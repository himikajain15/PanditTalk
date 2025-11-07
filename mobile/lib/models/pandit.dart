class Pandit {
  final int id;
  final String username;
  final List<dynamic> languages;
  final String expertise;
  final int experienceYears;
  final double feePerMinute;
  final double rating;
  final bool isOnline;

  Pandit({
    required this.id,
    required this.username,
    required this.languages,
    required this.expertise,
    required this.experienceYears,
    required this.feePerMinute,
    required this.rating,
    required this.isOnline,
  });

  factory Pandit.fromJson(Map<String, dynamic> json) {
    final user = json['user'] ?? {};
    return Pandit(
      id: json['id'],
      username: user['username'] ?? 'Pandit',
      languages: json['languages'] ?? [],
      expertise: json['expertise'] ?? '',
      experienceYears: json['experience_years'] ?? 0,
      feePerMinute: (json['fee_per_minute'] != null) ? double.parse(json['fee_per_minute'].toString()) : 0.0,
      rating: (json['rating'] != null) ? double.parse(json['rating'].toString()) : 0.0,
      isOnline: json['is_online'] ?? false,
    );
  }
}
