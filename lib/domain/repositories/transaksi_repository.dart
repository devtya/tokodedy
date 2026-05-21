import '../entities/item_transaksi.dart';
import '../entities/transaksi.dart';

abstract class TransaksiRepository {
  Future<List<Transaksi>> getAllTransaksi();
  Future<List<Transaksi>> getTransaksiByDate(DateTime date);
  Future<Transaksi?> getTransaksiById(String id);
  Future<String> addTransaksi(Transaksi transaksi);
  Future<void> addItemTransaksi(ItemTransaksi item);
  Future<List<ItemTransaksi>> getItemTransaksiByTransaksiId(String transaksiId);
  Future<double> getTotalOmsetToday();
  Future<Transaksi?> getLastTransaksiByProdukId(String produkId);
}
