import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';

import '../../core/platform/app_platform.dart';

@lazySingleton
class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  void Function(String? payload)? _onTap;

  // Local notifications are only wired for Android/iOS. On desktop (Windows)
  // the plugin requires WindowsInitializationSettings; calling initialize()
  // without it throws and, being awaited before runApp, would prevent the
  // window from ever appearing. Skip entirely off-mobile.
  bool get _supported => AppPlatform.isMobile;

  Future<void> initialize({void Function(String? payload)? onNotificationTap}) async {
    if (!_supported) return;
    _onTap = onNotificationTap;
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        _onTap?.call(details.payload);
      },
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> showNotification({required int id, required String title, required String body, String? payload}) async {
    if (!_supported) return;
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'online_orders_channel',
      'Pesanan Online',
      channelDescription: 'Notifikasi saat ada pesanan online baru',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await _flutterLocalNotificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: platformChannelSpecifics,
      payload: payload,
    );
  }

  Future<void> showStokNotification({required int id, required String title, required String body, String? payload}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'stok_channel',
      'Peringatan Stok',
      channelDescription: 'Notifikasi stok menipis dan stok habis',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await _flutterLocalNotificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: platformChannelSpecifics,
      payload: payload,
    );
  }
}
