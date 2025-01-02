import 'package:shared_preferences/shared_preferences.dart';

class AuthHelper {
  AuthHelper._();

  static Future<void> setAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  static Future<void> setRefreshToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('refresh_token', token);
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refresh_token');
  }

  static Future<void> setAccessTokenKB(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token_kb', token);
  }

  static Future<String?> getAccessTokenKB() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token_kb');
  }

  static Future<void> setRefreshTokenKB(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('refresh_token_kb', token);
  }

  static Future<String?> getRefreshTokenKB() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refresh_token_kb');
  }

  static Future<void> setLoggedInStatus(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', isLoggedIn);
  }

  static Future<bool?> getLoggedInStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in');
  }

  static Future<void> setName(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
  }

  static Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }

  static Future<void> setEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    await prefs.remove('access_token_kb');
    await prefs.remove('refresh_token_kb');
    await prefs.remove('username');
    await prefs.remove('email');
    await prefs.setBool('is_logged_in', false);
  }
}