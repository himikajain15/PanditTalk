class Booking {
  final int id;
  final Map<String, dynamic> user;
  final Map<String, dynamic> pandit;
  final String scheduledAt;
  final int durationMinutes;
  final String status;

  Booking({
    required this.id,
    required this.user,
    required this.pandit,
    required this.scheduledAt,
    required this.durationMinutes,
    required this.status,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      user: json['user'] ?? {},
      pandit: json['pandit'] ?? {},
      scheduledAt: json['scheduled_at'] ?? '',
      durationMinutes: json['duration_minutes'] ?? 15,
      status: json['status'] ?? 'PENDING',
    );
  }
}
