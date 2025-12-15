import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppTheme.primaryYellow,
      ),
      body: ListView(
        children: [
          _buildSection('Account'),
          _buildTile(Icons.person, 'Edit Profile', () {}),
          _buildTile(Icons.lock, 'Change Password', () {}),
          _buildTile(Icons.language, 'Language', () {}),
          
          const Divider(),
          _buildSection('Notifications'),
          _buildTile(Icons.notifications, 'Push Notifications', () {}),
          _buildTile(Icons.email, 'Email Notifications', () {}),
          
          const Divider(),
          _buildSection('App'),
          _buildTile(Icons.info, 'About', () {}),
          _buildTile(Icons.privacy_tip, 'Privacy Policy', () {}),
          _buildTile(Icons.description, 'Terms & Conditions', () {}),
          _buildTile(Icons.logout, 'Logout', () {}, color: Colors.red),
        ],
      ),
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildTile(IconData icon, String title, VoidCallback onTap,
      {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppTheme.primaryYellow),
      title: Text(title, style: TextStyle(color: color)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}

