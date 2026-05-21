import '../../entities/transaksi.dart';
import '../../repositories/transaksi_repository.dart';

class GetLastPenjualanByProduk {
  final TransaksiRepository repository;

  GetLastPenjualanByProduk(this.repository);

  Future<Transaksi?> call(String produkId) {
    return repository.getLastTransaksiByProdukId(produkId);
  }
}
