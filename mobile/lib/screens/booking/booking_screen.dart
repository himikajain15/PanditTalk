import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/pandit.dart';
import '../../providers/booking_provider.dart';
import '../../providers/user_provider.dart';

class BookingScreen extends StatefulWidget {
  final Pandit pandit;
  const BookingScreen({required this.pandit, Key? key}) : super(key: key);

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? _selected;
  int _duration = 15;
  bool _loading = false;
  String? _msg;

  void _pickDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 90)),
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          _selected = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  void _submit() async {
    if (_selected == null) return;

    setState(() {
      _loading = true;
      _msg = null;
    });

    final bp = Provider.of<BookingProvider>(context, listen: false);
    final userProv = Provider.of<UserProvider>(context, listen: false);
    final token = await userProv.auth.getToken();

    final res = await bp.createBooking(
      widget.pandit.id,
      _selected!.toUtc().toIso8601String(),
      _duration,
      token,
    );

    setState(() {
      _loading = false;
    });

    if (res['id'] != null) {
      setState(() {
        _msg = "Booking created successfully! Proceed to payment.";
      });
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } else {
      setState(() {
        _msg = "Booking failed. Please try again later.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dtText = _selected == null
        ? "Select date & time"
        : DateFormat.yMMMd().add_jm().format(_selected!);

    return Scaffold(
      appBar: AppBar(
        title: Text("Book ${widget.pandit.username}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: const Text("Pandit"),
              subtitle: Text(widget.pandit.username),
            ),
            const SizedBox(height: 8),
            ListTile(
              title: const Text("Expertise"),
              subtitle: Text(widget.pandit.expertise),
            ),
            const SizedBox(height: 8),
            ListTile(
              title: const Text("Fee / min"),
              subtitle: Text("₹ ${widget.pandit.feePerMinute.toStringAsFixed(2)}"),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _pickDate,
              child: Text(dtText),
            ),
            const SizedBox(height: 12),
            DropdownButton<int>(
              value: _duration,
              items: [15, 30, 45, 60]
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text("$e minutes"),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                if (v != null) setState(() => _duration = v);
              },
            ),
            const SizedBox(height: 20),
            if (_msg != null) Text(_msg!),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: (_selected == null || _loading) ? null : _submit,
              child: _loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Confirm Booking'),
            ),
          ],
        ),
      ),
    );
  }
}
