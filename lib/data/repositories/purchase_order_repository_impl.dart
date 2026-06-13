import 'package:injectable/injectable.dart';
import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../services/supabase_sync_service.dart';
import '../../domain/entities/purchase_order.dart' as domain;
import '../../domain/entities/purchase_order_item.dart' as domain;
import '../../domain/repositories/purchase_order_repository.dart';

@LazySingleton(as: PurchaseOrderRepository)
class PurchaseOrderRepositoryImpl implements PurchaseOrderRepository {
  final AppDatabase _db;
  final SupabaseSyncService _syncService;

  PurchaseOrderRepositoryImpl(this._db, this._syncService);

  domain.PurchaseOrder _map(PurchaseOrderTableData data) {
    return domain.PurchaseOrder(
      id: data.id,
      supplierId: data.supplierId,
      namaSupplier: data.namaSupplier,
      status: data.status,
      totalHarga: data.totalHarga,
      notes: data.notes,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
    );
  }

  @override
  Future<List<domain.PurchaseOrder>> getAllPurchaseOrders() async {
    final data = await _db.select(_db.purchaseOrderTable).get();
    data.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return data.map(_map).toList();
  }

  @override
  Future<domain.PurchaseOrder?> getPurchaseOrderById(String id) async {
    final data = await (_db.select(_db.purchaseOrderTable)
      ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return data != null ? _map(data) : null;
  }

  @override
  Future<String> addPurchaseOrder(domain.PurchaseOrder po) async {
    final id = po.id ?? _syncService.generateId();
    await _db.into(_db.purchaseOrderTable).insert(
      PurchaseOrderTableCompanion.insert(
        id: id,
        supplierId: Value(po.supplierId),
        namaSupplier: Value(po.namaSupplier),
        status: Value(po.status),
        totalHarga: Value(po.totalHarga),
        notes: Value(po.notes),
      ),
    );

    await _syncService.upsert('purchase_orders', {
      'id': id,
      'supplier_id': po.supplierId,
      'nama_supplier': po.namaSupplier,
      'status': po.status,
      'total_harga': po.totalHarga,
      'notes': po.notes,
    });

    return id;
  }

  @override
  Future<void> updatePurchaseOrder(domain.PurchaseOrder po) async {
    await (_db.update(_db.purchaseOrderTable)
      ..where((t) => t.id.equals(po.id!)))
      .write(PurchaseOrderTableCompanion(
        supplierId: Value(po.supplierId),
        namaSupplier: Value(po.namaSupplier),
        status: Value(po.status),
        totalHarga: Value(po.totalHarga),
        notes: Value(po.notes),
      ));

    await _syncService.upsert('purchase_orders', {
      'id': po.id!,
      'supplier_id': po.supplierId,
      'nama_supplier': po.namaSupplier,
      'status': po.status,
      'total_harga': po.totalHarga,
      'notes': po.notes,
    });
  }

  @override
  Future<void> addPurchaseOrderItem(domain.PurchaseOrderItem item) async {
    final id = item.id ?? _syncService.generateId();
    await _db.into(_db.purchaseOrderItemTable).insert(
      PurchaseOrderItemTableCompanion.insert(
        id: id,
        poId: item.poId,
        produkId: item.produkId,
        namaProduk: Value(item.namaProduk),
        qtyPesan: Value(item.qtyPesan),
        qtyTerima: Value(item.qtyTerima),
        hargaSatuan: Value(item.hargaSatuan),
        subtotal: Value(item.subtotal),
        satuanId: Value(item.satuanId),
        konversi: Value(item.konversi),
      ),
    );

    await _syncService.upsert('purchase_order_items', {
      'id': id,
      'po_id': item.poId,
      'produk_id': item.produkId,
      'nama_produk': item.namaProduk,
      'qty_pesan': item.qtyPesan,
      'qty_terima': item.qtyTerima,
      'harga_satuan': item.hargaSatuan,
      'subtotal': item.subtotal,
      'satuan_id': item.satuanId,
      'konversi': item.konversi,
    });
  }

  @override
  Future<void> updatePurchaseOrderItem(domain.PurchaseOrderItem item) async {
    await (_db.update(_db.purchaseOrderItemTable)
      ..where((t) => t.id.equals(item.id!)))
      .write(PurchaseOrderItemTableCompanion(
        qtyTerima: Value(item.qtyTerima),
      ));

    await _syncService.upsert('purchase_order_items', {
      'id': item.id!,
      'po_id': item.poId,
      'produk_id': item.produkId,
      'nama_produk': item.namaProduk,
      'qty_pesan': item.qtyPesan,
      'qty_terima': item.qtyTerima,
      'harga_satuan': item.hargaSatuan,
      'subtotal': item.subtotal,
      'satuan_id': item.satuanId,
      'konversi': item.konversi,
    });
  }

  @override
  Future<List<domain.PurchaseOrderItem>> getItemsByPoId(String poId) async {
    final query = _db.select(_db.purchaseOrderItemTable).join([
      innerJoin(
        _db.produkTable,
        _db.produkTable.id.equalsExp(_db.purchaseOrderItemTable.produkId),
      ),
      leftOuterJoin(
        _db.satuanProdukTable,
        _db.satuanProdukTable.id.equalsExp(_db.purchaseOrderItemTable.satuanId),
      ),
    ])..where(_db.purchaseOrderItemTable.poId.equals(poId));

    final result = await query.get();
    return result.map((row) {
      final item = row.readTable(_db.purchaseOrderItemTable);
      final produk = row.readTable(_db.produkTable);
      final satuan = row.readTableOrNull(_db.satuanProdukTable);
      final unitName = satuan?.nama ?? produk.satuan;
      return domain.PurchaseOrderItem(
        id: item.id,
        poId: item.poId,
        produkId: item.produkId,
        namaProduk: '${produk.nama} - $unitName',
        qtyPesan: item.qtyPesan,
        qtyTerima: item.qtyTerima,
        hargaSatuan: item.hargaSatuan,
        subtotal: item.subtotal,
        satuanId: item.satuanId,
        konversi: item.konversi,
      );
    }).toList();
  }

  @override
  Future<void> deletePurchaseOrder(String id) async {
    await (_db.delete(_db.purchaseOrderItemTable)
      ..where((t) => t.poId.equals(id)))
      .go();
    await (_db.delete(_db.purchaseOrderTable)
      ..where((t) => t.id.equals(id)))
      .go();

    await _syncService.delete('purchase_order_items', id);
    await _syncService.delete('purchase_orders', id);
  }

  @override
  Future<void> updateStatus(String id, String status) async {
    await (_db.update(_db.purchaseOrderTable)
      ..where((t) => t.id.equals(id)))
      .write(PurchaseOrderTableCompanion(
        status: Value(status),
        updatedAt: Value(DateTime.now()),
      ));
    
    await _syncService.upsert('purchase_orders', {
      'id': id,
      'status': status,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    });
  }

  @override
  Future<void> deleteItemsByPoId(String poId) async {
    // Cari id item yang akan dihapus untuk disinkronisasi
    final items = await (_db.select(_db.purchaseOrderItemTable)
      ..where((t) => t.poId.equals(poId)))
      .get();
      
    await (_db.delete(_db.purchaseOrderItemTable)
      ..where((t) => t.poId.equals(poId)))
      .go();

    for (var item in items) {
      await _syncService.delete('purchase_order_items', item.id);
    }
  }
}
