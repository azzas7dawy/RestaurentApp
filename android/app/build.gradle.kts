// File: android/app/build.gradle.kts

import org.gradle.api.tasks.testing.Test
import java.util.Properties

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android") version "2.1.20"
    id("com.google.gms.google-services")
    id("dev.flutter.flutter-gradle-plugin")
}

// قراءة متغيّر skipTests من gradle.properties
// افتراضيًا true حتى يتم تنفيذ البناء بدون اختبارات
val skipTests = project
    .findProperty("skipTests")
    ?.toString()
    ?.toBoolean()
    ?: true

val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")
if (localPropertiesFile.exists()) {
    localPropertiesFile.inputStream().use { localProperties.load(it) }
}

val flutterVersionCode = localProperties
    .getProperty("flutter.versionCode")
    ?.toInt() ?: 1
val flutterVersionName = localProperties
    .getProperty("flutter.versionName") ?: "1.0"

android {
    namespace = "com.example.restrant_app"
    compileSdk = 35

    defaultConfig {
        applicationId = "com.example.fierfier"
        minSdk = 23
        targetSdk = 35
        versionCode = flutterVersionCode
        versionName = flutterVersionName
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation(platform("com.google.firebase:firebase-bom:33.10.0"))
    implementation("com.google.firebase:firebase-analytics")
}

// تعطيل كل اختبارات الوحدة حسب قيمة skipTests
tasks.withType<Test>().configureEach {
    enabled = !skipTests
}
