import '../models/testimonial.dart';
import 'api_service.dart';

class TestimonialService {
  final ApiService api = ApiService();

  /// Get all testimonials
  Future<List<Testimonial>> getTestimonials({int? panditId, int limit = 50}) async {
    try {
      String url = '/api/core/testimonials/';
      if (panditId != null) {
        url += '?pandit=$panditId';
      }
      final res = await api.get(url);
      if (res is List) {
        return res.map((e) => Testimonial.fromJson(e)).toList();
      } else if (res is Map && res.containsKey('results')) {
        return (res['results'] as List)
            .map((e) => Testimonial.fromJson(e))
            .toList();
      }
    } catch (e) {
      print('Error fetching testimonials: $e');
    }
    return [];
  }

  /// Submit a testimonial/review
  Future<Map<String, dynamic>> submitTestimonial({
    int? panditId,
    required int rating,
    required String title,
    required String content,
    String? authToken,
  }) async {
    try {
      final body = {
        if (panditId != null) 'pandit': panditId,
        'rating': rating,
        'title': title,
        'content': content,
      };
      final res = await api.post('/api/core/testimonials/', body, token: authToken);
      if (res is Map) {
        return Map<String, dynamic>.from(res);
      }
    } catch (e) {
      print('Error submitting testimonial: $e');
    }
    return {'error': 'Failed to submit testimonial'};
  }
}

