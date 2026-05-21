import '../../repositories/produk_repository.dart';

class DeleteSatuan {
  final ProdukRepository repository;
  DeleteSatuan(this.repository);

  Future<void> call(String id) => repository.deleteSatuan(id);
}
