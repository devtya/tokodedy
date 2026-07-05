import 'package:equatable/equatable.dart';
import '../../../../domain/repositories/kas_harian_repository.dart';

abstract class KasHarianState extends Equatable {
  const KasHarianState();
  
  @override
  List<Object?> get props => [];
}

class KasHarianInitial extends KasHarianState {}

class KasHarianLoading extends KasHarianState {}

class KasHarianLoaded extends KasHarianState {
  final KasDailySummary summary;
  final DateTime selectedDate;

  const KasHarianLoaded({
    required this.summary,
    required this.selectedDate,
  });

  @override
  List<Object?> get props => [summary, selectedDate];
}

class KasHarianError extends KasHarianState {
  final String message;

  const KasHarianError(this.message);

  @override
  List<Object?> get props => [message];
}
