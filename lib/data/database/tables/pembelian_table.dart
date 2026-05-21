import 'package:drift/drift.dart';

class PembelianTable extends Table {
  TextColumn get id           => text()(); // UUID
  TextColumn get tokoId       => text()(); // UUID FK ke toko
  TextColumn? get supplierId  => text().nullable()(); // UUID FK ke supplier
  TextColumn? get namaSupplier => text().nullable()();
  RealColumn get totalHarga   => real().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
