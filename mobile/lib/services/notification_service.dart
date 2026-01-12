import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/horoscope.dart';
import 'kundali_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    // Initialize timezone
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _initialized = true;
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap - can navigate to specific screens
    print('Notification tapped: ${response.payload}');
  }

  /// Schedule daily horoscope notification (morning at 8 AM)
  Future<void> scheduleDailyHoroscopeNotification(String zodiacSign) async {
    await initialize();

    final prefs = await SharedPreferences.getInstance();
    final notificationTime = prefs.getString('horoscope_notification_time') ?? '08:00';
    final parts = notificationTime.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    // Cancel existing notification
    await _notifications.cancel(1);

    // Schedule new notification
    await _notifications.zonedSchedule(
      1,
      'Your Daily Horoscope',
      'Check your ${zodiacSign.toUpperCase()} horoscope for today!',
      _nextInstanceOfTime(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_horoscope',
          'Daily Horoscope',
          channelDescription: 'Daily horoscope reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Schedule personalized prediction notification
  Future<void> schedulePersonalizedPrediction(String zodiacSign, String prediction) async {
    await initialize();

    await _notifications.zonedSchedule(
      2,
      'Personalized Prediction for ${zodiacSign.toUpperCase()}',
      prediction.length > 100 ? prediction.substring(0, 100) + '...' : prediction,
      tz.TZDateTime.now(tz.local).add(const Duration(hours: 12)), // 12 hours from now
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'personalized_predictions',
          'Personalized Predictions',
          channelDescription: 'Personalized astrology predictions',
          importance: Importance.defaultImportance,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// Schedule auspicious time alert
  Future<void> scheduleAuspiciousTimeAlert(String title, String description, DateTime time) async {
    await initialize();

    final tzTime = tz.TZDateTime.from(time, tz.local);

    await _notifications.zonedSchedule(
      DateTime.now().millisecondsSinceEpoch % 100000, // Unique ID
      title,
      description,
      tzTime.subtract(const Duration(minutes: 15)), // 15 minutes before
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'auspicious_times',
          'Auspicious Times',
          channelDescription: 'Alerts for auspicious times',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// Schedule consultation reminder (1 hour before)
  Future<void> scheduleConsultationReminder(int bookingId, String panditName, DateTime consultationTime) async {
    await initialize();

    final reminderTime = tz.TZDateTime.from(consultationTime, tz.local).subtract(const Duration(hours: 1));

    await _notifications.zonedSchedule(
      bookingId + 10000, // Unique ID based on booking
      'Consultation Reminder',
      'Your consultation with $panditName is in 1 hour',
      reminderTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'consultation_reminders',
          'Consultation Reminders',
          channelDescription: 'Reminders for upcoming consultations',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  /// Get next instance of specified time
  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }
}

