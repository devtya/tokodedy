import 'package:injectable/injectable.dart';

import '../../entities/riwayat_perubahan.dart';
import '../../repositories/produk_repository.dart';

@lazySingleton
class GetRiwayatPerubahanByProduk {
  final ProdukRepository repository;

  GetRiwayatPerubahanByProduk(this.repository);

  Future<List<RiwayatPerubahan>> call(String produkId) async {
    return await repository.getRiwayatPerubahan(produkId);
  }
}
