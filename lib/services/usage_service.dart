import 'package:usage_stats/usage_stats.dart';

class UsageService {
  // Check if the user has enabled "Usage Access" in Android settings
  static Future<bool> hasPermission() async {
    bool? granted = await UsageStats.checkUsagePermission();
    return granted ?? false;
  }

  // Open the Android system settings screen to let the user grant permission
  static Future<void> requestPermission() async {
    await UsageStats.grantUsagePermission();
  }

  // Query events from the last few seconds to see if a target app was opened
  static Future<String?> getRecentActiveApp() async {
    try {
      bool permitted = await hasPermission();
      if (!permitted) return null;

      final endDate = DateTime.now();
      final startDate = endDate.subtract(const Duration(seconds: 10));

      // Query usage events in the last 10 seconds
      List events = await UsageStats.queryEvents(startDate, endDate);
      
      if (events.isNotEmpty) {
        // Safely sort events by timestamp descending (most recent first)
        events.sort((a, b) {
          int timeA = int.tryParse(a.timeStamp?.toString() ?? '0') ?? 0;
          int timeB = int.tryParse(b.timeStamp?.toString() ?? '0') ?? 0;
          return timeB.compareTo(timeA);
        });
        
        for (var event in events) {
          // Event type '1' represents ACTIVITY_RESUMED (app brought to foreground)
          if (event.eventType.toString() == '1' && event.packageName != null) {
            return event.packageName;
          }
        }
      }
    } catch (e) {
      print('Error querying usage stats: $e');
    }
    return null;
  }
}