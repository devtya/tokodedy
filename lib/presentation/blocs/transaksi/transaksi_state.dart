import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/transaksi.dart';

part 'transaksi_state.freezed.dart';

@freezed
class TransaksiState with _$TransaksiState {
  const factory TransaksiState.initial() = _Initial;
  const factory TransaksiState.loading() = _Loading;
  const factory TransaksiState.loaded(List<Transaksi> transaksiList) = _Loaded;
  const factory TransaksiState.detailLoaded(Transaksi transaksi) = _DetailLoaded;
  const factory TransaksiState.error(String message) = _Error;
}
