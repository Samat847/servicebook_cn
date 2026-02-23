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
      'dashboardTitle': 'Главная',
      'mapTitle': 'Карта',
      
      // DashboardScreen
      'myGarage': 'Мой Гараж',
      'noCars': 'Нет автомобилей',
      'noCarsDescription': 'Добавьте автомобиль в разделе "Гараж"',
      'dataLoadingError': 'Ошибка загрузки данных:',
      'retry': 'Повторить',
      'monthlyExpenses': 'Расходы в месяце',
      'nextService': 'Следующее ТО',
      'inKM': 'через {km} км',
      'addRecord': 'Добавить запись',
      'sellReport': 'Отчет для продажи',
      'partnersStos': 'Партнеры СТО',
      'analytics': 'Аналитика',
      'workHistory': 'История работ',
      'all': 'Все',
      'allRecords': 'Все записи',
      'partnerStos': 'Партнерские СТО',
      'bookOnline': 'Запишись онлайн и получи скидку 10%',
      'withDiscount': '-{discount}',
      'allDocuments': 'Документы',
      'personalData': 'Личные данные',
      'manageData': 'Управление данными',
      'backups': 'Резервные копии',
      'helpFaq': 'Помощь и FAQ',
      'contactSupport': 'Связаться с поддержкой',
      'rateApp': 'Оценить приложение',
      'privacyPolicy': 'Политика конфиденциальности',
      'termsOfUse': 'Условия использования',
      'aboutApp': 'О приложении',
      'bonusPoints': 'Бонусные баллы',
      'refill': 'Пополнить',
      'myGarageTitle': 'Мой гараж',
      'addButton': 'Добавить',
      'driverLicense': 'Водительское удостоверение',
      'validUntil2028': 'Действительно до 2028',
      'osago': 'ОСАГО',
      'valid': 'Действует',
      'sts': 'СТС',
      'unlimited': 'Бессрочно',
      'settingsTitle': 'Настройки',
      'premium': 'Premium',
      'noCarsInGarage': 'В гараже пока нет автомобилей',
      'addCar': 'Добавить автомобиль',
      'withoutPlate': 'Без номера',
      'inDays': 'Через {km} км',
      'openAppStore': 'Открываем магазин приложений...',
      'logout': 'Выйти',
      'applyingLanguage': 'Применяем язык...',
      'languageChangedTo': 'Язык изменён на',
      'languageChangeError': 'Ошибка смены языка:',
      
      // Quick Actions and Smart Tips
      'quickActions': 'Быстрые действия',
      'smartTips': 'Умные подсказки',
      'refuel': 'Заправить',
      'carWash': 'Мойка',
      'service': 'ТО',
      'tires': 'Шины',
      'avgConsumption': 'Ср. расход',
      'untilNextService': 'До ТО',
      'untilNextServiceShort': 'км',
      'documentExpiring': 'истекает через',
      'documentDays': 'дн.',
      'monthlySpending': 'Расходы за месяц',
      'reminder': 'Напоминание',
      'checkTirePressure': 'Проверьте давление в шинах',
      'tipAddFirstRecord': 'Добавьте первую запись',
      'tipAdvice': 'Совет',
      'fuelWorkType': 'Топливо',
      'washWorkType': 'Мойка',
      'tiresWorkType': 'Резина',
      
      // ExpertScreen
      'expert': 'Эксперт',
      'expertTitle': 'Эксперт',
      'expertSubtitle': 'Чат по китайским автомобилям • AI-режим',
      'expertWelcomeMessage': 'Привет! Я AI-эксперт по китайским автомобилям.\n\nЯ могу помочь вам с:\n• Подбором масла и расходников\n• Расшифровкой ошибок OBD\n• Советами по ТО и ремонту\n• Анализом типичных проблем',
      'expertUserQuestion': 'Какое масло лучше заливать в Chery Tiggo 7 Pro?',
      'expertAnswer': 'Для Chery Tiggo 7 Pro рекомендую:\n\n• Моторное масло: 5W-30 (полусинтетика или синтетика)\n• Объём: ~4.5 литра (с фильтром)\n• Стандарт: API SN/SP, ACEA C3\n• Примеры: Shell Helix HX7, Mobil Super 3000, Gazpromneft Premium N',
      'expertChipOil': 'Масло для Chery',
      'expertChipService': 'Когда следующее ТО?',
      'expertQuickDecode': 'Расшифровать код ошибки P0171',
      'expertInputHint': 'Опишите вопрос или вставьте текст ошибки с панели',
      'expertFooterNote': 'Эксперт учитывает историю расходов и ТО из раздела "Мой гараж"',
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
      'dashboardTitle': 'Home',
      'mapTitle': 'Map',
      
      // DashboardScreen
      'myGarage': 'My Garage',
      'noCars': 'No Cars',
      'noCarsDescription': 'Add a car in the Garage section',
      'dataLoadingError': 'Data loading error:',
      'retry': 'Retry',
      'monthlyExpenses': 'Monthly Expenses',
      'nextService': 'Next Service',
      'inKM': 'in {km} km',
      'addRecord': 'Add Record',
      'sellReport': 'Sell Report',
      'partnersStos': 'Service Partners',
      'analytics': 'Analytics',
      'workHistory': 'Work History',
      'all': 'All',
      'allRecords': 'All Records',
      'partnerStos': 'Partner Service Centers',
      'bookOnline': 'Book online and get 10% discount',
      'withDiscount': '-{discount}',
      'allDocuments': 'Documents',
      'personalData': 'Personal Data',
      'manageData': 'Data Management',
      'backups': 'Backups',
      'helpFaq': 'Help & FAQ',
      'contactSupport': 'Contact Support',
      'rateApp': 'Rate App',
      'privacyPolicy': 'Privacy Policy',
      'termsOfUse': 'Terms of Use',
      'aboutApp': 'About App',
      'bonusPoints': 'Bonus Points',
      'refill': 'Top Up',
      'myGarageTitle': 'My Garage',
      'addButton': 'Add',
      'driverLicense': 'Driver License',
      'validUntil2028': 'Valid until 2028',
      'osago': 'OSAGO',
      'valid': 'Valid',
      'sts': 'STS',
      'unlimited': 'Unlimited',
      'settingsTitle': 'Settings',
      'premium': 'Premium',
      'noCarsInGarage': 'No cars in garage yet',
      'addCar': 'Add Car',
      'withoutPlate': 'No plate',
      'inDays': 'In {km} km',
      'openAppStore': 'Opening app store...',
      'logout': 'Logout',
      'applyingLanguage': 'Applying language...',
      'languageChangedTo': 'Language changed to',
      'languageChangeError': 'Language change error:',
      
      // Quick Actions and Smart Tips
      'quickActions': 'Quick Actions',
      'smartTips': 'Smart Tips',
      'refuel': 'Refuel',
      'carWash': 'Car Wash',
      'service': 'Service',
      'tires': 'Tires',
      'avgConsumption': 'Avg. consumption',
      'untilNextService': 'Until next service',
      'untilNextServiceShort': 'km',
      'documentExpiring': 'expires in',
      'documentDays': 'days',
      'monthlySpending': 'Monthly spending',
      'reminder': 'Reminder',
      'checkTirePressure': 'Check tire pressure',
      'tipAddFirstRecord': 'Add your first record',
      'tipAdvice': 'Advice',
      'fuelWorkType': 'Fuel',
      'washWorkType': 'Car Wash',
      'tiresWorkType': 'Tires',
      
      // ExpertScreen
      'expert': 'Expert',
      'expertTitle': 'Expert',
      'expertSubtitle': 'Chinese Cars Chat • AI Mode',
      'expertWelcomeMessage': 'Hi! I am an AI expert on Chinese cars.\n\nI can help you with:\n• Oil and consumables selection\n• OBD error decoding\n• Maintenance and repair advice\n• Typical problems analysis',
      'expertUserQuestion': 'What oil is best for Chery Tiggo 7 Pro?',
      'expertAnswer': 'For Chery Tiggo 7 Pro I recommend:\n\n• Engine oil: 5W-30 (semi-synthetic or synthetic)\n• Volume: ~4.5 liters (with filter)\n• Standard: API SN/SP, ACEA C3\n• Examples: Shell Helix HX7, Mobil Super 3000, Gazpromneft Premium N',
      'expertChipOil': 'Oil for Chery',
      'expertChipService': 'When is the next service?',
      'expertQuickDecode': 'Decode error code P0171',
      'expertInputHint': 'Describe your question or paste error text from the panel',
      'expertFooterNote': 'Expert considers expense and service history from "My Garage" section',
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
      'dashboardTitle': 'Басты бет',
      'mapTitle': 'Карта',
      
      // DashboardScreen
      'myGarage': 'Менің гаражым',
      'noCars': 'Автокөлік жоқ',
      'noCarsDescription': 'Гараж бөлімінде автокөлік қосыңыз',
      'dataLoadingError': 'Деректерді жүктеу қатесі:',
      'retry': 'Қайталау',
      'monthlyExpenses': 'Ай шығыстары',
      'nextService': 'Келесі қызмет көрсету',
      'inKM': '{km} км ішінде',
      'addRecord': 'Жазба қосу',
      'sellReport': 'Сату есебі',
      'partnersStos': 'Серіктес СТО',
      'analytics': 'Аналитика',
      'workHistory': 'Жұмыс тарихы',
      'all': 'Барлығы',
      'allRecords': 'Барлық жазбалар',
      'partnerStos': 'Серіктес СТО-лар',
      'bookOnline': 'Онлайн жазылып 10% жеңілдік алыңыз',
      'withDiscount': '-{discount}',
      'allDocuments': 'Құжаттар',
      'personalData': 'Жеке деректер',
      'manageData': 'Деректерді басқару',
      'backups': 'Қорғаныш көшірмелер',
      'helpFaq': 'Көмек мен FAQ',
      'contactSupport': 'Қолдау көрсету',
      'rateApp': 'Қолданбаны бағалау',
      'privacyPolicy': 'Құпиялылық саясаты',
      'termsOfUse': 'Қолдану шарттары',
      'aboutApp': 'Қолданба туралы',
      'bonusPoints': 'Бонус ұпайлары',
      'refill': 'Толтыру',
      'myGarageTitle': 'Менің гаражым',
      'addButton': 'Қосу',
      'driverLicense': 'Жүргізуші куəлігі',
      'validUntil2028': '2028 жылға дейін жарамды',
      'osago': 'ОСАГО',
      'valid': 'Жарамды',
      'sts': 'СТС',
      'unlimited': ' мерзімсіз',
      'settingsTitle': 'Баптаулар',
      'premium': 'Премиум',
      'noCarsInGarage': 'Гаражда әлі автокөлік жоқ',
      'addCar': 'Автокөлік қосу',
      'withoutPlate': 'Нөмірсіз',
      'inDays': '{km} км ішінде',
      'openAppStore': 'Қолданба дүкенін ашып жатыр...',
      'logout': 'Шығу',
      'applyingLanguage': 'Тілді қолдану...',
      'languageChangedTo': 'Тіл өзгертілді',
      'languageChangeError': 'Тіл өзгерту қатесі:',
      
      // Quick Actions and Smart Tips
      'quickActions': 'Жылдам әрекеттер',
      'smartTips': 'Смарт кеңестер',
      'refuel': 'Құю',
      'carWash': 'Жуу',
      'service': 'Қызмет көрсету',
      'tires': 'Дөңгелектер',
      'avgConsumption': 'Орташа шығын',
      'untilNextService': 'Келесі қызметке дейін',
      'untilNextServiceShort': 'км',
      'documentExpiring': 'мерзімі аяқталады',
      'documentDays': 'күн',
      'monthlySpending': 'Айлық шығыстар',
      'reminder': 'Еске салу',
      'checkTirePressure': 'Дөңгелек қысымын тексеріңіз',
      'tipAddFirstRecord': 'Бірінші жазба қосыңыз',
      'tipAdvice': 'Кеңес',
      'fuelWorkType': 'Отын',
      'washWorkType': 'Жуу',
      'tiresWorkType': 'Дөңгелектер',
      
      // ExpertScreen
      'expert': 'Сарапшы',
      'expertTitle': 'Сарапшы',
      'expertSubtitle': 'Қытай автокөліктері чаты • AI режимі',
      'expertWelcomeMessage': 'Сәлем! Мен қытай автокөліктері бойынша AI-сарапшымын.\n\nМен сізге көмектесе аламын:\n• Май және тұтынables таңдау\n• OBD қателерін декодтау\n• Техникалық қызмет көрсету және жөндеу кеңестері\n• Типтік мәселелерді талдау',
      'expertUserQuestion': 'Chery Tiggo 7 Pro үшін қандай майды құю керек?',
      'expertAnswer': 'Chery Tiggo 7 Pro үшін ұсынамын:\n\n• Қозғалтқыш майы: 5W-30 (жартылай синтетика немесе синтетика)\n• Көлемі: ~4.5 литр (сүзгімен)\n• Стандарты: API SN/SP, ACEA C3\n• Мысалдары: Shell Helix HX7, Mobil Super 3000, Gazpromneft Premium N',
      'expertChipOil': 'Chery үшін май',
      'expertChipService': 'Келесі ТО қашан?',
      'expertQuickDecode': 'P0171 қате кодын декодтау',
      'expertInputHint': 'Сұрақты сипаттаңыз немесе панельден қате мәтінін қойыңыз',
      'expertFooterNote': 'Сарапшы "Менің гаражым" бөліміндегі шығындар мен ТО тарихын ескереді',
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
  String get dashboardTitle => _localizedValues[locale.languageCode]?['dashboardTitle'] ?? _localizedValues['ru']!['dashboardTitle']!;
  String get mapTitle => _localizedValues[locale.languageCode]?['mapTitle'] ?? _localizedValues['ru']!['mapTitle']!;
  
  // DashboardScreen
  String get myGarage => _localizedValues[locale.languageCode]?['myGarage'] ?? _localizedValues['ru']!['myGarage']!;
  String get noCars => _localizedValues[locale.languageCode]?['noCars'] ?? _localizedValues['ru']!['noCars']!;
  String get noCarsDescription => _localizedValues[locale.languageCode]?['noCarsDescription'] ?? _localizedValues['ru']!['noCarsDescription']!;
  String get dataLoadingError => _localizedValues[locale.languageCode]?['dataLoadingError'] ?? _localizedValues['ru']!['dataLoadingError']!;
  String get retry => _localizedValues[locale.languageCode]?['retry'] ?? _localizedValues['ru']!['retry']!;
  String get monthlyExpenses => _localizedValues[locale.languageCode]?['monthlyExpenses'] ?? _localizedValues['ru']!['monthlyExpenses']!;
  String get nextService => _localizedValues[locale.languageCode]?['nextService'] ?? _localizedValues['ru']!['nextService']!;
  String inKM(int km) => _localizedValues[locale.languageCode]?['inKM']?.replaceAll('{km}', km.toString()) ?? _localizedValues['ru']!['inKM']!.replaceAll('{km}', km.toString());
  String get addRecord => _localizedValues[locale.languageCode]?['addRecord'] ?? _localizedValues['ru']!['addRecord']!;
  String get sellReport => _localizedValues[locale.languageCode]?['sellReport'] ?? _localizedValues['ru']!['sellReport']!;
  String get partnersStos => _localizedValues[locale.languageCode]?['partnersStos'] ?? _localizedValues['ru']!['partnersStos']!;
  String get analytics => _localizedValues[locale.languageCode]?['analytics'] ?? _localizedValues['ru']!['analytics']!;
  String get workHistory => _localizedValues[locale.languageCode]?['workHistory'] ?? _localizedValues['ru']!['workHistory']!;
  String get all => _localizedValues[locale.languageCode]?['all'] ?? _localizedValues['ru']!['all']!;
  String get allRecords => _localizedValues[locale.languageCode]?['allRecords'] ?? _localizedValues['ru']!['allRecords']!;
  String get partnerStos => _localizedValues[locale.languageCode]?['partnerStos'] ?? _localizedValues['ru']!['partnerStos']!;
  String get bookOnline => _localizedValues[locale.languageCode]?['bookOnline'] ?? _localizedValues['ru']!['bookOnline']!;
  String withDiscount(String discount) => _localizedValues[locale.languageCode]?['withDiscount']?.replaceAll('{discount}', discount) ?? _localizedValues['ru']!['withDiscount']!.replaceAll('{discount}', discount);
  String get allDocuments => _localizedValues[locale.languageCode]?['allDocuments'] ?? _localizedValues['ru']!['allDocuments']!;
  String get manageData => _localizedValues[locale.languageCode]?['manageData'] ?? _localizedValues['ru']!['manageData']!;
  String get backups => _localizedValues[locale.languageCode]?['backups'] ?? _localizedValues['ru']!['backups']!;
  String get helpFaq => _localizedValues[locale.languageCode]?['helpFaq'] ?? _localizedValues['ru']!['helpFaq']!;
  String get contactSupport => _localizedValues[locale.languageCode]?['contactSupport'] ?? _localizedValues['ru']!['contactSupport']!;
  String get rateApp => _localizedValues[locale.languageCode]?['rateApp'] ?? _localizedValues['ru']!['rateApp']!;
  String get termsOfUse => _localizedValues[locale.languageCode]?['termsOfUse'] ?? _localizedValues['ru']!['termsOfUse']!;
  String get aboutApp => _localizedValues[locale.languageCode]?['aboutApp'] ?? _localizedValues['ru']!['aboutApp']!;
  String get bonusPoints => _localizedValues[locale.languageCode]?['bonusPoints'] ?? _localizedValues['ru']!['bonusPoints']!;
  String get refill => _localizedValues[locale.languageCode]?['refill'] ?? _localizedValues['ru']!['refill']!;
  String get myGarageTitle => _localizedValues[locale.languageCode]?['myGarageTitle'] ?? _localizedValues['ru']!['myGarageTitle']!;
  String get addButton => _localizedValues[locale.languageCode]?['addButton'] ?? _localizedValues['ru']!['addButton']!;
  String get driverLicense => _localizedValues[locale.languageCode]?['driverLicense'] ?? _localizedValues['ru']!['driverLicense']!;
  String get validUntil2028 => _localizedValues[locale.languageCode]?['validUntil2028'] ?? _localizedValues['ru']!['validUntil2028']!;
  String get osago => _localizedValues[locale.languageCode]?['osago'] ?? _localizedValues['ru']!['osago']!;
  String get valid => _localizedValues[locale.languageCode]?['valid'] ?? _localizedValues['ru']!['valid']!;
  String get sts => _localizedValues[locale.languageCode]?['sts'] ?? _localizedValues['ru']!['sts']!;
  String get unlimited => _localizedValues[locale.languageCode]?['unlimited'] ?? _localizedValues['ru']!['unlimited']!;
  String get settingsTitle => _localizedValues[locale.languageCode]?['settingsTitle'] ?? _localizedValues['ru']!['settingsTitle']!;
  String get premium => _localizedValues[locale.languageCode]?['premium'] ?? _localizedValues['ru']!['premium']!;
  String get noCarsInGarage => _localizedValues[locale.languageCode]?['noCarsInGarage'] ?? _localizedValues['ru']!['noCarsInGarage']!;
  String get withoutPlate => _localizedValues[locale.languageCode]?['withoutPlate'] ?? _localizedValues['ru']!['withoutPlate']!;
  String inDays(int km) => _localizedValues[locale.languageCode]?['inDays']?.replaceAll('{km}', km.toString()) ?? _localizedValues['ru']!['inDays']!.replaceAll('{km}', km.toString());
  String get openAppStore => _localizedValues[locale.languageCode]?['openAppStore'] ?? _localizedValues['ru']!['openAppStore']!;
  String get applyingLanguage => _localizedValues[locale.languageCode]?['applyingLanguage'] ?? _localizedValues['ru']!['applyingLanguage']!;
  String get languageChangedTo => _localizedValues[locale.languageCode]?['languageChangedTo'] ?? _localizedValues['ru']!['languageChangedTo']!;
  String get languageChangeError => _localizedValues[locale.languageCode]?['languageChangeError'] ?? _localizedValues['ru']!['languageChangeError']!;
  
  // Quick Actions and Smart Tips
  String get quickActions => _localizedValues[locale.languageCode]?['quickActions'] ?? _localizedValues['ru']!['quickActions']!;
  String get smartTips => _localizedValues[locale.languageCode]?['smartTips'] ?? _localizedValues['ru']!['smartTips']!;
  String get refuel => _localizedValues[locale.languageCode]?['refuel'] ?? _localizedValues['ru']!['refuel']!;
  String get carWash => _localizedValues[locale.languageCode]?['carWash'] ?? _localizedValues['ru']!['carWash']!;
  String get service => _localizedValues[locale.languageCode]?['service'] ?? _localizedValues['ru']!['service']!;
  String get tires => _localizedValues[locale.languageCode]?['tires'] ?? _localizedValues['ru']!['tires']!;
  String get avgConsumption => _localizedValues[locale.languageCode]?['avgConsumption'] ?? _localizedValues['ru']!['avgConsumption']!;
  String get untilNextService => _localizedValues[locale.languageCode]?['untilNextService'] ?? _localizedValues['ru']!['untilNextService']!;
  String get untilNextServiceShort => _localizedValues[locale.languageCode]?['untilNextServiceShort'] ?? _localizedValues['ru']!['untilNextServiceShort']!;
  String get documentExpiring => _localizedValues[locale.languageCode]?['documentExpiring'] ?? _localizedValues['ru']!['documentExpiring']!;
  String get documentDays => _localizedValues[locale.languageCode]?['documentDays'] ?? _localizedValues['ru']!['documentDays']!;
  String get monthlySpending => _localizedValues[locale.languageCode]?['monthlySpending'] ?? _localizedValues['ru']!['monthlySpending']!;
  String get reminder => _localizedValues[locale.languageCode]?['reminder'] ?? _localizedValues['ru']!['reminder']!;
  String get checkTirePressure => _localizedValues[locale.languageCode]?['checkTirePressure'] ?? _localizedValues['ru']!['checkTirePressure']!;
  String get tipAddFirstRecord => _localizedValues[locale.languageCode]?['tipAddFirstRecord'] ?? _localizedValues['ru']!['tipAddFirstRecord']!;
  String get tipAdvice => _localizedValues[locale.languageCode]?['tipAdvice'] ?? _localizedValues['ru']!['tipAdvice']!;
  String get fuelWorkType => _localizedValues[locale.languageCode]?['fuelWorkType'] ?? _localizedValues['ru']!['fuelWorkType']!;
  String get washWorkType => _localizedValues[locale.languageCode]?['washWorkType'] ?? _localizedValues['ru']!['washWorkType']!;
  String get tiresWorkType => _localizedValues[locale.languageCode]?['tiresWorkType'] ?? _localizedValues['ru']!['tiresWorkType']!;
  
  // ExpertScreen getters
  String get expert => _localizedValues[locale.languageCode]?['expert'] ?? _localizedValues['ru']!['expert']!;
  String get expertTitle => _localizedValues[locale.languageCode]?['expertTitle'] ?? _localizedValues['ru']!['expertTitle']!;
  String get expertSubtitle => _localizedValues[locale.languageCode]?['expertSubtitle'] ?? _localizedValues['ru']!['expertSubtitle']!;
  String get expertWelcomeMessage => _localizedValues[locale.languageCode]?['expertWelcomeMessage'] ?? _localizedValues['ru']!['expertWelcomeMessage']!;
  String get expertUserQuestion => _localizedValues[locale.languageCode]?['expertUserQuestion'] ?? _localizedValues['ru']!['expertUserQuestion']!;
  String get expertAnswer => _localizedValues[locale.languageCode]?['expertAnswer'] ?? _localizedValues['ru']!['expertAnswer']!;
  String get expertChipOil => _localizedValues[locale.languageCode]?['expertChipOil'] ?? _localizedValues['ru']!['expertChipOil']!;
  String get expertChipService => _localizedValues[locale.languageCode]?['expertChipService'] ?? _localizedValues['ru']!['expertChipService']!;
  String get expertQuickDecode => _localizedValues[locale.languageCode]?['expertQuickDecode'] ?? _localizedValues['ru']!['expertQuickDecode']!;
  String get expertInputHint => _localizedValues[locale.languageCode]?['expertInputHint'] ?? _localizedValues['ru']!['expertInputHint']!;
  String get expertFooterNote => _localizedValues[locale.languageCode]?['expertFooterNote'] ?? _localizedValues['ru']!['expertFooterNote']!;
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