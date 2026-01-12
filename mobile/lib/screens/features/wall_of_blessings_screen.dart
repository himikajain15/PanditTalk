import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../services/engagement_service.dart';
import '../../providers/user_provider.dart';

class WallOfBlessingsScreen extends StatefulWidget {
  const WallOfBlessingsScreen({super.key});

  @override
  State<WallOfBlessingsScreen> createState() => _WallOfBlessingsScreenState();
}

class _WallOfBlessingsScreenState extends State<WallOfBlessingsScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<_Blessing> _blessings = [
    _Blessing(text: 'Got a new job after following the remedies. Thank you!', timeAgo: '2h ago'),
    _Blessing(text: 'Health improved and I feel more peaceful now.', timeAgo: '1d ago'),
    _Blessing(text: 'Marriage talks restarted in our family. Feeling hopeful.', timeAgo: '3d ago'),
  ];
  bool _submitting = false;

  Future<void> _submitBlessing() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() => _submitting = true);
    try {
      final userProv = Provider.of<UserProvider>(context, listen: false);
      final token = await userProv.auth.getToken();
      final engagement = EngagementService();

      // Log as analytics event; backend can later store/display properly.
      await engagement.logEvent('wall_blessing_posted', {
        'text': text,
        'anonymous': true,
      }, token: token);

      setState(() {
        _blessings.insert(0, _Blessing(text: text, timeAgo: 'Just now'));
        _controller.clear();
      });
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not post right now. Please try again.')),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wall of Blessings'),
        backgroundColor: AppTheme.primaryYellow,
      ),
      backgroundColor: AppTheme.lightGray,
      body: Column(
        children: [
          // Header / input
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Share your gratitude (anonymous)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _controller,
                  maxLength: 140,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Eg: Got job after following remedy. Feeling blessed.',
                    filled: true,
                    fillColor: AppTheme.lightGray,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitting ? null : _submitBlessing,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryYellow,
                      foregroundColor: AppTheme.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _submitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.black),
                            ),
                          )
                        : const Text(
                            'Post Blessing',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Blessings list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _blessings.length,
              itemBuilder: (context, index) {
                final b = _blessings[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('🙏', style: TextStyle(fontSize: 24)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              b.text,
                              style: const TextStyle(fontSize: 14, height: 1.5),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Anonymous • ${b.timeAgo}',
                              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _Blessing {
  final String text;
  final String timeAgo;

  _Blessing({required this.text, required this.timeAgo});
}


