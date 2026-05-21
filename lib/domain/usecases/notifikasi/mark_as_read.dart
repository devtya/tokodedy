import '../../repositories/notifikasi_repository.dart';

class MarkAsRead {
  final NotifikasiRepository repository;

  MarkAsRead(this.repository);

  Future<void> call(String id) {
    return repository.markAsRead(id);
  }
}
