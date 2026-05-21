import 'package:drift/drift.dart';

class PendingPembelianTable extends Table {
  TextColumn get id           => text()(); // UUID
  TextColumn get tokoId       => text()(); // UUID FK ke toko
  TextColumn? get supplierId  => text().nullable()(); // UUID FK ke supplier
  TextColumn? get namaSupplier => text().nullable()();
  BoolColumn get isPpnEnabled => boolean().withDefault(const Constant(false))();
  RealColumn get ppnPercent   => real().withDefault(const Constant(11.0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
