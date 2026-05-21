import 'package:intl/intl.dart';

import '../models/receipt_data.dart';
import '../../domain/usecases/transaksi/buat_transaksi.dart';

class ReceiptGenerator {
  final String namaToko;
  final String alamatToko;
  final String kasir;
  final int lebarKertas;
  final String fontSize;

  const ReceiptGenerator({
    required this.namaToko,
    this.alamatToko = '',
    this.kasir = '',
    this.lebarKertas = 58,
    this.fontSize = 'normal',
  });

  ReceiptData fromTransaction({
    required String transaksiId,
    required List<CartItem> cartItems,
    required double totalBayar,
    required double kembalian,
    String metodePembayaran = 'Tunai',
  }) {
    final now = DateTime.now();
    final tanggal = DateFormat('dd/MM/yyyy HH:mm').format(now);

    final items = cartItems
        .map(
          (item) => ReceiptItem(
            nama: item.namaProduk,
            jumlah: item.jumlah,
            harga: item.hargaJual,
            diskon: item.totalDiskon,
            satuan: item.satuan,
            konversi: item.konversi,
          ),
        )
        .toList();

    final subtotal = items.fold(
      0.0,
      (sum, item) => sum + (item.jumlah * item.harga),
    );

    final totalDiskon = items.fold(
      0.0,
      (sum, item) => sum + item.diskon,
    );

    return ReceiptData(
      namaToko: namaToko,
      alamatToko: alamatToko,
      transaksiId: transaksiId,
      tanggal: tanggal,
      kasir: kasir,
      items: items,
      subtotal: subtotal,
      totalDiskon: totalDiskon,
      totalBayar: totalBayar,
      kembalian: kembalian,
      metodePembayaran: metodePembayaran,
      lebarKertas: lebarKertas,
      fontSize: fontSize,
    );
  }
}
