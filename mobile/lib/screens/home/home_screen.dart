import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/theme.dart';
import '../../providers/user_provider.dart';
import '../../providers/booking_provider.dart';
import '../../providers/language_provider.dart';
import '../../models/pandit.dart';
import '../chat/chat_list_screen.dart';
import '../call/call_screen.dart';
import '../profile/profile_screen.dart';
import '../booking/booking_screen.dart';
import '../../widgets/app_drawer.dart';
import '../services/daily_horoscope_screen.dart';
import '../services/free_kundli_screen.dart';
import '../services/kundli_matching_screen.dart';
import '../services/astrology_blog_screen.dart';
import '../payments/payment_screen.dart';
import '../consultation/pandits_list_screen.dart';

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

  @override
  void initState() {
    super.initState();
    _loadPandits();
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
              
              // Quick Action Icons
              _buildQuickActions(),
              
              // Cashback Banner
              _buildCashbackBanner(),
              
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

  Widget _buildHeader(user, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: AppTheme.white,
      child: Column(
        children: [
          // Top row: Profile, Name, Actions
          Row(
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi ${user?.username ?? 'User'}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Language Selector
              _buildLanguageSelector(context),
              SizedBox(width: 8),
              // Support Icon
              IconButton(
                icon: Icon(Icons.support_agent, color: AppTheme.primaryYellow),
                onPressed: () {},
                iconSize: 22,
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
            ],
          ),
          SizedBox(height: 8),
          // Bottom row: Add Cash Button (full width)
          SizedBox(
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.primaryYellow,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryYellow.withOpacity(0.3),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _showRechargeDialog(context),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.account_balance_wallet, size: 18, color: AppTheme.black),
                        SizedBox(width: 8),
                        Text(
                          'Add Cash to Wallet',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
                Text(currentLangData['flag']!, style: TextStyle(fontSize: 16)),
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
                    Text(lang['flag']!, style: TextStyle(fontSize: 20)),
                    SizedBox(width: 12),
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
    return Container(
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
            'Search astrologers...',
            style: TextStyle(color: AppTheme.mediumGray, fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {
        'icon': Icons.wb_sunny,
        'label': 'Daily\nHoroscope',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => DailyHoroscopeScreen())),
      },
      {
        'icon': Icons.auto_graph,
        'label': 'Free\nKundli',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => FreeKundliScreen())),
      },
      {
        'icon': Icons.favorite,
        'label': 'Kundli\nMatching',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => KundliMatchingScreen())),
      },
      {
        'icon': Icons.article,
        'label': 'Astrology\nBlog',
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => AstrologyBlogScreen())),
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
                  action['label'] as String,
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
                  '100% CASHBACK!',
                            style: TextStyle(
                    color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'on your first recharge',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to payment screen with wallet recharge
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text('Add Money to Wallet'),
                        content: TextField(
                          decoration: InputDecoration(
                            labelText: 'Enter Amount',
                            prefixText: '₹',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          onSubmitted: (value) {
                            final amount = double.tryParse(value);
                            if (amount != null && amount > 0) {
                              Navigator.pop(ctx);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PaymentScreen(
                                    bookingId: 0, // 0 indicates wallet recharge
                                    amount: amount,
                                    isWalletRecharge: true,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: Text('Cancel'),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryYellow,
                    foregroundColor: AppTheme.black,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  ),
                  child: Text('RECHARGE NOW', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          Text('💰', style: TextStyle(fontSize: 60)),
        ],
      ),
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
                'Celebrity Astrologers',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/pandits'),
                child: Text('View All', style: TextStyle(color: AppTheme.primaryYellow)),
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
                      '⭐ Celebrity',
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
                    child: Text('Chat Now • ₹${pandit.feePerMinute}/min', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
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
                '${_livePandits.length} Astrologers Live',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/pandits'),
                child: Text('View All', style: TextStyle(color: AppTheme.primaryYellow)),
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
              label: Text('Chat with Astrologer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryYellow,
                foregroundColor: AppTheme.black,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CallScreen())),
              icon: Icon(Icons.call),
              label: Text('Call with Astrologer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryYellow,
                foregroundColor: AppTheme.black,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
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
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
        BottomNavigationBarItem(icon: Icon(Icons.call), label: 'Call'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
