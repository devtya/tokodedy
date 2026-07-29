import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'core/platform/app_platform.dart';
import 'core/platform/ui_scale.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState, User;
import 'package:workmanager/workmanager.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/services/supabase_sync_service.dart';
import 'data/services/local_notification_service.dart';
import 'data/services/fcm_service.dart';

import 'domain/entities/user.dart';
import 'domain/repositories/auth_repository.dart';
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
  if (kDebugMode) debugPrint('[FCM Background] Message received: orderId=${message.data['orderId']}');
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

  // Phase 1 — local-only init (must be fast, no network dependency)
  await initDependencies();
  await UiScale.instance.load();

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

  // Phase 2 — network-dependent init (fire-and-forget; timeout so it doesn't hang offline)
  _initNetworkServices();

  runApp(const TokodedyApp());
}

Future<void> _initNetworkServices() async {
  try {
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      anonKey: AppConfig.supabaseAnonKey,
    ).timeout(const Duration(seconds: 5));

    // Supabase ready — set up auth listener (password recovery deep link)
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.passwordRecovery) {
        appNavigatorKey.currentState?.push(
          MaterialPageRoute(builder: (_) => const ResetPasswordPage()),
        );
      }
    });
  } catch (_) {
    if (kDebugMode) debugPrint('[main] Supabase init timed out — offline mode');
  }

  // Workmanager & Firebase Messaging are Android/iOS only — skip on desktop
  // (Windows) where the plugins have no implementation and would throw.
  if (AppPlatform.isMobile) {
    Workmanager().initialize(callbackDispatcher);
    Workmanager().registerPeriodicTask(
      "sync_task_1",
      "syncSupabaseTask",
      frequency: const Duration(minutes: 15),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );

    try {
      await Firebase.initializeApp();

      // Register background FCM handler
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      // FCM foreground notification tap (app dari background → foreground)
      FirebaseMessaging.onMessageOpenedApp.listen(_handleFcmNotificationTap);

      // FCM notification yang membuka app dari terminated (killed)
      FirebaseMessaging.instance.getInitialMessage().then(_handleFcmNotificationTap);

      await FcmService.init().timeout(const Duration(seconds: 10));
    } catch (_) {
      if (kDebugMode) debugPrint('[main] Firebase/FCM init timed out — offline mode');
    }
  }

  _checkUpdate();
}

class TokodedyApp extends StatefulWidget {
  const TokodedyApp({super.key});

  @override
  State<TokodedyApp> createState() => _TokodedyAppState();
}

/// Handle FCM notification tap (membuka halaman order saat notif diklik).
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

class _TokodedyAppState extends State<TokodedyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Auto-connect Bluetooth printer setelah widget tree siap
    Future.delayed(const Duration(seconds: 2), _tryAutoConnectBluetooth);
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
      if (settings.enabled) {
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
                    builder: (context, child) {
                      final mq = MediaQuery.of(context);
                      return ValueListenableBuilder<double>(
                        valueListenable: UiScale.instance.scale,
                        builder: (context, s, _) => MediaQuery(
                          data: mq.copyWith(textScaler: TextScaler.linear(s)),
                          child: child!,
                        ),
                      );
                    },
                    themeMode: themeMode,
                    theme: AppTheme.lightTheme,
                    darkTheme: AppTheme.darkTheme,
                    locale: TranslationProvider.of(context).flutterLocale,
                    supportedLocales: AppLocaleUtils.supportedLocales,
                    localizationsDelegates: GlobalMaterialLocalizations.delegates,
                    home: BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        if (kDebugMode) debugPrint('[Main-BlocBuilder] state=${state.runtimeType} | '
                            'isInitial=${state is AuthInitial} '
                            'isLoading=${state is AuthLoading} '
                            'isAuthd=${state is Authenticated} '
                            'isUnauthd=${state is Unauthenticated}');
                        if (state is AuthInitial || state is AuthLoading) {
                          if (kDebugMode) debugPrint('[Main-BlocBuilder] → showing SPLASH (AuthInitial/AuthLoading)');
                          return const Scaffold(
                            body: Center(child: CircularProgressIndicator()),
                          );
                        }
                        if (state is Authenticated) {
                          if (kDebugMode) debugPrint('[Main-BlocBuilder] → showing _PinGate');
                          return _PinGate(user: state.user);
                        }
                        if (state is AuthError) {
                          final localUser = sl<AuthRepository>().getCurrentUser();
                          if (localUser != null) {
                            if (kDebugMode) debugPrint('[Main-BlocBuilder] AuthError → fallback to _PinGate');
                            return _PinGate(user: localUser);
                          }
                          return const LoginPage();
                        }
                        if (kDebugMode) debugPrint('[Main-BlocBuilder] → showing LoginPage');
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
