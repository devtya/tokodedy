import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState, User;
import 'package:workmanager/workmanager.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/services/supabase_sync_service.dart';
import 'data/services/local_notification_service.dart';
import 'data/services/fcm_service.dart';

import 'domain/entities/user.dart';
import 'core/config.dart';
import 'core/di/injection.dart';
import 'core/services/update_service.dart';
import 'core/theme/app_theme.dart';
import 'data/services/bluetooth_printer_service.dart';
import 'data/services/printer_settings.dart';
import 'i18n/strings.g.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/auth/auth_event.dart';
import 'presentation/blocs/auth/auth_state.dart';
import 'presentation/blocs/local_auth/local_auth_bloc.dart';
import 'presentation/blocs/local_auth/local_auth_event.dart';
import 'presentation/blocs/local_auth/local_auth_state.dart';
import 'presentation/blocs/sync/sync_bloc.dart';
import 'presentation/blocs/online_order/online_order_bloc.dart';
import 'presentation/blocs/theme/theme_cubit.dart';
import 'presentation/pages/shared/home_page.dart';
import 'presentation/pages/shared/initial_sync_page.dart';
import 'presentation/pages/shared/login_page.dart';
import 'presentation/pages/shared/pin_setup_page.dart';
import 'presentation/pages/shared/pin_verify_page.dart';
import 'presentation/pages/shared/reset_password_page.dart';
import 'presentation/pages/shared/online_order_page.dart';

/// Global navigator key untuk akses dari service layer (notifikasi, dll)
final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

Future<void> _checkUpdate() async {
  try {
    final updateService = sl<UpdateService>();
    final info = await updateService.checkForUpdate();
    if (info != null && info.url.isNotEmpty) {
      // Update tersedia — dialog akan muncul di HomePage
    }
  } catch (_) {}
}

class _PinGate extends StatefulWidget {
  final User user;
  const _PinGate({required this.user});

  @override
  State<_PinGate> createState() => _PinGateState();
}

class _PinGateState extends State<_PinGate> {
  bool _hasChecked = false;

  @override
  void initState() {
    super.initState();
    context.read<LocalAuthBloc>().add(CheckPinEvent(widget.user.id!));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LocalAuthBloc, LocalAuthState>(
      listenWhen: (prev, curr) => curr is PinReady || curr is PinNotSet || curr is PinError || curr is PinVerified,
      listener: (context, state) {
        if (!_hasChecked && (state is PinReady || state is PinNotSet || state is PinError)) {
          setState(() => _hasChecked = true);
        }
      },
      builder: (context, state) {
        if (!_hasChecked) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is PinNotSet) {
          return PinSetupPage(userId: widget.user.id!);
        }

        return PinVerifyPage(
          userId: widget.user.id!,
          onVerified: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
              (route) => false,
            );
          },
          onSkip: () {
            context.read<AuthBloc>().add(LogoutEvent());
          },
        );
      },
    );
  }
}

/// Handler untuk FCM ketika app dalam keadaan terminated (killed).
/// Cukup log saja — Android otomatis menampilkan system tray notification
/// karena payload FCM memiliki field `notification`.
/// Data akan ter-pull oleh periodic polling atau Realtime setelah app aktif.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('[FCM Background] Message received: orderId=${message.data['orderId']}');
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      await Supabase.initialize(
        url: AppConfig.supabaseUrl,
        anonKey: AppConfig.supabaseAnonKey,
      );
      await initDependencies();
      final syncService = sl<SupabaseSyncService>();
      await syncService.pullOnlineOrdersForce();
      await syncService.flushQueue();
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id', null);
  LocaleSettings.useDeviceLocale();

  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );

  Workmanager().initialize(
    callbackDispatcher,
  );
  Workmanager().registerPeriodicTask(
    "sync_task_1",
    "syncSupabaseTask",
    frequency: const Duration(minutes: 15),
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
  );

  await initDependencies();

  await sl<LocalNotificationService>().initialize(
    onNotificationTap: (payload) {
      if (payload == 'online_orders') {
        appNavigatorKey.currentState?.push(
          MaterialPageRoute(builder: (_) => BlocProvider.value(
            value: sl<OnlineOrderBloc>(),
            child: const OnlineOrderPage(),
          )),
        );
      }
    },
  );

  // Register background & foreground FCM handlers
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await FcmService.init();

  _checkUpdate();
  runApp(const TokodedyApp());
}

class TokodedyApp extends StatefulWidget {
  const TokodedyApp({super.key});

  @override
  State<TokodedyApp> createState() => _TokodedyAppState();
}

class _TokodedyAppState extends State<TokodedyApp> with WidgetsBindingObserver {
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
        appNavigatorKey.currentState?.push(
          MaterialPageRoute(builder: (_) => const ResetPasswordPage()),
        );
      }
    });

    // Handle FCM notification tap (app di background → foreground)
    FirebaseMessaging.onMessageOpenedApp.listen(_handleFcmNotificationTap);

    // Handle FCM notification yang membuka app dari keadaan terminated (killed)
    FirebaseMessaging.instance.getInitialMessage().then(_handleFcmNotificationTap);
  }

  void _handleFcmNotificationTap(RemoteMessage? message) {
    if (message == null) return;
    final orderId = message.data['orderId'];
    if (orderId != null) {
      appNavigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => BlocProvider.value(
          value: sl<OnlineOrderBloc>(),
          child: const OnlineOrderPage(),
        )),
      );
    }
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
            child: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => sl<LocalAuthBloc>(),
                ),
              ],
              child: TranslationProvider(
                child: Builder(builder: (context) {
                  return MaterialApp(
                    navigatorKey: appNavigatorKey,
                    title: 'Tokodedy',
                    debugShowCheckedModeBanner: false,
                    themeMode: themeMode,
                    theme: AppTheme.lightTheme,
                    darkTheme: AppTheme.darkTheme,
                    locale: TranslationProvider.of(context).flutterLocale,
                    supportedLocales: AppLocaleUtils.supportedLocales,
                    localizationsDelegates: GlobalMaterialLocalizations.delegates,
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
                          return _PinGate(user: state.user);
                        }
                        return const LoginPage();
                      },
                    ),
                  );
                }),
              ),
            ),
          );
        },
      ),
    );
  }
}
