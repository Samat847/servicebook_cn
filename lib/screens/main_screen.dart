import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import '../l10n/app_localizations.dart';
import 'dashboard_screen.dart';
import 'home_screen.dart';
import 'partners_screen.dart'; // ← заменили map_screen.dart
import 'user_profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const HomeScreen(),
    const PartnersScreen(), // ← теперь экран партнёров
    const UserProfileScreen(),
  ];

  List<String> _getTitles(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return [
      l10n?.dashboardTitle ?? 'Главная',
      l10n?.garage ?? 'Мой гараж',
      l10n?.mapTitle ?? 'Карта',
      l10n?.profile ?? 'Профиль',
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final titles = _getTitles(context);

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: const TextStyle(fontSize: 12),
            unselectedLabelStyle: const TextStyle(fontSize: 12),
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home_outlined),
                activeIcon: const Icon(Icons.home),
                label: l10n?.dashboardTitle ?? 'Главная',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.directions_car_outlined),
                activeIcon: const Icon(Icons.directions_car),
                label: l10n?.garage ?? 'Авто',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.map_outlined),
                activeIcon: const Icon(Icons.map),
                label: l10n?.mapTitle ?? 'Карта',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person_outlined),
                activeIcon: const Icon(Icons.person),
                label: l10n?.profile ?? 'Профиль',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
