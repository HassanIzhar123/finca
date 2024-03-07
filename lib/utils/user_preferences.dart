import 'dart:convert';

import 'package:finca/models/signup/auth_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class UserPreferences {
//   static final UserPreferences _instance = UserPreferences._internal();
//   late SharedPreferences _prefs;
//
//   factory UserPreferences() {
//     return _instance;
//   }
//
//   UserPreferences._internal();
//
//   Future<void> initPrefs() async {
//     _prefs = await SharedPreferences.getInstance();
//   }
//
//   void setUserInfo(AuthModel authModel) async {
//     String jsonString = jsonEncode(authModel.toJson());
//     await _prefs.setString('user_info', jsonString);
//   }
//
//   AuthModel getUserInfo() {
//     String jsonString = _prefs.getString('user_info') ?? '{}';
//     Map<String, dynamic> userMap = jsonDecode(jsonString);
//     return AuthModel.fromJson(userMap);
//   }
// }

// class UserPreferences {
//   static Future<SharedPreferences> get _instance async =>
//       _prefsInstance ??= await SharedPreferences.getInstance();
//   static late SharedPreferences _prefsInstance;
//
//   static Future<SharedPreferences> initPrefs() async {
//     _prefsInstance = await _instance;
//     return _prefsInstance;
//   }
//
//   static String getString(String key, [String? defValue]) {
//     return _prefsInstance.getString(key) ?? defValue ?? "";
//   }
//
//   static Future<bool> setString(String key, String value) async {
//     var prefs = await _instance;
//     return prefs.setString(key, value);
//   }
//
//   void setUserInfo(AuthModel authModel) async {
//     var prefs = await _instance;
//     String jsonString = jsonEncode(authModel.toJson());
//     await prefs.setString('user_info', jsonString);
//   }
//
//   Future<AuthModel> getUserInfo() async {
//     var prefs = await _instance;
//     String jsonString = prefs.getString('user_info') ?? '{}';
//     Map<String, dynamic> userMap = jsonDecode(jsonString);
//     return await AuthModel.fromJson(userMap);
//   }
// }

class UserPreferences {
  static Future<SharedPreferences> get _instance async => _prefsInstance ??= await SharedPreferences.getInstance();
  static SharedPreferences? _prefsInstance;

  // call this method from iniState() function of mainApp().
  static Future<SharedPreferences> init() async {
    _prefsInstance = await _instance;
    return _prefsInstance ??= await SharedPreferences.getInstance();
  }

  static String getString(String key, [String? defValue]) {
    return _prefsInstance?.getString(key) ?? defValue ?? "";
  }

  static Future<bool> setString(String key, String value) async {
    var prefs = await _instance;
    return prefs.setString(key, value) ?? Future.value(false);
  }

  void setUserInfo(AuthModel authModel) async {
    var prefs = await _instance;
    String jsonString = jsonEncode(authModel.toJson());
    await prefs.setString('user_info', jsonString);
  }

  AuthModel? getUserInfo() {
    String jsonString = _prefsInstance?.getString('user_info') ?? '{}';
    Map<String, dynamic> userMap = jsonDecode(jsonString);
    if (userMap.isNotEmpty) {
      return AuthModel.fromJson(userMap);
    }
    return null;
  }

  String getUid() {
    return _prefsInstance?.getString('user_info') ?? '';
  }
}
