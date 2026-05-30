import 'package:injectable/injectable.dart';
import '../../entities/produk.dart';
import '../../repositories/produk_repository.dart';

@lazySingleton
class GetAllProduk {
  final ProdukRepository repository;
  GetAllProduk(this.repository);

  Future<List<Produk>> call() => repository.getAllProduk();
}
