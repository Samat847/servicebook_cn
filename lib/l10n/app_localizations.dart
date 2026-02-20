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
      'phoneNumber': 'Номер телефона',
      'phoneHint': 'Введите номер телефона',
      'getCode': 'Получить код',
      'phoneMustHave10Digits': 'Номер должен содержать 10 цифр после +7',
      'enterPhoneNumber': 'Введите номер телефона',
      'login': 'Войти',
      'loginWithPhone': 'Вход по номеру телефона',
      'loginWithPassword': 'Вход по логину и паролю',
      'loginTitle': 'Вход',
      'loginSubtitle': 'Войдите в аккаунт для продолжения',
      'phoneOrEmail': 'Введите номер телефона или email, чтобы войти или создать аккаунт.',
      'byPhone': 'По номеру телефона',
      'byPassword': 'По логину и паролю',
      'register': 'Регистрация',
      'registerTitle': 'Создание аккаунта',
      'registerSubtitle': 'Создайте аккаунт для сохранения данных',
      'loginField': 'Логин',
      'loginHint': 'Введите логин или email',
      'password': 'Пароль',
      'passwordHint': 'Введите пароль',
      'confirmPassword': 'Подтвердите пароль',
      'confirmPasswordHint': 'Введите пароль ещё раз',
      'passwordsDoNotMatch': 'Пароли не совпадают',
      'passwordTooShort': 'Пароль должен содержать минимум 6 символов',
      'invalidLogin': 'Введите логин',
      'invalidPassword': 'Введите пароль',
      'invalidConfirmPassword': 'Подтвердите пароль',
      'accountCreated': 'Аккаунт создан успешно',
      'loginFailed': 'Неверный логин или пароль',
      'changePassword': 'Сменить пароль',
      'currentPassword': 'Текущий пароль',
      'newPassword': 'Новый пароль',
      'oldPasswordIncorrect': 'Неверный текущий пароль',
      'passwordChanged': 'Пароль успешно изменён',
      'passwordChangeFailed': 'Не удалось изменить пароль',
      'personalDataSubtitle': 'Имя, город, телефон',
      'securitySubtitle': 'Пароль, двухфакторная аутентификация',
      'languageSubtitle': 'Выберите язык интерфейса',
      'selectLanguage': 'Выберите язык интерфейса',
      'languageChanged': 'Язык изменён на',
      'changePasswordSuccess': 'Пароль изменён',
      'clearDataConfirm': 'Вы уверены, что хотите удалить все данные? Это действие необратимо.',
      'clearDataSuccess': 'Все данные очищены',
      'dataManagementSubtitle': 'Экспорт, импорт, очистка',
      'backupSubtitle': 'История резервных копий',
      'backupComingSoon': 'Функция резервного копирования появится позже',
      'helpAndFaqSubtitle': 'Часто задаваемые вопросы',
      'supportSubtitle': 'Написать нам',
      'rateAppSubtitle': 'Оставить отзыв в магазине',
      'logoutConfirm': 'Выйти из аккаунта?',
      'logoutConfirmText': 'Все данные будут сохранены на устройстве.',
      'logoutSuccess': 'Вы вышли из аккаунта',
      'profile': 'Профиль',
      'name': 'Имя',
      'city': 'Город',
      'phone': 'Телефон',
      'email': 'Email',
      'nameHint': 'Введите имя',
      'cityHint': 'Введите город',
      'profileSaved': 'Профиль сохранён',
      'logoutButton': 'Выйти из аккаунта',
      'enterCode': 'Введите код',
      'codeSentTo': 'Код отправлен на',
      'resendCode': 'Отправить код повторно',
      'resendIn': 'Повторная отправка через',
      'confirmPhone': 'Подтвердите номер',
      'confirmPhoneText': 'Введите код из SMS на',
      'emailConfirmed': 'Email подтверждён!',
      'phoneConfirmed': 'Номер подтверждён!',
      'enterAllDigits': 'Введите все 6 цифр',
      'changePhone': 'Изменить номер',
      'changeEmail': 'Изменить email',
      'codeResent': 'Код отправлен повторно',
      'smsResent': 'SMS отправлено повторно',
      'selectLanguageTitle': 'Язык',
      'version': 'Версия',
      'appDescription': 'Приложение для учёта обслуживания автомобилей',
      'appAuthor': '© 2024 ServiceBook',
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
      'phoneNumber': 'Phone number',
      'phoneHint': 'Enter phone number',
      'getCode': 'Get Code',
      'phoneMustHave10Digits': 'Number must contain 10 digits after +7',
      'enterPhoneNumber': 'Enter phone number',
      'login': 'Login',
      'loginWithPhone': 'Login by phone number',
      'loginWithPassword': 'Login with username and password',
      'loginTitle': 'Login',
      'loginSubtitle': 'Log in to continue',
      'phoneOrEmail': 'Enter phone number or email to log in or create an account.',
      'byPhone': 'By phone number',
      'byPassword': 'By username and password',
      'register': 'Register',
      'registerTitle': 'Create Account',
      'registerSubtitle': 'Create an account to save data',
      'loginField': 'Username',
      'loginHint': 'Enter username or email',
      'password': 'Password',
      'passwordHint': 'Enter password',
      'confirmPassword': 'Confirm password',
      'confirmPasswordHint': 'Enter password again',
      'passwordsDoNotMatch': 'Passwords do not match',
      'passwordTooShort': 'Password must be at least 6 characters',
      'invalidLogin': 'Enter username',
      'invalidPassword': 'Enter password',
      'invalidConfirmPassword': 'Confirm password',
      'accountCreated': 'Account created successfully',
      'loginFailed': 'Invalid username or password',
      'changePassword': 'Change Password',
      'currentPassword': 'Current Password',
      'newPassword': 'New Password',
      'oldPasswordIncorrect': 'Current password is incorrect',
      'passwordChanged': 'Password changed successfully',
      'passwordChangeFailed': 'Failed to change password',
      'personalDataSubtitle': 'Name, city, phone',
      'securitySubtitle': 'Password, two-factor auth',
      'languageSubtitle': 'Choose interface language',
      'selectLanguage': 'Choose interface language',
      'languageChanged': 'Language changed to',
      'changePasswordSuccess': 'Password changed',
      'clearDataConfirm': 'Are you sure you want to delete all data? This action cannot be undone.',
      'clearDataSuccess': 'All data cleared',
      'dataManagementSubtitle': 'Export, import, clear',
      'backupSubtitle': 'Backup history',
      'backupComingSoon': 'Backup feature coming soon',
      'helpAndFaqSubtitle': 'Frequently asked questions',
      'supportSubtitle': 'Contact us',
      'rateAppSubtitle': 'Leave a review in the store',
      'logoutConfirm': 'Log out of account?',
      'logoutConfirmText': 'All data will be saved on device.',
      'logoutSuccess': 'You have logged out',
      'profile': 'Profile',
      'name': 'Name',
      'city': 'City',
      'phone': 'Phone',
      'email': 'Email',
      'nameHint': 'Enter name',
      'cityHint': 'Enter city',
      'profileSaved': 'Profile saved',
      'logoutButton': 'Log out',
      'enterCode': 'Enter code',
      'codeSentTo': 'Code sent to',
      'resendCode': 'Resend code',
      'resendIn': 'Resend in',
      'confirmPhone': 'Confirm phone number',
      'confirmPhoneText': 'Enter code from SMS at',
      'emailConfirmed': 'Email confirmed!',
      'phoneConfirmed': 'Phone number confirmed!',
      'enterAllDigits': 'Enter all 6 digits',
      'changePhone': 'Change phone number',
      'changeEmail': 'Change email',
      'codeResent': 'Code resent',
      'smsResent': 'SMS resent',
      'selectLanguageTitle': 'Language',
      'version': 'Version',
      'appDescription': 'Car service tracking application',
      'appAuthor': '© 2024 ServiceBook',
    },
    'kk': {
      'appTitle': 'ServiceBook',
      'garage': 'Гараж',
      'profile': 'Профиль',
      'settings': 'Баптаулар',
      'addCar': 'Автокосы қосу',
      'save': 'Сақтау',
      'cancel': 'Болдырмау',
      'delete': 'Жою',
      'edit': 'Редакциялау',
      'confirm': 'Растау',
      'yes': 'Ия',
      'no': 'Жоқ',
      'ok': 'ОК',
      'error': 'Қате',
      'success': 'Сəтті',
      'loading': 'Жүктеу...',
      'noData': 'Деректер жоқ',
      'language': 'Тіл',
      'dataManagement': 'Деректерді басқару',
      'backup': 'Қорғаныш көшірме',
      'exportData': 'Деректерді шығару',
      'importData': 'Деректерді импорттау',
      'clearData': 'Деректерді тазалау',
      'logout': 'Шығу',
      'personalData': 'Жеке деректер',
      'security': 'Қауіпсіздік',
      'notifications': 'Хабарландырулар',
      'darkMode': 'Қараңғы режим',
      'about': 'Қолданба туралы',
      'helpAndFaq': 'Көмек мен FAQ',
      'support': 'Қолдау көрсету',
      'privacyPolicy': 'Құпиялылық саясаты',
      'termsOfService': 'Қолдану шарттары',
      'serviceReminder': 'Қызмет көрсету ескертуі',
      'serviceReminderText': 'Жоспарланған қызмет көрсету жақындап келеді',
      'phoneNumber': 'Телефон нөмірі',
      'phoneHint': 'Телефон нөмірін енгізіңіз',
      'getCode': 'Кодты алу',
      'phoneMustHave10Digits': 'Нөмір +7-ден кейін 10 цифр болуы керек',
      'enterPhoneNumber': 'Телефон нөмірін енгізіңіз',
      'login': 'Кіру',
      'loginWithPhone': 'Телефон нөмірі бойынша кіру',
      'loginWithPassword': 'Логин жəне құпия сөзбен кіру',
      'loginTitle': 'Кіру',
      'loginSubtitle': 'Жалғастыру үшін кіріңіз',
      'phoneOrEmail': 'Кіру немесе аккаунт жасау үшін телефон нөмірін енгізіңіз.',
      'byPhone': 'Телефон бойынша',
      'byPassword': 'Логин жəне құпия сөз бойынша',
      'register': 'Тіркелу',
      'registerTitle': 'Аккаунт жасау',
      'registerSubtitle': 'Деректерді сақтау үшін аккаунт жасаңыз',
      'loginField': 'Логин',
      'loginHint': 'Логин немесе email енгізіңіз',
      'password': 'Құпия сөз',
      'passwordHint': 'Құпия сөзд енгізіңіз',
      'confirmPassword': 'Құпия сөзд растау',
      'confirmPasswordHint': 'Құпия сөзд қайтадан енгізіңіз',
      'passwordsDoNotMatch': 'Құпия сөздер сəйкес келмейді',
      'passwordTooShort': 'Құпия сөз кемінде 6 таңба болуы керек',
      'invalidLogin': 'Логинді енгізіңіз',
      'invalidPassword': 'Құпия сөзд енгізіңіз',
      'invalidConfirmPassword': 'Құпия сөзд растаңыз',
      'accountCreated': 'Аккаунт сəтті жасалды',
      'loginFailed': 'Логин немесе құпия сөз қате',
      'changePassword': 'Құпия сөзд өзгерту',
      'currentPassword': 'Ағымдағы құпия сөз',
      'newPassword': 'Жаңа құпия сөз',
      'oldPasswordIncorrect': 'Ағымдағы құпия сөз қате',
      'passwordChanged': 'Құпия сөз сəтті өзгертілді',
      'passwordChangeFailed': 'Құпия сөзд өзгерту мүмкін болмады',
      'personalDataSubtitle': 'Аты, қала, телефон',
      'securitySubtitle': 'Құпия сөз, екі факторлы аутентификация',
      'languageSubtitle': 'Интерфейс тілдерін таңдаңыз',
      'selectLanguage': 'Интерфейс тілдерін таңдаңыз',
      'languageChanged': 'Тіл өзгертілді',
      'changePasswordSuccess': 'Құпия сөз өзгертілді',
      'clearDataConfirm': 'Барлық деректерді жойғыңыз келетініне сенімдісіз бе? Бұл əрекетті қайтару мүмкін емес.',
      'clearDataSuccess': 'Барлық деректер тазаланды',
      'dataManagementSubtitle': 'Экспорт, импорт, тазалау',
      'backupSubtitle': 'Қорғаныш көшірмелер тарихы',
      'backupComingSoon': 'Қорғаныш көшірме мүмкіндігі кейінірек қосылады',
      'helpAndFaqSubtitle': 'Жиі қойылатын сұрақтар',
      'supportSubtitle': 'Бізге жазыңыз',
      'rateAppSubtitle': 'Дүкенде пікір қалдырыңыз',
      'logoutConfirm': 'Аккаунттан шығу?',
      'logoutConfirmText': 'Барлық деректер құрылғыда сақталады.',
      'logoutSuccess': 'Сіз аккаунттан шықтыңыз',
      'profile': 'Профиль',
      'name': 'Аты',
      'city': 'Қала',
      'phone': 'Телефон',
      'email': 'Email',
      'nameHint': 'Атын енгізіңіз',
      'cityHint': 'Қаланы енгізіңіз',
      'profileSaved': 'Профиль сақталды',
      'logoutButton': 'Аккаунттан шығу',
      'enterCode': 'Кодты енгізіңіз',
      'codeSentTo': 'Код жіберілді',
      'resendCode': 'Кодты қайта жіберу',
      'resendIn': 'Қайта жіберу',
      'confirmPhone': 'Нөмірд растау',
      'confirmPhoneText': 'SMS-тен кодты енгізіңіз',
      'emailConfirmed': 'Email расталды!',
      'phoneConfirmed': 'Нөмір расталды!',
      'enterAllDigits': 'Барлық 6 цифрды енгізіңіз',
      'changePhone': 'Нөмірд өзгерту',
      'changeEmail': 'Email-ді өзгерту',
      'codeResent': 'Код қайта жіберілді',
      'smsResent': 'SMS қайта жіберілді',
      'selectLanguageTitle': 'Тіл',
      'version': 'Версия',
      'appDescription': 'Автокөлік қызметін есепке алу қолданбасы',
      'appAuthor': '© 2024 ServiceBook',
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
  
  // New localization getters
  String get phoneNumber => _localizedValues[locale.languageCode]?['phoneNumber'] ?? _localizedValues['ru']!['phoneNumber']!;
  String get phoneHint => _localizedValues[locale.languageCode]?['phoneHint'] ?? _localizedValues['ru']!['phoneHint']!;
  String get getCode => _localizedValues[locale.languageCode]?['getCode'] ?? _localizedValues['ru']!['getCode']!;
  String get phoneMustHave10Digits => _localizedValues[locale.languageCode]?['phoneMustHave10Digits'] ?? _localizedValues['ru']!['phoneMustHave10Digits']!;
  String get enterPhoneNumber => _localizedValues[locale.languageCode]?['enterPhoneNumber'] ?? _localizedValues['ru']!['enterPhoneNumber']!;
  String get login => _localizedValues[locale.languageCode]?['login'] ?? _localizedValues['ru']!['login']!;
  String get loginWithPhone => _localizedValues[locale.languageCode]?['loginWithPhone'] ?? _localizedValues['ru']!['loginWithPhone']!;
  String get loginWithPassword => _localizedValues[locale.languageCode]?['loginWithPassword'] ?? _localizedValues['ru']!['loginWithPassword']!;
  String get loginTitle => _localizedValues[locale.languageCode]?['loginTitle'] ?? _localizedValues['ru']!['loginTitle']!;
  String get loginSubtitle => _localizedValues[locale.languageCode]?['loginSubtitle'] ?? _localizedValues['ru']!['loginSubtitle']!;
  String get phoneOrEmail => _localizedValues[locale.languageCode]?['phoneOrEmail'] ?? _localizedValues['ru']!['phoneOrEmail']!;
  String get byPhone => _localizedValues[locale.languageCode]?['byPhone'] ?? _localizedValues['ru']!['byPhone']!;
  String get byPassword => _localizedValues[locale.languageCode]?['byPassword'] ?? _localizedValues['ru']!['byPassword']!;
  String get register => _localizedValues[locale.languageCode]?['register'] ?? _localizedValues['ru']!['register']!;
  String get registerTitle => _localizedValues[locale.languageCode]?['registerTitle'] ?? _localizedValues['ru']!['registerTitle']!;
  String get registerSubtitle => _localizedValues[locale.languageCode]?['registerSubtitle'] ?? _localizedValues['ru']!['registerSubtitle']!;
  String get loginField => _localizedValues[locale.languageCode]?['loginField'] ?? _localizedValues['ru']!['loginField']!;
  String get loginHint => _localizedValues[locale.languageCode]?['loginHint'] ?? _localizedValues['ru']!['loginHint']!;
  String get password => _localizedValues[locale.languageCode]?['password'] ?? _localizedValues['ru']!['password']!;
  String get passwordHint => _localizedValues[locale.languageCode]?['passwordHint'] ?? _localizedValues['ru']!['passwordHint']!;
  String get confirmPassword => _localizedValues[locale.languageCode]?['confirmPassword'] ?? _localizedValues['ru']!['confirmPassword']!;
  String get confirmPasswordHint => _localizedValues[locale.languageCode]?['confirmPasswordHint'] ?? _localizedValues['ru']!['confirmPasswordHint']!;
  String get passwordsDoNotMatch => _localizedValues[locale.languageCode]?['passwordsDoNotMatch'] ?? _localizedValues['ru']!['passwordsDoNotMatch']!;
  String get passwordTooShort => _localizedValues[locale.languageCode]?['passwordTooShort'] ?? _localizedValues['ru']!['passwordTooShort']!;
  String get invalidLogin => _localizedValues[locale.languageCode]?['invalidLogin'] ?? _localizedValues['ru']!['invalidLogin']!;
  String get invalidPassword => _localizedValues[locale.languageCode]?['invalidPassword'] ?? _localizedValues['ru']!['invalidPassword']!;
  String get invalidConfirmPassword => _localizedValues[locale.languageCode]?['invalidConfirmPassword'] ?? _localizedValues['ru']!['invalidConfirmPassword']!;
  String get accountCreated => _localizedValues[locale.languageCode]?['accountCreated'] ?? _localizedValues['ru']!['accountCreated']!;
  String get loginFailed => _localizedValues[locale.languageCode]?['loginFailed'] ?? _localizedValues['ru']!['loginFailed']!;
  String get changePassword => _localizedValues[locale.languageCode]?['changePassword'] ?? _localizedValues['ru']!['changePassword']!;
  String get currentPassword => _localizedValues[locale.languageCode]?['currentPassword'] ?? _localizedValues['ru']!['currentPassword']!;
  String get newPassword => _localizedValues[locale.languageCode]?['newPassword'] ?? _localizedValues['ru']!['newPassword']!;
  String get oldPasswordIncorrect => _localizedValues[locale.languageCode]?['oldPasswordIncorrect'] ?? _localizedValues['ru']!['oldPasswordIncorrect']!;
  String get passwordChanged => _localizedValues[locale.languageCode]?['passwordChanged'] ?? _localizedValues['ru']!['passwordChanged']!;
  String get passwordChangeFailed => _localizedValues[locale.languageCode]?['passwordChangeFailed'] ?? _localizedValues['ru']!['passwordChangeFailed']!;
  String get personalDataSubtitle => _localizedValues[locale.languageCode]?['personalDataSubtitle'] ?? _localizedValues['ru']!['personalDataSubtitle']!;
  String get securitySubtitle => _localizedValues[locale.languageCode]?['securitySubtitle'] ?? _localizedValues['ru']!['securitySubtitle']!;
  String get languageSubtitle => _localizedValues[locale.languageCode]?['languageSubtitle'] ?? _localizedValues['ru']!['languageSubtitle']!;
  String get selectLanguage => _localizedValues[locale.languageCode]?['selectLanguage'] ?? _localizedValues['ru']!['selectLanguage']!;
  String get languageChanged => _localizedValues[locale.languageCode]?['languageChanged'] ?? _localizedValues['ru']!['languageChanged']!;
  String get changePasswordSuccess => _localizedValues[locale.languageCode]?['changePasswordSuccess'] ?? _localizedValues['ru']!['changePasswordSuccess']!;
  String get clearDataConfirm => _localizedValues[locale.languageCode]?['clearDataConfirm'] ?? _localizedValues['ru']!['clearDataConfirm']!;
  String get clearDataSuccess => _localizedValues[locale.languageCode]?['clearDataSuccess'] ?? _localizedValues['ru']!['clearDataSuccess']!;
  String get dataManagementSubtitle => _localizedValues[locale.languageCode]?['dataManagementSubtitle'] ?? _localizedValues['ru']!['dataManagementSubtitle']!;
  String get backupSubtitle => _localizedValues[locale.languageCode]?['backupSubtitle'] ?? _localizedValues['ru']!['backupSubtitle']!;
  String get backupComingSoon => _localizedValues[locale.languageCode]?['backupComingSoon'] ?? _localizedValues['ru']!['backupComingSoon']!;
  String get helpAndFaqSubtitle => _localizedValues[locale.languageCode]?['helpAndFaqSubtitle'] ?? _localizedValues['ru']!['helpAndFaqSubtitle']!;
  String get supportSubtitle => _localizedValues[locale.languageCode]?['supportSubtitle'] ?? _localizedValues['ru']!['supportSubtitle']!;
  String get rateAppSubtitle => _localizedValues[locale.languageCode]?['rateAppSubtitle'] ?? _localizedValues['ru']!['rateAppSubtitle']!;
  String get logoutConfirm => _localizedValues[locale.languageCode]?['logoutConfirm'] ?? _localizedValues['ru']!['logoutConfirm']!;
  String get logoutConfirmText => _localizedValues[locale.languageCode]?['logoutConfirmText'] ?? _localizedValues['ru']!['logoutConfirmText']!;
  String get logoutSuccess => _localizedValues[locale.languageCode]?['logoutSuccess'] ?? _localizedValues['ru']!['logoutSuccess']!;
  String get name => _localizedValues[locale.languageCode]?['name'] ?? _localizedValues['ru']!['name']!;
  String get city => _localizedValues[locale.languageCode]?['city'] ?? _localizedValues['ru']!['city']!;
  String get phone => _localizedValues[locale.languageCode]?['phone'] ?? _localizedValues['ru']!['phone']!;
  String get email => _localizedValues[locale.languageCode]?['email'] ?? _localizedValues['ru']!['email']!;
  String get nameHint => _localizedValues[locale.languageCode]?['nameHint'] ?? _localizedValues['ru']!['nameHint']!;
  String get cityHint => _localizedValues[locale.languageCode]?['cityHint'] ?? _localizedValues['ru']!['cityHint']!;
  String get profileSaved => _localizedValues[locale.languageCode]?['profileSaved'] ?? _localizedValues['ru']!['profileSaved']!;
  String get logoutButton => _localizedValues[locale.languageCode]?['logoutButton'] ?? _localizedValues['ru']!['logoutButton']!;
  String get enterCode => _localizedValues[locale.languageCode]?['enterCode'] ?? _localizedValues['ru']!['enterCode']!;
  String get codeSentTo => _localizedValues[locale.languageCode]?['codeSentTo'] ?? _localizedValues['ru']!['codeSentTo']!;
  String get resendCode => _localizedValues[locale.languageCode]?['resendCode'] ?? _localizedValues['ru']!['resendCode']!;
  String get resendIn => _localizedValues[locale.languageCode]?['resendIn'] ?? _localizedValues['ru']!['resendIn']!;
  String get confirmPhone => _localizedValues[locale.languageCode]?['confirmPhone'] ?? _localizedValues['ru']!['confirmPhone']!;
  String get confirmPhoneText => _localizedValues[locale.languageCode]?['confirmPhoneText'] ?? _localizedValues['ru']!['confirmPhoneText']!;
  String get emailConfirmed => _localizedValues[locale.languageCode]?['emailConfirmed'] ?? _localizedValues['ru']!['emailConfirmed']!;
  String get phoneConfirmed => _localizedValues[locale.languageCode]?['phoneConfirmed'] ?? _localizedValues['ru']!['phoneConfirmed']!;
  String get enterAllDigits => _localizedValues[locale.languageCode]?['enterAllDigits'] ?? _localizedValues['ru']!['enterAllDigits']!;
  String get changePhone => _localizedValues[locale.languageCode]?['changePhone'] ?? _localizedValues['ru']!['changePhone']!;
  String get changeEmail => _localizedValues[locale.languageCode]?['changeEmail'] ?? _localizedValues['ru']!['changeEmail']!;
  String get codeResent => _localizedValues[locale.languageCode]?['codeResent'] ?? _localizedValues['ru']!['codeResent']!;
  String get smsResent => _localizedValues[locale.languageCode]?['smsResent'] ?? _localizedValues['ru']!['smsResent']!;
  String get selectLanguageTitle => _localizedValues[locale.languageCode]?['selectLanguageTitle'] ?? _localizedValues['ru']!['selectLanguageTitle']!;
  String get version => _localizedValues[locale.languageCode]?['version'] ?? _localizedValues['ru']!['version']!;
  String get appDescription => _localizedValues[locale.languageCode]?['appDescription'] ?? _localizedValues['ru']!['appDescription']!;
  String get appAuthor => _localizedValues[locale.languageCode]?['appAuthor'] ?? _localizedValues['ru']!['appAuthor']!;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();
  
  @override
  bool isSupported(Locale locale) {
    return ['ru', 'en', 'kk'].contains(locale.languageCode);
  }
  
  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }
  
  @override
  bool shouldReload(_AppLocalizationsDelegate old) => true;
}