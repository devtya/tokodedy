import 'package:drift/drift.dart';

class SatuanProdukTable extends Table {
  TextColumn get id       => text()(); // UUID
  TextColumn get tokoId   => text()(); // UUID FK ke toko
  TextColumn get produkId => text()(); // UUID FK ke produk
  TextColumn get nama     => text()();
  RealColumn get konversi => real().withDefault(const Constant(1))();
  RealColumn get hargaBeli => real().withDefault(const Constant(0))();
  RealColumn get hargaJual => real().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
