import 'package:equatable/equatable.dart';

import '../../../domain/entities/produk.dart';

abstract class ProdukEvent extends Equatable {
  const ProdukEvent();
  @override
  List<Object?> get props => [];
}

class LoadProduk extends ProdukEvent {}

class SearchProdukEvent extends ProdukEvent {
  final String query;
  const SearchProdukEvent(this.query);
  @override
  List<Object?> get props => [query];
}

class AddProdukEvent extends ProdukEvent {
  final Produk produk;
  const AddProdukEvent(this.produk);
  @override
  List<Object?> get props => [produk];
}

class UpdateProdukEvent extends ProdukEvent {
  final Produk produk;
  const UpdateProdukEvent(this.produk);
  @override
  List<Object?> get props => [produk];
}

class DeleteProdukEvent extends ProdukEvent {
  final String id;
  const DeleteProdukEvent(this.id);
  @override
  List<Object?> get props => [id];
}
