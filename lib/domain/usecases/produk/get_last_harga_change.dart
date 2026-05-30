import 'package:injectable/injectable.dart';
import '../../entities/notifikasi.dart';
import '../../repositories/notifikasi_repository.dart';

@lazySingleton
class GetLastHargaChangeByProduk {
  final NotifikasiRepository repository;

  GetLastHargaChangeByProduk(this.repository);

  Future<Notifikasi?> call(String namaProduk) async {
    final results = await repository.getNotifikasiByJudul(
      'Harga Beli Berubah - $namaProduk',
    );
    return results.isNotEmpty ? results.first : null;
  }
}
