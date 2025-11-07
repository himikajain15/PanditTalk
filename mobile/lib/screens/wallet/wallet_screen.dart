import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/theme.dart';
import '../../providers/user_provider.dart';
import '../payments/payment_screen.dart';

class WalletScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    final balance = user?.karmaPoints ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Wallet"),
        backgroundColor: AppTheme.primaryYellow,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Balance Card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryYellow, AppTheme.darkYellow],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryYellow.withOpacity(0.3),
                    blurRadius: 15,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Wallet Balance",
                        style: TextStyle(
                          color: AppTheme.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(Icons.account_balance_wallet, color: AppTheme.black),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "₹ ${balance.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: AppTheme.black,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${balance} Karma Points",
                    style: TextStyle(
                      color: AppTheme.black.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Add Money Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton.icon(
                onPressed: () {
                  _showAddMoneyDialog(context);
                },
                icon: Icon(Icons.add_circle_outline),
                label: Text("Add Money to Wallet"),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(54),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Quick Add Options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Quick Add",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _quickAddButton(context, 100)),
                      const SizedBox(width: 12),
                      Expanded(child: _quickAddButton(context, 500)),
                      const SizedBox(width: 12),
                      Expanded(child: _quickAddButton(context, 1000)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _quickAddButton(context, 2000)),
                      const SizedBox(width: 12),
                      Expanded(child: _quickAddButton(context, 5000)),
                      const SizedBox(width: 12),
                      Expanded(child: _quickAddButton(context, 10000)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Transaction History
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recent Transactions",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.black,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to full history
                    },
                    child: Text("View All"),
                  ),
                ],
              ),
            ),

            // Placeholder for transactions
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.lightGray,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.receipt_long, size: 48, color: AppTheme.mediumGray),
                    const SizedBox(height: 12),
                    Text(
                      "No transactions yet",
                      style: TextStyle(color: AppTheme.mediumGray),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickAddButton(BuildContext context, int amount) {
    return OutlinedButton(
      onPressed: () => _proceedToPayment(context, amount),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: AppTheme.primaryYellow, width: 2),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        "₹$amount",
        style: TextStyle(
          color: AppTheme.black,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }

  void _showAddMoneyDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Add Money"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: "Enter amount",
            prefixText: "₹ ",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = int.tryParse(controller.text) ?? 0;
              Navigator.pop(ctx);
              if (amount > 0) {
                _proceedToPayment(context, amount);
              }
            },
            child: Text("Proceed"),
          ),
        ],
      ),
    );
  }

  void _proceedToPayment(BuildContext context, int amount) {
    // TODO: Integrate proper payment gateway for wallet recharge
    // For now, show a message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment gateway integration coming soon! Amount: ₹$amount'),
        duration: Duration(seconds: 2),
      ),
    );
    
    // When payment gateway is ready for wallet, create a wallet recharge endpoint
    // and navigate to proper payment flow
    // Example:
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (_) => WalletPaymentScreen(amount: amount),
    //   ),
    // );
  }
}

