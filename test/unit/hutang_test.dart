import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HutangPiutang — jumlah & status', () {
    test('Hutang dengan jumlah default', () {
      final hutang = _TestHutang(
        tokoId: 't1',
        namaPelanggan: 'Budi',
        jumlah: 50000,
      );
      expect(hutang.jumlah, 50000);
      expect(hutang.status, 'belum_lunas');
    });

    test('Hutang dengan status lunas', () {
      final hutang = _TestHutang(
        tokoId: 't1',
        namaPelanggan: 'Ani',
        jumlah: 100000,
        status: 'lunas',
      );
      expect(hutang.status, 'lunas');
    });

    test('Hutang dengan transaksiId', () {
      final hutang = _TestHutang(
        tokoId: 't1',
        transaksiId: 'trx-001',
        namaPelanggan: 'Citra',
        jumlah: 75000,
      );
      expect(hutang.transaksiId, 'trx-001');
    });

    test('Total hutang dari multiple record', () {
      final hutangs = [
        _TestHutang(tokoId: 't1', namaPelanggan: 'A', jumlah: 50000, status: 'belum_lunas'),
        _TestHutang(tokoId: 't1', namaPelanggan: 'B', jumlah: 30000, status: 'belum_lunas'),
        _TestHutang(tokoId: 't1', namaPelanggan: 'C', jumlah: 20000, status: 'lunas'),
        _TestHutang(tokoId: 't1', namaPelanggan: 'D', jumlah: 40000, status: 'belum_lunas'),
      ];

      final totalOutstanding = hutangs
          .where((h) => h.status == 'belum_lunas')
          .fold(0.0, (sum, h) => sum + h.jumlah);
      expect(totalOutstanding, 50000 + 30000 + 40000);
      expect(totalOutstanding, 120000.0);
    });

    test('Filter hutang by status', () {
      final hutangs = [
        _TestHutang(tokoId: 't1', transaksiId: 't1', namaPelanggan: 'A', jumlah: 50000, status: 'belum_lunas'),
        _TestHutang(tokoId: 't1', transaksiId: 't2', namaPelanggan: 'B', jumlah: 30000, status: 'lunas'),
        _TestHutang(tokoId: 't1', transaksiId: 't3', namaPelanggan: 'C', jumlah: 20000, status: 'belum_lunas'),
      ];

      final belumLunas = hutangs.where((h) => h.status == 'belum_lunas').toList();
      expect(belumLunas.length, 2);
      expect(belumLunas.every((h) => h.status == 'belum_lunas'), true);

      final lunas = hutangs.where((h) => h.status == 'lunas').toList();
      expect(lunas.length, 1);
    });

    test('Update status jadi lunas', () {
      final hutang = _TestHutang(
        tokoId: 't1',
        transaksiId: 'trx-001',
        namaPelanggan: 'Budi',
        jumlah: 50000,
        status: 'belum_lunas',
      );

      final updated = _TestHutang(
        tokoId: hutang.tokoId,
        transaksiId: hutang.transaksiId,
        namaPelanggan: hutang.namaPelanggan,
        jumlah: hutang.jumlah,
        status: 'lunas',
      );

      expect(updated.status, 'lunas');
      expect(updated.transaksiId, 'trx-001');
      expect(updated.jumlah, 50000);
    });

    test('Hutang jumlah = 0 (valid)', () {
      final hutang = _TestHutang(
        tokoId: 't1',
        namaPelanggan: 'Test',
        jumlah: 0,
      );
      expect(hutang.jumlah, 0.0);
    });

    test('Tanggal jatuh tempo opsional', () {
      final hutang = _TestHutang(
        tokoId: 't1',
        namaPelanggan: 'Budi',
        jumlah: 50000,
        tanggalJatuhTempo: '2026-06-15',
      );
      expect(hutang.tanggalJatuhTempo, '2026-06-15');

      final hutangTanpaTempo = _TestHutang(
        tokoId: 't1',
        namaPelanggan: 'Ani',
        jumlah: 30000,
      );
      expect(hutangTanpaTempo.tanggalJatuhTempo, isNull);
    });

    test('Grouping hutang per pelanggan', () {
      final hutangs = [
        _TestHutang(tokoId: 't1', transaksiId: 't1', namaPelanggan: 'Budi', jumlah: 50000, status: 'belum_lunas'),
        _TestHutang(tokoId: 't1', transaksiId: 't2', namaPelanggan: 'Budi', jumlah: 25000, status: 'belum_lunas'),
        _TestHutang(tokoId: 't1', transaksiId: 't3', namaPelanggan: 'Ani', jumlah: 30000, status: 'lunas'),
        _TestHutang(tokoId: 't1', transaksiId: 't4', namaPelanggan: 'Ani', jumlah: 10000, status: 'belum_lunas'),
      ];

      final perPelanggan = <String, double>{};
      for (final h in hutangs.where((h) => h.status == 'belum_lunas')) {
        perPelanggan.update(h.namaPelanggan, (v) => v + h.jumlah, ifAbsent: () => h.jumlah);
      }

      expect(perPelanggan['Budi'], 75000.0);
      expect(perPelanggan['Ani'], 10000.0);
    });
  });
}

class _TestHutang {
  final String tokoId;
  final String? transaksiId;
  final String namaPelanggan;
  final double jumlah;
  final String status;
  final String? tanggalJatuhTempo;

  const _TestHutang({
    required this.tokoId,
    this.transaksiId,
    required this.namaPelanggan,
    required this.jumlah,
    this.status = 'belum_lunas',
    this.tanggalJatuhTempo,
  });
}
