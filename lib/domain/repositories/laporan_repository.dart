import '../entities/hutang_piutang.dart';
import '../entities/produk.dart';

class LabaRugiItem {
  final String produkId;
  final String namaProduk;
  final int qtyTerjual;
  final double totalHargaJual;
  final double totalHargaPokok;
  final double labaKotor;
  final double marginPersen;

  const LabaRugiItem({
    required this.produkId,
    required this.namaProduk,
    required this.qtyTerjual,
    required this.totalHargaJual,
    required this.totalHargaPokok,
    required this.labaKotor,
    required this.marginPersen,
  });
}

class ProdukTerlarisItem {
  final String produkId;
  final String namaProduk;
  final int qtyTerjual;
  final double totalPenjualan;

  const ProdukTerlarisItem({
    required this.produkId,
    required this.namaProduk,
    required this.qtyTerjual,
    required this.totalPenjualan,
  });
}

class ArusKasItem {
  final double pemasukan;
  final double pengeluaran;
  final DateTime tanggal;

  const ArusKasItem({
    required this.pemasukan,
    required this.pengeluaran,
    required this.tanggal,
  });
}

abstract class LaporanRepository {
  Future<List<LabaRugiItem>> getLabaRugi({
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<List<ProdukTerlarisItem>> getProdukTerlaris({
    required DateTime startDate,
    required DateTime endDate,
    int limit,
  });

  Future<List<HutangPiutang>> getRingkasanHutang();

  Future<List<ArusKasItem>> getArusKas({
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<List<Produk>> getStokMenipis({int? stokLimit});
}
