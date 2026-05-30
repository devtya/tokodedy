import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/stok/get_riwayat_stok.dart';
import '../../../domain/usecases/stok/tambah_stok.dart';
import 'stok_event.dart';
import 'stok_state.dart';

@injectable
class StokBloc extends Bloc<StokEvent, StokState> {
  final GetRiwayatStok getRiwayatStok;
  final TambahStok tambahStok;

  StokBloc({required this.getRiwayatStok, required this.tambahStok})
    : super(StokInitial()) {
    on<LoadRiwayatStok>(_onLoadRiwayat);
    on<TambahStokEvent>(_onTambahStok);
  }

  Future<void> _onLoadRiwayat(
    LoadRiwayatStok event,
    Emitter<StokState> emit,
  ) async {
    emit(StokLoading());
    try {
      final riwayat = await getRiwayatStok(event.produkId);
      emit(StokLoaded(riwayat));
    } catch (e) {
      emit(StokError(e.toString()));
    }
  }

  Future<void> _onTambahStok(
    TambahStokEvent event,
    Emitter<StokState> emit,
  ) async {
    try {
      await tambahStok(event.produkId, event.jumlah, event.keterangan);
      emit(StokOperationSuccess('Stok berhasil ditambahkan'));
      add(LoadRiwayatStok(event.produkId));
    } catch (e) {
      emit(StokError(e.toString()));
    }
  }
}
