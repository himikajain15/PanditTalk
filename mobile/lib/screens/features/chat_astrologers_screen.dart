import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class ChatAstrologersScreen extends StatelessWidget {
  const ChatAstrologersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with Astrologers'),
        backgroundColor: AppTheme.primaryYellow,
      ),
      body: const Center(
        child: Text('Chat with Astrologers - Coming Soon!'),
      ),
    );
  }
}

