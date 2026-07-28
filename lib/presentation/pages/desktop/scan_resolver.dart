import '../../../domain/entities/produk.dart';
import '../../blocs/cashier/cashier_event.dart';

enum ScanOutcome { added, notFound, archived, outOfStock }

class ScanResult {
  final ScanOutcome outcome;
  final AddToCart? event;
  const ScanResult(this.outcome, [this.event]);
}

ScanResult resolveScannedProduct(Produk? p, {required bool isKasir}) {
  if (p == null) return const ScanResult(ScanOutcome.notFound);
  if (p.isArchived) return const ScanResult(ScanOutcome.archived);
  if (p.stok <= 0) return const ScanResult(ScanOutcome.outOfStock);
  return ScanResult(
    ScanOutcome.added,
    AddToCart(
      produkId: p.id!,
      namaProduk: '${p.nama} - ${p.satuan ?? 'pcs'}',
      hargaJual: p.hargaJual,
      hargaPokok: isKasir ? 0.0 : p.hargaBeli,
      jumlah: 1,
      konversi: 1.0,
    ),
  );
}
