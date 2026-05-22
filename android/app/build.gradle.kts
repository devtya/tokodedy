plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.hend_kasir"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.hend_kasir"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            // Baca dari env variable (CI), fallback ke nilai default (lokal)
            val keystorePath = System.getenv("KEYSTORE_PATH") ?: "keystore/release.keystore"
            val keystorePass = System.getenv("KEYSTORE_PASSWORD") ?: "HendKasir2024"
            val keyAliasName = System.getenv("KEY_ALIAS") ?: "release"
            val keyPass = System.getenv("KEY_PASSWORD") ?: "HendKasir2024"

            storeFile = file(keystorePath)
            storePassword = keystorePass
            keyAlias = keyAliasName
            keyPassword = keyPass
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }

    applicationVariants.all {
        outputs.all {
            val output = this
            if (output is com.android.build.gradle.internal.api.ApkVariantOutputImpl) {
                output.outputFileName = "hendkasir-v${defaultConfig.versionName}.apk"
            }
        }
    }
}

flutter {
    source = "../.."
}
