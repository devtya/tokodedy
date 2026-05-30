import 'package:injectable/injectable.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../presentation/blocs/theme/theme_cubit.dart';
import '../../data/database/app_database.dart';
import '../../data/database/supplier_products_dao.dart';
import '../services/toko_service.dart';
import '../services/update_service.dart';
import '../../data/services/printer_service.dart';
import '../../data/services/printer_settings.dart';
import '../../data/services/network_printer_service.dart';
import '../../data/services/bluetooth_printer_service.dart';
import '../../data/services/receipt_generator.dart';

import 'injection.config.dart';

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

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> initDependencies() async {
  await sl.init();
  _initPrinterService();
}

@module
abstract class RegisterModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @singleton
  AppDatabase get db => AppDatabase();

  @lazySingleton
  SupabaseClient get supabase => Supabase.instance.client;

  @lazySingleton
  Connectivity get connectivity => Connectivity();
}
