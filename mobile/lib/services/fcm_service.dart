// Minimal FCM registration helper - requires Firebase setup to fully work.
// Here we just provide a method to register token with backend when available.
import '../services/api_service.dart';

class FcmService {
  final ApiService api;

  FcmService({ApiService? apiService}) : api = apiService ?? ApiService();

  Future<void> registerToken(String token, String? authToken) async {
    // If backend available, call register endpoint
    if (authToken != null) {
      await api.post('/api/notifications/register-token/', {'token': token}, token: authToken);
    }
  }
}
