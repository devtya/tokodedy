import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/satuan_produk.dart';
import '../../../domain/usecases/produk/add_produk.dart';
import '../../../domain/usecases/produk/add_satuan.dart';
import '../../../domain/usecases/produk/delete_produk.dart';
import '../../../domain/usecases/produk/delete_satuan_by_produk_id.dart';
import '../../../domain/usecases/produk/get_all_produk.dart';
import '../../../domain/usecases/produk/search_produk.dart';
import '../../../domain/usecases/produk/update_produk.dart';
import 'produk_event.dart';
import 'produk_state.dart';

class ProdukBloc extends Bloc<ProdukEvent, ProdukState> {
  final GetAllProduk getAllProduk;
  final SearchProduk searchProduk;
  final AddProduk addProduk;
  final UpdateProduk updateProduk;
  final DeleteProduk deleteProduk;
  final AddSatuan addSatuan;
  final DeleteSatuanByProdukId deleteSatuanByProdukId;

  ProdukBloc({
    required this.getAllProduk,
    required this.searchProduk,
    required this.addProduk,
    required this.updateProduk,
    required this.deleteProduk,
    required this.addSatuan,
    required this.deleteSatuanByProdukId,
  }) : super(ProdukInitial()) {
    on<LoadProduk>(_onLoadProduk);
    on<SearchProdukEvent>(_onSearchProduk);
    on<AddProdukEvent>(_onAddProduk);
    on<UpdateProdukEvent>(_onUpdateProduk);
    on<DeleteProdukEvent>(_onDeleteProduk);
  }

  Future<void> _onLoadProduk(
    LoadProduk event,
    Emitter<ProdukState> emit,
  ) async {
    emit(ProdukLoading());
    try {
      final produk = await getAllProduk();
      emit(ProdukLoaded(produk));
    } catch (e) {
      emit(ProdukError(e.toString()));
    }
  }

  Future<void> _onSearchProduk(
    SearchProdukEvent event,
    Emitter<ProdukState> emit,
  ) async {
    emit(ProdukLoading());
    try {
      final produk = await searchProduk(event.query);
      emit(ProdukLoaded(produk, searchQuery: event.query));
    } catch (e) {
      emit(ProdukError(e.toString()));
    }
  }

  Future<void> _onAddProduk(
    AddProdukEvent event,
    Emitter<ProdukState> emit,
  ) async {
    try {
      final newId = await addProduk(event.produk);
      final satuanList = event.produk.satuanList;
      if (satuanList != null) {
        for (final s in satuanList) {
          await addSatuan(
            SatuanProduk(
              tokoId: event.produk.tokoId,
              produkId: newId,
              nama: s.nama,
              konversi: s.konversi,
              hargaBeli: s.hargaBeli,
              hargaJual: s.hargaJual,
            ),
          );
        }
      }
      emit(ProdukOperationSuccess('Produk berhasil ditambahkan', newId: newId));
      add(LoadProduk());
    } catch (e) {
      emit(ProdukError(e.toString()));
    }
  }

  Future<void> _onUpdateProduk(
    UpdateProdukEvent event,
    Emitter<ProdukState> emit,
  ) async {
    try {
      await updateProduk(event.produk);
      final satuanList = event.produk.satuanList;
      if (satuanList != null) {
        await deleteSatuanByProdukId(event.produk.id!);
        for (final s in satuanList) {
          await addSatuan(
            SatuanProduk(
              tokoId: event.produk.tokoId,
              produkId: event.produk.id!,
              nama: s.nama,
              konversi: s.konversi,
              hargaBeli: s.hargaBeli,
              hargaJual: s.hargaJual,
            ),
          );
        }
      }
      emit(ProdukOperationSuccess('Produk berhasil diupdate'));
      add(LoadProduk());
    } catch (e) {
      emit(ProdukError(e.toString()));
    }
  }

  Future<void> _onDeleteProduk(
    DeleteProdukEvent event,
    Emitter<ProdukState> emit,
  ) async {
    try {
      await deleteProduk(event.id);
      emit(ProdukOperationSuccess('Produk berhasil dihapus'));
      add(LoadProduk());
    } catch (e) {
      emit(ProdukError(e.toString()));
    }
  }
}
