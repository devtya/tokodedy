import '../entities/produk.dart';
import '../entities/satuan_produk.dart';

abstract class ProdukRepository {
  Future<List<Produk>> getAllProduk();
  Future<List<Produk>> searchProduk(String query);
  Future<Produk?> getProdukById(String id);
  Future<Produk?> getProdukByBarcode(String barcode);
  Future<Set<String>> getAllBarcodes();
  Future<String> addProduk(Produk produk);
  Future<void> updateProduk(Produk produk);
  Future<void> deleteProduk(String id);
  Future<void> updateStok(String produkId, int jumlah);

  Future<List<SatuanProduk>> getSatuanByProdukId(String produkId);
  Future<void> addSatuan(SatuanProduk satuan);
  Future<void> updateSatuan(SatuanProduk satuan);
  Future<void> deleteSatuan(String id);
  Future<void> deleteSatuanByProdukId(String produkId);

  Future<({int imported, int skipped})> importAll({
    required List<Produk> produkList,
    required Map<String, List<SatuanProduk>> satuanByNama,
    required Set<String> existingBarcodes,
  });
}
