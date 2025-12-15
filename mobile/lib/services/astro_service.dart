import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';

class AstroService {
  static String? _token;
  static DateTime? _tokenExpiry;

  // Get and cache Prokerala API token
  static Future<String?> _getToken({bool forceRefresh = false}) async {
    if (!forceRefresh && _token != null && _tokenExpiry != null && DateTime.now().isBefore(_tokenExpiry!)) {
      return _token;
    }
    final resp = await http.post(
      Uri.parse(Constants.prokeralaTokenUrl),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'grant_type': 'client_credentials',
        'client_id': Constants.prokeralaClientId,
        'client_secret': Constants.prokeralaClientSecret,
      },
    );
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      _token = data['access_token'];
      _tokenExpiry = DateTime.now().add(Duration(seconds: data['expires_in'] - 60));
      return _token;
    } else {
      debugPrint('❌ Prokerala token error: ${resp.body}');
      _token = null;
      return null;
    }
  }

  static Future<Map<String, String>> _authHeaders() async {
    final token = await _getToken();
    if (token == null) return {'Error': 'No token'};
    return {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'};
  }

  // Map Flutter form inputs to Prokerala payload
  static Map<String, dynamic> _mapKundliPayload(Map<String, dynamic> input) {
    // Prokerala's API needs:
    // date: yyyy-mm-dd, time: HH:MM, timezone: +05:30, coordinates: (optional)
    // place (string) is not directly supported, but give empty if not available
    return {
      'ayanamsa': 1,
      'coordinates': {'latitude': 0, 'longitude': 0},
      'datetime': '${input['date']}T${input['time']}:00${input['timezone']}',
      // 'place': input['place'] ?? '',
    };
  }

  static Future<Map<String, dynamic>> fetchKundli(Map<String, dynamic> payload) async {
    final date = payload['date'] as String? ?? '';
    final time = payload['time'] as String? ?? '';
    final timezone = payload['timezone'] as String? ?? '+05:30';
    final lat = payload['lat'] as double?;
    final lon = payload['lon'] as double?;
    if (date.isEmpty || time.isEmpty || lat == null || lon == null) {
      return {'error': 'Missing required birth details or location.'};
    }
    final datetime = '${date}T${time}:00${timezone}';
    
    // Prokerala uses GET with query parameters, not POST
    final token = await _getToken();
    if (token == null) return {'error': 'Token not available'};
    
    final url = Uri.parse(Constants.prokeralaKundliApiUrl).replace(queryParameters: {
      'ayanamsa': '1',
      'coordinates': '$lat,$lon', // Format: "lat,lon"
      'datetime': datetime,
    });
    
    debugPrint('🔍 Prokerala Kundli URL: $url');
    
    final headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };
    
    http.Response resp = await http.get(url, headers: headers);
    debugPrint('📥 Prokerala Response: ${resp.statusCode} - ${resp.body.substring(0, resp.body.length > 200 ? 200 : resp.body.length)}');
    if (resp.statusCode == 401) {
      await _getToken(forceRefresh: true);
      final token2 = await _getToken();
      if (token2 == null) return {'error': 'Token refresh failed'};
      final headers2 = {'Authorization': 'Bearer $token2', 'Accept': 'application/json'};
      resp = await http.get(url, headers: headers2);
    }
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      return {'raw': data, ...data};
    } else {
      String msg = resp.body.isNotEmpty ? resp.body : 'Prokerala API error';
      return {'error': 'Prokerala API error: $msg', 'status': resp.statusCode, 'body': resp.body};
    }
  }

  // Compatibility payload mapping
  static Map<String, dynamic> _mapPartner(Map<String, dynamic> partner) => {
    'ayanamsa': 1,
    'coordinates': {'latitude': 0, 'longitude': 0},
    'datetime': '${partner['date']}T${partner['time']}:00${partner['timezone']}',
  };

  static Future<Map<String, dynamic>> fetchCompatibility(Map<String, dynamic> payload) async {
    final url = Uri.parse(Constants.prokeralaMatchApiUrl);
    final headers = await _authHeaders();
    if (headers.containsKey('Error')) return {'error': 'Token not available'};
    final prokeralaPayload = {
      'ayanamsa': 1,
      'partner': _mapPartner(payload['partner1']),
      'girl': _mapPartner(payload['partner2']),
    };
    http.Response resp = await http.post(url, headers: headers, body: jsonEncode(prokeralaPayload));
    // If token expired, retry once
    if (resp.statusCode == 401) {
      await _getToken(forceRefresh: true);
      final headers2 = await _authHeaders();
      resp = await http.post(url, headers: headers2, body: jsonEncode(prokeralaPayload));
    }
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      return {'raw': data, ...data};
    } else {
      return {'error': 'Prokerala API error', 'status': resp.statusCode, 'body': resp.body};
    }
  }

  static Future<Map<String, dynamic>> fetchDailyHoroscope(String sign) async {
    // You can improve this: Prokerala has a dedicated endpoint for zodiac horoscopes too, but Aztro fallback is in place
    return {'error': 'Not implemented'};
  }

  /// Geocode a place string, returns {lat, lon} as double or null.
  static Future<Map<String, double>?> geocodePlace(String place) async {
    final uri = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(place)}&format=json&limit=1');
    final resp = await http.get(uri, headers: {
      'User-Agent': 'PanditTalkApp (Flutter; contact@pandittalk.com)'
    });
    if (resp.statusCode == 200) {
      final arr = jsonDecode(resp.body);
      if (arr is List && arr.isNotEmpty) {
        final item = arr[0];
        final lat = double.tryParse(item['lat'] ?? '');
        final lon = double.tryParse(item['lon'] ?? '');
        if (lat != null && lon != null) {
          return {'lat': lat, 'lon': lon};
        }
      }
    }
    return null;
  }
}

