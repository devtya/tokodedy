import 'package:injectable/injectable.dart';
import '../../entities/pengeluaran_operasional.dart';
import '../../repositories/kas_harian_repository.dart';

@lazySingleton
class AddPengeluaran {
  final KasHarianRepository repository;

  AddPengeluaran(this.repository);

  Future<void> call(PengeluaranOperasional pengeluaran) {
    return repository.addPengeluaran(pengeluaran);
  }
}
