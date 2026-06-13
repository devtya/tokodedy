import 'package:drift/drift.dart';

class ProdukTable extends Table {
  TextColumn get id       => text()(); // UUID
  TextColumn get nama     => text()();
  TextColumn? get barcode => text().nullable()();
  RealColumn get hargaBeli => real().withDefault(const Constant(0))();
  RealColumn get hargaJual => real().withDefault(const Constant(0.0))();
  IntColumn get stok      => integer().withDefault(const Constant(0))();
  IntColumn? get stokMinimum => integer().nullable()();
  TextColumn? get kategori => text().nullable()();
  TextColumn get satuan   => text().withDefault(const Constant('pcs'))();
  TextColumn? get imageUrl => text().nullable()();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
