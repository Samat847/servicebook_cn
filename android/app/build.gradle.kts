import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keyPropertiesFile = rootProject.file("key.properties")
val keyProperties = Properties()
if (keyPropertiesFile.exists()) {
    keyPropertiesFile.inputStream().use { keyProperties.load(it) }
}

android {
    namespace = "kz.samat.avtoman"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "kz.samat.avtoman"
        minSdk = 24
        targetSdk = 35
        versionCode = 2
        versionName = "1.0.1"
    }

    signingConfigs {
        create("release") {
            val keystorePath = System.getenv("KEYSTORE_PATH")
                ?: keyProperties.getProperty("storeFile")
            val keystorePassword = System.getenv("KEYSTORE_PASSWORD")
                ?: keyProperties.getProperty("storePassword")
            val keyAlias = System.getenv("KEY_ALIAS")
                ?: keyProperties.getProperty("keyAlias")
            val keyPassword = System.getenv("KEY_PASSWORD")
                ?: keyProperties.getProperty("keyPassword")

            if (keystorePath != null && keystorePassword != null &&
                keyAlias != null && keyPassword != null) {
                storeFile = file(keystorePath)
                storePassword = keystorePassword
                this.keyAlias = keyAlias
                this.keyPassword = keyPassword
            }
        }
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            val releaseConfig = signingConfigs.getByName("release")
            signingConfig = if (releaseConfig.storeFile != null) {
                releaseConfig
            } else {
                signingConfigs.getByName("debug")
            }
        }
        debug {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}

configurations.all {
    resolutionStrategy {
        force("androidx.core:core:1.13.1")
        force("androidx.core:core-ktx:1.13.1")
        force("androidx.activity:activity:1.9.0")
        force("androidx.activity:activity-ktx:1.9.0")
        force("androidx.browser:browser:1.8.0")
        force("androidx.media3:media3-exoplayer:1.3.1")
        force("androidx.media3:media3-session:1.3.1")
        force("androidx.lifecycle:lifecycle-runtime:2.8.0")
        force("androidx.lifecycle:lifecycle-common:2.8.0")
    }
}
