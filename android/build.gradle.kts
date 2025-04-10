allprojects {
    //  ext.kotlin_version = '1.9.22'
    repositories {
        google()
        jcenter()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:4.1.0")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.3.50")
        classpath("com.google.gms:google-services:4.3.3")
    }
    dependencies {
        
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.9.23")
        // classpath("dev.flutter:flutter-gradle-plugin:1.0.0") // استخدم نسخة flutter المناسبة
        classpath("com.google.gms:google-services:4.4.1")
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

dependencies {
    classpath("dev.flutter:flutter-gradle-plugin")
    id 'com.google.gms.google-services' version '4.4.2' apply false
}

