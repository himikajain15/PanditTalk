import 'package:intl/intl.dart';
import '../models/calendar_event.dart';
import 'api_service.dart';

class CalendarService {
  final ApiService api = ApiService();

  /// Fetch festivals and important dates
  Future<List<CalendarEvent>> getFestivals(DateTime month, {String? zodiacSign, String? authToken}) async {
    try {
      final startOfMonth = DateTime(month.year, month.month, 1);
      final endOfMonth = DateTime(month.year, month.month + 1, 0);
      final dateFrom = DateFormat('yyyy-MM-dd').format(startOfMonth);
      final dateTo = DateFormat('yyyy-MM-dd').format(endOfMonth);
      final url = '/api/core/calendar/events/?date_from=$dateFrom&date_to=$dateTo';
      final res = await api.get(url, token: authToken);
      if (res is List) {
        final events = res.map((e) => CalendarEvent.fromJson(e)).toList();
        // Filter for festivals and public events
        return events.where((e) => e.eventType == 'festival' || e.isPublic).toList();
      }
    } catch (e) {
      print('Error fetching festivals: $e');
    }
    return _getDefaultFestivals(month);
  }

  /// Get auspicious times for a specific date
  Future<List<CalendarEvent>> getAuspiciousTimes(DateTime date, {String? zodiacSign, String? authToken}) async {
    try {
      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      final url = '/api/core/calendar/events/?date_from=$dateStr&date_to=$dateStr';
      final res = await api.get(url, token: authToken);
      if (res is List) {
        final events = res.map((e) => CalendarEvent.fromJson(e)).toList();
        // Filter for auspicious events
        return events.where((e) => e.eventType == 'auspicious').toList();
      }
    } catch (e) {
      print('Error fetching auspicious times: $e');
    }
    return [];
  }

  /// Get user's personalized calendar events
  Future<List<CalendarEvent>> getUserEvents(DateTime month, String? authToken) async {
    try {
      final startOfMonth = DateTime(month.year, month.month, 1);
      final endOfMonth = DateTime(month.year, month.month + 1, 0);
      final dateFrom = DateFormat('yyyy-MM-dd').format(startOfMonth);
      final dateTo = DateFormat('yyyy-MM-dd').format(endOfMonth);
      final res = await api.get('/api/core/calendar/events/?date_from=$dateFrom&date_to=$dateTo', token: authToken);
      if (res is List) {
        return res.map((e) => CalendarEvent.fromJson(e)).toList();
      }
    } catch (e) {
      print('Error fetching user events: $e');
    }
    return [];
  }

  /// Create a calendar event
  Future<CalendarEvent?> createEvent({
    required String eventType,
    required String title,
    required DateTime date,
    String? description,
    String? time,
    bool isRecurring = false,
    String? recurringPattern,
    String? authToken,
  }) async {
    try {
      final body = {
        'event_type': eventType,
        'title': title,
        'date': DateFormat('yyyy-MM-dd').format(date),
        if (description != null) 'description': description,
        if (time != null) 'time': time,
        'is_recurring': isRecurring,
        if (recurringPattern != null) 'recurring_pattern': recurringPattern,
        'is_public': false,
      };
      final res = await api.post('/api/core/calendar/events/', body, token: authToken);
      if (res is Map) {
        return CalendarEvent.fromJson(Map<String, dynamic>.from(res));
      }
    } catch (e) {
      print('Error creating calendar event: $e');
    }
    return null;
  }

  /// Default festivals (fallback)
  List<CalendarEvent> _getDefaultFestivals(DateTime month) {
    // Common Indian festivals - simplified list
    final festivals = <CalendarEvent>[];
    final year = month.year;
    
    // Add some common festivals (simplified - in production, use proper calendar API)
    festivals.add(CalendarEvent(
      id: 1,
      title: 'Diwali',
      description: 'Festival of Lights',
      date: DateTime(year, 10, 24), // Approximate
      eventType: 'festival',
    ));
    
    festivals.add(CalendarEvent(
      id: 2,
      title: 'Holi',
      description: 'Festival of Colors',
      date: DateTime(year, 3, 8), // Approximate
      eventType: 'festival',
    ));

    return festivals.where((e) => 
      e.date.year == month.year && e.date.month == month.month
    ).toList();
  }
}

