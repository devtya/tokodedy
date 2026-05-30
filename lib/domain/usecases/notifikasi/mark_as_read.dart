import 'package:injectable/injectable.dart';
import '../../repositories/notifikasi_repository.dart';

@lazySingleton
class MarkAsRead {
  final NotifikasiRepository repository;

  MarkAsRead(this.repository);

  Future<void> call(String id) {
    return repository.markAsRead(id);
  }
}
