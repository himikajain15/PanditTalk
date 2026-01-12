import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../utils/theme.dart';
import '../../utils/app_strings.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import 'dart:convert';

class PalmistryScreen extends StatefulWidget {
  const PalmistryScreen({Key? key}) : super(key: key);

  @override
  State<PalmistryScreen> createState() => _PalmistryScreenState();
}

class _PalmistryScreenState extends State<PalmistryScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _leftHandImage;
  File? _rightHandImage;
  bool _analyzing = false;
  String? _analysisResult;
  String? _error;

  Future<void> _pickImage(bool isLeftHand) async {
    try {
      // Show dialog to choose camera or gallery
      final ImageSource? source = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            AppStrings.getString(
              context,
              'selectImageSource',
              fallback: 'Select Image Source',
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text(
                  AppStrings.getString(
                    context,
                    'camera',
                    fallback: 'Camera',
                  ),
                ),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text(
                  AppStrings.getString(
                    context,
                    'gallery',
                    fallback: 'Gallery',
                  ),
                ),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        ),
      );

      if (source == null) return;

      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          if (isLeftHand) {
            _leftHandImage = File(image.path);
          } else {
            _rightHandImage = File(image.path);
          }
          _analysisResult = null;
          _error = null;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to pick image: $e';
      });
    }
  }

  Future<void> _analyzePalms() async {
    if (_leftHandImage == null && _rightHandImage == null) {
      setState(() {
        _error = 'Please upload at least one hand photo';
      });
      return;
    }

    setState(() {
      _analyzing = true;
      _error = null;
      _analysisResult = null;
    });

    try {
      final authService = AuthService();
      final token = await authService.getToken();
      final api = ApiService();

      // Convert images to base64
      List<Map<String, String>> images = [];
      if (_leftHandImage != null) {
        final leftBytes = await _leftHandImage!.readAsBytes();
        final leftBase64 = base64Encode(leftBytes);
        images.add({
          'hand': 'left',
          'image': 'data:image/jpeg;base64,$leftBase64',
        });
      }
      if (_rightHandImage != null) {
        final rightBytes = await _rightHandImage!.readAsBytes();
        final rightBase64 = base64Encode(rightBytes);
        images.add({
          'hand': 'right',
          'image': 'data:image/jpeg;base64,$rightBase64',
        });
      }

      // Call OpenAI API through backend
      // Use longer timeout (120 seconds) for OpenAI API calls
      final response = await api.post(
        '/api/core/palmistry/analyze/',
        {
          'images': images,
        },
        token: token,
        timeout: const Duration(seconds: 120), // 2 minutes for OpenAI processing
      );

      if (mounted) {
        setState(() {
          _analyzing = false;
          if (response is Map && response.containsKey('analysis')) {
            _analysisResult = response['analysis'];
          } else if (response is Map && response.containsKey('error')) {
            String errorMsg = response['error'].toString();
            // Check for quota/API key errors
            if (response['error_type'] == 'quota_exceeded' || 
                errorMsg.toLowerCase().contains('quota') ||
                errorMsg.toLowerCase().contains('billing')) {
              _error = 'Gemini API quota exceeded. Please check your API key at https://aistudio.google.com/app/apikey';
            } else if (response['error_type'] == 'authentication_error' ||
                       errorMsg.toLowerCase().contains('api key') ||
                       errorMsg.toLowerCase().contains('authentication')) {
              _error = 'Invalid Gemini API key. Please configure GEMINI_API_KEY in backend settings.';
            } else {
              _error = errorMsg;
            }
          } else {
            _error = 'Failed to analyze palms. Please try again.';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _analyzing = false;
          _error = 'Error: ${e.toString()}';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryYellow,
        foregroundColor: AppTheme.black,
        title: Text(
          AppStrings.getString(context, 'palmistry', fallback: 'Palmistry Reading'),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Instructions
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryYellow.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: AppTheme.primaryYellow),
                      SizedBox(width: 8),
                      Text(
                        AppStrings.getString(
                          context,
                          'palmistryInstructions',
                          fallback: 'How to take photos:',
                        ),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    AppStrings.getString(
                      context,
                      'palmistryInstructionsText',
                      fallback:
                          '• Place your hand on a flat surface\n• Ensure good lighting\n• Keep fingers together and palm flat\n• Take clear, focused photos\n• Upload both hands for complete analysis',
                    ),
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Left Hand
            Text(
              AppStrings.getString(context, 'leftHand', fallback: 'Left Hand'),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            GestureDetector(
              onTap: () => _pickImage(true),
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.lightGray,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _leftHandImage != null
                        ? AppTheme.primaryYellow
                        : AppTheme.mediumGray,
                    width: 2,
                  ),
                ),
                child: _leftHandImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          _leftHandImage!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate,
                            size: 48,
                            color: AppTheme.mediumGray,
                          ),
                          SizedBox(height: 8),
                          Text(
                            AppStrings.getString(
                              context,
                              'tapToUpload',
                              fallback: 'Tap to upload left hand',
                            ),
                            style: TextStyle(color: AppTheme.mediumGray),
                          ),
                        ],
                      ),
              ),
            ),
            SizedBox(height: 24),

            // Right Hand
            Text(
              AppStrings.getString(context, 'rightHand', fallback: 'Right Hand'),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            GestureDetector(
              onTap: () => _pickImage(false),
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.lightGray,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _rightHandImage != null
                        ? AppTheme.primaryYellow
                        : AppTheme.mediumGray,
                    width: 2,
                  ),
                ),
                child: _rightHandImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          _rightHandImage!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate,
                            size: 48,
                            color: AppTheme.mediumGray,
                          ),
                          SizedBox(height: 8),
                          Text(
                            AppStrings.getString(
                              context,
                              'tapToUploadRight',
                              fallback: 'Tap to upload right hand',
                            ),
                            style: TextStyle(color: AppTheme.mediumGray),
                          ),
                        ],
                      ),
              ),
            ),
            SizedBox(height: 24),

            // Analyze Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _analyzing ? null : _analyzePalms,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryYellow,
                  foregroundColor: AppTheme.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _analyzing
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.black),
                        ),
                      )
                    : Text(
                        AppStrings.getString(
                          context,
                          'analyzePalms',
                          fallback: 'Analyze Palms',
                        ),
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ),

            // Error Message
            if (_error != null) ...[
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _error!,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Analysis Result
            if (_analysisResult != null) ...[
              SizedBox(height: 24),
              Text(
                AppStrings.getString(
                  context,
                  'palmistryAnalysis',
                  fallback: 'Palmistry Analysis',
                ),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.primaryYellow.withOpacity(0.3)),
                ),
                child: Text(
                  _analysisResult!,
                  style: TextStyle(fontSize: 14, height: 1.6),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

