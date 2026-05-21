import '../../repositories/produk_repository.dart';

class DeleteProduk {
  final ProdukRepository repository;
  DeleteProduk(this.repository);

  Future<void> call(String id) => repository.deleteProduk(id);
}
