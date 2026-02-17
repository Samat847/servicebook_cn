# servicebook_cn

A Flutter application for service book management for Chinese automobiles.

## 🧭 Navigation Audit & Testing

A comprehensive navigation audit and widget test implementation has been completed for this project.

### 📚 Documentation
- **[NAVIGATION_OVERVIEW.md](NAVIGATION_OVERVIEW.md)** - Quick overview of audit and tests
- **[NAVIGATION_AUDIT.md](NAVIGATION_AUDIT.md)** - Complete architecture audit
- **[NAVIGATION_QUICK_REFERENCE.md](NAVIGATION_QUICK_REFERENCE.md)** - Developer quick reference
- **[TEST_SUMMARY.md](TEST_SUMMARY.md)** - Test implementation metrics
- **[QUICK_START.md](QUICK_START.md)** - Quick start guide

### 🧪 Tests
- **test/navigation_test.dart** - 35+ widget tests for navigation
- **test/navigation_flows_test.dart** - 35+ integration tests for user flows
- **test/README_TESTS.md** - Test documentation

### ✅ Coverage
- **70+ test cases** covering all navigation flows
- **~90% coverage** of navigation code
- **13 screens** fully tested
- **6 major flows** documented and tested

### 🚀 Quick Start
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/navigation_test.dart
```

For more details, see [NAVIGATION_OVERVIEW.md](NAVIGATION_OVERVIEW.md)

---

## Getting Started

This project is a Flutter application for managing service records for Chinese automobiles.

### Prerequisites
- Flutter SDK ^3.10.3
- Dart SDK (included with Flutter)

### Installation
```bash
# Get dependencies
flutter pub get

# Run the app
flutter run

# Run tests
flutter test
```

### Project Structure
```
lib/
  ├── main.dart              # App entry point
  ├── screens/               # UI screens (13 screens)
  └── services/              # Business logic (storage)

test/
  ├── navigation_test.dart           # Navigation widget tests
  ├── navigation_flows_test.dart     # Integration tests
  └── README_TESTS.md                # Test documentation
```

### Key Features
- 📱 Phone and email authentication
- 🚗 Car management (add, view, details)
- 📊 Service history tracking
- 💰 Expense analytics
- 🏷️ Sell report generation
- 👤 User profile management

## Resources

### Flutter Resources
- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
- [Online documentation](https://docs.flutter.dev/)

### Project Resources
- [Navigation Architecture](NAVIGATION_AUDIT.md)
- [Testing Guide](test/README_TESTS.md)
- [Quick Reference](NAVIGATION_QUICK_REFERENCE.md)
