import '../../repositories/supplier_repository.dart';

class DeleteSupplier {
  final SupplierRepository repository;

  DeleteSupplier(this.repository);

  Future<void> call(String id) => repository.deleteSupplier(id);
}
