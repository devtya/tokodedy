import 'package:drift/drift.dart';

class TokoTable extends Table {
  TextColumn get id      => text()(); // UUID
  TextColumn get nama    => text()();
  TextColumn? get alamat => text().nullable()();
  TextColumn? get telepon => text().nullable()();
  TextColumn? get ownerId => text().nullable()(); // Supabase Auth user UUID
  IntColumn get stokMinimumGlobal => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
