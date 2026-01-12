import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../services/calendar_service.dart';
import '../../providers/user_provider.dart';

class RemedyPlannerScreen extends StatelessWidget {
  RemedyPlannerScreen({super.key});

  final List<_Remedy> _remedies = [
    _Remedy(
      title: 'Career Growth Mantra',
      category: 'Career',
      description: 'Chant “Om Gam Ganapataye Namah” 108 times every morning for 21 days.',
    ),
    _Remedy(
      title: 'Marriage Harmony Fast',
      category: 'Marriage',
      description: 'Observe a light fast on Fridays and offer white sweets to Goddess Lakshmi.',
    ),
    _Remedy(
      title: 'Health & Vitality',
      category: 'Health',
      description: 'Drink tulsi-infused water and chant “Mahamrityunjaya Mantra” 11 times daily.',
    ),
    _Remedy(
      title: 'Wealth & Stability',
      category: 'Finance',
      description: 'Light a ghee diya facing North-East every evening and pray for abundance.',
    ),
    _Remedy(
      title: 'Study Focus',
      category: 'Education',
      description: 'Chant “Om Saraswatyai Namah” before starting studies each day.',
    ),
  ];

  Future<void> _addToCalendar(BuildContext context, _Remedy remedy) async {
    final now = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );
    if (selectedDate == null) return;

    final userProv = Provider.of<UserProvider>(context, listen: false);
    final token = await userProv.auth.getToken();
    final service = CalendarService();

    final event = await service.createEvent(
      eventType: 'reminder',
      title: 'Remedy: ${remedy.title}',
      date: selectedDate,
      description: remedy.description,
      authToken: token,
    );

    if (event != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Reminder added on ${DateFormat('MMM d, yyyy').format(selectedDate)}',
          ),
        ),
      );
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not add to calendar. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remedy Planner'),
        backgroundColor: AppTheme.primaryYellow,
      ),
      backgroundColor: AppTheme.lightGray,
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _remedies.length,
        itemBuilder: (context, index) {
          final remedy = _remedies[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryYellow.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          remedy.category,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          remedy.title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    remedy.description,
                    style: TextStyle(fontSize: 13, color: AppTheme.mediumGray, height: 1.4),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () => _addToCalendar(context, remedy),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryYellow,
                        foregroundColor: AppTheme.black,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      icon: const Icon(Icons.event_available, size: 18),
                      label: const Text(
                        'Add to My Calendar',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Remedy {
  final String title;
  final String category;
  final String description;

  _Remedy({
    required this.title,
    required this.category,
    required this.description,
  });
}


