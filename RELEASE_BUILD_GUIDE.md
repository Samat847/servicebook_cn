# Руководство по сборке Release APK

## Выполненные изменения

Проект подготовлен для успешной release сборки APK со следующими изменениями:

### 1. Application ID изменён
- **Старый**: `com.example.servicebook_cn`
- **Новый**: `kz.samat.avtoman`

### 2. SDK настройки
- **minSdk**: 24 (Android 7.0+) - обеспечивает совместимость с geolocator и современными библиотеками
- **targetSdk**: 34 (Android 14) - требуется для публикации в Google Play с августа 2024
- **compileSdk**: 34

### 3. Версия приложения
- **versionCode**: 2
- **versionName**: 1.0.1

### 4. Оптимизации сборки
- **Code shrinking** (minifyEnabled): включено
- **Resource shrinking** (shrinkResources): включено
- **ProGuard rules**: создан `android/app/proguard-rules.pro` с правилами для Flutter и плагинов
- **Native library extraction**: включено для уменьшения размера APK

### 5. Безопасность
- `usesCleartextTraffic="false"` - запрещает нешифрованный HTTP трафик
- Backup rules настроены для сохранения пользовательских данных

## Сборка Release APK

### Вариант 1: Сборка с debug подписью (для тестирования)

```bash
flutter clean
flutter pub get
flutter build apk --release
```

APK будет подписан debug ключом и сохранён в:
`build/app/outputs/flutter-apk/app-release.apk`

### Вариант 2: Сборка с собственным keystore (для публикации)

#### Шаг 1: Создать keystore (один раз)

```bash
cd android/app
keytool -genkey -v -keystore keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Введите:
- Пароль keystore (запомните/сохраните!)
- Информацию о владельце (имя, организация и т.д.)
- Пароль для ключа (можно использовать тот же)

#### Шаг 2: Настроить переменные окружения

**Linux/macOS:**
```bash
export KEYSTORE_PATH="android/app/keystore.jks"
export KEYSTORE_PASSWORD="your_keystore_password"
export KEY_ALIAS="upload"
export KEY_PASSWORD="your_key_password"
```

**Windows (PowerShell):**
```powershell
$env:KEYSTORE_PATH="android/app/keystore.jks"
$env:KEYSTORE_PASSWORD="your_keystore_password"
$env:KEY_ALIAS="upload"
$env:KEY_PASSWORD="your_key_password"
```

#### Шаг 3: Собрать APK

```bash
flutter clean
flutter pub get
flutter build apk --release
```

### Вариант 3: Использование key.properties (локальная разработка)

Создайте файл `android/key.properties`:

```properties
storePassword=your_keystore_password
keyPassword=your_key_password
keyAlias=upload
storeFile=../app/keystore.jks
```

**Важно**: файл `key.properties` добавлен в `.gitignore` и не должен попадать в git!

## Проверка подписи APK

```bash
# Проверить подпись
jarsigner -verify -verbose -certs build/app/outputs/flutter-apk/app-release.apk

# Информация о подписи
keytool -printcert -jarfile build/app/outputs/flutter-apk/app-release.apk
```

## Создание App Bundle (AAB) для Google Play

```bash
flutter build appbundle --release
```

AAB будет сохранён в:
`build/app/outputs/bundle/release/app-release.aab`

## Важные примечания

1. **Google Maps API Key**: Замените `YOUR_GOOGLE_MAPS_API_KEY_HERE` в `AndroidManifest.xml` на реальный ключ для production

2. **Keystore безопасность**: 
   - Никогда не коммитьте keystore файлы (.jks, .keystore)
   - Храните пароли в надёжном месте
   - Для CI/CD используйте переменные окружения или секреты

3. **ProGuard**: При включенном minifyEnabled тщательно тестируйте приложение, так как некоторые классы могут быть удалены. Созданный `proguard-rules.pro` содержит базовые правила для Flutter и используемых плагинов.

4. **Размер APK**: С включенным shrinkResources и minifyEnabled размер APK должен уменьшиться на 20-40%.

5. **Резервное копирование**: Настроено автоматическое резервное копирование SharedPreferences (кроме FlutterSharedPreferences).

## Устранение неполадок

### Ошибка: "Could not find keystore file"
Убедитесь, что переменная `KEYSTORE_PATH` указывает на правильный путь относительно папки `android/app/`.

### Ошибка: "Keystore was tampered with"
Неверный пароль keystore. Проверьте переменную `KEYSTORE_PASSWORD`.

### Ошибка: "Cannot recover key"
Неверный пароль ключа. Проверьте переменную `KEY_PASSWORD`.

### Ошибка: "Entry was not found"
Неверный alias ключа. Проверьте переменную `KEY_ALIAS`.
