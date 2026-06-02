import 'package:equatable/equatable.dart';

class PendingOrder extends Equatable {
  final String? id; // UUID
  final String namaPelanggan;
  final String? catatan;
  final DateTime? createdAt;

  const PendingOrder({
    this.id,
    required this.namaPelanggan,
    this.catatan,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, namaPelanggan, catatan, createdAt];
}
