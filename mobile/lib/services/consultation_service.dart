import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pandit.dart';
import 'api_service.dart';

class ConsultationService {
  static String get baseUrl => '${ApiService.baseUrl}/api';

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Get available pandits
  static Future<List<Pandit>> getAvailablePandits({
    String? availability,
    String? specialization,
    String? search,
  }) async {
    try {
      final headers = await _getHeaders();
      var url = '$baseUrl/user/pandits/';
      
      List<String> queryParams = [];
      if (availability != null) queryParams.add('availability=$availability');
      if (specialization != null) queryParams.add('specialization=$specialization');
      if (search != null) queryParams.add('search=$search');
      
      if (queryParams.isNotEmpty) {
        url += '?${queryParams.join('&')}';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Pandit.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error getting pandits: $e');
      return [];
    }
  }

  // Get pandit details
  static Future<Map<String, dynamic>?> getPanditDetails(int panditId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/user/pandits/$panditId/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      print('Error getting pandit details: $e');
      return null;
    }
  }

  // Create consultation request
  static Future<Map<String, dynamic>> createConsultationRequest({
    required int panditId,
    required String serviceType,
    required int duration,
    required double amount,
    String? query,
    Map<String, dynamic>? birthDetails,
  }) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/user/consultations/'),
        headers: headers,
        body: json.encode({
          'pandit': panditId,
          'service_type': serviceType,
          'duration': duration,
          'amount': amount,
          'user_query': query ?? '',
          'birth_details': birthDetails,
        }),
      );

      return {
        'success': response.statusCode == 201,
        'data': json.decode(response.body),
      };
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // Get my consultations
  static Future<List<dynamic>> getMyConsultations() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/user/consultations/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return [];
    } catch (e) {
      print('Error getting consultations: $e');
      return [];
    }
  }

  // Rate consultation
  static Future<Map<String, dynamic>> rateConsultation({
    required int consultationId,
    required int rating,
    String? review,
  }) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/user/consultations/$consultationId/rate/'),
        headers: headers,
        body: json.encode({
          'rating': rating,
          'review': review ?? '',
        }),
      );

      return {
        'success': response.statusCode == 200,
        'data': json.decode(response.body),
      };
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }
}

