class ConsultationRequest {
  final int id;
  final int userId;
  final int panditId;
  final String userName;
  final String? userPhone;
  final String? userProfilePic;
  final String serviceType;
  final int duration;
  final String? userQuery;
  final Map<String, dynamic>? birthDetails;
  final double amount;
  final double panditEarnings;
  final String status;
  final DateTime createdAt;
  final DateTime? acceptedAt;
  final int? userRating;
  final String? userReview;
  final String? panditNotes;
  final String? recommendedRemedies;
  final bool isVIP;

  ConsultationRequest({
    required this.id,
    required this.userId,
    required this.panditId,
    required this.userName,
    this.userPhone,
    this.userProfilePic,
    required this.serviceType,
    required this.duration,
    this.userQuery,
    this.birthDetails,
    required this.amount,
    required this.panditEarnings,
    required this.status,
    required this.createdAt,
    this.acceptedAt,
    this.userRating,
    this.userReview,
    this.panditNotes,
    this.recommendedRemedies,
    this.isVIP = false,
  });

  factory ConsultationRequest.fromJson(Map<String, dynamic> json) {
    return ConsultationRequest(
      id: json['id'],
      userId: json['user'],
      panditId: json['pandit'],
      userName: json['user_name'] ?? 'User',
      userPhone: json['user_phone'],
      userProfilePic: json['user_profile_pic'],
      serviceType: json['service_type'],
      duration: json['duration'] ?? 15,
      userQuery: json['user_query'],
      birthDetails: json['birth_details'],
      amount: double.parse(json['amount'].toString()),
      panditEarnings: double.parse(json['pandit_earnings'].toString()),
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      acceptedAt: json['accepted_at'] != null
          ? DateTime.parse(json['accepted_at'])
          : null,
      userRating: json['user_rating'],
      userReview: json['user_review'],
      panditNotes: json['pandit_notes'],
      recommendedRemedies: json['recommended_remedies'],
      isVIP: json['is_vip'] ?? false,
    );
  }

  String get serviceTypeDisplay {
    switch (serviceType) {
      case 'chat':
        return 'Chat';
      case 'call':
        return 'Audio Call';
      case 'video':
        return 'Video Call';
      default:
        return serviceType;
    }
  }

  String get statusDisplay {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'accepted':
        return 'Accepted';
      case 'in_progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      case 'rejected':
        return 'Rejected';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }
}

