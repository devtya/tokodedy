import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../database/app_database.dart';
import 'sync_helper.dart';
import '../../core/services/toko_service.dart';

/// FK field mapping: table → list of FK field names (camelCase)
const Map<String, List<String>> _tableFkFields = {
  'satuan_produk': ['produkId'],
  'item_transaksi': ['transaksiId', 'produkId'],
  'hutang_piutang': ['transaksiId'],
  'riwayat_stok': ['produkId'],
  'item_pembelian': ['pembelianId', 'produkId'],
  'pending_order_item': ['pendingOrderId', 'produkId'],
  'pending_pembelian': ['supplierId'],
  'pending_pembelian_item': ['pendingPembelianId', 'produkId'],
};

/// Resolve FK field → target table name
const Map<String, String> _fkTargetTable = {
  'produkId': 'produk',
  'transaksiId': 'transaksi',
  'pembelianId': 'pembelian',
  'pendingOrderId': 'pending_order',
  'supplierId': 'supplier',
  'pendingPembelianId': 'pending_pembelian',
};

/// Pull order: tables without FK dependencies first
const _pullOrder = [
  'produk',
  'transaksi',
  'pembelian',
  'pending_order',
  'supplier',
  'notifikasi',
  'user',
  'pending_pembelian',
  'satuan_produk',
  'item_transaksi',
  'hutang_piutang',
  'riwayat_stok',
  'item_pembelian',
  'pending_order_item',
  'pending_pembelian_item',
];

class SupabaseSyncService {
  final AppDatabase _db;
  final SyncHelper _syncHelper;
  final SupabaseClient _supabase;
  final SharedPreferences _prefs;
  final Uuid _uuid;
  final TokoService _tokoService;

  SupabaseSyncService({
    required AppDatabase db,
    required SyncHelper syncHelper,
    required SupabaseClient supabase,
    required SharedPreferences prefs,
    required TokoService tokoService,
  })  : _db = db,
        _syncHelper = syncHelper,
        _supabase = supabase,
        _prefs = prefs,
        _tokoService = tokoService,
        _uuid = const Uuid();

  int get _tokoId => _tokoService.tokoId ?? 1;

  // ───────────── PUSH ─────────────

  Future<List<String>> push({
    void Function(String table, int count)? onTablePushed,
  }) async {
    final deviceId = await _getDeviceId();
    final now = DateTime.now().millisecondsSinceEpoch;
    final pushedTables = <String>[];

    for (final entry in _tableReaders.entries) {
      final tableEntity = entry.key;
      final reader = entry.value;
      final fkFields = _tableFkFields[tableEntity] ?? [];
      final records = await reader(_db);

      int count = 0;
      for (final json in records) {
        final localId = json['id'] as int;
        final uuid = await _getOrCreateUuid(tableEntity, localId);

        for (final fkField in fkFields) {
          final fkValue = json[fkField];
          if (fkValue != null && fkValue is int) {
            final targetTable = _fkTargetTable[fkField]!;
            final targetUuid =
                await _resolveLocalIdToUuid(targetTable, fkValue);
            if (targetUuid != null) {
              json['_${fkField}_uuid'] = targetUuid;
            }
          }
        }

        json['_uuid'] = uuid;
        json['_table'] = tableEntity;
        json['_device_id'] = deviceId;
        json['_updated_at'] = now;
        json['_toko_id'] = _tokoId;

        await _supabase.from('records').upsert(
          {'uuid': uuid, 'data': jsonEncode(json), 'updated_at': now, 'toko_id': _tokoId},
          onConflict: 'uuid',
        );
        count++;
      }

      if (count > 0) {
        pushedTables.add(tableEntity);
        onTablePushed?.call(tableEntity, count);
      }
    }

    // Push deletes
    final deletedRecords = await (_db.select(_db.syncRecordTable)
      ..where((t) =>
          t.syncStatus.equals('pending') & t.isDeleted.equals(true)))
      .get();

    int deleteCount = 0;
    for (final record in deletedRecords) {
      final json = {
        '_uuid': record.uuid,
        '_table': record.tableEntity,
        '_device_id': deviceId,
        '_updated_at': now,
        '_deleted': true,
        '_toko_id': _tokoId,
      };
      await _supabase.from('records').upsert(
        {'uuid': record.uuid, 'data': jsonEncode(json), 'updated_at': now, 'toko_id': _tokoId},
        onConflict: 'uuid',
      );

      await _markSynced(record.uuid);
      deleteCount++;
    }

    if (deleteCount > 0) {
      onTablePushed?.call('hapus', deleteCount);
    }

    await _saveLastSyncTimestamp(now);
    return pushedTables;
  }

  // ───────────── INITIAL FULL SYNC ─────────────

  Future<bool> get isInitialSyncDone async {
    if (_prefs.getBool('initial_sync_done') == true) return true;
    final count = await _db.customSelect(
      'SELECT COUNT(*) as c FROM sync_record_table',
    ).getSingle();
    final c = count.data['c'] as int;
    return c > 0;
  }

  Future<void> performInitialSync({
    required void Function(int fetched, int total) onProgress,
  }) async {
    // 1. Count all records
    final countData = await _supabase.from('records').select('uuid').eq('toko_id', _tokoId);
    final total = (countData as List<dynamic>).length;
    onProgress(0, total);

    if (total == 0) {
      await _prefs.setBool('initial_sync_done', true);
      return;
    }

    // 2. Fetch data in paginated batches
    const batchSize = 500;
    final allData = <String, List<Map<String, dynamic>>>{};
    int fetched = 0;

    while (fetched < total) {
      final end = (fetched + batchSize - 1).clamp(0, total - 1);
      final response = await _supabase
          .from('records')
          .select('data')
          .eq('toko_id', _tokoId)
          .range(fetched, end)
          .order('uuid');

      for (final item in response as List<dynamic>) {
        final raw = jsonDecode(item['data'] as String) as Map<String, dynamic>;
        final table = raw['_table'] as String?;
        if (table == null) continue;
        allData.putIfAbsent(table, () => []).add(raw);
      }

      fetched = end + 1;
      onProgress(fetched, total);
    }

    // 3. Insert into Drift per table (dependency order)
    for (final tableEntity in _pullOrder) {
      final list = allData[tableEntity];
      if (list == null || list.isEmpty) continue;
      await _processPullTable(tableEntity, list);
    }

    // 4. Mark done
    await _prefs.setBool('initial_sync_done', true);
    await _saveLastSyncTimestamp(DateTime.now().millisecondsSinceEpoch);
  }

  // ───────────── PULL ─────────────

  Future<List<String>> pull({
    void Function(String table, int count)? onTablePulled,
  }) async {
    final lastSync = await _getLastSyncTimestamp();
    final pulledTables = <String>[];

    try {
      final response = await _supabase
          .from('records')
          .select('data, updated_at')
          .eq('toko_id', _tokoId)
          .gte('updated_at', lastSync)
          .order('updated_at');

      final grouped = <String, List<Map<String, dynamic>>>{};
      for (final item in response as List<dynamic>) {
        final data = jsonDecode(item['data'] as String) as Map<String, dynamic>;
        final table = data['_table'] as String?;
        if (table == null) continue;
        grouped.putIfAbsent(table, () => []).add(data);
      }

      for (final tableEntity in _pullOrder) {
        final list = grouped[tableEntity];
        if (list == null || list.isEmpty) continue;
        await _processPullTable(tableEntity, list);
        pulledTables.add(tableEntity);
        onTablePulled?.call(tableEntity, list.length);
      }

      await _saveLastSyncTimestamp(DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      // fallback: pull all if updated_at column not yet in schema cache
      final err = e.toString();
      if (err.contains('updated_at') && err.contains('Could not find the')) {
        final response = await _supabase.from('records').select('data').eq('toko_id', _tokoId);
        final grouped = <String, List<Map<String, dynamic>>>{};
        for (final item in response as List<dynamic>) {
          final data = jsonDecode(item['data'] as String) as Map<String, dynamic>;
          final table = data['_table'] as String?;
          if (table == null) continue;
          grouped.putIfAbsent(table, () => []).add(data);
        }
        for (final tableEntity in _pullOrder) {
          final list = grouped[tableEntity];
          if (list == null || list.isEmpty) continue;
          await _processPullTable(tableEntity, list);
          pulledTables.add(tableEntity);
          onTablePulled?.call(tableEntity, list.length);
        }
        await _saveLastSyncTimestamp(DateTime.now().millisecondsSinceEpoch);
      } else {
        rethrow;
      }
    }

    return pulledTables;
  }

  Future<void> _processPullTable(
    String tableEntity,
    List<Map<String, dynamic>> rows,
  ) async {
    for (final data in rows) {
      final remoteUuid = data['_uuid'] as String?;
      if (remoteUuid == null) continue;

      if (data['_deleted'] == true) {
        final sr = await _findByUuid(remoteUuid);
        if (sr != null) {
          final deleter = _tableDeleters[tableEntity];
          if (deleter != null) await deleter(_db, sr.localId);
          await (_db.delete(_db.syncRecordTable)
            ..where((t) => t.uuid.equals(remoteUuid)))
            .go();
        }
        continue;
      }

      final existing = await _findByUuid(remoteUuid);
      if (existing != null) {
        final updater = _tableUpdaters[tableEntity];
        if (updater != null) {
          _resolveFkUuids(tableEntity, data);
          await updater(_db, existing.localId, data);
        }
      } else {
        final inserter = _tableInserters[tableEntity];
        if (inserter != null) {
          _resolveFkUuids(tableEntity, data);
          final newId = await inserter(_db, data);
          await _syncHelper.onInsert(tableEntity: tableEntity, localId: newId);
          await (_db.update(_db.syncRecordTable)
            ..where((t) =>
                t.tableEntity.equals(tableEntity) & t.localId.equals(newId)))
            .write(SyncRecordTableCompanion(
              uuid: Value(remoteUuid),
              syncStatus: Value('synced'),
            ));
        }
      }
    }
  }

  void _resolveFkUuids(String tableEntity, Map<String, dynamic> data) {
    final fkFields = _tableFkFields[tableEntity] ?? [];
    for (final fkField in fkFields) {
      final fkUuidKey = '_${fkField}_uuid';
      final fkUuid = data[fkUuidKey];
      if (fkUuid != null && fkUuid is String) {
        // resolved during pull — local id will be injected by the caller
      }
    }
  }

  // ───────── UUID HELPERS ─────────

  Future<String> _getOrCreateUuid(String tableEntity, int localId) async {
    final existing = await (_db.select(_db.syncRecordTable)
      ..where((t) =>
          t.tableEntity.equals(tableEntity) & t.localId.equals(localId)))
      .getSingleOrNull();
    if (existing != null) return existing.uuid;

    final uuid = _uuid.v4();
    await _syncHelper.onInsert(
      tableEntity: tableEntity,
      localId: localId,
      tokoId: _tokoId,
    );
    await (_db.update(_db.syncRecordTable)
      ..where((t) =>
          t.tableEntity.equals(tableEntity) & t.localId.equals(localId)))
      .write(SyncRecordTableCompanion(
        uuid: Value(uuid),
        syncStatus: Value('synced'),
      ));
    return uuid;
  }

  Future<String?> _resolveLocalIdToUuid(
    String tableEntity,
    int localId,
  ) async {
    final record = await (_db.select(_db.syncRecordTable)
      ..where((t) =>
          t.tableEntity.equals(tableEntity) & t.localId.equals(localId)))
      .getSingleOrNull();
    return record?.uuid;
  }

  Future<SyncRecordTableData?> _findByUuid(String uuid) async {
    return await (_db.select(_db.syncRecordTable)
      ..where((t) => t.uuid.equals(uuid)))
      .getSingleOrNull();
  }

  Future<void> _markSynced(String uuid) async {
    await (_db.update(_db.syncRecordTable)
      ..where((t) => t.uuid.equals(uuid)))
      .write(const SyncRecordTableCompanion(
        syncStatus: Value('synced'),
      ));
  }

  // ───────── DEVICE / SYNC META ─────────

  Future<String> _getDeviceId() async {
    var id = _prefs.getString('device_id');
    if (id == null) {
      id = _uuid.v4();
      await _prefs.setString('device_id', id);
    }
    return id;
  }

  Future<int> _getLastSyncTimestamp() async {
    return _prefs.getInt('last_sync_timestamp') ?? 0;
  }

  Future<void> _saveLastSyncTimestamp(int ts) async {
    await _prefs.setInt('last_sync_timestamp', ts);
  }
}

// ───────── TABLE-SPECIFIC READERS ─────────

typedef _TableReader = Future<List<Map<String, dynamic>>> Function(
    AppDatabase);

final Map<String, _TableReader> _tableReaders = {
  'produk': (db) async {
    final rows = await db.select(db.produkTable).get();
    return rows.map((r) => r.toJson()).toList();
  },
  'satuan_produk': (db) async {
    final rows = await db.select(db.satuanProdukTable).get();
    return rows.map((r) => r.toJson()).toList();
  },
  'transaksi': (db) async {
    final rows = await db.select(db.transaksiTable).get();
    return rows.map((r) => r.toJson()).toList();
  },
  'item_transaksi': (db) async {
    final rows = await db.select(db.itemTransaksiTable).get();
    return rows.map((r) => r.toJson()).toList();
  },
  'hutang_piutang': (db) async {
    final rows = await db.select(db.hutangPiutangTable).get();
    return rows.map((r) => r.toJson()).toList();
  },
  'riwayat_stok': (db) async {
    final rows = await db.select(db.riwayatStokTable).get();
    return rows.map((r) => r.toJson()).toList();
  },
  'pembelian': (db) async {
    final rows = await db.select(db.pembelianTable).get();
    return rows.map((r) => r.toJson()).toList();
  },
  'item_pembelian': (db) async {
    final rows = await db.select(db.itemPembelianTable).get();
    return rows.map((r) => r.toJson()).toList();
  },
  'pending_order': (db) async {
    final rows = await db.select(db.pendingOrderTable).get();
    return rows.map((r) => r.toJson()).toList();
  },
  'pending_order_item': (db) async {
    final rows = await db.select(db.pendingOrderItemTable).get();
    return rows.map((r) => r.toJson()).toList();
  },
  'pending_pembelian': (db) async {
    final rows = await db.select(db.pendingPembelianTable).get();
    return rows.map((r) => r.toJson()).toList();
  },
  'pending_pembelian_item': (db) async {
    final rows = await db.select(db.pendingPembelianItemTable).get();
    return rows.map((r) => r.toJson()).toList();
  },
  'supplier': (db) async {
    final rows = await db.select(db.supplierTable).get();
    return rows.map((r) => r.toJson()).toList();
  },
  'notifikasi': (db) async {
    final rows = await db.select(db.notifikasiTable).get();
    return rows.map((r) => r.toJson()).toList();
  },
  'user': (db) async {
    final rows = await db.select(db.userTable).get();
    return rows.map((r) => r.toJson()).toList();
  },
};

// ───────── TABLE-SPECIFIC INSERTERS ─────────

typedef _TableInserter = Future<int> Function(AppDatabase, Map<String, dynamic> json);
typedef _TableUpdater = Future<void> Function(AppDatabase, int localId, Map<String, dynamic> json);
typedef _TableDeleter = Future<void> Function(AppDatabase, int localId);

final Map<String, _TableInserter> _tableInserters = {
  'produk': (db, json) async {
    return db.into(db.produkTable).insert(ProdukTableCompanion(
      nama: Value(json['nama'] as String),
      barcode: Value(json['barcode'] as String?),
      hargaBeli: Value((json['hargaBeli'] as num).toDouble()),
      hargaJual: Value((json['hargaJual'] as num).toDouble()),
      stok: Value(json['stok'] as int? ?? 0),
      kategori: Value(json['kategori'] as String?),
      satuan: Value(json['satuan'] as String? ?? 'pcs'),
    ));
  },
  'satuan_produk': (db, json) async {
    final fkId = await _resolveFkJson('produkId', json, db);
    return db.into(db.satuanProdukTable).insert(SatuanProdukTableCompanion(
      produkId: Value(fkId ?? json['produkId'] as int),
      nama: Value(json['nama'] as String),
      konversi: Value((json['konversi'] as num).toDouble()),
      hargaBeli: Value((json['hargaBeli'] as num).toDouble()),
      hargaJual: Value((json['hargaJual'] as num).toDouble()),
    ));
  },
  'transaksi': (db, json) async {
    return db.into(db.transaksiTable).insert(TransaksiTableCompanion(
      totalHarga: Value((json['totalHarga'] as num).toDouble()),
      jumlahBayar: Value((json['jumlahBayar'] as num).toDouble()),
      kembalian: Value((json['kembalian'] as num).toDouble()),
      status: Value(json['status'] as String? ?? 'lunas'),
      pelangganId: Value(json['pelangganId'] as int?),
    ));
  },
  'item_transaksi': (db, json) async {
    final transId = await _resolveFkJson('transaksiId', json, db);
    final prodId = await _resolveFkJson('produkId', json, db);
    return db.into(db.itemTransaksiTable).insert(ItemTransaksiTableCompanion(
      transaksiId: Value(transId ?? json['transaksiId'] as int),
      produkId: Value(prodId ?? json['produkId'] as int),
      jumlah: Value(json['jumlah'] as int),
      hargaSatuan: Value((json['hargaSatuan'] as num).toDouble()),
      subtotal: Value((json['subtotal'] as num).toDouble()),
    ));
  },
  'hutang_piutang': (db, json) async {
    final transId = await _resolveFkJson('transaksiId', json, db);
    return db.into(db.hutangPiutangTable).insert(HutangPiutangTableCompanion(
      transaksiId: Value(transId ?? json['transaksiId'] as int?),
      namaPelanggan: Value(json['namaPelanggan'] as String),
      jumlah: Value((json['jumlah'] as num).toDouble()),
      status: Value(json['status'] as String? ?? 'belum_lunas'),
      tanggalJatuhTempo: Value(
        json['tanggalJatuhTempo'] != null
            ? DateTime.parse(json['tanggalJatuhTempo'] as String)
            : null,
      ),
    ));
  },
  'riwayat_stok': (db, json) async {
    final prodId = await _resolveFkJson('produkId', json, db);
    return db.into(db.riwayatStokTable).insert(RiwayatStokTableCompanion(
      produkId: Value(prodId ?? json['produkId'] as int),
      tipe: Value(json['tipe'] as String),
      jumlah: Value(json['jumlah'] as int),
      keterangan: Value(json['keterangan'] as String?),
    ));
  },
  'pembelian': (db, json) async {
    return db.into(db.pembelianTable).insert(PembelianTableCompanion(
      namaSupplier: Value(json['namaSupplier'] as String),
      totalHarga: Value((json['totalHarga'] as num).toDouble()),
    ));
  },
  'item_pembelian': (db, json) async {
    final pembId = await _resolveFkJson('pembelianId', json, db);
    final prodId = await _resolveFkJson('produkId', json, db);
    return db.into(db.itemPembelianTable).insert(ItemPembelianTableCompanion(
      pembelianId: Value(pembId ?? json['pembelianId'] as int),
      produkId: Value(prodId ?? json['produkId'] as int),
      jumlah: Value(json['jumlah'] as int),
      hargaBeliSatuan: Value((json['hargaBeliSatuan'] as num).toDouble()),
      subtotal: Value((json['subtotal'] as num).toDouble()),
    ));
  },
  'pending_order': (db, json) async {
    return db.into(db.pendingOrderTable).insert(PendingOrderTableCompanion(
      namaPelanggan: Value(json['namaPelanggan'] as String),
      catatan: Value(json['catatan'] as String?),
    ));
  },
  'pending_order_item': (db, json) async {
    final poId = await _resolveFkJson('pendingOrderId', json, db);
    final prodId = await _resolveFkJson('produkId', json, db);
    return db.into(db.pendingOrderItemTable).insert(
        PendingOrderItemTableCompanion(
      pendingOrderId: Value(poId ?? json['pendingOrderId'] as int),
      produkId: Value(prodId ?? json['produkId'] as int),
      namaProduk: Value(json['namaProduk'] as String),
      hargaJual: Value((json['hargaJual'] as num).toDouble()),
      jumlah: Value(json['jumlah'] as int),
      diskonTipe: Value(json['diskonTipe'] as int? ?? 0),
      diskonValue: Value((json['diskonValue'] as num).toDouble()),
      subtotal: Value((json['subtotal'] as num).toDouble()),
    ));
  },
  'pending_pembelian': (db, json) async {
    final suppId = await _resolveFkJson('supplierId', json, db);
    return db.into(db.pendingPembelianTable).insert(
        PendingPembelianTableCompanion(
      supplierId: Value(suppId ?? json['supplierId'] as int?),
      namaSupplier: Value(json['namaSupplier'] as String?),
      isPpnEnabled: Value(json['isPpnEnabled'] as bool? ?? false),
      ppnPercent: Value((json['ppnPercent'] as num?)?.toDouble() ?? 11.0),
    ));
  },
  'pending_pembelian_item': (db, json) async {
    final ppId = await _resolveFkJson('pendingPembelianId', json, db);
    final prodId = await _resolveFkJson('produkId', json, db);
    return db.into(db.pendingPembelianItemTable).insert(
        PendingPembelianItemTableCompanion(
      pendingPembelianId: Value(ppId ?? json['pendingPembelianId'] as int),
      produkId: Value(prodId ?? json['produkId'] as int),
      namaProduk: Value(json['namaProduk'] as String),
      jumlah: Value(json['jumlah'] as int),
      hargaBeliSatuan: Value((json['hargaBeliSatuan'] as num).toDouble()),
      hargaBeliLama: Value((json['hargaBeliLama'] as num).toDouble()),
      diskonTipe: Value(json['diskonTipe'] as int? ?? 0),
      diskonValue: Value((json['diskonValue'] as num).toDouble()),
    ));
  },
  'supplier': (db, json) async {
    return db.into(db.supplierTable).insert(SupplierTableCompanion(
      nama: Value(json['nama'] as String),
      telepon: Value(json['telepon'] as String?),
      alamat: Value(json['alamat'] as String?),
    ));
  },
  'notifikasi': (db, json) async {
    return db.into(db.notifikasiTable).insert(NotifikasiTableCompanion(
      judul: Value(json['judul'] as String),
      pesan: Value(json['pesan'] as String),
      tipe: Value(json['tipe'] as String? ?? 'INFO'),
      isRead: Value(json['isRead'] as bool? ?? false),
    ));
  },
  'user': (db, json) async {
    return db.into(db.userTable).insert(UserTableCompanion(
      username: Value(json['username'] as String),
      password: Value(json['password'] as String),
      role: Value(json['role'] as String),
    ));
  },
};

final Map<String, _TableUpdater> _tableUpdaters = {
  'produk': (db, id, json) async {
    await (db.update(db.produkTable)..where((t) => t.id.equals(id))).write(
      ProdukTableCompanion(
        nama: Value(json['nama'] as String),
        barcode: Value(json['barcode'] as String?),
        hargaBeli: Value((json['hargaBeli'] as num).toDouble()),
        hargaJual: Value((json['hargaJual'] as num).toDouble()),
        stok: Value(json['stok'] as int? ?? 0),
        kategori: Value(json['kategori'] as String?),
        satuan: Value(json['satuan'] as String? ?? 'pcs'),
      ),
    );
  },
  'satuan_produk': (db, id, json) async {
    final fkId = await _resolveFkJson('produkId', json, db);
    await (db.update(db.satuanProdukTable)..where((t) => t.id.equals(id)))
        .write(SatuanProdukTableCompanion(
      produkId: Value(fkId ?? json['produkId'] as int),
      nama: Value(json['nama'] as String),
      konversi: Value((json['konversi'] as num).toDouble()),
      hargaBeli: Value((json['hargaBeli'] as num).toDouble()),
      hargaJual: Value((json['hargaJual'] as num).toDouble()),
    ));
  },
  'transaksi': (db, id, json) async {
    await (db.update(db.transaksiTable)..where((t) => t.id.equals(id)))
        .write(TransaksiTableCompanion(
      totalHarga: Value((json['totalHarga'] as num).toDouble()),
      jumlahBayar: Value((json['jumlahBayar'] as num).toDouble()),
      kembalian: Value((json['kembalian'] as num).toDouble()),
      status: Value(json['status'] as String? ?? 'lunas'),
      pelangganId: Value(json['pelangganId'] as int?),
    ));
  },
  'supplier': (db, id, json) async {
    await (db.update(db.supplierTable)..where((t) => t.id.equals(id)))
        .write(SupplierTableCompanion(
      nama: Value(json['nama'] as String),
      telepon: Value(json['telepon'] as String?),
      alamat: Value(json['alamat'] as String?),
    ));
  },
  'user': (db, id, json) async {
    await (db.update(db.userTable)..where((t) => t.id.equals(id)))
        .write(UserTableCompanion(
      username: Value(json['username'] as String),
      password: Value(json['password'] as String),
      role: Value(json['role'] as String),
    ));
  },
  'notifikasi': (db, id, json) async {
    await (db.update(db.notifikasiTable)..where((t) => t.id.equals(id)))
        .write(NotifikasiTableCompanion(
      isRead: Value(json['isRead'] as bool? ?? false),
    ));
  },
  'pending_order': (db, id, json) async {
    await (db.update(db.pendingOrderTable)..where((t) => t.id.equals(id)))
        .write(PendingOrderTableCompanion(
      namaPelanggan: Value(json['namaPelanggan'] as String),
      catatan: Value(json['catatan'] as String?),
    ));
  },
  'pending_pembelian': (db, id, json) async {
    final suppId = await _resolveFkJson('supplierId', json, db);
    await (db.update(db.pendingPembelianTable)..where((t) => t.id.equals(id)))
        .write(PendingPembelianTableCompanion(
      supplierId: Value(suppId ?? json['supplierId'] as int?),
      namaSupplier: Value(json['namaSupplier'] as String?),
      isPpnEnabled: Value(json['isPpnEnabled'] as bool? ?? false),
      ppnPercent: Value((json['ppnPercent'] as num?)?.toDouble() ?? 11.0),
    ));
  },
  'pembelian': (db, id, json) async {
    await (db.update(db.pembelianTable)..where((t) => t.id.equals(id)))
        .write(PembelianTableCompanion(
      namaSupplier: Value(json['namaSupplier'] as String),
      totalHarga: Value((json['totalHarga'] as num).toDouble()),
    ));
  },
};

final Map<String, _TableDeleter> _tableDeleters = {
  'produk': (db, id) async {
    await (db.delete(db.produkTable)..where((t) => t.id.equals(id))).go();
  },
  'satuan_produk': (db, id) async {
    await (db.delete(db.satuanProdukTable)..where((t) => t.id.equals(id))).go();
  },
  'transaksi': (db, id) async {
    await (db.delete(db.transaksiTable)..where((t) => t.id.equals(id))).go();
  },
  'item_transaksi': (db, id) async {
    await (db.delete(db.itemTransaksiTable)..where((t) => t.id.equals(id))).go();
  },
  'hutang_piutang': (db, id) async {
    await (db.delete(db.hutangPiutangTable)..where((t) => t.id.equals(id))).go();
  },
  'riwayat_stok': (db, id) async {
    await (db.delete(db.riwayatStokTable)..where((t) => t.id.equals(id))).go();
  },
  'pembelian': (db, id) async {
    await (db.delete(db.pembelianTable)..where((t) => t.id.equals(id))).go();
  },
  'item_pembelian': (db, id) async {
    await (db.delete(db.itemPembelianTable)..where((t) => t.id.equals(id))).go();
  },
  'pending_order': (db, id) async {
    await (db.delete(db.pendingOrderTable)..where((t) => t.id.equals(id))).go();
  },
  'pending_order_item': (db, id) async {
    await (db.delete(db.pendingOrderItemTable)..where((t) => t.id.equals(id))).go();
  },
  'pending_pembelian': (db, id) async {
    await (db.delete(db.pendingPembelianTable)..where((t) => t.id.equals(id))).go();
  },
  'pending_pembelian_item': (db, id) async {
    await (db.delete(db.pendingPembelianItemTable)..where((t) => t.id.equals(id))).go();
  },
  'supplier': (db, id) async {
    await (db.delete(db.supplierTable)..where((t) => t.id.equals(id))).go();
  },
  'notifikasi': (db, id) async {
    await (db.delete(db.notifikasiTable)..where((t) => t.id.equals(id))).go();
  },
  'user': (db, id) async {
    await (db.delete(db.userTable)..where((t) => t.id.equals(id))).go();
  },
};

Future<int?> _resolveFkJson(
  String fkField,
  Map<String, dynamic> json,
  AppDatabase db,
) async {
  final fkUuidKey = '_${fkField}_uuid';
  final fkUuid = json[fkUuidKey];
  if (fkUuid == null || fkUuid is! String) return null;

  final targetTable = _fkTargetTable[fkField]!;
  final record = await (db.select(db.syncRecordTable)
    ..where((t) => t.uuid.equals(fkUuid) & t.tableEntity.equals(targetTable)))
    .getSingleOrNull();
  return record?.localId;
}
