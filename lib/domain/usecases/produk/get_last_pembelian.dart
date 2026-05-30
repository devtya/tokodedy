import 'package:injectable/injectable.dart';
import '../../entities/pembelian.dart';
import '../../repositories/pembelian_repository.dart';

@lazySingleton
class GetLastPembelianByProduk {
  final PembelianRepository repository;

  GetLastPembelianByProduk(this.repository);

  Future<Pembelian?> call(String produkId) {
    return repository.getLastPembelianByProdukId(produkId);
  }
}
