import 'package:injectable/injectable.dart';
import '../../entities/supplier.dart';
import '../../repositories/supplier_repository.dart';

@lazySingleton
class GetAllSupplier {
  final SupplierRepository repository;

  GetAllSupplier(this.repository);

  Future<List<Supplier>> call() => repository.getAllSupplier();
}
