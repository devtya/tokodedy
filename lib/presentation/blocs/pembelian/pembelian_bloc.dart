import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/item_pembelian.dart';
import '../../../domain/repositories/pembelian_repository.dart';
import '../../../domain/usecases/stok/buat_pembelian.dart';
import '../../../domain/usecases/stok/update_pembelian.dart';
import 'pembelian_event.dart';
import 'pembelian_state.dart';
import '../../../core/di/injection.dart';
import '../../../core/services/toko_service.dart';

class PembelianBloc extends Bloc<PembelianEvent, PembelianState> {
  final PembelianRepository repository;
  final BuatPembelian buatPembelian;
  final UpdatePembelian updatePembelian;

  PembelianBloc({
    required this.repository,
    required this.buatPembelian,
    required this.updatePembelian,
  }) : super(PembelianInitial()) {
    on<LoadPembelian>(_onLoad);
    on<AddPembelianEvent>(_onAdd);
    on<UpdatePembelianEvent>(_onUpdate);
  }

  Future<void> _onLoad(
    LoadPembelian event,
    Emitter<PembelianState> emit,
  ) async {
    emit(PembelianLoading());
    try {
      final list = await repository.getAllPembelian();
      emit(PembelianLoaded(list));
    } catch (e) {
      emit(PembelianError(e.toString()));
    }
  }

  Future<void> _onAdd(
    AddPembelianEvent event,
    Emitter<PembelianState> emit,
  ) async {
    try {
      final items = event.items
          .map(
            (d) => ItemPembelian(
              tokoId: sl<TokoService>().tokoId ?? '',
              produkId: d.produkId,
              pembelianId: '',
              jumlah: d.jumlah,
              hargaBeliSatuan: d.hargaBeliSatuan,
              subtotal: d.subtotal,
              satuanId: d.satuanId,
              konversi: d.konversi,
            ),
          )
          .toList();
      await buatPembelian(namaSupplier: event.namaSupplier, items: items);
      emit(const PembelianSuccess('Pembelian berhasil'));
      add(LoadPembelian());
    } catch (e) {
      emit(PembelianError(e.toString()));
    }
  }

  Future<void> _onUpdate(
    UpdatePembelianEvent event,
    Emitter<PembelianState> emit,
  ) async {
    emit(PembelianLoading());
    try {
      final items = event.items
          .map(
            (d) => ItemPembelian(
              tokoId: sl<TokoService>().tokoId ?? '',
              produkId: d.produkId,
              pembelianId: event.pembelianId,
              jumlah: d.jumlah,
              hargaBeliSatuan: d.hargaBeliSatuan,
              subtotal: d.subtotal,
              satuanId: d.satuanId,
              konversi: d.konversi,
            ),
          )
          .toList();
      await updatePembelian(
        pembelianId: event.pembelianId,
        namaSupplier: event.namaSupplier,
        itemsBaru: items,
      );
      emit(const PembelianSuccess('Pembelian berhasil diupdate'));
      add(LoadPembelian());
    } catch (e) {
      emit(PembelianError(e.toString()));
    }
  }
}
