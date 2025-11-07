import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class RewardsScreen extends StatefulWidget {
  @override
  _RewardsScreenState createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  // Demo list of rewards
  final List<Map<String, String>> _rewards = [
    { 'title': 'Free 5-min Consultation', 'desc': 'Invite 3 friends' },
    { 'title': '10% Discount Coupon', 'desc': 'Book 5 sessions' },
    { 'title': 'Golden Badge', 'desc': 'Active 30 days streak' },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Rewards"), backgroundColor: AppTheme.saffron),
      body: ListView.separated(
        padding: EdgeInsets.all(12),
        itemCount: _rewards.length,
        separatorBuilder: (_, __) => SizedBox(height: 8),
        itemBuilder: (ctx, i) {
          final r = _rewards[i];
          return Card(
            child: ListTile(
              leading: CircleAvatar(backgroundColor: AppTheme.saffron, child: Icon(Icons.card_giftcard, color: Colors.white)),
              title: Text(r['title']!),
              subtitle: Text(r['desc']!),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.deepSaffron),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Reward redeemed (demo)")));
                },
                child: Text("Redeem"),
              ),
            ),
          );
        },
      ),
    );
  }
}
