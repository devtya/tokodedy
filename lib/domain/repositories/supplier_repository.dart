import '../entities/supplier.dart';

abstract class SupplierRepository {
  Future<List<Supplier>> getAllSupplier();
  Future<Supplier?> getSupplierById(String id);
  Future<List<Supplier>> searchSupplier(String query);
  Future<String> addSupplier(Supplier supplier);
  Future<void> updateSupplier(Supplier supplier);
  Future<void> deleteSupplier(String id);
}
