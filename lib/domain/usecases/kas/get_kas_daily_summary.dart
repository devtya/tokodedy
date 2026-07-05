import 'package:injectable/injectable.dart';
import '../../repositories/kas_harian_repository.dart';

@lazySingleton
class GetKasDailySummary {
  final KasHarianRepository repository;

  GetKasDailySummary(this.repository);

  Future<KasDailySummary> call(DateTime date) {
    return repository.getDailySummary(date);
  }
}
