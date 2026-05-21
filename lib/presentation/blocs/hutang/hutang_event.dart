import 'package:equatable/equatable.dart';

import '../../../domain/entities/hutang_piutang.dart';

abstract class HutangEvent extends Equatable {
  const HutangEvent();
  @override
  List<Object?> get props => [];
}

class LoadHutang extends HutangEvent {}

class FilterHutang extends HutangEvent {
  final String status;
  const FilterHutang(this.status);
  @override
  List<Object?> get props => [status];
}

class AddHutangManual extends HutangEvent {
  final HutangPiutang hutang;
  const AddHutangManual(this.hutang);
  @override
  List<Object?> get props => [hutang];
}

class LunasHutang extends HutangEvent {
  final String id;
  const LunasHutang(this.id);
  @override
  List<Object?> get props => [id];
}
