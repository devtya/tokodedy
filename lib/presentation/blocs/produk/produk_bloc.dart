import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/future_extension.dart';

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

@injectable
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
  }) : super(const ProdukState.initial()) {
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
    emit(const ProdukState.loading());
    final result = await getAllProduk().toEither();
    result.fold(
      (f) => emit(ProdukState.error(f.message)),
      (produk) => emit(ProdukState.loaded(produk)),
    );
  }

  Future<void> _onSearchProduk(
    SearchProdukEvent event,
    Emitter<ProdukState> emit,
  ) async {
    emit(const ProdukState.loading());
    final result = await searchProduk(event.query).toEither();
    result.fold(
      (f) => emit(ProdukState.error(f.message)),
      (produk) => emit(ProdukState.loaded(produk, searchQuery: event.query)),
    );
  }

  Future<void> _onAddProduk(
    AddProdukEvent event,
    Emitter<ProdukState> emit,
  ) async {
    final result = await addProduk(event.produk).toEither();
    
    await result.fold(
      (f) async => emit(ProdukState.error(f.message)),
      (newId) async {
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
        emit(ProdukState.operationSuccess('Produk berhasil ditambahkan', newId: newId));
        add(LoadProduk());
      },
    );
  }

  Future<void> _onUpdateProduk(
    UpdateProdukEvent event,
    Emitter<ProdukState> emit,
  ) async {
    final result = await updateProduk(event.produk).toEither();
    
    await result.fold(
      (f) async => emit(ProdukState.error(f.message)),
      (_) async {
        // Hapus satuan lama
        final delSatuanResult = await deleteSatuanByProdukId(event.produk.id!).toEither();
        await delSatuanResult.fold(
          (f) async => emit(ProdukState.error(f.message)),
          (_) async {
            // Insert satuan baru
            final satuanList = event.produk.satuanList;
            if (satuanList != null) {
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
            emit(const ProdukState.operationSuccess('Produk berhasil diupdate'));
            add(LoadProduk());
          },
        );
      },
    );
  }

  Future<void> _onDeleteProduk(
    DeleteProdukEvent event,
    Emitter<ProdukState> emit,
  ) async {
    final result = await deleteProduk(event.id).toEither();
    result.fold(
      (f) => emit(ProdukState.error(f.message)),
      (_) {
        emit(const ProdukState.operationSuccess('Produk berhasil dihapus'));
        add(LoadProduk());
      },
    );
  }
}
