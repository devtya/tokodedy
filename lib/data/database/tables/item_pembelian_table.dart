import 'package:drift/drift.dart';

class ItemPembelianTable extends Table {
  TextColumn get id              => text()(); // UUID
  TextColumn get tokoId          => text()(); // UUID FK ke toko
  TextColumn get pembelianId     => text()(); // UUID FK ke pembelian
  TextColumn get produkId        => text()(); // UUID FK ke produk
  IntColumn get jumlah           => integer().withDefault(const Constant(1))();
  RealColumn get hargaBeliSatuan => real().withDefault(const Constant(0))();
  RealColumn get subtotal        => real().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
