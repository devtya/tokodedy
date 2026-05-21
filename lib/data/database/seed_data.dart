import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'app_database.dart';

Future<void> seedDatabase(AppDatabase db) async {
  final existing = await db.select(db.produkTable).get();
  if (existing.isNotEmpty) return;

  const uuid = Uuid();
  const defaultTokoId = '1';

  // ── Seeding Products ──
  final productIds = List.generate(_produkData.length, (_) => uuid.v4());

  for (int i = 0; i < _produkData.length; i++) {
    final p = _produkData[i];
    await db.into(db.produkTable).insert(
      ProdukTableCompanion.insert(
        id: productIds[i],
        tokoId: defaultTokoId,
        nama: p.nama,
        barcode: Value(p.barcode),
        hargaBeli: Value(p.hargaBeli),
        hargaJual: Value(p.hargaJual),
        stok: Value(p.stok),
        kategori: Value(p.kategori),
        satuan: Value(p.satuan),
      ),
    );
  }

  // ── Seeding Satuan Produk (Multi-Satuan) ──
  for (final s in _satuanData) {
    await db.into(db.satuanProdukTable).insert(
      SatuanProdukTableCompanion.insert(
        id: uuid.v4(),
        tokoId: defaultTokoId,
        produkId: productIds[s.produkIndex],
        nama: s.nama,
        konversi: Value(s.konversi),
        hargaBeli: Value(s.hargaBeli),
        hargaJual: Value(s.hargaJual),
      ),
    );
  }

  // ── Seeding Suppliers ──
  final existingSupplier = await db.select(db.supplierTable).get();
  if (existingSupplier.isNotEmpty) return;

  for (final s in _supplierData) {
    await db.into(db.supplierTable).insert(
      SupplierTableCompanion.insert(
        id: uuid.v4(),
        tokoId: defaultTokoId,
        nama: s.nama,
        telepon: Value(s.telepon),
        alamat: Value(s.alamat),
      ),
    );
  }
}

class _SeedProduk {
  final String nama;
  final String barcode;
  final double hargaBeli;
  final double hargaJual;
  final int stok;
  final String kategori;
  final String satuan;

  const _SeedProduk({
    required this.nama,
    required this.barcode,
    required this.hargaBeli,
    required this.hargaJual,
    required this.stok,
    required this.kategori,
    required this.satuan,
  });
}

class _SeedSatuan {
  final int produkIndex;
  final String nama;
  final double konversi;
  final double hargaBeli;
  final double hargaJual;

  const _SeedSatuan({
    required this.produkIndex,
    required this.nama,
    required this.konversi,
    required this.hargaBeli,
    required this.hargaJual,
  });
}

class _SeedSupplier {
  final String nama;
  final String telepon;
  final String alamat;

  const _SeedSupplier({
    required this.nama,
    required this.telepon,
    required this.alamat,
  });
}

List<_SeedProduk> get _produkData => const [
  _SeedProduk(nama: 'Beras Premium 5kg', barcode: '8991002111111', hargaBeli: 65000, hargaJual: 72000, stok: 50, kategori: 'Sembako', satuan: 'karung'),
  _SeedProduk(nama: 'Minyak Goreng Bimoli 1L', barcode: '8991002222222', hargaBeli: 14000, hargaJual: 16000, stok: 36, kategori: 'Sembako', satuan: 'btl'),
  _SeedProduk(nama: 'Gula Pasir 1kg', barcode: '8991002333333', hargaBeli: 15000, hargaJual: 17500, stok: 40, kategori: 'Sembako', satuan: 'kg'),
  _SeedProduk(nama: 'Telur Ayam 1kg', barcode: '8991002444444', hargaBeli: 25000, hargaJual: 28000, stok: 25, kategori: 'Sembako', satuan: 'kg'),
  _SeedProduk(nama: 'Indomie Goreng', barcode: '089686010947', hargaBeli: 2600, hargaJual: 3500, stok: 200, kategori: 'Mie Instan', satuan: 'pcs'),
  _SeedProduk(nama: 'Indomie Kari Ayam', barcode: '089686010220', hargaBeli: 2600, hargaJual: 3500, stok: 160, kategori: 'Mie Instan', satuan: 'pcs'),
  _SeedProduk(nama: 'Mie Sedaap Goreng', barcode: '8998866200123', hargaBeli: 2500, hargaJual: 3400, stok: 120, kategori: 'Mie Instan', satuan: 'pcs'),
  _SeedProduk(nama: 'Aqua 600ml', barcode: '8886008101024', hargaBeli: 2500, hargaJual: 3500, stok: 120, kategori: 'Minuman', satuan: 'btl'),
  _SeedProduk(nama: 'Aqua 1500ml', barcode: '8886008101048', hargaBeli: 4000, hargaJual: 5500, stok: 48, kategori: 'Minuman', satuan: 'btl'),
  _SeedProduk(nama: 'Teh Botol Sosro 450ml', barcode: '8991002345678', hargaBeli: 4000, hargaJual: 5000, stok: 72, kategori: 'Minuman', satuan: 'btl'),
  _SeedProduk(nama: 'Coca Cola 390ml', barcode: '8888002076009', hargaBeli: 4500, hargaJual: 6000, stok: 48, kategori: 'Minuman', satuan: 'btl'),
  _SeedProduk(nama: 'Kopi Kapal Api 25g', barcode: '8991002666666', hargaBeli: 1000, hargaJual: 1500, stok: 100, kategori: 'Minuman', satuan: 'sachet'),
  _SeedProduk(nama: 'Good Day Cappuccino 25g', barcode: '8991002777000', hargaBeli: 1200, hargaJual: 1800, stok: 80, kategori: 'Minuman', satuan: 'sachet'),
  _SeedProduk(nama: 'Surya 16', barcode: '8999909301016', hargaBeli: 22000, hargaJual: 25000, stok: 30, kategori: 'Rokok', satuan: 'bungkus'),
  _SeedProduk(nama: 'Djarum Super 12', barcode: '8999909101012', hargaBeli: 17500, hargaJual: 21000, stok: 50, kategori: 'Rokok', satuan: 'bungkus'),
  _SeedProduk(nama: 'Sabun Mandi Lifebuoy 75g', barcode: '8991002888888', hargaBeli: 3500, hargaJual: 4500, stok: 48, kategori: 'Personal Care', satuan: 'pcs'),
  _SeedProduk(nama: 'Shampo Sunsilk 9ml', barcode: '8991002999999', hargaBeli: 800, hargaJual: 1100, stok: 72, kategori: 'Personal Care', satuan: 'sachet'),
  _SeedProduk(nama: 'Pasta Gigi Pepsodent 75g', barcode: '8999999028701', hargaBeli: 4000, hargaJual: 6000, stok: 36, kategori: 'Personal Care', satuan: 'pcs'),
  _SeedProduk(nama: 'Kecap Manis ABC 600ml', barcode: '8991002220000', hargaBeli: 12000, hargaJual: 15000, stok: 20, kategori: 'Bumbu Dapur', satuan: 'btl'),
  _SeedProduk(nama: 'Saos Sambal ABC 335ml', barcode: '8991002330000', hargaBeli: 8000, hargaJual: 10000, stok: 24, kategori: 'Bumbu Dapur', satuan: 'btl'),
  _SeedProduk(nama: 'Tisu Tessa 250 sheets', barcode: '8992907550250', hargaBeli: 12000, hargaJual: 16000, stok: 18, kategori: 'Rumah Tangga', satuan: 'pak'),
  _SeedProduk(nama: 'Deterjen Rinso 800g', barcode: '8999999017897', hargaBeli: 10000, hargaJual: 13000, stok: 24, kategori: 'Rumah Tangga', satuan: 'pcs'),
  _SeedProduk(nama: 'Susu Ultra Milk Full Cream 1L', barcode: '8998009010101', hargaBeli: 15000, hargaJual: 18000, stok: 24, kategori: 'Susu', satuan: 'pcs'),
  _SeedProduk(nama: 'Susu Indomilk Coklat 250ml', barcode: '8998009020202', hargaBeli: 4000, hargaJual: 5500, stok: 48, kategori: 'Susu', satuan: 'pcs'),
  _SeedProduk(nama: 'Baterai ABC AA', barcode: '8991234560001', hargaBeli: 3000, hargaJual: 4500, stok: 36, kategori: 'Lain-Lain', satuan: 'pcs'),
];

List<_SeedSatuan> get _satuanData => const [
  _SeedSatuan(produkIndex: 1, nama: 'KARTON', konversi: 12.0, hargaBeli: 168000, hargaJual: 192000),
  _SeedSatuan(produkIndex: 4, nama: 'DUS', konversi: 40.0, hargaBeli: 104000, hargaJual: 140000),
  _SeedSatuan(produkIndex: 5, nama: 'DUS', konversi: 40.0, hargaBeli: 104000, hargaJual: 140000),
  _SeedSatuan(produkIndex: 6, nama: 'DUS', konversi: 40.0, hargaBeli: 100000, hargaJual: 136000),
  _SeedSatuan(produkIndex: 7, nama: 'DUS', konversi: 24.0, hargaBeli: 60000, hargaJual: 78000),
  _SeedSatuan(produkIndex: 8, nama: 'DUS', konversi: 12.0, hargaBeli: 48000, hargaJual: 66000),
  _SeedSatuan(produkIndex: 9, nama: 'KRAT', konversi: 24.0, hargaBeli: 96000, hargaJual: 120000),
  _SeedSatuan(produkIndex: 10, nama: 'DUS', konversi: 12.0, hargaBeli: 54000, hargaJual: 72000),
  _SeedSatuan(produkIndex: 11, nama: 'RENCENG', konversi: 10.0, hargaBeli: 10000, hargaJual: 15000),
  _SeedSatuan(produkIndex: 12, nama: 'RENCENG', konversi: 10.0, hargaBeli: 12000, hargaJual: 18000),
  _SeedSatuan(produkIndex: 14, nama: 'SLOP', konversi: 10.0, hargaBeli: 175000, hargaJual: 210000),
  _SeedSatuan(produkIndex: 15, nama: 'LUSIN', konversi: 12.0, hargaBeli: 42000, hargaJual: 54000),
  _SeedSatuan(produkIndex: 16, nama: 'RENCENG', konversi: 12.0, hargaBeli: 9600, hargaJual: 13200),
  _SeedSatuan(produkIndex: 17, nama: 'LUSIN', konversi: 12.0, hargaBeli: 48000, hargaJual: 72000),
  _SeedSatuan(produkIndex: 20, nama: 'DUS', konversi: 6.0, hargaBeli: 72000, hargaJual: 96000),
  _SeedSatuan(produkIndex: 21, nama: 'DUS', konversi: 12.0, hargaBeli: 120000, hargaJual: 156000),
  _SeedSatuan(produkIndex: 22, nama: 'DUS', konversi: 12.0, hargaBeli: 180000, hargaJual: 216000),
  _SeedSatuan(produkIndex: 23, nama: 'DUS', konversi: 24.0, hargaBeli: 96000, hargaJual: 132000),
  _SeedSatuan(produkIndex: 24, nama: 'LUSIN', konversi: 12.0, hargaBeli: 36000, hargaJual: 54000),
];

List<_SeedSupplier> get _supplierData => const [
  _SeedSupplier(nama: 'UD Sembako Jaya', telepon: '081234567890', alamat: 'Jl. Merdeka No. 123, Jakarta'),
  _SeedSupplier(nama: 'CV Maju Makmur', telepon: '082345678901', alamat: 'Jl. Sudirman No. 45, Bandung'),
  _SeedSupplier(nama: 'PT Indofood Sukses Makmur', telepon: '0800123456', alamat: 'Jl. Jend. Sudirman Kav. 76-78, Jakarta'),
  _SeedSupplier(nama: 'Toko Sinar Rejeki', telepon: '085678901234', alamat: 'Jl. Diponegoro No. 67, Surabaya'),
  _SeedSupplier(nama: 'CV Aqua Golden Mississippi', telepon: '081122334455', alamat: 'Jl Raya Cibitung No. 10, Bekasi'),
  _SeedSupplier(nama: 'PT Unilever Indonesia', telepon: '0800100200', alamat: 'Grha Unilever, BSD, Tangerang'),
];
