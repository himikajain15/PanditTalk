import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/user_provider.dart';
import 'providers/booking_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/home/pandit_list_screen.dart';
import 'utils/theme.dart';
// ignore: unused_import
import 'utils/constants.dart';
import 'screens/chat/chat_list_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/wallet/wallet_screen.dart';
import 'screens/bookings/bookings_history_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/call/live_pandits_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool isDark = true; // Default to dark theme
  try {
    final prefs = await SharedPreferences.getInstance();
    isDark = prefs.getBool('isDarkMode') ?? true; // Default to true (dark)
  } catch (e) {
    // 🧠 For web safety: shared_prefs sometimes fails on first load.
    debugPrint('SharedPreferences not available on web: $e');
  }

  runApp(PandittalkApp(isDarkMode: isDark));
}

class PandittalkApp extends StatefulWidget {
  final bool isDarkMode;
  const PandittalkApp({Key? key, required this.isDarkMode}) : super(key: key);

  @override
  State<PandittalkApp> createState() => _PandittalkAppState();
}

class _PandittalkAppState extends State<PandittalkApp> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
  }

  void _toggleTheme() async {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDarkMode', _isDarkMode);
    } catch (e) {
      debugPrint('Failed to save theme preference on web: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pandittalk',
        theme: _isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
        initialRoute: '/',
        routes: {
          '/': (ctx) =>
              EntryDecider(toggleTheme: _toggleTheme, isDarkMode: _isDarkMode),
          '/login': (ctx) => LoginScreen(),
          '/register': (ctx) => RegisterScreen(),
          '/home': (ctx) => HomeScreen(),
          '/pandits': (ctx) => PanditListScreen(),
          '/chats': (ctx) => ChatListScreen(),
          '/profile': (ctx) => ProfileScreen(),
          '/wallet': (ctx) => WalletScreen(),
          '/bookings': (ctx) => BookingsHistoryScreen(),
          '/settings': (ctx) => SettingsScreen(),
          '/live-pandits': (ctx) => LivePanditsScreen(),
        },
      ),
    );
  }
}

class EntryDecider extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const EntryDecider({
    Key? key,
    required this.toggleTheme,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  State<EntryDecider> createState() => _EntryDeciderState();
}

class _EntryDeciderState extends State<EntryDecider> {
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final userProv = Provider.of<UserProvider>(context, listen: false);
    await userProv.tryAutoLogin();
    if (mounted) {
      setState(() {
        _isInitializing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final userProv = Provider.of<UserProvider>(context, listen: true);
    final screen = userProv.isAuthenticated ? HomeScreen() : LoginScreen();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pandittalk"),
        actions: [
          IconButton(
            icon: Icon(
              widget.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
              color: AppTheme.white,
            ),
            onPressed: widget.toggleTheme,
            tooltip: 'Toggle Theme',
          ),
        ],
      ),
      body: screen,
    );
  }
}
