import 'package:injectable/injectable.dart';
import '../../repositories/produk_repository.dart';

@lazySingleton
class DeleteSatuanByProdukId {
  final ProdukRepository repository;
  DeleteSatuanByProdukId(this.repository);

  Future<void> call(String produkId) =>
      repository.deleteSatuanByProdukId(produkId);
}
