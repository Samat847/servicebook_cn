import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  
  AppLocalizations(this.locale);
  
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }
  
  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();
  
  static final Map<String, Map<String, String>> _localizedValues = {
    'ru': {
      'appTitle': 'ServiceBook',
      'garage': 'Гараж',
      'profile': 'Профиль',
      'settings': 'Настройки',
      'addCar': 'Добавить автомобиль',
      'save': 'Сохранить',
      'cancel': 'Отмена',
      'delete': 'Удалить',
      'edit': 'Редактировать',
      'confirm': 'Подтвердить',
      'yes': 'Да',
      'no': 'Нет',
      'ok': 'ОК',
      'error': 'Ошибка',
      'success': 'Успешно',
      'loading': 'Загрузка...',
      'noData': 'Нет данных',
      'language': 'Язык',
      'dataManagement': 'Управление данными',
      'backup': 'Резервная копия',
      'exportData': 'Экспорт данных',
      'importData': 'Импорт данных',
      'clearData': 'Очистить данные',
      'logout': 'Выйти',
      'personalData': 'Личные данные',
      'security': 'Безопасность',
      'notifications': 'Уведомления',
      'darkMode': 'Темная тема',
      'about': 'О приложении',
      'helpAndFaq': 'Помощь и FAQ',
      'support': 'Связаться с поддержкой',
      'privacyPolicy': 'Политика конфиденциальности',
      'termsOfService': 'Условия использования',
      'serviceReminder': 'Напоминание о ТО',
      'serviceReminderText': 'Скоро плановое ТО',
    },
    'en': {
      'appTitle': 'ServiceBook',
      'garage': 'Garage',
      'profile': 'Profile',
      'settings': 'Settings',
      'addCar': 'Add Car',
      'save': 'Save',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'edit': 'Edit',
      'confirm': 'Confirm',
      'yes': 'Yes',
      'no': 'No',
      'ok': 'OK',
      'error': 'Error',
      'success': 'Success',
      'loading': 'Loading...',
      'noData': 'No data',
      'language': 'Language',
      'dataManagement': 'Data Management',
      'backup': 'Backup',
      'exportData': 'Export Data',
      'importData': 'Import Data',
      'clearData': 'Clear Data',
      'logout': 'Logout',
      'personalData': 'Personal Data',
      'security': 'Security',
      'notifications': 'Notifications',
      'darkMode': 'Dark Mode',
      'about': 'About',
      'helpAndFaq': 'Help & FAQ',
      'support': 'Contact Support',
      'privacyPolicy': 'Privacy Policy',
      'termsOfService': 'Terms of Service',
      'serviceReminder': 'Service Reminder',
      'serviceReminderText': 'Upcoming scheduled maintenance',
    },
  };
  
  String get appTitle => _localizedValues[locale.languageCode]!['appTitle']!;
  String get garage => _localizedValues[locale.languageCode]!['garage']!;
  String get profile => _localizedValues[locale.languageCode]!['profile']!;
  String get settings => _localizedValues[locale.languageCode]!['settings']!;
  String get addCar => _localizedValues[locale.languageCode]!['addCar']!;
  String get save => _localizedValues[locale.languageCode]!['save']!;
  String get cancel => _localizedValues[locale.languageCode]!['cancel']!;
  String get delete => _localizedValues[locale.languageCode]!['delete']!;
  String get edit => _localizedValues[locale.languageCode]!['edit']!;
  String get confirm => _localizedValues[locale.languageCode]!['confirm']!;
  String get yes => _localizedValues[locale.languageCode]!['yes']!;
  String get no => _localizedValues[locale.languageCode]!['no']!;
  String get ok => _localizedValues[locale.languageCode]!['ok']!;
  String get error => _localizedValues[locale.languageCode]!['error']!;
  String get success => _localizedValues[locale.languageCode]!['success']!;
  String get loading => _localizedValues[locale.languageCode]!['loading']!;
  String get noData => _localizedValues[locale.languageCode]!['noData']!;
  String get language => _localizedValues[locale.languageCode]!['language']!;
  String get dataManagement => _localizedValues[locale.languageCode]!['dataManagement']!;
  String get backup => _localizedValues[locale.languageCode]!['backup']!;
  String get exportData => _localizedValues[locale.languageCode]!['exportData']!;
  String get importData => _localizedValues[locale.languageCode]!['importData']!;
  String get clearData => _localizedValues[locale.languageCode]!['clearData']!;
  String get logout => _localizedValues[locale.languageCode]!['logout']!;
  String get personalData => _localizedValues[locale.languageCode]!['personalData']!;
  String get security => _localizedValues[locale.languageCode]!['security']!;
  String get notifications => _localizedValues[locale.languageCode]!['notifications']!;
  String get darkMode => _localizedValues[locale.languageCode]!['darkMode']!;
  String get about => _localizedValues[locale.languageCode]!['about']!;
  String get helpAndFaq => _localizedValues[locale.languageCode]!['helpAndFaq']!;
  String get support => _localizedValues[locale.languageCode]!['support']!;
  String get privacyPolicy => _localizedValues[locale.languageCode]!['privacyPolicy']!;
  String get termsOfService => _localizedValues[locale.languageCode]!['termsOfService']!;
  String get serviceReminder => _localizedValues[locale.languageCode]!['serviceReminder']!;
  String get serviceReminderText => _localizedValues[locale.languageCode]!['serviceReminderText']!;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();
  
  @override
  bool isSupported(Locale locale) {
    return ['ru', 'en'].contains(locale.languageCode);
  }
  
  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }
  
  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}