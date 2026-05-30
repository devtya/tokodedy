import 'package:injectable/injectable.dart';
import '../../entities/produk.dart';
import '../../repositories/produk_repository.dart';

@lazySingleton
class GetProdukByBarcode {
  final ProdukRepository repository;
  GetProdukByBarcode(this.repository);

  Future<Produk?> call(String barcode) =>
      repository.getProdukByBarcode(barcode);
}
