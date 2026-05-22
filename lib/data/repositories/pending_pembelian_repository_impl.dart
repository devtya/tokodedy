import 'package:drift/drift.dart';

import '../../data/database/app_database.dart';
import '../../data/services/supabase_sync_service.dart';
import '../../core/services/toko_service.dart';
import '../../domain/entities/pending_pembelian.dart';
import '../../domain/repositories/pending_pembelian_repository.dart';

class PendingPembelianRepositoryImpl implements PendingPembelianRepository {
  final AppDatabase _db;
  final SupabaseSyncService _syncService;
  final TokoService _tokoService;

  PendingPembelianRepositoryImpl(this._db, this._syncService, this._tokoService);

  String get _tokoId => _tokoService.tokoId ?? '';

  PendingPembelian _map(PendingPembelianTableData data) {
    return PendingPembelian(
      id: data.id,
      tokoId: data.tokoId,
      supplierId: data.supplierId,
      namaSupplier: data.namaSupplier,
      createdAt: data.createdAt,
      isPpnEnabled: data.isPpnEnabled,
      ppnPercent: data.ppnPercent,
      diskonTipe: data.diskonTipe,
      diskonPersen: data.diskonPersen,
      diskonNominal: data.diskonNominal,
    );
  }

  @override
  Future<List<PendingPembelian>> getAllPending() async {
    final data = await (_db.select(_db.pendingPembelianTable)..where((t) => t.tokoId.equals(_tokoId))).get();
    data.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return data.map(_map).toList();
  }

  @override
  Future<PendingPembelian?> getPendingById(String id) async {
    final data = await (_db.select(_db.pendingPembelianTable)
      ..where((t) => t.id.equals(id) & t.tokoId.equals(_tokoId)))
        .getSingleOrNull();
    return data != null ? _map(data) : null;
  }

  @override
  Future<String> addPending(PendingPembelian pending) async {
    final id = pending.id ?? _syncService.generateId();
    await _db.into(_db.pendingPembelianTable).insert(
          PendingPembelianTableCompanion.insert(
            id: id,
            tokoId: _tokoId,
            supplierId: Value(pending.supplierId),
            namaSupplier: Value(pending.namaSupplier),
            isPpnEnabled: Value(pending.isPpnEnabled),
            ppnPercent: Value(pending.ppnPercent),
            diskonTipe: Value(pending.diskonTipe),
            diskonPersen: Value(pending.diskonPersen),
            diskonNominal: Value(pending.diskonNominal),
          ),
        );

    // Sync to Supabase
    await _syncService.upsert('pending_pembelian', {
      'id': id,
      'toko_id': _tokoId,
      'supplier_id': pending.supplierId,
      'nama_supplier': pending.namaSupplier,
      'is_ppn_enabled': pending.isPpnEnabled,
      'ppn_percent': pending.ppnPercent,
      'diskon_tipe': pending.diskonTipe,
      'diskon_persen': pending.diskonPersen,
      'diskon_nominal': pending.diskonNominal,
    });

    return id;
  }

  @override
  Future<void> deletePending(String id) async {
    // Delete items first locally and in Supabase
    final items = await getItemsByPendingId(id);
    for (final item in items) {
      if (item.id != null) {
        await _syncService.delete('pending_pembelian_item', item.id!);
      }
    }
    await (_db.delete(_db.pendingPembelianItemTable)
      ..where((t) => t.pendingPembelianId.equals(id) & t.tokoId.equals(_tokoId)))
        .go();

    // Delete parent
    await (_db.delete(_db.pendingPembelianTable)
      ..where((t) => t.id.equals(id) & t.tokoId.equals(_tokoId)))
        .go();

    // Sync to Supabase
    await _syncService.delete('pending_pembelian', id);
  }

  @override
  Future<List<PendingPembelianItemData>> getItemsByPendingId(
    String pendingId,
  ) async {
    final data = await (_db.select(_db.pendingPembelianItemTable)
      ..where((t) => t.pendingPembelianId.equals(pendingId) & t.tokoId.equals(_tokoId)))
        .get();

    return data
        .map(
          (item) => PendingPembelianItemData(
            id: item.id,
            produkId: item.produkId,
            namaProduk: item.namaProduk,
            jumlah: item.jumlah,
            hargaBeliSatuan: item.hargaBeliSatuan,
            hargaBeliLama: item.hargaBeliLama,
            diskonTipe: item.diskonTipe,
            diskonValue: item.diskonValue,
          ),
        )
        .toList();
  }

  @override
  Future<void> addItem(String pendingId, PendingPembelianItemData item) async {
    final id = item.id ?? _syncService.generateId();
    await _db.into(_db.pendingPembelianItemTable).insert(
          PendingPembelianItemTableCompanion.insert(
            id: id,
            tokoId: _tokoId,
            pendingPembelianId: pendingId,
            produkId: item.produkId,
            namaProduk: item.namaProduk,
            jumlah: Value(item.jumlah),
            hargaBeliSatuan: Value(item.hargaBeliSatuan),
            hargaBeliLama: Value(item.hargaBeliLama),
            diskonTipe: Value(item.diskonTipe),
            diskonValue: Value(item.diskonValue),
          ),
        );

    // Sync to Supabase
    await _syncService.upsert('pending_pembelian_item', {
      'id': id,
      'toko_id': _tokoId,
      'pending_pembelian_id': pendingId,
      'produk_id': item.produkId,
      'nama_produk': item.namaProduk,
      'jumlah': item.jumlah,
      'harga_beli_satuan': item.hargaBeliSatuan,
      'harga_beli_lama': item.hargaBeliLama,
      'diskon_tipe': item.diskonTipe,
      'diskon_value': item.diskonValue,
    });
  }
}
