import 'package:flutter/material.dart';
import '../db/auth_repository.dart';
import '../model/user.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;

  AuthProvider(this.authRepository);

  bool isLoadingLogin = false;
  bool isLoadingLogout = false;
  bool isLoadingRegister = false;
  bool isLoggedIn = false;

  /// LOGIN
  Future<bool> login(User user) async {
    isLoadingLogin = true;
    notifyListeners();

    try {
      await authRepository.login(user);
      isLoggedIn = true;
    } catch (e) {
      isLoggedIn = false;
    }

    isLoadingLogin = false;
    notifyListeners();
    return isLoggedIn;
  }

  /// REGISTER
  Future<bool> register(User user, String name) async {
    isLoadingRegister = true;
    notifyListeners();

    try {
      await authRepository.register(user, name: name);
      isLoadingRegister = false;
      notifyListeners();
      return true;
    } catch (_) {
      isLoadingRegister = false;
      notifyListeners();
      return false;
    }
  }

  /// LOGOUT
  Future<void> logout() async {
    isLoadingLogout = true;
    notifyListeners();

    await authRepository.logout();
    isLoggedIn = false;

    isLoadingLogout = false;
    notifyListeners();
  }
}
