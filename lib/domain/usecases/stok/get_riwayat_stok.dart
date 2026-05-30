import 'package:injectable/injectable.dart';
import '../../entities/riwayat_stok.dart';
import '../../repositories/riwayat_stok_repository.dart';

@lazySingleton
class GetRiwayatStok {
  final RiwayatStokRepository repository;
  GetRiwayatStok(this.repository);

  Future<List<RiwayatStok>> call(String produkId) =>
      repository.getRiwayatByProdukId(produkId);
}
