import 'package:injectable/injectable.dart';
import '../../entities/transaksi.dart';
import '../../repositories/transaksi_repository.dart';

@lazySingleton
class GetAllTransaksi {
  final TransaksiRepository repository;
  GetAllTransaksi(this.repository);

  Future<List<Transaksi>> call() => repository.getAllTransaksi();
}
