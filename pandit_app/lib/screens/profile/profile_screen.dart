import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../../config/constants.dart';
import '../../services/api_service.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _profileData;
  String _username = '';
  String _phone = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString(AppConstants.keyUsername) ?? 'Pandit';
      _phone = prefs.getString(AppConstants.keyPhone) ?? '';
    });
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);

    final result = await ApiService.getProfile();
    if (result['success']) {
      setState(() {
        _profileData = result['data'];
      });
    }

    setState(() => _isLoading = false);
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.red,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ApiService.logout();
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadProfile,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              child: Column(
                children: [
                  // Profile Header
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusLarge),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppConstants.paddingLarge),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: AppConstants.primaryYellow,
                            child: const Icon(
                              Icons.person,
                              size: 50,
                              color: AppConstants.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _username,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _phone,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppConstants.grey,
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (_profileData?['is_verified'] == true)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppConstants.green,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.verified,
                                      color: AppConstants.white, size: 16),
                                  SizedBox(width: 4),
                                  Text(
                                    'Verified Pandit',
                                    style: TextStyle(
                                      color: AppConstants.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppConstants.orange,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Verification Pending',
                                style: TextStyle(
                                  color: AppConstants.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Stats
                  if (_profileData != null) ...[
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Experience',
                            '${_profileData!['experience_years']} Years',
                            Icons.work,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            'Rating',
                            '${_profileData!['average_rating']} ⭐',
                            Icons.star,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Total Consultations',
                            '${_profileData!['total_consultations']}',
                            Icons.assignment,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            'Reviews',
                            '${_profileData!['total_reviews']}',
                            Icons.rate_review,
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Specializations
                  if (_profileData?['specializations'] != null) ...[
                    const Text(
                      'Specializations',
                      style: AppConstants.subheadingStyle,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: (_profileData!['specializations'] as List)
                          .map((spec) => Chip(
                                label: Text(spec.toString()),
                                backgroundColor:
                                    AppConstants.primaryYellow.withOpacity(0.2),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Languages
                  if (_profileData?['languages'] != null) ...[
                    const Text(
                      'Languages',
                      style: AppConstants.subheadingStyle,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: (_profileData!['languages'] as List)
                          .map((lang) => Chip(
                                label: Text(lang.toString()),
                                backgroundColor:
                                    AppConstants.blue.withOpacity(0.2),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Pricing
                  const Text(
                    'My Rates',
                    style: AppConstants.subheadingStyle,
                  ),
                  const SizedBox(height: 12),
                  _buildRateCard('Chat', _profileData?['chat_rate'], Icons.chat),
                  _buildRateCard('Audio Call', _profileData?['call_rate'], Icons.call),
                  _buildRateCard('Video Call', _profileData?['video_rate'], Icons.videocam),

                  const SizedBox(height: 24),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _logout,
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppConstants.red,
                        side: const BorderSide(color: AppConstants.red),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: AppConstants.primaryYellow, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppConstants.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRateCard(String service, dynamic rate, IconData icon) {
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: AppConstants.primaryYellow),
        title: Text(service),
        trailing: Text(
          currencyFormat.format(rate ?? 0),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppConstants.green,
          ),
        ),
      ),
    );
  }
}

