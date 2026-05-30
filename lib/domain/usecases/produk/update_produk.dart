import 'package:injectable/injectable.dart';
import '../../entities/produk.dart';
import '../../repositories/produk_repository.dart';

@lazySingleton
class UpdateProduk {
  final ProdukRepository repository;
  UpdateProduk(this.repository);

  Future<void> call(Produk produk) => repository.updateProduk(produk);
}
