import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/admin_models.dart';

class SessionService {
  static const String _userKey = 'camsik_admin_user_session';
  static const String _isLoggedInKey = 'camsik_admin_logged_in';

  static Future<void> saveUser(AdminUser user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
    await prefs.setBool(_isLoggedInKey, true);
  }

  static Future<AdminUser?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_userKey);
    if (raw == null) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return AdminUser.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.setBool(_isLoggedInKey, false);
  }
}
