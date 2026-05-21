import '../../entities/transaksi.dart';
import '../../repositories/transaksi_repository.dart';

class GetTransaksiById {
  final TransaksiRepository repository;
  GetTransaksiById(this.repository);

  Future<Transaksi?> call(String id) => repository.getTransaksiById(id);
}
