import 'package:flutter/material.dart';
import '../../config/constants.dart';
import '../../models/consultation_request.dart';

class ChatConsultationScreen extends StatelessWidget {
  final ConsultationRequest request;

  const ChatConsultationScreen({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${request.userName}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              children: const [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Live chat UI coming soon.\nUse this as a preview of consultation context.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppConstants.grey),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(AppConstants.paddingSmall),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryYellow,
                    foregroundColor: AppConstants.black,
                  ),
                  child: const Icon(Icons.send, size: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


