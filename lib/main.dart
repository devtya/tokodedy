import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/config.dart';
import 'core/di/injection.dart';
import 'core/services/update_service.dart';
import 'core/theme/app_theme.dart';
import 'data/services/bluetooth_printer_service.dart';
import 'data/services/printer_settings.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/auth/auth_event.dart';
import 'presentation/blocs/auth/auth_state.dart';
import 'presentation/blocs/sync/sync_bloc.dart';
import 'presentation/blocs/theme/theme_cubit.dart';
import 'presentation/pages/shared/home_page.dart';
import 'presentation/pages/shared/initial_sync_page.dart';
import 'presentation/pages/shared/login_page.dart';
import 'presentation/pages/shared/reset_password_page.dart';

Future<void> _checkUpdate() async {
  try {
    final updateService = sl<UpdateService>();
    final info = await updateService.checkForUpdate();
    if (info != null && info.url.isNotEmpty) {
      // Update tersedia — dialog akan muncul di HomePage
    }
  } catch (_) {}
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id', null);

  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );

  await initDependencies();

  _checkUpdate();
  runApp(const HendKasirApp());
}

class HendKasirApp extends StatefulWidget {
  const HendKasirApp({super.key});

  @override
  State<HendKasirApp> createState() => _HendKasirAppState();
}

class _HendKasirAppState extends State<HendKasirApp> with WidgetsBindingObserver {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Auto-connect Bluetooth printer setelah widget tree siap
    Future.delayed(const Duration(seconds: 2), _tryAutoConnectBluetooth);

    // Listen untuk Supabase auth events — handle password recovery deep link
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.passwordRecovery) {
        // User klik link reset password dari email → buka halaman isi password baru
        _navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (_) => const ResetPasswordPage()),
        );
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _tryAutoConnectBluetooth();
    }
  }

  void _tryAutoConnectBluetooth() {
    try {
      final settings = sl<PrinterSettings>();
      if (settings.type == 'bluetooth' && settings.enabled) {
        sl<BluetoothPrinterService>().autoConnect();
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ThemeCubit>(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => sl<AuthBloc>()..add(CheckAuthStatus()),
              ),
              BlocProvider(create: (context) => sl<SyncBloc>()),
            ],
            child: MaterialApp(
              navigatorKey: _navigatorKey,
              title: 'HendKasir',
              debugShowCheckedModeBanner: false,
              themeMode: (Platform.isWindows || Platform.isLinux || Platform.isMacOS)
                  ? ThemeMode.light
                  : themeMode,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              home: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthInitial ||
                      state is AuthLoading &&
                          state is! Authenticated &&
                          state is! Unauthenticated) {
                    return const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (state is Authenticated) {
                    return FutureBuilder<bool>(
                      future: context.read<SyncBloc>().isInitialSyncDone,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Scaffold(
                            body: Center(child: CircularProgressIndicator()),
                          );
                        }
                        if (snapshot.data == true) {
                          return const HomePage();
                        }
                        return const InitialSyncPage(destination: HomePage());
                      },
                    );
                  }
                  return const LoginPage();
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
