import 'package:injectable/injectable.dart';
import '../../entities/kas_harian.dart';
import '../../repositories/kas_harian_repository.dart';

@lazySingleton
class SetModalAwal {
  final KasHarianRepository repository;

  SetModalAwal(this.repository);

  Future<void> call(KasHarian kasHarian) {
    return repository.setModalAwal(kasHarian);
  }
}
