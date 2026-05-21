import '../../entities/produk.dart';
import '../../repositories/produk_repository.dart';

class GetProdukById {
  final ProdukRepository repository;

  GetProdukById(this.repository);

  Future<Produk?> call(String id) {
    return repository.getProdukById(id);
  }
}
