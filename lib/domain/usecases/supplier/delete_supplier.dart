import 'package:injectable/injectable.dart';
import '../../repositories/supplier_repository.dart';

@lazySingleton
class DeleteSupplier {
  final SupplierRepository repository;

  DeleteSupplier(this.repository);

  Future<void> call(String id) => repository.deleteSupplier(id);
}
