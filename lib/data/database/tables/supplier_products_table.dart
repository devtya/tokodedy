import 'package:drift/drift.dart';

class SupplierProductsTable extends Table {
  TextColumn get id         => text()(); // UUID
  TextColumn get tokoId     => text()(); // UUID FK ke toko
  TextColumn get supplierId => text()(); // UUID FK ke supplier
  TextColumn get produkId   => text()(); // UUID FK ke produk
  RealColumn get harga      => real().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
