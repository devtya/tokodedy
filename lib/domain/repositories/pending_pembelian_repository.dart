import '../entities/pending_pembelian.dart';

abstract class PendingPembelianRepository {
  Future<List<PendingPembelian>> getAllPending();
  Future<PendingPembelian?> getPendingById(String id);
  Future<String> addPending(PendingPembelian pending);
  Future<void> deletePending(String id);
  Future<List<PendingPembelianItemData>> getItemsByPendingId(String pendingId);
  Future<void> addItem(String pendingId, PendingPembelianItemData item);
}

class PendingPembelianItemData {
  final String? id; // UUID
  final String produkId; // UUID
  final String namaProduk;
  final int jumlah;
  final double hargaBeliSatuan;
  final double hargaBeliLama;
  final int diskonTipe;
  final double diskonValue;

  const PendingPembelianItemData({
    this.id,
    required this.produkId,
    required this.namaProduk,
    required this.jumlah,
    required this.hargaBeliSatuan,
    required this.hargaBeliLama,
    this.diskonTipe = 0,
    this.diskonValue = 0,
  });
}
