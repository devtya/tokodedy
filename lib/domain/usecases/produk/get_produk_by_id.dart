import 'package:injectable/injectable.dart';
import '../../entities/produk.dart';
import '../../repositories/produk_repository.dart';

@lazySingleton
class GetProdukById {
  final ProdukRepository repository;

  GetProdukById(this.repository);

  Future<Produk?> call(String id) {
    return repository.getProdukById(id);
  }
}
