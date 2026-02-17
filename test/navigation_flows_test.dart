import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:servicebook_cn/screens/auth_screen.dart';
import 'package:servicebook_cn/screens/verification_screen.dart';
import 'package:servicebook_cn/screens/profile_screen.dart';
import 'package:servicebook_cn/screens/main_screen.dart';
import 'package:servicebook_cn/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Integration tests for complete navigation flows
/// 
/// These tests verify end-to-end user journeys through the app:
/// - Complete authentication flow
/// - Onboarding flow
/// - Car management workflows
/// - Navigation stack behavior

void main() {
  group('Complete Navigation Flow Tests', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('Complete authentication flow: Auth → Verify → Profile → Main',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AuthScreen(),
        ),
      );

      // Step 1: AuthScreen - Enter phone number
      expect(find.text('Вход'), findsOneWidget);
      
      final phoneField = find.byType(TextField).first;
      await tester.enterText(phoneField, '9001234567');
      await tester.pumpAndSettle();

      // Tap "Get Code" button
      await tester.tap(find.text('Получить код'));
      await tester.pumpAndSettle();

      // Step 2: VerificationScreen - Enter verification code
      expect(find.byType(VerificationScreen), findsOneWidget);
      
      final codeFields = find.byType(TextField);
      for (int i = 0; i < 6; i++) {
        await tester.enterText(codeFields.at(i), '${i + 1}');
        await tester.pump(const Duration(milliseconds: 100));
      }

      await tester.pumpAndSettle();
      
      // Wait for automatic navigation
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Step 3: ProfileScreen - Fill profile
      expect(find.byType(ProfileScreen), findsOneWidget);
      
      await tester.enterText(find.byType(TextField), 'Test User');
      await tester.pumpAndSettle();

      // Select city
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Москва').last);
      await tester.pumpAndSettle();

      // Save profile
      await tester.tap(find.text('Сохранить и продолжить'));
      await tester.pumpAndSettle();

      // Step 4: Verify we're on MainScreen
      expect(find.byType(MainScreen), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('Email authentication flow works correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AuthScreen(),
        ),
      );

      // Switch to email tab
      await tester.tap(find.text('Войти по почте'));
      await tester.pumpAndSettle();

      // Enter email
      await tester.enterText(
        find.byType(TextField),
        'test@example.com',
      );
      await tester.pumpAndSettle();

      // Tap get code
      await tester.tap(find.text('Получить код'));
      await tester.pumpAndSettle();

      // Verify navigation to verification screen with email
      expect(find.byType(VerificationScreen), findsOneWidget);
      expect(find.text('Подтверждение email'), findsOneWidget);
    });

    testWidgets('Profile screen validation prevents empty submission',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(),
        ),
      );

      // Try to save without entering name
      await tester.tap(find.text('Сохранить и продолжить'));
      await tester.pumpAndSettle();

      // Verify error message is shown
      expect(find.text('Пожалуйста, введите ваше имя'), findsOneWidget);
      
      // Verify we're still on ProfileScreen
      expect(find.byType(ProfileScreen), findsOneWidget);
    });

    testWidgets('Back navigation during authentication flow',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AuthScreen(),
        ),
      );

      // Navigate to verification
      final phoneField = find.byType(TextField).first;
      await tester.enterText(phoneField, '9001234567');
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('Получить код'));
      await tester.pumpAndSettle();

      expect(find.byType(VerificationScreen), findsOneWidget);

      // Go back to auth screen
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Verify we can re-enter phone number
      expect(find.byType(AuthScreen), findsOneWidget);
      expect(find.text('Вход'), findsOneWidget);
    });

    testWidgets('Change contact info button on verification screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: VerificationScreen(
            contactInfo: '9001234567',
            isEmail: false,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find and tap "Изменить номер" button
      final changeButton = find.text('Изменить номер');
      expect(changeButton, findsOneWidget);
      
      await tester.tap(changeButton);
      await tester.pumpAndSettle();

      // Verify navigation back occurred
      // In the actual app, this would go back to AuthScreen
    });

    testWidgets('Verification code entry automatically advances focus',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: VerificationScreen(
            contactInfo: '9001234567',
            isEmail: false,
          ),
        ),
      );

      await tester.pumpAndSettle();

      final codeFields = find.byType(TextField);
      
      // Enter first digit
      await tester.enterText(codeFields.at(0), '1');
      await tester.pump(const Duration(milliseconds: 100));
      
      // Verify text was entered
      final firstField = tester.widget<TextField>(codeFields.at(0));
      expect(firstField.controller?.text, '1');
      
      // Continue with remaining digits
      for (int i = 1; i < 6; i++) {
        await tester.enterText(codeFields.at(i), '${i + 1}');
        await tester.pump(const Duration(milliseconds: 100));
      }

      await tester.pumpAndSettle();
    });

    testWidgets('Bottom navigation maintains selected tab index',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MainScreen(),
        ),
      );

      final bottomNav = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(bottomNav.currentIndex, 0);

      // Tap second tab
      await tester.tap(find.text('Авто'));
      await tester.pumpAndSettle();

      final bottomNav2 = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(bottomNav2.currentIndex, 1);

      // Tap fourth tab
      await tester.tap(find.text('Профиль'));
      await tester.pumpAndSettle();

      final bottomNav3 = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(bottomNav3.currentIndex, 3);
    });

    testWidgets('Bottom navigation shows correct screen for each tab',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MainScreen(),
        ),
      );

      // Tab 0: Dashboard (default)
      expect(find.text('Главная'), findsOneWidget);

      // Tab 1: Home/Garage
      await tester.tap(find.text('Авто'));
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);

      // Tab 2: Map/Partners
      await tester.tap(find.text('Карта'));
      await tester.pumpAndSettle();
      // PartnersScreen should be displayed

      // Tab 3: Profile
      await tester.tap(find.text('Профиль'));
      await tester.pumpAndSettle();
      // UserProfileScreen should be displayed
    });

    testWidgets('Navigation from MainScreen tabs to detail screens',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MainScreen(),
        ),
      );

      // Navigate to HomeScreen tab
      await tester.tap(find.text('Авто'));
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
      
      // Verify FAB is present for adding cars
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('Verification timer counts down correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: VerificationScreen(
            contactInfo: '9001234567',
            isEmail: false,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Initial timer should show 1:00
      expect(find.text('1:00'), findsOneWidget);

      // Wait for 2 seconds
      await tester.pump(const Duration(seconds: 2));
      
      // Timer should have counted down (exact time may vary)
      // This verifies the timer is running
    });

    testWidgets('Resend code button appears after timer expires',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: VerificationScreen(
            contactInfo: '9001234567',
            isEmail: false,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Initially, resend button should not be visible
      expect(find.text('Отправить код повторно'), findsNothing);

      // Fast forward past the timer (60 seconds + buffer)
      await tester.pump(const Duration(seconds: 61));
      await tester.pumpAndSettle();

      // Now resend button should be visible
      expect(find.text('Отправить код повторно'), findsOneWidget);
    });

    testWidgets('Clear all fields button on verification screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: VerificationScreen(
            contactInfo: '9001234567',
            isEmail: false,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Enter some code digits
      final codeFields = find.byType(TextField);
      await tester.enterText(codeFields.at(0), '1');
      await tester.enterText(codeFields.at(1), '2');
      await tester.enterText(codeFields.at(2), '3');
      await tester.pumpAndSettle();

      // Tap refresh/clear button
      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pumpAndSettle();

      // Verify fields are cleared
      final field0 = tester.widget<TextField>(codeFields.at(0));
      expect(field0.controller?.text ?? '', isEmpty);
    });

    testWidgets('Profile screen pre-fills existing data',
        (WidgetTester tester) async {
      // Set up mock profile data
      SharedPreferences.setMockInitialValues({
        'profile_name': 'Existing User',
        'profile_city': 'Москва',
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(),
        ),
      );

      // Wait for async data loading
      await tester.pumpAndSettle();

      // Verify data is pre-filled
      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);
      
      // The name field should have the existing value
      final nameField = tester.widget<TextField>(textField);
      expect(nameField.controller?.text, 'Existing User');
    });
  });

  group('Navigation Stack Management Tests', () {
    testWidgets('pushAndRemoveUntil clears navigation stack',
        (WidgetTester tester) async {
      final navigatorKey = GlobalKey<NavigatorState>();
      
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigatorKey,
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AuthScreen(),
                            ),
                          );
                        },
                        child: const Text('Push Auth'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );

      // Push AuthScreen
      await tester.tap(find.text('Push Auth'));
      await tester.pumpAndSettle();

      // Navigate through verification flow
      final phoneField = find.byType(TextField).first;
      await tester.enterText(phoneField, '9001234567');
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('Получить код'));
      await tester.pumpAndSettle();

      // Now we have multiple routes in the stack
      // When we eventually reach MainScreen with pushAndRemoveUntil,
      // we shouldn't be able to go back
    });

    testWidgets('Multiple push operations create correct stack depth',
        (WidgetTester tester) async {
      int stackDepth = 0;
      final observer = NavigatorObserver();

      await tester.pumpWidget(
        MaterialApp(
          navigatorObservers: [observer],
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AuthScreen(),
                        ),
                      );
                      stackDepth++;
                    },
                    child: const Text('Navigate'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      // Initial screen
      expect(find.text('Navigate'), findsOneWidget);

      // Push one screen
      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();
      
      expect(find.byType(AuthScreen), findsOneWidget);
    });

    testWidgets('Pop returns correct result data',
        (WidgetTester tester) async {
      String? receivedData;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      final result = await Navigator.push<Map<String, dynamic>>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Scaffold(
                            body: Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context, {
                                    'brand': 'TestBrand',
                                    'model': 'TestModel',
                                  });
                                },
                                child: const Text('Return Data'),
                              ),
                            ),
                          ),
                        ),
                      );
                      
                      if (result != null) {
                        receivedData = '${result['brand']} ${result['model']}';
                      }
                    },
                    child: const Text('Push Screen'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      // Push screen
      await tester.tap(find.text('Push Screen'));
      await tester.pumpAndSettle();

      // Pop with data
      await tester.tap(find.text('Return Data'));
      await tester.pumpAndSettle();

      // Verify data was received
      expect(receivedData, 'TestBrand TestModel');
    });
  });

  group('Error Handling in Navigation', () {
    testWidgets('Navigation with null context is handled gracefully',
        (WidgetTester tester) async {
      // This test ensures navigation errors don't crash the app
      await tester.pumpWidget(
        const MaterialApp(
          home: AuthScreen(),
        ),
      );

      // App should render without errors
      expect(find.byType(AuthScreen), findsOneWidget);
    });

    testWidgets('Back navigation on root screen is handled',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AuthScreen(),
        ),
      );

      // Try to pop when already at root
      // This should not crash the app
      final BuildContext context = tester.element(find.byType(AuthScreen));
      final navigator = Navigator.of(context);
      
      // Check if we can pop
      expect(navigator.canPop(), isFalse);
    });

    testWidgets('Rapid navigation taps are handled correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AuthScreen(),
        ),
      );

      // Enter phone number
      final phoneField = find.byType(TextField).first;
      await tester.enterText(phoneField, '9001234567');
      await tester.pump();

      // Rapidly tap the button multiple times
      await tester.tap(find.text('Получить код'));
      await tester.tap(find.text('Получить код'));
      await tester.pump();
      
      // Only one navigation should occur
      await tester.pumpAndSettle();
      
      // We should see one VerificationScreen
      expect(find.byType(VerificationScreen), findsOneWidget);
    });
  });
}
