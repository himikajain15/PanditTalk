import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  final AuthService auth = AuthService();
  UserModel? user;
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  Future<void> tryAutoLogin() async {
    try {
      final token = await auth.getToken();
      if (token != null && token.isNotEmpty) {
        // Try to fetch user data to verify token is valid
        final userRes = await auth.getCurrentUser();
        if (userRes['ok'] == true) {
          user = UserModel.fromJson(userRes['user']);
          _isAuthenticated = true;
        } else {
          // Token invalid, clear it
          await auth.logout();
          _isAuthenticated = false;
          user = null;
        }
      } else {
        _isAuthenticated = false;
        user = null;
      }
    } catch (e) {
      _isAuthenticated = false;
      user = null;
    }
    notifyListeners();
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    final res = await auth.login(username, password);
    if (res['ok'] == true) {
      final u = res['user'];
      if (u != null) {
        user = UserModel.fromJson(u);
      } else {
        // Fallback: fetch user data
        final userRes = await auth.getCurrentUser();
        if (userRes['ok'] == true) {
          user = UserModel.fromJson(userRes['user']);
        }
      }
      _isAuthenticated = true;
      notifyListeners();
    }
    return res;
  }

  Future<Map<String, dynamic>> register(String username, String email, String password) async {
    final res = await auth.register(username, email, password);
    if (res['ok'] == true) {
      final u = res['user'];
      if (u != null) {
        user = UserModel.fromJson(u);
      } else {
        // Fallback: fetch user data
        final userRes = await auth.getCurrentUser();
        if (userRes['ok'] == true) {
          user = UserModel.fromJson(userRes['user']);
        }
      }
      _isAuthenticated = true;
      notifyListeners();
    }
    return res;
  }

  Future<void> logout() async {
    await auth.logout();
    user = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  // Method to update user after OTP verification
  Future<void> updateUserAfterOtp() async {
    final userRes = await auth.getCurrentUser();
    if (userRes['ok'] == true) {
      user = UserModel.fromJson(userRes['user']);
      _isAuthenticated = true;
      notifyListeners();
    }
  }
}
