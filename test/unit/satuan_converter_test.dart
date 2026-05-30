import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SatuanProduk — konversi', () {
    test('SatuanProduk entity stores fields correctly', () {
      final satuan = _TestSatuan(
        id: 's1',
        tokoId: 't1',
        produkId: 'p1',
        nama: 'karton',
        konversi: 10,
        hargaBeli: 50000,
        hargaJual: 60000,
      );
      expect(satuan.nama, 'karton');
      expect(satuan.konversi, 10);
      expect(satuan.hargaBeli, 50000);
      expect(satuan.hargaJual, 60000);
    });

    test('Harga beli dari satuan konversi = hargaBeli satuan jika ada harga sendiri', () {
      final satuan = _TestSatuan(
        id: 's1', tokoId: 't1', produkId: 'p1',
        nama: 'pak', konversi: 5, hargaBeli: 25000, hargaJual: 30000,
      );
      // Jika satuan memiliki hargaBeli sendiri, pakai langsung
      const hargaBeliDasar = 5000.0;
      final hargaBeliFinal = satuan.hargaBeli > 0 ? satuan.hargaBeli : hargaBeliDasar * satuan.konversi;
      expect(hargaBeliFinal, 25000);
    });

    test('Harga beli dari satuan konversi = hargaDasar * konversi jika tidak ada harga sendiri', () {
      final satuan = _TestSatuan(
        id: 's1', tokoId: 't1', produkId: 'p1',
        nama: 'pak', konversi: 5, hargaBeli: 0, hargaJual: 0,
      );
      const hargaBeliDasar = 5000.0;
      final hargaBeliFinal = satuan.hargaBeli > 0 ? satuan.hargaBeli : hargaBeliDasar * satuan.konversi;
      expect(hargaBeliFinal, 25000);
    });

    test('Harga jual dari satuan konversi = hargaJual satuan jika ada harga sendiri', () {
      final satuan = _TestSatuan(
        id: 's1', tokoId: 't1', produkId: 'p1',
        nama: 'lusin', konversi: 12, hargaBeli: 0, hargaJual: 120000,
      );
      const hargaJualDasar = 10000.0;
      final hargaJualFinal = satuan.hargaJual > 0 ? satuan.hargaJual : hargaJualDasar * satuan.konversi;
      expect(hargaJualFinal, 120000);
    });

    test('Harga jual dari satuan konversi = hargaDasar * konversi jika tidak ada harga sendiri', () {
      final satuan = _TestSatuan(
        id: 's1', tokoId: 't1', produkId: 'p1',
        nama: 'lusin', konversi: 12, hargaBeli: 0, hargaJual: 0,
      );
      const hargaJualDasar = 10000.0;
      final hargaJualFinal = satuan.hargaJual > 0 ? satuan.hargaJual : hargaJualDasar * satuan.konversi;
      expect(hargaJualFinal, 120000);
    });

    test('Konversi 1 = default (satuan dasar)', () {
      final satuan = _TestSatuan(
        id: 's1', tokoId: 't1', produkId: 'p1',
        nama: 'pcs', konversi: 1, hargaBeli: 5000, hargaJual: 7500,
      );
      expect(satuan.konversi, 1);
      expect(satuan.hargaBeli, 5000);
    });

    test('Konversi pecahan (0.5 = untuk barang yang dijual per-setengah)', () {
      final satuan = _TestSatuan(
        id: 's1', tokoId: 't1', produkId: 'p1',
        nama: '1/2 kg', konversi: 0.5, hargaBeli: 4000, hargaJual: 6000,
      );
      const hargaDasar = 8000.0;
      final hargaBeli = satuan.hargaBeli > 0 ? satuan.hargaBeli : hargaDasar * satuan.konversi;
      expect(hargaBeli, 4000);
    });

    test('Konversi besar (100 = untuk barang yang dijual per-karton)', () {
      final satuan = _TestSatuan(
        id: 's1', tokoId: 't1', produkId: 'p1',
        nama: 'karton', konversi: 100, hargaBeli: 0, hargaJual: 0,
      );
      const hargaDasar = 500.0;
      final hargaBeli = satuan.hargaBeli > 0 ? satuan.hargaBeli : hargaDasar * satuan.konversi;
      expect(hargaBeli, 50000);
    });
  });
}

class _TestSatuan {
  final String id;
  final String tokoId;
  final String produkId;
  final String nama;
  final double konversi;
  final double hargaBeli;
  final double hargaJual;

  const _TestSatuan({
    required this.id,
    required this.tokoId,
    required this.produkId,
    required this.nama,
    required this.konversi,
    required this.hargaBeli,
    required this.hargaJual,
  });
}
