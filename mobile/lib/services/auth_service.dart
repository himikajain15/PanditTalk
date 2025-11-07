// lib/services/auth_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/api_service.dart';

class AuthService {
  final ApiService api;
  final storage = const FlutterSecureStorage();
  static const _tokenKey = 'access_token';

  AuthService({ApiService? apiService}) : api = apiService ?? ApiService();

  /// Login with username/email + password
  Future<Map<String, dynamic>> login(String username, String password) async {
    final res = await api.post('/api/auth/login/', {'username': username, 'password': password});
    if (res is Map && res.containsKey('access') && !res.containsKey('error')) {
      await storage.write(key: _tokenKey, value: res['access']);
      return {'ok': true, 'user': res['user'] ?? {}, 'access': res['access']};
    }
    // Handle error response
    String errorMsg = 'Login failed';
    if (res is Map && res.containsKey('error')) {
      errorMsg = res['error'] is List ? res['error'].join(', ') : res['error'].toString();
    } else if (res is String) {
      errorMsg = res;
    }
    return {'ok': false, 'error': errorMsg};
  }

  /// Register new user (returns success map or errors)
  Future<Map<String, dynamic>> register(String username, String email, String password) async {
    final res = await api.post('/api/auth/register/', {
      'username': username,
      'email': email,
      'password': password,
      'password2': password
    });
    if (res is Map && res.containsKey('access') && !res.containsKey('error')) {
      await storage.write(key: _tokenKey, value: res['access']);
      return {'ok': true, 'user': res['user'] ?? res, 'access': res['access']};
    }
    // Handle error response
    String errorMsg = 'Registration failed';
    if (res is Map && res.containsKey('error')) {
      errorMsg = res['error'] is List ? res['error'].join(', ') : res['error'].toString();
    } else if (res is String) {
      errorMsg = res;
    }
    return {'ok': false, 'error': errorMsg};
  }

  /// Send OTP to given phone number (backend should handle SMS)
  Future<Map<String, dynamic>> sendOtp(String phone) async {
    final res = await api.post('/api/auth/send-otp/', {'phone': phone});
    if (res is Map && (res['ok'] == true || res['status'] == 'sent')) {
      return {'ok': true, 'data': res};
    }
    // Handle error response
    String errorMsg = 'Failed to send OTP';
    if (res is Map && res.containsKey('error')) {
      errorMsg = res['error'] is List ? res['error'].join(', ') : res['error'].toString();
    }
    return {'ok': false, 'error': errorMsg};
  }

  /// Verify OTP — backend should return access token + user on success
  Future<Map<String, dynamic>> verifyOtp(String phone, String otp) async {
    final res = await api.post('/api/auth/verify-otp/', {'phone': phone, 'otp': otp});
    if (res is Map && res.containsKey('access') && !res.containsKey('error')) {
      // store token locally
      await storage.write(key: _tokenKey, value: res['access']);
      return {'ok': true, 'user': res['user'] ?? {}, 'access': res['access']};
    }
    // Handle error response
    String errorMsg = 'OTP verification failed';
    if (res is Map && res.containsKey('error')) {
      errorMsg = res['error'] is List ? res['error'].join(', ') : res['error'].toString();
    } else if (res is String) {
      errorMsg = res;
    }
    return {'ok': false, 'error': errorMsg};
  }

  /// Get current user data using stored token
  Future<Map<String, dynamic>> getCurrentUser() async {
    final token = await getToken();
    if (token == null) {
      return {'ok': false, 'error': 'No token found'};
    }
    final res = await api.get('/api/auth/me/', token: token);
    if (res is Map && res.containsKey('id') && !res.containsKey('error')) {
      return {'ok': true, 'user': res};
    }
    return {'ok': false, 'error': res['error'] ?? 'Failed to fetch user'};
  }

  Future<String?> getToken() async => await storage.read(key: _tokenKey);

  Future<void> logout() async {
    await storage.delete(key: _tokenKey);
  }
}
