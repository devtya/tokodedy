import 'package:equatable/equatable.dart';

import '../../../domain/entities/supplier.dart';

abstract class SupplierEvent extends Equatable {
  const SupplierEvent();

  @override
  List<Object?> get props => [];
}

class LoadSupplier extends SupplierEvent {}

class SearchSupplierEvent extends SupplierEvent {
  final String query;
  const SearchSupplierEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class AddSupplierEvent extends SupplierEvent {
  final Supplier supplier;
  const AddSupplierEvent(this.supplier);

  @override
  List<Object?> get props => [supplier];
}

class UpdateSupplierEvent extends SupplierEvent {
  final Supplier supplier;
  const UpdateSupplierEvent(this.supplier);

  @override
  List<Object?> get props => [supplier];
}

class DeleteSupplierEvent extends SupplierEvent {
  final String id;
  const DeleteSupplierEvent(this.id);

  @override
  List<Object?> get props => [id];
}
