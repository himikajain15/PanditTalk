// lib/screens/chat/chat_screen.dart
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/theme.dart';
import '../../services/api_service.dart';

class ChatScreen extends StatefulWidget {
  final int threadId; // existing ChatThread id on backend
  ChatScreen({required this.threadId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  WebSocketChannel? _channel;
  final _controller = TextEditingController();
  List<_ChatItem> _messages = [];
  bool _connected = false;
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _connectWs();
  }

  @override
  void dispose() {
    _sub?.cancel();
    _channel?.sink.close(status.goingAway);
    _controller.dispose();
    super.dispose();
  }

  Future<void> _connectWs() async {
    final userProv = Provider.of<UserProvider>(context, listen: false);
    final token = await userProv.auth.getToken();

    // Build URL; choose secure wss in production.
    // If your backend is local dev using http://10.0.2.2:8000, ws uses ws://10.0.2.2:8000
    // Use wss://api.yourdomain.com if hosted behind TLS.
    final base = Uri.parse(ApiBaseForWs());
    final wsScheme = base.scheme == 'https' ? 'wss' : 'ws';
    final host = base.host + (base.hasPort ? ':${base.port}' : '');
    final wsUrl = Uri.parse('$wsScheme://$host/ws/chat/${widget.threadId}/?token=${token ?? ''}');

    try {
      _channel = WebSocketChannel.connect(wsUrl);
      _sub = _channel!.stream.listen((data) {
        _handleIncoming(data);
      }, onDone: () {
        setState(() { _connected = false; });
      }, onError: (err) {
        setState(() { _connected = false; });
      });
      setState(() { _connected = true; });
    } catch (e) {
      setState(() { _connected = false; });
    }
  }

  // Helper to determine base API host for ws connection
  String ApiBaseForWs() {
    // Match ApiService base; use same host as API
    // ApiService automatically detects the correct URL for web/Android/iOS
    return ApiService.baseUrl;
  }

  void _handleIncoming(dynamic raw) {
    try {
      final Map<String, dynamic> msg = (raw is String) ? jsonDecode(raw) : Map<String, dynamic>.from(raw);
      // The consumer sends messages under a 'type' and data; we handle chat_message events.
      if (msg.containsKey('message')) {
        final senderId = msg['sender_id']?.toString() ?? '';
        final messageText = msg['message']?.toString() ?? '';
        setState(() {
          _messages.add(_ChatItem(senderId: senderId, text: messageText));
        });
      } else if (msg.containsKey('type') && msg['type'] == 'chat_message' && msg.containsKey('message')) {
        final senderId = msg['sender_id']?.toString() ?? '';
        final messageText = msg['message']?.toString() ?? '';
        setState(() {
          _messages.add(_ChatItem(senderId: senderId, text: messageText));
        });
      } else {
        // If message structure differs, show raw
        setState(() {
          _messages.add(_ChatItem(senderId: 'sys', text: raw.toString()));
        });
      }
    } catch (e) {
      setState(() {
        _messages.add(_ChatItem(senderId: 'sys', text: raw.toString()));
      });
    }
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty || _channel == null) return;
    final text = _controller.text.trim();
    final userProv = Provider.of<UserProvider>(context, listen: false);
    final userId = userProv.user?.id.toString() ?? '0';
    final payload = jsonEncode({'message': text, 'sender_id': userId});
    _channel!.sink.add(payload);
    setState(() {
      _messages.add(_ChatItem(senderId: userId, text: text));
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        backgroundColor: AppTheme.saffron,
        actions: [
          Icon(_connected ? Icons.wifi : Icons.wifi_off, color: Colors.white),
          SizedBox(width: 8)
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: false,
              itemCount: _messages.length,
              itemBuilder: (ctx, i) {
                final m = _messages[i];
                final isMe = (Provider.of<UserProvider>(context, listen: false).user?.id.toString() ?? '') == m.senderId;
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isMe ? AppTheme.saffron.withOpacity(0.95) : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3)],
                    ),
                    child: Text(m.text, style: TextStyle(color: isMe ? Colors.white : Colors.black87)),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      minLines: 1,
                      maxLines: 4,
                      decoration: InputDecoration.collapsed(hintText: 'Type a message...'),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: AppTheme.saffron),
                    onPressed: _sendMessage,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _ChatItem {
  final String senderId;
  final String text;
  _ChatItem({required this.senderId, required this.text});
}
