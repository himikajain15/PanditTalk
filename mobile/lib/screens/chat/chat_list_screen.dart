import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/booking_provider.dart';
import '../../models/pandit.dart';
import '../booking/booking_screen.dart';
import '../../utils/theme.dart';
import 'whatsapp_chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<Pandit> _pandits = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final bp = Provider.of<BookingProvider>(context, listen: false);
    final list = await bp.fetchPandits();
    setState(() {
      _pandits = list;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat with Pandits"), backgroundColor: AppTheme.gold),
      body: _loading
          ? Center(child: CircularProgressIndicator(color: AppTheme.gold))
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: _pandits.length,
                itemBuilder: (ctx, i) {
                  final p = _pandits[i];
                  return ListTile(
                    leading: Stack(
                      children: [
                        CircleAvatar(
                          child: Text(p.username.isNotEmpty ? p.username[0].toUpperCase() : 'P'),
                        ),
                        if (p.isOnline)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                            ),
                          ),
                      ],
                    ),
                    title: Text(p.username),
                    subtitle: Text('${p.expertise} • ₹${p.feePerMinute}/min'),
                    trailing: Icon(Icons.chat_bubble_outline, size: 20, color: AppTheme.primaryYellow),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => WhatsAppChatScreen(pandit: p)),
                    ),
                  );
                },
                separatorBuilder: (_, __) => const Divider(height: 1),
              ),
            ),
    );
  }
}
