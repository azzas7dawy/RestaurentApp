Add project specific ProGuard rules here.

By default, the flags in this file are appended to flags specified

in the default ProGuard configuration.

Keep the android.window.BackEvent class to prevent R8 from removing it

-keep class android.window.BackEvent { *; }

Suppress warnings related to android.window.BackEvent

-dontwarn android.window.BackEvent

# Please add these rules to your existing keep rules in order to suppress warnings.
# This is generated automatically by the Android Gradle plugin.
-dontwarn android.window.BackEvent