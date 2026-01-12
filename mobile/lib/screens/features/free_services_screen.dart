import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../services/daily_horoscope_screen.dart';
import '../services/free_kundli_screen.dart';
import '../services/kundli_matching_screen.dart';
import '../services/palmistry_screen.dart';
import '../services/tarot_card_screen.dart';

class FreeServicesScreen extends StatelessWidget {
  const FreeServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final services = [
      {
        'title': 'Daily Horoscope',
        'icon': '⭐',
        'description': 'Get your free daily horoscope',
        'screen': DailyHoroscopeScreen(),
      },
      {
        'title': 'Free Kundli (AI)',
        'icon': '📜',
        'description': 'AI-powered free Kundli',
        'screen': FreeKundliScreen(),
      },
      {
        'title': 'Kundli Matching',
        'icon': '💑',
        'description': 'Free compatibility check',
        'screen': KundliMatchingScreen(),
      },
      {
        'title': 'Palmistry Reading',
        'icon': '✋',
        'description': 'Upload hand photos for free palm reading',
        'screen': PalmistryScreen(),
      },
      {
        'title': 'Tarot Card Reading',
        'icon': '🃏',
        'description': 'Get free AI-powered tarot card readings',
        'screen': TarotCardScreen(),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Free Services'),
        backgroundColor: AppTheme.primaryYellow,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade400, Colors.green.shade600],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.card_giftcard, color: Colors.white, size: 32),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Enjoy FREE services as our valued user!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: services.length,
              itemBuilder: (context, index) {
                final service = services[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Text(
                      service['icon'] as String,
                      style: const TextStyle(fontSize: 32),
                    ),
                    title: Text(service['title'] as String),
                    subtitle: Text(service['description'] as String),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'FREE',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onTap: () {
                      final screen = service['screen'] as Widget?;
                      if (screen != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => screen),
                        );
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

