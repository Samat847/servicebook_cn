import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();

    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _plugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint('[NotificationService] Notification tapped: ${response.payload}');
        // Handle notification tap - could navigate to specific screen
      },
    );

    _initialized = true;
    debugPrint('[NotificationService] Initialized');
  }

  /// Schedule service reminder notification
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
        'Напоминание о ТО',
        '$carName — плановое ТО через 7 дней',
        tz.TZDateTime.from(notifyDate, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'service_reminders',
            'Напоминания о ТО',
            channelDescription: 'Уведомления о плановом обслуживании',
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
      debugPrint('[NotificationService] Scheduled service reminder for $carName');
    }
  }

  /// Schedule notification based on mileage
  static Future<void> scheduleMileageNotification({
    required int id,
    required String carName,
    required int currentMileage,
    required int serviceInterval,
  }) async {
    final nextServiceMileage = currentMileage + serviceInterval;
    final warningMileage = nextServiceMileage - 1000;

    await _plugin.zonedSchedule(
      id,
      'Напоминание о пробеге',
      '$carName скоро достигнет $warningMileage км. Запланируйте ТО!',
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      const NotificationDetails(
                android: AndroidNotificationDetails(
                  'mileage_reminders',
                  'Напоминания о пробеге',
                  channelDescription: 'Уведомления о пробеге автомобиля',
                  importance: Importance.default,
                  priority: Priority.default,
                ),
                iOS: DarwinNotificationDetails(),
              ),
              androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
              uiLocalNotificationDateInterpretation:
                  UILocalNotificationDateInterpretation.absoluteTime,
    );
    debugPrint('[NotificationService] Scheduled mileage reminder for $carName');
  }

  /// Show immediate notification
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await _plugin.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'general_notifications',
          'Общие уведомления',
          channelDescription: 'Общие уведомления приложения',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: payload,
    );
  }

  /// Request notification permissions (for iOS 13+)
  static Future<void> requestPermissions() async {
    await _plugin.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  /// Cancel all notifications
  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
    debugPrint('[NotificationService] All notifications cancelled');
  }

  /// Cancel specific notification
  static Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id);
    debugPrint('[NotificationService] Notification $id cancelled');
  }

  /// Get pending notifications
  static Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _plugin.pendingNotificationRequests();
  }
}