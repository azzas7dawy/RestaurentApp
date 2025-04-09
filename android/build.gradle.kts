buildscript {
    // ext.kotlin_version = '2.1.0'
    repositories {
        google()
        mavenCentral()
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
