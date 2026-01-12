import 'dart:convert';
import 'package:flutter/material.dart';
import '../../config/constants.dart';
import '../../services/api_service.dart';
import 'login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers - Only Personal Information
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _dobController = TextEditingController();
  final _stateController = TextEditingController();
  final _addressController = TextEditingController();
  
  // State
  String _selectedGender = '';
  DateTime? _selectedDob;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _stateController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDob = picked;
        _dobController.text = '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  Future<void> _submitRegistration() async {
    if (!_formKey.currentState!.validate()) {
      _showError('Please fill all required fields correctly');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Prepare form data - Only personal information
      final formData = {
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'email': _emailController.text.trim(),
        'dob': _selectedDob!.toIso8601String(),
        'gender': _selectedGender,
        'state': _stateController.text.trim(),
        'address': _addressController.text.trim(),
        'registration_source': 'Pandit App',
      };

      final result = await ApiService.registerPandit(formData);

      setState(() => _isLoading = false);

      if (result['success']) {
        _showSuccess('Registration successful! Please login to continue.');
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        }
      } else {
        _showError(result['error'] ?? 'Registration failed. Please try again.');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Error: ${e.toString()}');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppConstants.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppConstants.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register as Pandit'),
        backgroundColor: AppConstants.primaryYellow,
        foregroundColor: AppConstants.black,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppConstants.primaryYellow.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppConstants.primaryYellow.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      '🕉️ Join PanditTalk',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter your personal information to get started. You can complete your profile after login.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppConstants.darkGrey,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Personal Information Section
              Text(
                'Personal Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.black,
                ),
              ),
              const SizedBox(height: 16),
              
              _buildTextField(_nameController, 'Full Name *', Icons.person, validator: (v) => v!.isEmpty ? 'Required' : null),
              _buildTextField(_phoneController, 'Phone Number *', Icons.phone, keyboardType: TextInputType.phone, maxLength: 10, validator: (v) => v!.length != 10 ? 'Enter 10-digit number' : null),
              _buildTextField(_emailController, 'Email Address *', Icons.email, keyboardType: TextInputType.emailAddress, validator: (v) => !v!.contains('@') ? 'Invalid email' : null),
              
              // Date of Birth
              TextFormField(
                controller: _dobController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Date of Birth *',
                  prefixIcon: Icon(Icons.calendar_today, color: AppConstants.primaryYellow),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onTap: () => _selectDate(context),
                validator: (v) => _selectedDob == null ? 'Required' : null,
              ),
              
              const SizedBox(height: 16),
              
              // Gender
              DropdownButtonFormField<String>(
                value: _selectedGender.isEmpty ? null : _selectedGender,
                decoration: InputDecoration(
                  labelText: 'Gender *',
                  prefixIcon: Icon(Icons.person_outline, color: AppConstants.primaryYellow),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: ['Male', 'Female', 'Other'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                onChanged: (v) => setState(() => _selectedGender = v ?? ''),
                validator: (v) => v == null ? 'Required' : null,
              ),
              
              const SizedBox(height: 16),
              
              _buildTextField(_stateController, 'State *', Icons.location_on, validator: (v) => v!.isEmpty ? 'Required' : null),
              _buildTextField(_addressController, 'Full Address *', Icons.home, maxLines: 2, validator: (v) => v!.isEmpty ? 'Required' : null),
              
              const SizedBox(height: 32),
              
              // Submit Button
              Container(
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(colors: [AppConstants.primaryYellow, AppConstants.darkYellow]),
                  boxShadow: [BoxShadow(color: AppConstants.primaryYellow.withOpacity(0.4), blurRadius: 15, offset: Offset(0, 5))],
                ),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitRegistration,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _isLoading
                      ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation<Color>(AppConstants.black)))
                      : const Text('Submit Registration', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppConstants.black, letterSpacing: 1)),
                ),
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType? keyboardType,
    int? maxLines = 1,
    int? maxLength,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AppConstants.primaryYellow),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
          counterText: maxLength != null ? '' : null,
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
        maxLength: maxLength,
        validator: validator,
      ),
    );
  }
}

