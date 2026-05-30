import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/produk.dart';

part 'produk_state.freezed.dart';

@freezed
class ProdukState with _$ProdukState {
  const factory ProdukState.initial() = _Initial;
  const factory ProdukState.loading() = _Loading;
  const factory ProdukState.loaded(List<Produk> produkList, {String? searchQuery}) = _Loaded;
  const factory ProdukState.error(String message) = _Error;
  const factory ProdukState.operationSuccess(String message, {String? newId}) = _OperationSuccess;
}
