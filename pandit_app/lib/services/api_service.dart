import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/constants.dart';

class ApiService {
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.keyToken);
  }

  static Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Authentication
  static Future<Map<String, dynamic>> sendOtp(String phone) async {
    final url = AppConstants.baseUrl + AppConstants.sendOtpEndpoint;
    print('🌐 Sending OTP to: $url');
    print('📱 Phone: $phone');
    
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({'phone': phone}),
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception('Request timeout - is the backend server running at ${AppConstants.baseUrl}?');
        },
      );
      
      print('✅ Response status: ${response.statusCode}');
      print('📄 Response body: ${response.body}');
      
      return {
        'success': response.statusCode == 200,
        'data': response.body.isNotEmpty ? json.decode(response.body) : {},
        'status': response.statusCode,
      };
    } catch (e) {
      print('❌ Error: $e');
      String errorMsg = e.toString();
      if (errorMsg.contains('Failed host lookup') || errorMsg.contains('Connection refused') || errorMsg.contains('Software caused connection abort')) {
        errorMsg = 'Cannot connect to backend server. Make sure:\n1. Backend is running: python manage.py runserver 0.0.0.0:8000\n2. Phone and computer are on same WiFi\n3. Windows Firewall allows Python on port 8000';
      }
      return {'success': false, 'error': errorMsg};
    }
  }

  static Future<Map<String, dynamic>> verifyOtp(
      String phone, String otp) async {
    print('🔐 Verifying OTP for: $phone');
    try {
      final response = await http.post(
        Uri.parse(AppConstants.baseUrl + AppConstants.verifyOtpEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'phone': phone, 'otp': otp}),
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception('Request timeout');
        },
      );
      
      print('✅ Verify OTP Response status: ${response.statusCode}');
      print('📄 Verify OTP Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Save token and user data (backend returns 'access' not 'token')
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.keyToken, data['access'] ?? '');
        await prefs.setInt(AppConstants.keyUserId, data['user']['id'] ?? 0);
        await prefs.setString(
            AppConstants.keyUsername, data['user']['username'] ?? '');
        await prefs.setString(AppConstants.keyPhone, data['user']['phone'] ?? '');
        await prefs.setBool(
            AppConstants.keyIsPandit, data['user']['is_pandit'] ?? false);
        
        print('✅ Token and user data saved successfully');
        return {
          'success': true,
          'data': data,
        };
      } else {
        final errorData = json.decode(response.body);
        print('❌ Verification failed: ${errorData['error'] ?? 'Unknown error'}');
        return {
          'success': false,
          'error': errorData['error'] ?? 'Verification failed'
        };
      }
    } catch (e) {
      print('❌ Error during OTP verification: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  // Dashboard
  static Future<Map<String, dynamic>> getDashboard() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse(AppConstants.baseUrl + AppConstants.dashboardEndpoint),
        headers: headers,
      );
      return {
        'success': response.statusCode == 200,
        'data': json.decode(response.body),
      };
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // Profile
  static Future<Map<String, dynamic>> getProfile() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse(AppConstants.baseUrl + AppConstants.profileEndpoint),
        headers: headers,
      );
      return {
        'success': response.statusCode == 200,
        'data': json.decode(response.body),
      };
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> updateAvailability(
      String status) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse(
            AppConstants.baseUrl + AppConstants.updateAvailabilityEndpoint),
        headers: headers,
        body: json.encode({'availability_status': status}),
      );
      return {
        'success': response.statusCode == 200,
        'data': json.decode(response.body),
      };
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // Consultation Requests
  static Future<Map<String, dynamic>> getPendingRequests() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse(AppConstants.baseUrl + AppConstants.pendingRequestsEndpoint),
        headers: headers,
      );
      return {
        'success': response.statusCode == 200,
        'data': json.decode(response.body),
      };
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> getActiveConsultations() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse(
            AppConstants.baseUrl + AppConstants.activeConsultationsEndpoint),
        headers: headers,
      );
      return {
        'success': response.statusCode == 200,
        'data': json.decode(response.body),
      };
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> acceptRequest(int id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse(AppConstants.baseUrl + AppConstants.acceptRequest(id)),
        headers: headers,
      );
      return {
        'success': response.statusCode == 200,
        'data': json.decode(response.body),
      };
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> rejectRequest(int id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse(AppConstants.baseUrl + AppConstants.rejectRequest(id)),
        headers: headers,
      );
      return {
        'success': response.statusCode == 200,
        'data': json.decode(response.body),
      };
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> completeConsultation(int id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse(AppConstants.baseUrl + AppConstants.completeRequest(id)),
        headers: headers,
      );
      return {
        'success': response.statusCode == 200,
        'data': json.decode(response.body),
      };
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // Earnings
  static Future<Map<String, dynamic>> getEarnings(String period) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse(
            '${AppConstants.baseUrl}${AppConstants.earningsEndpoint}?period=$period'),
        headers: headers,
      );
      return {
        'success': response.statusCode == 200,
        'data': json.decode(response.body),
      };
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // Payouts
  static Future<Map<String, dynamic>> requestPayout(double amount) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse(AppConstants.baseUrl + AppConstants.payoutsEndpoint),
        headers: headers,
        body: json.encode({'amount': amount}),
      );
      return {
        'success': response.statusCode == 201,
        'data': json.decode(response.body),
      };
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

