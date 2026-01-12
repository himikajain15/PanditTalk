import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import 'edit_profile_screen.dart';
import '../../utils/theme.dart';
import '../wallet/wallet_screen.dart';
import '../bookings/bookings_history_screen.dart';
import '../settings/settings_screen.dart';
import 'rate_us_screen.dart';
import 'help_support_screen.dart';
import '../../utils/app_strings.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProv = Provider.of<UserProvider>(context);
    final user = userProv.user;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.getString(context, 'profile', fallback: 'Profile')),
        backgroundColor: AppTheme.primaryYellow,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: user == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_off, size: 64, color: AppTheme.mediumGray),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.getString(context, 'notLoggedIn', fallback: 'Not logged in'),
                    style: TextStyle(fontSize: 18, color: AppTheme.mediumGray),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                    child: Text(AppStrings.getString(context, 'login', fallback: 'Login')),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Profile Header
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppTheme.primaryYellow, AppTheme.darkYellow],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: AppTheme.white,
                          child: Text(
                            user.username.isNotEmpty ? user.username[0].toUpperCase() : "U",
                            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppTheme.black),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          user.username,
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.black),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          user.email,
                          style: TextStyle(fontSize: 14, color: AppTheme.black.withOpacity(0.8)),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppTheme.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                    children: [
                              Icon(Icons.stars, color: AppTheme.black),
                              const SizedBox(width: 8),
                              Text(
                                "${user.karmaPoints} Karma Points",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.black),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Menu Items
                  const SizedBox(height: 16),
                  _buildMenuItem(
                    context,
                    icon: Icons.account_balance_wallet,
                    title: AppStrings.getString(context, 'myWallet', fallback: 'My Wallet'),
                    subtitle: AppStrings.getString(context, 'addMoneyViewTransactions', fallback: 'Add money, view transactions'),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => WalletScreen())),
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.history,
                    title: AppStrings.getString(context, 'bookingHistory', fallback: 'Booking History'),
                    subtitle: AppStrings.getString(context, 'viewAllYourBookings', fallback: 'View all your bookings'),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BookingsHistoryScreen())),
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.edit,
                    title: AppStrings.getString(context, 'editProfile', fallback: 'Edit Profile'),
                    subtitle: AppStrings.getString(context, 'updateYourInformation', fallback: 'Update your information'),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EditProfileScreen())),
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.settings,
                    title: AppStrings.getString(context, 'settings', fallback: 'Settings'),
                    subtitle: AppStrings.getString(context, 'notificationsPrivacyMore', fallback: 'Notifications, privacy & more'),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen())),
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.help_outline,
                    title: AppStrings.getString(context, 'helpSupport', fallback: 'Help & Support'),
                    subtitle: AppStrings.getString(context, 'getHelpWithYourAccount', fallback: 'Get help with your account'),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HelpSupportScreen())),
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.star_rate,
                    title: AppStrings.getString(context, 'rateUs', fallback: 'Rate Us'),
                    subtitle: AppStrings.getString(context, 'shareYourFeedback', fallback: 'Share your feedback'),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RateUsScreen())),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showLogoutDialog(context, userProv);
                      },
                    icon: Icon(Icons.logout),
                    label: Text(AppStrings.getString(context, 'logout', fallback: 'Logout')),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        minimumSize: Size.fromHeight(50),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.primaryYellow.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppTheme.primaryYellow),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 13, color: AppTheme.mediumGray)),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: AppTheme.mediumGray),
        onTap: onTap,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, UserProvider userProv) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppStrings.getString(context, 'logout', fallback: 'Logout')),
        content: Text(AppStrings.getString(context, 'areYouSureLogout', fallback: 'Are you sure you want to logout?')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppStrings.getString(context, 'cancel', fallback: 'Cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
                      userProv.logout();
                      Navigator.pushReplacementNamed(context, '/login');
                    },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(AppStrings.getString(context, 'logout', fallback: 'Logout')),
          ),
                ],
      ),
    );
  }
}
