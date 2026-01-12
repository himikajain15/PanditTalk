import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/theme.dart';
import '../../models/pandit.dart';
import '../../providers/booking_provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/app_strings.dart';
import '../../utils/theme.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/personalized_dashboard.dart';
import '../booking/booking_screen.dart';
import '../call/call_screen.dart';
import '../calendar/calendar_screen.dart';
import '../chat/chat_list_screen.dart';
import '../consultation/pandits_list_screen.dart';
import '../payments/payment_screen.dart';
import '../profile/profile_screen.dart';
import '../referral/referral_screen.dart';
import '../services/astrology_blog_screen.dart';
import '../services/daily_horoscope_screen.dart';
import '../services/free_kundli_screen.dart';
import '../services/kundli_matching_screen.dart';
import '../services/palmistry_screen.dart';
import '../services/tarot_card_screen.dart';
import '../testimonials/testimonials_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  List<Pandit> _livePandits = [];
  List<Pandit> _celebrityPandits = [];
  bool _loading = true;
  int _streakDays = 0;
  DateTime? _lastCheckIn;

  late final PageController _promoPageController;
  int _currentPromoIndex = 0;
  Timer? _promoTimer;

  @override
  void initState() {
    super.initState();
    _promoPageController = PageController();
    _startPromoAutoScroll();
    _loadPandits();
    _loadStreak();
  }

  @override
  void dispose() {
    _promoTimer?.cancel();
    _promoPageController.dispose();
    super.dispose();
  }

  void _startPromoAutoScroll() {
    _promoTimer?.cancel();
    _promoTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted) return;
      final nextPage = (_currentPromoIndex + 1) % 2;
      setState(() {
        _currentPromoIndex = nextPage;
      });
      _promoPageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  Future<void> _loadPandits() async {
    final bp = Provider.of<BookingProvider>(context, listen: false);
    final pandits = await bp.fetchPandits();
    setState(() {
      _livePandits = pandits.where((p) => p.isOnline).toList();
      // Mark some as celebrity for display
      _celebrityPandits = pandits.take(3).toList();
      _loading = false;
    });
  }

  Future<void> _loadStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final last = prefs.getString('daily_checkin_date');
    final streak = prefs.getInt('daily_checkin_streak') ?? 0;
    DateTime? lastDate;
    if (last != null) {
      try {
        lastDate = DateTime.parse(last);
      } catch (_) {}
    }
    setState(() {
      _lastCheckIn = lastDate;
      _streakDays = streak;
    });
  }

  Future<void> _checkInToday() async {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final last = _lastCheckIn != null
        ? DateTime(_lastCheckIn!.year, _lastCheckIn!.month, _lastCheckIn!.day)
        : null;

    int newStreak;
    if (last == null) {
      newStreak = 1;
    } else if (todayDate.difference(last).inDays == 0) {
      // already checked in today
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You already checked in today!')),
      );
      return;
    } else if (todayDate.difference(last).inDays == 1) {
      newStreak = _streakDays + 1;
    } else {
      newStreak = 1;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('daily_checkin_date', todayDate.toIso8601String());
    await prefs.setInt('daily_checkin_streak', newStreak);

    setState(() {
      _lastCheckIn = todayDate;
      _streakDays = newStreak;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Checked in! Current streak: $newStreak days')),
    );
  }


  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    
    setState(() => _selectedIndex = index);
    
    switch (index) {
      case 0:
        // Already on home
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (_) => ChatListScreen()));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (_) => CallScreen()));
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppTheme.lightGray,
      drawer: AppDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(user, context),

              // Search Bar
              _buildSearchBar(),

              // Promo carousel (Freebie + Cashback)
              _buildPromoCarousel(),

              // Personalized Dashboard (Your Day)
              PersonalizedDashboard(userZodiacSign: 'aries'), // TODO: Get from user profile
              
              // Daily Check-in / Streaks
              _buildDailyCheckInCard(),
              
              // Quick Action Icons
              _buildQuickActions(),
              
              // Celebrity Section
              if (!_loading && _celebrityPandits.isNotEmpty)
                _buildCelebritySection(),
              
              // Live Astrologers Section
              if (!_loading && _livePandits.isNotEmpty)
                _buildLiveAstrologers(),
              
              // Chat/Call Buttons
              _buildChatCallButtons(),
              
              SizedBox(height: 80), // Space for bottom nav
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: _buildFloatingActions(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildDailyCheckInCard() {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final checkedInToday = _lastCheckIn != null &&
        DateTime(_lastCheckIn!.year, _lastCheckIn!.month, _lastCheckIn!.day)
                .difference(todayDate)
                .inDays ==
            0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primaryYellow.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Center(child: Text('🔥', style: TextStyle(fontSize: 22))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Check-in',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  checkedInToday
                      ? 'You’ve checked in today. Current streak: $_streakDays days.'
                      : 'Tap to check-in and grow your streak! Current streak: $_streakDays days.',
                  style: TextStyle(fontSize: 12, color: AppTheme.mediumGray),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: checkedInToday ? null : _checkInToday,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryYellow,
              foregroundColor: AppTheme.black,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: Text(
              checkedInToday ? 'Done' : 'Check-in',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(user, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: AppTheme.white,
      child: Row(
        children: [
          // Hamburger menu with profile pic
          InkWell(
            onTap: () => _scaffoldKey.currentState?.openDrawer(),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppTheme.primaryYellow,
                  child: Text(
                    user?.username?[0].toUpperCase() ?? 'U',
                    style: TextStyle(color: AppTheme.black, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: AppTheme.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.menu, size: 11, color: AppTheme.black),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          // Greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.getStringWithParam(
                    context,
                    'hi',
                    {'name': user?.username ?? 'User'},
                    fallback: 'Hi ${user?.username ?? 'User'}',
                  ),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          // Language selector (compact)
          _buildLanguageSelector(context),
          SizedBox(width: 8),
          // Small Add Cash button
          TextButton.icon(
            onPressed: () => _showRechargeDialog(context),
            style: TextButton.styleFrom(
              backgroundColor: AppTheme.primaryYellow,
              foregroundColor: AppTheme.black,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              minimumSize: Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            icon: Icon(Icons.account_balance_wallet, size: 16),
            label: Text(
              AppStrings.getString(context, 'addCash', fallback: 'Add Cash'),
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, langProvider, _) {
        final currentLang = langProvider.locale.languageCode;
        final currentLangData = LanguageProvider.supportedLanguages.firstWhere(
          (l) => l['code'] == currentLang,
          orElse: () => LanguageProvider.supportedLanguages[0],
        );

        return PopupMenuButton<String>(
          icon: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.primaryYellow.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  (currentLangData['code'] ?? currentLang).toUpperCase(),
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.black),
                ),
                SizedBox(width: 4),
                Icon(Icons.arrow_drop_down, size: 16, color: AppTheme.black),
              ],
            ),
          ),
          onSelected: (String code) {
            langProvider.setLanguage(Locale(code));
          },
          itemBuilder: (BuildContext context) {
            return LanguageProvider.supportedLanguages.map((lang) {
              return PopupMenuItem<String>(
                value: lang['code'],
                child: Row(
                  children: [
                    Text(
                      lang['code']!.toUpperCase(),
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8),
                    Text(lang['name']!),
                    if (lang['code'] == currentLang)
                      Spacer(),
                    if (lang['code'] == currentLang)
                      Icon(Icons.check, color: AppTheme.primaryYellow, size: 18),
                  ],
                ),
              );
            }).toList();
          },
        );
      },
    );
  }

  void _showRechargeDialog(BuildContext context) {
    final amounts = [200, 500, 1000, 2000, 3000, 4000, 8000, 15000];
    final extras = [100, 40, 20, 10, 10, 12, 12, 15];
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Container(
        padding: EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Green header
            Container(
              padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.percent, color: Colors.white),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Get 100% Cashback on your First recharge',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            
            // Title
            Text(
              'Recharge Now',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            
            // Tip
            Row(
                  children: [
                Icon(Icons.lightbulb, color: AppTheme.primaryYellow, size: 16),
                SizedBox(width: 6),
                Text(
                  'Tip: 90% users recharge for 10 mins or more',
                  style: TextStyle(fontSize: 12, color: AppTheme.mediumGray),
                ),
              ],
            ),
            SizedBox(height: 20),
            
            // Recharge options
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: amounts.length,
                itemBuilder: (ctx, i) {
                  return OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: i == 0 ? AppTheme.primaryYellow : AppTheme.mediumGray),
                      backgroundColor: i == 0 ? AppTheme.primaryYellow.withOpacity(0.1) : null,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '₹${amounts[i]}',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.black),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${extras[i]}% Extra',
                          style: TextStyle(fontSize: 11, color: Colors.green),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            
            // Proceed button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryYellow,
                  foregroundColor: AppTheme.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                      child: Text(
                  'Proceed to Pay',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
    );
  }

  Widget _buildSearchBar() {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/pandits'),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
        child: Row(
          children: [
            Icon(Icons.search, color: AppTheme.mediumGray),
            SizedBox(width: 12),
            Text(
              AppStrings.getString(context, 'searchAstrologers', fallback: 'Search astrologers...'),
              style: TextStyle(color: AppTheme.mediumGray, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {
        'icon': Icons.wb_sunny,
        'labelKey': 'dailyHoroscopeLabel',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => DailyHoroscopeScreen())),
      },
      {
        'icon': Icons.auto_graph,
        'labelKey': 'freeKundliLabel',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => FreeKundliScreen())),
      },
      {
        'icon': Icons.favorite,
        'labelKey': 'kundliMatchingLabel',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => KundliMatchingScreen())),
      },
      {
        'icon': Icons.article,
        'labelKey': 'astrologyBlogLabel',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => AstrologyBlogScreen())),
      },
      {
        'icon': Icons.pan_tool,
        'labelKey': 'palmistryLabel',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => PalmistryScreen())),
      },
      {
        'icon': Icons.style,
        'labelKey': 'tarotLabel',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => TarotCardScreen())),
      },
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: AppTheme.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: actions.map((action) {
          return InkWell(
            onTap: action['onTap'] as VoidCallback,
            borderRadius: BorderRadius.circular(40),
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryYellow,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(action['icon'] as IconData, color: AppTheme.black, size: 28),
                ),
                SizedBox(height: 6),
                Text(
                  AppStrings.getString(
                    context,
                    action['labelKey'] as String,
                    fallback: '',
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, height: 1.2),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }


  Widget _buildCashbackBanner() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
          colors: [Color(0xFF2C1A4D), Color(0xFF4A2B6F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
            children: [
          Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.getString(context, 'cashback100', fallback: '100% CASHBACK!'),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                SizedBox(height: 4),
                Text(
                  AppStrings.getString(context, 'onYourFirstRecharge', fallback: 'on your first recharge'),
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => _showRechargeDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryYellow,
                    foregroundColor: AppTheme.black,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  ),
                  child: Text(
                    AppStrings.getString(context, 'rechargeNow', fallback: 'RECHARGE NOW'),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Text('💰', style: TextStyle(fontSize: 60)),
        ],
      ),
    );
  }

  Widget _buildFreebieBanner() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.getString(context, 'registerForFreebie', fallback: 'Register for Freebie'),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.black),
                ),
                SizedBox(height: 6),
                Text(
                  AppStrings.getString(context, 'first1000UsersGetFreebie', fallback: 'First 1000 users get a freebie!'),
                  style: TextStyle(fontSize: 13, color: AppTheme.mediumGray),
                ),
                SizedBox(height: 8),
                Text(
                  AppStrings.getString(context, 'loginAndRegisterNow', fallback: 'Login and register now to claim your welcome gift before the slots run out.'),
                  style: TextStyle(fontSize: 12, color: AppTheme.mediumGray),
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/ruby-registration'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryYellow,
                    foregroundColor: AppTheme.black,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: Text(
                    AppStrings.getString(context, 'registerNow', fallback: 'Register Now'),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          Text('🎁', style: TextStyle(fontSize: 42)),
        ],
      ),
    );
  }

  Widget _buildPromoCarousel() {
    return Column(
      children: [
        SizedBox(
          height: 220,
          child: PageView(
            controller: _promoPageController,
            onPageChanged: (index) {
              setState(() {
                _currentPromoIndex = index;
              });
            },
            children: [
              _buildFreebieBanner(),
              _buildCashbackBanner(),
            ],
          ),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(2, (index) {
            final isActive = index == _currentPromoIndex;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _currentPromoIndex = index;
                });
                _promoPageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: Container(
                width: isActive ? 10 : 6,
                height: isActive ? 10 : 6,
                margin: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: isActive ? AppTheme.primaryYellow : AppTheme.mediumGray.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildCelebritySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.getString(context, 'celebrityAstrologers', fallback: 'Celebrity Astrologers'),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/pandits'),
                child: Text(
                  AppStrings.getString(context, 'viewAll', fallback: 'View All'),
                  style: TextStyle(color: AppTheme.primaryYellow),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 12),
            itemCount: _celebrityPandits.length,
            itemBuilder: (ctx, i) {
              final pandit = _celebrityPandits[i];
              return _buildCelebrityCard(pandit);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCelebrityCard(Pandit pandit) {
    return Container(
      width: 220,
      margin: EdgeInsets.symmetric(horizontal: 4),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                    color: AppTheme.lightYellow,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Center(
                    child: CircleAvatar(
                      radius: 45,
                      backgroundColor: AppTheme.primaryYellow.withOpacity(0.3),
                      child: Text(
                        pandit.username[0].toUpperCase(),
                        style: TextStyle(fontSize: 36, color: AppTheme.primaryYellow, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryYellow,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      AppStrings.getString(context, 'celebrity', fallback: '⭐ Celebrity'),
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.black),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pandit.username,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    pandit.expertise,
                    style: TextStyle(fontSize: 12, color: AppTheme.mediumGray),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, size: 14, color: Colors.amber),
                      SizedBox(width: 4),
                      Text('${pandit.rating}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      SizedBox(width: 8),
                      Text('${pandit.experienceYears} yrs', style: TextStyle(fontSize: 12, color: AppTheme.mediumGray)),
                    ],
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BookingScreen(pandit: pandit))),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryYellow,
                      foregroundColor: AppTheme.black,
                      minimumSize: Size.fromHeight(36),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      '${AppStrings.getString(context, "chatNow", fallback: "Chat Now")} • ₹${pandit.feePerMinute}${AppStrings.getString(context, "perMinute", fallback: "/min")}',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveAstrologers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.5),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              Text(
                AppStrings.getStringWithParam(
                  context,
                  'astrologersLive',
                  {'count': _livePandits.length.toString()},
                  fallback: '${_livePandits.length} Astrologers Live',
                ),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/pandits'),
                child: Text(
                  AppStrings.getString(context, 'viewAll', fallback: 'View All'),
                  style: TextStyle(color: AppTheme.primaryYellow),
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 12),
          itemCount: _livePandits.length > 5 ? 5 : _livePandits.length,
          itemBuilder: (ctx, i) {
            final pandit = _livePandits[i];
            return _buildPanditCard(pandit);
          },
        ),
      ],
    );
  }

  Widget _buildPanditCard(Pandit pandit) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            // Avatar
            Stack(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: AppTheme.primaryYellow.withOpacity(0.2),
                  child: Text(
                    pandit.username[0].toUpperCase(),
                    style: TextStyle(fontSize: 24, color: AppTheme.primaryYellow, fontWeight: FontWeight.bold),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 12),
            
            // Info
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          pandit.username,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(Icons.verified, size: 16, color: Colors.green),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    pandit.expertise,
                    style: TextStyle(fontSize: 13, color: AppTheme.mediumGray),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    pandit.languages.join(', '),
                    style: TextStyle(fontSize: 12, color: AppTheme.mediumGray),
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Text('Exp: ${pandit.experienceYears} Years', style: TextStyle(fontSize: 12)),
                      Spacer(),
                      Text(
                        '₹${pandit.feePerMinute}/min',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      ...List.generate(5, (i) => Icon(Icons.star, size: 14, color: Colors.amber)),
                      SizedBox(width: 8),
                      Text('${(pandit.rating * 1000).toInt()} orders', style: TextStyle(fontSize: 11, color: AppTheme.mediumGray)),
                    ],
              ),
            ],
          ),
            ),
            SizedBox(width: 12),
            
            // Chat Button
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BookingScreen(pandit: pandit))),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Text('Chat', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatCallButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatListScreen())),
              icon: Icon(Icons.chat_bubble),
              label: Text(
                AppStrings.getString(context, 'chatWithAstrologer', fallback: 'Chat with Astrologer'),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryYellow,
                foregroundColor: AppTheme.black,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CallScreen())),
              icon: Icon(Icons.call),
              label: Text(
                AppStrings.getString(context, 'callWithAstrologer', fallback: 'Call with Astrologer'),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryYellow,
                foregroundColor: AppTheme.black,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget? _buildFloatingActions() {
    return null; // Using bottom buttons instead
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      selectedItemColor: AppTheme.black,
      unselectedItemColor: AppTheme.mediumGray,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppTheme.white,
      elevation: 8,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: AppStrings.getString(context, 'home', fallback: 'Home'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          label: AppStrings.getString(context, 'chat', fallback: 'Chat'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.call),
          label: AppStrings.getString(context, 'call', fallback: 'Call'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: AppStrings.getString(context, 'profile', fallback: 'Profile'),
        ),
      ],
    );
  }
}
