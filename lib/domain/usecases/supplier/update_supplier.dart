import 'package:injectable/injectable.dart';
import '../../entities/supplier.dart';
import '../../repositories/supplier_repository.dart';

@lazySingleton
class UpdateSupplier {
  final SupplierRepository repository;

  UpdateSupplier(this.repository);

  Future<void> call(Supplier supplier) => repository.updateSupplier(supplier);
}
