class UserDaySummary {
  final String date;
  final String zodiacSign;
  final String horoscopeText;
  final int luckyNumber;
  final String luckyColor;
  final String mood;
  final String? auspiciousTime;
  final List<String> recommendations;
  final int upcomingConsultations;

  UserDaySummary({
    required this.date,
    required this.zodiacSign,
    required this.horoscopeText,
    required this.luckyNumber,
    required this.luckyColor,
    required this.mood,
    this.auspiciousTime,
    this.recommendations = const [],
    this.upcomingConsultations = 0,
  });

  factory UserDaySummary.fromJson(Map<String, dynamic> json) {
    return UserDaySummary(
      date: json['date'] ?? '',
      zodiacSign: json['zodiac_sign'] ?? '',
      horoscopeText: json['horoscope_text'] ?? '',
      luckyNumber: json['lucky_number'] ?? 0,
      luckyColor: json['lucky_color'] ?? '',
      mood: json['mood'] ?? '',
      auspiciousTime: json['auspicious_time'],
      recommendations: json['recommendations'] != null
          ? List<String>.from(json['recommendations'])
          : [],
      upcomingConsultations: json['upcoming_consultations'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'zodiac_sign': zodiacSign,
      'horoscope_text': horoscopeText,
      'lucky_number': luckyNumber,
      'lucky_color': luckyColor,
      'mood': mood,
      'auspicious_time': auspiciousTime,
      'recommendations': recommendations,
      'upcoming_consultations': upcomingConsultations,
    };
  }
}

