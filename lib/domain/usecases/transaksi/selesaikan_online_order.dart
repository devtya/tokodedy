import 'package:injectable/injectable.dart';

import '../../../data/database/app_database.dart' as db_lib;
import '../../entities/item_transaksi.dart';
import '../../entities/online_order.dart';
import '../../entities/riwayat_stok.dart';
import '../../entities/transaksi.dart';
import '../../repositories/produk_repository.dart';
import '../../repositories/riwayat_stok_repository.dart';
import '../../repositories/transaksi_repository.dart';
import '../../repositories/notifikasi_repository.dart';
import '../../entities/notifikasi.dart';

/// Usecase untuk menyelesaikan pesanan online.
/// Proses:
/// 1. Buat record Transaksi baru (status: 'lunas_online')
/// 2. Salin item pesanan ke ItemTransaksi (hanya item yg tersedia / tidak ditandai habis)
/// 3. Potong stok produk per item
/// 4. Catat RiwayatStok (tipe: 'penjualan_online')
///
/// Status online_order diubah oleh caller (OnlineOrderBloc) setelah usecase selesai
/// agar tidak terjadi circular DI antara usecase dan repository.
///
/// Semua DB operation dijalankan dalam satu db.transaction() (atomic —
/// kalau ada yang gagal di tengah jalan, semua otomatis di-rollback).
@lazySingleton
class SelesaikanOnlineOrder {
  final db_lib.AppDatabase db;
  final TransaksiRepository transaksiRepository;
  final ProdukRepository produkRepository;
  final RiwayatStokRepository riwayatStokRepository;
  final NotifikasiRepository notifikasiRepository;

  SelesaikanOnlineOrder({
    required this.db,
    required this.transaksiRepository,
    required this.produkRepository,
    required this.riwayatStokRepository,
    required this.notifikasiRepository,
  });

  Future<String> call(OnlineOrder order) async {
    // Hanya proses item yang TIDAK ditandai habis
    final itemTersedia = order.items.where((i) => !i.isUnavailable).toList();

    if (itemTersedia.isEmpty) {
      throw Exception(
          'Tidak ada item yang tersedia untuk diselesaikan. Batalkan pesanan jika semua barang habis.');
    }

    final totalHarga = itemTersedia.fold(0.0, (sum, i) => sum + i.subtotal);

    return db.transaction(() async {
      // 1. Buat Transaksi
      final transaksiId = await transaksiRepository.addTransaksi(
        Transaksi(
          totalHarga: totalHarga,
          jumlahBayar: totalHarga,
          kembalian: 0,
          // Status khusus agar bisa dibedakan dari transaksi kasir biasa di laporan
          status: 'lunas_online',
        ),
      );

      // 2. Salin tiap item tersedia ke ItemTransaksi + potong stok
      for (final item in itemTersedia) {
        await transaksiRepository.addItemTransaksi(
          ItemTransaksi(
            transaksiId: transaksiId,
            produkId: item.produkId,
            jumlah: item.jumlah,
            hargaSatuan: item.hargaSatuan,
            subtotal: item.subtotal,
          ),
        );

        final produk = await produkRepository.getProdukById(item.produkId);
        if (produk != null) {
          // Potong stok (mempertimbangkan konversi satuan)
          final jumlahDikurangi = (item.jumlah * item.konversi).round();
          final stokBaru = produk.stok - jumlahDikurangi;
          await produkRepository.updateStok(item.produkId, stokBaru);

          // Notifikasi stok menipis
          if (stokBaru < 5) {
            await notifikasiRepository.addNotifikasi(
              Notifikasi(
                judul: 'Stok Menipis - ${produk.nama}',
                pesan:
                    'Sisa stok ${produk.nama} saat ini adalah $stokBaru (setelah pesanan online). Segera lakukan restock.',
                tipe: 'WARNING',
              ),
            );
          }
        }

        // 3. Catat riwayat stok
        await riwayatStokRepository.addRiwayat(
          RiwayatStok(
            produkId: item.produkId,
            tipe: 'penjualan_online',
            jumlah: -(item.jumlah * item.konversi).ceil(),
            keterangan:
                'Pesanan Online #${order.id.substring(0, 8)} - ${order.namaCustomer}',
          ),
        );
      }

      return transaksiId;
    });
  }
}
