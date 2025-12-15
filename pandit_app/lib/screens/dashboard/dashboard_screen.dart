import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../config/constants.dart';
import '../../services/api_service.dart';
import '../../models/consultation_request.dart';
import '../requests/requests_screen.dart';
import '../earnings/earnings_screen.dart';
import '../profile/profile_screen.dart';
import '../auth/login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _dashboardData;
  List<ConsultationRequest> _pendingRequests = [];
  String _availabilityStatus = AppConstants.availabilityOffline;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    setState(() => _isLoading = true);

    // Load dashboard stats
    final dashboardResult = await ApiService.getDashboard();
    if (dashboardResult['success']) {
      _dashboardData = dashboardResult['data'];
      _availabilityStatus =
          _dashboardData?['availability_status'] ?? AppConstants.availabilityOffline;
    }

    // Load pending requests
    final requestsResult = await ApiService.getPendingRequests();
    if (requestsResult['success']) {
      final List<dynamic> requestsJson = requestsResult['data'];
      _pendingRequests = requestsJson
          .map((json) => ConsultationRequest.fromJson(json))
          .toList();
    }

    setState(() => _isLoading = false);
  }

  Future<void> _toggleAvailability() async {
    setState(() {
      _availabilityStatus = _availabilityStatus == AppConstants.availabilityAvailable
          ? AppConstants.availabilityOffline
          : AppConstants.availabilityAvailable;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _availabilityStatus == AppConstants.availabilityAvailable
            ? 'You are now ONLINE (requests will be shown)'
            : 'You are now OFFLINE (no new requests)',
        ),
        backgroundColor: _availabilityStatus == AppConstants.availabilityAvailable
          ? AppConstants.green
          : AppConstants.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _handleRequest(ConsultationRequest request, bool accept) async {
    final result = accept
        ? await ApiService.acceptRequest(request.id)
        : await ApiService.rejectRequest(request.id);

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(accept ? 'Request accepted!' : 'Request rejected'),
          backgroundColor: accept ? AppConstants.green : AppConstants.orange,
        ),
      );
      _loadDashboard(); // Reload data
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${result['error']}'),
          backgroundColor: AppConstants.red,
        ),
      );
    }
  }

  Future<void> _logout() async {
    await ApiService.logout();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PanditTalk',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDashboard,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RequestsScreen()),
            ).then((_) => _loadDashboard());
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EarningsScreen()),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            );
          }
        },
        selectedItemColor: AppConstants.primaryYellow,
        unselectedItemColor: AppConstants.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Earnings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: _loadDashboard,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Availability Toggle
            _buildAvailabilityCard(),
            const SizedBox(height: 28),
            
            // Stats Cards
            _buildStatsGrid(),
            const SizedBox(height: 24),
            
            // Pending Requests
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pending Requests',
                  style: AppConstants.subheadingStyle,
                ),
                if (_pendingRequests.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppConstants.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_pendingRequests.length}',
                      style: const TextStyle(
                        color: AppConstants.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            
            if (_pendingRequests.isEmpty)
              _buildEmptyState()
            else
              ..._pendingRequests.map((request) => _buildRequestCard(request)),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailabilityCard() {
    final isAvailable = _availabilityStatus == AppConstants.availabilityAvailable;
    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(top: 4, bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        side: BorderSide(
          color: isAvailable ? AppConstants.green : AppConstants.red,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (isAvailable ? AppConstants.green : AppConstants.grey).withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isAvailable ? AppConstants.green : AppConstants.red,
                  width: 2,
                ),
              ),
              child: Icon(
                isAvailable ? Icons.check_circle_rounded : Icons.cancel_outlined,
                color: isAvailable ? AppConstants.green : AppConstants.red,
                size: 36,
              ),
            ),
            const SizedBox(width: 22),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Status',
                    style: AppConstants.captionStyle,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isAvailable ? 'ONLINE' : 'OFFLINE',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isAvailable ? AppConstants.green : AppConstants.red,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isAvailable
                      ? 'You can now accept new consultation requests.'
                      : 'Toggle ON to start receiving requests.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppConstants.grey,
                    ),
                  ),
                ],
              ),
            ),
            Transform.scale(
              scale: 1.22,
              child: Switch(
                value: isAvailable,
                onChanged: (_) => _toggleAvailability(),
                activeColor: AppConstants.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 14,
      crossAxisSpacing: 14,
      childAspectRatio: 1.6,
      children: [
        _buildStatCard(
          'Today\'s Earnings',
          currencyFormat.format(_dashboardData?['today_earnings'] ?? 0),
          Icons.account_balance_wallet,
          AppConstants.green,
        ),
        _buildStatCard(
          'Today\'s Consultations',
          '${_dashboardData?['today_consultations'] ?? 0}',
          Icons.assignment,
          AppConstants.blue,
        ),
        _buildStatCard(
          'Total Earnings',
          currencyFormat.format(_dashboardData?['total_earnings'] ?? 0),
          Icons.monetization_on,
          AppConstants.orange,
        ),
        _buildStatCard(
          'Total Consultations',
          '${_dashboardData?['total_consultations'] ?? 0}',
          Icons.history,
          AppConstants.primaryYellow,
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
      ),
      child: Container(
        constraints: BoxConstraints(minHeight: 92),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 34),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                color: AppConstants.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestCard(ConsultationRequest request) {
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppConstants.primaryYellow,
                  child: request.userProfilePic != null
                      ? ClipOval(
                          child: Image.network(
                            request.userProfilePic!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(Icons.person),
                          ),
                        )
                      : const Icon(Icons.person, color: AppConstants.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.userName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (request.userPhone != null)
                        Text(
                          request.userPhone!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppConstants.grey,
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryYellow,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    request.serviceTypeDisplay,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.black,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            
            // Query
            if (request.userQuery != null && request.userQuery!.isNotEmpty) ...[
              const Text(
                'Query:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                request.userQuery!,
                style: const TextStyle(fontSize: 14),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
            ],
            
            // Details Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDetailItem(
                  Icons.access_time,
                  '${request.duration} min',
                ),
                _buildDetailItem(
                  Icons.currency_rupee,
                  currencyFormat.format(request.amount),
                ),
                _buildDetailItem(
                  Icons.account_balance_wallet,
                  'You get: ${currencyFormat.format(request.panditEarnings)}',
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _handleRequest(request, false),
                    icon: const Icon(Icons.close, size: 18),
                    label: const Text('Reject'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.lightGrey,
                      foregroundColor: AppConstants.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusSmall),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _handleRequest(request, true),
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('Accept'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.green,
                      foregroundColor: AppConstants.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusSmall),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppConstants.grey),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: AppConstants.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.inbox,
                size: 64,
                color: AppConstants.grey.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              const Text(
                'No Pending Requests',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.grey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _availabilityStatus == AppConstants.availabilityAvailable
                    ? 'You\'re online! Requests will appear here.'
                    : 'Turn on availability to receive requests',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppConstants.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

