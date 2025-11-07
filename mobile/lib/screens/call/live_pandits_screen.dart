import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/theme.dart';
import '../../providers/booking_provider.dart';
import '../../models/pandit.dart';
import '../booking/booking_screen.dart';

class LivePanditsScreen extends StatefulWidget {
  @override
  State<LivePanditsScreen> createState() => _LivePanditsScreenState();
}

class _LivePanditsScreenState extends State<LivePanditsScreen> {
  List<Pandit> _livePandits = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadLivePandits();
  }

  Future<void> _loadLivePandits() async {
    setState(() => _loading = true);
    final bp = Provider.of<BookingProvider>(context, listen: false);
    final all = await bp.fetchPandits();
    setState(() {
      _livePandits = all.where((p) => p.isOnline).toList();
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Pandits"),
        backgroundColor: AppTheme.primaryYellow,
        automaticallyImplyLeading: false,
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator(color: AppTheme.primaryYellow))
          : RefreshIndicator(
              onRefresh: _loadLivePandits,
              child: _livePandits.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.phone_disabled, size: 64, color: AppTheme.mediumGray),
                          const SizedBox(height: 16),
                          Text(
                            "No pandits online right now",
                            style: TextStyle(fontSize: 18, color: AppTheme.mediumGray),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Please check back later",
                            style: TextStyle(fontSize: 14, color: AppTheme.mediumGray),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _livePandits.length,
                      itemBuilder: (ctx, i) {
                        final pandit = _livePandits[i];
                        return _buildPanditCard(pandit);
                      },
                    ),
            ),
    );
  }

  Widget _buildPanditCard(Pandit pandit) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: AppTheme.primaryYellow.withOpacity(0.2),
                      child: Text(
                        pandit.username[0].toUpperCase(),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryYellow,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pandit.username,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        pandit.expertise,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.mediumGray,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            "${pandit.rating.toStringAsFixed(1)}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.black,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "${pandit.experienceYears} years exp",
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.mediumGray,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.lightYellow,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Call Rate:",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.darkGray,
                    ),
                  ),
                  Text(
                    "₹${pandit.feePerMinute}/min",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryYellow,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => BookingScreen(pandit: pandit)),
                      );
                    },
                    icon: Icon(Icons.book_online, size: 20),
                    label: Text("Book"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryYellow,
                      side: BorderSide(color: AppTheme.primaryYellow, width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _initiateCall(pandit);
                    },
                    icon: Icon(Icons.call, size: 20),
                    label: Text("Call Now"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
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

  void _initiateCall(Pandit pandit) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Confirm Call"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("You are about to call ${pandit.username}"),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.lightYellow,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Rate:", style: TextStyle(fontWeight: FontWeight.w600)),
                      Text("₹${pandit.feePerMinute}/min", style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Charges will be deducted from your wallet during the call.",
                    style: TextStyle(fontSize: 12, color: AppTheme.mediumGray),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              // TODO: Implement actual call functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Connecting to ${pandit.username}...")),
              );
            },
            child: Text("Proceed to Call"),
          ),
        ],
      ),
    );
  }
}

