class Horoscope {
  final int id;
  final String zodiacSign;
  final String date;
  final String prediction;

  Horoscope({required this.id, required this.zodiacSign, required this.date, required this.prediction});

  factory Horoscope.fromJson(Map<String, dynamic> json) {
    return Horoscope(
      id: json['id'],
      zodiacSign: json['zodiac_sign'] ?? '',
      date: json['date'] ?? '',
      prediction: json['prediction'] ?? (json['text'] ?? ''),
    );
  }
}
