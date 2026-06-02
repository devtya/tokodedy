import 'package:drift/drift.dart';
import 'online_customer_table.dart';

@DataClassName('OnlineOrder')
class OnlineOrderTable extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get customerId => text().references(OnlineCustomerTable, #id)();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  RealColumn get totalHarga => real().withDefault(const Constant(0.0))();
  TextColumn get metodePengiriman => text().withDefault(const Constant('pickup'))();
  TextColumn get alamatPengiriman => text().nullable()();
  TextColumn get catatan => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
  
  @override
  String get tableName => 'online_orders';
}
