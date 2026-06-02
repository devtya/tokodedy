import 'package:equatable/equatable.dart';

class OnlineOrder extends Equatable {
  final String id;
  final String customerId;
  final String namaCustomer; // Joins with online_customers
  final String status;
  final double totalHarga;
  final String metodePengiriman;
  final String? alamatPengiriman;
  final String? catatan;
  final DateTime createdAt;

  const OnlineOrder({
    required this.id,
    required this.customerId,
    required this.namaCustomer,
    required this.status,
    required this.totalHarga,
    required this.metodePengiriman,
    this.alamatPengiriman,
    this.catatan,
    required this.createdAt,
  });

  OnlineOrder copyWith({
    String? status,
  }) {
    return OnlineOrder(
      id: id,
      customerId: customerId,
      namaCustomer: namaCustomer,
      status: status ?? this.status,
      totalHarga: totalHarga,
      metodePengiriman: metodePengiriman,
      alamatPengiriman: alamatPengiriman,
      catatan: catatan,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        customerId,
        namaCustomer,
        status,
        totalHarga,
        metodePengiriman,
        alamatPengiriman,
        catatan,
        createdAt,
      ];
}
