import 'dart:async';
import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'usage_service.dart';
import 'app_mapper.dart';
import 'notification_service.dart';

Future<void> initializeBackgroundService() async {
  final service = FlutterBackgroundService();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'foreground_service_channel',
    'Background Monitoring',
    description: 'Keeps IntentLoop running to detect distracting apps.',
    importance: Importance.low,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: 'foreground_service_channel',
      initialNotificationTitle: 'IntentLoop Active',
      initialNotificationContent: 'Monitoring for mindful sessions...',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: false,
    ),
  );
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  // Poll usage stats every 5 seconds in the background
  Timer.periodic(const Duration(seconds: 5), (timer) async {
    bool granted = await UsageService.hasPermission();
    if (!granted) return;

    String? recentPackage = await UsageService.getRecentActiveApp();
    if (recentPackage != null) {
      String? mappedApp = AppMapper.getAppName(recentPackage);
      if (mappedApp != null) {
        // Trigger a notification to open the session setup
        await NotificationService.showTestNotification(); 
      }
    }
  });
}