import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:servicebook_cn/screens/main_screen.dart';
import 'package:servicebook_cn/screens/dashboard_screen.dart';
import 'package:servicebook_cn/screens/home_screen.dart';
import 'package:servicebook_cn/screens/user_profile_screen.dart';
import 'package:servicebook_cn/screens/car_detail_screen.dart';
import 'package:servicebook_cn/screens/driver_license_screen.dart';
import 'package:servicebook_cn/screens/add_service_screen.dart';
import 'package:servicebook_cn/screens/add_car_screen.dart';
import 'package:servicebook_cn/screens/sell_report_screen.dart';
import 'package:servicebook_cn/screens/partners_screen.dart';
import 'package:servicebook_cn/screens/expense_analytics_screen.dart';
import 'package:servicebook_cn/screens/service_history_screen.dart';
import 'package:servicebook_cn/screens/insurance_screen.dart';
import 'package:servicebook_cn/screens/sts_detail_screen.dart';
import 'package:servicebook_cn/screens/all_documents_screen.dart';
import 'package:servicebook_cn/screens/profile_edit_screen.dart';
import 'package:servicebook_cn/screens/security_settings_screen.dart';
import 'package:servicebook_cn/screens/language_settings_screen.dart';
import 'package:servicebook_cn/screens/data_management_screen.dart';
import 'package:servicebook_cn/screens/backup_settings_screen.dart';
import 'package:servicebook_cn/screens/help_and_faq_screen.dart';
import 'package:servicebook_cn/screens/support_screen.dart';
import 'package:servicebook_cn/screens/privacy_policy_screen.dart';
import 'package:servicebook_cn/screens/terms_of_service_screen.dart';
import 'package:servicebook_cn/screens/about_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Comprehensive navigation and widget tests for ServiceBook CN app
/// 
/// These tests cover:
/// - Main screen navigation with bottom tabs
/// - Dashboard quick action buttons
/// - User profile screen navigation
/// - Driver license screen functionality
/// - Car detail screen navigation
/// - Back navigation behavior
/// - Form validation

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  group('MainScreen Navigation Tests', () {
    testWidgets('MainScreen renders all tabs', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MainScreen()));
      await tester.pumpAndSettle();
      
      expect(find.text('Главная'), findsOneWidget);
      expect(find.text('Авто'), findsOneWidget);
      expect(find.text('Карта'), findsOneWidget);
      expect(find.text('Профиль'), findsOneWidget);
    });

    testWidgets('MainScreen switches between tabs correctly', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MainScreen()));
      await tester.pumpAndSettle();

      // Initially on Dashboard tab
      expect(find.byType(DashboardScreen), findsOneWidget);

      // Tap Auto tab
      await tester.tap(find.text('Авто'));
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);

      // Tap Profile tab
      await tester.tap(find.text('Профиль'));
      await tester.pumpAndSettle();
      expect(find.byType(UserProfileScreen), findsOneWidget);
    });
  });

  group('DashboardScreen Quick Actions Tests', () {
    testWidgets('All quick action buttons are present with keys', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DashboardScreen(),
        ),
      );
      await tester.pumpAndSettle();
      
      expect(find.byKey(const Key('add_service_button')), findsOneWidget);
      expect(find.byKey(const Key('sell_report_button')), findsOneWidget);
      expect(find.byKey(const Key('partners_button')), findsOneWidget);
      expect(find.byKey(const Key('analytics_button')), findsOneWidget);
    });

    testWidgets('Tap Analytics button navigates to ExpenseAnalyticsScreen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DashboardScreen(),
        ),
      );
      await tester.pumpAndSettle();
      
      final analyticsButton = find.byKey(const Key('analytics_button'));
      expect(analyticsButton, findsOneWidget);
      
      await tester.tap(analyticsButton);
      await tester.pumpAndSettle();
      
      expect(find.byType(ExpenseAnalyticsScreen), findsOneWidget);
    });

    testWidgets('Tap Add Service button navigates to AddServiceScreen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DashboardScreen(),
        ),
      );
      await tester.pumpAndSettle();
      
      final addServiceButton = find.byKey(const Key('add_service_button'));
      expect(addServiceButton, findsOneWidget);
      
      await tester.tap(addServiceButton);
      await tester.pumpAndSettle();
      
      expect(find.byType(AddServiceScreen), findsOneWidget);
    });

    testWidgets('Tap Partners button navigates to PartnersScreen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DashboardScreen(),
        ),
      );
      await tester.pumpAndSettle();
      
      final partnersButton = find.byKey(const Key('partners_button'));
      expect(partnersButton, findsOneWidget);
      
      await tester.tap(partnersButton);
      await tester.pumpAndSettle();
      
      expect(find.byType(PartnersScreen), findsOneWidget);
    });
  });

  group('UserProfileScreen Navigation Tests', () {
    testWidgets('UserProfileScreen renders with all document tiles', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: UserProfileScreen(),
        ),
      );
      await tester.pumpAndSettle();
      
      expect(find.byKey(const Key('driver_license_tile')), findsOneWidget);
      expect(find.byKey(const Key('insurance_tile')), findsOneWidget);
      expect(find.byKey(const Key('sts_tile')), findsOneWidget);
    });

    testWidgets('Tap Driver License button navigates to DriverLicenseScreen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: UserProfileScreen(),
        ),
      );
      await tester.pumpAndSettle();
      
      final driverLicenseTile = find.byKey(const Key('driver_license_tile'));
      expect(driverLicenseTile, findsOneWidget);
      
      await tester.tap(driverLicenseTile);
      await tester.pumpAndSettle();
      
      // Verify navigation to DriverLicenseScreen - THIS FIXES RED SCREEN ISSUE!
      expect(find.byType(DriverLicenseScreen), findsOneWidget);
    });

    testWidgets('Tap Insurance button navigates to InsuranceScreen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: UserProfileScreen(),
        ),
      );
      await tester.pumpAndSettle();
      
      final insuranceTile = find.byKey(const Key('insurance_tile'));
      expect(insuranceTile, findsOneWidget);
      
      await tester.tap(insuranceTile);
      await tester.pumpAndSettle();
      
      expect(find.byType(InsuranceScreen), findsOneWidget);
    });

    testWidgets('Tap STS button navigates to STSDetailScreen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: UserProfileScreen(),
        ),
      );
      await tester.pumpAndSettle();
      
      final stsTile = find.byKey(const Key('sts_tile'));
      expect(stsTile, findsOneWidget);
      
      await tester.tap(stsTile);
      await tester.pumpAndSettle();
      
      expect(find.byType(STSDetailScreen), findsOneWidget);
    });

    testWidgets('Tap View All Documents button navigates to AllDocumentsScreen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: UserProfileScreen(),
        ),
      );
      await tester.pumpAndSettle();
      
      final viewAllButton = find.byKey(const Key('view_all_documents_button'));
      expect(viewAllButton, findsOneWidget);
      
      await tester.tap(viewAllButton);
      await tester.pumpAndSettle();
      
      expect(find.byType(AllDocumentsScreen), findsOneWidget);
    });

    testWidgets('Tap Add Car button navigates to AddCarScreen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: UserProfileScreen(),
        ),
      );
      await tester.pumpAndSettle();
      
      final addCarButton = find.byKey(const Key('add_car_button'));
      expect(addCarButton, findsOneWidget);
      
      await tester.tap(addCarButton);
      await tester.pumpAndSettle();
      
      // Should navigate to AddCarScreen
      expect(find.byType(AddCarScreen), findsOneWidget);
    });

    testWidgets('All settings tiles are present with keys', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: UserProfileScreen(),
        ),
      );
      await tester.pumpAndSettle();
      
      expect(find.byKey(const Key('personal_data_tile')), findsOneWidget);
      expect(find.byKey(const Key('security_tile')), findsOneWidget);
      expect(find.byKey(const Key('language_tile')), findsOneWidget);
      expect(find.byKey(const Key('data_management_tile')), findsOneWidget);
      expect(find.byKey(const Key('backup_tile')), findsOneWidget);
      expect(find.byKey(const Key('help_tile')), findsOneWidget);
      expect(find.byKey(const Key('contact_support_tile')), findsOneWidget);
      expect(find.byKey(const Key('rate_app_tile')), findsOneWidget);
      expect(find.byKey(const Key('privacy_policy_tile')), findsOneWidget);
      expect(find.byKey(const Key('terms_tile')), findsOneWidget);
      expect(find.byKey(const Key('about_tile')), findsOneWidget);
      expect(find.byKey(const Key('logout_tile')), findsOneWidget);
    });

    testWidgets('Tap Personal Data navigates to ProfileEditScreen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: UserProfileScreen(),
        ),
      );
      await tester.pumpAndSettle();
      
      await tester.tap(find.byKey(const Key('personal_data_tile')));
      await tester.pumpAndSettle();
      
      expect(find.byType(ProfileEditScreen), findsOneWidget);
    });

    testWidgets('Tap Security navigates to SecuritySettingsScreen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: UserProfileScreen(),
        ),
      );
      await tester.pumpAndSettle();
      
      await tester.tap(find.byKey(const Key('security_tile')));
      await tester.pumpAndSettle();
      
      expect(find.byType(SecuritySettingsScreen), findsOneWidget);
    });

    testWidgets('Tap Language navigates to LanguageSettingsScreen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: UserProfileScreen(),
        ),
      );
      await tester.pumpAndSettle();
      
      await tester.tap(find.byKey(const Key('language_tile')));
      await tester.pumpAndSettle();
      
      expect(find.byType(LanguageSettingsScreen), findsOneWidget);
    });

    testWidgets('Tap Data Management navigates to DataManagementScreen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: UserProfileScreen(),
        ),
      );
      await tester.pumpAndSettle();
      
      await tester.tap(find.byKey(const Key('data_management_tile')));
      await tester.pumpAndSettle();
      
      expect(find.byType(DataManagementScreen), findsOneWidget);
    });

    testWidgets('Tap Backup navigates to BackupSettingsScreen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: UserProfileScreen(),
        ),
      );
      await tester.pumpAndSettle();
      
      await tester.tap(find.byKey(const Key('backup_tile')));
      await tester.pumpAndSettle();
      
      expect(find.byType(BackupSettingsScreen), findsOneWidget);
    });

    testWidgets('Tap Help and FAQ navigates to HelpAndFaqScreen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: UserProfileScreen(),
        ),
      );
      await tester.pumpAndSettle();
      
      await tester.tap(find.byKey(const Key('help_tile')));
      await tester.pumpAndSettle();
      
      expect(find.byType(HelpAndFaqScreen), findsOneWidget);
    });

    testWidgets('Tap Contact Support navigates to SupportScreen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: UserProfileScreen(),
        ),
      );
      await tester.pumpAndSettle();
      
      await tester.tap(find.byKey(const Key('contact_support_tile')));
      await tester.pumpAndSettle();
      
      expect(find.byType(SupportScreen), findsOneWidget);
    });

    testWidgets('Tap Privacy Policy navigates to PrivacyPolicyScreen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: UserProfileScreen(),
        ),
      );
      await tester.pumpAndSettle();
      
      await tester.tap(find.byKey(const Key('privacy_policy_tile')));
      await tester.pumpAndSettle();
      
      expect(find.byType(PrivacyPolicyScreen), findsOneWidget);
    });

    testWidgets('Tap Terms of Service navigates to TermsOfServiceScreen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: UserProfileScreen(),
        ),
      );
      await tester.pumpAndSettle();
      
      await tester.tap(find.byKey(const Key('terms_tile')));
      await tester.pumpAndSettle();
      
      expect(find.byType(TermsOfServiceScreen), findsOneWidget);
    });

    testWidgets('Tap About navigates to AboutScreen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: UserProfileScreen(),
        ),
      );
      await tester.pumpAndSettle();
      
      await tester.tap(find.byKey(const Key('about_tile')));
      await tester.pumpAndSettle();
      
      expect(find.byType(AboutScreen), findsOneWidget);
    });
  });

  group('DriverLicenseScreen Widget Tests', () {
    testWidgets('DriverLicenseScreen renders all form fields', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DriverLicenseScreen(),
        ),
      );
      await tester.pumpAndSettle();
      
      expect(find.text('Водительское удостоверение'), findsOneWidget);
      expect(find.text('Фото удостоверения'), findsOneWidget);
      expect(find.text('Номер удостоверения'), findsOneWidget);
      expect(find.text('Дата выдачи'), findsOneWidget);
      expect(find.text('Срок действия'), findsOneWidget);
      expect(find.text('Категории'), findsOneWidget);
      expect(find.byKey(const Key('save_driver_license_button')), findsOneWidget);
      expect(find.byKey(const Key('cancel_driver_license_button')), findsOneWidget);
    });

    testWidgets('Save and Cancel buttons are present', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DriverLicenseScreen(),
        ),
      );
      await tester.pumpAndSettle();
      
      expect(find.byKey(const Key('save_driver_license_button')), findsOneWidget);
      expect(find.byKey(const Key('cancel_driver_license_button')), findsOneWidget);
    });

    testWidgets('Cancel button pops navigation', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DriverLicenseScreen()),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );
      
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      
      expect(find.byType(DriverLicenseScreen), findsOneWidget);
      
      await tester.tap(find.byKey(const Key('cancel_driver_license_button')));
      await tester.pumpAndSettle();
      
      expect(find.byType(DriverLicenseScreen), findsNothing);
    });

    testWidgets('Category chips are tappable', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DriverLicenseScreen(),
        ),
      );
      await tester.pumpAndSettle();
      
      // Find category chips
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
      expect(find.text('C'), findsOneWidget);
      
      // Tap on category C
      await tester.tap(find.text('C'));
      await tester.pumpAndSettle();
      
      // Chip should now be selected (visual change would happen)
    });
  });

  group('CarDetailScreen Navigation Tests', () {
    testWidgets('Service history button is clickable', (tester) async {
      final car = {
        'brand': 'Geely',
        'model': 'Monjaro',
        'year': '2022',
        'plate': 'A 777 AA',
        'mileage': 15420,
        'vin': 'LVSHCAMB1CE012345',
      };
      
      await tester.pumpWidget(
        MaterialApp(
          home: CarDetailScreen(car: car),
        ),
      );
      await tester.pumpAndSettle();
      
      final serviceHistoryButton = find.byKey(const Key('service_history_button'));
      expect(serviceHistoryButton, findsOneWidget);
      
      await tester.tap(serviceHistoryButton);
      await tester.pumpAndSettle();
      
      expect(find.byType(ServiceHistoryScreen), findsOneWidget);
    });

    testWidgets('All records button navigates to ServiceHistoryScreen', (tester) async {
      final car = {
        'brand': 'Geely',
        'model': 'Monjaro',
        'year': '2022',
        'plate': 'A 777 AA',
        'mileage': 15420,
        'vin': 'LVSHCAMB1CE012345',
      };
      
      await tester.pumpWidget(
        MaterialApp(
          home: CarDetailScreen(car: car),
        ),
      );
      await tester.pumpAndSettle();
      
      final allRecordsButton = find.byKey(const Key('all_records_button'));
      expect(allRecordsButton, findsOneWidget);
      
      await tester.tap(allRecordsButton);
      await tester.pumpAndSettle();
      
      expect(find.byType(ServiceHistoryScreen), findsOneWidget);
    });

    testWidgets('Analytics details button navigates to ExpenseAnalyticsScreen', (tester) async {
      final car = {
        'brand': 'Geely',
        'model': 'Monjaro',
        'year': '2022',
        'plate': 'A 777 AA',
        'mileage': 15420,
        'vin': 'LVSHCAMB1CE012345',
      };
      
      await tester.pumpWidget(
        MaterialApp(
          home: CarDetailScreen(car: car),
        ),
      );
      await tester.pumpAndSettle();
      
      final analyticsButton = find.byKey(const Key('analytics_details_button'));
      expect(analyticsButton, findsOneWidget);
      
      await tester.tap(analyticsButton);
      await tester.pumpAndSettle();
      
      expect(find.byType(ExpenseAnalyticsScreen), findsOneWidget);
    });

    testWidgets('Sell report button navigates to SellReportScreen', (tester) async {
      final car = {
        'brand': 'Geely',
        'model': 'Monjaro',
        'year': '2022',
        'plate': 'A 777 AA',
        'mileage': 15420,
        'vin': 'LVSHCAMB1CE012345',
      };
      
      await tester.pumpWidget(
        MaterialApp(
          home: CarDetailScreen(car: car),
        ),
      );
      await tester.pumpAndSettle();
      
      final sellReportButton = find.byKey(const Key('sell_report_button'));
      expect(sellReportButton, findsOneWidget);
      
      await tester.tap(sellReportButton);
      await tester.pumpAndSettle();
      
      expect(find.byType(SellReportScreen), findsOneWidget);
    });

    testWidgets('CarDetailScreen displays car data correctly', (tester) async {
      final car = {
        'brand': 'Geely',
        'model': 'Monjaro',
        'year': '2022',
        'plate': 'A 777 AA',
        'mileage': 15420,
        'vin': 'LVSHCAMB1CE012345',
      };
      
      await tester.pumpWidget(
        MaterialApp(
          home: CarDetailScreen(car: car),
        ),
      );
      await tester.pumpAndSettle();
      
      expect(find.text('Geely'), findsOneWidget);
      expect(find.text('Monjaro'), findsOneWidget);
      expect(find.text('A 777 AA'), findsOneWidget);
      expect(find.text('Мой Автомобиль'), findsOneWidget);
    });
  });

  group('Back Navigation Tests', () {
    testWidgets('Pressing back returns to previous screen from DriverLicenseScreen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DriverLicenseScreen()),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );
      
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      
      expect(find.byType(DriverLicenseScreen), findsOneWidget);
      
      // Tap system back button
      await tester.pageBack();
      await tester.pumpAndSettle();
      
      expect(find.byType(DriverLicenseScreen), findsNothing);
      expect(find.text('Open'), findsOneWidget);
    });

    testWidgets('Cancel button works in DriverLicenseScreen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DriverLicenseScreen()),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );
      
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      
      expect(find.byType(DriverLicenseScreen), findsOneWidget);
      
      await tester.tap(find.byKey(const Key('cancel_driver_license_button')));
      await tester.pumpAndSettle();
      
      expect(find.byType(DriverLicenseScreen), findsNothing);
    });
  });

  group('Navigation Integration Tests', () {
    testWidgets('Complete flow: Dashboard -> Analytics -> Back', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DashboardScreen(),
        ),
      );
      await tester.pumpAndSettle();
      
      // Start on Dashboard
      expect(find.byType(DashboardScreen), findsOneWidget);
      
      // Navigate to Analytics
      await tester.tap(find.byKey(const Key('analytics_button')));
      await tester.pumpAndSettle();
      
      expect(find.byType(ExpenseAnalyticsScreen), findsOneWidget);
      
      // Go back
      await tester.pageBack();
      await tester.pumpAndSettle();
      
      expect(find.byType(DashboardScreen), findsOneWidget);
    });

    testWidgets('Complete flow: Profile -> Driver License -> Back', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: UserProfileScreen(),
        ),
      );
      await tester.pumpAndSettle();
      
      // Start on Profile
      expect(find.byType(UserProfileScreen), findsOneWidget);
      
      // Navigate to Driver License
      await tester.tap(find.byKey(const Key('driver_license_tile')));
      await tester.pumpAndSettle();
      
      expect(find.byType(DriverLicenseScreen), findsOneWidget);
      
      // Go back
      await tester.pageBack();
      await tester.pumpAndSettle();
      
      expect(find.byType(UserProfileScreen), findsOneWidget);
    });

    testWidgets('Complete flow: Car Detail -> Service History -> Back', (tester) async {
      final car = {
        'brand': 'Geely',
        'model': 'Monjaro',
        'year': '2022',
        'plate': 'A 777 AA',
        'mileage': 15420,
        'vin': 'LVSHCAMB1CE012345',
      };
      
      await tester.pumpWidget(
        MaterialApp(
          home: CarDetailScreen(car: car),
        ),
      );
      await tester.pumpAndSettle();
      
      // Navigate to Service History
      await tester.tap(find.byKey(const Key('service_history_button')));
      await tester.pumpAndSettle();
      
      expect(find.byType(ServiceHistoryScreen), findsOneWidget);
      
      // Go back
      await tester.pageBack();
      await tester.pumpAndSettle();
      
      expect(find.byType(CarDetailScreen), findsOneWidget);
    });
  });

  group('Form Validation Tests', () {
    testWidgets('DriverLicenseScreen validates empty license number', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DriverLicenseScreen(),
        ),
      );
      await tester.pumpAndSettle();
      
      // Try to save without entering license number
      await tester.tap(find.byKey(const Key('save_driver_license_button')));
      await tester.pumpAndSettle();
      
      // Should show validation error
      expect(find.text('Введите номер удостоверения'), findsOneWidget);
    });
  });

  group('Screen Content Tests', () {
    testWidgets('DriverLicenseScreen has correct app bar title', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DriverLicenseScreen(),
        ),
      );
      await tester.pumpAndSettle();
      
      expect(find.text('Водительское удостоверение'), findsOneWidget);
    });

    testWidgets('UserProfileScreen has correct sections', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: UserProfileScreen(),
        ),
      );
      await tester.pumpAndSettle();
      
      expect(find.text('Мой гараж'), findsOneWidget);
      expect(find.text('Документы'), findsOneWidget);
      expect(find.text('Настройки'), findsOneWidget);
    });

    testWidgets('DashboardScreen has correct sections', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DashboardScreen(),
        ),
      );
      await tester.pumpAndSettle();
      
      expect(find.text('Мой Гараж'), findsOneWidget);
      expect(find.text('История работ'), findsOneWidget);
      expect(find.text('Партнерские СТО'), findsOneWidget);
    });
  });
}
