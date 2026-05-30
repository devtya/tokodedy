import 'package:injectable/injectable.dart';
import '../../entities/transaksi.dart';
import '../../repositories/transaksi_repository.dart';

@lazySingleton
class GetTransaksiById {
  final TransaksiRepository repository;
  GetTransaksiById(this.repository);

  Future<Transaksi?> call(String id) => repository.getTransaksiById(id);
}
