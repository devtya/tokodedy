import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/produk.dart';

class DialogUtils {
  static final _currency = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  static void showPilihSatuanDialog({
    required BuildContext context,
    required Produk produk,
    required bool isPembelian,
    required Function(
      String produkId,
      String nama,
      double harga,
      String? satuanId,
      double konversi,
    ) onSelected,
  }) {
    final hargaDasar = isPembelian ? produk.hargaBeli : produk.hargaJual;
    final satuans = (produk.satuanList ?? [])
        .where((s) => s.nama != produk.satuan)
        .toList();

    if (satuans.isEmpty) {
      onSelected(produk.id!, produk.nama, hargaDasar, null, 1.0);
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Pilih Satuan - ${produk.nama}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('${produk.nama} (${produk.satuan})'),
              subtitle: Text(_currency.format(hargaDasar)),
              trailing: const Icon(Icons.add_circle, color: AppTheme.accentGreen),
              onTap: () {
                final id = produk.id!;
                final nama = produk.nama;
                final harga = hargaDasar;
                Navigator.pop(ctx);
                onSelected(id, nama, harga, null, 1.0);
              },
            ),
            ...satuans.map((s) {
              final hargaSatuan = isPembelian
                  ? (s.hargaBeli > 0
                        ? s.hargaBeli
                        : produk.hargaBeli * s.konversi)
                  : s.hargaJual;
              return ListTile(
                title: Text(
                  '${s.nama} (${s.konversi.toInt()} ${produk.satuan})',
                ),
                subtitle: Text(_currency.format(hargaSatuan)),
                trailing: const Icon(
                  Icons.add_circle,
                  color: AppTheme.accentGreen,
                ),
                onTap: () {
                  final pId = produk.id!;
                  final pNama = '${produk.nama} - ${s.nama}';
                  final pHarga = hargaSatuan;
                  final pSatuanId = s.id;
                  final pKonversi = s.konversi;
                  Navigator.pop(ctx);
                  onSelected(pId, pNama, pHarga, pSatuanId, pKonversi);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  static void showQuantityDialog({
    required BuildContext context,
    required String namaProduk,
    required Function(int qty) onSubmitted,
  }) {
    final qtyCtrl = TextEditingController(text: '1');
    qtyCtrl.selection =
        TextSelection(baseOffset: 0, extentOffset: qtyCtrl.text.length);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Jumlah Barang'),
        content: TextField(
          controller: qtyCtrl,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Jumlah'),
          onSubmitted: (val) {
            final qty = int.tryParse(val) ?? 1;
            if (qty > 0) onSubmitted(qty);
            Navigator.pop(ctx);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              final qty = int.tryParse(qtyCtrl.text) ?? 1;
              if (qty > 0) onSubmitted(qty);
              Navigator.pop(ctx);
            },
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }
}
