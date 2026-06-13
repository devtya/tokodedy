import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/future_extension.dart';

import '../../../domain/entities/satuan_produk.dart';
import '../../../domain/usecases/produk/add_produk.dart';
import '../../../domain/usecases/produk/add_satuan.dart';
import '../../../domain/usecases/produk/delete_produk.dart';
import '../../../domain/usecases/produk/delete_satuan.dart';
import '../../../domain/usecases/produk/delete_satuan_by_produk_id.dart';
import '../../../domain/usecases/produk/get_all_produk.dart';
import '../../../domain/usecases/produk/get_produk_by_id.dart';
import '../../../domain/usecases/produk/search_produk.dart';
import '../../../domain/usecases/produk/update_produk.dart';
import '../../../domain/usecases/produk/update_satuan.dart';
import '../../../domain/usecases/produk/archive_produk.dart';
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
  final UpdateSatuan updateSatuan;
  final DeleteSatuan deleteSatuan;
  final DeleteSatuanByProdukId deleteSatuanByProdukId;
  final GetProdukById getProdukById;
  final ArchiveProduk archiveProduk;

  ProdukBloc({
    required this.getAllProduk,
    required this.searchProduk,
    required this.addProduk,
    required this.updateProduk,
    required this.deleteProduk,
    required this.addSatuan,
    required this.updateSatuan,
    required this.deleteSatuan,
    required this.deleteSatuanByProdukId,
    required this.getProdukById,
    required this.archiveProduk,
  }) : super(const ProdukState.initial()) {
    on<LoadProduk>(_onLoadProduk);
    on<SearchProdukEvent>(_onSearchProduk);
    on<AddProdukEvent>(_onAddProduk);
    on<UpdateProdukEvent>(_onUpdateProduk);
    on<DeleteProdukEvent>(_onDeleteProduk);
    on<ArchiveProdukEvent>(_onArchiveProduk);
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
        final satuanBaru = event.produk.satuanList;
        if (satuanBaru == null) {
          emit(const ProdukState.operationSuccess('Produk berhasil diupdate'));
          add(LoadProduk());
          return;
        }

        // --- Smart upsert: update/insert/delete per-ID ---
        // Hindari delete-all+reinsert yang menyebabkan race condition
        // dengan background Supabase sync.

        // Ambil satuan yang saat ini ada di DB
        final existingProduk = await getProdukById(event.produk.id!);
        final existingList = existingProduk?.satuanList ?? [];
        final existingIds = existingList
            .where((s) => s.id != null)
            .map((s) => s.id!)
            .toSet();

        // ID satuan baru yang masih punya ID (artinya sudah ada di DB)
        final keptIds = satuanBaru
            .where((s) => s.id != null && s.id!.isNotEmpty)
            .map((s) => s.id!)
            .toSet();

        // 1. Hapus satuan lama yang tidak ada di list baru
        for (final oldId in existingIds.difference(keptIds)) {
          try {
            await deleteSatuan(oldId);
          } catch (_) {}
        }

        // 2. Update satuan yang sudah ada, insert satuan baru
        for (final s in satuanBaru) {
          if (s.id != null && s.id!.isNotEmpty && existingIds.contains(s.id)) {
            // Satuan lama → update
            try {
              await updateSatuan(s.copyWith(produkId: event.produk.id!));
            } catch (_) {}
          } else {
            // Satuan baru (tidak punya ID) → insert
            try {
              await addSatuan(
                SatuanProduk(
                  produkId: event.produk.id!,
                  nama: s.nama,
                  konversi: s.konversi,
                  hargaBeli: s.hargaBeli,
                  hargaJual: s.hargaJual,
                ),
              );
            } catch (_) {}
          }
        }

        emit(const ProdukState.operationSuccess('Produk berhasil diupdate'));
        add(LoadProduk());
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

  Future<void> _onArchiveProduk(
    ArchiveProdukEvent event,
    Emitter<ProdukState> emit,
  ) async {
    final result = await archiveProduk(event.id, event.isArchived).toEither();
    result.fold(
      (f) => emit(ProdukState.error(f.message)),
      (_) {
        emit(ProdukState.operationSuccess(event.isArchived ? 'Produk berhasil diarsipkan' : 'Produk dikembalikan dari arsip'));
        add(LoadProduk());
      },
    );
  }
}
