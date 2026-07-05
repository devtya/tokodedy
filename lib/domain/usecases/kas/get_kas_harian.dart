import 'package:injectable/injectable.dart';
import '../../entities/kas_harian.dart';
import '../../repositories/kas_harian_repository.dart';

@lazySingleton
class GetKasHarian {
  final KasHarianRepository repository;

  GetKasHarian(this.repository);

  Future<KasHarian?> call(DateTime date) {
    return repository.getKasHarianByDate(date);
  }
}
