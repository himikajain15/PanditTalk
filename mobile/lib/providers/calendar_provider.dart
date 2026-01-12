import 'package:flutter/material.dart';
import '../models/calendar_event.dart';
import '../services/calendar_service.dart';
import '../services/auth_service.dart';

class CalendarProvider extends ChangeNotifier {
  final CalendarService _service = CalendarService();
  final AuthService _auth = AuthService();

  List<CalendarEvent> _festivals = [];
  List<CalendarEvent> _userEvents = [];
  Map<DateTime, List<CalendarEvent>> _eventsByDate = {};
  bool _loading = false;
  String? _zodiacSign;

  List<CalendarEvent> get festivals => _festivals;
  List<CalendarEvent> get userEvents => _userEvents;
  Map<DateTime, List<CalendarEvent>> get eventsByDate => _eventsByDate;
  bool get loading => _loading;

  void setZodiacSign(String? sign) {
    _zodiacSign = sign;
    notifyListeners();
  }

  Future<void> loadFestivals(DateTime month) async {
    _loading = true;
    notifyListeners();

    try {
      _festivals = await _service.getFestivals(month, zodiacSign: _zodiacSign);
      _updateEventsMap();
    } catch (e) {
      debugPrint('Error loading festivals: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> loadUserEvents(DateTime month) async {
    _loading = true;
    notifyListeners();

    try {
      final token = await _auth.getToken();
      _userEvents = await _service.getUserEvents(month, token);
      _updateEventsMap();
    } catch (e) {
      debugPrint('Error loading user events: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<List<CalendarEvent>> getAuspiciousTimes(DateTime date) async {
    try {
      return await _service.getAuspiciousTimes(date, zodiacSign: _zodiacSign);
    } catch (e) {
      debugPrint('Error loading auspicious times: $e');
      return [];
    }
  }

  void _updateEventsMap() {
    _eventsByDate.clear();
    final allEvents = [..._festivals, ..._userEvents];
    
    for (var event in allEvents) {
      final dateKey = DateTime(event.date.year, event.date.month, event.date.day);
      if (!_eventsByDate.containsKey(dateKey)) {
        _eventsByDate[dateKey] = [];
      }
      _eventsByDate[dateKey]!.add(event);
    }
  }

  List<CalendarEvent> getEventsForDate(DateTime date) {
    final dateKey = DateTime(date.year, date.month, date.day);
    return _eventsByDate[dateKey] ?? [];
  }
}

