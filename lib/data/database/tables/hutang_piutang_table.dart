import 'package:drift/drift.dart';

class HutangPiutangTable extends Table {
  TextColumn get id            => text()(); // UUID
  TextColumn get tokoId        => text()(); // UUID FK ke toko
  TextColumn? get transaksiId  => text().nullable()(); // UUID FK ke transaksi
  TextColumn get namaPelanggan => text()();
  RealColumn get jumlah        => real().withDefault(const Constant(0))();
  TextColumn get status => text().withDefault(const Constant('belum_lunas'))(); // 'belum_lunas'|'lunas'
  DateTimeColumn? get tanggalJatuhTempo => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
