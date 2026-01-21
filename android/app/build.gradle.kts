plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services") version "4.4.4" apply false
    id("com.google.gms.google-services")  
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.ecopet"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
       defaultConfig {
        applicationId "com.ecopet.app"  // ← Package name
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "1.0"
        multiDexEnabled true
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // MultiDex
    implementation 'androidx.multidex:multidex:2.0.1'
    
    // Firebase BoM
    implementation(platform("com.google.firebase:firebase-bom:34.8.0"))
    
    // Firebase products (tanpa versi, diatur BoM)
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-auth")
}