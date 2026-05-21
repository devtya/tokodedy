import '../../entities/produk.dart';
import '../../repositories/produk_repository.dart';

class AddProduk {
  final ProdukRepository repository;
  AddProduk(this.repository);

  Future<String> call(Produk produk) => repository.addProduk(produk);
}
