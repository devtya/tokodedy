import 'package:injectable/injectable.dart';

import '../produk/get_all_produk.dart';
import '../../entities/produk.dart';

class POGenerateItem {
  final Produk produk;
  final int stokSaatIni;
  final int stokMinimum;
  final int qtyRekomendasi;
  int qtyPesan;

  POGenerateItem({
    required this.produk,
    required this.stokSaatIni,
    required this.stokMinimum,
    required this.qtyRekomendasi,
    required this.qtyPesan,
  });
}

@lazySingleton
class GeneratePODariStokMinimum {
  final GetAllProduk getAllProduk;

  GeneratePODariStokMinimum(this.getAllProduk);

  Future<List<POGenerateItem>> call() async {
    final semuaProduk = await getAllProduk();
    final result = <POGenerateItem>[];

    for (final p in semuaProduk) {
      if (p.isArchived) continue;
      
      final minStok = p.stokMinimum ?? 0; // If null, assume 0 for filtering purposes
      if (p.stok <= minStok) {
        int rek = minStok - p.stok;
        if (p.stokMinimum == null && rek <= 0) {
           rek = 5; // Default minimal if no minimum is set but somehow triggered (though usually stok=0)
        } else if (rek <= 0) {
           rek = 5; // Fallback just in case
        }

        result.add(POGenerateItem(
          produk: p,
          stokSaatIni: p.stok,
          stokMinimum: minStok,
          qtyRekomendasi: rek,
          qtyPesan: rek, // Editable later
        ));
      }
    }

    // Sort: stok=0 first, then by stok asc
    result.sort((a, b) {
      if (a.stokSaatIni == 0 && b.stokSaatIni != 0) return -1;
      if (a.stokSaatIni != 0 && b.stokSaatIni == 0) return 1;
      return a.stokSaatIni.compareTo(b.stokSaatIni);
    });

    return result;
  }
}
