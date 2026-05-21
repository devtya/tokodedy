import '../../entities/riwayat_stok.dart';
import '../../repositories/produk_repository.dart';
import '../../repositories/riwayat_stok_repository.dart';

class TambahStok {
  final ProdukRepository produkRepository;
  final RiwayatStokRepository riwayatRepository;
  TambahStok(this.produkRepository, this.riwayatRepository);

  Future<void> call(String produkId, int jumlahTambah, String? keterangan) async {
    final produk = await produkRepository.getProdukById(produkId);
    if (produk == null) throw Exception('Produk tidak ditemukan');

    final stokBaru = produk.stok + jumlahTambah;
    await produkRepository.updateStok(produkId, stokBaru);

    await riwayatRepository.addRiwayat(
      RiwayatStok(
        tokoId: produk.tokoId,
        produkId: produkId,
        tipe: 'masuk',
        jumlah: jumlahTambah,
        keterangan: keterangan,
      ),
    );
  }
}
