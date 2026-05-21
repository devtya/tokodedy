import 'package:drift/drift.dart';

class NotifikasiTable extends Table {
  TextColumn get id     => text()(); // UUID
  TextColumn get tokoId => text()(); // UUID FK ke toko
  TextColumn get judul  => text()();
  TextColumn get pesan  => text()();
  TextColumn get tipe   => text().withDefault(const Constant('INFO'))();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
