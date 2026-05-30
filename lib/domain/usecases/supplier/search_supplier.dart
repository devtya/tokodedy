import 'package:injectable/injectable.dart';
import '../../entities/supplier.dart';
import '../../repositories/supplier_repository.dart';

@lazySingleton
class SearchSupplier {
  final SupplierRepository repository;

  SearchSupplier(this.repository);

  Future<List<Supplier>> call(String query) => repository.searchSupplier(query);
}
