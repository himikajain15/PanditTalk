import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/pandit.dart';
import '../models/booking.dart';

class BookingProvider extends ChangeNotifier {
  final ApiService api = ApiService();

  /// Fetch all pandits from API.
  /// Handles both list and paginated responses.
  Future<List<Pandit>> fetchPandits() async {
    try {
      final res = await api.get('/api/core/pandits/');
      if (res is List) {
        // Simple list of pandits
        return res.map((e) => Pandit.fromJson(e)).toList();
      } else if (res is Map && res.containsKey('results')) {
        // Paginated response from Django REST Framework
        return (res['results'] as List)
            .map((e) => Pandit.fromJson(e))
            .toList();
      } else if (res is Map && res.values.isNotEmpty) {
        // Fallback for dictionary-style responses
        return res.values.map((e) => Pandit.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint('Error fetching pandits: $e');
    }
    return [];
  }

  /// Sync Pandits from Google Sheets (optional - can be called manually)
  /// Returns sync result with count of synced/updated pandits
  Future<Map<String, dynamic>> syncPanditsFromSheets() async {
    try {
      final res = await api.post('/api/core/pandits/sync-sheets/', {});
      if (res is Map) {
        return Map<String, dynamic>.from(res);
      }
    } catch (e) {
      debugPrint('Error syncing pandits from sheets: $e');
    }
    return {'error': 'Failed to sync pandits from Google Sheets'};
  }

  /// Fetch all bookings for a user (requires auth token).
  Future<List<Booking>> fetchBookings(String? token) async {
    try {
      final res = await api.get('/api/core/bookings/list/', token: token);
      if (res is List) {
        return res.map((e) => Booking.fromJson(e)).toList();
      } else if (res is Map && res.containsKey('results')) {
        return (res['results'] as List)
            .map((e) => Booking.fromJson(e))
            .toList();
      }
    } catch (e) {
      debugPrint('Error fetching bookings: $e');
    }
    return [];
  }

  /// Create a new booking for a Pandit.
  /// Returns the response from the API, which should include booking details.
  Future<Map<String, dynamic>> createBooking(
    int panditId,
    String scheduledAtIso,
    int durationMinutes,
    String? token,
  ) async {
    try {
      final body = {
        'pandit_id': panditId,
        'scheduled_at': scheduledAtIso,
        'duration_minutes': durationMinutes,
      };

      final res = await api.post('/api/core/bookings/', body, token: token);
      if (res is Map<String, dynamic>) {
        return res;
      }
    } catch (e) {
      debugPrint('Error creating booking: $e');
    }

    // Default fallback error response
    return {'error': 'Failed to create booking'};
  }
}
