import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _plugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
      },
    );
  }

  static Future<void> scheduleServiceNotification({
    required int id,
    required String carName,
    required DateTime nextServiceDate,
  }) async {
    // Уведомление за 7 дней до даты ТО
    final notifyDate = nextServiceDate.subtract(const Duration(days: 7));
    if (notifyDate.isAfter(DateTime.now())) {
      await _plugin.zonedSchedule(
        id,
        'ServiceReminder',
        '$carName — плановое ТО через 7 дней',
        tz.TZDateTime.from(notifyDate, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'service_reminders',
            'Service Reminders',
            channelDescription: 'Notifications for scheduled maintenance',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dateAndTime,
      );
    }
  }

  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  static Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id);
  }
}