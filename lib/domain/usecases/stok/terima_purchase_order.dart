import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import '../../../data/database/app_database.dart';
import '../../entities/item_pembelian.dart';
import '../../entities/pembelian.dart';
import '../../entities/notifikasi.dart';
import '../../repositories/purchase_order_repository.dart';
import '../../repositories/pembelian_repository.dart';
import '../../repositories/produk_repository.dart';
import '../../repositories/notifikasi_repository.dart';
import 'buat_pembelian.dart';

@lazySingleton
class TerimaPurchaseOrder {
  final PurchaseOrderRepository poRepository;
  final PembelianRepository pembelianRepository;
  final ProdukRepository produkRepository;
  final NotifikasiRepository notifikasiRepository;
  final AppDatabase db;

  TerimaPurchaseOrder({
    required this.poRepository,
    required this.pembelianRepository,
    required this.produkRepository,
    required this.notifikasiRepository,
    required this.db,
  });

  Future<String> call({
    required String poId,
    required List<ItemTerima> itemsTerima,
    List<PriceChange>? priceChanges,
    List<SatuanPriceChange>? konversiAutoUpdates,
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

      if (priceChanges != null) {
        for (final change in priceChanges) {
          final produk = await produkRepository.getProdukById(change.produkId);
          if (produk != null) {
            await produkRepository.updateProduk(
              produk.copyWith(
                hargaBeli: change.hargaBeliBaru,
                hargaJual: change.hargaJualBaru,
              ),
            );
            
            final satuanList = await produkRepository.getSatuanByProdukId(change.produkId);
            for (final satuanChange in change.satuanChanges) {
              final satuan = satuanList.where((s) => s.id == satuanChange.satuanId).firstOrNull;
              if (satuan != null) {
                await produkRepository.updateSatuan(
                  satuan.copyWith(
                    hargaBeli: satuanChange.hargaBeli,
                    hargaJual: satuanChange.hargaJual,
                  ),
                );
              }
            }
          }
        }
      }

      if (konversiAutoUpdates != null) {
        for (final update in konversiAutoUpdates) {
          final satuanInfo = await db.customSelect(
            'SELECT nama, produk_id FROM satuan_produk_table WHERE id = ?',
            variables: [Variable.withString(update.satuanId)],
          ).getSingleOrNull();
          
          if (satuanInfo != null) {
            final satuanName = satuanInfo.read<String>('nama');
            final pId = satuanInfo.read<String>('produk_id');
            final pInfo = await db.customSelect(
              'SELECT nama FROM produk_table WHERE id = ?',
              variables: [Variable.withString(pId)],
            ).getSingleOrNull();
            final pName = pInfo?.read<String>('nama') ?? 'Produk';
            
            final satuanList = await produkRepository.getSatuanByProdukId(pId);
            final satuan = satuanList.where((s) => s.id == update.satuanId).firstOrNull;
            if (satuan != null) {
              await produkRepository.updateSatuan(
                satuan.copyWith(
                  hargaBeli: update.hargaBeli,
                  hargaJual: update.hargaJual,
                ),
              );
              
              await notifikasiRepository.addNotifikasi(
                Notifikasi(
                  judul: 'Harga Jual Satuan Disesuaikan',
                  pesan: 'Harga jual $pName ($satuanName) otomatis disesuaikan karena HPP baru melebihi harga jual lama.',
                  tipe: 'WARNING',
                  createdAt: DateTime.now().toUtc(),
                ),
              );
            }
          }
        }
      }

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
