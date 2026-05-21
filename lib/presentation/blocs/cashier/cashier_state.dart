import 'package:equatable/equatable.dart';

import '../../../domain/usecases/transaksi/buat_transaksi.dart';

class _DiscountHelper {
  static double hitungTotalDiskon(double subtotal, int tipe, double value) {
    if (tipe == 1) return subtotal * value / 100;
    if (tipe == 2) return value;
    return 0;
  }
}

abstract class CashierState extends Equatable {
  const CashierState();
  @override
  List<Object?> get props => [];
}

class CashierInitial extends CashierState {}

class CashierLoading extends CashierState {}

class CashierReady extends CashierState {
  final List<CartItem> cart;
  final double jumlahBayar;

  const CashierReady({this.cart = const [], this.jumlahBayar = 0});

  double get total => cart.fold(0.0, (sum, item) => sum + item.subtotal);
  double get totalDiskon => cart.fold(
    0.0,
    (sum, item) =>
        sum +
        _DiscountHelper.hitungTotalDiskon(
          item.subtotal,
          item.diskonTipe,
          item.diskonValue,
        ),
  );
  double get totalSetelahDiskon => total - totalDiskon;
  double get kembalian =>
      jumlahBayar >= totalSetelahDiskon ? jumlahBayar - totalSetelahDiskon : 0;

  CashierReady copyWith({List<CartItem>? cart, double? jumlahBayar}) {
    return CashierReady(
      cart: cart ?? this.cart,
      jumlahBayar: jumlahBayar ?? this.jumlahBayar,
    );
  }

  @override
  List<Object?> get props => [cart, jumlahBayar];
}

class CashierSuccess extends CashierState {
  final String transaksiId;
  final bool isHutang;
  const CashierSuccess(this.transaksiId, {this.isHutang = false});
  @override
  List<Object?> get props => [transaksiId, isHutang];
}

class CashierError extends CashierState {
  final String message;
  final List<CartItem> cart;
  final double jumlahBayar;

  const CashierError(
    this.message, {
    this.cart = const [],
    this.jumlahBayar = 0,
  });

  double get total => cart.fold(0.0, (sum, item) => sum + item.subtotal);
  double get totalDiskon => cart.fold(
    0.0,
    (sum, item) =>
        sum +
        _DiscountHelper.hitungTotalDiskon(
          item.subtotal,
          item.diskonTipe,
          item.diskonValue,
        ),
  );
  double get totalSetelahDiskon => total - totalDiskon;
  double get kembalian =>
      jumlahBayar >= totalSetelahDiskon ? jumlahBayar - totalSetelahDiskon : 0;

  @override
  List<Object?> get props => [message, cart, jumlahBayar];
}
