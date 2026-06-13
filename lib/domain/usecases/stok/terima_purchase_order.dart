import 'package:injectable/injectable.dart';
import '../../../data/database/app_database.dart';
import '../../entities/item_pembelian.dart';
import '../../entities/pembelian.dart';
import '../../repositories/purchase_order_repository.dart';
import '../../repositories/pembelian_repository.dart';
import '../../repositories/produk_repository.dart';

@lazySingleton
class TerimaPurchaseOrder {
  final PurchaseOrderRepository poRepository;
  final PembelianRepository pembelianRepository;
  final ProdukRepository produkRepository;
  final AppDatabase db;

  TerimaPurchaseOrder({
    required this.poRepository,
    required this.pembelianRepository,
    required this.produkRepository,
    required this.db,
  });

  Future<String> call({
    required String poId,
    required List<ItemTerima> itemsTerima,
  }) async {
    return db.transaction(() async {
      final po = await poRepository.getPurchaseOrderById(poId);
      if (po == null) throw Exception('Purchase Order tidak ditemukan');

      final poItems = await poRepository.getItemsByPoId(poId);

      double totalHargaPembelian = 0;
      final itemsPembelian = <ItemPembelian>[];
      bool allFullyReceived = true;

      for (final terima in itemsTerima) {
        final poItem = poItems.firstWhere(
          (i) => i.id == terima.poItemId,
          orElse: () => throw Exception('Item PO tidak ditemukan'),
        );

        final newQtyTerima = poItem.qtyTerima + terima.qtyTerima;
        final updatedHargaSatuan = terima.hargaBeliBaru ?? poItem.hargaSatuan;
        final subtotal = terima.qtyTerima * updatedHargaSatuan;

        // Update PO item qty terima & harga
        await poRepository.updatePurchaseOrderItem(
          poItem.copyWith(
            qtyTerima: newQtyTerima,
            hargaSatuan: updatedHargaSatuan,
            subtotal: poItem.qtyPesan * updatedHargaSatuan,
          ),
        );

        if (newQtyTerima < poItem.qtyPesan) {
          allFullyReceived = false;
        }

        if (terima.qtyTerima > 0) {
          totalHargaPembelian += subtotal;
          itemsPembelian.add(
            ItemPembelian(
              produkId: terima.produkId,
              pembelianId: '',
              jumlah: terima.qtyTerima,
              hargaBeliSatuan: updatedHargaSatuan,
              subtotal: subtotal,
              satuanId: poItem.satuanId,
              konversi: poItem.konversi,
            ),
          );
        }
      }

      // Create Pembelian from received items
      final pembelianId = await pembelianRepository.addPembelian(
        Pembelian(
          supplierId: po.supplierId,
          namaSupplier: po.namaSupplier,
          totalHarga: totalHargaPembelian,
        ),
      );

      for (final item in itemsPembelian) {
        await pembelianRepository.addItemPembelian(
          item.copyWith(pembelianId: pembelianId),
        );
      }

      // Update stock & HPP
      for (final item in itemsPembelian) {
        final produk = await produkRepository.getProdukById(item.produkId);
        if (produk != null) {
          final konversi = item.konversi;
          final tambahStok = (item.jumlah * konversi).round();
          await produkRepository.updateStok(
            item.produkId,
            produk.stok + tambahStok,
          );

          if (item.satuanId != null) {
            final satuanList = await produkRepository.getSatuanByProdukId(item.produkId);
            final satuan = satuanList.where((s) => s.id == item.satuanId).firstOrNull;
            if (satuan != null && satuan.hargaBeli != item.hargaBeliSatuan) {
              await produkRepository.updateSatuan(
                satuan.copyWith(hargaBeli: item.hargaBeliSatuan),
              );
              if (item.hargaBeliSatuan > 0 && konversi > 0) {
                final hargaDasarBaru = item.hargaBeliSatuan / konversi;
                await produkRepository.updateProduk(
                  produk.copyWith(hargaBeli: hargaDasarBaru),
                );
              }
            }
          } else {
            if (produk.hargaBeli != item.hargaBeliSatuan) {
              await produkRepository.updateProduk(
                produk.copyWith(hargaBeli: item.hargaBeliSatuan),
              );
            }
          }
        }
      }

      // Update PO status
      final newStatus = allFullyReceived ? 'received' : 'partial';
      await poRepository.updatePurchaseOrder(
        po.copyWith(status: newStatus),
      );

      return pembelianId;
    });
  }
}

class ItemTerima {
  final String poItemId;
  final String produkId;
  final int qtyTerima;
  final String? satuanId;
  final double konversi;
  final double? hargaBeliBaru;

  const ItemTerima({
    required this.poItemId,
    required this.produkId,
    required this.qtyTerima,
    this.satuanId,
    this.konversi = 1.0,
    this.hargaBeliBaru,
  });
}
