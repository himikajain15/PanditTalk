import 'package:flutter/material.dart';
import 'api_service.dart';

/// Service layer for engagement/growth endpoints.
/// All methods are resilient: they return null/sensible defaults on errors.
class EngagementService {
  final ApiService api = ApiService();

  Future<Map<String, dynamic>?> fetchDailyHoroscope(String sign, {String? token}) async {
    final res = await api.get('/api/horoscope/daily/?sign=$sign', token: token);
    if (res is Map && res['error'] == null) return Map<String, dynamic>.from(res);
    return null;
  }

  Future<double?> fetchWalletBalance({String? token}) async {
    final res = await api.get('/api/wallet/balance/', token: token);
    if (res is Map && res['balance'] != null) {
      return double.tryParse(res['balance'].toString());
    }
    return null;
  }

  Future<Map<String, dynamic>?> fetchReferralCode({String? token}) async {
    final res = await api.get('/api/referrals/me/', token: token);
    if (res is Map && res['error'] == null) return Map<String, dynamic>.from(res);
    return null;
  }

  Future<Map<String, dynamic>?> checkStreak({String? token}) async {
    final res = await api.get('/api/streaks/status/', token: token);
    if (res is Map && res['error'] == null) return Map<String, dynamic>.from(res);
    return null;
  }

  Future<Map<String, dynamic>?> checkInStreak({String? token}) async {
    final res = await api.post('/api/streaks/check-in/', {}, token: token ?? '');
    if (res is Map && res['error'] == null) return Map<String, dynamic>.from(res);
    return null;
  }

  Future<void> submitContext({
    required int panditId,
    required String topic,
    required String background,
    String? token,
  }) async {
    await api.post('/api/session/context/', {
      'pandit_id': panditId,
      'topic': topic,
      'background': background,
    }, token: token ?? '');
  }

  Future<void> submitCallRating({
    required int panditId,
    required double rating,
    double? tip,
    String? token,
  }) async {
    await api.post('/api/session/rating/', {
      'pandit_id': panditId,
      'rating': rating,
      if (tip != null) 'tip': tip,
    }, token: token ?? '');
  }

  Future<void> logEvent(String name, Map<String, dynamic> props, {String? token}) async {
    await api.post('/api/analytics/event/', {
      'name': name,
      'props': props,
    }, token: token ?? '');
  }
}

