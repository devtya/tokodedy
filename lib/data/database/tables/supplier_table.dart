import 'package:drift/drift.dart';

class SupplierTable extends Table {
  TextColumn get id      => text()(); // UUID
  TextColumn get tokoId  => text()(); // UUID FK ke toko
  TextColumn get nama    => text()();
  TextColumn? get telepon => text().nullable()();
  TextColumn? get alamat  => text().nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
