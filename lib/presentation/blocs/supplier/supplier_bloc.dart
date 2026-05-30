import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/supplier/add_supplier.dart';
import '../../../domain/usecases/supplier/delete_supplier.dart';
import '../../../domain/usecases/supplier/get_all_supplier.dart';
import '../../../domain/usecases/supplier/search_supplier.dart';
import '../../../domain/usecases/supplier/update_supplier.dart';
import 'supplier_event.dart';
import 'supplier_state.dart';

@injectable
class SupplierBloc extends Bloc<SupplierEvent, SupplierState> {
  final GetAllSupplier getAllSupplier;
  final SearchSupplier searchSupplier;
  final AddSupplier addSupplier;
  final UpdateSupplier updateSupplier;
  final DeleteSupplier deleteSupplier;

  SupplierBloc({
    required this.getAllSupplier,
    required this.searchSupplier,
    required this.addSupplier,
    required this.updateSupplier,
    required this.deleteSupplier,
  }) : super(SupplierInitial()) {
    on<LoadSupplier>(_onLoad);
    on<SearchSupplierEvent>(_onSearch);
    on<AddSupplierEvent>(_onAdd);
    on<UpdateSupplierEvent>(_onUpdate);
    on<DeleteSupplierEvent>(_onDelete);
  }

  Future<void> _onLoad(LoadSupplier event, Emitter<SupplierState> emit) async {
    emit(SupplierLoading());
    try {
      final list = await getAllSupplier();
      emit(SupplierLoaded(list));
    } catch (e) {
      emit(SupplierError(e.toString()));
    }
  }

  Future<void> _onSearch(
    SearchSupplierEvent event,
    Emitter<SupplierState> emit,
  ) async {
    emit(SupplierLoading());
    try {
      final list = await searchSupplier(event.query);
      emit(SupplierLoaded(list, searchQuery: event.query));
    } catch (e) {
      emit(SupplierError(e.toString()));
    }
  }

  Future<void> _onAdd(
    AddSupplierEvent event,
    Emitter<SupplierState> emit,
  ) async {
    try {
      await addSupplier(event.supplier);
      emit(const SupplierOperationSuccess('Supplier berhasil ditambahkan'));
      add(LoadSupplier());
    } catch (e) {
      emit(SupplierError(e.toString()));
    }
  }

  Future<void> _onUpdate(
    UpdateSupplierEvent event,
    Emitter<SupplierState> emit,
  ) async {
    try {
      await updateSupplier(event.supplier);
      emit(const SupplierOperationSuccess('Supplier berhasil diupdate'));
      add(LoadSupplier());
    } catch (e) {
      emit(SupplierError(e.toString()));
    }
  }

  Future<void> _onDelete(
    DeleteSupplierEvent event,
    Emitter<SupplierState> emit,
  ) async {
    try {
      await deleteSupplier(event.id);
      emit(const SupplierOperationSuccess('Supplier berhasil dihapus'));
      add(LoadSupplier());
    } catch (e) {
      emit(SupplierError(e.toString()));
    }
  }
}
