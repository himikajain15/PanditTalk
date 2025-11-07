import 'dart:convert';
import 'package:http/http.dart' as http;

/// KundaliService connects to the free Aztro API
/// to fetch daily horoscope (kundali) information
/// based on the user's zodiac sign.
class KundaliService {
  /// Base URL for the Aztro API
  static const String _baseUrl = 'https://aztro.sameerkumar.website/';

  /// Fetches kundali (horoscope) data for the given zodiac sign.
  ///
  /// [sign] should be one of:
  /// aries, taurus, gemini, cancer, leo, virgo,
  /// libra, scorpio, sagittarius, capricorn, aquarius, pisces
  ///
  /// Returns a map containing the horoscope data.
  static Future<Map<String, dynamic>?> getKundali(String sign) async {
    try {
      final Uri url = Uri.parse('$_baseUrl?sign=$sign&day=today');

      // Aztro API uses POST requests even for fetching data
      final response = await http.post(url);

      if (response.statusCode == 200) {
        // Parse JSON response into a Map
        final data = json.decode(response.body);
        return data;
      } else {
        print('Failed to fetch kundali. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching kundali: $e');
      return null;
    }
  }
}
