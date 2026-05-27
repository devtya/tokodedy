import 'package:drift/drift.dart';

class PendingPembelianItemTable extends Table {
  TextColumn get id                => text()(); // UUID
  TextColumn get tokoId            => text()(); // UUID FK ke toko
  TextColumn get pendingPembelianId => text()(); // UUID FK ke pending_pembelian
  TextColumn get produkId          => text()(); // UUID FK ke produk
  TextColumn get namaProduk        => text()();
  IntColumn get jumlah             => integer().withDefault(const Constant(1))();
  RealColumn get hargaBeliSatuan   => real().withDefault(const Constant(0))();
  RealColumn get hargaBeliLama     => real().withDefault(const Constant(0))();
  IntColumn get diskonTipe         => integer().withDefault(const Constant(0))();
  RealColumn get diskonValue       => real().withDefault(const Constant(0))();
  TextColumn get satuanId          => text().nullable()();
  RealColumn get konversi          => real().withDefault(const Constant(1.0))();

  @override
  Set<Column> get primaryKey => {id};
}
