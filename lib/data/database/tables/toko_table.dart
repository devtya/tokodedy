import 'package:drift/drift.dart';

class TokoTable extends Table {
  TextColumn get id      => text()(); // UUID
  TextColumn get nama    => text()();
  TextColumn? get alamat => text().nullable()();
  TextColumn? get telepon => text().nullable()();
  TextColumn? get ownerId => text().nullable()(); // Supabase Auth user UUID
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
