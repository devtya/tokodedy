import 'package:drift/drift.dart';

class RiwayatPerubahanProdukTable extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get produkId => text()(); // UUID FK ke produk
  TextColumn get kolomDiubah => text()(); // 'NAMA', 'STOK', dsb.
  TextColumn get nilaiLama => text()(); 
  TextColumn get nilaiBaru => text()(); 
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
