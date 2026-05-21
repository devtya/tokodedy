import '../../entities/item_pembelian.dart';
import '../../entities/pembelian.dart';
import '../../entities/riwayat_stok.dart';
import '../../repositories/pembelian_repository.dart';
import '../../repositories/produk_repository.dart';
import '../../repositories/riwayat_stok_repository.dart';

class UpdatePembelian {
  final PembelianRepository pembelianRepository;
  final ProdukRepository produkRepository;
  final RiwayatStokRepository riwayatStokRepository;

  UpdatePembelian({
    required this.pembelianRepository,
    required this.produkRepository,
    required this.riwayatStokRepository,
  });

  Future<void> call({
    required String pembelianId,
    required String namaSupplier,
    required List<ItemPembelian> itemsBaru,
  }) async {
    await pembelianRepository.runInTransaction(() async {
      final itemsLama = await pembelianRepository.getItemsByPembelianId(
        pembelianId,
      );

      final tokoId = itemsBaru.isNotEmpty ? itemsBaru.first.tokoId : (itemsLama.isNotEmpty ? itemsLama.first.tokoId : '');

      final totalHarga = itemsBaru.fold(0.0, (sum, item) => sum + item.subtotal);

      // Rollback stok dari item lama
      for (final item in itemsLama) {
        await _rollbackStok(item.produkId, item.jumlah, item.hargaBeliSatuan);
      }

      // Update header
      await pembelianRepository.updatePembelian(
        Pembelian(
          id: pembelianId,
          tokoId: tokoId,
          namaSupplier: namaSupplier,
          totalHarga: totalHarga,
        ),
      );

      // Hapus item lama
      await pembelianRepository.deleteItemsByPembelianId(pembelianId);

      // Insert item baru
      for (final item in itemsBaru) {
        await pembelianRepository.addItemPembelian(
          item.copyWith(pembelianId: pembelianId),
        );
      }

      // Apply stok & HPP baru
      for (final item in itemsBaru) {
        await _applyStokDanHpp(item.produkId, item.jumlah, item.hargaBeliSatuan);
      }

      // Write riwayat stok untuk item baru
      for (final item in itemsBaru) {
        await riwayatStokRepository.addRiwayat(
          RiwayatStok(
            tokoId: tokoId,
            produkId: item.produkId,
            tipe: 'masuk',
            jumlah: item.jumlah,
            keterangan: 'Edit Pembelian #$pembelianId',
          ),
        );
      }
    });
  }

  Future<void> _rollbackStok(String produkId, int qtyLama, double hargaLama) async {
    final produk = await produkRepository.getProdukById(produkId);
    if (produk == null) return;

    final stokBaru = (produk.stok - qtyLama).clamp(0, 999999999);

    double hppBaru;
    if (stokBaru <= 0) {
      hppBaru = produk.hargaBeli;
    } else {
      hppBaru = ((produk.hargaBeli * produk.stok) - (hargaLama * qtyLama)) / stokBaru;
      if (hppBaru < 0) hppBaru = 0;
    }

    await produkRepository.updateStok(produkId, stokBaru);
    await produkRepository.updateProduk(
      produk.copyWith(hargaBeli: hppBaru),
    );
  }

  Future<void> _applyStokDanHpp(String produkId, int qtyBaru, double hargaBaru) async {
    final produk = await produkRepository.getProdukById(produkId);
    if (produk == null) return;

    final stokAkhir = produk.stok + qtyBaru;
    double hppAkhir;
    if (stokAkhir <= 0) {
      hppAkhir = hargaBaru;
    } else {
      hppAkhir = ((produk.hargaBeli * produk.stok) + (hargaBaru * qtyBaru)) / stokAkhir;
    }

    await produkRepository.updateStok(produkId, stokAkhir);
    await produkRepository.updateProduk(
      produk.copyWith(hargaBeli: hppAkhir),
    );
  }
}
