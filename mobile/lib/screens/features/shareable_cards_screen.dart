import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../utils/theme.dart';
import '../../utils/app_strings.dart';

class ShareableCardsScreen extends StatelessWidget {
  const ShareableCardsScreen({Key? key}) : super(key: key);

  String _todayQuote() {
    final quotes = [
      'Trust the timing of your life. ✨',
      'The universe is working in your favour.',
      'Small consistent steps create big destiny shifts.',
      'Your intuition is your highest guru – listen to it.',
      'Blessings are on the way. Keep your heart open.'
    ];
    final index = DateTime.now().day % quotes.length;
    return quotes[index];
  }

  String _luckyColor() {
    final colors = ['Gold', 'Saffron', 'Royal Blue', 'Emerald Green', 'Maroon', 'White', 'Purple'];
    final index = DateTime.now().weekday % colors.length;
    return colors[index];
  }

  int _luckyNumber() {
    final day = DateTime.now().day;
    final sum = day.toString().split('').map(int.parse).fold<int>(0, (a, b) => a + b);
    return sum == 0 ? 7 : (sum % 9 == 0 ? 9 : sum % 9);
  }

  Map<String, String> _simplePanchang() {
    final now = DateTime.now();
    final weekday = DateFormat('EEEE').format(now);
    final tithis = [
      'Pratipada',
      'Dwitiya',
      'Tritiya',
      'Chaturthi',
      'Panchami',
      'Shashthi',
      'Saptami',
      'Ashtami',
      'Navami',
      'Dashami',
      'Ekadashi',
      'Dwadashi',
      'Trayodashi',
      'Chaturdashi',
      'Purnima/Amavasya',
    ];
    final tithi = tithis[now.day % tithis.length];
    final rahuKaalByDay = {
      'Monday': '7:30 AM – 9:00 AM',
      'Tuesday': '3:00 PM – 4:30 PM',
      'Wednesday': '12:00 PM – 1:30 PM',
      'Thursday': '1:30 PM – 3:00 PM',
      'Friday': '10:30 AM – 12:00 PM',
      'Saturday': '9:00 AM – 10:30 AM',
      'Sunday': '4:30 PM – 6:00 PM',
    };
    final rahuKaal = rahuKaalByDay[weekday] ?? 'Check local timings';

    return {
      'weekday': weekday,
      'tithi': tithi,
      'rahuKaal': rahuKaal,
    };
  }

  @override
  Widget build(BuildContext context) {
    final dateText = DateFormat('MMM d, yyyy').format(DateTime.now());
    final panchang = _simplePanchang();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.getString(context, 'shareableCardsTitle', fallback: 'Shareable Cards'),
        ),
        backgroundColor: AppTheme.primaryYellow,
        foregroundColor: AppTheme.black,
      ),
      backgroundColor: AppTheme.lightGray,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            AppStrings.getString(
              context,
              'shareableCardsSubtitle',
              fallback: 'Share today’s blessings, lucky color and message with your loved ones.',
            ),
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),

          // Today’s Quote card
          _buildShareCard(
            context: context,
            tag: 'Today’s Quote',
            title: '✨ $dateText',
            mainText: _todayQuote(),
          ),
          const SizedBox(height: 16),

          // Daily Panchang card
          _buildShareCard(
            context: context,
            tag: 'Today’s Panchang',
            title: '${panchang['weekday']} • ${panchang['tithi']}',
            mainText:
                'Tithi: ${panchang['tithi']}\nRahu Kaal: ${panchang['rahuKaal']}\n\nFor detailed muhurat and city-specific timings, please consult your astrologer.',
          ),
          const SizedBox(height: 16),

          // Lucky Color & Number card
          _buildShareCard(
            context: context,
            tag: 'Lucky Color & Number',
            title: AppStrings.getString(context, 'luckyColor', fallback: 'Lucky Color'),
            mainText:
                '${_luckyColor()} • ${AppStrings.getString(context, 'luckyNumber', fallback: 'Lucky Number')}: ${_luckyNumber()}',
          ),
          const SizedBox(height: 16),

          // Zodiac message card (simple generic)
          _buildShareCard(
            context: context,
            tag: 'Zodiac Message',
            title: AppStrings.getString(context, 'dailyHoroscope', fallback: 'Daily Horoscope'),
            mainText:
                'Stars are supporting inner growth today. Take one small action towards your dreams and trust your journey.',
          ),
        ],
      ),
    );
  }

  Widget _buildShareCard({
    required BuildContext context,
    required String tag,
    required String title,
    required String mainText,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF2C1A4D), const Color(0xFF4A2B6F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tag,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: () async {
                  final shareText = '$tag\n\n$title\n$mainText\n\n— Sent from PanditTalk app';
                  await Share.share(shareText);
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            mainText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}


