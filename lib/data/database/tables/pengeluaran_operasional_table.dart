import 'package:drift/drift.dart';

class PengeluaranOperasionalTable extends Table {
  TextColumn get id => text()();
  RealColumn get jumlah => real().withDefault(const Constant(0))();
  TextColumn get kategori => text().withDefault(const Constant('Lain-lain'))();
  TextColumn get keterangan => text().nullable()();
  DateTimeColumn get tanggal => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  
  @override
  Set<Column> get primaryKey => {id};
}
