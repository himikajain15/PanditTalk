import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../utils/theme.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/chat/chat_list_screen.dart';
import '../screens/profile/rate_us_screen.dart';
import '../screens/profile/help_support_screen.dart';
import '../screens/services/daily_horoscope_screen.dart';
import '../screens/services/free_kundli_screen.dart';
import '../screens/services/kundli_matching_screen.dart';
import '../screens/services/astrology_blog_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // User Header
          Container(
            padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
            color: AppTheme.white,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: AppTheme.primaryYellow,
                  child: Text(
                    user?.username?[0].toUpperCase() ?? 'U',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.black),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            user?.username ?? 'User',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 8),
                          InkWell(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EditProfileScreen())),
                            child: Icon(Icons.edit, size: 16, color: AppTheme.primaryYellow),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        user?.phone ?? user?.email ?? '',
                        style: TextStyle(fontSize: 13, color: AppTheme.mediumGray),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: AppTheme.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

           // Menu Items
           _buildMenuItem(Icons.home, 'Home', () => Navigator.pop(context)),
           _buildMenuItemWithBadge(Icons.card_giftcard, 'Book a Pooja', 'New', () {
             Navigator.pop(context);
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pooja booking coming soon!')));
           }, Colors.red),
           _buildMenuItem(Icons.support_agent, 'Customer Support Chat', () {
             Navigator.pop(context);
             Navigator.push(context, MaterialPageRoute(builder: (_) => HelpSupportScreen()));
           }),
           _buildMenuItem(Icons.account_balance_wallet, 'Wallet Transactions', () {
             Navigator.pop(context);
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Wallet transactions coming soon!')));
           }),
           _buildMenuItem(Icons.card_giftcard, 'Redeem Gift Card', () {
             Navigator.pop(context);
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gift card redemption coming soon!')));
           }),
           _buildMenuItem(Icons.history, 'Order History', () {
             Navigator.pop(context);
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order history coming soon!')));
           }),
           _buildMenuItem(Icons.shopping_bag, 'AstroRemedy', () {
             Navigator.pop(context);
             Navigator.push(context, MaterialPageRoute(builder: (_) => DailyHoroscopeScreen()));
           }),
           _buildMenuItem(Icons.article, 'Astrology Blog', () {
             Navigator.pop(context);
             Navigator.push(context, MaterialPageRoute(builder: (_) => AstrologyBlogScreen()));
           }),
           _buildMenuItem(Icons.chat_bubble, 'Chat with Astrologers', () {
             Navigator.pop(context);
             Navigator.push(context, MaterialPageRoute(builder: (_) => ChatListScreen()));
           }),
           _buildMenuItem(Icons.person_add, 'My Following', () {
             Navigator.pop(context);
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Following list coming soon!')));
           }),
           _buildMenuItem(Icons.card_membership, 'Free Services', () {
             Navigator.pop(context);
             Navigator.push(context, MaterialPageRoute(builder: (_) => FreeKundliScreen()));
           }),
           _buildMenuItem(Icons.settings, 'Settings', () {
             Navigator.pop(context);
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Settings coming soon!')));
           }),

          Divider(height: 32, thickness: 1),

          // App Availability
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Also available on',
                  style: TextStyle(fontSize: 13, color: AppTheme.mediumGray),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    _buildSocialIcon(Icons.apple),
                    _buildSocialIcon(Icons.language),
                    _buildSocialIcon(Icons.play_arrow),
                    _buildSocialIcon(Icons.facebook),
                    _buildSocialIcon(Icons.camera_alt),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  'Version 1.1.0',
                  style: TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.mediumGray, size: 22),
      title: Text(title, style: TextStyle(fontSize: 15)),
      onTap: onTap,
      dense: true,
    );
  }

  Widget _buildMenuItemWithBadge(IconData icon, String title, String badge, VoidCallback onTap, Color badgeColor) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.mediumGray, size: 22),
      title: Row(
        children: [
          Text(title, style: TextStyle(fontSize: 15)),
          SizedBox(width: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              badge,
              style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      onTap: onTap,
      dense: true,
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      margin: EdgeInsets.only(right: 12),
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: AppTheme.lightGray,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 18, color: AppTheme.mediumGray),
    );
  }
}

