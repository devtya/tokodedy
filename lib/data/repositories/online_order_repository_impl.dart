import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../services/supabase_sync_service.dart';
import '../../domain/entities/online_order.dart' as domain;
import '../../domain/entities/online_order_item.dart' as domain_item;
import '../../domain/repositories/online_order_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: OnlineOrderRepository)
class OnlineOrderRepositoryImpl implements OnlineOrderRepository {
  final AppDatabase _db;
  final SupabaseSyncService _syncService;

  OnlineOrderRepositoryImpl(this._db, this._syncService);

  domain_item.OnlineOrderItem _mapItem(OnlineOrderItem i) {
    return domain_item.OnlineOrderItem(
      id: i.id,
      produkId: i.produkId,
      namaProduk: i.namaProduk,
      hargaSatuan: i.hargaSatuan,
      jumlah: i.jumlah,
      subtotal: i.subtotal,
      satuanId: i.satuanId,
      konversi: i.konversi,
      isUnavailable: i.isUnavailable,
    );
  }

  @override
  Future<List<domain.OnlineOrder>> getActiveOrders() async {
    final query = _db.select(_db.onlineOrderTable).join([
      leftOuterJoin(
        _db.onlineCustomerTable,
        _db.onlineCustomerTable.id.equalsExp(_db.onlineOrderTable.customerId),
      ),
    ])
      ..where(_db.onlineOrderTable.status.isIn(['pending', 'processing', 'shipped']))
      ..orderBy([OrderingTerm.desc(_db.onlineOrderTable.createdAt)]);

    final rows = await query.get();

    final orderIds = rows.map((row) => row.readTable(_db.onlineOrderTable).id).toList();
    
    List<OnlineOrderItem> allItems = [];
    if (orderIds.isNotEmpty) {
      final itemsQuery = _db.select(_db.onlineOrderItemTable)
        ..where((t) => t.onlineOrderId.isIn(orderIds));
      allItems = await itemsQuery.get();
    }

    return rows.map((row) {
      final order = row.readTable(_db.onlineOrderTable);
      final customer = row.readTableOrNull(_db.onlineCustomerTable);

      final orderItems = allItems
          .where((i) => i.onlineOrderId == order.id)
          .map(_mapItem)
          .toList();

      return domain.OnlineOrder(
        id: order.id,
        customerId: order.customerId,
        namaCustomer: customer?.nama ?? 'Pelanggan Online',
        status: order.status,
        totalHarga: order.totalHarga,
        metodePengiriman: order.metodePengiriman,
        alamatPengiriman: order.alamatPengiriman,
        catatan: order.catatan,
        createdAt: order.createdAt,
        items: orderItems,
      );
    }).toList();
  }

  @override
  Future<List<domain.OnlineOrder>> getRecentCompletedOrders({int days = 14}) async {
    final since = DateTime.now().subtract(Duration(days: days));

    // Hanya filter status di SQL; filter tanggal di Dart
    // untuk menghindari null check error pada DateTime column di Drift
    final query = _db.select(_db.onlineOrderTable).join([
      leftOuterJoin(
        _db.onlineCustomerTable,
        _db.onlineCustomerTable.id.equalsExp(_db.onlineOrderTable.customerId),
      ),
    ])
      ..where(_db.onlineOrderTable.status.isIn(['completed', 'cancelled']))
      ..orderBy([OrderingTerm.desc(_db.onlineOrderTable.createdAt)]);

    final allRows = await query.get();

    // Filter 14 hari terakhir di Dart — aman dari null
    final rows = allRows.where((row) {
      final order = row.readTable(_db.onlineOrderTable);
      return order.createdAt.isAfter(since);
    }).toList();

    final orderIds = rows.map((row) => row.readTable(_db.onlineOrderTable).id).toList();

    List<OnlineOrderItem> allItems = [];
    if (orderIds.isNotEmpty) {
      final itemsQuery = _db.select(_db.onlineOrderItemTable)
        ..where((t) => t.onlineOrderId.isIn(orderIds));
      allItems = await itemsQuery.get();
    }

    return rows.map((row) {
      final order = row.readTable(_db.onlineOrderTable);
      final customer = row.readTableOrNull(_db.onlineCustomerTable);

      final orderItems = allItems
          .where((i) => i.onlineOrderId == order.id)
          .map(_mapItem)
          .toList();

      return domain.OnlineOrder(
        id: order.id,
        customerId: order.customerId,
        namaCustomer: customer?.nama ?? 'Pelanggan Online',
        status: order.status,
        totalHarga: order.totalHarga,
        metodePengiriman: order.metodePengiriman,
        alamatPengiriman: order.alamatPengiriman,
        catatan: order.catatan,
        createdAt: order.createdAt,
        items: orderItems,
      );
    }).toList();
  }

  @override
  Future<domain.OnlineOrder?> getOrderWithItems(String id) async {
    final query = _db.select(_db.onlineOrderTable).join([
      leftOuterJoin(
        _db.onlineCustomerTable,
        _db.onlineCustomerTable.id.equalsExp(_db.onlineOrderTable.customerId),
      ),
    ])..where(_db.onlineOrderTable.id.equals(id));

    final row = await query.getSingleOrNull();
    if (row == null) return null;

    final order = row.readTable(_db.onlineOrderTable);
    final customer = row.readTableOrNull(_db.onlineCustomerTable);

    final items = await (_db.select(_db.onlineOrderItemTable)
          ..where((t) => t.onlineOrderId.equals(id)))
        .get();

    return domain.OnlineOrder(
      id: order.id,
      customerId: order.customerId,
      namaCustomer: customer?.nama ?? 'Pelanggan Online',
      status: order.status,
      totalHarga: order.totalHarga,
      metodePengiriman: order.metodePengiriman,
      alamatPengiriman: order.alamatPengiriman,
      catatan: order.catatan,
      createdAt: order.createdAt,
      items: items.map(_mapItem).toList(),
    );
  }

  @override
  Future<void> updateOrderStatus(String id, String status, {double? newTotal}) async {
    final companion = OnlineOrderTableCompanion(
      status: Value(status),
      updatedAt: Value(DateTime.now()),
    );
    
    await (_db.update(_db.onlineOrderTable)..where((t) => t.id.equals(id))).write(
      newTotal != null ? companion.copyWith(totalHarga: Value(newTotal)) : companion
    );

    final updatedRow = await (_db.select(_db.onlineOrderTable)..where((t) => t.id.equals(id))).getSingle();
    
    final supabaseMap = {
      'id': updatedRow.id,
      'customer_id': updatedRow.customerId,
      'status': updatedRow.status,
      'total_harga': updatedRow.totalHarga,
      'metode_pengiriman': updatedRow.metodePengiriman,
      'alamat_pengiriman': updatedRow.alamatPengiriman,
      'catatan': updatedRow.catatan,
      'updated_at': updatedRow.updatedAt.toUtc().toIso8601String(),
      'created_at': updatedRow.createdAt.toUtc().toIso8601String(),
    };

    await _syncService.upsert('online_orders', supabaseMap);
  }

  @override
  Future<void> markItemUnavailable(String itemId, bool isUnavailable) async {
    await (_db.update(_db.onlineOrderItemTable)
          ..where((t) => t.id.equals(itemId)))
        .write(OnlineOrderItemTableCompanion(
      isUnavailable: Value(isUnavailable),
    ));

    // Sync ke Supabase
    final item = await (_db.select(_db.onlineOrderItemTable)
          ..where((t) => t.id.equals(itemId)))
        .getSingleOrNull();
    if (item != null) {
      await _syncService.upsert('online_order_items', {
        'id': item.id,
        'online_order_id': item.onlineOrderId,
        'produk_id': item.produkId,
        'nama_produk': item.namaProduk,
        'harga_satuan': item.hargaSatuan,
        'jumlah': item.jumlah,
        'subtotal': item.subtotal,
        'satuan_id': item.satuanId,
        'konversi': item.konversi,
        'is_unavailable': item.isUnavailable,
      });
    }
  }
}
