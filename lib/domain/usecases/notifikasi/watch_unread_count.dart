import 'package:injectable/injectable.dart';
import '../../repositories/notifikasi_repository.dart';

@lazySingleton
class WatchUnreadCount {
  final NotifikasiRepository repository;

  WatchUnreadCount(this.repository);

  Stream<int> call() {
    return repository.watchUnreadCount();
  }
}
