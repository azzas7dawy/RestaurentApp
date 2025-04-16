import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class PrefService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      log('SharedPreferences initialized successfully');
    } catch (e) {
      log('Error initializing SharedPreferences: $e');
      throw Exception('Failed to initialize SharedPreferences');
    }
  }

  static bool get isOnboardingSeen {
    _checkInitialized();
    return _prefs!.getBool('isOnboardingSeen') ?? false;
  }

  static Future<void> setOnboardingSeen(bool value) async {
    _checkInitialized();
    await _prefs!.setBool('isOnboardingSeen', value);
  }

  static bool get isLoggedIn {
    _checkInitialized();
    return _prefs!.getBool('isLoggedIn') ?? false;
  }

  static Future<void> setLoggedIn(bool value) async {
    _checkInitialized();
    await _prefs!.setBool('isLoggedIn', value);
  }

  static Future<void> saveUserData({
    required String userId,
    required String name,
    required String email,
    required String phone,
    String? imageUrl,
  }) async {
    _checkInitialized();
    await _prefs!.setString('userId', userId);
    await _prefs!.setString('userName', name);
    await _prefs!.setString('userEmail', email);
    await _prefs!.setString('userPhone', phone);
    if (imageUrl != null) {
      await _prefs!.setString('userImageUrl', imageUrl);
    }
  }

  static Future<void> saveUserImage(String imageUrl) async {
    _checkInitialized();
    await _prefs!.setString('userImageUrl', imageUrl);
  }

  static Map<String, String> get userData {
    _checkInitialized();
    return {
      'userId': _prefs!.getString('userId') ?? '',
      'name': _prefs!.getString('userName') ?? '',
      'email': _prefs!.getString('userEmail') ?? '',
      'phone': _prefs!.getString('userPhone') ?? '',
      'imageUrl': _prefs!.getString('userImageUrl') ?? '',
    };
  }

  static Future<Map<String, dynamic>> getUserData() async {
    _checkInitialized();
    return {
      'userId': _prefs!.getString('userId'),
      'name': _prefs!.getString('userName'),
      'email': _prefs!.getString('userEmail'),
      'phone': _prefs!.getString('userPhone'),
      'imageUrl': _prefs!.getString('userImageUrl'),
    };
  }

  static Future<void> clearUserData() async {
    _checkInitialized();
    await _prefs!.remove('userId');
    await _prefs!.remove('userName');
    await _prefs!.remove('userEmail');
    await _prefs!.remove('userPhone');
    await _prefs!.remove('userImageUrl');
    await _prefs!.remove('isLoggedIn');
  }

  static void _checkInitialized() {
    if (_prefs == null) {
      throw Exception(
          'SharedPreferences not initialized. Call PrefService.init() first');
    }
  }
}
