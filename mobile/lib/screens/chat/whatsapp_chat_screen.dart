import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/pandit.dart';
import '../../utils/theme.dart';

class WhatsAppChatScreen extends StatefulWidget {
  final Pandit pandit;
  
  const WhatsAppChatScreen({required this.pandit, Key? key}) : super(key: key);

  @override
  State<WhatsAppChatScreen> createState() => _WhatsAppChatScreenState();
}

class _WhatsAppChatScreenState extends State<WhatsAppChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    // Load initial messages
    _loadMessages();
  }

  void _loadMessages() {
    // TODO: Load from API
    setState(() {
      _messages.addAll([
        ChatMessage(
          text: 'Namaste! How can I help you today?',
          isMe: false,
          timestamp: DateTime.now().subtract(Duration(minutes: 5)),
        ),
      ]);
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: _messageController.text,
        isMe: true,
        timestamp: DateTime.now(),
      ));
    });

    _messageController.clear();
    
    // Scroll to bottom
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    // Simulate response
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _messages.add(ChatMessage(
          text: 'I received your message. Let me help you with that.',
          isMe: false,
          timestamp: DateTime.now(),
        ));
      });
      
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryYellow,
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppTheme.white,
              child: Text(
                widget.pandit.username.isNotEmpty ? widget.pandit.username[0].toUpperCase() : 'P',
                style: TextStyle(
                  color: AppTheme.primaryYellow,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.pandit.username,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    widget.pandit.isOnline ? 'Online' : 'Offline',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.black.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Video call feature coming soon')),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.call),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Voice call feature coming soon')),
              );
            },
          ),
          PopupMenuButton(
            itemBuilder: (ctx) => [
              PopupMenuItem(
                child: Text('View Profile'),
                value: 'profile',
              ),
              PopupMenuItem(
                child: Text('Clear Chat'),
                value: 'clear',
              ),
              PopupMenuItem(
                child: Text('Block'),
                value: 'block',
              ),
            ],
            onSelected: (value) {
              if (value == 'clear') {
                setState(() {
                  _messages.clear();
                });
              }
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: isDark ? AppTheme.black : Color(0xFFECE5DD),
          image: isDark
              ? null
              : DecorationImage(
                  image: NetworkImage('https://i.imgur.com/qffvN7T.png'),
                  repeat: ImageRepeat.repeat,
                  opacity: 0.1,
                ),
        ),
        child: Column(
          children: [
            // Messages list
            Expanded(
              child: _messages.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 80,
                            color: AppTheme.mediumGray,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No messages yet',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppTheme.mediumGray,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Start a conversation with ${widget.pandit.username}',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.mediumGray,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.all(12),
                      itemCount: _messages.length,
                      itemBuilder: (ctx, i) {
                        return _buildMessageBubble(_messages[i]);
                      },
                    ),
            ),

            // Message input
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.darkGray : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    // Emoji button
                    IconButton(
                      icon: Icon(Icons.emoji_emotions_outlined, color: AppTheme.mediumGray),
                      onPressed: () {
                        // TODO: Show emoji picker
                      },
                    ),

                    // Text field
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: isDark ? AppTheme.mediumGray : Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: 'Type a message',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 10),
                          ),
                          maxLines: null,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                      ),
                    ),

                    SizedBox(width: 8),

                    // Send button
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.primaryYellow,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.send, color: AppTheme.black),
                        onPressed: _sendMessage,
                      ),
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

  Widget _buildMessageBubble(ChatMessage message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: message.isMe ? 60 : 0,
          right: message.isMe ? 0 : 60,
        ),
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: message.isMe
              ? (isDark ? AppTheme.primaryYellow.withOpacity(0.3) : AppTheme.primaryYellow)
              : (isDark ? AppTheme.darkGray : Colors.white),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message.text,
              style: TextStyle(
                fontSize: 15,
                color: message.isMe && !isDark ? AppTheme.black : null,
              ),
            ),
            SizedBox(height: 4),
            Text(
              DateFormat('HH:mm').format(message.timestamp),
              style: TextStyle(
                fontSize: 11,
                color: message.isMe && !isDark 
                    ? AppTheme.black.withOpacity(0.6)
                    : AppTheme.mediumGray,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class ChatMessage {
  final String text;
  final bool isMe;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.timestamp,
  });
}
