import 'package:drift/drift.dart';

class PendingOrderItemTable extends Table {
  TextColumn get id             => text()(); // UUID
  TextColumn get tokoId         => text()(); // UUID FK ke toko
  TextColumn get pendingOrderId => text()(); // UUID FK ke pending_order
  TextColumn get produkId       => text()(); // UUID FK ke produk
  TextColumn get namaProduk     => text()();
  RealColumn get hargaJual      => real().withDefault(const Constant(0))();
  IntColumn get jumlah          => integer().withDefault(const Constant(1))();
  IntColumn get diskonTipe      => integer().withDefault(const Constant(0))();
  RealColumn get diskonValue    => real().withDefault(const Constant(0))();
  RealColumn get subtotal       => real().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
