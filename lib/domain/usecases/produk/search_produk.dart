import 'package:injectable/injectable.dart';
import '../../entities/produk.dart';
import '../../repositories/produk_repository.dart';

@lazySingleton
class SearchProduk {
  final ProdukRepository repository;
  SearchProduk(this.repository);

  Future<List<Produk>> call(String query) => repository.searchProduk(query);
}
