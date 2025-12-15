// lib/screens/auth/otp_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../providers/user_provider.dart';
import '../../utils/theme.dart';

class OtpScreen extends StatefulWidget {
  final String phone;
  const OtpScreen({Key? key, required this.phone}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpController = TextEditingController();
  bool _loading = false;
  String? _error;

  void _verify() async {
    final otp = _otpController.text.trim();
    if (otp.length < 4) {
      setState(() => _error = 'Enter the OTP');
      return;
    }

    setState(() { _loading = true; _error = null; });
    final auth = AuthService();
    final res = await auth.verifyOtp(widget.phone, otp);
    setState(() => _loading = false);

    if (res['ok'] == true && res.containsKey('user')) {
      // Update user provider with new user data
      final userProv = Provider.of<UserProvider>(context, listen: false);
      await userProv.updateUserAfterOtp();
      
      // Check if the mounted property is true before navigating
      if (!mounted) return;
      
      // navigate to home
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() => _error = res['error'] ?? 'OTP verification failed. Try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final saffron = AppTheme.saffron;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify OTP"),
        backgroundColor: saffron,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Enter the OTP sent to ${widget.phone}", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            TextField(
              controller: _otpController,
              maxLength: 6,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "123456",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 16),
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _verify,
                    style: ElevatedButton.styleFrom(backgroundColor: saffron),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
                      child: Text("Verify & Continue", style: TextStyle(fontSize: 16)),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
