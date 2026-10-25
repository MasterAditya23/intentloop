import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = 
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
    );

    // Request notification permission for Android 13+
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> showTestNotification() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'intentloop_channel',
      'Mindful Reminders',
      channelDescription: 'Gentle nudges to check your intentions',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails = 
        NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      id: 0,
      title: 'IntentLoop — A quick check-in',
      body: 'Hey buddy! What are today\'s plans? Set your intention before you start scrolling.',
      notificationDetails: platformDetails,
    );
  }
}