import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class HelpSupportScreen extends StatelessWidget {
  final List<Map<String, dynamic>> faqs = [
    {
      'question': 'How do I book a consultation?',
      'answer': 'Go to the Home screen, browse astrologers, and tap "Book Now" on any available pandit. You can book via chat or call.',
    },
    {
      'question': 'How do I add money to my wallet?',
      'answer': 'Tap on the wallet icon in the app bar or go to Profile > Wallet. Enter the amount and complete the payment via Razorpay.',
    },
    {
      'question': 'Can I get a refund?',
      'answer': 'Yes, refunds are processed within 5-7 business days if the consultation was not delivered as promised.',
    },
    {
      'question': 'How do I contact customer support?',
      'answer': 'You can reach us via email at support@pandittalk.com or call us at +91-9876543210.',
    },
    {
      'question': 'Are my personal details safe?',
      'answer': 'Yes, we use industry-standard encryption to protect your personal and payment information.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help & Support'),
        backgroundColor: AppTheme.primaryYellow,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Contact Options
            Container(
              color: AppTheme.lightYellow,
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'Need Help?',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildContactButton(
                        icon: Icons.email,
                        label: 'Email',
                        onTap: () {},
                      ),
                      _buildContactButton(
                        icon: Icons.phone,
                        label: 'Call',
                        onTap: () {},
                      ),
                      _buildContactButton(
                        icon: Icons.chat_bubble,
                        label: 'Chat',
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // FAQs
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Frequently Asked Questions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  ...faqs.map((faq) => _buildFAQItem(faq['question']!, faq['answer']!)),
                ],
              ),
            ),
            
            // Contact Details
            Container(
              color: AppTheme.lightGray,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contact Information',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  _buildContactInfo(Icons.email, 'support@pandittalk.com'),
                  SizedBox(height: 8),
                  _buildContactInfo(Icons.phone, '+91-9876543210'),
                  SizedBox(height: 8),
                  _buildContactInfo(Icons.location_on, 'New Delhi, India'),
                  SizedBox(height: 8),
                  _buildContactInfo(Icons.access_time, '9:00 AM - 9:00 PM IST'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppTheme.primaryYellow,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppTheme.black, size: 28),
          ),
          SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return ExpansionTile(
      title: Text(question, style: TextStyle(fontWeight: FontWeight.w600)),
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(answer, style: TextStyle(color: AppTheme.mediumGray)),
        ),
      ],
    );
  }

  Widget _buildContactInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppTheme.mediumGray),
        SizedBox(width: 12),
        Text(text, style: TextStyle(fontSize: 14)),
      ],
    );
  }
}

