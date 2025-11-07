import 'package:flutter/material.dart';
import '../../utils/theme.dart';
import '../../services/kundali_service.dart';

class DailyHoroscopeScreen extends StatefulWidget {
  @override
  _DailyHoroscopeScreenState createState() => _DailyHoroscopeScreenState();
}

class _DailyHoroscopeScreenState extends State<DailyHoroscopeScreen> {
  String selectedSign = 'aries';
  Map<String, dynamic>? horoscopeData;
  bool loading = true;

  final zodiacSigns = [
    {'name': 'Aries', 'icon': '♈', 'value': 'aries'},
    {'name': 'Taurus', 'icon': '♉', 'value': 'taurus'},
    {'name': 'Gemini', 'icon': '♊', 'value': 'gemini'},
    {'name': 'Cancer', 'icon': '♋', 'value': 'cancer'},
    {'name': 'Leo', 'icon': '♌', 'value': 'leo'},
    {'name': 'Virgo', 'icon': '♍', 'value': 'virgo'},
    {'name': 'Libra', 'icon': '♎', 'value': 'libra'},
    {'name': 'Scorpio', 'icon': '♏', 'value': 'scorpio'},
    {'name': 'Sagittarius', 'icon': '♐', 'value': 'sagittarius'},
    {'name': 'Capricorn', 'icon': '♑', 'value': 'capricorn'},
    {'name': 'Aquarius', 'icon': '♒', 'value': 'aquarius'},
    {'name': 'Pisces', 'icon': '♓', 'value': 'pisces'},
  ];

  @override
  void initState() {
    super.initState();
    _loadHoroscope();
  }

  Future<void> _loadHoroscope() async {
    setState(() => loading = true);
    final data = await KundaliService.getKundali(selectedSign);
    setState(() {
      horoscopeData = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Horoscope'),
        backgroundColor: AppTheme.primaryYellow,
      ),
      body: Column(
        children: [
          // Zodiac selector
          Container(
            height: 100,
            padding: EdgeInsets.symmetric(vertical: 12),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 8),
              itemCount: zodiacSigns.length,
              itemBuilder: (ctx, i) {
                final sign = zodiacSigns[i];
                final isSelected = sign['value'] == selectedSign;
                return GestureDetector(
                  onTap: () {
                    setState(() => selectedSign = sign['value'] as String);
                    _loadHoroscope();
                  },
                  child: Container(
                    width: 70,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primaryYellow : AppTheme.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? AppTheme.primaryYellow : AppTheme.lightGray,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(sign['icon'] as String, style: TextStyle(fontSize: 28)),
                        SizedBox(height: 4),
                        Text(
                          sign['name'] as String,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Horoscope content
          Expanded(
            child: loading
                ? Center(child: CircularProgressIndicator(color: AppTheme.primaryYellow))
                : SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              horoscopeData?['current_date'] ?? '',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryYellow),
                            ),
                            SizedBox(height: 16),
                            Text(
                              horoscopeData?['description'] ?? 'Loading horoscope...',
                              style: TextStyle(fontSize: 15, height: 1.6),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

