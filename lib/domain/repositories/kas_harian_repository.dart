import '../entities/kas_harian.dart';
import '../entities/pengeluaran_operasional.dart';

abstract class KasHarianRepository {
  Future<KasHarian?> getKasHarianByDate(DateTime date);
  Future<void> setModalAwal(KasHarian kasHarian);
  Future<List<PengeluaranOperasional>> getPengeluaranByDate(DateTime date);
  Future<void> addPengeluaran(PengeluaranOperasional pengeluaran);
  Future<void> deletePengeluaran(String id);
  Future<KasDailySummary> getDailySummary(DateTime date);
}

class KasDailySummary {
  final double modalAwal;
  final double totalOmzet;      // dari transaksi lunas
  final double totalPembelian;  // dari pembelian
  final double totalPengeluaran; // pengeluaran operasional
  final double saldoAkhir;      // modalAwal + totalOmzet - totalPembelian - totalPengeluaran
  final List<PengeluaranOperasional> pengeluaranList;

  const KasDailySummary({
    required this.modalAwal,
    required this.totalOmzet,
    required this.totalPembelian,
    required this.totalPengeluaran,
    required this.saldoAkhir,
    required this.pengeluaranList,
  });
}
