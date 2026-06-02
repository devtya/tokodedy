import 'package:equatable/equatable.dart';
import '../../../domain/entities/purchase_order.dart';

abstract class PurchaseOrderState extends Equatable {
  const PurchaseOrderState();
  @override
  List<Object?> get props => [];
}

class PurchaseOrderInitial extends PurchaseOrderState {}

class PurchaseOrderLoading extends PurchaseOrderState {}

class PurchaseOrdersLoaded extends PurchaseOrderState {
  final List<PurchaseOrder> list;
  const PurchaseOrdersLoaded(this.list);
  @override
  List<Object?> get props => [list];
}

class PurchaseOrderSuccess extends PurchaseOrderState {
  final String message;
  const PurchaseOrderSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class PurchaseOrderError extends PurchaseOrderState {
  final String message;
  const PurchaseOrderError(this.message);
  @override
  List<Object?> get props => [message];
}
