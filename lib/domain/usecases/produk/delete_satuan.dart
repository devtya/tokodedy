import 'package:injectable/injectable.dart';
import '../../repositories/produk_repository.dart';

@lazySingleton
class DeleteSatuan {
  final ProdukRepository repository;
  DeleteSatuan(this.repository);

  Future<void> call(String id) => repository.deleteSatuan(id);
}
