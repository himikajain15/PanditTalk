import 'package:flutter/material.dart';
import '../../utils/theme.dart';
import '../chat/chatbot_screen.dart';
import '../../utils/app_strings.dart';

class FreeKundliScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.getString(context, 'freeKundli', fallback: 'Free Kundli (AI)')),
        backgroundColor: AppTheme.primaryYellow,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.auto_graph, size: 80, color: AppTheme.primaryYellow),
              SizedBox(height: 20),
              Text(
                AppStrings.getString(context, 'aiPoweredKundliAnalysis', fallback: 'AI-Powered Kundli Analysis'),
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Text(
                AppStrings.getString(context, 'getInstantKundliReading', fallback: 'Get instant Kundli reading powered by AI'),
                style: TextStyle(fontSize: 14, color: AppTheme.mediumGray),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AIKundaliChatScreen())),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryYellow,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: Text(
                  AppStrings.getString(context, 'startAIKundliChat', fallback: 'Start AI Kundli Chat'),
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

