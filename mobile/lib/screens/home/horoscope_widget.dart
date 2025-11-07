import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/horoscope.dart';
import '../../utils/theme.dart';

/// Minimal daily horoscope widget that fetches today's horoscope for a given sign.
/// If backend not available, shows a gentle fallback message.
class HoroscopeWidget extends StatefulWidget {
  final String zodiacSign;
  HoroscopeWidget({required this.zodiacSign});

  @override
  _HoroscopeWidgetState createState() => _HoroscopeWidgetState();
}

class _HoroscopeWidgetState extends State<HoroscopeWidget> {
  Horoscope? _horoscope;
  bool _loading = true;
  final ApiService api = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchHoroscope();
  }

  Future<void> _fetchHoroscope() async {
    setState(() => _loading = true);
    final today = DateTime.now();
    final dateStr = "${today.year.toString().padLeft(4,'0')}-${today.month.toString().padLeft(2,'0')}-${today.day.toString().padLeft(2,'0')}";
    final res = await api.get('/api/horoscope/?zodiac=${widget.zodiacSign}&date=$dateStr');
    if (res is List && res.isNotEmpty) {
      setState(() {
        _horoscope = Horoscope.fromJson(res[0]);
        _loading = false;
      });
    } else if (res is Map && res.containsKey('results') && (res['results'] as List).isNotEmpty) {
      setState(() {
        _horoscope = Horoscope.fromJson(res['results'][0]);
        _loading = false;
      });
    } else {
      // fallback generic
      setState(() {
        _horoscope = Horoscope(id: 0, zodiacSign: widget.zodiacSign, date: dateStr, prediction: "Today is a day of small wins — stay mindful and kind.");
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _loading
            ? Center(child: CircularProgressIndicator(color: AppTheme.saffron))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.auto_awesome, color: AppTheme.deepSaffron),
                      SizedBox(width: 8),
                      Text("${widget.zodiacSign} • Today", style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.deepSaffron)),
                      Spacer(),
                      Text(_horoscope?.date ?? "", style: TextStyle(color: Colors.black54, fontSize: 12)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(_horoscope?.prediction ?? "No horoscope available.", style: TextStyle(fontSize: 15)),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _fetchHoroscope,
                      child: Text("Refresh", style: TextStyle(color: AppTheme.saffron)),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
