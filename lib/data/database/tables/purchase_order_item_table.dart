import 'package:drift/drift.dart';

class PurchaseOrderItemTable extends Table {
  TextColumn get id            => text()(); // UUID
  TextColumn get poId          => text()(); // UUID FK ke purchase_order
  TextColumn get produkId      => text()(); // UUID FK ke produk
  TextColumn? get namaProduk   => text().nullable()();
  IntColumn get qtyPesan       => integer().withDefault(const Constant(1))();
  IntColumn get qtyTerima      => integer().withDefault(const Constant(0))();
  RealColumn get hargaSatuan   => real().withDefault(const Constant(0))();
  RealColumn get subtotal      => real().withDefault(const Constant(0))();
  TextColumn? get satuanId     => text().nullable()();
  RealColumn get konversi      => real().withDefault(const Constant(1.0))();

  @override
  Set<Column> get primaryKey => {id};
}
