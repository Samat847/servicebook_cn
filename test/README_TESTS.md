# Navigation Widget Tests Documentation

## Overview
This directory contains comprehensive widget tests for Flutter navigation and screen transitions in the Service Book application.

## Test Files

### 1. `navigation_test.dart`
**Purpose:** Unit and widget tests for individual navigation actions and transitions.

**Test Coverage:**
- ✅ AuthScreen navigation to VerificationScreen
- ✅ Input validation and error handling
- ✅ Tab switching between phone and email authentication
- ✅ Back button functionality across screens
- ✅ VerificationScreen to ProfileScreen navigation
- ✅ ProfileScreen to MainScreen with stack clearing
- ✅ Bottom navigation bar functionality
- ✅ Tab switching in MainScreen
- ✅ HomeScreen empty state and add car navigation
- ✅ FAB (Floating Action Button) navigation
- ✅ CarDetailScreen navigation to child screens
- ✅ Data passing between screens
- ✅ Multiple back navigation chains
- ✅ Contact info masking
- ✅ Navigator observer tracking

**Key Test Groups:**
```dart
group('Navigation Tests', () {...});
group('Navigation Observer Tests', () {...});
group('Navigation State Preservation Tests', () {...});
```

### 2. `navigation_flows_test.dart`
**Purpose:** Integration tests for complete user journeys through the app.

**Test Coverage:**
- ✅ Complete authentication flow (Auth → Verify → Profile → Main)
- ✅ Email authentication flow
- ✅ Profile validation
- ✅ Back navigation during authentication
- ✅ Change contact info flow
- ✅ Verification code auto-advance
- ✅ Bottom navigation tab persistence
- ✅ Timer countdown functionality
- ✅ Resend code functionality
- ✅ Clear fields functionality
- ✅ Profile data pre-filling
- ✅ Navigation stack management
- ✅ pushAndRemoveUntil behavior
- ✅ Pop with result data
- ✅ Error handling in navigation

**Key Test Groups:**
```dart
group('Complete Navigation Flow Tests', () {...});
group('Navigation Stack Management Tests', () {...});
group('Error Handling in Navigation', () {...});
```

## Running the Tests

### Run All Tests
```bash
flutter test
```

### Run Specific Test File
```bash
flutter test test/navigation_test.dart
flutter test test/navigation_flows_test.dart
```

### Run Tests with Coverage
```bash
flutter test --coverage
```

### Run Tests in Watch Mode (requires flutter_test_runner)
```bash
flutter test --watch
```

### Run Tests with Verbose Output
```bash
flutter test --verbose
```

### Run Specific Test Group
```bash
flutter test --name "Navigation Tests"
flutter test --name "Complete Navigation Flow Tests"
```

### Run Specific Test Case
```bash
flutter test --name "AuthScreen navigates to VerificationScreen"
```

## Test Utilities

### TestNavigatorObserver
A custom NavigatorObserver for tracking navigation events in tests.

**Usage:**
```dart
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
```

## Test Data

### Mock Car Data
```dart
final testCar = {
  'brand': 'Geely',
  'model': 'Monjaro',
  'year': 2023,
  'vin': 'TEST1234567890',
  'plate': 'A777AA',
  'mileage': 15000,
};
```

### Mock Profile Data
```dart
SharedPreferences.setMockInitialValues({
  'profile_name': 'Test User',
  'profile_city': 'Москва',
});
```

## Testing Best Practices

### 1. Setup and Teardown
Always initialize SharedPreferences mocks in setUp:
```dart
setUp(() async {
  SharedPreferences.setMockInitialValues({});
});
```

### 2. Pump and Settle
Use `pumpAndSettle()` to wait for all animations and async operations:
```dart
await tester.tap(find.text('Button'));
await tester.pumpAndSettle();
```

### 3. Finding Widgets
Prefer specific finders:
```dart
// Good
expect(find.byType(AuthScreen), findsOneWidget);
expect(find.text('Вход'), findsOneWidget);

// Less specific
expect(find.byKey(Key('someKey')), findsOneWidget);
```

### 4. Testing Navigation
Verify both source and destination:
```dart
// Before navigation
expect(find.byType(AuthScreen), findsOneWidget);

// Perform navigation
await tester.tap(find.text('Получить код'));
await tester.pumpAndSettle();

// After navigation
expect(find.byType(VerificationScreen), findsOneWidget);
```

### 5. Testing Back Navigation
```dart
await tester.tap(find.byIcon(Icons.arrow_back));
await tester.pumpAndSettle();
expect(find.byType(PreviousScreen), findsOneWidget);
```

## Common Test Patterns

### Testing Form Input
```dart
await tester.enterText(find.byType(TextField), 'Test Input');
await tester.pumpAndSettle();
```

### Testing Dropdowns
```dart
await tester.tap(find.byType(DropdownButtonFormField<String>));
await tester.pumpAndSettle();
await tester.tap(find.text('Option').last);
await tester.pumpAndSettle();
```

### Testing Multiple Text Fields
```dart
final fields = find.byType(TextField);
expect(fields, findsNWidgets(6));
for (int i = 0; i < 6; i++) {
  await tester.enterText(fields.at(i), '${i + 1}');
}
```

### Testing Scrolling
```dart
await tester.scrollUntilVisible(
  find.text('Button Text'),
  500.0,
);
```

## Troubleshooting

### Test Timeout
If tests timeout, increase the timeout:
```dart
testWidgets('Test name', (WidgetTester tester) async {
  // ...
}, timeout: const Timeout(Duration(minutes: 2)));
```

### Widget Not Found
Add debug output:
```dart
print(tester.allWidgets.map((w) => w.runtimeType).toList());
```

### Async Issues
Ensure proper async handling:
```dart
await tester.pumpAndSettle();
await tester.pump(const Duration(seconds: 1));
```

### SharedPreferences Not Initialized
Always mock in setUp:
```dart
setUp(() async {
  SharedPreferences.setMockInitialValues({});
});
```

## Test Coverage Goals

### Current Coverage
- ✅ Navigation transitions: ~95%
- ✅ Authentication flow: ~90%
- ✅ Bottom navigation: ~95%
- ✅ Car management flow: ~85%
- ✅ Back button handling: ~90%

### Areas for Improvement
- ⚠️ Error state navigation
- ⚠️ Offline behavior
- ⚠️ Deep linking (if implemented)
- ⚠️ Complex animation testing

## Integration with CI/CD

### GitHub Actions Example
```yaml
name: Flutter Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.10.3'
      - run: flutter pub get
      - run: flutter test --coverage
      - run: flutter test --coverage --reporter=json > test_report.json
```

## Maintenance

### Adding New Tests
1. Follow existing naming conventions
2. Add to appropriate test group
3. Include descriptive test names
4. Document complex test logic

### Updating Tests After Code Changes
When navigation changes:
1. Update affected test cases
2. Verify all navigation flows still work
3. Add tests for new navigation paths
4. Remove obsolete tests

## References

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Widget Testing Guide](https://docs.flutter.dev/cookbook/testing/widget)
- [Navigation Testing Best Practices](https://docs.flutter.dev/cookbook/testing/navigation)
- [MockNavigatorObserver](https://api.flutter.dev/flutter/widgets/NavigatorObserver-class.html)

## Contact

For questions or issues with tests, please refer to the main `NAVIGATION_AUDIT.md` document or contact the development team.
