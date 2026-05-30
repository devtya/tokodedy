// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

import '../../data/database/app_database.dart' as _i160;
import '../../data/database/supplier_products_dao.dart' as _i909;
import '../../data/repositories/auth_repository_impl.dart' as _i895;
import '../../data/repositories/dashboard_repository_impl.dart' as _i283;
import '../../data/repositories/hutang_piutang_repository_impl.dart' as _i294;
import '../../data/repositories/laporan_repository_impl.dart' as _i880;
import '../../data/repositories/local_auth_repository_impl.dart' as _i486;
import '../../data/repositories/notifikasi_repository_impl.dart' as _i833;
import '../../data/repositories/pembelian_repository_impl.dart' as _i810;
import '../../data/repositories/pending_order_repository_impl.dart' as _i803;
import '../../data/repositories/pending_pembelian_repository_impl.dart' as _i54;
import '../../data/repositories/produk_repository_impl.dart' as _i601;
import '../../data/repositories/riwayat_stok_repository_impl.dart' as _i561;
import '../../data/repositories/supplier_repository_impl.dart' as _i994;
import '../../data/repositories/transaksi_repository_impl.dart' as _i942;
import '../../data/services/bluetooth_printer_service.dart' as _i187;
import '../../data/services/printer_settings.dart' as _i219;
import '../../data/services/receipt_generator.dart' as _i1016;
import '../../data/services/supabase_sync_service.dart' as _i345;
import '../../domain/repositories/auth_repository.dart' as _i1073;
import '../../domain/repositories/dashboard_repository.dart' as _i272;
import '../../domain/repositories/hutang_piutang_repository.dart' as _i36;
import '../../domain/repositories/laporan_repository.dart' as _i620;
import '../../domain/repositories/local_auth_repository.dart' as _i517;
import '../../domain/repositories/notifikasi_repository.dart' as _i895;
import '../../domain/repositories/pembelian_repository.dart' as _i228;
import '../../domain/repositories/pending_order_repository.dart' as _i803;
import '../../domain/repositories/pending_pembelian_repository.dart' as _i258;
import '../../domain/repositories/produk_repository.dart' as _i680;
import '../../domain/repositories/riwayat_stok_repository.dart' as _i747;
import '../../domain/repositories/supplier_repository.dart' as _i88;
import '../../domain/repositories/transaksi_repository.dart' as _i673;
import '../../domain/usecases/notifikasi/add_notifikasi.dart' as _i413;
import '../../domain/usecases/notifikasi/get_all_notifikasi.dart' as _i991;
import '../../domain/usecases/notifikasi/get_unread_notifikasi.dart' as _i39;
import '../../domain/usecases/notifikasi/mark_as_read.dart' as _i665;
import '../../domain/usecases/notifikasi/watch_unread_count.dart' as _i878;
import '../../domain/usecases/produk/add_produk.dart' as _i278;
import '../../domain/usecases/produk/add_satuan.dart' as _i536;
import '../../domain/usecases/produk/delete_produk.dart' as _i480;
import '../../domain/usecases/produk/delete_satuan.dart' as _i109;
import '../../domain/usecases/produk/delete_satuan_by_produk_id.dart' as _i543;
import '../../domain/usecases/produk/get_all_produk.dart' as _i1053;
import '../../domain/usecases/produk/get_last_harga_change.dart' as _i569;
import '../../domain/usecases/produk/get_last_pembelian.dart' as _i784;
import '../../domain/usecases/produk/get_last_penjualan.dart' as _i331;
import '../../domain/usecases/produk/get_produk_by_barcode.dart' as _i852;
import '../../domain/usecases/produk/get_produk_by_id.dart' as _i956;
import '../../domain/usecases/produk/search_produk.dart' as _i756;
import '../../domain/usecases/produk/update_produk.dart' as _i992;
import '../../domain/usecases/produk/update_satuan.dart' as _i233;
import '../../domain/usecases/stok/buat_pembelian.dart' as _i408;
import '../../domain/usecases/stok/get_riwayat_stok.dart' as _i609;
import '../../domain/usecases/stok/tambah_stok.dart' as _i995;
import '../../domain/usecases/stok/update_pembelian.dart' as _i479;
import '../../domain/usecases/supplier/add_supplier.dart' as _i773;
import '../../domain/usecases/supplier/delete_supplier.dart' as _i82;
import '../../domain/usecases/supplier/get_all_supplier.dart' as _i715;
import '../../domain/usecases/supplier/search_supplier.dart' as _i1048;
import '../../domain/usecases/supplier/update_supplier.dart' as _i699;
import '../../domain/usecases/transaksi/buat_transaksi.dart' as _i991;
import '../../domain/usecases/transaksi/get_all_transaksi.dart' as _i287;
import '../../domain/usecases/transaksi/get_transaksi_by_id.dart' as _i20;
import '../../presentation/blocs/auth/auth_bloc.dart' as _i141;
import '../../presentation/blocs/cashier/cashier_bloc.dart' as _i207;
import '../../presentation/blocs/dashboard/dashboard_bloc.dart' as _i286;
import '../../presentation/blocs/hutang/hutang_bloc.dart' as _i318;
import '../../presentation/blocs/laporan/laporan_bloc.dart' as _i17;
import '../../presentation/blocs/local_auth/local_auth_bloc.dart' as _i546;
import '../../presentation/blocs/notifikasi/notifikasi_bloc.dart' as _i166;
import '../../presentation/blocs/pembelian/pembelian_bloc.dart' as _i1061;
import '../../presentation/blocs/produk/produk_bloc.dart' as _i308;
import '../../presentation/blocs/stok/stok_bloc.dart' as _i360;
import '../../presentation/blocs/supplier/supplier_bloc.dart' as _i482;
import '../../presentation/blocs/sync/sync_bloc.dart' as _i701;
import '../../presentation/blocs/theme/theme_cubit.dart' as _i473;
import '../../presentation/blocs/transaksi/transaksi_bloc.dart' as _i172;
import '../services/toko_service.dart' as _i997;
import '../services/update_service.dart' as _i919;
import 'injection.dart' as _i464;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.singleton<_i160.AppDatabase>(() => registerModule.db);
    gh.lazySingleton<_i454.SupabaseClient>(() => registerModule.supabase);
    gh.lazySingleton<_i895.Connectivity>(() => registerModule.connectivity);
    gh.lazySingleton<_i919.UpdateService>(() => _i919.UpdateService());
    gh.lazySingleton<_i187.BluetoothPrinterService>(
      () => _i187.BluetoothPrinterService(),
    );
    gh.lazySingleton<_i517.LocalAuthRepository>(
      () => _i486.LocalAuthRepositoryImpl(
        gh<_i160.AppDatabase>(),
        gh<_i460.SharedPreferences>(),
      ),
    );
    gh.factory<_i546.LocalAuthBloc>(
      () => _i546.LocalAuthBloc(gh<_i517.LocalAuthRepository>()),
    );
    gh.factory<_i1016.ReceiptGenerator>(
      () => _i1016.ReceiptGenerator(
        namaToko: gh<String>(),
        alamatToko: gh<String>(),
        kasir: gh<String>(),
        lebarKertas: gh<int>(),
        fontSize: gh<String>(),
      ),
    );
    gh.factory<_i473.ThemeCubit>(
      () => _i473.ThemeCubit(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i997.TokoService>(
      () => _i997.TokoService(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i909.SupplierProductsDao>(
      () => _i909.SupplierProductsDao(gh<_i160.AppDatabase>()),
    );
    gh.lazySingleton<_i219.PrinterSettings>(
      () => _i219.PrinterSettings(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i620.LaporanRepository>(
      () => _i880.LaporanRepositoryImpl(
        gh<_i160.AppDatabase>(),
        gh<_i997.TokoService>(),
      ),
    );
    gh.lazySingleton<_i272.DashboardRepository>(
      () => _i283.DashboardRepositoryImpl(
        gh<_i160.AppDatabase>(),
        gh<_i997.TokoService>(),
      ),
    );
    gh.lazySingleton<_i345.SupabaseSyncService>(
      () => _i345.SupabaseSyncService(
        db: gh<_i160.AppDatabase>(),
        supabase: gh<_i454.SupabaseClient>(),
        prefs: gh<_i460.SharedPreferences>(),
        tokoService: gh<_i997.TokoService>(),
      ),
    );
    gh.lazySingleton<_i88.SupplierRepository>(
      () => _i994.SupplierRepositoryImpl(
        gh<_i160.AppDatabase>(),
        gh<_i345.SupabaseSyncService>(),
        gh<_i997.TokoService>(),
      ),
    );
    gh.lazySingleton<_i1073.AuthRepository>(
      () => _i895.AuthRepositoryImpl(
        gh<_i160.AppDatabase>(),
        gh<_i454.SupabaseClient>(),
        gh<_i460.SharedPreferences>(),
        gh<_i997.TokoService>(),
      ),
    );
    gh.factory<_i701.SyncBloc>(
      () => _i701.SyncBloc(
        syncService: gh<_i345.SupabaseSyncService>(),
        connectivity: gh<_i895.Connectivity>(),
      ),
    );
    gh.factory<_i286.DashboardBloc>(
      () => _i286.DashboardBloc(gh<_i272.DashboardRepository>()),
    );
    gh.lazySingleton<_i36.HutangPiutangRepository>(
      () => _i294.HutangPiutangRepositoryImpl(
        gh<_i160.AppDatabase>(),
        gh<_i345.SupabaseSyncService>(),
        gh<_i997.TokoService>(),
      ),
    );
    gh.lazySingleton<_i803.PendingOrderRepository>(
      () => _i803.PendingOrderRepositoryImpl(
        gh<_i160.AppDatabase>(),
        gh<_i345.SupabaseSyncService>(),
        gh<_i997.TokoService>(),
      ),
    );
    gh.lazySingleton<_i747.RiwayatStokRepository>(
      () => _i561.RiwayatStokRepositoryImpl(
        gh<_i160.AppDatabase>(),
        gh<_i345.SupabaseSyncService>(),
        gh<_i997.TokoService>(),
      ),
    );
    gh.lazySingleton<_i673.TransaksiRepository>(
      () => _i942.TransaksiRepositoryImpl(
        gh<_i160.AppDatabase>(),
        gh<_i345.SupabaseSyncService>(),
        gh<_i997.TokoService>(),
      ),
    );
    gh.lazySingleton<_i331.GetLastPenjualanByProduk>(
      () => _i331.GetLastPenjualanByProduk(gh<_i673.TransaksiRepository>()),
    );
    gh.lazySingleton<_i287.GetAllTransaksi>(
      () => _i287.GetAllTransaksi(gh<_i673.TransaksiRepository>()),
    );
    gh.lazySingleton<_i20.GetTransaksiById>(
      () => _i20.GetTransaksiById(gh<_i673.TransaksiRepository>()),
    );
    gh.lazySingleton<_i773.AddSupplier>(
      () => _i773.AddSupplier(gh<_i88.SupplierRepository>()),
    );
    gh.lazySingleton<_i82.DeleteSupplier>(
      () => _i82.DeleteSupplier(gh<_i88.SupplierRepository>()),
    );
    gh.lazySingleton<_i715.GetAllSupplier>(
      () => _i715.GetAllSupplier(gh<_i88.SupplierRepository>()),
    );
    gh.lazySingleton<_i1048.SearchSupplier>(
      () => _i1048.SearchSupplier(gh<_i88.SupplierRepository>()),
    );
    gh.lazySingleton<_i699.UpdateSupplier>(
      () => _i699.UpdateSupplier(gh<_i88.SupplierRepository>()),
    );
    gh.factory<_i141.AuthBloc>(
      () => _i141.AuthBloc(
        authRepository: gh<_i1073.AuthRepository>(),
        tokoService: gh<_i997.TokoService>(),
      ),
    );
    gh.factory<_i318.HutangBloc>(
      () => _i318.HutangBloc(repository: gh<_i36.HutangPiutangRepository>()),
    );
    gh.lazySingleton<_i228.PembelianRepository>(
      () => _i810.PembelianRepositoryImpl(
        gh<_i160.AppDatabase>(),
        gh<_i345.SupabaseSyncService>(),
        gh<_i997.TokoService>(),
      ),
    );
    gh.lazySingleton<_i258.PendingPembelianRepository>(
      () => _i54.PendingPembelianRepositoryImpl(
        gh<_i160.AppDatabase>(),
        gh<_i345.SupabaseSyncService>(),
        gh<_i997.TokoService>(),
      ),
    );
    gh.lazySingleton<_i680.ProdukRepository>(
      () => _i601.ProdukRepositoryImpl(
        gh<_i160.AppDatabase>(),
        gh<_i345.SupabaseSyncService>(),
        gh<_i997.TokoService>(),
      ),
    );
    gh.lazySingleton<_i479.UpdatePembelian>(
      () => _i479.UpdatePembelian(
        pembelianRepository: gh<_i228.PembelianRepository>(),
        produkRepository: gh<_i680.ProdukRepository>(),
        riwayatStokRepository: gh<_i747.RiwayatStokRepository>(),
      ),
    );
    gh.lazySingleton<_i895.NotifikasiRepository>(
      () => _i833.NotifikasiRepositoryImpl(
        gh<_i160.AppDatabase>(),
        gh<_i345.SupabaseSyncService>(),
        gh<_i997.TokoService>(),
      ),
    );
    gh.lazySingleton<_i408.BuatPembelian>(
      () => _i408.BuatPembelian(
        pembelianRepository: gh<_i228.PembelianRepository>(),
        produkRepository: gh<_i680.ProdukRepository>(),
        riwayatStokRepository: gh<_i747.RiwayatStokRepository>(),
        tokoService: gh<_i997.TokoService>(),
        db: gh<_i160.AppDatabase>(),
      ),
    );
    gh.lazySingleton<_i413.AddNotifikasi>(
      () => _i413.AddNotifikasi(gh<_i895.NotifikasiRepository>()),
    );
    gh.lazySingleton<_i991.GetAllNotifikasi>(
      () => _i991.GetAllNotifikasi(gh<_i895.NotifikasiRepository>()),
    );
    gh.lazySingleton<_i39.GetUnreadNotifikasi>(
      () => _i39.GetUnreadNotifikasi(gh<_i895.NotifikasiRepository>()),
    );
    gh.lazySingleton<_i665.MarkAsRead>(
      () => _i665.MarkAsRead(gh<_i895.NotifikasiRepository>()),
    );
    gh.lazySingleton<_i878.WatchUnreadCount>(
      () => _i878.WatchUnreadCount(gh<_i895.NotifikasiRepository>()),
    );
    gh.lazySingleton<_i569.GetLastHargaChangeByProduk>(
      () => _i569.GetLastHargaChangeByProduk(gh<_i895.NotifikasiRepository>()),
    );
    gh.factory<_i482.SupplierBloc>(
      () => _i482.SupplierBloc(
        getAllSupplier: gh<_i715.GetAllSupplier>(),
        searchSupplier: gh<_i1048.SearchSupplier>(),
        addSupplier: gh<_i773.AddSupplier>(),
        updateSupplier: gh<_i699.UpdateSupplier>(),
        deleteSupplier: gh<_i82.DeleteSupplier>(),
      ),
    );
    gh.factory<_i166.NotifikasiBloc>(
      () => _i166.NotifikasiBloc(
        getAllNotifikasi: gh<_i991.GetAllNotifikasi>(),
        getUnreadNotifikasi: gh<_i39.GetUnreadNotifikasi>(),
        markAsRead: gh<_i665.MarkAsRead>(),
      ),
    );
    gh.lazySingleton<_i609.GetRiwayatStok>(
      () => _i609.GetRiwayatStok(gh<_i747.RiwayatStokRepository>()),
    );
    gh.factory<_i17.LaporanBloc>(
      () => _i17.LaporanBloc(
        transaksiRepository: gh<_i673.TransaksiRepository>(),
        laporanRepository: gh<_i620.LaporanRepository>(),
      ),
    );
    gh.factory<_i172.TransaksiBloc>(
      () => _i172.TransaksiBloc(
        getAllTransaksi: gh<_i287.GetAllTransaksi>(),
        getTransaksiById: gh<_i20.GetTransaksiById>(),
      ),
    );
    gh.lazySingleton<_i278.AddProduk>(
      () => _i278.AddProduk(gh<_i680.ProdukRepository>()),
    );
    gh.lazySingleton<_i536.AddSatuan>(
      () => _i536.AddSatuan(gh<_i680.ProdukRepository>()),
    );
    gh.lazySingleton<_i480.DeleteProduk>(
      () => _i480.DeleteProduk(gh<_i680.ProdukRepository>()),
    );
    gh.lazySingleton<_i109.DeleteSatuan>(
      () => _i109.DeleteSatuan(gh<_i680.ProdukRepository>()),
    );
    gh.lazySingleton<_i543.DeleteSatuanByProdukId>(
      () => _i543.DeleteSatuanByProdukId(gh<_i680.ProdukRepository>()),
    );
    gh.lazySingleton<_i1053.GetAllProduk>(
      () => _i1053.GetAllProduk(gh<_i680.ProdukRepository>()),
    );
    gh.lazySingleton<_i852.GetProdukByBarcode>(
      () => _i852.GetProdukByBarcode(gh<_i680.ProdukRepository>()),
    );
    gh.lazySingleton<_i956.GetProdukById>(
      () => _i956.GetProdukById(gh<_i680.ProdukRepository>()),
    );
    gh.lazySingleton<_i756.SearchProduk>(
      () => _i756.SearchProduk(gh<_i680.ProdukRepository>()),
    );
    gh.lazySingleton<_i992.UpdateProduk>(
      () => _i992.UpdateProduk(gh<_i680.ProdukRepository>()),
    );
    gh.lazySingleton<_i233.UpdateSatuan>(
      () => _i233.UpdateSatuan(gh<_i680.ProdukRepository>()),
    );
    gh.factory<_i1061.PembelianBloc>(
      () => _i1061.PembelianBloc(
        repository: gh<_i228.PembelianRepository>(),
        buatPembelian: gh<_i408.BuatPembelian>(),
        updatePembelian: gh<_i479.UpdatePembelian>(),
      ),
    );
    gh.lazySingleton<_i991.BuatTransaksi>(
      () => _i991.BuatTransaksi(
        transaksiRepository: gh<_i673.TransaksiRepository>(),
        produkRepository: gh<_i680.ProdukRepository>(),
        riwayatStokRepository: gh<_i747.RiwayatStokRepository>(),
        hutangPiutangRepository: gh<_i36.HutangPiutangRepository>(),
        notifikasiRepository: gh<_i895.NotifikasiRepository>(),
        tokoService: gh<_i997.TokoService>(),
        db: gh<_i160.AppDatabase>(),
      ),
    );
    gh.lazySingleton<_i784.GetLastPembelianByProduk>(
      () => _i784.GetLastPembelianByProduk(gh<_i228.PembelianRepository>()),
    );
    gh.lazySingleton<_i995.TambahStok>(
      () => _i995.TambahStok(
        gh<_i680.ProdukRepository>(),
        gh<_i747.RiwayatStokRepository>(),
      ),
    );
    gh.factory<_i308.ProdukBloc>(
      () => _i308.ProdukBloc(
        getAllProduk: gh<_i1053.GetAllProduk>(),
        searchProduk: gh<_i756.SearchProduk>(),
        addProduk: gh<_i278.AddProduk>(),
        updateProduk: gh<_i992.UpdateProduk>(),
        deleteProduk: gh<_i480.DeleteProduk>(),
        addSatuan: gh<_i536.AddSatuan>(),
        deleteSatuanByProdukId: gh<_i543.DeleteSatuanByProdukId>(),
      ),
    );
    gh.factory<_i360.StokBloc>(
      () => _i360.StokBloc(
        getRiwayatStok: gh<_i609.GetRiwayatStok>(),
        tambahStok: gh<_i995.TambahStok>(),
      ),
    );
    gh.factory<_i207.CashierBloc>(
      () => _i207.CashierBloc(
        getAllProduk: gh<_i1053.GetAllProduk>(),
        getProdukByBarcode: gh<_i852.GetProdukByBarcode>(),
        buatTransaksi: gh<_i991.BuatTransaksi>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i464.RegisterModule {}
