import 'package:drift/drift.dart';
import 'online_order_table.dart';
import 'produk_table.dart';
import 'satuan_produk_table.dart';

@DataClassName('OnlineOrderItem')
class OnlineOrderItemTable extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get onlineOrderId => text().references(OnlineOrderTable, #id)();
  TextColumn get produkId => text().references(ProdukTable, #id)();
  TextColumn get namaProduk => text()();
  RealColumn get hargaSatuan => real().withDefault(const Constant(0.0))();
  IntColumn get jumlah => integer().withDefault(const Constant(1))();
  RealColumn get subtotal => real().withDefault(const Constant(0.0))();
  TextColumn get satuanId => text().nullable().references(SatuanProdukTable, #id)();
  RealColumn get konversi => real().withDefault(const Constant(1.0))();
  BoolColumn get isUnavailable => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
  
  @override
  String get tableName => 'online_order_items';
}
