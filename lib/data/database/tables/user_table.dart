import 'package:drift/drift.dart';

/// Profiles: users per toko, linked ke Supabase Auth UUID
class UserTable extends Table {
  TextColumn get id      => text()(); // UUID = Supabase Auth user id
  TextColumn get tokoId  => text()(); // UUID FK ke toko
  TextColumn? get nama   => text().nullable()();
  TextColumn get role    => text().withDefault(const Constant('kasir'))(); // 'owner' | 'kasir'
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
