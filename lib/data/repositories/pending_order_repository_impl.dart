import 'package:injectable/injectable.dart';
import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../services/supabase_sync_service.dart';
import '../../domain/entities/pending_order.dart' as domain;
import '../../domain/repositories/pending_order_repository.dart';

@LazySingleton(as: PendingOrderRepository)
class PendingOrderRepositoryImpl implements PendingOrderRepository {
  final AppDatabase _db;
  final SupabaseSyncService _syncService;

  PendingOrderRepositoryImpl(this._db, this._syncService);

  domain.PendingOrder _map(PendingOrderTableData data) {
    return domain.PendingOrder(
      id: data.id,
      namaPelanggan: data.namaPelanggan,
      catatan: data.catatan,
      createdAt: data.createdAt,
    );
  }

  @override
  Future<List<domain.PendingOrder>> getAllPending() async {
    final data = await _db.select(_db.pendingOrderTable).get();
    data.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return data.map(_map).toList();
  }

  @override
  Future<domain.PendingOrder?> getPendingById(String id) async {
    final data = await (_db.select(_db.pendingOrderTable)
      ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return data != null ? _map(data) : null;
  }

  @override
  Future<String> addPending(domain.PendingOrder pending) async {
    final id = pending.id ?? _syncService.generateId();
    await _db.into(_db.pendingOrderTable).insert(
          PendingOrderTableCompanion.insert(
            id: id,
                  namaPelanggan: pending.namaPelanggan,
            catatan: Value(pending.catatan),
          ),
        );

    // Sync to Supabase
    await _syncService.upsert('pending_order', {
      'id': id,
      'nama_pelanggan': pending.namaPelanggan,
      'catatan': pending.catatan,
    });

    return id;
  }

  @override
  Future<void> deletePending(String id) async {
    // Drop items first locally and in Supabase
    final items = await getItemsByPendingId(id);
    for (final item in items) {
      if (item.id != null) {
        await _syncService.delete('pending_order_item', item.id!);
      }
    }
    await (_db.delete(_db.pendingOrderItemTable)
      ..where((t) => t.pendingOrderId.equals(id)))
        .go();

    // Drop parent
    await (_db.delete(_db.pendingOrderTable)
      ..where((t) => t.id.equals(id)))
        .go();

    // Sync to Supabase
    await _syncService.delete('pending_order', id);
  }

  @override
  Future<List<CartItemData>> getItemsByPendingId(String pendingId) async {
    final data = await (_db.select(_db.pendingOrderItemTable)
      ..where((t) => t.pendingOrderId.equals(pendingId)))
        .get();
    return data
        .map(
          (d) => CartItemData(
            id: d.id,
            produkId: d.produkId,
            namaProduk: d.namaProduk,
            hargaJual: d.hargaJual,
            jumlah: d.jumlah,
            diskonTipe: d.diskonTipe,
            diskonValue: d.diskonValue,
            subtotal: d.subtotal,
          ),
        )
        .toList();
  }

  @override
  Future<void> addItem(String pendingId, CartItemData item) async {
    final id = item.id ?? _syncService.generateId();
    await _db.into(_db.pendingOrderItemTable).insert(
          PendingOrderItemTableCompanion.insert(
            id: id,
                  pendingOrderId: pendingId,
            produkId: item.produkId,
            namaProduk: item.namaProduk,
            hargaJual: Value(item.hargaJual),
            jumlah: Value(item.jumlah),
            diskonTipe: Value(item.diskonTipe),
            diskonValue: Value(item.diskonValue),
            subtotal: Value(item.subtotal),
          ),
        );

    // Sync to Supabase
    await _syncService.upsert('pending_order_item', {
      'id': id,
      'pending_order_id': pendingId,
      'produk_id': item.produkId,
      'nama_produk': item.namaProduk,
      'harga_jual': item.hargaJual,
      'jumlah': item.jumlah,
      'diskon_tipe': item.diskonTipe,
      'diskon_value': item.diskonValue,
      'subtotal': item.subtotal,
    });
  }
}
