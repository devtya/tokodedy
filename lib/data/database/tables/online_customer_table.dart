import 'package:drift/drift.dart';

@DataClassName('OnlineCustomer')
class OnlineCustomerTable extends Table {
  TextColumn get id => text()(); // UUID dari auth.users
  TextColumn get nama => text()();
  TextColumn get telepon => text().nullable()();
  TextColumn get alamat => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
  
  @override
  String get tableName => 'online_customers';
}
