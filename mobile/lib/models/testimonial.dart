class Testimonial {
  final int id;
  final int userId;
  final String userName;
  final String? userAvatar;
  final int panditId;
  final String? panditName;
  final double rating;
  final String review;
  final DateTime createdAt;
  final bool verified;

  Testimonial({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.panditId,
    this.panditName,
    required this.rating,
    required this.review,
    required this.createdAt,
    this.verified = false,
  });

  factory Testimonial.fromJson(Map<String, dynamic> json) {
    return Testimonial(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      userName: json['user_name'] ?? 'Anonymous',
      userAvatar: json['user_avatar'],
      panditId: json['pandit_id'] ?? 0,
      panditName: json['pandit_name'],
      rating: (json['rating'] ?? 0.0).toDouble(),
      review: json['review'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      verified: json['verified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'user_name': userName,
      'user_avatar': userAvatar,
      'pandit_id': panditId,
      'pandit_name': panditName,
      'rating': rating,
      'review': review,
      'created_at': createdAt.toIso8601String(),
      'verified': verified,
    };
  }
}

