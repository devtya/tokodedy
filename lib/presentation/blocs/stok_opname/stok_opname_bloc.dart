import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../domain/usecases/produk/get_all_produk.dart';
import '../../../../domain/usecases/stok/stok_opname.dart';
import 'stok_opname_event.dart';
import 'stok_opname_state.dart';

@injectable
class StokOpnameBloc extends Bloc<StokOpnameEvent, StokOpnameState> {
  final GetAllProduk _getAllProduk;
  final StokOpname _stokOpname;

  StokOpnameBloc(this._getAllProduk, this._stokOpname) : super(StokOpnameInitial()) {
    on<LoadStokOpname>(_onLoadStokOpname);
    on<UpdateStokFisik>(_onUpdateStokFisik);
    on<SearchStokOpname>(_onSearchStokOpname);
    on<FilterHanyaSelisih>(_onFilterHanyaSelisih);
    on<SimpanStokOpname>(_onSimpanStokOpname);
  }

  Future<void> _onLoadStokOpname(LoadStokOpname event, Emitter<StokOpnameState> emit) async {
    emit(StokOpnameLoading());
    try {
      final produkList = await _getAllProduk();
      final activeProduk = produkList.where((p) => !p.isArchived).toList();
      
      final items = activeProduk.map((p) => StokOpnameItem(
        produkId: p.id!,
        namaProduk: p.nama,
        satuan: p.satuan ?? '-',
        stokSistem: p.stok,
        stokFisik: p.stok,
      )).toList();

      // Sort by nama
      items.sort((a, b) => a.namaProduk.toLowerCase().compareTo(b.namaProduk.toLowerCase()));

      emit(StokOpnameLoaded(
        items: items,
        filteredItems: items,
      ));
    } catch (e) {
      emit(StokOpnameError(e.toString()));
    }
  }

  void _onUpdateStokFisik(UpdateStokFisik event, Emitter<StokOpnameState> emit) {
    if (state is StokOpnameLoaded) {
      final currentState = state as StokOpnameLoaded;
      
      final newItems = currentState.items.map((item) {
        if (item.produkId == event.produkId) {
          return item.copyWith(stokFisik: event.stokFisik);
        }
        return item;
      }).toList();

      emit(currentState.copyWith(
        items: newItems,
        filteredItems: _applyFilters(newItems, currentState.searchQuery, currentState.hanyaSelisih),
      ));
    }
  }

  void _onSearchStokOpname(SearchStokOpname event, Emitter<StokOpnameState> emit) {
    if (state is StokOpnameLoaded) {
      final currentState = state as StokOpnameLoaded;
      emit(currentState.copyWith(
        searchQuery: event.query,
        filteredItems: _applyFilters(currentState.items, event.query, currentState.hanyaSelisih),
      ));
    }
  }

  void _onFilterHanyaSelisih(FilterHanyaSelisih event, Emitter<StokOpnameState> emit) {
    if (state is StokOpnameLoaded) {
      final currentState = state as StokOpnameLoaded;
      emit(currentState.copyWith(
        hanyaSelisih: event.hanyaSelisih,
        filteredItems: _applyFilters(currentState.items, currentState.searchQuery, event.hanyaSelisih),
      ));
    }
  }

  List<StokOpnameItem> _applyFilters(List<StokOpnameItem> items, String query, bool hanyaSelisih) {
    return items.where((item) {
      final matchQuery = query.isEmpty || 
          item.namaProduk.toLowerCase().contains(query.toLowerCase());
      final matchSelisih = !hanyaSelisih || item.adaSelisih;
      return matchQuery && matchSelisih;
    }).toList();
  }

  Future<void> _onSimpanStokOpname(SimpanStokOpname event, Emitter<StokOpnameState> emit) async {
    if (state is StokOpnameLoaded) {
      final currentState = state as StokOpnameLoaded;
      
      final itemsToUpdate = currentState.items.where((i) => i.adaSelisih).toList();
      if (itemsToUpdate.isEmpty) return;

      emit(currentState.copyWith(isSaving: true));
      
      try {
        await _stokOpname(itemsToUpdate);
        emit(StokOpnameSaved(totalKoreksi: itemsToUpdate.length));
      } catch (e) {
        emit(StokOpnameError(e.toString()));
        emit(currentState.copyWith(isSaving: false)); // Revert loading
      }
    }
  }
}
