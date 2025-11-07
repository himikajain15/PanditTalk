import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/booking_provider.dart';
import '../../models/pandit.dart';
import '../booking/booking_screen.dart';
import '../../utils/theme.dart';

class CallScreen extends StatefulWidget {
  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  List<Pandit> _livePandits = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadLivePandits();
  }

  Future<void> _loadLivePandits() async {
    final bp = Provider.of<BookingProvider>(context, listen: false);
    final allPandits = await bp.fetchPandits();
    setState(() {
      _livePandits = allPandits.where((p) => p.isOnline).toList();
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Call a Pandit'),
        backgroundColor: AppTheme.primaryYellow,
        automaticallyImplyLeading: false,
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator(color: AppTheme.primaryYellow))
          : RefreshIndicator(
              onRefresh: _loadLivePandits,
              child: _livePandits.isEmpty
                  ? ListView(
                      children: [
                        SizedBox(height: 100),
                        Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.phone_disabled,
                                size: 80,
                                color: AppTheme.mediumGray,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No pandits online',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: AppTheme.mediumGray,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Please check back later',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.mediumGray,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with live indicator
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppTheme.primaryYellow, AppTheme.darkYellow],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.green.withOpacity(0.5),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                '${_livePandits.length} Pandits Live Now',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.black,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Live Pandits List
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.all(12),
                            itemCount: _livePandits.length,
                            itemBuilder: (ctx, i) {
                              final pandit = _livePandits[i];
                              return Card(
                                margin: EdgeInsets.only(bottom: 12),
                                child: InkWell(
                                  onTap: () => _showCallOptionsDialog(pandit),
                                  borderRadius: BorderRadius.circular(12),
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            // Avatar with online indicator
                                            Stack(
                                              children: [
                                                CircleAvatar(
                                                  radius: 35,
                                                  backgroundColor: AppTheme.primaryYellow.withOpacity(0.2),
                                                  child: Text(
                                                    pandit.username.isNotEmpty ? pandit.username[0].toUpperCase() : 'P',
                                                    style: TextStyle(
                                                      fontSize: 28,
                                                      fontWeight: FontWeight.bold,
                                                      color: AppTheme.primaryYellow,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: 0,
                                                  right: 0,
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
                                            SizedBox(width: 16),

                                            // Pandit Info
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    pandit.username,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    pandit.expertise,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: AppTheme.mediumGray,
                                                    ),
                                                  ),
                                                  SizedBox(height: 6),
                                                  Row(
                                                    children: [
                                                      Icon(Icons.star, size: 16, color: Colors.amber),
                                                      SizedBox(width: 4),
                                                      Text(
                                                        '${pandit.rating.toStringAsFixed(1)}',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                      SizedBox(width: 12),
                                                      Icon(Icons.work_outline, size: 16, color: AppTheme.mediumGray),
                                                      SizedBox(width: 4),
                                                      Text(
                                                        '${pandit.experienceYears} yrs',
                                                        style: TextStyle(
                                                          color: AppTheme.mediumGray,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),

                                            // Call button
                                            Column(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(12),
                                                  decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    Icons.call,
                                                    color: Colors.white,
                                                    size: 24,
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  'CALL',
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),

                                        SizedBox(height: 12),
                                        Divider(height: 1),
                                        SizedBox(height: 12),

                                        // Pricing
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Languages: ${pandit.languages.join(", ")}',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: AppTheme.mediumGray,
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                              decoration: BoxDecoration(
                                                color: AppTheme.primaryYellow.withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                '₹${pandit.feePerMinute}/min',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: AppTheme.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            ),
    );
  }

  void _showCallOptionsDialog(Pandit pandit) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.mediumGray,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 20),
            CircleAvatar(
              radius: 40,
              backgroundColor: AppTheme.primaryYellow.withOpacity(0.2),
              child: Text(
                pandit.username.isNotEmpty ? pandit.username[0].toUpperCase() : 'P',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryYellow,
                ),
              ),
            ),
            SizedBox(height: 12),
            Text(
              pandit.username,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              pandit.expertise,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.mediumGray,
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.lightYellow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Call Rate:',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '₹${pandit.feePerMinute}/min',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryYellow,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookingScreen(pandit: pandit),
                    ),
                  );
                },
                icon: Icon(Icons.phone_in_talk),
                label: Text('Book Call Now'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}


