import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../providers/user_provider.dart';
import '../../services/api_service.dart';
import '../../utils/theme.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  bool _loading = false;
  final ApiService api = ApiService();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (user != null) {
      _nameCtrl.text = user.username;
      _bioCtrl.text = user.karmaPoints != null ? "" : ""; // keep simple
    }
  }

  Future<void> _save() async {
    setState(() => _loading = true);
    final token = await Provider.of<UserProvider>(context, listen: false).auth.getToken();
    // Simple patch to /api/auth/me/ if available. If your backend uses different endpoint, adapt.
    final res = await api.post('/api/auth/me/', {
      'username': _nameCtrl.text.trim(),
      'bio': _bioCtrl.text.trim(),
      'phone': _phoneCtrl.text.trim()
    }, token: token);
    setState(() => _loading = false);
    // best-effort success handling
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Profile update requested.")));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _bioCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    
    return Scaffold(
      appBar: AppBar(title: Text("Edit Profile"), backgroundColor: AppTheme.primaryYellow),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Profile Picture Section
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: AppTheme.lightYellow,
                    backgroundImage: _selectedImage != null ? FileImage(_selectedImage!) : null,
                    child: _selectedImage == null
                        ? Text(
                            user?.username?[0].toUpperCase() ?? 'U',
                            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppTheme.primaryYellow),
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: _pickImage,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryYellow,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Icon(Icons.camera_alt, size: 20, color: AppTheme.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            
            // Form Fields
            TextField(
              controller: _nameCtrl,
              decoration: InputDecoration(
                labelText: "Display Name",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: Icon(Icons.person, color: AppTheme.primaryYellow),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _phoneCtrl,
              decoration: InputDecoration(
                labelText: "Phone",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: Icon(Icons.phone, color: AppTheme.primaryYellow),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _bioCtrl,
              decoration: InputDecoration(
                labelText: "Bio",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: Icon(Icons.info_outline, color: AppTheme.primaryYellow),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
            ),
            SizedBox(height: 24),
            
            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryYellow,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _loading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: AppTheme.black, strokeWidth: 2),
                      )
                    : Text("Save Changes", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
