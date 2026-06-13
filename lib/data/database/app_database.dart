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
import 'tables/riwayat_perubahan_produk_table.dart';
import 'tables/purchase_order_table.dart';
import 'tables/purchase_order_item_table.dart';
import 'tables/riwayat_harga_table.dart';
import 'tables/riwayat_stok_table.dart';
import 'tables/satuan_produk_table.dart';
import 'tables/supplier_table.dart';
import 'tables/supplier_products_table.dart';
import 'tables/transaksi_table.dart';
import 'tables/notifikasi_table.dart';
import 'tables/user_table.dart';
import 'tables/local_auth_table.dart';
import 'tables/online_customer_table.dart';
import 'tables/online_order_table.dart';
import 'tables/online_order_item_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    UserTable,
    ProdukTable,
    SatuanProdukTable,
    RiwayatPerubahanProdukTable,
    SupplierTable,
    SupplierProductsTable,
    TransaksiTable,
    ItemTransaksiTable,
    HutangPiutangTable,
    RiwayatStokTable,
    PembelianTable,
    ItemPembelianTable,
    PurchaseOrderTable,
    PurchaseOrderItemTable,
    PendingOrderTable,
    PendingOrderItemTable,
    PendingPembelianTable,
    PendingPembelianItemTable,
    NotifikasiTable,
    PendingSyncQueueTable,
    RiwayatHargaTable,
    LocalAuthTable,
    OnlineCustomerTable,
    OnlineOrderTable,
    OnlineOrderItemTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(produkTable, produkTable.isArchived);
        await m.createTable(riwayatPerubahanProdukTable);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    await Directory(dir.path).create(recursive: true);
    // Nama file baru agar tidak konflik dengan DB lama
    final file = File(p.join(dir.path, 'tokodedy.db'));
    return NativeDatabase(file);
  });
}
