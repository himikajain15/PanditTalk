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

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProv = Provider.of<UserProvider>(context);
    final user = userProv.user;

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: AppTheme.primaryYellow,
        automaticallyImplyLeading: false,
      ),
      body: user == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_off, size: 64, color: AppTheme.mediumGray),
                  const SizedBox(height: 16),
                  Text("Not logged in", style: TextStyle(fontSize: 18, color: AppTheme.mediumGray)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                    child: Text("Login"),
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
                    title: "My Wallet",
                    subtitle: "Add money, view transactions",
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => WalletScreen())),
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.history,
                    title: "Booking History",
                    subtitle: "View all your bookings",
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BookingsHistoryScreen())),
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.edit,
                    title: "Edit Profile",
                    subtitle: "Update your information",
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EditProfileScreen())),
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.settings,
                    title: "Settings",
                    subtitle: "Notifications, privacy & more",
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen())),
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.help_outline,
                    title: "Help & Support",
                    subtitle: "Get help with your account",
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HelpSupportScreen())),
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.star_rate,
                    title: "Rate Us",
                    subtitle: "Share your feedback",
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
                    label: Text("Logout"),
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
        title: Text("Logout"),
        content: Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
                      userProv.logout();
                      Navigator.pushReplacementNamed(context, '/login');
                    },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text("Logout"),
          ),
                ],
      ),
    );
  }
}
