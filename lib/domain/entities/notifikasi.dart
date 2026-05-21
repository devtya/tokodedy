import 'package:equatable/equatable.dart';

class Notifikasi extends Equatable {
  final String? id; // UUID
  final String tokoId; // UUID FK ke toko
  final String judul;
  final String pesan;
  final String tipe;
  final bool isRead;
  final DateTime? createdAt;

  const Notifikasi({
    this.id,
    required this.tokoId,
    required this.judul,
    required this.pesan,
    this.tipe = 'INFO',
    this.isRead = false,
    this.createdAt,
  });

  Notifikasi copyWith({
    String? id,
    String? tokoId,
    String? judul,
    String? pesan,
    String? tipe,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return Notifikasi(
      id: id ?? this.id,
      tokoId: tokoId ?? this.tokoId,
      judul: judul ?? this.judul,
      pesan: pesan ?? this.pesan,
      tipe: tipe ?? this.tipe,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, tokoId, judul, pesan, tipe, isRead, createdAt];
}
