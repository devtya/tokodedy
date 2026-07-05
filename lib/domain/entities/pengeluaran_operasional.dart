class PengeluaranOperasional {
  final String? id;
  final double jumlah;
  final String kategori;
  final String? keterangan;
  final DateTime tanggal;
  final DateTime? createdAt;

  const PengeluaranOperasional({
    this.id,
    required this.jumlah,
    required this.kategori,
    this.keterangan,
    required this.tanggal,
    this.createdAt,
  });
}
