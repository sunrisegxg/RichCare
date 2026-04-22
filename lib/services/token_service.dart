import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  static const _tokenKey = "token";
  static const _userIdKey = "userId";

  /// 🔹 Token
  static Future<void> save(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> get() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// 🔹 UserId (idFE)
  static Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  /// 🔹 Clear
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey); // 👈 nhớ clear luôn
  }

  static Future<bool> isLoggedIn() async {
    final token = await get();
    return token != null;
  }
}
