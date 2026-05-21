import 'package:equatable/equatable.dart';

class ReceiptItem {
  final String nama;
  final int jumlah;
  final double harga;
  final double diskon;
  final String? satuan;
  final double konversi;

  const ReceiptItem({
    required this.nama,
    required this.jumlah,
    required this.harga,
    this.diskon = 0.0,
    this.satuan,
    this.konversi = 1.0,
  });

  Map<String, dynamic> toJson() => {
        'nama': nama,
        'jumlah': jumlah,
        'harga': harga,
        'diskon': diskon,
        'satuan': satuan,
        'konversi': konversi,
      };
}

class ReceiptData extends Equatable {
  final String namaToko;
  final String alamatToko;
  final String transaksiId;
  final String tanggal;
  final String kasir;
  final List<ReceiptItem> items;
  final double subtotal;
  final double totalDiskon;
  final double totalBayar;
  final double kembalian;
  final String metodePembayaran;
  final int lebarKertas; // 58 atau 80
  final String fontSize; // kecil, normal, besar

  const ReceiptData({
    required this.namaToko,
    this.alamatToko = '',
    required this.transaksiId,
    required this.tanggal,
    this.kasir = '',
    required this.items,
    required this.subtotal,
    this.totalDiskon = 0.0,
    required this.totalBayar,
    this.kembalian = 0.0,
    this.metodePembayaran = 'Tunai',
    this.lebarKertas = 58,
    this.fontSize = 'normal',
  });

  Map<String, dynamic> toJson() => {
        'nama_toko': namaToko,
        'alamat_toko': alamatToko,
        'transaksi_id': transaksiId,
        'tanggal': tanggal,
        'kasir': kasir,
        'items': items.map((e) => e.toJson()).toList(),
        'subtotal': subtotal,
        'total_diskon': totalDiskon,
        'total_bayar': totalBayar,
        'kembalian': kembalian,
        'metode_pembayaran': metodePembayaran,
        'lebar_kertas': lebarKertas,
        'font_size': fontSize,
      };

  @override
  List<Object?> get props => [
        namaToko,
        alamatToko,
        transaksiId,
        tanggal,
        kasir,
        items,
        subtotal,
        totalDiskon,
        totalBayar,
        kembalian,
        metodePembayaran,
        lebarKertas,
        fontSize,
      ];
}
