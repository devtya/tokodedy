import 'package:injectable/injectable.dart';
import '../../../data/database/app_database.dart';
import '../../entities/hutang_piutang.dart';
import '../../entities/item_transaksi.dart';
import '../../entities/riwayat_stok.dart';
import '../../entities/transaksi.dart';
import '../../repositories/hutang_piutang_repository.dart';
import '../../repositories/produk_repository.dart';
import '../../repositories/riwayat_stok_repository.dart';
import '../../repositories/transaksi_repository.dart';
import '../../repositories/notifikasi_repository.dart';
import '../../entities/notifikasi.dart';

class CartItem {
  final String produkId;
  final String namaProduk;
  final double hargaJual;
  final double hargaPokok; // harga beli / modal
  final int jumlah;
  final int diskonTipe;
  final double diskonValue;
  final String? satuan;
  final double konversi;

  const CartItem({
    required this.produkId,
    required this.namaProduk,
    required this.hargaJual,
    this.hargaPokok = 0,
    required this.jumlah,
    this.diskonTipe = 0,
    this.diskonValue = 0,
    this.satuan,
    this.konversi = 1.0,
  });

  double get subtotal => (hargaJual * jumlah).roundToDouble();
  double get totalDiskon => diskonTipe == 1
      ? subtotal * diskonValue / 100
      : diskonTipe == 2
      ? diskonValue
      : 0;
  double get totalSetelahDiskon => subtotal - totalDiskon;

  CartItem copyWith({
    int? jumlah,
    int? diskonTipe,
    double? diskonValue,
    String? satuan,
    double? konversi,
  }) {
    return CartItem(
      produkId: produkId,
      namaProduk: namaProduk,
      hargaJual: hargaJual,
      hargaPokok: hargaPokok,
      jumlah: jumlah ?? this.jumlah,
      diskonTipe: diskonTipe ?? this.diskonTipe,
      diskonValue: diskonValue ?? this.diskonValue,
      satuan: satuan ?? this.satuan,
      konversi: konversi ?? this.konversi,
    );
  }
}

@lazySingleton
class BuatTransaksi {
  final TransaksiRepository transaksiRepository;
  final ProdukRepository produkRepository;
  final RiwayatStokRepository riwayatStokRepository;
  final HutangPiutangRepository hutangPiutangRepository;
  final NotifikasiRepository notifikasiRepository;
  final AppDatabase db;

  BuatTransaksi({
    required this.transaksiRepository,
    required this.produkRepository,
    required this.riwayatStokRepository,
    required this.hutangPiutangRepository,
    required this.notifikasiRepository,
    required this.db,
  });

  Future<String> call({
    required List<CartItem> cartItems,
    required double jumlahBayar,
    String? namaPelanggan,
  }) async {
    return db.transaction(() async {
            final totalHarga = cartItems.fold(
        0.0,
        (sum, item) => sum + item.totalSetelahDiskon,
      );
      final status = namaPelanggan != null ? 'hutang' : 'lunas';

      final transaksiId = await transaksiRepository.addTransaksi(
        Transaksi(
              totalHarga: totalHarga,
          jumlahBayar: jumlahBayar,
          kembalian: jumlahBayar - totalHarga,
          status: status,
        ),
      );

      for (final item in cartItems) {
        await transaksiRepository.addItemTransaksi(
          ItemTransaksi(
                  transaksiId: transaksiId,
            produkId: item.produkId,
            jumlah: item.jumlah,
            hargaSatuan: item.hargaJual,
            subtotal: item.totalSetelahDiskon,
          ),
        );

        final produk = await produkRepository.getProdukById(item.produkId);
        if (produk != null) {
          final jumlahDikurangi = (item.jumlah * item.konversi).round();
          final newStok = produk.stok - jumlahDikurangi;
          await produkRepository.updateStok(item.produkId, newStok);

          if (newStok < 5) {
            await notifikasiRepository.addNotifikasi(
              Notifikasi(
                          judul: 'Stok Menipis - ${produk.nama}',
                pesan:
                    'Sisa stok ${produk.nama} saat ini adalah $newStok. Segera lakukan pembelian (restock).',
                tipe: 'WARNING',
              ),
            );
          }
        }

        final jumlahDikurangi = (item.jumlah * item.konversi).round();
        await riwayatStokRepository.addRiwayat(
          RiwayatStok(
                  produkId: item.produkId,
            tipe: 'penjualan',
            jumlah: -jumlahDikurangi,
            keterangan: 'Transaksi #$transaksiId',
          ),
        );
      }

      if (namaPelanggan != null) {
        await hutangPiutangRepository.addHutang(
          HutangPiutang(
                  transaksiId: transaksiId,
            namaPelanggan: namaPelanggan,
            jumlah: totalHarga,
            status: 'belum_lunas',
          ),
        );
      }

      return transaksiId;
    });
  }
}
