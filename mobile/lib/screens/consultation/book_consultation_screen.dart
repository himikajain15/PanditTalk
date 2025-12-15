import 'package:flutter/material.dart';
import '../../models/pandit.dart';
import '../../services/consultation_service.dart';

class BookConsultationScreen extends StatefulWidget {
  final Pandit pandit;

  const BookConsultationScreen({super.key, required this.pandit});

  @override
  State<BookConsultationScreen> createState() => _BookConsultationScreenState();
}

class _BookConsultationScreenState extends State<BookConsultationScreen> {
  String _selectedService = 'chat';
  int _duration = 15;
  final _queryController = TextEditingController();
  final _dobController = TextEditingController();
  final _timeController = TextEditingController();
  final _placeController = TextEditingController();
  bool _isLoading = false;

  double get _amount {
    final profile = widget.pandit.profile;
    if (profile == null) return 0;

    switch (_selectedService) {
      case 'chat':
        return profile.chatRate;
      case 'call':
        return profile.callRate;
      case 'video':
        return profile.videoRate;
      default:
        return 0;
    }
  }

  Future<void> _bookConsultation() async {
    if (_queryController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your query'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final result = await ConsultationService.createConsultationRequest(
      panditId: widget.pandit.id,
      serviceType: _selectedService,
      duration: _duration,
      amount: _amount,
      query: _queryController.text,
      birthDetails: {
        if (_dobController.text.isNotEmpty) 'dob': _dobController.text,
        if (_timeController.text.isNotEmpty) 'time': _timeController.text,
        if (_placeController.text.isNotEmpty) 'place': _placeController.text,
      },
    );

    setState(() => _isLoading = false);

    if (result['success']) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Request Sent!'),
          content: const Text(
            'Your consultation request has been sent to the pandit. You will be notified once they accept.',
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFC107),
                foregroundColor: Colors.black,
              ),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${result['error']}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Consultation'),
        backgroundColor: const Color(0xFFFFC107),
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pandit Info Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: const Color(0xFFFFC107),
                      child: widget.pandit.profilePic != null
                          ? ClipOval(
                              child: Image.network(
                                widget.pandit.profilePic!,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    const Icon(Icons.person, size: 30),
                              ),
                            )
                          : const Icon(Icons.person,
                              size: 30, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.pandit.username,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (widget.pandit.profile != null)
                            Text(
                              '${widget.pandit.profile!.experienceYears} years exp • ⭐ ${widget.pandit.profile!.averageRating.toStringAsFixed(1)}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Select Service Type
            const Text(
              'Select Service Type',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildServiceOption('chat', 'Chat Consultation', Icons.chat,
                widget.pandit.profile?.chatRate ?? 0),
            _buildServiceOption('call', 'Audio Call', Icons.call,
                widget.pandit.profile?.callRate ?? 0),
            _buildServiceOption('video', 'Video Call', Icons.videocam,
                widget.pandit.profile?.videoRate ?? 0),

            const SizedBox(height: 24),

            // Duration (for calls)
            if (_selectedService != 'chat') ...[
              const Text(
                'Duration',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildDurationChip(15),
                  const SizedBox(width: 8),
                  _buildDurationChip(30),
                  const SizedBox(width: 8),
                  _buildDurationChip(60),
                ],
              ),
              const SizedBox(height: 24),
            ],

            // Your Query
            const Text(
              'Your Query',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _queryController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Describe what you want to discuss...',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            // Birth Details (Optional)
            const Text(
              'Birth Details (Optional)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _dobController,
              decoration: const InputDecoration(
                labelText: 'Date of Birth',
                hintText: 'DD-MM-YYYY',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _timeController,
              decoration: const InputDecoration(
                labelText: 'Time of Birth',
                hintText: 'HH:MM AM/PM',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _placeController,
              decoration: const InputDecoration(
                labelText: 'Place of Birth',
                hintText: 'City, State',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            // Amount Summary
            Card(
              color: const Color(0xFFFFC107).withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Amount:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '₹${_amount.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Book Button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _bookConsultation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFC107),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ),
                      )
                    : const Text(
                        'Book & Pay ₹',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceOption(
      String value, String label, IconData icon, double rate) {
    final isSelected = _selectedService == value;

    return Card(
      elevation: isSelected ? 4 : 1,
      color: isSelected ? const Color(0xFFFFC107).withOpacity(0.2) : null,
      child: InkWell(
        onTap: () => setState(() => _selectedService = value),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFFFC107)
                      : Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: isSelected ? Colors.white : Colors.grey[600],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
              Text(
                '₹${rate.toInt()}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.green : Colors.black,
                ),
              ),
              const SizedBox(width: 8),
              if (isSelected)
                const Icon(Icons.check_circle, color: Color(0xFFFFC107)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDurationChip(int minutes) {
    final isSelected = _duration == minutes;
    return ChoiceChip(
      label: Text('$minutes min'),
      selected: isSelected,
      onSelected: (_) => setState(() => _duration = minutes),
      selectedColor: const Color(0xFFFFC107),
      backgroundColor: Colors.grey[200],
    );
  }

  @override
  void dispose() {
    _queryController.dispose();
    _dobController.dispose();
    _timeController.dispose();
    _placeController.dispose();
    super.dispose();
  }
}

