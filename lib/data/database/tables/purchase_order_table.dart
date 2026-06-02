import 'package:drift/drift.dart';

class PurchaseOrderTable extends Table {
  TextColumn get id           => text()(); // UUID
  TextColumn? get supplierId  => text().nullable()(); // UUID FK ke supplier
  TextColumn? get namaSupplier => text().nullable()();
  TextColumn get status       => text().withDefault(const Constant('open'))(); // open, partial, received, cancelled
  RealColumn get totalHarga   => real().withDefault(const Constant(0))();
  TextColumn? get notes       => text().nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
