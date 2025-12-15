class Pandit {
  final int id;
  final String username;
  final String? phone;
  final String? profilePic;
  final String? bio;
  final PanditProfile? profile;

  Pandit({
    required this.id,
    required this.username,
    this.phone,
    this.profilePic,
    this.bio,
    this.profile,
  });

  factory Pandit.fromJson(Map<String, dynamic> json) {
    return Pandit(
      id: json['id'],
      username: json['username'],
      phone: json['phone'],
      profilePic: json['profile_pic'],
      bio: json['bio'],
      profile: json['profile'] != null
          ? PanditProfile.fromJson(json['profile'])
          : null,
    );
  }

  // Backward compatibility with old code
  bool get isOnline => profile?.isAvailable ?? false;
  String get expertise => profile?.specializations.isNotEmpty == true 
      ? profile!.specializations.first 
      : 'Astrologer';
  List<String> get languages => profile?.languages ?? [];
  int get experienceYears => profile?.experienceYears ?? 0;
  double get rating => profile?.averageRating ?? 0.0;
  double get feePerMinute => profile?.chatRate ?? 0.0;
}

class PanditProfile {
  final int id;
  final bool isVerified;
  final List<String> specializations;
  final List<String> languages;
  final int experienceYears;
  final double chatRate;
  final double callRate;
  final double videoRate;
  final String availabilityStatus;
  final double averageRating;
  final int totalConsultations;
  final int totalReviews;

  PanditProfile({
    required this.id,
    required this.isVerified,
    required this.specializations,
    required this.languages,
    required this.experienceYears,
    required this.chatRate,
    required this.callRate,
    required this.videoRate,
    required this.availabilityStatus,
    required this.averageRating,
    required this.totalConsultations,
    required this.totalReviews,
  });

  factory PanditProfile.fromJson(Map<String, dynamic> json) {
    return PanditProfile(
      id: json['id'],
      isVerified: json['is_verified'] ?? false,
      specializations: List<String>.from(json['specializations'] ?? []),
      languages: List<String>.from(json['languages'] ?? []),
      experienceYears: json['experience_years'] ?? 0,
      chatRate: double.parse(json['chat_rate'].toString()),
      callRate: double.parse(json['call_rate'].toString()),
      videoRate: double.parse(json['video_rate'].toString()),
      availabilityStatus: json['availability_status'] ?? 'offline',
      averageRating: double.parse(json['average_rating'].toString()),
      totalConsultations: json['total_consultations'] ?? 0,
      totalReviews: json['total_reviews'] ?? 0,
    );
  }

  bool get isAvailable => availabilityStatus == 'available';
}
