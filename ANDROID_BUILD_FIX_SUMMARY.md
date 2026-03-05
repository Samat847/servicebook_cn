# Исправления сборки Android для Flutter-приложения AvtoMAN

## Проблемы

Произошли ошибки компиляции Kotlin в плагинах `file_picker` и `package_info_plus`, связанные с несовместимостью версий:
- **Kotlin 2.1.0** несовместим с **AGP 8.2.2**
- **Gradle 8.13** требует **AGP 8.5+**
- **SDK 35** требует **AGP 8.4.0+**
- Плагины `file_picker: 8.0.7` и `package_info_plus: 8.0.0` имели проблемы с Kotlin 2.x

## Внесённые исправления

### 1. Обновление Android Gradle Plugin и Kotlin
**Файл:** `android/settings.gradle.kts`

```kotlin
// Было:
id("com.android.application") version "8.2.2" apply false
id("org.jetbrains.kotlin.android") version "1.9.25" apply false

// Стало:
id("com.android.application") version "8.4.2" apply false
id("org.jetbrains.kotlin.android") version "2.0.21" apply false
```

### 2. Обновление Gradle Wrapper
**Файл:** `android/gradle/wrapper/gradle-wrapper.properties`

```properties
# Было:
distributionUrl=https\://services.gradle.org/distributions/gradle-8.13-all.zip

# Стало:
distributionUrl=https\://services.gradle.org/distributions/gradle-8.8-all.zip
```

### 3. Обновление версий плагинов Flutter
**Файл:** `pubspec.yaml`

```yaml
# Было:
package_info_plus: ^8.0.0
file_picker: ^8.0.0

# Стало:
package_info_plus: ^8.3.1
file_picker: ^10.1.8
```

### 4. Обновление gradle.properties
**Файл:** `android/gradle.properties`

```properties
# Добавлено:
android.enableJetifier=true
kotlin.stdlib.default.dependency=false
```

### 5. Обновление конфигурации Kotlin в app/build.gradle.kts
**Файл:** `android/app/build.gradle.kts`

```kotlin
// Было:
kotlinOptions {
    jvmTarget = "17"
    freeCompilerArgs += listOf(
        "-Xjvm-default=all"
    )
}

// Стало:
kotlinOptions {
    jvmTarget = JavaVersion.VERSION_17.toString()
}

kotlin {
    jvmToolchain(17)
}
```

## Итоговая матрица версий

| Компонент | Версия | Примечание |
|-----------|--------|------------|
| AGP | 8.4.2 | Поддерживает SDK 35 |
| Kotlin | 2.0.21 | Стабильная LTS версия |
| Gradle | 8.8 | Совместим с AGP 8.4.x |
| compileSdk | 35 | Android 15 |
| targetSdk | 35 | Android 15 |
| minSdk | 24 | Android 7.0 |
| file_picker | 10.1.8 | Полная поддержка Kotlin 2.x |
| package_info_plus | 8.3.1 | Совместим с Kotlin 2.x |

## Инструкция по сборке

```bash
# 1. Очистка проекта
flutter clean

# 2. Очистка Gradle кэша (при необходимости)
cd android && ./gradlew clean && cd ..

# 3. Получение зависимостей
flutter pub get

# 4. Сборка release APK
flutter build apk --release
```

APK будет доступен по пути: `build/app/outputs/flutter-apk/app-release.apk`

## Резервный вариант (если проблемы сохраняются)

Если сборка всё ещё не работает, можно использовать консервативный вариант с понижением до SDK 34:

**settings.gradle.kts:**
```kotlin
id("com.android.application") version "8.2.2" apply false
id("org.jetbrains.kotlin.android") version "1.9.25" apply false
```

**gradle-wrapper.properties:**
```properties
distributionUrl=https\://services.gradle.org/distributions/gradle-8.5-all.zip
```

**app/build.gradle.kts:**
```kotlin
compileSdk = 34
targetSdk = 34
```

**pubspec.yaml:**
```yaml
file_picker: ^8.0.7  # или последняя совместимая версия
```
