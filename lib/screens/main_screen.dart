import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'dashboard_screen.dart';
import 'expert_screen.dart';
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
      const ExpertScreen(),
      const PartnersScreen(),
      _UserProfileRefreshProxy(key: _profileKey),
    ];
  }

  void _onItemTapped(int index) {
    if (index == 0 && _selectedIndex != 0) {
      _dashboardKey.currentState?.refresh();
    }
    if (index == 4 && _selectedIndex != 4) {
      _profileKey.currentState?.refresh();
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildExpertIcon(bool isSelected) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFFF8C00).withOpacity(0.15)
                : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Icon(
            isSelected ? Icons.smart_toy : Icons.smart_toy_outlined,
            color: isSelected ? const Color(0xFFFF8C00) : Colors.grey,
            size: 26,
          ),
        ),
        Positioned(
          top: -4,
          right: -2,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFFF8C00),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF8C00).withOpacity(0.4),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Text(
              'AI',
              style: TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
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
            selectedItemColor: _selectedIndex == 2
                ? const Color(0xFFFF8C00)
                : Colors.blue,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: const TextStyle(fontSize: 12),
            unselectedLabelStyle: const TextStyle(fontSize: 12),
            selectedFontSize: 12,
            unselectedFontSize: 12,
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
                icon: _buildExpertIcon(false),
                activeIcon: _buildExpertIcon(true),
                label: l10n?.expert ?? 'Эксперт',
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
