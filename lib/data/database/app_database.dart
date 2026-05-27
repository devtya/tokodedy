import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/hutang_piutang_table.dart';
import 'tables/item_pembelian_table.dart';
import 'tables/item_transaksi_table.dart';
import 'tables/pembelian_table.dart';
import 'tables/pending_pembelian_table.dart';
import 'tables/pending_pembelian_item_table.dart';
import 'tables/pending_order_item_table.dart';
import 'tables/pending_order_table.dart';
import 'tables/pending_sync_queue_table.dart';
import 'tables/produk_table.dart';
import 'tables/riwayat_harga_table.dart';
import 'tables/riwayat_stok_table.dart';
import 'tables/satuan_produk_table.dart';
import 'tables/supplier_table.dart';
import 'tables/supplier_products_table.dart';
import 'tables/toko_table.dart';
import 'tables/transaksi_table.dart';
import 'tables/notifikasi_table.dart';
import 'tables/user_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    TokoTable,
    UserTable,
    ProdukTable,
    SatuanProdukTable,
    SupplierTable,
    SupplierProductsTable,
    TransaksiTable,
    ItemTransaksiTable,
    HutangPiutangTable,
    RiwayatStokTable,
    PembelianTable,
    ItemPembelianTable,
    PendingOrderTable,
    PendingOrderItemTable,
    PendingPembelianTable,
    PendingPembelianItemTable,
    NotifikasiTable,
    PendingSyncQueueTable,
    RiwayatHargaTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 17;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        try {
          await m.addColumn(pendingPembelianTable, pendingPembelianTable.diskonTipe);
          await m.addColumn(pendingPembelianTable, pendingPembelianTable.diskonPersen);
          await m.addColumn(pendingPembelianTable, pendingPembelianTable.diskonNominal);
        } catch (_) {}
      }
      
      if (from < 15) {
        // Coba tambahkan kolom yang mungkin hilang di tabel item (jika user upgrade dari v1/v2)
        try {
          await m.addColumn(pendingPembelianItemTable, pendingPembelianItemTable.diskonTipe);
        } catch (_) {}
        try {
          await m.addColumn(pendingPembelianItemTable, pendingPembelianItemTable.diskonValue);
        } catch (_) {}
        try {
          await m.addColumn(pendingPembelianItemTable, pendingPembelianItemTable.hargaBeliLama);
        } catch (_) {}
      }
      
      if (from < 14) {
        try {
          await m.createTable(riwayatHargaTable);
        } catch (_) {}
      }
      
      if (from < 16) {
        try {
          await m.addColumn(produkTable, produkTable.stokMinimum);
        } catch (_) {}
        try {
          await m.addColumn(tokoTable, tokoTable.stokMinimumGlobal);
        } catch (_) {}
      }

      if (from < 17) {
        try {
          await m.addColumn(itemPembelianTable, itemPembelianTable.satuanId);
          await m.addColumn(itemPembelianTable, itemPembelianTable.konversi);
        } catch (_) {}
        try {
          await m.addColumn(pendingPembelianItemTable, pendingPembelianItemTable.satuanId);
          await m.addColumn(pendingPembelianItemTable, pendingPembelianItemTable.konversi);
        } catch (_) {}
      }
    },
    beforeOpen: (details) async {
      // Aktifkan foreign key enforcement di SQLite
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    await Directory(dir.path).create(recursive: true);
    // Nama file baru agar tidak konflik dengan DB lama
    final file = File(p.join(dir.path, 'hend_kasir_v2.db'));
    return NativeDatabase(file);
  });
}
