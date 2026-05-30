import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../database/app_database.dart';
import '../../core/services/toko_service.dart';

import 'package:injectable/injectable.dart';

/// Sync service baru — direct upsert per-tabel ke Supabase.
/// Tidak ada lagi blob JSON atau sync_record_table.
/// Strategi:
///   - Write: tulis ke Drift lokal dulu, lalu upsert ke Supabase.
///     Jika offline → antri di pending_sync_queue_table.
///   - Read: pull dari Supabase berdasarkan updated_at > lastSync.
///   - Conflict: last-write-wins via updated_at.
@lazySingleton
class SupabaseSyncService {
  final AppDatabase _db;
  final SupabaseClient _supabase;
  final SharedPreferences _prefs;
  final TokoService _tokoService;
  final Uuid _uuid = const Uuid();

  static const _lastSyncKey = 'last_sync_v2';

  SupabaseSyncService({
    required AppDatabase db,
    required SupabaseClient supabase,
    required SharedPreferences prefs,
    required TokoService tokoService,
  })  : _db = db,
        _supabase = supabase,
        _prefs = prefs,
        _tokoService = tokoService;

  String get _tokoId => _tokoService.tokoId ?? '';

  // ─────────────────────────────────────────────────
  // PUBLIC API
  // ─────────────────────────────────────────────────

  /// Generate UUID baru untuk record yang akan dibuat
  String generateId() => _uuid.v4();

  /// Cek apakah ada koneksi internet
  Future<bool> get isOnline async {
    final result = await Connectivity().checkConnectivity();
    return !result.contains(ConnectivityResult.none) && result.isNotEmpty;
  }

  /// Push: upsert record ke Supabase atau antri jika offline
  Future<void> upsert(String tableName, Map<String, dynamic> data) async {
    // Pastikan toko_id selalu ada
    data['toko_id'] = _tokoId;

    // Inject timestamp agar proses pull() di device lain bisa mendeteksi perubahan
    final now = DateTime.now().toUtc().toIso8601String();
    if (_pullOrder.contains(tableName)) {
      data['updated_at'] = now;
    } else if (_appendOnlyTables.contains(tableName)) {
      data['created_at'] ??= now;
    }

    if (await isOnline) {
      try {
        await _supabase.from(tableName).upsert(data, onConflict: 'id');
        return;
      } catch (e) {
        // Jika gagal, antri
      }
    }
    // Offline → antri
    await _enqueue(tableName, 'upsert', data['id'] as String, data);
  }

  /// Delete: hapus record dari Supabase atau antri jika offline
  Future<void> delete(String tableName, String id) async {
    if (await isOnline) {
      try {
        await _supabase.from(tableName).delete().eq('id', id);
        return;
      } catch (e) {
        // Jika gagal, antri
      }
    }
    // Offline → antri
    await _enqueue(tableName, 'delete', id, {'id': id});
  }

  /// Pull: download perubahan dari Supabase sejak lastSync
  Future<List<String>> pull({
    void Function(String table, int count)? onTablePulled,
  }) async {
    if (_tokoId.isEmpty) return [];
    final lastSync = _prefs.getString(_lastSyncKey) ?? '1970-01-01T00:00:00Z';
    final pulledTables = <String>[];

    for (final table in _pullOrder) {
      try {
        final rows = await _supabase
            .from(table)
            .select()
            .eq('toko_id', _tokoId)
            .gte('updated_at', lastSync)
            .order('updated_at');

        if ((rows as List).isEmpty) continue;

        await _applyPulledRows(table, rows.cast<Map<String, dynamic>>());
        pulledTables.add(table);
        onTablePulled?.call(table, rows.length);
      } catch (_) {
        // Skip tabel yang error (mungkin belum punya updated_at)
      }
    }

    // Pull tabel tanpa updated_at (append-only)
    for (final table in _appendOnlyTables) {
      try {
        final rows = await _supabase
            .from(table)
            .select()
            .eq('toko_id', _tokoId)
            .gte('created_at', lastSync)
            .order('created_at');

        if ((rows as List).isEmpty) continue;
        await _applyPulledRows(table, rows.cast<Map<String, dynamic>>());
        pulledTables.add(table);
        onTablePulled?.call(table, rows.length);
      } catch (_) {}
    }

    await _prefs.setString(_lastSyncKey, DateTime.now().toIso8601String());
    return pulledTables;
  }

  /// Full sync: download semua data toko dari Supabase (untuk install baru)
  Future<void> performInitialSync({
    required void Function(int fetched, int total) onProgress,
  }) async {
    if (_tokoId.isEmpty) return;

    const allTables = [
      ...(_pullOrder),
      ...(_appendOnlyTables),
    ];

    int total = allTables.length;
    int done = 0;
    onProgress(0, total);

    for (final table in allTables) {
      try {
        final rows = await _supabase
            .from(table)
            .select()
            .eq('toko_id', _tokoId)
            .order('created_at');

        if ((rows as List).isNotEmpty) {
          await _applyPulledRows(table, rows.cast<Map<String, dynamic>>());
        }
      } catch (_) {}

      done++;
      onProgress(done, total);
    }

    // Juga pull profiles (tidak punya toko_id tapi punya toko_id FK)
    try {
      final profiles = await _supabase
          .from('profiles')
          .select()
          .eq('toko_id', _tokoId);
      for (final p in profiles as List) {
        await _db.into(_db.userTable).insertOnConflictUpdate(UserTableCompanion(
          id: Value(p['id'] as String),
          tokoId: Value(p['toko_id'] as String),
          nama: Value(p['nama'] as String?),
          role: Value(p['role'] as String? ?? 'kasir'),
        ));
      }
    } catch (_) {}

    await _prefs.setString(_lastSyncKey, DateTime.now().toIso8601String());
    await _prefs.setBool('initial_sync_done_v2', true);
  }

  Future<bool> get isInitialSyncDone async {
    return _prefs.getBool('initial_sync_done_v2') == true;
  }

  /// Flush antrian operasi yang belum berhasil di-sync
  Future<int> flushQueue() async {
    if (!(await isOnline)) return 0;
    if (_tokoId.isEmpty) return 0;

    final queue = await _db.select(_db.pendingSyncQueueTable).get();
    int flushed = 0;

    for (final item in queue) {
      try {
        final payload = jsonDecode(item.payload) as Map<String, dynamic>;
        if (item.operation == 'upsert') {
          await _supabase.from(item.targetTable).upsert(payload, onConflict: 'id');
        } else if (item.operation == 'delete') {
          await _supabase.from(item.targetTable).delete().eq('id', item.recordId);
        }
        // Hapus dari queue setelah berhasil
        await (_db.delete(_db.pendingSyncQueueTable)
          ..where((t) => t.id.equals(item.id)))
            .go();
        flushed++;
      } catch (_) {
        // Biarkan di queue untuk retry berikutnya
      }
    }

    return flushed;
  }

  // ─────────────────────────────────────────────────
  // PRIVATE HELPERS
  // ─────────────────────────────────────────────────

  Future<void> _enqueue(
    String tableName,
    String operation,
    String recordId,
    Map<String, dynamic> payload,
  ) async {
    await _db.into(_db.pendingSyncQueueTable).insert(
      PendingSyncQueueTableCompanion(
        targetTable: Value(tableName),
        operation: Value(operation),
        recordId: Value(recordId),
        payload: Value(jsonEncode(payload)),
      ),
    );
  }

  Future<void> _applyPulledRows(
    String table,
    List<Map<String, dynamic>> rows,
  ) async {
    for (final row in rows) {
      await _inserters[table]?.call(_db, row);
    }
  }
}

// ─────────────────────────────────────────────────
// PULL ORDER (dependency order — parent sebelum child)
// ─────────────────────────────────────────────────

const _pullOrder = [
  'produk',
  'satuan_produk',
  'supplier',
  'supplier_products',
  'transaksi',
  'hutang_piutang',
  'pembelian',
  'pending_order',
  'pending_pembelian',
];

const _appendOnlyTables = [
  'item_transaksi',
  'item_pembelian',
  'riwayat_stok',
  'notifikasi',
  'pending_order_item',
  'pending_pembelian_item',
];

// ─────────────────────────────────────────────────
// INSERTERS — Supabase JSON → Drift local table
// ─────────────────────────────────────────────────

typedef _Inserter = Future<void> Function(AppDatabase db, Map<String, dynamic> row);

final Map<String, _Inserter> _inserters = {
  'produk': (db, r) async {
    await db.into(db.produkTable).insertOnConflictUpdate(ProdukTableCompanion(
      id: Value(r['id'] as String),
      tokoId: Value(r['toko_id'] as String),
      nama: Value(r['nama'] as String),
      barcode: Value(r['barcode'] as String?),
      hargaBeli: Value((r['harga_beli'] as num).toDouble()),
      hargaJual: Value((r['harga_jual'] as num).toDouble()),
      stok: Value(r['stok'] as int? ?? 0),
      stokMinimum: Value(r['stok_minimum'] as int?),
      kategori: Value(r['kategori'] as String?),
      satuan: Value(r['satuan'] as String? ?? 'pcs'),
      updatedAt: Value(_parseDate(r['updated_at'])),
      createdAt: Value(_parseDate(r['created_at'])),
    ));
  },
  'satuan_produk': (db, r) async {
    await db.into(db.satuanProdukTable).insertOnConflictUpdate(SatuanProdukTableCompanion(
      id: Value(r['id'] as String),
      tokoId: Value(r['toko_id'] as String),
      produkId: Value(r['produk_id'] as String),
      nama: Value(r['nama'] as String),
      konversi: Value((r['konversi'] as num).toDouble()),
      hargaBeli: Value((r['harga_beli'] as num).toDouble()),
      hargaJual: Value((r['harga_jual'] as num).toDouble()),
      updatedAt: Value(_parseDate(r['updated_at'])),
    ));
  },
  'supplier': (db, r) async {
    await db.into(db.supplierTable).insertOnConflictUpdate(SupplierTableCompanion(
      id: Value(r['id'] as String),
      tokoId: Value(r['toko_id'] as String),
      nama: Value(r['nama'] as String),
      telepon: Value(r['telepon'] as String?),
      alamat: Value(r['alamat'] as String?),
      updatedAt: Value(_parseDate(r['updated_at'])),
      createdAt: Value(_parseDate(r['created_at'])),
    ));
  },
  'supplier_products': (db, r) async {
    await db.into(db.supplierProductsTable).insertOnConflictUpdate(SupplierProductsTableCompanion(
      id: Value(r['id'] as String),
      tokoId: Value(r['toko_id'] as String),
      supplierId: Value(r['supplier_id'] as String),
      produkId: Value(r['produk_id'] as String),
      harga: Value((r['harga'] as num).toDouble()),
      updatedAt: Value(_parseDate(r['updated_at'])),
    ));
  },
  'transaksi': (db, r) async {
    await db.into(db.transaksiTable).insertOnConflictUpdate(TransaksiTableCompanion(
      id: Value(r['id'] as String),
      tokoId: Value(r['toko_id'] as String),
      kasirId: Value(r['kasir_id'] as String?),
      totalHarga: Value((r['total_harga'] as num).toDouble()),
      jumlahBayar: Value((r['jumlah_bayar'] as num).toDouble()),
      kembalian: Value((r['kembalian'] as num).toDouble()),
      status: Value(r['status'] as String? ?? 'lunas'),
      updatedAt: Value(_parseDate(r['updated_at'])),
      createdAt: Value(_parseDate(r['created_at'])),
    ));
  },
  'item_transaksi': (db, r) async {
    await db.into(db.itemTransaksiTable).insertOnConflictUpdate(ItemTransaksiTableCompanion(
      id: Value(r['id'] as String),
      tokoId: Value(r['toko_id'] as String),
      transaksiId: Value(r['transaksi_id'] as String),
      produkId: Value(r['produk_id'] as String),
      jumlah: Value(r['jumlah'] as int),
      hargaSatuan: Value((r['harga_satuan'] as num).toDouble()),
      subtotal: Value((r['subtotal'] as num).toDouble()),
    ));
  },
  'hutang_piutang': (db, r) async {
    await db.into(db.hutangPiutangTable).insertOnConflictUpdate(HutangPiutangTableCompanion(
      id: Value(r['id'] as String),
      tokoId: Value(r['toko_id'] as String),
      transaksiId: Value(r['transaksi_id'] as String?),
      namaPelanggan: Value(r['nama_pelanggan'] as String),
      jumlah: Value((r['jumlah'] as num).toDouble()),
      status: Value(r['status'] as String? ?? 'belum_lunas'),
      tanggalJatuhTempo: Value(r['tanggal_jatuh_tempo'] != null
          ? DateTime.tryParse(r['tanggal_jatuh_tempo'] as String)
          : null),
      updatedAt: Value(_parseDate(r['updated_at'])),
      createdAt: Value(_parseDate(r['created_at'])),
    ));
  },
  'pembelian': (db, r) async {
    await db.into(db.pembelianTable).insertOnConflictUpdate(PembelianTableCompanion(
      id: Value(r['id'] as String),
      tokoId: Value(r['toko_id'] as String),
      supplierId: Value(r['supplier_id'] as String?),
      namaSupplier: Value(r['nama_supplier'] as String?),
      totalHarga: Value((r['total_harga'] as num).toDouble()),
      updatedAt: Value(_parseDate(r['updated_at'])),
      createdAt: Value(_parseDate(r['created_at'])),
    ));
  },
  'item_pembelian': (db, r) async {
    await db.into(db.itemPembelianTable).insertOnConflictUpdate(ItemPembelianTableCompanion(
      id: Value(r['id'] as String),
      tokoId: Value(r['toko_id'] as String),
      pembelianId: Value(r['pembelian_id'] as String),
      produkId: Value(r['produk_id'] as String),
      jumlah: Value(r['jumlah'] as int),
      hargaBeliSatuan: Value((r['harga_beli_satuan'] as num).toDouble()),
      subtotal: Value((r['subtotal'] as num).toDouble()),
      satuanId: Value(r['satuan_id'] as String?),
      konversi: Value((r['konversi'] as num? ?? 1.0).toDouble()),
    ));
  },
  'riwayat_stok': (db, r) async {
    await db.into(db.riwayatStokTable).insertOnConflictUpdate(RiwayatStokTableCompanion(
      id: Value(r['id'] as String),
      tokoId: Value(r['toko_id'] as String),
      produkId: Value(r['produk_id'] as String),
      tipe: Value(r['tipe'] as String),
      jumlah: Value(r['jumlah'] as int),
      keterangan: Value(r['keterangan'] as String?),
      createdAt: Value(_parseDate(r['created_at'])),
    ));
  },
  'notifikasi': (db, r) async {
    await db.into(db.notifikasiTable).insertOnConflictUpdate(NotifikasiTableCompanion(
      id: Value(r['id'] as String),
      tokoId: Value(r['toko_id'] as String),
      judul: Value(r['judul'] as String),
      pesan: Value(r['pesan'] as String),
      tipe: Value(r['tipe'] as String? ?? 'INFO'),
      isRead: Value(r['is_read'] as bool? ?? false),
      createdAt: Value(_parseDate(r['created_at'])),
    ));
  },
  'pending_order': (db, r) async {
    await db.into(db.pendingOrderTable).insertOnConflictUpdate(PendingOrderTableCompanion(
      id: Value(r['id'] as String),
      tokoId: Value(r['toko_id'] as String),
      namaPelanggan: Value(r['nama_pelanggan'] as String),
      catatan: Value(r['catatan'] as String?),
      createdAt: Value(_parseDate(r['created_at'])),
    ));
  },
  'pending_order_item': (db, r) async {
    await db.into(db.pendingOrderItemTable).insertOnConflictUpdate(PendingOrderItemTableCompanion(
      id: Value(r['id'] as String),
      tokoId: Value(r['toko_id'] as String),
      pendingOrderId: Value(r['pending_order_id'] as String),
      produkId: Value(r['produk_id'] as String),
      namaProduk: Value(r['nama_produk'] as String),
      hargaJual: Value((r['harga_jual'] as num).toDouble()),
      jumlah: Value(r['jumlah'] as int),
      diskonTipe: Value(r['diskon_tipe'] as int? ?? 0),
      diskonValue: Value((r['diskon_value'] as num? ?? 0).toDouble()),
      subtotal: Value((r['subtotal'] as num).toDouble()),
    ));
  },
  'pending_pembelian': (db, r) async {
    await db.into(db.pendingPembelianTable).insertOnConflictUpdate(PendingPembelianTableCompanion(
      id: Value(r['id'] as String),
      tokoId: Value(r['toko_id'] as String),
      supplierId: Value(r['supplier_id'] as String?),
      namaSupplier: Value(r['nama_supplier'] as String?),
      isPpnEnabled: Value(r['is_ppn_enabled'] as bool? ?? false),
      ppnPercent: Value((r['ppn_percent'] as num? ?? 11.0).toDouble()),
      createdAt: Value(_parseDate(r['created_at'])),
    ));
  },
  'pending_pembelian_item': (db, r) async {
    await db.into(db.pendingPembelianItemTable).insertOnConflictUpdate(PendingPembelianItemTableCompanion(
      id: Value(r['id'] as String),
      tokoId: Value(r['toko_id'] as String),
      pendingPembelianId: Value(r['pending_pembelian_id'] as String),
      produkId: Value(r['produk_id'] as String),
      namaProduk: Value(r['nama_produk'] as String),
      jumlah: Value(r['jumlah'] as int),
      hargaBeliSatuan: Value((r['harga_beli_satuan'] as num).toDouble()),
      hargaBeliLama: Value((r['harga_beli_lama'] as num).toDouble()),
      diskonTipe: Value(r['diskon_tipe'] as int? ?? 0),
      diskonValue: Value((r['diskon_value'] as num? ?? 0).toDouble()),
      satuanId: Value(r['satuan_id'] as String?),
      konversi: Value((r['konversi'] as num? ?? 1.0).toDouble()),
    ));
  },
};

DateTime _parseDate(dynamic v) {
  if (v == null) return DateTime.now();
  if (v is DateTime) return v;
  return DateTime.tryParse(v.toString()) ?? DateTime.now();
}
