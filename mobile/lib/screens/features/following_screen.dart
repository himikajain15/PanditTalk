import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class FollowingScreen extends StatelessWidget {
  const FollowingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Following'),
        backgroundColor: AppTheme.primaryYellow,
      ),
      body: const Center(
        child: Text('Your favorite pandits will appear here'),
      ),
    );
  }
}

