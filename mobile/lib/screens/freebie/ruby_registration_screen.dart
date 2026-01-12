import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/theme.dart';
import '../../utils/app_strings.dart';
import '../../providers/user_provider.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';

class RubyRegistrationScreen extends StatefulWidget {
  const RubyRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RubyRegistrationScreen> createState() => _RubyRegistrationScreenState();
}

class _RubyRegistrationScreenState extends State<RubyRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _landmarkController = TextEditingController();

  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (user != null) {
      _nameController.text = user.username;
      _phoneController.text = user.phone ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _landmarkController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);

    try {
      final authService = AuthService();
      final token = await authService.getToken();
      final api = ApiService();

      final body = {
        'full_name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'full_address': _addressController.text.trim(),
        'city': _cityController.text.trim(),
        'state': _stateController.text.trim(),
        'pincode': _pincodeController.text.trim(),
        'landmark': _landmarkController.text.trim(),
      };

      final res = await api.post('/api/core/ruby/register/', body, token: token);

      if (!mounted) return;
      setState(() => _submitting = false);

      if (res is Map && res.containsKey('error')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res['error'] ?? 'Failed to submit details'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppStrings.getString(
                context,
                'rubyRegistrationSuccess',
                fallback: 'Details submitted! Our team will contact you for delivery.',
              ),
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryYellow,
        foregroundColor: AppTheme.black,
        title: Text(
          AppStrings.getString(context, 'rubyRegistrationTitle', fallback: 'Ruby Delivery Details'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.getString(
                  context,
                  'rubyRegistrationSubtitle',
                  fallback: 'Please share your contact and full address to receive your Ruby gift.',
                ),
                style: TextStyle(fontSize: 14, color: AppTheme.mediumGray),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                labelKey: 'name',
                controller: _nameController,
              ),
              _buildTextField(
                labelKey: 'phone',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
              ),
              _buildTextField(
                labelKey: 'fullAddress',
                controller: _addressController,
                maxLines: 3,
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      labelKey: 'city',
                      controller: _cityController,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      labelKey: 'state',
                      controller: _stateController,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      labelKey: 'pincode',
                      controller: _pincodeController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      labelKey: 'landmark',
                      controller: _landmarkController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryYellow,
                    foregroundColor: AppTheme.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: _submitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          AppStrings.getString(
                            context,
                            'submitDetails',
                            fallback: 'Submit Details',
                          ),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String labelKey,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: (value) {
          if (labelKey == 'landmark') {
            // Landmark is optional
            return null;
          }
          if (value == null || value.trim().isEmpty) {
            return AppStrings.getString(context, 'required', fallback: 'Required');
          }
          if (labelKey == 'phone' && value.length < 10) {
            return AppStrings.getString(context, 'enterValidPhone', fallback: 'Please enter a valid phone number');
          }
          if (labelKey == 'pincode' && value.length != 6) {
            return 'Pincode must be 6 digits';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: AppStrings.getString(context, labelKey, fallback: labelKey),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}


