import 'package:injectable/injectable.dart';
import '../../entities/satuan_produk.dart';
import '../../repositories/produk_repository.dart';

@lazySingleton
class UpdateSatuan {
  final ProdukRepository repository;
  UpdateSatuan(this.repository);

  Future<void> call(SatuanProduk satuan) => repository.updateSatuan(satuan);
}
