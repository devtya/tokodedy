import 'package:drift/drift.dart';

class SatuanProdukTable extends Table {
  TextColumn get id       => text()(); // UUID
  TextColumn get produkId => text()(); // UUID FK ke produk
  TextColumn get nama     => text()();
  // CATATAN: konversi wajib > 0. Konversi 0 atau negatif akan menghasilkan
  // Infinity/NaN saat dipakai sebagai pembagi di kalkulasi harga modal
  // (lihat price_validation_dialog.dart -> baseCost = hargaBeliSatuan / konversi).
  RealColumn get konversi => real().withDefault(const Constant(1))();
  RealColumn get hargaBeli => real().withDefault(const Constant(0))();
  RealColumn get hargaJual => real().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        // Cegah duplikat nama satuan untuk produk yang sama di level database.
        // Ini akar masalah dialog validasi salah skip unit saat ada nama
        // satuan kembar (mis. dua row "PAK" untuk produk yang sama).
        {produkId, nama},
      ];

  // Konversi wajib > 0 agar tidak menghasilkan Infinity/NaN saat dipakai
  // sebagai pembagi di kalkulasi harga modal.
  @override
  List<String> get customConstraints => [
        'CHECK (konversi > 0)',
      ];
}
