import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'app_database.dart';

class SupplierProductsDao {
  final AppDatabase _db;
  final Uuid _uuid = const Uuid();

  SupplierProductsDao(this._db);

  Future<void> upsertSupplierProduct({
    required String tokoId,
    required String supplierId,
    required String produkId,
    required double harga,
  }) async {
    final existing = await (_db.select(_db.supplierProductsTable)
          ..where((t) =>
              t.supplierId.equals(supplierId) & t.produkId.equals(produkId)))
        .getSingleOrNull();

    if (existing != null) {
      await (_db.update(_db.supplierProductsTable)
            ..where((t) => t.id.equals(existing.id)))
          .write(
        SupplierProductsTableCompanion(
          harga: Value(harga),
          updatedAt: Value(DateTime.now()),
        ),
      );
    } else {
      await _db.into(_db.supplierProductsTable).insert(
        SupplierProductsTableCompanion.insert(
          id: _uuid.v4(),
          tokoId: tokoId,
          supplierId: supplierId,
          produkId: produkId,
          harga: Value(harga),
          updatedAt: Value(DateTime.now()),
        ),
      );
    }
  }

  Future<List<String>> getProductsBySupplier(String supplierId) async {
    final rows = await (_db.select(_db.supplierProductsTable)
          ..where((t) => t.supplierId.equals(supplierId)))
        .get();
    return rows.map((r) => r.produkId).toList();
  }

  Future<List<String>> getSuppliersByProduct(String produkId) async {
    final rows = await (_db.select(_db.supplierProductsTable)
          ..where((t) => t.produkId.equals(produkId)))
        .get();
    return rows.map((r) => r.supplierId).toList();
  }
}
