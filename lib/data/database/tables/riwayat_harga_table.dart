import 'package:drift/drift.dart';

class RiwayatHargaTable extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get produkId => text()(); // UUID FK ke produk
  RealColumn get hargaBeliLama => real()();
  RealColumn get hargaBeliBaru => real()();
  RealColumn get hargaJualLama => real()();
  RealColumn get hargaJualBaru => real()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
