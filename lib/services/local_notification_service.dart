import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {

  static final FlutterLocalNotificationsPlugin
      notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {

    const androidSettings =
        AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const settings =
        InitializationSettings(
      android: androidSettings,
    );

    await notifications.initialize(
      settings,
    );
  }

  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {

const androidDetails =
    AndroidNotificationDetails(
  'shieldher_emergency_v2',
  'ShieldHer Emergency Alerts',

  importance: Importance.max,
  priority: Priority.high,

  playSound: true,
  enableVibration: true,
);

    const details =
        NotificationDetails(
      android: androidDetails,
    );

    await notifications.show(
      0,
      title,
      body,
      details,
    );
  }
}