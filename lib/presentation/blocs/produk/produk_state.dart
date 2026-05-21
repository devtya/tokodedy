import 'package:equatable/equatable.dart';

import '../../../domain/entities/produk.dart';

abstract class ProdukState extends Equatable {
  const ProdukState();
  @override
  List<Object?> get props => [];
}

class ProdukInitial extends ProdukState {}

class ProdukLoading extends ProdukState {}

class ProdukLoaded extends ProdukState {
  final List<Produk> produkList;
  final String? searchQuery;
  const ProdukLoaded(this.produkList, {this.searchQuery});
  @override
  List<Object?> get props => [produkList, searchQuery];
}

class ProdukError extends ProdukState {
  final String message;
  const ProdukError(this.message);
  @override
  List<Object?> get props => [message];
}

class ProdukOperationSuccess extends ProdukState {
  final String message;
  final String? newId;
  const ProdukOperationSuccess(this.message, {this.newId});
  @override
  List<Object?> get props => [message, newId];
}
