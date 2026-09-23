import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/partner_models.dart';

class SessionService {
  static const String _keyPartnerSession = 'camsik_partner_session';
  static PartnerUser? _currentUser;

  static PartnerUser? get currentUser => _currentUser;

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyPartnerSession);
    if (raw != null && raw.isNotEmpty) {
      try {
        final Map<String, dynamic> data = jsonDecode(raw);
        _currentUser = PartnerUser.fromJson(data);
      } catch (_) {}
    }
  }

  static Future<void> saveSession(PartnerUser user) async {
    _currentUser = user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPartnerSession, jsonEncode(user.toJson()));
  }

  static Future<void> clearSession() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyPartnerSession);
  }

  static bool get isLoggedIn => _currentUser != null;
}
