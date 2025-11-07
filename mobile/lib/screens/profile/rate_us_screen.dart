import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class RateUsScreen extends StatefulWidget {
  @override
  _RateUsScreenState createState() => _RateUsScreenState();
}

class _RateUsScreenState extends State<RateUsScreen> {
  int _rating = 0;
  final TextEditingController _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rate Us'),
        backgroundColor: AppTheme.primaryYellow,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Icon(Icons.star_rate, size: 80, color: AppTheme.primaryYellow),
            SizedBox(height: 20),
            Text(
              'How was your experience?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            Text(
              'Your feedback helps us improve',
              style: TextStyle(fontSize: 14, color: AppTheme.mediumGray),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            
            // Star Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    size: 48,
                    color: index < _rating ? Colors.amber : AppTheme.mediumGray,
                  ),
                  onPressed: () => setState(() => _rating = index + 1),
                );
              }),
            ),
            
            if (_rating > 0) ...[
              SizedBox(height: 8),
              Text(
                _getRatingText(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.primaryYellow),
              ),
            ],
            
            SizedBox(height: 32),
            
            // Review Text Field
            TextField(
              controller: _reviewController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Write your review (optional)',
                hintText: 'Tell us what you liked or what we can improve...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                alignLabelWithHint: true,
              ),
            ),
            
            SizedBox(height: 24),
            
            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _rating > 0 ? _submitRating : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryYellow,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  'Submit Rating',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            
            SizedBox(height: 16),
            
            // Rate on Play Store Button
            OutlinedButton.icon(
              onPressed: () {
                // TODO: Open Play Store link
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Opening Play Store...')),
                );
              },
              icon: Icon(Icons.play_arrow),
              label: Text('Rate on Play Store'),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppTheme.primaryYellow),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getRatingText() {
    switch (_rating) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Very Good';
      case 5:
        return 'Excellent!';
      default:
        return '';
    }
  }

  void _submitRating() {
    // TODO: Submit rating to backend
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 12),
            Text('Thank You!'),
          ],
        ),
        content: Text('Your feedback has been submitted successfully.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}

