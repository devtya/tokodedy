import 'package:injectable/injectable.dart';
import '../../repositories/produk_repository.dart';

@lazySingleton
class DeleteProduk {
  final ProdukRepository repository;
  DeleteProduk(this.repository);

  Future<void> call(String id) => repository.deleteProduk(id);
}
