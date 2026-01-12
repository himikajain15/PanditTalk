import 'dart:convert';
import 'package:flutter/foundation.dart';
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
          'error': errorData['error'] ?? 'Verification failed',
          'verification_pending': errorData['verification_pending'] ?? false,
        };
      }
    } catch (e) {
      print('❌ Error during OTP verification: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  // Registration
  static Future<Map<String, dynamic>> registerPandit(Map<String, dynamic> formData) async {
    print('📝 Registering pandit...');
    try {
      final response = await http.post(
        Uri.parse(AppConstants.baseUrl + AppConstants.registerPanditEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(formData),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout - registration may take longer');
        },
      );
      
      print('✅ Registration Response status: ${response.statusCode}');
      print('📄 Registration Response body: ${response.body}');
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'message': data['message'] ?? 'Registration successful!',
          'data': data,
        };
      } else {
        final errorData = json.decode(response.body);
        print('❌ Registration failed: ${errorData['error'] ?? 'Unknown error'}');
        return {
          'success': false,
          'error': errorData['error'] ?? errorData['message'] ?? 'Registration failed',
        };
      }
    } catch (e) {
      print('❌ Error during registration: $e');
      String errorMsg = e.toString();
      if (errorMsg.contains('Failed host lookup') || errorMsg.contains('Connection refused')) {
        errorMsg = 'Cannot connect to backend server. Make sure the backend is running.';
      }
      return {'success': false, 'error': errorMsg};
    }
  }

  // Dashboard
  static Future<Map<String, dynamic>> getDashboard() async {
    // Demo data for development preview
    if (kDebugMode && AppConstants.useDemoData) {
      return {
        'success': true,
        'data': {
          'today_earnings': 1250.0,
          'today_consultations': 4,
          'pending_requests': 2,
          'total_earnings': 84520.0,
          'total_consultations': 320,
          'average_rating': 4.7,
          'wallet_balance': 5230.0,
          'availability_status': AppConstants.availabilityAvailable,
        },
      };
    }

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
    if (kDebugMode && AppConstants.useDemoData) {
      final now = DateTime.now();
      final iso = now.toIso8601String();
      final demo = [
        {
          'id': 1,
          'user': 101,
          'pandit': 201,
          'user_name': 'Rohit Sharma',
          'user_phone': '+91-9876543210',
          'user_profile_pic': null,
          'pandit_name': 'Demo Pandit',
          'pandit_phone': '+91-9000000000',
          'pandit_profile_pic': null,
          'service_type': 'chat',
          'duration': 15,
          'user_query': 'Career growth and onsite opportunity in next 1-2 years.',
          'birth_details': {
            'date_of_birth': '1992-05-14',
            'time_of_birth': '09:30',
            'place_of_birth': 'Mumbai, India',
          },
          'amount': 499.0,
          'commission_percentage': 25.0,
          'commission_amount': 124.75,
          'pandit_earnings': 374.25,
          'payment_status': 'paid',
          'status': 'pending',
          'created_at': iso,
          'accepted_at': null,
          'started_at': null,
          'ended_at': null,
          'user_rating': null,
          'user_review': '',
          'pandit_notes': '',
          'recommended_remedies': '',
        },
      ];
      return {'success': true, 'data': demo};
    }

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
    if (kDebugMode && AppConstants.useDemoData) {
      final now = DateTime.now();
      final todayIso = now.toIso8601String();
      final tomorrowIso =
          now.add(const Duration(days: 1)).toIso8601String();
      final demo = [
        {
          'id': 2,
          'user': 102,
          'pandit': 201,
          'user_name': 'Neha Verma',
          'user_phone': '+91-9876500000',
          'user_profile_pic': null,
          'pandit_name': 'Demo Pandit',
          'pandit_phone': '+91-9000000000',
          'pandit_profile_pic': null,
          'service_type': 'call',
          'duration': 20,
          'user_query': 'Marriage timing and partner nature.',
          'birth_details': {
            'date_of_birth': '1995-11-02',
            'time_of_birth': '21:15',
            'place_of_birth': 'Delhi, India',
          },
          'amount': 799.0,
          'commission_percentage': 25.0,
          'commission_amount': 199.75,
          'pandit_earnings': 599.25,
          'payment_status': 'paid',
          'status': 'accepted',
          'created_at': todayIso,
          'accepted_at': todayIso,
          'started_at': null,
          'ended_at': null,
          'user_rating': null,
          'user_review': '',
          'pandit_notes': 'User is anxious, focus on reassurance.',
          'recommended_remedies': '',
        },
        {
          'id': 3,
          'user': 103,
          'pandit': 201,
          'user_name': 'Amit Singh',
          'user_phone': '+91-9988776655',
          'user_profile_pic': null,
          'pandit_name': 'Demo Pandit',
          'pandit_phone': '+91-9000000000',
          'pandit_profile_pic': null,
          'service_type': 'video',
          'duration': 30,
          'user_query': 'Business expansion to a new city.',
          'birth_details': {
            'date_of_birth': '1988-03-10',
            'time_of_birth': '14:45',
            'place_of_birth': 'Jaipur, India',
          },
          'amount': 1299.0,
          'commission_percentage': 25.0,
          'commission_amount': 324.75,
          'pandit_earnings': 974.25,
          'payment_status': 'paid',
          'status': 'in_progress',
          'created_at': tomorrowIso,
          'accepted_at': todayIso,
          'started_at': null,
          'ended_at': null,
          'user_rating': null,
          'user_review': '',
          'pandit_notes': '',
          'recommended_remedies': '',
        },
      ];
      return {'success': true, 'data': demo};
    }

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

  static Future<Map<String, dynamic>> updateConsultationNotes(
      int id, String panditNotes, String recommendedRemedies) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse(
            AppConstants.baseUrl + '/pandit/consultations/$id/update_notes/'),
        headers: headers,
        body: json.encode({
          'pandit_notes': panditNotes,
          'recommended_remedies': recommendedRemedies,
        }),
      );
      return {
        'success': response.statusCode == 200,
        'data': response.body.isNotEmpty ? json.decode(response.body) : {},
      };
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> generateAiRemedies(
      int id, {String? notes}) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse(
            AppConstants.baseUrl + '/pandit/consultations/$id/ai_remedies/'),
        headers: headers,
        body: json.encode({
          if (notes != null && notes.isNotEmpty) 'notes': notes,
        }),
      );
      return {
        'success': response.statusCode == 200,
        'data': response.body.isNotEmpty ? json.decode(response.body) : {},
      };
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // Earnings
  static Future<Map<String, dynamic>> getEarnings(String period) async {
    if (kDebugMode && AppConstants.useDemoData) {
      String label;
      switch (period) {
        case 'day':
          label = 'Today';
          break;
        case 'week':
          label = 'This Week';
          break;
        default:
          label = 'This Month';
      }
      final demo = {
        'period': label,
        'total_amount': 24500.0,
        'consultations_count': 42,
        'chat_earnings': 8500.0,
        'call_earnings': 11000.0,
        'video_earnings': 5000.0,
      };
      return {'success': true, 'data': demo};
    }

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

  // Block/Unblock Users
  static Future<Map<String, dynamic>> blockUser(int userId, {String? reason}) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/pandit/block-user/$userId/'),
        headers: headers,
        body: json.encode({'reason': reason ?? ''}),
      );
      return {
        'success': response.statusCode == 200,
        'data': response.body.isNotEmpty ? json.decode(response.body) : {},
      };
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> unblockUser(int userId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('${AppConstants.baseUrl}/pandit/block-user/$userId/'),
        headers: headers,
      );
      return {
        'success': response.statusCode == 200,
        'data': response.body.isNotEmpty ? json.decode(response.body) : {},
      };
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // VIP Users
  static Future<Map<String, dynamic>> markAsVIP(int userId, {String? notes}) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/pandit/vip-user/$userId/'),
        headers: headers,
        body: json.encode({'notes': notes ?? ''}),
      );
      return {
        'success': response.statusCode == 200,
        'data': response.body.isNotEmpty ? json.decode(response.body) : {},
      };
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> removeVIP(int userId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('${AppConstants.baseUrl}/pandit/vip-user/$userId/'),
        headers: headers,
      );
      return {
        'success': response.statusCode == 200,
        'data': response.body.isNotEmpty ? json.decode(response.body) : {},
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

