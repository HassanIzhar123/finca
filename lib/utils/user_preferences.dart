import 'dart:convert';

import 'package:finca/models/signup/auth_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static final UserPreferences _instance = UserPreferences._internal();
  late SharedPreferences _prefs;

  factory UserPreferences() {
    return _instance;
  }

  UserPreferences._internal();

  Future<void> initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void setUserInfo(AuthModel authModel) async {
    String jsonString = jsonEncode(authModel.toJson());
    await _prefs.setString('user_info', jsonString);
  }

  AuthModel getUserInfo() {
    String jsonString = _prefs.getString('user_info') ?? '{}';
    Map<String, dynamic> userMap = jsonDecode(jsonString);
    return AuthModel.fromJson(userMap);
  }
}
