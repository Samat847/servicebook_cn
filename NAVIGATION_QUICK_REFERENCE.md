# Flutter Navigation Quick Reference Guide

## 🚀 Quick Navigation Patterns

### Basic Push Navigation
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => NextScreen(),
  ),
);
```

### Push with Data
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => DetailScreen(
      data: myData,
    ),
  ),
);
```

### Push and Get Result
```dart
final result = await Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => InputScreen(),
  ),
);

if (result != null) {
  // Use the result
}
```

### Pop with Result
```dart
Navigator.pop(context, myData);
```

### Replace Current Screen
```dart
Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => NewScreen(),
  ),
);
```

### Clear Stack and Navigate
```dart
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(
    builder: (context) => HomeScreen(),
  ),
  (route) => false, // Remove all previous routes
);
```

### Check if Can Pop
```dart
if (Navigator.canPop(context)) {
  Navigator.pop(context);
} else {
  // At root, handle differently
}
```

## 📱 App-Specific Navigation Flows

### Authentication Flow
```
AuthScreen
  ↓ (push)
VerificationScreen
  ↓ (pushReplacement)
ProfileScreen
  ↓ (pushAndRemoveUntil)
MainScreen
```

**Code Example:**
```dart
// Step 1: Auth to Verification
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => VerificationScreen(
      contactInfo: phoneNumber,
      isEmail: false,
    ),
  ),
);

// Step 2: Verification to Profile
Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => const ProfileScreen(),
  ),
);

// Step 3: Profile to Main (clear stack)
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(
    builder: (context) => const MainScreen(),
  ),
  (route) => false,
);
```

### Car Management Flow
```
HomeScreen
  ↓ (push)
AddCarScreen
  ↓ (pop with result)
HomeScreen (updated)
```

**Code Example:**
```dart
// Navigate to add car
final newCar = await Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const AddCarScreen(),
  ),
);

// Handle result
if (newCar != null) {
  setState(() {
    cars.add(newCar);
  });
}

// In AddCarScreen, return data:
Navigator.pop(context, carData);
```

### Car Details Flow
```
HomeScreen
  ↓ (push with car data)
CarDetailScreen
  ├→ ServiceHistoryScreen
  ├→ ExpenseAnalyticsScreen
  └→ SellReportScreen
```

**Code Example:**
```dart
// Navigate to car details
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => CarDetailScreen(car: selectedCar),
  ),
);

// From CarDetailScreen to sub-screens
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ServiceHistoryScreen(car: widget.car),
  ),
);
```

### Logout Flow
```
Any Screen
  ↓ (pushAndRemoveUntil)
AuthScreen
```

**Code Example:**
```dart
Future<void> _logout() async {
  await CarStorage.saveAuthStatus(false);
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => const AuthScreen(),
    ),
    (route) => false,
  );
}
```

## 🎨 Bottom Navigation Pattern

### Implementation
```dart
class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  
  final List<Widget> _screens = [
    DashboardScreen(),
    HomeScreen(),
    PartnersScreen(),
    UserProfileScreen(),
  ];
  
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          // ... more items
        ],
      ),
    );
  }
}
```

### With State Preservation (Recommended)
```dart
body: IndexedStack(
  index: _selectedIndex,
  children: _screens,
),
```

## 🔍 Common Patterns

### Show Dialog and Navigate on Result
```dart
showDialog(
  context: context,
  barrierDismissible: false,
  builder: (context) => AlertDialog(
    title: Text('Confirm'),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.pop(context, true);
        },
        child: Text('Yes'),
      ),
    ],
  ),
).then((confirmed) {
  if (confirmed == true) {
    Navigator.push(context, ...);
  }
});
```

### Show Loading and Navigate
```dart
void _submit() async {
  // Show loading
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Center(
      child: CircularProgressIndicator(),
    ),
  );
  
  // Do async work
  await saveData();
  
  // Close loading
  Navigator.pop(context);
  
  // Navigate to next screen
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => NextScreen()),
  );
}
```

### Navigate with Animation
```dart
Navigator.push(
  context,
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => NextScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;
      
      var tween = Tween(begin: begin, end: end).chain(
        CurveTween(curve: curve),
      );
      
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  ),
);
```

## 🧪 Testing Navigation

### Basic Navigation Test
```dart
testWidgets('navigates to next screen', (tester) async {
  await tester.pumpWidget(
    MaterialApp(home: FirstScreen()),
  );
  
  await tester.tap(find.text('Next'));
  await tester.pumpAndSettle();
  
  expect(find.byType(SecondScreen), findsOneWidget);
});
```

### Test Navigation with Data
```dart
testWidgets('passes data correctly', (tester) async {
  final testData = {'key': 'value'};
  
  await tester.pumpWidget(
    MaterialApp(
      home: DetailScreen(data: testData),
    ),
  );
  
  expect(find.text('value'), findsOneWidget);
});
```

### Test Back Navigation
```dart
testWidgets('back button works', (tester) async {
  await tester.pumpWidget(
    MaterialApp(home: FirstScreen()),
  );
  
  // Navigate forward
  await tester.tap(find.text('Next'));
  await tester.pumpAndSettle();
  
  // Navigate back
  await tester.tap(find.byIcon(Icons.arrow_back));
  await tester.pumpAndSettle();
  
  expect(find.byType(FirstScreen), findsOneWidget);
});
```

## ⚠️ Common Mistakes to Avoid

### ❌ Don't: Use Navigator without context
```dart
// Wrong - context not available
Navigator.push(context, ...); // Error!
```

### ✅ Do: Get context from build method or callback
```dart
@override
Widget build(BuildContext context) {
  return ElevatedButton(
    onPressed: () {
      Navigator.push(context, ...); // Correct
    },
    child: Text('Navigate'),
  );
}
```

### ❌ Don't: Navigate before async completion
```dart
// Wrong - navigating too soon
await saveData();
Navigator.push(context, ...); // May fail if widget unmounted
```

### ✅ Do: Check mounted before navigating
```dart
await saveData();
if (!mounted) return;
Navigator.push(context, ...);
```

### ❌ Don't: Create unnecessary routes
```dart
// Wrong - rebuilding widget tree
setState(() {
  currentScreen = NewScreen();
});
```

### ✅ Do: Use proper navigation
```dart
// Correct - using Navigator
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => NewScreen()),
);
```

### ❌ Don't: Pop without checking
```dart
// Wrong - may error on root screen
Navigator.pop(context);
```

### ✅ Do: Check canPop first
```dart
if (Navigator.canPop(context)) {
  Navigator.pop(context);
}
```

## 📚 Data Passing Patterns

### Constructor Parameters (Recommended)
```dart
class DetailScreen extends StatelessWidget {
  final String id;
  final String title;
  
  const DetailScreen({
    required this.id,
    required this.title,
  });
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Text('ID: $id'),
    );
  }
}

// Usage:
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => DetailScreen(
      id: '123',
      title: 'Details',
    ),
  ),
);
```

### Route Arguments (Alternative)
```dart
// Define route
MaterialApp(
  routes: {
    '/detail': (context) {
      final args = ModalRoute.of(context)!.settings.arguments as Map;
      return DetailScreen(data: args);
    },
  },
);

// Navigate with arguments
Navigator.pushNamed(
  context,
  '/detail',
  arguments: {'id': '123', 'title': 'Details'},
);
```

## 🎯 Best Practices Checklist

- ✅ Use MaterialPageRoute for standard transitions
- ✅ Pass data via constructor parameters
- ✅ Check Navigator.canPop() before popping
- ✅ Use pushAndRemoveUntil for logout/authentication flows
- ✅ Handle async operations before navigation
- ✅ Check if widget is mounted after async operations
- ✅ Use proper error handling
- ✅ Test navigation flows
- ✅ Document complex navigation patterns
- ✅ Consider user experience in navigation design

## 🔗 Related Files

- `NAVIGATION_AUDIT.md` - Complete navigation audit
- `test/navigation_test.dart` - Navigation widget tests
- `test/navigation_flows_test.dart` - Integration tests
- `test/README_TESTS.md` - Test documentation

## 📖 Further Reading

- [Flutter Navigation Basics](https://docs.flutter.dev/cookbook/navigation/navigation-basics)
- [Navigation with Arguments](https://docs.flutter.dev/cookbook/navigation/navigate-with-arguments)
- [Named Routes](https://docs.flutter.dev/cookbook/navigation/named-routes)
- [Testing Navigation](https://docs.flutter.dev/cookbook/testing/navigation)

---

**Last Updated:** February 2026  
**App Version:** 1.0.0+1  
**Flutter SDK:** ^3.10.3
