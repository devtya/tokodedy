import '../entities/item_pembelian.dart';
import '../entities/pembelian.dart';

abstract class PembelianRepository {
  Future<List<Pembelian>> getAllPembelian();
  Future<Pembelian?> getPembelianById(String id);
  Future<String> addPembelian(Pembelian pembelian);
  Future<void> addItemPembelian(ItemPembelian item);
  Future<List<ItemPembelian>> getItemsByPembelianId(String pembelianId);
  Future<Pembelian?> getLastPembelianByProdukId(String produkId);

  Future<void> updatePembelian(Pembelian pembelian);
  Future<void> deleteItemsByPembelianId(String pembelianId);
  Future<void> deletePembelian(String id);
  Future<void> runInTransaction(Future<void> Function() action);
}
