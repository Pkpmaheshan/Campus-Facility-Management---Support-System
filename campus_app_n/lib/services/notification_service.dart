import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // Android settings
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
        InitializationSettings(android: androidSettings);

    await _notifications.initialize(settings);

    // 🔔 Request Notification Permission (Android 13+)
    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    // Initialize timezone
    tz.initializeTimeZones();
    try {
      tz.setLocalLocation(tz.getLocation('Asia/Colombo'));
    } catch (e) {
      print("Timezone initialization failed: $e");
    }
  }

  static Future<void> scheduleNotification(
      int id, String title, DateTime dateTime) async {
    print("Scheduling notification for: $dateTime");

    // Robust TZDateTime creation
    final tz.TZDateTime scheduledAt = tz.TZDateTime(
      tz.local,
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
    );

    await _notifications.zonedSchedule(
      id,
      "Reminder",
      title,
      scheduledAt,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'reminder_channel',
          'Reminder Channel',
          channelDescription: 'Channel for campus reminders',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
    print("Notification scheduled successfully.");
  }

  // 🔔 TEST NOTIFICATION (Instant)
  static Future<void> showInstantNotification(String title) async {
    await _notifications.show(
      0,
      "Test Notification",
      title,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_channel',
          'Test Channel',
          channelDescription: 'Test notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }
}
