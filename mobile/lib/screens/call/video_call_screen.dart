import 'package:flutter/material.dart';
import '../../utils/theme.dart';
import '../../utils/app_strings.dart';
import '../../models/pandit.dart';

class VideoCallScreen extends StatefulWidget {
  final Pandit pandit;
  final int? bookingId;

  const VideoCallScreen({
    Key? key,
    required this.pandit,
    this.bookingId,
  }) : super(key: key);

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  bool _isMuted = false;
  bool _isVideoOff = false;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    // Simulate connection
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isConnected = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Video area
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!_isConnected)
                    CircularProgressIndicator(color: AppTheme.primaryYellow)
                  else
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: AppTheme.primaryYellow.withOpacity(0.3),
                          child: Text(
                            widget.pandit.username[0].toUpperCase(),
                            style: TextStyle(
                              fontSize: 48,
                              color: AppTheme.primaryYellow,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          widget.pandit.username,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          _isConnected ? 'Connected' : 'Connecting...',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            // Controls
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildControlButton(
                    icon: _isMuted ? Icons.mic_off : Icons.mic,
                    label: _isMuted ? 'Unmute' : 'Mute',
                    onPressed: () => setState(() => _isMuted = !_isMuted),
                    color: _isMuted ? Colors.red : Colors.white,
                  ),
                  _buildControlButton(
                    icon: Icons.videocam_off,
                    label: 'Video',
                    onPressed: () => setState(() => _isVideoOff = !_isVideoOff),
                    color: _isVideoOff ? Colors.red : Colors.white,
                  ),
                  _buildControlButton(
                    icon: Icons.call_end,
                    label: 'End',
                    onPressed: () => Navigator.pop(context),
                    color: Colors.red,
                    isLarge: true,
                  ),
                ],
              ),
            ),

            // Top info
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '00:00',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
    bool isLarge = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: isLarge ? 64 : 56,
          height: isLarge ? 64 : 56,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(icon, color: isLarge ? Colors.white : Colors.black),
            onPressed: onPressed,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }
}

