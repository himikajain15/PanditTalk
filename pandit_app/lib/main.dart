import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/constants.dart';
import 'screens/auth/welcome_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PanditApp());
}

class PanditApp extends StatelessWidget {
  const PanditApp({super.key});

  Future<bool> _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.keyToken) != null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PanditTalk - Pandit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppConstants.primaryYellow,
        scaffoldBackgroundColor: AppConstants.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppConstants.primaryYellow,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppConstants.primaryYellow,
          foregroundColor: AppConstants.black,
          elevation: 0,
        ),
        fontFamily: 'Poppins',
      ),
      home: FutureBuilder<bool>(
        future: _checkLogin(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: AppConstants.primaryYellow,
                ),
              ),
            );
          }
          return snapshot.data == true
              ? const DashboardScreen()
              : const WelcomeScreen();
        },
      ),
    );
  }
}
