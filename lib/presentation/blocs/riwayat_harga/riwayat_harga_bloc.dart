import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/produk_repository.dart';
import 'riwayat_harga_event.dart';
import 'riwayat_harga_state.dart';

@injectable
class RiwayatHargaBloc extends Bloc<RiwayatHargaEvent, RiwayatHargaState> {
  final ProdukRepository _produkRepository;

  RiwayatHargaBloc(this._produkRepository) : super(RiwayatHargaInitial()) {
    on<LoadRiwayatHarga>(_onLoadRiwayatHarga);
  }

  Future<void> _onLoadRiwayatHarga(
    LoadRiwayatHarga event,
    Emitter<RiwayatHargaState> emit,
  ) async {
    emit(RiwayatHargaLoading());
    try {
      final riwayat = await _produkRepository.getAllRiwayatHarga(limit: 100);
      emit(RiwayatHargaLoaded(riwayat));
    } catch (e) {
      emit(RiwayatHargaError('Gagal memuat riwayat harga: $e'));
    }
  }
}
