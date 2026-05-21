import 'package:drift/drift.dart';

class PendingOrderTable extends Table {
  TextColumn get id             => text()(); // UUID
  TextColumn get tokoId         => text()(); // UUID FK ke toko
  TextColumn get namaPelanggan  => text()();
  TextColumn? get catatan       => text().nullable()();
  DateTimeColumn get createdAt  => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
