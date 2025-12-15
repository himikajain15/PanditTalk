import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class AppConstants {
  // Using localhost with USB reverse forwarding
  // adb reverse tcp:8000 tcp:8000 forwards phone's localhost:8000 to PC's localhost:8000
  static const String baseUrl = 'http://localhost:8000/api';
  
  // API Endpoints
  static const String loginEndpoint = '/auth/login/';
  static const String sendOtpEndpoint = '/auth/send-otp/';
  static const String verifyOtpEndpoint = '/auth/verify-otp/';
  static const String profileEndpoint = '/pandit/profile/me/';
  static const String dashboardEndpoint = '/pandit/dashboard/';
  static const String updateAvailabilityEndpoint = '/pandit/profile/update_availability/';
  static const String pendingRequestsEndpoint = '/pandit/consultations/pending/';
  static const String activeConsultationsEndpoint = '/pandit/consultations/active/';
  static const String historyEndpoint = '/pandit/consultations/history/';
  static const String earningsEndpoint = '/pandit/earnings/';
  static const String payoutsEndpoint = '/pandit/payouts/';
  static const String reviewsEndpoint = '/pandit/reviews/';
  
  // Actions
  static String acceptRequest(int id) => '/pandit/consultations/$id/accept/';
  static String rejectRequest(int id) => '/pandit/consultations/$id/reject/';
  static String completeRequest(int id) => '/pandit/consultations/$id/complete/';
  
  // Colors - Yellow/White/Black Theme
  static const Color primaryYellow = Color(0xFFFFC107);
  static const Color darkYellow = Color(0xFFFFB300);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color darkGrey = Color(0xFF616161);
  static const Color green = Color(0xFF4CAF50);
  static const Color red = Color(0xFFF44336);
  static const Color orange = Color(0xFFFF9800);
  static const Color blue = Color(0xFF2196F3);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryYellow, darkYellow],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Text Styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: black,
  );
  
  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: black,
  );
  
  static const TextStyle bodyStyle = TextStyle(
    fontSize: 14,
    color: black,
  );
  
  static const TextStyle captionStyle = TextStyle(
    fontSize: 12,
    color: grey,
  );
  
  // Shared Preferences Keys
  static const String keyToken = 'auth_token';
  static const String keyUserId = 'user_id';
  static const String keyUsername = 'username';
  static const String keyPhone = 'phone';
  static const String keyIsPandit = 'is_pandit';
  static const String keyProfilePic = 'profile_pic';
  
  // Service Types
  static const String serviceChat = 'chat';
  static const String serviceCall = 'call';
  static const String serviceVideo = 'video';
  
  // Status
  static const String statusPending = 'pending';
  static const String statusAccepted = 'accepted';
  static const String statusRejected = 'rejected';
  static const String statusInProgress = 'in_progress';
  static const String statusCompleted = 'completed';
  static const String statusCancelled = 'cancelled';
  
  // Availability
  static const String availabilityAvailable = 'available';
  static const String availabilityBusy = 'busy';
  static const String availabilityOffline = 'offline';
  
  // Spacing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  
  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  
  // Icon Sizes
  static const double iconSmall = 20.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
}

