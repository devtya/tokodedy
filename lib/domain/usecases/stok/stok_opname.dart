import 'package:injectable/injectable.dart';
import '../../entities/riwayat_stok.dart';
import '../../repositories/produk_repository.dart';
import '../../repositories/riwayat_stok_repository.dart';

class StokOpnameItem {
  final String produkId;
  final String namaProduk;
  final String satuan;
  final int stokSistem;
  final int stokFisik; // input dari owner
  
  const StokOpnameItem({
    required this.produkId,
    required this.namaProduk,
    required this.satuan,
    required this.stokSistem,
    required this.stokFisik,
  });

  int get selisih => stokFisik - stokSistem;
  bool get adaSelisih => selisih != 0;

  StokOpnameItem copyWith({
    String? produkId,
    String? namaProduk,
    String? satuan,
    int? stokSistem,
    int? stokFisik,
  }) {
    return StokOpnameItem(
      produkId: produkId ?? this.produkId,
      namaProduk: namaProduk ?? this.namaProduk,
      satuan: satuan ?? this.satuan,
      stokSistem: stokSistem ?? this.stokSistem,
      stokFisik: stokFisik ?? this.stokFisik,
    );
  }
}

@lazySingleton
class StokOpname {
  final ProdukRepository produkRepository;
  final RiwayatStokRepository riwayatStokRepository;

  StokOpname({
    required this.produkRepository,
    required this.riwayatStokRepository,
  });
  
  Future<void> call(List<StokOpnameItem> items) async {
    for (final item in items) {
      if (!item.adaSelisih) continue; // skip jika sama
      
      // Update stok ke nilai fisik (absolute)
      await produkRepository.updateStok(
        item.produkId, 
        item.stokFisik,
      );
      
      // Tulis riwayat koreksi
      await riwayatStokRepository.addRiwayat(
        RiwayatStok(
          produkId: item.produkId,
          tipe: 'koreksi',
          jumlah: item.selisih,
          keterangan: item.selisih > 0
            ? 'Stok opname: lebih ${item.selisih} ${item.satuan}'
            : 'Stok opname: kurang ${item.selisih.abs()} ${item.satuan}',
        ),
      );
    }
  }
}
