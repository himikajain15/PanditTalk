import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../config/constants.dart';
import '../../models/consultation_request.dart';
import '../../services/api_service.dart';
import '../consultation/chat_consultation_screen.dart';
import '../consultation/call_consultation_screen.dart';

class ConsultationDetailScreen extends StatefulWidget {
  final ConsultationRequest request;

  const ConsultationDetailScreen({super.key, required this.request});

  @override
  State<ConsultationDetailScreen> createState() => _ConsultationDetailScreenState();
}

class _ConsultationDetailScreenState extends State<ConsultationDetailScreen> {
  late TextEditingController _notesController;
  late TextEditingController _remediesController;
  bool _saving = false;
  bool _aiLoading = false;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: widget.request.panditNotes ?? '');
    _remediesController = TextEditingController(text: widget.request.recommendedRemedies ?? '');
  }

  @override
  void dispose() {
    _notesController.dispose();
    _remediesController.dispose();
    super.dispose();
  }

  Future<void> _saveNotes() async {
    setState(() => _saving = true);
    final result = await ApiService.updateConsultationNotes(
      widget.request.id,
      _notesController.text.trim(),
      _remediesController.text.trim(),
    );
    setState(() => _saving = false);

    if (!mounted) return;

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notes saved'),
          backgroundColor: AppConstants.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['error']?.toString() ?? 'Failed to save notes'),
          backgroundColor: AppConstants.red,
        ),
      );
    }
  }

  Future<void> _generateAiRemedies() async {
    setState(() => _aiLoading = true);
    final result = await ApiService.generateAiRemedies(
      widget.request.id,
      notes: _notesController.text.trim(),
    );
    setState(() => _aiLoading = false);

    if (!mounted) return;

    if (result['success'] == true && result['data']?['remedies'] != null) {
      setState(() {
        _remediesController.text = result['data']['remedies'] as String;
      });
    } else {
      final errorText = result['data']?['error']?.toString() ??
          result['error']?.toString() ??
          'Could not generate remedies';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorText),
          backgroundColor: AppConstants.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final req = widget.request;
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    final timeFormat = DateFormat('dd MMM, hh:mm a');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultation Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User & service summary
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: AppConstants.primaryYellow,
                          child: req.userProfilePic != null
                              ? ClipOval(
                                  child: Image.network(
                                    req.userProfilePic!,
                                    width: 52,
                                    height: 52,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        const Icon(Icons.person, color: AppConstants.white),
                                  ),
                                )
                              : const Icon(Icons.person, color: AppConstants.white, size: 30),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                req.userName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (req.userPhone != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  req.userPhone!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppConstants.grey,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 4),
                              Text(
                                timeFormat.format(req.createdAt),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppConstants.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          req.serviceType == AppConstants.serviceChat
                              ? Icons.chat
                              : req.serviceType == AppConstants.serviceCall
                                  ? Icons.call
                                  : Icons.videocam,
                          size: 20,
                          color: AppConstants.primaryYellow,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          req.serviceTypeDisplay,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${req.duration} min',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppConstants.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Total Amount',
                              style: TextStyle(fontSize: 12, color: AppConstants.grey),
                            ),
                            Text(
                              currencyFormat.format(req.amount),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'You Earn',
                              style: TextStyle(fontSize: 12, color: AppConstants.grey),
                            ),
                            Text(
                              currencyFormat.format(req.panditEarnings),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppConstants.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // User query & birth details
            if ((req.userQuery != null && req.userQuery!.isNotEmpty) ||
                (req.birthDetails != null && req.birthDetails!.isNotEmpty)) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (req.userQuery != null && req.userQuery!.isNotEmpty) ...[
                        const Text(
                          'User Query',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          req.userQuery!,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 12),
                      ],
                      if (req.birthDetails != null && req.birthDetails!.isNotEmpty) ...[
                        const Text(
                          'Birth Details',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        ...req.birthDetails!.entries.map(
                          (e) => Text(
                            '${e.key}: ${e.value}',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],

            // Notes & remedies
            Text(
              'Pandit Notes',
              style: AppConstants.subheadingStyle,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Your understanding, important points to remember, patterns you see…',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Text(
                  'Suggested Remedies',
                  style: AppConstants.subheadingStyle,
                ),
                const SizedBox(width: 8),
                if (_aiLoading)
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppConstants.primaryYellow,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _remediesController,
              maxLines: 8,
              decoration: const InputDecoration(
                hintText: 'Write or generate structured remedies you will share with the user…',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _aiLoading ? null : _generateAiRemedies,
                    icon: const Icon(Icons.auto_awesome, size: 18),
                    label: const Text('AI Suggest Remedies'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _saving ? null : _saveNotes,
                    icon: _saving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppConstants.white,
                            ),
                          )
                        : const Icon(Icons.save, size: 18),
                    label: const Text('Save Notes'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.primaryYellow,
                      foregroundColor: AppConstants.black,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Chat / Call entry points (placeholder for now)
            Text(
              'Start Consultation',
              style: AppConstants.subheadingStyle,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatConsultationScreen(request: req),
                        ),
                      );
                    },
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: const Text('Start Chat'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.white,
                      foregroundColor: AppConstants.black,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CallConsultationScreen(request: req),
                        ),
                      );
                    },
                    icon: const Icon(Icons.call),
                    label: const Text('Start Call'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.green,
                      foregroundColor: AppConstants.white,
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


