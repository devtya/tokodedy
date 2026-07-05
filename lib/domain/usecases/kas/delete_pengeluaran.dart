import 'package:injectable/injectable.dart';
import '../../repositories/kas_harian_repository.dart';

@lazySingleton
class DeletePengeluaran {
  final KasHarianRepository repository;

  DeletePengeluaran(this.repository);

  Future<void> call(String id) {
    return repository.deletePengeluaran(id);
  }
}
