import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

import '../../core/di/injection.dart';
import '../../core/platform/app_platform.dart';
import 'local_notification_service.dart';
import 'supabase_sync_service.dart';

class FcmService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final SupabaseClient _supabase = Supabase.instance.client;
  static String? _cachedToken;

  static Future<void> init() async {
    if (AppPlatform.isDesktop) return; // FCM is mobile-only.
    try {
      await Firebase.initializeApp();
    } catch (e) {
      if (kDebugMode) debugPrint('Firebase initialization error: $e');
      return;
    }

    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) debugPrint('User granted FCM permission');

      try {
        String? token = await _firebaseMessaging.getToken();
        if (token != null) {
          _cachedToken = token;
          if (kDebugMode) debugPrint('FCM Token: $token');
          await saveTokenToSupabase(token);
        }
      } catch (e) {
        if (kDebugMode) debugPrint('Failed to get FCM token: $e');
      }

      // Simpan token lagi setiap kali user login (misal setelah reinstall)
      _supabase.auth.onAuthStateChange.listen((data) {
        if (data.session != null && _cachedToken != null) {
          saveTokenToSupabase(_cachedToken);
        }
      });

      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        _cachedToken = newToken;
        saveTokenToSupabase(newToken);
      });
      
      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        if (kDebugMode) debugPrint('Got a message whilst in the foreground!');
        if (message.notification != null) {
          sl<LocalNotificationService>().showNotification(
            id: DateTime.now().millisecond,
            title: message.notification!.title ?? 'Notifikasi Baru',
            body: message.notification!.body ?? '',
            payload: message.data['orderId'] != null ? 'online_orders' : null,
          );
        }

        // Pull data order baru agar langsung muncul di UI tanpa perlu refresh
        if (message.data['orderId'] != null) {
          try {
            final syncService = sl<SupabaseSyncService>();
            await syncService.pullOnlineOrdersForce();
            syncService.notifyOnlineOrderReceived();
          } catch (e) {
            if (kDebugMode) debugPrint('Gagal pull order dari FCM foreground: $e');
          }
        }
      });
    }
  }

  static Future<void> saveTokenToSupabase(String? token) async {
    if (token == null) return;
    final user = _supabase.auth.currentUser;
    if (user == null) return; // Jika belum login, abaikan

    try {
      await _supabase.from('fcm_tokens').upsert({
        'user_id': user.id,
        'token': token,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      }, onConflict: 'token');
    } catch (e) {
      if (kDebugMode) debugPrint('Gagal menyimpan token FCM ke Supabase: $e');
    }
  }
}
