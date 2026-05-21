import '../../entities/supplier.dart';
import '../../repositories/supplier_repository.dart';

class AddSupplier {
  final SupplierRepository repository;

  AddSupplier(this.repository);

  Future<String> call(Supplier supplier) => repository.addSupplier(supplier);
}
