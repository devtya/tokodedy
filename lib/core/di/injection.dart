import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show Supabase;
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../presentation/blocs/theme/theme_cubit.dart';

import '../../data/database/app_database.dart';
import '../../data/database/supplier_products_dao.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/local_auth_repository_impl.dart';
import '../../domain/repositories/local_auth_repository.dart';
import '../../data/repositories/hutang_piutang_repository_impl.dart';
import '../../data/repositories/pembelian_repository_impl.dart';
import '../../data/repositories/pending_order_repository_impl.dart';
import '../../data/repositories/pending_pembelian_repository_impl.dart';
import '../../data/repositories/backup_repository_impl.dart';
import '../../data/repositories/produk_repository_impl.dart';
import '../../data/repositories/riwayat_stok_repository_impl.dart';
import '../../data/repositories/supplier_repository_impl.dart';
import '../../data/repositories/transaksi_repository_impl.dart';
import '../../data/services/supabase_sync_service.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/hutang_piutang_repository.dart';
import '../../domain/repositories/pembelian_repository.dart';
import '../../domain/repositories/pending_order_repository.dart';
import '../../domain/repositories/pending_pembelian_repository.dart';
import '../../domain/repositories/produk_repository.dart';
import '../../domain/repositories/riwayat_stok_repository.dart';
import '../../domain/repositories/supplier_repository.dart';
import '../../domain/repositories/transaksi_repository.dart';
import '../../domain/repositories/backup_repository.dart';
import '../../domain/repositories/laporan_repository.dart';
import '../../domain/repositories/notifikasi_repository.dart';
import '../../data/repositories/laporan_repository_impl.dart';
import '../../data/repositories/notifikasi_repository_impl.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../services/toko_service.dart';
import '../services/update_service.dart';
import '../../domain/usecases/produk/add_produk.dart';
import '../../domain/usecases/produk/add_satuan.dart';
import '../../domain/usecases/produk/delete_produk.dart';
import '../../domain/usecases/produk/delete_satuan_by_produk_id.dart';
import '../../domain/usecases/produk/get_all_produk.dart';
import '../../domain/usecases/produk/get_produk_by_barcode.dart';
import '../../domain/usecases/produk/get_produk_by_id.dart';
import '../../domain/usecases/produk/search_produk.dart';
import '../../domain/usecases/produk/update_produk.dart';
import '../../domain/usecases/produk/update_satuan.dart';
import '../../domain/usecases/produk/delete_satuan.dart';
import '../../domain/usecases/produk/get_last_harga_change.dart';
import '../../domain/usecases/produk/get_last_pembelian.dart';
import '../../domain/usecases/produk/get_last_penjualan.dart';
import '../../domain/usecases/stok/buat_pembelian.dart';
import '../../domain/usecases/stok/update_pembelian.dart';
import '../../domain/usecases/stok/get_riwayat_stok.dart';
import '../../domain/usecases/stok/tambah_stok.dart';
import '../../domain/usecases/supplier/add_supplier.dart';
import '../../domain/usecases/supplier/delete_supplier.dart';
import '../../domain/usecases/supplier/get_all_supplier.dart';
import '../../domain/usecases/supplier/search_supplier.dart';
import '../../domain/usecases/supplier/update_supplier.dart';
import '../../domain/usecases/transaksi/buat_transaksi.dart';
import '../../domain/usecases/notifikasi/add_notifikasi.dart';
import '../../domain/usecases/notifikasi/get_all_notifikasi.dart';
import '../../domain/usecases/notifikasi/get_unread_notifikasi.dart';
import '../../domain/usecases/notifikasi/mark_as_read.dart';
import '../../domain/usecases/notifikasi/watch_unread_count.dart';
import '../../domain/usecases/transaksi/get_all_transaksi.dart';
import '../../domain/usecases/transaksi/get_transaksi_by_id.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';
import '../../presentation/blocs/backup/backup_bloc.dart';
import '../../presentation/blocs/cashier/cashier_bloc.dart';
import '../../presentation/blocs/hutang/hutang_bloc.dart';
import '../../presentation/blocs/laporan/laporan_bloc.dart';
import '../../presentation/blocs/pembelian/pembelian_bloc.dart';
import '../../presentation/blocs/produk/produk_bloc.dart';
import '../../presentation/blocs/stok/stok_bloc.dart';
import '../../presentation/blocs/supplier/supplier_bloc.dart';
import '../../presentation/blocs/transaksi/transaksi_bloc.dart';
import '../../presentation/blocs/notifikasi/notifikasi_bloc.dart';
import '../../presentation/blocs/sync/sync_bloc.dart';
import '../../presentation/blocs/dashboard/dashboard_bloc.dart';
import '../../presentation/blocs/local_auth/local_auth_bloc.dart';
import '../../data/services/printer_service.dart';
import '../../data/services/printer_settings.dart';
import '../../data/services/network_printer_service.dart';
import '../../data/services/bluetooth_printer_service.dart';
import '../../data/services/receipt_generator.dart';

final sl = GetIt.instance;

void _initPrinterService() {
  final settings = sl<PrinterSettings>();
  // Self-healing: if type is network but url is a MAC address, fix it
  if (settings.type == 'network' && settings.url.isNotEmpty && !settings.url.startsWith('http')) {
    settings.type = 'bluetooth';
  }

  if (settings.type == 'bluetooth') {
    sl.registerLazySingleton<PrinterService>(() => sl<BluetoothPrinterService>());
  } else {
    sl.registerLazySingleton<PrinterService>(
      () => NetworkPrinterService(baseUrl: settings.url),
    );
  }
}

void updatePrinterService() {
  final settings = sl<PrinterSettings>();
  // Self-healing: if type is network but url is a MAC address, fix it
  if (settings.type == 'network' && settings.url.isNotEmpty && !settings.url.startsWith('http')) {
    settings.type = 'bluetooth';
  }

  sl.allowReassignment = true;
  if (settings.type == 'bluetooth') {
    sl.registerLazySingleton<PrinterService>(() => sl<BluetoothPrinterService>());
  } else {
    sl.registerLazySingleton<PrinterService>(
      () => NetworkPrinterService(baseUrl: settings.url),
    );
  }
  sl.allowReassignment = false;
}

Future<void> initDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);
  sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit(prefs));

  final database = AppDatabase();
  sl.registerLazySingleton<AppDatabase>(() => database);

  sl.registerLazySingleton<SupplierProductsDao>(
    () => SupplierProductsDao(database),
  );

  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  sl.registerLazySingleton<TokoService>(() => TokoService(prefs));
  sl.registerLazySingleton<UpdateService>(() => UpdateService());

  // Printer services
  sl.registerLazySingleton<PrinterSettings>(() => PrinterSettings(prefs));
  sl.registerLazySingleton<BluetoothPrinterService>(
    () => BluetoothPrinterService(),
  );
  _initPrinterService();
  sl.registerFactory<ReceiptGenerator>(
    () => ReceiptGenerator(
      namaToko: sl<PrinterSettings>().namaToko,
      alamatToko: sl<PrinterSettings>().alamatToko,
      lebarKertas: sl<PrinterSettings>().lebarKertas,
      fontSize: sl<PrinterSettings>().fontSize,
    ),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), Supabase.instance.client, sl(), sl()),
  );
  sl.registerLazySingleton<LocalAuthRepository>(
    () => LocalAuthRepositoryImpl(sl(), sl()),
  );

  sl.registerLazySingleton<ProdukRepository>(
    () => ProdukRepositoryImpl(database, sl(), sl()),
  );
  sl.registerLazySingleton<TransaksiRepository>(
    () => TransaksiRepositoryImpl(database, sl(), sl()),
  );
  sl.registerLazySingleton<RiwayatStokRepository>(
    () => RiwayatStokRepositoryImpl(database, sl(), sl()),
  );
  sl.registerLazySingleton<HutangPiutangRepository>(
    () => HutangPiutangRepositoryImpl(database, sl(), sl()),
  );
  sl.registerLazySingleton<PembelianRepository>(
    () => PembelianRepositoryImpl(database, sl(), sl()),
  );
  sl.registerLazySingleton<PendingOrderRepository>(
    () => PendingOrderRepositoryImpl(database, sl(), sl()),
  );
  sl.registerLazySingleton<PendingPembelianRepository>(
    () => PendingPembelianRepositoryImpl(database, sl(), sl()),
  );
  sl.registerLazySingleton<SupplierRepository>(
    () => SupplierRepositoryImpl(database, sl(), sl()),
  );
  sl.registerLazySingleton<NotifikasiRepository>(
    () => NotifikasiRepositoryImpl(database, sl(), sl()),
  );
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(database, sl()),
  );
  sl.registerLazySingleton<LaporanRepository>(
    () => LaporanRepositoryImpl(database, sl()),
  );

  sl.registerLazySingleton<BackupRepository>(() => BackupRepositoryImpl(sl()));

  sl.registerLazySingleton<SupabaseSyncService>(() => SupabaseSyncService(
        db: sl(),
        supabase: Supabase.instance.client,
        prefs: sl(),
        tokoService: sl(),
      ));

  sl.registerLazySingleton(() => GetAllProduk(sl()));
  sl.registerLazySingleton(() => SearchProduk(sl()));
  sl.registerLazySingleton(() => GetProdukByBarcode(sl()));
  sl.registerLazySingleton(() => GetProdukById(sl()));
  sl.registerLazySingleton(() => AddProduk(sl()));
  sl.registerLazySingleton(() => UpdateProduk(sl()));
  sl.registerLazySingleton(() => DeleteProduk(sl()));
  sl.registerLazySingleton(() => AddSatuan(sl()));
  sl.registerLazySingleton(() => UpdateSatuan(sl()));
  sl.registerLazySingleton(() => DeleteSatuan(sl()));
  sl.registerLazySingleton(() => DeleteSatuanByProdukId(sl()));
  sl.registerLazySingleton(() => GetLastPembelianByProduk(sl()));
  sl.registerLazySingleton(() => GetLastPenjualanByProduk(sl()));
  sl.registerLazySingleton(() => GetLastHargaChangeByProduk(sl()));
  sl.registerLazySingleton(() => GetRiwayatStok(sl()));
  sl.registerLazySingleton(() => TambahStok(sl(), sl()));
  sl.registerLazySingleton(() => GetAllTransaksi(sl()));
  sl.registerLazySingleton(() => GetTransaksiById(sl()));
  sl.registerLazySingleton(
    () => BuatTransaksi(
      transaksiRepository: sl(),
      produkRepository: sl(),
      riwayatStokRepository: sl(),
      hutangPiutangRepository: sl(),
      notifikasiRepository: sl(),
      tokoService: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetAllSupplier(sl()));
  sl.registerLazySingleton(() => SearchSupplier(sl()));
  sl.registerLazySingleton(() => AddSupplier(sl()));
  sl.registerLazySingleton(() => UpdateSupplier(sl()));
  sl.registerLazySingleton(() => DeleteSupplier(sl()));

  sl.registerLazySingleton(() => AddNotifikasi(sl()));
  sl.registerLazySingleton(() => GetAllNotifikasi(sl()));
  sl.registerLazySingleton(() => GetUnreadNotifikasi(sl()));
  sl.registerLazySingleton(() => MarkAsRead(sl()));
  sl.registerLazySingleton(() => WatchUnreadCount(sl()));

  sl.registerLazySingleton(
    () => BuatPembelian(
      pembelianRepository: sl(),
      produkRepository: sl(),
      riwayatStokRepository: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => UpdatePembelian(
      pembelianRepository: sl(),
      produkRepository: sl(),
      riwayatStokRepository: sl(),
    ),
  );

  sl.registerFactory(
    () => ProdukBloc(
      getAllProduk: sl(),
      searchProduk: sl(),
      addProduk: sl(),
      updateProduk: sl(),
      deleteProduk: sl(),
      addSatuan: sl(),
      deleteSatuanByProdukId: sl(),
    ),
  );
  sl.registerFactory(() => StokBloc(getRiwayatStok: sl(), tambahStok: sl()));
  sl.registerFactory(
    () => CashierBloc(
      getAllProduk: sl(),
      getProdukByBarcode: sl(),
      buatTransaksi: sl(),
    ),
  );
  sl.registerFactory(
    () => TransaksiBloc(getAllTransaksi: sl(), getTransaksiById: sl()),
  );
  sl.registerFactory(() => HutangBloc(repository: sl()));
  sl.registerFactory(() => LaporanBloc(
    transaksiRepository: sl(),
    laporanRepository: sl(),
  ));
  sl.registerFactory(
    () => PembelianBloc(
      repository: sl(),
      buatPembelian: sl(),
      updatePembelian: sl(),
    ),
  );
  sl.registerFactory(
    () => SupplierBloc(
      getAllSupplier: sl(),
      searchSupplier: sl(),
      addSupplier: sl(),
      updateSupplier: sl(),
      deleteSupplier: sl(),
    ),
  );
  sl.registerFactory(
    () => NotifikasiBloc(
      getAllNotifikasi: sl(),
      getUnreadNotifikasi: sl(),
      markAsRead: sl(),
    ),
  );
  sl.registerFactory(() => DashboardBloc(sl()));
  sl.registerFactory(() => AuthBloc(authRepository: sl(), tokoService: sl()));
  sl.registerFactory(() => LocalAuthBloc(sl()));

  sl.registerFactory(() => BackupBloc(repository: sl()));

  sl.registerFactory(() => SyncBloc(
        syncService: sl(),
        connectivity: sl(),
      ));
}
