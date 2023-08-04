import 'package:shared_preferences/shared_preferences.dart';

class UserSimplePreferences {
  // ignore: unused_field
  static SharedPreferences? _preferences;

  static const _keyUseremail = "useremail";
  static const _keyUserphone = "userphone";
  static const _keyUsername = "username";
  static const _keyPassword = "password";

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setUserEmail(String email) async {
    await _preferences?.setString(_keyUseremail, email);
  }

  static Future setUserPhone(String phoneNumber) async {
    await _preferences?.setString(_keyUserphone, phoneNumber);
  }

  static Future setUserName(String userName) async {
    await _preferences?.setString(_keyUsername, userName);
  }

  static Future setPassword(String password) async {
    await _preferences?.setString(_keyPassword, password);
  }

  static String? getUserEmail() => _preferences?.getString(_keyUseremail);
  static String? getUserName() => _preferences?.getString(_keyUsername);
  static String? getUserPassword() => _preferences?.getString(_keyPassword);
  static String? getUserPhone() => _preferences?.getString(_keyUserphone);
}
