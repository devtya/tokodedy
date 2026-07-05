import 'package:equatable/equatable.dart';
import '../../../../domain/usecases/stok/stok_opname.dart';

abstract class StokOpnameState extends Equatable {
  const StokOpnameState();

  @override
  List<Object?> get props => [];
}

class StokOpnameInitial extends StokOpnameState {}

class StokOpnameLoading extends StokOpnameState {}

class StokOpnameLoaded extends StokOpnameState {
  final List<StokOpnameItem> items;
  final List<StokOpnameItem> filteredItems;
  final bool hanyaSelisih;
  final bool isSaving;
  final String searchQuery;

  const StokOpnameLoaded({
    required this.items,
    required this.filteredItems,
    this.hanyaSelisih = false,
    this.isSaving = false,
    this.searchQuery = '',
  });

  int get totalSelisih => items.where((i) => i.adaSelisih).length;

  StokOpnameLoaded copyWith({
    List<StokOpnameItem>? items,
    List<StokOpnameItem>? filteredItems,
    bool? hanyaSelisih,
    bool? isSaving,
    String? searchQuery,
  }) {
    return StokOpnameLoaded(
      items: items ?? this.items,
      filteredItems: filteredItems ?? this.filteredItems,
      hanyaSelisih: hanyaSelisih ?? this.hanyaSelisih,
      isSaving: isSaving ?? this.isSaving,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [items, filteredItems, hanyaSelisih, isSaving, searchQuery];
}

class StokOpnameSaved extends StokOpnameState {
  final int totalKoreksi;

  const StokOpnameSaved({required this.totalKoreksi});

  @override
  List<Object?> get props => [totalKoreksi];
}

class StokOpnameError extends StokOpnameState {
  final String message;

  const StokOpnameError(this.message);

  @override
  List<Object?> get props => [message];
}
