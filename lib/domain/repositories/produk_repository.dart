import '../entities/produk.dart';
import '../entities/satuan_produk.dart';
import '../entities/riwayat_harga.dart';
import '../entities/riwayat_perubahan.dart';

abstract class ProdukRepository {
  Future<List<Produk>> getAllProduk();
  Future<List<Produk>> searchProduk(String query);
  Future<Produk?> getProdukById(String id);
  Future<Produk?> getProdukByBarcode(String barcode);
  Future<Set<String>> getAllBarcodes();
  Future<String> addProduk(Produk produk);
  Future<void> updateProduk(Produk produk);
  Future<void> archiveProduk(String id, bool isArchived);
  Future<void> deleteProduk(String id);
  Future<void> updateStok(String produkId, int jumlah);
  Future<List<RiwayatHarga>> getAllRiwayatHarga({int limit = 100});
  Future<List<RiwayatPerubahan>> getRiwayatPerubahan(String produkId);

  Future<List<SatuanProduk>> getSatuanByProdukId(String produkId);
  Future<String> addSatuan(SatuanProduk satuan);
  Future<void> updateSatuan(SatuanProduk satuan);
  Future<void> deleteSatuan(String id);
  Future<void> deleteSatuanByProdukId(String produkId);

  Future<({int imported, int skipped})> importAll({
    required List<Produk> produkList,
    required Map<String, List<SatuanProduk>> satuanByNama,
    required Set<String> existingBarcodes,
  });


  Future<List<String>> getAllSatuan();
  Future<List<String>> getAllKategori();

  /// Bersihkan satuan duplikat (nama sama dalam 1 produk).
  /// Strategi: satuan yang sudah direferensikan di transaksi TIDAK dihapus.
  /// Returns jumlah satuan yang berhasil dihapus.
  Future<({int deleted, int protected})> cleanupDuplicateSatuan();
}
