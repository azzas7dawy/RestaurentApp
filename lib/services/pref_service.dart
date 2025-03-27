import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

abstract class PrefService {
  static SharedPreferences? prefs;

  static Future<void> init() async {
    try {
    prefs = await SharedPreferences.getInstance();
    log('prefs is initialized');
      
    } catch (e) {
      log('prefs is not initialized : $e');
    }
  }
  static bool get isOnboardingSeen => prefs!.getBool('isOnboardingSeen') ?? false;
  static set isOnboardingSeen(bool value) => prefs!.setBool('isOnboardingSeen', value);

  static bool get isLoggedIn => prefs!.getBool('isLoggedIn') ?? false;
  static set isLoggedIn(bool value) => prefs!.setBool('isLoggedIn', value);
}