import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/theme.dart';
import '../models/user_day_summary.dart';
import '../models/booking.dart';
import '../providers/booking_provider.dart';
import '../providers/user_provider.dart';
import '../services/kundali_service.dart';
import '../services/auth_service.dart';
import '../screens/services/daily_horoscope_screen.dart';
import '../screens/bookings/bookings_history_screen.dart';
import '../screens/calendar/calendar_screen.dart';
import '../screens/features/shareable_cards_screen.dart';
import '../utils/app_strings.dart';

class PersonalizedDashboard extends StatefulWidget {
  final String? userZodiacSign;

  const PersonalizedDashboard({Key? key, this.userZodiacSign}) : super(key: key);

  @override
  _PersonalizedDashboardState createState() => _PersonalizedDashboardState();
}

class _PersonalizedDashboardState extends State<PersonalizedDashboard> {
  UserDaySummary? _daySummary;
  List<Booking> _upcomingBookings = [];
  bool _loading = true;
  bool _isExpanded = false;
  DateTime? _joinDate;
  int _totalConsultations = 0;
  int _completedConsultations = 0;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _loading = true);

    try {
      // Load horoscope
      final zodiacSign = widget.userZodiacSign ?? 'aries';
      final horoscopeData = await KundaliService.getKundali(zodiacSign);

      // Load upcoming bookings
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
      final authService = AuthService();
      final token = await authService.getToken();
      
      final allBookings = await bookingProvider.fetchBookings(token);
      _totalConsultations = allBookings.length;
      _completedConsultations =
          allBookings.where((b) => b.status == 'COMPLETED').length;

      // Load or create local "join date" for journey timeline
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getString('user_join_date');
      final now = DateTime.now();
      if (stored == null) {
        _joinDate = now;
        await prefs.setString('user_join_date', now.toIso8601String());
      } else {
        try {
          _joinDate = DateTime.parse(stored);
        } catch (_) {
          _joinDate = now;
          await prefs.setString('user_join_date', now.toIso8601String());
        }
      }

      _upcomingBookings = allBookings
          .where((b) {
            try {
              final bookingTime = DateTime.parse(b.scheduledAt);
              return bookingTime.isAfter(now) && b.status != 'CANCELLED';
            } catch (e) {
              return false;
            }
          })
          .toList()
        ..sort((a, b) => DateTime.parse(a.scheduledAt).compareTo(DateTime.parse(b.scheduledAt)));
      _upcomingBookings = _upcomingBookings.take(3).toList();

      // Create day summary
      _daySummary = UserDaySummary(
        date: DateFormat('EEEE, MMMM d').format(DateTime.now()),
        zodiacSign: zodiacSign.toUpperCase(),
        horoscopeText: horoscopeData?['description'] ?? 'Loading...',
        luckyNumber: horoscopeData?['lucky_number'] ?? 7,
        luckyColor: horoscopeData?['color'] ?? 'Gold',
        mood: horoscopeData?['mood'] ?? 'Positive',
        auspiciousTime: horoscopeData?['lucky_time'],
        recommendations: [
          'Check your daily horoscope',
          'Consult with an astrologer',
          'Meditate for inner peace',
        ],
        upcomingConsultations: _upcomingBookings.length,
      );
    } catch (e) {
      debugPrint('Error loading dashboard: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Container(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator(color: AppTheme.primaryYellow)),
      );
    }

    if (_daySummary == null) {
      return SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryYellow.withOpacity(0.1), AppTheme.primaryYellow.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryYellow.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.wb_sunny, color: AppTheme.primaryYellow, size: 28),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.getString(context, 'yourDay', fallback: 'Your Day'),
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _daySummary!.date,
                      style: TextStyle(fontSize: 14, color: AppTheme.mediumGray),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                ),
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                color: AppTheme.primaryYellow,
              )
            ],
          ),
          if (_isExpanded) ...[
            SizedBox(height: 20),

            // Horoscope Preview
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DailyHoroscopeScreen()),
              ),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text('♈', style: TextStyle(fontSize: 24)),
                            SizedBox(width: 8),
                            Text(
                              '${_daySummary!.zodiacSign} Horoscope',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Icon(Icons.refresh, size: 20, color: AppTheme.primaryYellow),
                          onPressed: _loadDashboardData,
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      _daySummary!.horoscopeText.length > 150
                          ? '${_daySummary!.horoscopeText.substring(0, 150)}...'
                          : _daySummary!.horoscopeText,
                      style: TextStyle(fontSize: 14, height: 1.5),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tap to read full horoscope →',
                      style: TextStyle(fontSize: 12, color: AppTheme.primaryYellow, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Lucky Numbers & Colors
            Row(
              children: [
                Expanded(
                  child: _buildLuckyItem(
                    icon: Icons.stars,
                    label: 'Lucky Number',
                    value: '${_daySummary!.luckyNumber}',
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildLuckyItem(
                    icon: Icons.palette,
                    label: 'Lucky Color',
                    value: _daySummary!.luckyColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Journey Timeline (simple stats)
            if (_joinDate != null) ...[
              Text(
                AppStrings.getString(
                  context,
                  'yourJourney',
                  fallback: 'Your Journey',
                ),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6),
              Text(
                AppStrings.getStringWithParam(
                  context,
                  'journeySummary',
                  {
                    'date': DateFormat('MMM d, yyyy').format(_joinDate!),
                    'consultations': _totalConsultations.toString(),
                    'remedies': '0',
                    'wishes': '0',
                  },
                  fallback:
                      'You joined on ${DateFormat('MMM d, yyyy').format(_joinDate!)} and had $_totalConsultations consultations so far.',
                ),
                style: TextStyle(fontSize: 13, color: AppTheme.mediumGray),
              ),
              SizedBox(height: 16),
            ],

            // Upcoming Consultations
            if (_upcomingBookings.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.getString(context, 'upcomingConsultations', fallback: 'Upcoming Consultations'),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => BookingsHistoryScreen()),
                    ),
                    child: Text('View All', style: TextStyle(color: AppTheme.primaryYellow)),
                  ),
                ],
              ),
              SizedBox(height: 8),
              ..._upcomingBookings.map((booking) => _buildConsultationCard(booking)),
            ],

            // Recent Activity (placeholder)
            SizedBox(height: 16),
            Text(
              'Quick Actions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionCard(
                    icon: Icons.calendar_today,
                    label: AppStrings.getString(context, 'calendar', fallback: 'Calendar'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => CalendarScreen()),
                      );
                    },
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildQuickActionCard(
                    icon: Icons.share,
                    label: AppStrings.getString(context, 'shareableCards', fallback: 'Shareable Cards'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ShareableCardsScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLuckyItem({required IconData icon, required String label, required String value}) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: AppTheme.primaryYellow, size: 24),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
                          Text(
                            label == 'Lucky Number' 
                                ? AppStrings.getString(context, 'luckyNumber', fallback: 'Lucky Number')
                                : label == 'Lucky Color'
                                    ? AppStrings.getString(context, 'luckyColor', fallback: 'Lucky Color')
                                    : label,
                            style: TextStyle(fontSize: 12, color: AppTheme.mediumGray),
                          ),
        ],
      ),
    );
  }

  Widget _buildConsultationCard(Booking booking) {
    try {
      final bookingTime = DateTime.parse(booking.scheduledAt);
      final timeUntil = bookingTime.difference(DateTime.now());
      final hoursUntil = timeUntil.inHours;
      final minutesUntil = timeUntil.inMinutes % 60;

      return Container(
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.primaryYellow.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppTheme.primaryYellow.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  booking.pandit['username']?[0].toUpperCase() ?? 'P',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryYellow,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.pandit['username'] ?? 'Astrologer',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    DateFormat('MMM d, h:mm a').format(bookingTime),
                    style: TextStyle(fontSize: 12, color: AppTheme.mediumGray),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  hoursUntil > 0 ? '${hoursUntil}h ${minutesUntil}m' : '${minutesUntil}m',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryYellow,
                  ),
                ),
                Text(
                  'until',
                  style: TextStyle(fontSize: 10, color: AppTheme.mediumGray),
                ),
              ],
            ),
          ],
        ),
      );
    } catch (e) {
      return SizedBox.shrink();
    }
  }

  Widget _buildQuickActionCard({required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.primaryYellow, size: 28),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

