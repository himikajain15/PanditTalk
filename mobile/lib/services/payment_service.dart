import '../services/api_service.dart';

class PaymentService {
  final ApiService api;
  PaymentService({ApiService? apiService}) : api = apiService ?? ApiService();

  Future<Map<String, dynamic>> initiatePayment(int bookingId, String? token) async {
    return await api.post('/api/payments/initiate/', {'booking_id': bookingId}, token: token);
  }

  Future<Map<String, dynamic>> verifyPayment(Map<String, dynamic> payload, String? token) async {
    return await api.post('/api/payments/verify/', payload, token: token);
  }
}
