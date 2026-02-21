import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'dashboard_screen.dart';
import 'home_screen.dart';
import 'partners_screen.dart';
import 'user_profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final GlobalKey<_DashboardRefreshProxyState> _dashboardKey =
      GlobalKey<_DashboardRefreshProxyState>();
  final GlobalKey<_UserProfileRefreshProxyState> _profileKey =
      GlobalKey<_UserProfileRefreshProxyState>();

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      _DashboardRefreshProxy(key: _dashboardKey),
      const HomeScreen(),
      const PartnersScreen(),
      _UserProfileRefreshProxy(key: _profileKey),
    ];
  }

  void _onItemTapped(int index) {
    if (index == 0 && _selectedIndex != 0) {
      _dashboardKey.currentState?.refresh();
    }
    if (index == 3 && _selectedIndex != 3) {
      _profileKey.currentState?.refresh();
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
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

class _DashboardRefreshProxy extends StatefulWidget {
  const _DashboardRefreshProxy({super.key});

  @override
  State<_DashboardRefreshProxy> createState() =>
      _DashboardRefreshProxyState();
}

class _DashboardRefreshProxyState extends State<_DashboardRefreshProxy> {
  final GlobalKey<DashboardScreenState> _dashboardScreenKey =
      GlobalKey<DashboardScreenState>();

  void refresh() {
    _dashboardScreenKey.currentState?.refreshFromParent();
  }

  @override
  Widget build(BuildContext context) {
    return DashboardScreen(key: _dashboardScreenKey);
  }
}

class _UserProfileRefreshProxy extends StatefulWidget {
  const _UserProfileRefreshProxy({super.key});

  @override
  State<_UserProfileRefreshProxy> createState() =>
      _UserProfileRefreshProxyState();
}

class _UserProfileRefreshProxyState extends State<_UserProfileRefreshProxy> {
  final GlobalKey<UserProfileScreenState> _profileScreenKey =
      GlobalKey<UserProfileScreenState>();

  void refresh() {
    _profileScreenKey.currentState?.refreshFromParent();
  }

  @override
  Widget build(BuildContext context) {
    return UserProfileScreen(key: _profileScreenKey);
  }
}
