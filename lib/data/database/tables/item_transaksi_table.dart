import 'package:drift/drift.dart';

class ItemTransaksiTable extends Table {
  TextColumn get id          => text()(); // UUID
  TextColumn get tokoId      => text()(); // UUID FK ke toko
  TextColumn get transaksiId => text()(); // UUID FK ke transaksi
  TextColumn get produkId    => text()(); // UUID FK ke produk
  IntColumn get jumlah       => integer().withDefault(const Constant(1))();
  RealColumn get hargaSatuan => real().withDefault(const Constant(0))();
  RealColumn get subtotal    => real().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
