import 'dart:convert';
import 'package:intl/intl.dart';
import '../../models/receipt_data.dart';

class EscPosBuilder {
  const EscPosBuilder();

  List<int> drawerKick() => [0x1B, 0x70, 0x00, 0x19, 0xFA];

  List<int> buildReceipt(ReceiptData data) {
    final buffer = <int>[];
    void add(List<int> bytes) => buffer.addAll(bytes);
    void addText(String text) => buffer.addAll(utf8.encode(text));

    final lebar = data.lebarKertas == 58 ? 32 : 48;

    int fontMode() {
      switch (data.fontSize) {
        case 'kecil':
          return 0x01;
        case 'besar':
          return 0x30;
        default:
          return 0x00;
      }
    }

    String formatReceiptItemLine(ReceiptItem item, int lebar) {
      final formatter = NumberFormat('#,##0.00', 'en_US');
      final priceStr = item.harga.toStringAsFixed(0);
      final qtyStr = 'x ${item.jumlah}';
      final String unitName;
      final parts = item.nama.split(' - ');
      if (parts.length > 1) {
        unitName = parts.sublist(1).join(' - ');
      } else {
        unitName = item.satuan ?? '';
      }
      final String unitPart;
      if (item.konversi > 1 && unitName.isNotEmpty) {
        unitPart = '${item.konversi.toInt()} $unitName';
      } else {
        unitPart = unitName;
      }
      final totalStr = formatter.format(item.harga * item.jumlah);
      if (lebar == 48) {
        final p = priceStr.padRight(14);
        final q = qtyStr.padRight(6);
        final u = unitPart.padLeft(8);
        final t = totalStr.padLeft(17);
        return '$p$q$u = $t';
      } else {
        final p = priceStr.padRight(8);
        final q = qtyStr.padRight(4);
        final u = unitPart.padLeft(6);
        final t = totalStr.padLeft(11);
        return '$p$q$u = $t';
      }
    }

    add([0x1B, 0x40]);
    add([0x1B, 0x61, 0x01]);
    add([0x1B, 0x21, 0x38]);
    addText(data.namaToko);
    add([0x0A]);
    add([0x1B, 0x21, fontMode()]);
    if (data.alamatToko.isNotEmpty) {
      addText(data.alamatToko);
      add([0x0A]);
    }
    add([0x0A]);
    add([0x1B, 0x61, 0x00]);
    addText('#${data.transaksiId}');
    add([0x0A]);
    addText('Tgl: ${data.tanggal}');
    add([0x0A]);
    if (data.kasir.isNotEmpty) {
      addText('Kasir: ${data.kasir}');
      add([0x0A]);
    }
    addText('Metode: ${data.metodePembayaran}');
    add([0x0A]);
    addText('-' * lebar);
    add([0x0A]);
    for (final item in data.items) {
      final parts = item.nama.split(' - ');
      final namaProduk = parts.isNotEmpty ? parts[0] : item.nama;
      final nama =
          namaProduk.length > lebar ? namaProduk.substring(0, lebar) : namaProduk;
      add([0x1B, 0x61, 0x00]);
      addText(nama);
      add([0x0A]);
      addText(formatReceiptItemLine(item, lebar));
      add([0x0A]);
      if (item.diskon > 0) {
        add([0x1B, 0x61, 0x02]);
        addText('  Diskon: -${item.diskon.toStringAsFixed(0)}');
        add([0x0A]);
        add([0x1B, 0x61, 0x00]);
      }
    }
    addText('-' * lebar);
    add([0x0A]);
    add([0x1B, 0x61, 0x02]);
    add([0x1B, 0x21, 0x10 | fontMode()]);
    addText('Subtotal: ${data.subtotal.toStringAsFixed(0)}');
    add([0x0A]);
    if (data.totalDiskon > 0) {
      addText('Diskon: -${data.totalDiskon.toStringAsFixed(0)}');
      add([0x0A]);
    }
    add([0x1B, 0x21, 0x38]);
    addText('TOTAL: ${data.totalBayar.toStringAsFixed(0)}');
    add([0x0A]);
    add([0x1B, 0x21, 0x00]);
    add([0x0A]);
    addText('Dibayar: ${data.totalBayar.toStringAsFixed(0)}');
    add([0x0A]);
    if (data.kembalian > 0) {
      addText('Kembali: ${data.kembalian.toStringAsFixed(0)}');
      add([0x0A]);
    }
    add([0x0A]);
    addText('-' * lebar);
    add([0x0A]);
    add([0x1B, 0x61, 0x01]);
    addText('Terima kasih atas kunjungan Anda!');
    add([0x0A, 0x0A, 0x0A]);
    add(drawerKick());
    add([0x1D, 0x56, 0x41, 0x03]);
    return buffer;
  }

  List<int> buildPickingList(ReceiptData data) {
    final buffer = <int>[];
    void add(List<int> bytes) => buffer.addAll(bytes);
    void addText(String text) => buffer.addAll(utf8.encode(text));
    final lebar = data.lebarKertas == 58 ? 32 : 48;
    add([0x1B, 0x40]);
    add([0x1B, 0x61, 0x01]);
    add([0x1B, 0x21, 0x38]);
    addText('DAFTAR PENGAMBILAN');
    add([0x0A]);
    add([0x1B, 0x21, 0x00]);
    addText(data.namaToko);
    add([0x0A, 0x0A]);
    add([0x1B, 0x61, 0x00]);
    addText('Pesanan: #${data.transaksiId}');
    add([0x0A]);
    addText('Tgl: ${data.tanggal}');
    add([0x0A]);
    addText('-' * lebar);
    add([0x0A]);
    for (final item in data.items) {
      final parts = item.nama.split(' - ');
      final namaProduk = parts.isNotEmpty ? parts[0] : item.nama;
      final String unitName;
      if (parts.length > 1) {
        unitName = parts.sublist(1).join(' - ');
      } else {
        unitName = item.satuan ?? 'Pcs';
      }
      final qtyPart = '${item.jumlah} $unitName';
      add([0x1B, 0x61, 0x00]);
      add([0x1B, 0x21, 0x10]);
      addText('[ ] $namaProduk');
      add([0x0A]);
      add([0x1B, 0x21, 0x00]);
      addText('    Qty: $qtyPart');
      add([0x0A, 0x0A]);
    }
    addText('-' * lebar);
    add([0x0A, 0x0A, 0x0A]);
    add([0x1D, 0x56, 0x41, 0x03]);
    return buffer;
  }
}
