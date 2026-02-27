import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'screens/splash_screen.dart';
import 'services/notification_service.dart';
import 'providers/locale_provider.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();
  await initializeDateFormatting('ru', null);

  await NotificationService.init();

  final localeProvider = LocaleProvider();
  await localeProvider.loadLocale();

  runApp(MyApp(
    localeProvider: localeProvider,
  ));
}

class MyApp extends StatefulWidget {
  final LocaleProvider localeProvider;

  const MyApp({
    super.key,
    required this.localeProvider,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.localeProvider,
      child: Consumer<LocaleProvider>(
        builder: (_, provider, __) => MaterialApp(
          locale: provider.locale,
          debugShowCheckedModeBanner: false,
          title: 'AvtoMAN',
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
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
