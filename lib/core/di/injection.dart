import 'package:injectable/injectable.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../data/database/app_database.dart';

import 'injection.config.dart';
import 'printer_module.dart';

final sl = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> initDependencies() async {
  await sl.init();
  registerReceiptPrinter();
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
