plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    // namespace = "com.example.restrant_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion
    
//   buildTypes {
//     release {
//         isMinifyEnabled = true
//         isShrinkResources = true
//         proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
//         signingConfig = signingConfigs.getByName("debug")
//     }
// }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        // applicationId = "com.example.fierfier"
        
        applicationId = "com.example.restrant_app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }
 buildTypes {
        // getByName("release") {
        //     minifyEnabled = true
        //     isMinifyEnabled = false
        //     isShrinkResources = false
        //     proguardFiles(
        //         getDefaultProguardFile("proguard-android-optimize.txt"),
        //         "proguard-rules.pro"
        //     )
        // }
    }
   
}

flutter {
    source = "../.."
}

dependencies {
    implementation(platform("com.google.firebase:firebase-bom:33.10.0"))
    implementation("com.google.firebase:firebase-analytics")
}

