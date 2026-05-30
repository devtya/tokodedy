import 'package:injectable/injectable.dart';
import '../../entities/supplier.dart';
import '../../repositories/supplier_repository.dart';

@lazySingleton
class AddSupplier {
  final SupplierRepository repository;

  AddSupplier(this.repository);

  Future<String> call(Supplier supplier) => repository.addSupplier(supplier);
}
