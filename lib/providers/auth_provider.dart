import 'package:declarative_navigation/data/auth_repository.dart';
import 'package:flutter/material.dart';

enum AuthStatus { loading, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repo;

  AuthProvider(this._repo);

  AuthStatus _status = AuthStatus.loading;
  AuthStatus get status => _status;

  /// Check session on app start
  Future<void> checkLogin() async {
    _status = AuthStatus.loading;
    notifyListeners();

    final loggedIn = await _repo.isLoggedIn();
    _status = loggedIn ? AuthStatus.authenticated : AuthStatus.unauthenticated;

    notifyListeners();
  }

  /// Login
  Future<void> login(String email, String password) async {
    _status = AuthStatus.loading;
    notifyListeners();

    try {
      await _repo.login(email, password);
      _status = AuthStatus.authenticated;
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      rethrow;
    }

    notifyListeners();
  }

  /// Logout
  Future<void> logout() async {
    await _repo.logout();
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}
