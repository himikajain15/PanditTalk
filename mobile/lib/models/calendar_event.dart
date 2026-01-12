class CalendarEvent {
  final int id;
  final String title;
  final String description;
  final DateTime date;
  final String eventType; // 'festival', 'auspicious', 'reminder', 'consultation'
  final String? zodiacSign; // For personalized events
  final bool isRecurring;
  final bool isPublic; // Public events vs user events
  final DateTime? time; // For auspicious times
  final Map<String, dynamic>? metadata;

  CalendarEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.eventType,
    this.zodiacSign,
    this.isRecurring = false,
    this.isPublic = false,
    this.time,
    this.metadata,
  });

  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    return CalendarEvent(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.now(),
      eventType: json['event_type'] ?? 'reminder',
      zodiacSign: json['zodiac_sign'],
      isRecurring: json['is_recurring'] ?? false,
      isPublic: json['is_public'] ?? false,
      time: json['time'] != null ? DateTime.parse('2000-01-01 ${json['time']}') : null,
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'event_type': eventType,
      'zodiac_sign': zodiacSign,
      'is_recurring': isRecurring,
      'is_public': isPublic,
      'time': time != null ? '${time!.hour.toString().padLeft(2, '0')}:${time!.minute.toString().padLeft(2, '0')}' : null,
      'metadata': metadata,
    };
  }
}

