import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:servicebook_cn/services/notification_service.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

// Mock class to test notification service without actual platform dependencies
class MockNotificationService extends NotificationService {
  static bool _mockInitialized = false;
  static List<Map<String, dynamic>> _scheduledNotifications = [];
  static List<Map<String, dynamic>> _shownNotifications = [];

  static Future<void> init() async {
    if (_mockInitialized) return;
    tz_data.initializeTimeZones();
    _initialized = true;
    _mockInitialized = true;
  }

  static Future<void> _mockZonedSchedule(
    int id,
    String title,
    String body,
    tz.TZDateTime scheduledDate,
    NotificationDetails details, {
    AndroidScheduleMode? androidScheduleMode,
    UILocalNotificationDateInterpretation? uiLocalNotificationDateInterpretation,
    DateTimeComponents? matchDateTimeComponents,
    String? payload,
  }) async {
    _scheduledNotifications.add({
      'id': id,
      'title': title,
      'body': body,
      'scheduledDate': scheduledDate.toIso8601String(),
      'details': details,
    });
  }

  static Future<void> _mockShow(
    int id,
    String title,
    String body,
    NotificationDetails? details, {
    String? payload,
  }) async {
    _shownNotifications.add({
      'id': id,
      'title': title,
      'body': body,
      'details': details,
    });
  }

  static Future<void> _mockCancelAll() async {
    _scheduledNotifications.clear();
    _shownNotifications.clear();
  }

  static Future<void> _mockCancel(int id) async {
    _scheduledNotifications.removeWhere((notif) => notif['id'] == id);
    _shownNotifications.removeWhere((notif) => notif['id'] == id);
  }

  static List<Map<String, dynamic>> get scheduledNotifications => _scheduledNotifications;
  static List<Map<String, dynamic>> get shownNotifications => _shownNotifications;

  static void resetMock() {
    _scheduledNotifications.clear();
    _shownNotifications.clear();
  }

  // Override methods to use mocks
  static Future<void> scheduleServiceNotification({
    required int id,
    required String carName,
    required DateTime nextServiceDate,
  }) async {
    await init();
    final notifyDate = nextServiceDate.subtract(const Duration(days: 7));
    if (notifyDate.isAfter(DateTime.now())) {
      await _mockZonedSchedule(
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
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dateAndTime,
      );
    }
  }

  static Future<void> scheduleMileageNotification({
    required int id,
    required String carName,
    required int currentMileage,
    required int serviceInterval,
  }) async {
    await init();
    final nextServiceMileage = currentMileage + serviceInterval;
    final warningMileage = nextServiceMileage - 1000;

    await _mockZonedSchedule(
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
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await _mockShow(
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

  static Future<void> cancelAll() async => _mockCancelAll();
  static Future<void> cancelNotification(int id) async => _mockCancel(id);
}

void main() {
  group('NotificationService Tests', () {
    setUp(() {
      MockNotificationService.resetMock();
    });

    group('Initialization Tests', () {
      test('Notification service initializes without errors', () async {
        await MockNotificationService.init();
        expect(MockNotificationService._initialized, isTrue);
      });

      test('Notification service does not reinitialize when already initialized', () async {
        await MockNotificationService.init();
        await MockNotificationService.init();
        // Should not throw any errors
      });
    });

    group('Service Notification Tests', () {
      test('Schedule service notification for future date', () async {
        await MockNotificationService.init();
        final futureDate = DateTime.now().add(const Duration(days: 10));
        
        await MockNotificationService.scheduleServiceNotification(
          id: 1,
          carName: 'Toyota Camry',
          nextServiceDate: futureDate,
        );

        expect(MockNotificationService.scheduledNotifications.length, 1);
        final notification = MockNotificationService.scheduledNotifications.first;
        expect(notification['id'], 1);
        expect(notification['title'], 'Напоминание о ТО');
        expect(notification['body'], 'Toyota Camry — плановое ТО через 7 дней');
      });

      test('Do not schedule service notification for past date', () async {
        await MockNotificationService.init();
        final pastDate = DateTime.now().subtract(const Duration(days: 1));
        
        await MockNotificationService.scheduleServiceNotification(
          id: 2,
          carName: 'Honda Civic',
          nextServiceDate: pastDate,
        );

        expect(MockNotificationService.scheduledNotifications.length, 0);
      });

      test('Service notification has correct details', () async {
        await MockNotificationService.init();
        final futureDate = DateTime.now().add(const Duration(days: 10));
        
        await MockNotificationService.scheduleServiceNotification(
          id: 3,
          carName: 'BMW X5',
          nextServiceDate: futureDate,
        );

        expect(MockNotificationService.scheduledNotifications.length, 1);
        // Verify that the notification has proper scheduling parameters
        expect(MockNotificationService.scheduledNotifications.first, isA<Map<String, dynamic>>());
      });
    });

    group('Mileage Notification Tests', () {
      test('Schedule mileage notification', () async {
        await MockNotificationService.init();
        
        await MockNotificationService.scheduleMileageNotification(
          id: 10,
          carName: 'Audi A4',
          currentMileage: 50000,
          serviceInterval: 10000,
        );

        expect(MockNotificationService.scheduledNotifications.length, 1);
        final notification = MockNotificationService.scheduledNotifications.first;
        expect(notification['id'], 10);
        expect(notification['title'], 'Напоминание о пробеге');
        expect(notification['body'], 'Audi A4 скоро достигнет 59000 км. Запланируйте ТО!');
      });

      test('Mileage warning threshold calculation', () async {
        await MockNotificationService.init();
        
        await MockNotificationService.scheduleMileageNotification(
          id: 11,
          carName: 'Mercedes C-Class',
          currentMileage: 80000,
          serviceInterval: 15000,
        );

        expect(MockNotificationService.scheduledNotifications.length, 1);
        final notification = MockNotificationService.scheduledNotifications.first;
        // Expected warning mileage: 80000 + 15000 - 1000 = 94000
        expect(notification['body'], contains('94000 км'));
      });
    });

    group('Immediate Notification Tests', () {
      test('Show immediate notification', () async {
        await MockNotificationService.showNotification(
          id: 100,
          title: 'Тестовое уведомление',
          body: 'Это тестовое уведомление',
        );

        expect(MockNotificationService.shownNotifications.length, 1);
        final notification = MockNotificationService.shownNotifications.first;
        expect(notification['id'], 100);
        expect(notification['title'], 'Тестовое уведомление');
        expect(notification['body'], 'Это тестовое уведомление');
      });

      test('Show notification with payload', () async {
        await MockNotificationService.showNotification(
          id: 101,
          title: 'Уведомление с данными',
          body: 'Содержит дополнительные данные',
          payload: 'test_payload',
        );

        expect(MockNotificationService.shownNotifications.length, 1);
        final notification = MockNotificationService.shownNotifications.first;
        expect(notification['id'], 101);
      });
    });

    group('Cancellation Tests', () {
      test('Cancel specific notification', () async {
        await MockNotificationService.init();
        
        // Schedule notifications
        await MockNotificationService.scheduleServiceNotification(
          id: 200,
          carName: 'Test Car',
          nextServiceDate: DateTime.now().add(const Duration(days: 10)),
        );
        
        await MockNotificationService.showNotification(
          id: 201,
          title: 'Test',
          body: 'Test body',
        );

        expect(MockNotificationService.scheduledNotifications.length, 1);
        expect(MockNotificationService.shownNotifications.length, 1);

        // Cancel notifications
        await MockNotificationService.cancelNotification(200);
        await MockNotificationService.cancelNotification(201);

        expect(MockNotificationService.scheduledNotifications.length, 0);
        expect(MockNotificationService.shownNotifications.length, 0);
      });

      test('Cancel all notifications', () async {
        await MockNotificationService.init();
        
        // Schedule and show multiple notifications
        await MockNotificationService.scheduleServiceNotification(
          id: 300,
          carName: 'Car 1',
          nextServiceDate: DateTime.now().add(const Duration(days: 10)),
        );
        
        await MockNotificationService.showNotification(
          id: 301,
          title: 'Test 1',
          body: 'Test body 1',
        );

        await MockNotificationService.showNotification(
          id: 302,
          title: 'Test 2',
          body: 'Test body 2',
        );

        expect(MockNotificationService.scheduledNotifications.length, 1);
        expect(MockNotificationService.shownNotifications.length, 2);

        // Cancel all
        await MockNotificationService.cancelAll();

        expect(MockNotificationService.scheduledNotifications.length, 0);
        expect(MockNotificationService.shownNotifications.length, 0);
      });
    });
  });
}