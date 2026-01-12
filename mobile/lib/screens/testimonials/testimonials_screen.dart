import 'package:flutter/material.dart';
import '../../utils/theme.dart';
import '../../models/testimonial.dart';
import '../../services/testimonial_service.dart';
import '../../utils/app_strings.dart';

class TestimonialsScreen extends StatefulWidget {
  final int? panditId;

  const TestimonialsScreen({Key? key, this.panditId}) : super(key: key);

  @override
  _TestimonialsScreenState createState() => _TestimonialsScreenState();
}

class _TestimonialsScreenState extends State<TestimonialsScreen> {
  final TestimonialService _service = TestimonialService();
  List<Testimonial> _testimonials = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTestimonials();
  }

  Future<void> _loadTestimonials() async {
    setState(() => _loading = true);
    try {
      _testimonials = await _service.getTestimonials(panditId: widget.panditId);
    } catch (e) {
      debugPrint('Error loading testimonials: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.getString(context, 'testimonials', fallback: 'Testimonials & Reviews')),
        backgroundColor: AppTheme.primaryYellow,
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator(color: AppTheme.primaryYellow))
          : _testimonials.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.rate_review, size: 64, color: AppTheme.mediumGray),
                      SizedBox(height: 16),
                      Text(
                        AppStrings.getString(context, 'noTestimonials', fallback: 'No testimonials yet'),
                        style: TextStyle(fontSize: 16, color: AppTheme.mediumGray),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: _testimonials.length,
                  itemBuilder: (context, index) {
                    return _buildTestimonialCard(_testimonials[index]);
                  },
                ),
    );
  }

  Widget _buildTestimonialCard(Testimonial testimonial) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppTheme.primaryYellow.withOpacity(0.2),
                  child: testimonial.userAvatar != null
                      ? ClipOval(
                          child: Image.network(
                            testimonial.userAvatar!,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Text(
                          testimonial.userName[0].toUpperCase(),
                          style: TextStyle(
                            color: AppTheme.primaryYellow,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            testimonial.userName,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          if (testimonial.verified) ...[
                            SizedBox(width: 4),
                            Icon(Icons.verified, size: 16, color: Colors.blue),
                          ],
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          ...List.generate(5, (i) {
                            return Icon(
                              i < testimonial.rating.round()
                                  ? Icons.star
                                  : Icons.star_border,
                              size: 16,
                              color: Colors.amber,
                            );
                          }),
                          SizedBox(width: 8),
                          Text(
                            testimonial.rating.toStringAsFixed(1),
                            style: TextStyle(fontSize: 12, color: AppTheme.mediumGray),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  _formatDate(testimonial.createdAt),
                  style: TextStyle(fontSize: 12, color: AppTheme.mediumGray),
                ),
              ],
            ),
            SizedBox(height: 12),

            // Review Text
            Text(
              testimonial.review,
              style: TextStyle(fontSize: 14, height: 1.5),
            ),

            // Pandit Info (if available)
            if (testimonial.panditName != null) ...[
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryYellow.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.person, size: 16, color: AppTheme.primaryYellow),
                    SizedBox(width: 8),
                    Text(
                      'Consulted with ${testimonial.panditName}',
                      style: TextStyle(fontSize: 12, color: AppTheme.primaryYellow),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

