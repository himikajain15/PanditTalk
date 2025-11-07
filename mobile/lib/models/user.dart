class UserModel {
  final int id;
  final String username;
  final String email;
  final String? phone;
  final bool isPandit;
  final int karmaPoints;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.phone,
    this.isPandit = false,
    this.karmaPoints = 0,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      isPandit: json['is_pandit'] ?? false,
      karmaPoints: json['karma_points'] ?? 0,
    );
  }
}
