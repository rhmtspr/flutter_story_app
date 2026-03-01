import 'package:shared_preferences/shared_preferences.dart';
import 'auth_api.dart';

class AuthRepository {
  final AuthApi _api = AuthApi();

  static const _tokenKey = "token";
  static const _nameKey = "name";

  /// LOGIN
  Future<void> login(String email, String password) async {
    final result = await _api.login(email, password);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, result["token"]);
    await prefs.setString(_nameKey, result["name"]);
  }

  /// CHECK SESSION
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey) != null;
  }

  /// GET TOKEN
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// LOGOUT
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_nameKey);
  }
}
