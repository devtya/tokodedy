import 'package:drift/drift.dart';

class KasHarianTable extends Table {
  TextColumn get id => text()();
  RealColumn get modalAwal => real().withDefault(const Constant(0))();
  TextColumn get keterangan => text().nullable()();
  DateTimeColumn get tanggal => dateTime()(); // date only (00:00:00 local)
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  
  @override
  Set<Column> get primaryKey => {id};
}
