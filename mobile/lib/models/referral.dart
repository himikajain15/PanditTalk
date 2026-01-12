class Referral {
  final int id;
  final String referralCode;
  final int userId;
  final int totalReferrals;
  final int creditsEarned;
  final DateTime createdAt;

  Referral({
    required this.id,
    required this.referralCode,
    required this.userId,
    required this.totalReferrals,
    required this.creditsEarned,
    required this.createdAt,
  });

  factory Referral.fromJson(Map<String, dynamic> json) {
    return Referral(
      id: json['id'] ?? 0,
      referralCode: json['referral_code'] ?? '',
      userId: json['user_id'] ?? 0,
      totalReferrals: json['total_referrals'] ?? 0,
      creditsEarned: json['credits_earned'] ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'referral_code': referralCode,
      'user_id': userId,
      'total_referrals': totalReferrals,
      'credits_earned': creditsEarned,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class ReferralReward {
  final int id;
  final String referredByCode;
  final int referredUserId;
  final int creditsAwarded;
  final bool credited;
  final DateTime createdAt;

  ReferralReward({
    required this.id,
    required this.referredByCode,
    required this.referredUserId,
    required this.creditsAwarded,
    required this.credited,
    required this.createdAt,
  });

  factory ReferralReward.fromJson(Map<String, dynamic> json) {
    return ReferralReward(
      id: json['id'] ?? 0,
      referredByCode: json['referred_by_code'] ?? '',
      referredUserId: json['referred_user_id'] ?? 0,
      creditsAwarded: json['credits_awarded'] ?? 0,
      credited: json['credited'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }
}

