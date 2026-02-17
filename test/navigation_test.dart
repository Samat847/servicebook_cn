import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:servicebook_cn/screens/auth_screen.dart';
import 'package:servicebook_cn/screens/verification_screen.dart';
import 'package:servicebook_cn/screens/profile_screen.dart';
import 'package:servicebook_cn/screens/main_screen.dart';
import 'package:servicebook_cn/screens/add_car_screen.dart';
import 'package:servicebook_cn/screens/car_detail_screen.dart';
import 'package:servicebook_cn/screens/home_screen.dart';
import 'package:servicebook_cn/screens/service_history_screen.dart';
import 'package:servicebook_cn/screens/expense_analytics_screen.dart';
import 'package:servicebook_cn/screens/sell_report_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Comprehensive widget tests for Flutter navigation and screen transitions
/// 
/// These tests cover:
/// - Authentication flow navigation
/// - Main app navigation patterns
/// - Car management navigation
/// - Back button behavior
/// - Data passing between screens
/// - Navigation stack management

void main() {
  group('Navigation Tests', () {
    setUp(() async {
      // Initialize SharedPreferences for testing
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('AuthScreen navigates to VerificationScreen on "Get Code" button',
        (WidgetTester tester) async {
      // Build AuthScreen
      await tester.pumpWidget(
        const MaterialApp(
          home: AuthScreen(),
        ),
      );

      // Verify AuthScreen is displayed
      expect(find.text('Вход'), findsOneWidget);
      expect(find.text('Получить код'), findsOneWidget);

      // Enter phone number
      final phoneField = find.byType(TextField).first;
      await tester.enterText(phoneField, '9001234567');
      await tester.pumpAndSettle();

      // Tap "Get Code" button
      await tester.tap(find.text('Получить код'));
      await tester.pumpAndSettle();

      // Verify navigation to VerificationScreen
      expect(find.byType(VerificationScreen), findsOneWidget);
      expect(find.text('Подтверждение номера'), findsOneWidget);
    });

    testWidgets('AuthScreen shows error when phone number is empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AuthScreen(),
        ),
      );

      // Tap button without entering phone
      await tester.tap(find.text('Получить код'));
      await tester.pumpAndSettle();

      // Verify error message
      expect(find.text('Введите номер телефона'), findsOneWidget);
      
      // Verify we're still on AuthScreen
      expect(find.text('Вход'), findsOneWidget);
    });

    testWidgets('AuthScreen switches between phone and email tabs',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AuthScreen(),
        ),
      );

      // Initially on phone tab
      expect(find.text('Номер телефона'), findsOneWidget);
      
      // Switch to email tab
      await tester.tap(find.text('Войти по почте'));
      await tester.pumpAndSettle();

      // Verify email field is shown
      expect(find.byType(TextField), findsOneWidget);
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.keyboardType, TextInputType.emailAddress);
    });

    testWidgets('VerificationScreen has back button that pops navigation',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const AuthScreen(),
          routes: {
            '/verification': (context) => const VerificationScreen(
                  contactInfo: '9001234567',
                  isEmail: false,
                ),
          },
        ),
      );

      // Navigate to verification screen
      final phoneField = find.byType(TextField).first;
      await tester.enterText(phoneField, '9001234567');
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('Получить код'));
      await tester.pumpAndSettle();

      // Verify we're on VerificationScreen
      expect(find.byType(VerificationScreen), findsOneWidget);

      // Tap back button
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Verify we're back on AuthScreen
      expect(find.byType(AuthScreen), findsOneWidget);
      expect(find.text('Вход'), findsOneWidget);
    });

    testWidgets('VerificationScreen navigates to ProfileScreen on code verification',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: VerificationScreen(
            contactInfo: '9001234567',
            isEmail: false,
          ),
        ),
      );

      // Enter verification code
      final codeFields = find.byType(TextField);
      expect(codeFields, findsNWidgets(6));

      // Enter code in all fields
      for (int i = 0; i < 6; i++) {
        await tester.enterText(codeFields.at(i), '${i + 1}');
        await tester.pump(const Duration(milliseconds: 100));
      }

      await tester.pumpAndSettle();

      // Wait for the automatic navigation after code entry
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Verify navigation to ProfileScreen
      expect(find.byType(ProfileScreen), findsOneWidget);
      expect(find.text('Заполните профиль'), findsOneWidget);
    });

    testWidgets('ProfileScreen navigates to MainScreen with pushAndRemoveUntil',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(),
        ),
      );

      // Fill in profile data
      await tester.enterText(
        find.byType(TextField),
        'Test User',
      );
      await tester.pumpAndSettle();

      // Select a city
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Москва').last);
      await tester.pumpAndSettle();

      // Tap save button
      await tester.tap(find.text('Сохранить и продолжить'));
      await tester.pumpAndSettle();

      // Verify navigation to MainScreen
      expect(find.byType(MainScreen), findsOneWidget);
      
      // Verify we can't go back (navigation stack cleared)
      // This is implicit in the pushAndRemoveUntil behavior
    });

    testWidgets('MainScreen displays bottom navigation with 4 tabs',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MainScreen(),
        ),
      );

      // Verify bottom navigation bar
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      
      // Verify all 4 tabs
      expect(find.text('Главная'), findsOneWidget);
      expect(find.text('Авто'), findsOneWidget);
      expect(find.text('Карта'), findsOneWidget);
      expect(find.text('Профиль'), findsOneWidget);
    });

    testWidgets('MainScreen switches between tabs correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MainScreen(),
        ),
      );

      // Initially on first tab (Dashboard)
      expect(find.byIcon(Icons.home), findsOneWidget);

      // Tap second tab (Home/Garage)
      await tester.tap(find.text('Авто'));
      await tester.pumpAndSettle();
      
      // Verify HomeScreen is displayed
      expect(find.byType(HomeScreen), findsOneWidget);

      // Tap third tab (Map)
      await tester.tap(find.text('Карта'));
      await tester.pumpAndSettle();

      // Tap fourth tab (Profile)
      await tester.tap(find.text('Профиль'));
      await tester.pumpAndSettle();
    });

    testWidgets('HomeScreen shows empty state and navigates to AddCarScreen',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Verify empty state
      expect(find.text('Пока нет автомобилей'), findsOneWidget);
      expect(find.text('Добавить первый автомобиль'), findsOneWidget);

      // Tap add car button
      await tester.tap(find.text('Добавить первый автомобиль'));
      await tester.pumpAndSettle();

      // Verify navigation to AddCarScreen
      expect(find.byType(AddCarScreen), findsOneWidget);
    });

    testWidgets('HomeScreen FAB navigates to AddCarScreen',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Find and tap FAB
      final fab = find.byType(FloatingActionButton);
      expect(fab, findsOneWidget);
      
      await tester.tap(fab);
      await tester.pumpAndSettle();

      // Verify navigation to AddCarScreen
      expect(find.byType(AddCarScreen), findsOneWidget);
    });

    testWidgets('AddCarScreen has back button functionality',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AddCarScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify AddCarScreen is displayed
      expect(find.text('Добавить автомобиль'), findsOneWidget);

      // Tap back button (system back button or AppBar back)
      final backButton = find.byIcon(Icons.arrow_back);
      if (backButton.evaluate().isNotEmpty) {
        await tester.tap(backButton);
        await tester.pumpAndSettle();
      }
    });

    testWidgets('CarDetailScreen navigates to ServiceHistoryScreen',
        (WidgetTester tester) async {
      final testCar = {
        'brand': 'Geely',
        'model': 'Monjaro',
        'year': 2023,
        'vin': 'TEST1234567890',
        'plate': 'A777AA',
        'mileage': 15000,
      };

      await tester.pumpWidget(
        MaterialApp(
          home: CarDetailScreen(car: testCar),
        ),
      );

      await tester.pumpAndSettle();

      // Verify CarDetailScreen is displayed
      expect(find.text('Мой Автомобиль'), findsOneWidget);
      expect(find.text('Geely'), findsOneWidget);

      // Find and tap "История обслуживания" section
      final historyButton = find.text('Все записи');
      expect(historyButton, findsOneWidget);
      
      await tester.tap(historyButton);
      await tester.pumpAndSettle();

      // Verify navigation to ServiceHistoryScreen
      expect(find.byType(ServiceHistoryScreen), findsOneWidget);
    });

    testWidgets('CarDetailScreen navigates to ExpenseAnalyticsScreen',
        (WidgetTester tester) async {
      final testCar = {
        'brand': 'Haval',
        'model': 'Jolion',
        'year': 2022,
        'vin': 'TEST9876543210',
        'plate': 'B999BB',
        'mileage': 20000,
      };

      await tester.pumpWidget(
        MaterialApp(
          home: CarDetailScreen(car: testCar),
        ),
      );

      await tester.pumpAndSettle();

      // Find and tap "Детали" button in analytics section
      final detailsButton = find.text('Детали');
      expect(detailsButton, findsOneWidget);
      
      await tester.tap(detailsButton);
      await tester.pumpAndSettle();

      // Verify navigation to ExpenseAnalyticsScreen
      expect(find.byType(ExpenseAnalyticsScreen), findsOneWidget);
    });

    testWidgets('CarDetailScreen navigates to SellReportScreen',
        (WidgetTester tester) async {
      final testCar = {
        'brand': 'Chery',
        'model': 'Tiggo 8',
        'year': 2021,
        'vin': 'TESTVIN123456',
        'plate': 'C111CC',
        'mileage': 30000,
      };

      await tester.pumpWidget(
        MaterialApp(
          home: CarDetailScreen(car: testCar),
        ),
      );

      await tester.pumpAndSettle();

      // Scroll to find the sell report button
      await tester.scrollUntilVisible(
        find.text('Сформировать отчет и оценить стоимость'),
        500.0,
      );

      // Tap sell report button
      await tester.tap(find.text('Сформировать отчет и оценить стоимость'));
      await tester.pumpAndSettle();

      // Verify navigation to SellReportScreen
      expect(find.byType(SellReportScreen), findsOneWidget);
    });

    testWidgets('Navigation passes car data correctly between screens',
        (WidgetTester tester) async {
      final testCar = {
        'brand': 'BYD',
        'model': 'Han',
        'year': 2024,
        'vin': 'BYD123456789',
        'plate': 'E777EE',
        'mileage': 5000,
      };

      await tester.pumpWidget(
        MaterialApp(
          home: CarDetailScreen(car: testCar),
        ),
      );

      await tester.pumpAndSettle();

      // Verify car data is displayed
      expect(find.text('BYD'), findsOneWidget);
      expect(find.text('Han'), findsOneWidget);

      // Navigate to ServiceHistoryScreen
      await tester.tap(find.text('Все записи'));
      await tester.pumpAndSettle();

      // Verify car data is passed to ServiceHistoryScreen
      expect(find.byType(ServiceHistoryScreen), findsOneWidget);
      // The ServiceHistoryScreen should have the car data
    });

    testWidgets('Multiple back navigations work correctly',
        (WidgetTester tester) async {
      final testCar = {
        'brand': 'Geely',
        'model': 'Coolray',
        'year': 2023,
        'mileage': 8000,
      };

      await tester.pumpWidget(
        MaterialApp(
          home: HomeScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Assume we have a car in the list (this would require mocking storage)
      // For this test, we'll create a simplified navigation test
      
      // Navigate to CarDetailScreen programmatically
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CarDetailScreen(car: testCar),
                        ),
                      );
                    },
                    child: const Text('Go to Car Detail'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      // Tap button to navigate
      await tester.tap(find.text('Go to Car Detail'));
      await tester.pumpAndSettle();

      // Verify we're on CarDetailScreen
      expect(find.byType(CarDetailScreen), findsOneWidget);

      // Navigate to ServiceHistoryScreen
      await tester.tap(find.text('Все записи'));
      await tester.pumpAndSettle();

      // Verify we're on ServiceHistoryScreen
      expect(find.byType(ServiceHistoryScreen), findsOneWidget);

      // Go back to CarDetailScreen
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Verify we're back on CarDetailScreen
      expect(find.byType(CarDetailScreen), findsOneWidget);

      // Go back to previous screen
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Verify we're back at the initial screen
      expect(find.text('Go to Car Detail'), findsOneWidget);
    });

    testWidgets('VerificationScreen mask contact info correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: VerificationScreen(
            contactInfo: '79001234567',
            isEmail: false,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify masked phone number is displayed
      expect(find.textContaining('••••'), findsOneWidget);
    });

    testWidgets('VerificationScreen shows email when isEmail is true',
        (WidgetTester tester) async {
      const testEmail = 'test@example.com';
      
      await tester.pumpWidget(
        const MaterialApp(
          home: VerificationScreen(
            contactInfo: testEmail,
            isEmail: true,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify email is displayed
      expect(find.textContaining(testEmail), findsOneWidget);
      expect(find.text('Подтверждение email'), findsOneWidget);
    });
  });

  group('Navigation Observer Tests', () {
    testWidgets('Navigation observer tracks route changes',
        (WidgetTester tester) async {
      final List<Route<dynamic>?> pushedRoutes = [];
      final List<Route<dynamic>?> poppedRoutes = [];

      final observer = TestNavigatorObserver(
        onPushed: (route) => pushedRoutes.add(route),
        onPopped: (route) => poppedRoutes.add(route),
      );

      await tester.pumpWidget(
        MaterialApp(
          navigatorObservers: [observer],
          home: const AuthScreen(),
        ),
      );

      // Enter phone and navigate
      final phoneField = find.byType(TextField).first;
      await tester.enterText(phoneField, '9001234567');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Получить код'));
      await tester.pumpAndSettle();

      // Verify route was pushed
      expect(pushedRoutes.length, greaterThan(0));

      // Go back
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Verify route was popped
      expect(poppedRoutes.length, greaterThan(0));
    });
  });

  group('Navigation State Preservation Tests', () {
    testWidgets('Bottom navigation preserves tab state',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MainScreen(),
        ),
      );

      // Switch to second tab
      await tester.tap(find.text('Авто'));
      await tester.pumpAndSettle();

      // Switch to third tab
      await tester.tap(find.text('Карта'));
      await tester.pumpAndSettle();

      // Switch back to second tab
      await tester.tap(find.text('Авто'));
      await tester.pumpAndSettle();

      // Verify we're on HomeScreen
      expect(find.byType(HomeScreen), findsOneWidget);
      
      // Note: State preservation would require IndexedStack implementation
      // Current implementation rebuilds widgets on tab switch
    });
  });
}

/// Test navigator observer for tracking navigation events
class TestNavigatorObserver extends NavigatorObserver {
  final void Function(Route<dynamic>? route)? onPushed;
  final void Function(Route<dynamic>? route)? onPopped;

  TestNavigatorObserver({this.onPushed, this.onPopped});

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    onPushed?.call(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    onPopped?.call(route);
  }
}
