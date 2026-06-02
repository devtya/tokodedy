import 'package:equatable/equatable.dart';

import 'item_transaksi.dart';

class Transaksi extends Equatable {
  final String? id; // UUID
  final String? kasirId; // UUID FK ke profiles
  final double totalHarga;
  final double jumlahBayar;
  final double kembalian;
  final String status; // 'lunas' | 'hutang'
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final List<ItemTransaksi>? items;

  const Transaksi({
    this.id,
    this.kasirId,
    required this.totalHarga,
    required this.jumlahBayar,
    required this.kembalian,
    this.status = 'lunas',
    this.updatedAt,
    this.createdAt,
    this.items,
  });

  Transaksi copyWith({
    String? id,
    String? kasirId,
    double? totalHarga,
    double? jumlahBayar,
    double? kembalian,
    String? status,
    DateTime? updatedAt,
    DateTime? createdAt,
    List<ItemTransaksi>? items,
  }) {
    return Transaksi(
      id: id ?? this.id,
      kasirId: kasirId ?? this.kasirId,
      totalHarga: totalHarga ?? this.totalHarga,
      jumlahBayar: jumlahBayar ?? this.jumlahBayar,
      kembalian: kembalian ?? this.kembalian,
      status: status ?? this.status,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [
    id, kasirId, totalHarga, jumlahBayar, kembalian,
    status, updatedAt, createdAt, items,
  ];
}
