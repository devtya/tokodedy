import 'package:injectable/injectable.dart';
import '../../../core/services/toko_service.dart';
import '../../../data/database/app_database.dart';
import '../../entities/item_pembelian.dart';
import '../../entities/pembelian.dart';
import '../../entities/riwayat_stok.dart';
import '../../repositories/pembelian_repository.dart';
import '../../repositories/produk_repository.dart';
import '../../repositories/riwayat_stok_repository.dart';

@lazySingleton
class BuatPembelian {
  final PembelianRepository pembelianRepository;
  final ProdukRepository produkRepository;
  final RiwayatStokRepository riwayatStokRepository;
  final TokoService tokoService;
  final AppDatabase db;

  BuatPembelian({
    required this.pembelianRepository,
    required this.produkRepository,
    required this.riwayatStokRepository,
    required this.tokoService,
    required this.db,
  });

  Future<String> call({
    required String namaSupplier,
    required List<ItemPembelian> items,
  }) async {
    return db.transaction(() async {
      final totalHarga = items.fold(0.0, (sum, item) => sum + item.subtotal);

      final pembelianId = await pembelianRepository.addPembelian(
        Pembelian(
          tokoId: items.isNotEmpty ? items.first.tokoId : '',
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
      return pembelianId;
    });
  }
}
