import 'package:injectable/injectable.dart';
import '../../entities/notifikasi.dart';
import '../../repositories/notifikasi_repository.dart';

@lazySingleton
class GetAllNotifikasi {
  final NotifikasiRepository repository;

  GetAllNotifikasi(this.repository);

  Future<List<Notifikasi>> call() {
    return repository.getAllNotifikasi();
  }
}
