import 'package:flutter/material.dart';
import 'screens/auth_screen.dart';
import 'screens/main_screen.dart';
import 'services/car_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final isAuthenticated = await CarStorage.isAuthenticated();
  final profile = await CarStorage.loadProfile();
  final hasProfile = profile['name']!.isNotEmpty && profile['city']!.isNotEmpty;
  
  runApp(MyApp(
    isAuthenticated: isAuthenticated,
    hasProfile: hasProfile,
  ));
}

class MyApp extends StatelessWidget {
  final bool isAuthenticated;
  final bool hasProfile;
  
  const MyApp({
    super.key,
    required this.isAuthenticated,
    required this.hasProfile,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Service Book для китайских авто',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: isAuthenticated 
          ? (hasProfile ? const MainScreen() : const AuthScreen())
          : const AuthScreen(),
    );
  }
}