import 'package:drift/drift.dart';

class RiwayatStokTable extends Table {
  TextColumn get id        => text()(); // UUID
  TextColumn get tokoId    => text()(); // UUID FK ke toko
  TextColumn get produkId  => text()(); // UUID FK ke produk
  TextColumn get tipe      => text()(); // 'masuk'|'keluar'|'koreksi'
  IntColumn get jumlah     => integer().withDefault(const Constant(0))();
  TextColumn? get keterangan => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
