import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'screens/auth_screen.dart';
import 'screens/main_screen.dart';
import 'services/car_storage.dart';
import 'services/notification_service.dart';
import 'providers/locale_provider.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();
  await initializeDateFormatting('ru', null);
  
  await NotificationService.init();

  final isAuthenticated = await CarStorage.isAuthenticated();
  final profile = await CarStorage.loadUserProfile();
  final hasProfile = profile.isComplete;

  runApp(MyApp(
    isAuthenticated: isAuthenticated,
    hasProfile: hasProfile,
  ));
}

class MyApp extends StatefulWidget {
  final bool isAuthenticated;
  final bool hasProfile;

  const MyApp({
    super.key,
    required this.isAuthenticated,
    required this.hasProfile,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _localeProvider = LocaleProvider();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeLocale();
  }

  Future<void> _initializeLocale() async {
    await _localeProvider.loadLocale();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
    
    return ChangeNotifierProvider.value(
      value: _localeProvider,
      child: Consumer<LocaleProvider>(
        builder: (_, provider, __) => MaterialApp(
          locale: provider.locale,
          debugShowCheckedModeBanner: false,
          title: 'ServiceBook',
          supportedLocales: const [Locale('ru'), Locale('en'), Locale('kk')],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
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
            cardTheme: const CardThemeData(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
            ),
          ),
          home: widget.isAuthenticated
              ? (widget.hasProfile ? const MainScreen() : const AuthScreen())
              : const AuthScreen(),
        ),
      ),
    );
  }
}
