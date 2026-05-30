import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/future_extension.dart';

import '../../../domain/usecases/transaksi/get_all_transaksi.dart';
import '../../../domain/usecases/transaksi/get_transaksi_by_id.dart';
import 'transaksi_event.dart';
import 'transaksi_state.dart';

@injectable
class TransaksiBloc extends Bloc<TransaksiEvent, TransaksiState> {
  final GetAllTransaksi getAllTransaksi;
  final GetTransaksiById getTransaksiById;

  TransaksiBloc({required this.getAllTransaksi, required this.getTransaksiById})
    : super(const TransaksiState.initial()) {
    on<LoadTransaksi>(_onLoadTransaksi);
    on<LoadTransaksiDetail>(_onLoadDetail);
  }

  Future<void> _onLoadTransaksi(
    LoadTransaksi event,
    Emitter<TransaksiState> emit,
  ) async {
    emit(const TransaksiState.loading());
    final result = await getAllTransaksi().toEither();
    result.fold(
      (f) => emit(TransaksiState.error(f.message)),
      (list) => emit(TransaksiState.loaded(list)),
    );
  }

  Future<void> _onLoadDetail(
    LoadTransaksiDetail event,
    Emitter<TransaksiState> emit,
  ) async {
    emit(const TransaksiState.loading());
    final result = await getTransaksiById(event.id).toEither();
    result.fold(
      (f) => emit(TransaksiState.error(f.message)),
      (transaksi) {
        if (transaksi != null) {
          emit(TransaksiState.detailLoaded(transaksi));
        } else {
          emit(const TransaksiState.error('Transaksi tidak ditemukan'));
        }
      },
    );
  }
}
