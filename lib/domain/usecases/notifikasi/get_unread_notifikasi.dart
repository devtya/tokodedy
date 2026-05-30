import 'package:injectable/injectable.dart';
import '../../entities/notifikasi.dart';
import '../../repositories/notifikasi_repository.dart';

@lazySingleton
class GetUnreadNotifikasi {
  final NotifikasiRepository repository;

  GetUnreadNotifikasi(this.repository);

  Future<List<Notifikasi>> call() {
    return repository.getUnreadNotifikasi();
  }
}
