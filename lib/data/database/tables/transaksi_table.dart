import 'package:drift/drift.dart';

class TransaksiTable extends Table {
  TextColumn get id         => text()(); // UUID
  TextColumn get tokoId     => text()(); // UUID FK ke toko
  TextColumn? get kasirId   => text().nullable()(); // UUID FK ke profiles (user)
  RealColumn get totalHarga  => real().withDefault(const Constant(0))();
  RealColumn get jumlahBayar => real().withDefault(const Constant(0))();
  RealColumn get kembalian   => real().withDefault(const Constant(0))();
  TextColumn get status => text().withDefault(const Constant('lunas'))(); // 'lunas'|'hutang'
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
