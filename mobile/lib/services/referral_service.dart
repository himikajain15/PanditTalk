import '../models/referral.dart';
import 'api_service.dart';

class ReferralService {
  final ApiService api = ApiService();

  /// Get or create referral code for current user
  Future<Referral?> getReferralCode(String? authToken) async {
    try {
      final res = await api.get('/api/core/referrals/me/', token: authToken);
      if (res is Map) {
        return Referral.fromJson(Map<String, dynamic>.from(res));
      }
    } catch (e) {
      print('Error fetching referral code: $e');
    }
    return null;
  }

  /// Create referral code if doesn't exist
  Future<Referral?> createReferralCode(String? authToken) async {
    try {
      final res = await api.post('/api/core/referrals/', {}, token: authToken);
      if (res is Map) {
        return Referral.fromJson(Map<String, dynamic>.from(res));
      }
    } catch (e) {
      print('Error creating referral code: $e');
    }
    return null;
  }

  /// Apply referral code (when new user signs up)
  Future<Map<String, dynamic>> applyReferralCode(String code, String? authToken) async {
    try {
      final res = await api.post('/api/core/referrals/use/', {'referral_code': code}, token: authToken);
      if (res is Map) {
        return Map<String, dynamic>.from(res);
      }
    } catch (e) {
      print('Error applying referral code: $e');
    }
    return {'error': 'Failed to apply referral code'};
  }

  /// Get referral statistics (same as getReferralCode, includes stats)
  Future<Referral?> getReferralStats(String? authToken) async {
    return getReferralCode(authToken);
  }

  /// Get referral rewards history
  Future<List<ReferralReward>> getReferralRewards(String? authToken) async {
    try {
      final res = await api.get('/api/referrals/rewards/', token: authToken);
      if (res is List) {
        return res.map((e) => ReferralReward.fromJson(e)).toList();
      }
    } catch (e) {
      print('Error fetching referral rewards: $e');
    }
    return [];
  }
}

