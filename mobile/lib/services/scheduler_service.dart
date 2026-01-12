import 'package:intl/intl.dart';
import 'api_service.dart';

class SchedulerService {
  final ApiService api = ApiService();

  /// Get available slots for a date
  Future<List<Map<String, dynamic>>> getAvailableSlots({
    DateTime? date,
    int? panditId,
    String? authToken,
  }) async {
    try {
      String url = '/api/core/scheduler/slots/';
      final params = <String>[];
      if (date != null) {
        params.add('date=${DateFormat('yyyy-MM-dd').format(date)}');
      }
      if (panditId != null) {
        params.add('pandit_id=$panditId');
      }
      if (params.isNotEmpty) {
        url += '?${params.join('&')}';
      }
      
      final res = await api.get(url, token: authToken);
      if (res is List) {
        return res.map((e) => Map<String, dynamic>.from(e)).toList();
      }
    } catch (e) {
      print('Error fetching available slots: $e');
    }
    return [];
  }

  /// Book a live session slot
  Future<Map<String, dynamic>> bookSlot({
    required int slotId,
    String? authToken,
  }) async {
    try {
      final res = await api.post(
        '/api/core/scheduler/slots/$slotId/book/',
        {},
        token: authToken,
      );
      if (res is Map) {
        return Map<String, dynamic>.from(res);
      }
    } catch (e) {
      print('Error booking slot: $e');
    }
    return {'error': 'Failed to book slot'};
  }

  /// Create slots (for pandits only)
  Future<Map<String, dynamic>> createSlots({
    required int panditId,
    required DateTime date,
    required List<Map<String, String>> timeSlots, // [{'start_time': '09:00', 'end_time': '09:30'}]
    String? authToken,
  }) async {
    try {
      final slots = timeSlots.map((slot) => {
        'pandit_id': panditId,
        'date': DateFormat('yyyy-MM-dd').format(date),
        'start_time': slot['start_time'],
        'end_time': slot['end_time'],
      }).toList();

      final results = <Map<String, dynamic>>[];
      for (final slotData in slots) {
        try {
          final res = await api.post('/api/core/scheduler/slots/', slotData, token: authToken);
          if (res is Map) {
            results.add(Map<String, dynamic>.from(res));
          }
        } catch (e) {
          print('Error creating slot: $e');
        }
      }
      return {'success': true, 'slots_created': results.length, 'slots': results};
    } catch (e) {
      print('Error creating slots: $e');
    }
    return {'error': 'Failed to create slots'};
  }
}

