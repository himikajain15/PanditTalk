import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:io';

class ApiService {
  // Auto-detect base URL based on platform
  // For Android emulator use 10.0.2.2, for iOS simulator use localhost, for web use localhost
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8000';
    } else if (Platform.isAndroid) {
      // Android emulator uses special IP to access host machine
      return 'http://10.0.2.2:8000';
    } else {
      // iOS simulator or physical device
      return 'http://localhost:8000'; // Change to your actual server IP for physical devices
    }
  }

  String get _baseUrl => baseUrl;

  Future<dynamic> get(String endpoint, {String? token}) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    try {
      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      final response = await http.get(url, headers: headers);
      return _handleResponse(response);
    } catch (e) {
      debugPrint('❌ GET $endpoint error: $e');
      return {'error': e.toString()};
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body, {String? token}) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      debugPrint('📤 POST ${url.toString()}');
      final response = await http.post(url, headers: headers, body: jsonEncode(body)).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timeout - is the backend server running on $_baseUrl?');
        },
      );
      return _handleResponse(response);
    } catch (e) {
      debugPrint('❌ POST $endpoint error: $e');
      String errorMsg = e.toString();
      if (errorMsg.contains('Failed host lookup') || errorMsg.contains('Connection refused')) {
        errorMsg = 'Cannot connect to backend server. Make sure Django server is running on $_baseUrl';
      }
      return {'error': errorMsg};
    }
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> body, {String? token}) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    try {
      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      final response = await http.put(url, headers: headers, body: jsonEncode(body));
      return _handleResponse(response);
    } catch (e) {
      debugPrint('❌ PUT $endpoint error: $e');
      return {'error': e.toString()};
    }
  }

  Future<dynamic> delete(String endpoint, {String? token}) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    try {
      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      final response = await http.delete(url, headers: headers);
      return _handleResponse(response);
    } catch (e) {
      debugPrint('❌ DELETE $endpoint error: $e');
      return {'error': e.toString()};
    }
  }

  dynamic _handleResponse(http.Response response) {
    final status = response.statusCode;
    debugPrint('➡️ ${response.request?.url} [${response.statusCode}]');

    dynamic body;
    try {
      body = response.body.isNotEmpty ? jsonDecode(response.body) : null;
    } catch (e) {
      debugPrint('Failed to parse JSON: ${response.body}');
      body = {'error': 'Invalid JSON response'};
    }

    if (status >= 200 && status < 300) {
      return body;
    } else {
      debugPrint('API Error [${response.statusCode}]: ${response.body}');
      // Extract error message from response
      String errorMsg = 'Request failed';
      if (body is Map && body.containsKey('error')) {
        if (body['error'] is List) {
          errorMsg = body['error'].join(', ');
        } else {
          errorMsg = body['error'].toString();
        }
      } else if (body is Map && body.containsKey('detail')) {
        errorMsg = body['detail'].toString();
      }
      return {
        'error': errorMsg,
        'status': status,
        'body': body,
      };
    }
  }
}
