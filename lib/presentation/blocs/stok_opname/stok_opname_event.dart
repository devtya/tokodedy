import 'package:equatable/equatable.dart';

abstract class StokOpnameEvent extends Equatable {
  const StokOpnameEvent();

  @override
  List<Object?> get props => [];
}

class LoadStokOpname extends StokOpnameEvent {}

class UpdateStokFisik extends StokOpnameEvent {
  final String produkId;
  final int stokFisik;

  const UpdateStokFisik(this.produkId, this.stokFisik);

  @override
  List<Object?> get props => [produkId, stokFisik];
}

class SearchStokOpname extends StokOpnameEvent {
  final String query;

  const SearchStokOpname(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterHanyaSelisih extends StokOpnameEvent {
  final bool hanyaSelisih;

  const FilterHanyaSelisih(this.hanyaSelisih);

  @override
  List<Object?> get props => [hanyaSelisih];
}

class SimpanStokOpname extends StokOpnameEvent {}
