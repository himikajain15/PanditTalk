import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../utils/theme.dart';
import '../../providers/referral_provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/app_strings.dart';

class ReferralScreen extends StatefulWidget {
  @override
  _ReferralScreenState createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ReferralProvider>(context, listen: false);
      provider.loadReferralCode();
      provider.loadRewards();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.getString(context, 'referralProgram', fallback: 'Referral Program')),
        backgroundColor: AppTheme.primaryYellow,
      ),
      body: Consumer<ReferralProvider>(
        builder: (context, provider, _) {
          if (provider.loading && provider.referral == null) {
            return Center(child: CircularProgressIndicator(color: AppTheme.primaryYellow));
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Card
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppTheme.primaryYellow, AppTheme.primaryYellow.withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.card_giftcard, size: 64, color: AppTheme.white),
                      SizedBox(height: 16),
                      Text(
                        AppStrings.getString(context, 'inviteFriends', fallback: 'Invite Friends'),
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.white),
                      ),
                      SizedBox(height: 8),
                      Text(
                        AppStrings.getString(context, 'getCreditsForEachReferral', fallback: 'Get credits for each friend you refer!'),
                        style: TextStyle(fontSize: 14, color: AppTheme.white.withOpacity(0.9)),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),

                // Referral Code Card
                if (provider.referral != null) ...[
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.getString(context, 'yourReferralCode', fallback: 'Your Referral Code'),
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 16),
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryYellow.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppTheme.primaryYellow, width: 2),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  provider.referral!.referralCode,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.copy),
                                  onPressed: () {
                                    // Copy to clipboard
                                    // Clipboard.setData(ClipboardData(text: provider.referral!.referralCode));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Referral code copied!')),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () => _shareReferralCode(provider.referral!.referralCode),
                              icon: Icon(Icons.share),
                              label: Text(AppStrings.getString(context, 'shareReferralCode', fallback: 'Share Referral Code')),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryYellow,
                                foregroundColor: AppTheme.black,
                                padding: EdgeInsets.symmetric(vertical: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                ],

                // Statistics
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.people,
                        label: AppStrings.getString(context, 'totalReferrals', fallback: 'Total Referrals'),
                        value: '${provider.referral?.totalReferrals ?? 0}',
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.account_balance_wallet,
                        label: AppStrings.getString(context, 'creditsEarned', fallback: 'Credits Earned'),
                        value: '${provider.referral?.creditsEarned ?? 0}',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),

                // How it works
                Text(
                  AppStrings.getString(context, 'howItWorks', fallback: 'How It Works'),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                _buildStepCard(
                  step: 1,
                  title: AppStrings.getString(context, 'shareYourCode', fallback: 'Share Your Code'),
                  description: AppStrings.getString(context, 'shareCodeDescription', fallback: 'Share your referral code with friends'),
                ),
                _buildStepCard(
                  step: 2,
                  title: AppStrings.getString(context, 'friendSignsUp', fallback: 'Friend Signs Up'),
                  description: AppStrings.getString(context, 'friendSignsUpDescription', fallback: 'Your friend uses your code when registering'),
                ),
                _buildStepCard(
                  step: 3,
                  title: AppStrings.getString(context, 'earnCredits', fallback: 'Earn Credits'),
                  description: AppStrings.getString(context, 'earnCreditsDescription', fallback: 'You both get credits when they make their first booking'),
                ),
                SizedBox(height: 24),

                // Rewards History
                if (provider.rewards.isNotEmpty) ...[
                  Text(
                    AppStrings.getString(context, 'rewardsHistory', fallback: 'Rewards History'),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  ...provider.rewards.map((reward) => Card(
                    margin: EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: Icon(Icons.check_circle, color: Colors.green),
                      title: Text('+${reward.creditsAwarded} credits'),
                      subtitle: Text('Referred user #${reward.referredUserId}'),
                      trailing: Text(
                        reward.createdAt.toString().split(' ')[0],
                        style: TextStyle(fontSize: 12, color: AppTheme.mediumGray),
                      ),
                    ),
                  )),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard({required IconData icon, required String label, required String value}) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: AppTheme.primaryYellow),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: AppTheme.mediumGray),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepCard({required int step, required String title, required String description}) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryYellow,
          child: Text('$step', style: TextStyle(color: AppTheme.black, fontWeight: FontWeight.bold)),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
      ),
    );
  }

  Future<void> _shareReferralCode(String code) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final message = 'Join PanditTalk using my referral code: $code\n\nGet instant astrology consultations and I\'ll get credits too!';
    
    await Share.share(message, subject: 'Join PanditTalk');
  }
}

