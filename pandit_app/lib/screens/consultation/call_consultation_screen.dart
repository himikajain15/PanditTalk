import 'package:flutter/material.dart';
import '../../config/constants.dart';
import '../../models/consultation_request.dart';

class CallConsultationScreen extends StatelessWidget {
  final ConsultationRequest request;

  const CallConsultationScreen({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Call with ${request.userName}'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.call,
              size: 72,
              color: AppConstants.green,
            ),
            const SizedBox(height: 12),
            Text(
              request.userName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Live call UI & timer will appear here.\nUse this as a preview screen for now.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppConstants.grey),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.call_end),
                  label: const Text('End Call'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.red,
                    foregroundColor: AppConstants.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 10,
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
}


