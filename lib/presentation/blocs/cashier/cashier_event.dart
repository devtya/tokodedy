import 'package:equatable/equatable.dart';

import '../../../domain/usecases/transaksi/buat_transaksi.dart';

abstract class CashierEvent extends Equatable {
  const CashierEvent();
  @override
  List<Object?> get props => [];
}

class InitCashier extends CashierEvent {}

class ScanBarcodeCashier extends CashierEvent {
  final String barcode;
  const ScanBarcodeCashier(this.barcode);
  @override
  List<Object?> get props => [barcode];
}

class AddToCart extends CashierEvent {
  final String produkId;
  final String namaProduk;
  final double hargaJual;
  final double hargaPokok;
  final int jumlah;
  const AddToCart({
    required this.produkId,
    required this.namaProduk,
    required this.hargaJual,
    this.hargaPokok = 0,
    this.jumlah = 1,
  });
  @override
  List<Object?> get props => [produkId, namaProduk, hargaJual, hargaPokok, jumlah];
}

class RemoveFromCart extends CashierEvent {
  final int index;
  const RemoveFromCart(this.index);
  @override
  List<Object?> get props => [index];
}

class UpdateJumlahCart extends CashierEvent {
  final int index;
  final int jumlah;
  const UpdateJumlahCart(this.index, this.jumlah);
  @override
  List<Object?> get props => [index, jumlah];
}

class UpdateJumlahBayar extends CashierEvent {
  final double jumlah;
  const UpdateJumlahBayar(this.jumlah);
  @override
  List<Object?> get props => [jumlah];
}

class SetDiskonItem extends CashierEvent {
  final int index;
  final int tipe;
  final double value;
  const SetDiskonItem(this.index, this.tipe, this.value);
  @override
  List<Object?> get props => [index, tipe, value];
}

class LoadCartFromPending extends CashierEvent {
  final List<CartItem> items;
  const LoadCartFromPending(this.items);
  @override
  List<Object?> get props => [items];
}

class BayarCashier extends CashierEvent {
  const BayarCashier();
}

class BayarHutangCashier extends CashierEvent {
  final String namaPelanggan;
  const BayarHutangCashier(this.namaPelanggan);
  @override
  List<Object?> get props => [namaPelanggan];
}

class ClearError extends CashierEvent {
  const ClearError();
}
