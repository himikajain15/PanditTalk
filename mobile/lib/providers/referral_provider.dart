import 'package:flutter/material.dart';
import '../models/referral.dart';
import '../services/referral_service.dart';
import '../services/auth_service.dart';

class ReferralProvider extends ChangeNotifier {
  final ReferralService _service = ReferralService();
  final AuthService _auth = AuthService();

  Referral? _referral;
  List<ReferralReward> _rewards = [];
  bool _loading = false;
  String? _error;

  Referral? get referral => _referral;
  List<ReferralReward> get rewards => _rewards;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> loadReferralCode() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final token = await _auth.getToken();
      _referral = await _service.getReferralCode(token);
      if (_referral == null) {
        _error = 'Failed to load referral code';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> applyReferralCode(String code) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final token = await _auth.getToken();
      final result = await _service.applyReferralCode(code, token);
      if (result.containsKey('error')) {
        _error = result['error'];
      } else {
        // Reload referral stats
        await loadReferralCode();
      }
      _loading = false;
      notifyListeners();
      return result;
    } catch (e) {
      _error = e.toString();
      _loading = false;
      notifyListeners();
      return {'error': e.toString()};
    }
  }

  Future<void> loadRewards() async {
    _loading = true;
    notifyListeners();

    try {
      final token = await _auth.getToken();
      _rewards = await _service.getReferralRewards(token);
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}

