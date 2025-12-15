import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '../screens/features/book_pooja_screen.dart';
import '../screens/features/support_chat_screen.dart';
import '../screens/features/wallet_screen.dart';
import '../screens/features/gift_card_screen.dart';
import '../screens/features/order_history_screen.dart';
import '../screens/features/astro_remedy_screen.dart';
import '../screens/features/blog_screen.dart';
import '../screens/features/chat_astrologers_screen.dart';
import '../screens/features/following_screen.dart';
import '../screens/features/free_services_screen.dart';
import '../screens/features/settings_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // User Profile Section
          Container(
            color: AppTheme.primaryYellow,
            padding: const EdgeInsets.only(top: 48, bottom: 24, left: 16, right: 16),
            child: Column(
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 32,
                      backgroundImage: NetworkImage(
                        'https://via.placeholder.com/150',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Himika',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.black,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.edit,
                                size: 16,
                                color: Colors.grey[700],
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '+91-9001096888',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppTheme.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuItem(
                  context,
                  Icons.home,
                  'Home',
                  () => Navigator.pop(context),
                ),
                _buildMenuItem(
                  context,
                  Icons.light,
                  'Book a Pooja',
                  () => _navigate(context, const BookPoojaScreen()),
                  showNew: true,
                ),
                _buildMenuItem(
                  context,
                  Icons.headset_mic,
                  'Customer Support Chat',
                  () => _navigate(context, const SupportChatScreen()),
                ),
                _buildMenuItem(
                  context,
                  Icons.account_balance_wallet,
                  'Wallet Transactions',
                  () => _navigate(context, const WalletScreen()),
                ),
                _buildMenuItem(
                  context,
                  Icons.card_giftcard,
                  'Redeem Gift Card',
                  () => _navigate(context, const GiftCardScreen()),
                ),
                _buildMenuItem(
                  context,
                  Icons.history,
                  'Order History',
                  () => _navigate(context, const OrderHistoryScreen()),
                ),
                _buildMenuItem(
                  context,
                  Icons.shopping_bag,
                  'AstroRemedy',
                  () => _navigate(context, const AstroRemedyScreen()),
                ),
                _buildMenuItem(
                  context,
                  Icons.menu_book,
                  'Astrology Blog',
                  () => _navigate(context, const BlogScreen()),
                ),
                _buildMenuItem(
                  context,
                  Icons.chat_bubble,
                  'Chat with Astrologers',
                  () => _navigate(context, const ChatAstrologersScreen()),
                ),
                _buildMenuItem(
                  context,
                  Icons.favorite,
                  'My Following',
                  () => _navigate(context, const FollowingScreen()),
                ),
                _buildMenuItem(
                  context,
                  Icons.card_giftcard_outlined,
                  'Free Services',
                  () => _navigate(context, const FreeServicesScreen()),
                ),
                _buildMenuItem(
                  context,
                  Icons.settings,
                  'Settings',
                  () => _navigate(context, const SettingsScreen()),
                ),
              ],
            ),
          ),

          // Also Available On Section
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Also available on',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildSocialIcon(Icons.apple, Colors.black),
                    _buildSocialIcon(Icons.language, Colors.green),
                    _buildSocialIcon(Icons.play_arrow, Colors.red),
                    _buildSocialIcon(Icons.facebook, Colors.blue),
                    Container(
                      width: 32,
                      height: 32,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.purple, Colors.orange],
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(Icons.camera_alt,
                          size: 18, color: Colors.white),
                    ),
                    _buildSocialIcon(Icons.business, Colors.blue[900]!),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Version 1.1.402',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool showNew = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryYellow, size: 24),
      title: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              color: AppTheme.black,
            ),
          ),
          if (showNew) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'New',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }

  Widget _buildSocialIcon(IconData icon, Color color) {
    return Container(
      width: 32,
      height: 32,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(icon, size: 18, color: Colors.white),
    );
  }

  void _navigate(BuildContext context, Widget screen) {
    Navigator.pop(context); // Close drawer
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }
}
