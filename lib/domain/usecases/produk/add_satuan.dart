import 'package:injectable/injectable.dart';
import '../../entities/satuan_produk.dart';
import '../../repositories/produk_repository.dart';

@lazySingleton
class AddSatuan {
  final ProdukRepository repository;
  AddSatuan(this.repository);

  Future<void> call(SatuanProduk satuan) => repository.addSatuan(satuan);
}
