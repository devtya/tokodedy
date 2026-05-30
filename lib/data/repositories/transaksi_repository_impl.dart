import 'package:injectable/injectable.dart';
import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../services/supabase_sync_service.dart';
import '../../core/services/toko_service.dart';
import '../../domain/entities/item_transaksi.dart' as domain;
import '../../domain/entities/transaksi.dart' as domain;
import '../../domain/repositories/transaksi_repository.dart';

@LazySingleton(as: TransaksiRepository)
class TransaksiRepositoryImpl implements TransaksiRepository {
  final AppDatabase _db;
  final SupabaseSyncService _syncService;
  final TokoService _tokoService;

  TransaksiRepositoryImpl(this._db, this._syncService, this._tokoService);

  String get _tokoId => _tokoService.tokoId ?? '';

  domain.Transaksi _mapTransaksi(TransaksiTableData data) {
    return domain.Transaksi(
      id: data.id,
      tokoId: data.tokoId,
      kasirId: data.kasirId,
      totalHarga: data.totalHarga,
      jumlahBayar: data.jumlahBayar,
      kembalian: data.kembalian,
      status: data.status,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
    );
  }

  @override
  Future<List<domain.Transaksi>> getAllTransaksi() async {
    final data = await (_db.select(_db.transaksiTable)..where((t) => t.tokoId.equals(_tokoId))).get();
    data.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return data.map(_mapTransaksi).toList();
  }

  @override
  Future<List<domain.Transaksi>> getTransaksiByDate(DateTime date) async {
    final data = await (_db.select(_db.transaksiTable)..where((t) => t.tokoId.equals(_tokoId))).get();
    final filtered = data.where((t) {
      return t.createdAt.year == date.year &&
          t.createdAt.month == date.month &&
          t.createdAt.day == date.day;
    }).toList();
    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return filtered.map(_mapTransaksi).toList();
  }

  @override
  Future<domain.Transaksi?> getTransaksiById(String id) async {
    final data = await (_db.select(_db.transaksiTable)
      ..where((t) => t.id.equals(id) & t.tokoId.equals(_tokoId)))
        .getSingleOrNull();
    if (data == null) return null;
    final items = await getItemTransaksiByTransaksiId(id);
    return _mapTransaksi(data).copyWith(items: items);
  }

  @override
  Future<String> addTransaksi(domain.Transaksi transaksi) async {
    final id = transaksi.id ?? _syncService.generateId();
    await _db.into(_db.transaksiTable).insert(
          TransaksiTableCompanion.insert(
            id: id,
            tokoId: _tokoId,
            kasirId: Value(transaksi.kasirId),
            totalHarga: Value(transaksi.totalHarga),
            jumlahBayar: Value(transaksi.jumlahBayar),
            kembalian: Value(transaksi.kembalian),
            status: Value(transaksi.status),
          ),
        );

    // Sync to Supabase
    await _syncService.upsert('transaksi', {
      'id': id,
      'toko_id': _tokoId,
      'kasir_id': transaksi.kasirId,
      'total_harga': transaksi.totalHarga,
      'jumlah_bayar': transaksi.jumlahBayar,
      'kembalian': transaksi.kembalian,
      'status': transaksi.status,
    });

    return id;
  }

  @override
  Future<void> addItemTransaksi(domain.ItemTransaksi item) async {
    final id = item.id ?? _syncService.generateId();
    await _db.into(_db.itemTransaksiTable).insert(
          ItemTransaksiTableCompanion.insert(
            id: id,
            tokoId: _tokoId,
            transaksiId: item.transaksiId,
            produkId: item.produkId,
            jumlah: Value(item.jumlah),
            hargaSatuan: Value(item.hargaSatuan),
            subtotal: Value(item.subtotal),
          ),
        );

    // Sync to Supabase
    await _syncService.upsert('item_transaksi', {
      'id': id,
      'toko_id': _tokoId,
      'transaksi_id': item.transaksiId,
      'produk_id': item.produkId,
      'jumlah': item.jumlah,
      'harga_satuan': item.hargaSatuan,
      'subtotal': item.subtotal,
    });
  }

  @override
  Future<List<domain.ItemTransaksi>> getItemTransaksiByTransaksiId(
    String transaksiId,
  ) async {
    final query = _db.select(_db.itemTransaksiTable).join([
      leftOuterJoin(
        _db.produkTable,
        _db.produkTable.id.equalsExp(_db.itemTransaksiTable.produkId),
      ),
    ])..where(_db.itemTransaksiTable.transaksiId.equals(transaksiId) & _db.itemTransaksiTable.tokoId.equals(_tokoId));

    final rows = await query.get();
    return rows.map((row) {
      final item = row.readTable(_db.itemTransaksiTable);
      final produk = row.readTableOrNull(_db.produkTable);
      return domain.ItemTransaksi(
        id: item.id,
        tokoId: item.tokoId,
        transaksiId: item.transaksiId,
        produkId: item.produkId,
        namaProduk: produk?.nama,
        jumlah: item.jumlah,
        hargaSatuan: item.hargaSatuan,
        subtotal: item.subtotal,
      );
    }).toList();
  }

  @override
  Future<domain.Transaksi?> getLastTransaksiByProdukId(String produkId) async {
    final query = _db.select(_db.itemTransaksiTable).join([
      innerJoin(
        _db.transaksiTable,
        _db.transaksiTable.id.equalsExp(_db.itemTransaksiTable.transaksiId),
      ),
      innerJoin(
        _db.produkTable,
        _db.produkTable.id.equalsExp(_db.itemTransaksiTable.produkId),
      ),
    ])
      ..where(_db.itemTransaksiTable.produkId.equals(produkId) & _db.itemTransaksiTable.tokoId.equals(_tokoId))
      ..orderBy([
        OrderingTerm(
          expression: _db.transaksiTable.createdAt,
          mode: OrderingMode.desc,
        ),
      ])
      ..limit(1);

    final result = await query.getSingleOrNull();
    if (result == null) return null;

    final item = result.readTable(_db.itemTransaksiTable);
    final transaksi = result.readTable(_db.transaksiTable);
    final produk = result.readTable(_db.produkTable);
    return domain.Transaksi(
      id: transaksi.id,
      tokoId: transaksi.tokoId,
      kasirId: transaksi.kasirId,
      totalHarga: transaksi.totalHarga,
      jumlahBayar: transaksi.jumlahBayar,
      kembalian: transaksi.kembalian,
      status: transaksi.status,
      createdAt: transaksi.createdAt,
      updatedAt: transaksi.updatedAt,
      items: [
        domain.ItemTransaksi(
          id: item.id,
          tokoId: item.tokoId,
          transaksiId: item.transaksiId,
          produkId: item.produkId,
          namaProduk: produk.nama,
          jumlah: item.jumlah,
          hargaSatuan: item.hargaSatuan,
          subtotal: item.subtotal,
        ),
      ],
    );
  }

  @override
  Future<double> getTotalOmsetToday() async {
    final data = await (_db.select(_db.transaksiTable)..where((t) => t.tokoId.equals(_tokoId))).get();
    final now = DateTime.now();
    final today = data.where((t) {
      return t.createdAt.year == now.year &&
          t.createdAt.month == now.month &&
          t.createdAt.day == now.day &&
          t.status == 'lunas';
    });
    double total = 0;
    for (final t in today) {
      total += t.totalHarga;
    }
    return total;
  }
}
