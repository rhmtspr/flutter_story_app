import 'package:shared_preferences/shared_preferences.dart';
import 'package:declarative_navigation/model/user.dart';
import '../services/api_service.dart';

class AuthRepository {
  final ApiService apiService;

  AuthRepository(this.apiService);

  final String stateKey = 'state';
  final String tokenKey = 'token';
  final String userKey = 'user';

  /// =========================
  /// REGISTER
  /// =========================
  Future<bool> register(User user) async {
    await apiService.register(
      name: user.name!,
      email: user.email!,
      password: user.password!,
    );
    return true;
  }

  /// =========================
  /// LOGIN
  /// =========================
  Future<bool> login(User user) async {
    final result = await apiService.login(
      email: user.email!,
      password: user.password!,
    );

    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(stateKey, true);
    await prefs.setString(tokenKey, result['token']);
    await prefs.setString(userKey, user.toJson());

    return true;
  }

  /// =========================
  /// LOGOUT
  /// =========================
  Future<bool> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    return true;
  }

  /// =========================
  /// CHECK LOGIN
  /// =========================
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(stateKey) ?? false;
  }

  /// =========================
  /// GET TOKEN
  /// =========================
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  /// =========================
  /// GET USER
  /// =========================
  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(userKey);
    if (json == null) return null;
    return User.fromJson(json);
  }
}
