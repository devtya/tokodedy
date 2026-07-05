class KasHarian {
  final String? id;
  final double modalAwal;
  final String? keterangan;
  final DateTime tanggal;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const KasHarian({
    this.id,
    required this.modalAwal,
    this.keterangan,
    required this.tanggal,
    this.createdAt,
    this.updatedAt,
  });
}
