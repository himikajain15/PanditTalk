// Simple REST-based chat helper; WebSocket upgrade can be added later.
import '../services/api_service.dart';

class SocketService {
  final ApiService api;
  SocketService({ApiService? apiService}) : api = apiService ?? ApiService();

  Future<dynamic> sendMessage(int threadId, String message, String? token) async {
    return await api.post('/api/core/threads/$threadId/messages/', {'text': message}, token: token);
  }

  Future<dynamic> createThread(int panditId, String? token) async {
    return await api.post('/api/core/threads/', {'pandit': panditId}, token: token);
  }
}
