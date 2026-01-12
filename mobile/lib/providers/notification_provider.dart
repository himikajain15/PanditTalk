import 'package:flutter/material.dart';
import '../models/notification.dart';
import '../services/api_service.dart';
import '../services/notification_service.dart';
import '../services/auth_service.dart';
import 'user_provider.dart';

class NotificationProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  final NotificationService _notificationService = NotificationService();
  final AuthService _auth = AuthService();

  List<AppNotification> _notifications = [];
  bool _loading = false;
  bool _dailyHoroscopeEnabled = false;
  bool _personalizedPredictionsEnabled = false;
  bool _auspiciousTimeAlertsEnabled = false;
  String? _horoscopeNotificationTime = '08:00';

  List<AppNotification> get notifications => _notifications;
  bool get loading => _loading;
  bool get dailyHoroscopeEnabled => _dailyHoroscopeEnabled;
  bool get personalizedPredictionsEnabled => _personalizedPredictionsEnabled;
  bool get auspiciousTimeAlertsEnabled => _auspiciousTimeAlertsEnabled;
  String? get horoscopeNotificationTime => _horoscopeNotificationTime;

  Future<void> loadNotifications() async {
    _loading = true;
    notifyListeners();

    try {
      final res = await _api.get('/api/notifications/list/');
      if (res is List) {
        _notifications = res.map((e) => AppNotification.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint('Error loading notifications: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> enableDailyHoroscopeNotification(String zodiacSign, String time) async {
    _dailyHoroscopeEnabled = true;
    _horoscopeNotificationTime = time;
    await _notificationService.scheduleDailyHoroscopeNotification(zodiacSign);
    notifyListeners();
  }

  Future<void> disableDailyHoroscopeNotification() async {
    _dailyHoroscopeEnabled = false;
    await _notificationService.cancelNotification(1);
    notifyListeners();
  }

  Future<void> enablePersonalizedPredictions(String zodiacSign) async {
    _personalizedPredictionsEnabled = true;
    // Schedule personalized prediction notification
    await _notificationService.schedulePersonalizedPrediction(
      zodiacSign,
      'Your personalized prediction is ready!',
    );
    notifyListeners();
  }

  Future<void> enableAuspiciousTimeAlerts() async {
    _auspiciousTimeAlertsEnabled = true;
    notifyListeners();
  }

  Future<void> scheduleConsultationReminder(int bookingId, String panditName, DateTime consultationTime) async {
    await _notificationService.scheduleConsultationReminder(bookingId, panditName, consultationTime);
  }
}
