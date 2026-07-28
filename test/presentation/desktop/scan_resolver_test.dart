import 'package:flutter_test/flutter_test.dart';
import 'package:tokodedy/domain/entities/produk.dart';
import 'package:tokodedy/presentation/pages/desktop/scan_resolver.dart';

Produk _p({int stok = 5, bool archived = false}) => Produk(
      id: 'p1',
      nama: 'Indomie',
      hargaBeli: 2500,
      hargaJual: 3000,
      stok: stok,
      satuan: 'pcs',
      isArchived: archived,
    );

void main() {
  test('null product -> notFound', () {
    expect(resolveScannedProduct(null, isKasir: false).outcome,
        ScanOutcome.notFound);
  });

  test('archived -> archived', () {
    expect(resolveScannedProduct(_p(archived: true), isKasir: false).outcome,
        ScanOutcome.archived);
  });

  test('zero stock -> outOfStock', () {
    expect(resolveScannedProduct(_p(stok: 0), isKasir: false).outcome,
        ScanOutcome.outOfStock);
  });

  test('valid -> added with qty 1 and base unit', () {
    final r = resolveScannedProduct(_p(), isKasir: false);
    expect(r.outcome, ScanOutcome.added);
    expect(r.event!.produkId, 'p1');
    expect(r.event!.jumlah, 1);
    expect(r.event!.hargaJual, 3000);
    expect(r.event!.hargaPokok, 2500);
  });

  test('kasir role hides cost (hargaPokok 0)', () {
    final r = resolveScannedProduct(_p(), isKasir: true);
    expect(r.event!.hargaPokok, 0);
  });
}
