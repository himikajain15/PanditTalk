import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/theme.dart';
import '../../providers/user_provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: AppTheme.primaryYellow,
      ),
      body: ListView(
        children: [
          _buildSection("Account"),
          _buildTile(
            icon: Icons.person_outline,
            title: "Edit Profile",
            onTap: () => Navigator.pushNamed(context, '/edit-profile'),
          ),
          _buildTile(
            icon: Icons.security,
            title: "Privacy & Security",
            onTap: () {},
          ),
          _buildTile(
            icon: Icons.language,
            title: "Language",
            trailing: Text("English", style: TextStyle(color: AppTheme.mediumGray)),
            onTap: () {},
          ),

          Divider(height: 32),

          _buildSection("Notifications"),
          _buildSwitchTile(
            icon: Icons.notifications_outlined,
            title: "Push Notifications",
            value: _notificationsEnabled,
            onChanged: (val) => setState(() => _notificationsEnabled = val),
          ),
          _buildSwitchTile(
            icon: Icons.email_outlined,
            title: "Email Notifications",
            value: _emailNotifications,
            onChanged: (val) => setState(() => _emailNotifications = val),
          ),
          _buildSwitchTile(
            icon: Icons.sms_outlined,
            title: "SMS Notifications",
            value: _smsNotifications,
            onChanged: (val) => setState(() => _smsNotifications = val),
          ),

          Divider(height: 32),

          _buildSection("Support"),
          _buildTile(
            icon: Icons.help_outline,
            title: "Help & FAQ",
            onTap: () {},
          ),
          _buildTile(
            icon: Icons.support_agent,
            title: "Contact Support",
            onTap: () {},
          ),
          _buildTile(
            icon: Icons.rate_review_outlined,
            title: "Rate Us",
            onTap: () {},
          ),

          Divider(height: 32),

          _buildSection("Legal"),
          _buildTile(
            icon: Icons.description_outlined,
            title: "Terms & Conditions",
            onTap: () {
              _showTermsDialog();
            },
          ),
          _buildTile(
            icon: Icons.privacy_tip_outlined,
            title: "Privacy Policy",
            onTap: () {},
          ),
          _buildTile(
            icon: Icons.info_outline,
            title: "About",
            trailing: Text("v1.1.0", style: TextStyle(color: AppTheme.mediumGray)),
            onTap: () {},
          ),

          Divider(height: 32),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                _showLogoutDialog();
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
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppTheme.mediumGray,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryYellow),
      title: Text(title),
      trailing: trailing ?? Icon(Icons.arrow_forward_ios, size: 16, color: AppTheme.mediumGray),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      secondary: Icon(icon, color: AppTheme.primaryYellow),
      title: Text(title),
      value: value,
      onChanged: onChanged,
      activeColor: AppTheme.primaryYellow,
    );
  }

  void _showLogoutDialog() {
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
              final userProv = Provider.of<UserProvider>(context, listen: false);
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

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Terms & Conditions"),
        content: SingleChildScrollView(
          child: Text(
            "Terms & Conditions\n\n"
            "1. Acceptance of Terms: By accessing and using PanditTalk, you accept and agree to be bound by the terms and provision of this agreement.\n\n"
            "2. Services: PanditTalk provides astrology consultation services through verified astrologers.\n\n"
            "3. User Responsibilities: You are responsible for maintaining the confidentiality of your account.\n\n"
            "4. Payment Terms: All payments are processed securely through our payment gateway.\n\n"
            "5. Refund Policy: Refunds are provided as per our refund policy.\n\n"
            "6. Privacy: We respect your privacy and protect your personal information.\n\n"
            "For full terms and conditions, please visit our website.",
            style: TextStyle(fontSize: 14),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }
}

