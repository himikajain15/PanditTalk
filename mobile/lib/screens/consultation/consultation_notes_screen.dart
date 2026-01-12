import 'package:flutter/material.dart';
import '../../utils/theme.dart';
import '../../utils/app_strings.dart';
import '../../models/booking.dart';

class ConsultationNotesScreen extends StatefulWidget {
  final Booking booking;

  const ConsultationNotesScreen({
    Key? key,
    required this.booking,
  }) : super(key: key);

  @override
  State<ConsultationNotesScreen> createState() => _ConsultationNotesScreenState();
}

class _ConsultationNotesScreenState extends State<ConsultationNotesScreen> {
  final _notesController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _notesController.text = widget.booking.notes ?? '';
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveNotes() async {
    // TODO: Save notes to backend
    setState(() => _isEditing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Notes saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryYellow,
        foregroundColor: AppTheme.black,
        title: Text('Consultation Notes'),
        actions: [
          if (_isEditing)
            IconButton(
              icon: Icon(Icons.save),
              onPressed: _saveNotes,
            )
          else
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Booking info
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Consultation Details',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('Pandit: ${widget.booking.pandit.username}'),
                    Text('Date: ${widget.booking.scheduledAt}'),
                    Text('Status: ${widget.booking.status}'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Notes section
            Text(
              'Your Notes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _notesController,
              enabled: _isEditing,
              maxLines: 15,
              decoration: InputDecoration(
                hintText: 'Add your notes from the consultation...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: !_isEditing,
                fillColor: _isEditing ? null : AppTheme.lightGray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

