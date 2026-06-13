import 'package:injectable/injectable.dart';

import '../../repositories/produk_repository.dart';

@lazySingleton
class ArchiveProduk {
  final ProdukRepository repository;

  ArchiveProduk(this.repository);

  Future<void> call(String id, bool isArchived) async {
    return await repository.archiveProduk(id, isArchived);
  }
}
