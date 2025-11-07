import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/theme.dart';
import '../../providers/user_provider.dart';
import '../../services/auth_service.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  String _selectedCountryCode = '+91';

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _getOTP() async {
    final phone = _phoneController.text.trim();
    
    if (phone.isEmpty || phone.length < 10) {
      _showSnack("Please enter a valid 10-digit phone number");
      return;
    }
    
    setState(() => _isLoading = true);
    // Navigate to OTP screen
    await Future.delayed(Duration(seconds: 1));
    setState(() => _isLoading = false);
    
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => OtpScreen(phone: _selectedCountryCode + phone)),
    );
  }

  void _loginWithGoogle() {
    _showSnack("Google Sign-In coming soon!");
    // TODO: Implement Google Sign-In
  }

  void _loginWithEmail() {
    _showSnack("Email login coming soon!");
    // TODO: Navigate to email/password login screen
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: screenHeight - MediaQuery.of(context).padding.top),
            child: Column(
              children: [
                // Top section with illustration
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                  child: Column(
                    children: [
                      // Skip button
                      Align(
                        alignment: Alignment.topRight,
                        child: TextButton(
                          onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                          child: Text('Skip', style: TextStyle(color: AppTheme.mediumGray)),
                        ),
                      ),
                      
                      SizedBox(height: 20),
                      
                      // Illustration placeholder (using emoji for now)
                      Container(
                        height: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('🪐', style: TextStyle(fontSize: 80)),
                            SizedBox(height: 8),
                            Text('⭐', style: TextStyle(fontSize: 40)),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 20),
                      
                      // App name
                      Text(
                        'PanditTalk',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.black,
                        ),
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Free chat banner
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppTheme.white,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: AppTheme.lightGray),
                        ),
                        child: Text(
                          'First Chat with Astrologer is FREE!',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Login section with yellow background
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.primaryYellow,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  padding: EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Phone number input
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: Row(
                          children: [
                            // Country code dropdown
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                children: [
                                  Text('🇮🇳', style: TextStyle(fontSize: 20)),
                                  SizedBox(width: 4),
                                  Text('IN +91', style: TextStyle(fontWeight: FontWeight.w600)),
                                  Icon(Icons.arrow_drop_down, size: 20),
                                ],
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 30,
                              color: AppTheme.lightGray,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                maxLength: 10,
                                decoration: InputDecoration(
                                  hintText: 'Phone number',
                                  border: InputBorder.none,
                                  counterText: '',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 16),
                      
                      // GET OTP Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _getOTP,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.black,
                            foregroundColor: AppTheme.white,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(color: AppTheme.white, strokeWidth: 2),
                                )
                              : Text('GET OTP', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      
                      SizedBox(height: 12),
                      
                      // Terms
                      Text(
                        'By signing up, you agree to our Terms of Use and Privacy Policy',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 11, color: AppTheme.black.withOpacity(0.7)),
                      ),
                      
                      SizedBox(height: 20),
                      
                      // Divider with "Or"
                      Row(
                        children: [
                          Expanded(child: Divider(color: AppTheme.black.withOpacity(0.3))),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text('Or', style: TextStyle(color: AppTheme.black.withOpacity(0.7))),
                          ),
                          Expanded(child: Divider(color: AppTheme.black.withOpacity(0.3))),
                        ],
                      ),
                      
                      SizedBox(height: 20),
                      
                      // Social login buttons
                      _buildSocialButton(
                        icon: Icons.email,
                        label: 'Continue with Email',
                        onTap: _loginWithEmail,
                      ),
                      
                      SizedBox(height: 12),
                      
                      _buildSocialButton(
                        icon: Icons.g_mobiledata,
                        label: 'Continue with Google',
                        onTap: _loginWithGoogle,
                      ),
                      
                      SizedBox(height: 24),
                      
                      // Bottom stats
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStat('100%', 'Privacy'),
                          Container(width: 1, height: 30, color: AppTheme.black.withOpacity(0.2)),
                          _buildStat('1000+', 'Top astrologers\nof India'),
                          Container(width: 1, height: 30, color: AppTheme.black.withOpacity(0.2)),
                          _buildStat('3Cr+', 'Happy\ncustomers'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.lightGray),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: AppTheme.black),
            SizedBox(width: 12),
            Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.black,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            color: AppTheme.black.withOpacity(0.7),
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
