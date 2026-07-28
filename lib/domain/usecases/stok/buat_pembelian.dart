import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import '../../../data/database/app_database.dart';
import '../../entities/item_pembelian.dart';
import '../../entities/pembelian.dart';
import '../../entities/riwayat_stok.dart';
import '../../entities/notifikasi.dart';

import '../../repositories/pembelian_repository.dart';
import '../../repositories/produk_repository.dart';
import '../../repositories/riwayat_stok_repository.dart';
import '../../repositories/notifikasi_repository.dart';

class PriceChange {
  final String produkId;
  final double hargaBeliBaru;
  final double hargaJualBaru;
  final List<SatuanPriceChange> satuanChanges;

  const PriceChange({
    required this.produkId,
    required this.hargaBeliBaru,
    required this.hargaJualBaru,
    required this.satuanChanges,
  });
}

class SatuanPriceChange {
  final String satuanId;
  final double hargaBeli;
  final double hargaJual;

  const SatuanPriceChange({
    required this.satuanId,
    required this.hargaBeli,
    required this.hargaJual,
  });
}

@lazySingleton
class BuatPembelian {
  final PembelianRepository pembelianRepository;
  final ProdukRepository produkRepository;
  final RiwayatStokRepository riwayatStokRepository;
  final NotifikasiRepository notifikasiRepository;
  final AppDatabase db;

  BuatPembelian({
    required this.pembelianRepository,
    required this.produkRepository,
    required this.riwayatStokRepository,
    required this.notifikasiRepository,
    required this.db,
  });

  Future<String> call({
    required String namaSupplier,
    required List<ItemPembelian> items,
    List<PriceChange>? priceChanges,
    List<SatuanPriceChange>? konversiAutoUpdates,
  }) async {
    return db.transaction(() async {
      final totalHarga = items.fold(0.0, (sum, item) => sum + item.subtotal);

      final pembelianId = await pembelianRepository.addPembelian(
        Pembelian(
          namaSupplier: namaSupplier,
          totalHarga: totalHarga,
        ),
      );

      for (final item in items) {
        await pembelianRepository.addItemPembelian(
          item.copyWith(pembelianId: pembelianId),
        );

        final produk = await produkRepository.getProdukById(item.produkId);
        if (produk != null) {
          // Hitung tambahan stok: kalikan konversi satuan
          // Misal beli 1 karton (konversi=10 pcs) → stok bertambah 10
          final konversi = item.konversi;
          final tambahStok = (item.jumlah * konversi).round();
          await produkRepository.updateStok(
            item.produkId,
            produk.stok + tambahStok,
          );

          await riwayatStokRepository.addRiwayat(
            RiwayatStok(
              produkId: produk.id!,
              tipe: 'masuk',
              jumlah: tambahStok,
              keterangan: 'Pembelian #$pembelianId',
            ),
          );

          // Update harga beli:
          // - Jika satuan konversi → update SatuanProduk.hargaBeli & hitung ulang hargaBeli dasar
          // - Jika satuan dasar → update Produk.hargaBeli langsung
          if (item.satuanId != null) {
            // Satuan konversi: update SatuanProduk.hargaBeli
            final satuanList = await produkRepository.getSatuanByProdukId(item.produkId);
            final satuan = satuanList.where((s) => s.id == item.satuanId).firstOrNull;
            if (satuan != null && satuan.hargaBeli != item.hargaBeliSatuan) {
              await produkRepository.updateSatuan(
                satuan.copyWith(hargaBeli: item.hargaBeliSatuan),
              );

              // Auto update harga pokok dasar jika satuan konversi punya harga pokok
              if (item.hargaBeliSatuan > 0 && konversi > 0) {
                final hargaDasarBaru = item.hargaBeliSatuan / konversi;
                await produkRepository.updateProduk(
                  produk.copyWith(hargaBeli: hargaDasarBaru),
                );
              }
            }
          } else {
            // Satuan dasar: update Produk.hargaBeli
            if (produk.hargaBeli != item.hargaBeliSatuan) {
              await produkRepository.updateProduk(
                produk.copyWith(hargaBeli: item.hargaBeliSatuan),
              );
            }
          }
        }
      }

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
