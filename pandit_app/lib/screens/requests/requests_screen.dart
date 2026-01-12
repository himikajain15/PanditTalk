import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../config/constants.dart';
import '../../services/api_service.dart';
import '../../models/consultation_request.dart';
import 'consultation_detail_screen.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  List<ConsultationRequest> _pendingRequests = [];
  List<ConsultationRequest> _activeRequests = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    setState(() => _isLoading = true);

    // Load pending
    final pendingResult = await ApiService.getPendingRequests();
    if (pendingResult['success']) {
      final List<dynamic> json = pendingResult['data'];
      _pendingRequests =
          json.map((j) => ConsultationRequest.fromJson(j)).toList();
    }

    // Load active
    final activeResult = await ApiService.getActiveConsultations();
    if (activeResult['success']) {
      final List<dynamic> json = activeResult['data'];
      _activeRequests =
          json.map((j) => ConsultationRequest.fromJson(j)).toList();
    }

    setState(() => _isLoading = false);
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
      _loadRequests();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${result['error']}'),
          backgroundColor: AppConstants.red,
        ),
      );
    }
  }

  Future<void> _toggleVIP(ConsultationRequest request) async {
    final result = request.isVIP
        ? await ApiService.removeVIP(request.userId)
        : await ApiService.markAsVIP(request.userId);
    
    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            request.isVIP 
                ? 'VIP status removed' 
                : 'User marked as VIP (will appear first in requests)',
          ),
          backgroundColor: AppConstants.orange,
        ),
      );
      _loadRequests();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${result['error']}'),
          backgroundColor: AppConstants.red,
        ),
      );
    }
  }

  Future<void> _blockUser(ConsultationRequest request) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Block User'),
        content: Text('Are you sure you want to block ${request.userName}? They will not be able to send you consultation requests.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppConstants.red),
            child: const Text('Block'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final result = await ApiService.blockUser(request.userId);
      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${request.userName} has been blocked'),
            backgroundColor: AppConstants.red,
          ),
        );
        _loadRequests();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${result['error']}'),
            backgroundColor: AppConstants.red,
          ),
        );
      }
    }
  }

  Future<void> _completeConsultation(ConsultationRequest request) async {
    final result = await ApiService.completeConsultation(request.id);

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Consultation completed! ₹${request.panditEarnings} credited to wallet'),
          backgroundColor: AppConstants.green,
        ),
      );
      _loadRequests();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${result['error']}'),
          backgroundColor: AppConstants.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultation Requests'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppConstants.black,
          labelColor: AppConstants.black,
          tabs: [
            Tab(
              text: 'Pending (${_pendingRequests.length})',
            ),
            Tab(
              text: 'Active (${_activeRequests.length})',
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildPendingList(),
                _buildActiveList(),
              ],
            ),
    );
  }

  Widget _buildPendingList() {
    if (_pendingRequests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox,
              size: 80,
              color: AppConstants.grey.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'No Pending Requests',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppConstants.grey,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'New requests will appear here',
              style: TextStyle(color: AppConstants.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadRequests,
      child: ListView.builder(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        itemCount: _pendingRequests.length,
        itemBuilder: (context, index) {
          final request = _pendingRequests[index];
          return _buildRequestCard(request, isPending: true);
        },
      ),
    );
  }

  Widget _buildActiveList() {
    if (_activeRequests.isEmpty) {
      return const Center(
        child: Text(
          'No Active Consultations',
          style: TextStyle(color: AppConstants.grey),
        ),
      );
    }

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    final todayList = <ConsultationRequest>[];
    final upcomingList = <ConsultationRequest>[];

    for (final r in _activeRequests) {
      final d = r.createdAt;
      final dateOnly = DateTime(d.year, d.month, d.day);
      if (dateOnly == todayDate) {
        todayList.add(r);
      } else if (dateOnly.isAfter(todayDate)) {
        upcomingList.add(r);
      } else {
        // Older than today, still active – treat as today for now
        todayList.add(r);
      }
    }

    return RefreshIndicator(
      onRefresh: _loadRequests,
      child: ListView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        children: [
          if (todayList.isNotEmpty) ...[
            const Text(
              "Today's Queue",
              style: AppConstants.subheadingStyle,
            ),
            const SizedBox(height: 8),
            ...todayList.map((r) => _buildRequestCard(r, isPending: false)),
            const SizedBox(height: 16),
          ],
          if (upcomingList.isNotEmpty) ...[
            const Text(
              'Upcoming',
              style: AppConstants.subheadingStyle,
            ),
            const SizedBox(height: 8),
            ...upcomingList.map((r) => _buildRequestCard(r, isPending: false)),
          ],
        ],
      ),
    );
  }

  Widget _buildRequestCard(ConsultationRequest request,
      {required bool isPending}) {
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    final timeFormat = DateFormat('dd MMM, hh:mm a');

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ConsultationDetailScreen(request: request),
            ),
          ).then((_) => _loadRequests());
        },
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // Header
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppConstants.primaryYellow,
                  child: request.userProfilePic != null
                      ? ClipOval(
                          child: Image.network(
                            request.userProfilePic!,
                            fit: BoxFit.cover,
                            width: 56,
                            height: 56,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.person, size: 32),
                          ),
                        )
                      : const Icon(Icons.person,
                          size: 32, color: AppConstants.white),
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
                      const SizedBox(height: 4),
                      Text(
                        timeFormat.format(request.createdAt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppConstants.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    if (request.isVIP)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        margin: const EdgeInsets.only(right: 6),
                        decoration: BoxDecoration(
                          color: AppConstants.orange,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, size: 14, color: AppConstants.white),
                            SizedBox(width: 2),
                            Text(
                              'VIP',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppConstants.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getStatusColor(request.status),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        request.statusDisplay,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),

            // Service Type
            Row(
              children: [
                Icon(
                  _getServiceIcon(request.serviceType),
                  size: 20,
                  color: AppConstants.primaryYellow,
                ),
                const SizedBox(width: 8),
                Text(
                  request.serviceTypeDisplay,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  '${request.duration} minutes',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppConstants.grey,
                  ),
                ),
              ],
            ),

            // Query
            if (request.userQuery != null &&
                request.userQuery!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppConstants.lightGrey,
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusSmall),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 12),

            // Payment Info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!isPending)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Amount',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppConstants.grey,
                        ),
                      ),
                      Text(
                        currencyFormat.format(request.amount),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppConstants.green.withOpacity(0.1),
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusSmall),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'You Earn',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppConstants.grey,
                        ),
                      ),
                      Text(
                        currencyFormat.format(request.panditEarnings),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Block/VIP Actions Row (only for pending requests)
            if (isPending)
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      request.isVIP ? Icons.star : Icons.star_border,
                      color: request.isVIP ? AppConstants.orange : AppConstants.grey,
                      size: 20,
                    ),
                    onPressed: () => _toggleVIP(request),
                    tooltip: request.isVIP ? 'Remove VIP' : 'Mark as VIP',
                  ),
                  IconButton(
                    icon: const Icon(Icons.block, color: AppConstants.red, size: 20),
                    onPressed: () => _blockUser(request),
                    tooltip: 'Block User',
                  ),
                  const Spacer(),
                ],
              ),

            if (isPending) const SizedBox(height: 8),

            // Action Buttons
            if (isPending)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _handleRequest(request, false),
                      icon: const Icon(Icons.close, size: 18),
                      label: const Text('Reject'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppConstants.red,
                        side: const BorderSide(color: AppConstants.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              AppConstants.radiusSmall),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: () => _handleRequest(request, true),
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text('Accept Request'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.green,
                        foregroundColor: AppConstants.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              AppConstants.radiusSmall),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              )
            else
              ElevatedButton.icon(
                onPressed: () => _completeConsultation(request),
                icon: const Icon(Icons.check_circle, size: 18),
                label: const Text('Mark as Completed'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primaryYellow,
                  foregroundColor: AppConstants.black,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusSmall),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return AppConstants.orange;
      case 'accepted':
        return AppConstants.blue;
      case 'in_progress':
        return AppConstants.primaryYellow;
      case 'completed':
        return AppConstants.green;
      case 'rejected':
        return AppConstants.red;
      default:
        return AppConstants.grey;
    }
  }

  IconData _getServiceIcon(String serviceType) {
    switch (serviceType) {
      case 'chat':
        return Icons.chat;
      case 'call':
        return Icons.call;
      case 'video':
        return Icons.videocam;
      default:
        return Icons.help;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

