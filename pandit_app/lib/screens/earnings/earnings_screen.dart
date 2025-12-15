import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../config/constants.dart';
import '../../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  bool _isLoading = true;
  String _selectedPeriod = 'month';
  Map<String, dynamic>? _earningsData;
  double _walletBalance = 0.0;
  final _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadEarnings();
    _loadWalletBalance();
  }

  Future<void> _loadEarnings() async {
    setState(() => _isLoading = true);

    final result = await ApiService.getEarnings(_selectedPeriod);
    if (result['success']) {
      setState(() {
        _earningsData = result['data'];
      });
    }

    setState(() => _isLoading = false);
  }

  Future<void> _loadWalletBalance() async {
    final prefs = await SharedPreferences.getInstance();
    final dashboardResult = await ApiService.getDashboard();
    if (dashboardResult['success']) {
      setState(() {
        _walletBalance = double.parse(
            dashboardResult['data']['wallet_balance'].toString());
      });
    }
  }

  Future<void> _requestPayout() async {
    final amount = double.tryParse(_amountController.text);

    if (amount == null || amount <= 0) {
      _showError('Please enter valid amount');
      return;
    }

    if (amount > _walletBalance) {
      _showError('Insufficient balance');
      return;
    }

    if (amount < 500) {
      _showError('Minimum payout amount is ₹500');
      return;
    }

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Payout'),
        content: Text('Request payout of ₹${amount.toStringAsFixed(2)}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.green,
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isLoading = true);

    final result = await ApiService.requestPayout(amount);

    setState(() => _isLoading = false);

    if (result['success']) {
      _showSuccess('Payout requested successfully! Will be processed in 2-3 business days.');
      _amountController.clear();
      _loadWalletBalance();
    } else {
      _showError(result['error'] ?? 'Failed to request payout');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppConstants.red,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppConstants.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Earnings & Payouts'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Wallet Balance Card
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusLarge),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppConstants.paddingLarge),
                      decoration: BoxDecoration(
                        gradient: AppConstants.primaryGradient,
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusLarge),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Wallet Balance',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppConstants.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            currencyFormat.format(_walletBalance),
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppConstants.black,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _showPayoutDialog,
                              icon: const Icon(Icons.account_balance),
                              label: const Text('Withdraw to Bank'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppConstants.white,
                                foregroundColor: AppConstants.black,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Period Selector
                  Row(
                    children: [
                      const Text(
                        'Earnings Overview',
                        style: AppConstants.subheadingStyle,
                      ),
                      const Spacer(),
                      DropdownButton<String>(
                        value: _selectedPeriod,
                        items: const [
                          DropdownMenuItem(value: 'day', child: Text('Today')),
                          DropdownMenuItem(value: 'week', child: Text('This Week')),
                          DropdownMenuItem(
                              value: 'month', child: Text('This Month')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedPeriod = value);
                            _loadEarnings();
                          }
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Earnings Stats
                  if (_earningsData != null) ...[
                    _buildEarningsCard(),
                    const SizedBox(height: 16),
                    _buildBreakdownCards(),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildEarningsCard() {
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    final totalAmount = _earningsData?['total_amount'] ?? 0;
    final consultationsCount = _earningsData?['consultations_count'] ?? 0;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          children: [
            Text(
              _earningsData?['period'] ?? 'This Month',
              style: const TextStyle(
                fontSize: 14,
                color: AppConstants.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              currencyFormat.format(totalAmount),
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: AppConstants.green,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$consultationsCount Consultations',
              style: const TextStyle(
                fontSize: 14,
                color: AppConstants.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreakdownCards() {
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Earnings Breakdown',
          style: AppConstants.subheadingStyle,
        ),
        const SizedBox(height: 12),
        _buildServiceEarningCard(
          'Chat Consultations',
          _earningsData?['chat_earnings'] ?? 0,
          Icons.chat,
          AppConstants.blue,
        ),
        const SizedBox(height: 8),
        _buildServiceEarningCard(
          'Audio Calls',
          _earningsData?['call_earnings'] ?? 0,
          Icons.call,
          AppConstants.green,
        ),
        const SizedBox(height: 8),
        _buildServiceEarningCard(
          'Video Calls',
          _earningsData?['video_earnings'] ?? 0,
          Icons.videocam,
          AppConstants.orange,
        ),
      ],
    );
  }

  Widget _buildServiceEarningCard(
      String title, dynamic amount, IconData icon, Color color) {
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');

    return Card(
      elevation: 1,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        trailing: Text(
          currencyFormat.format(amount),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }

  void _showPayoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Request Payout'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Available Balance: ₹${_walletBalance.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppConstants.green,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount to Withdraw',
                prefixText: '₹ ',
                border: OutlineInputBorder(),
                helperText: 'Minimum: ₹500',
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Note: Payouts are processed within 2-3 business days.',
              style: TextStyle(
                fontSize: 12,
                color: AppConstants.grey,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              _amountController.clear();
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _requestPayout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.green,
            ),
            child: const Text('Request Payout'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}

