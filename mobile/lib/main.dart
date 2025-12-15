import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'providers/user_provider.dart';
import 'providers/booking_provider.dart';
import 'providers/language_provider.dart';
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

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PandittalkApp());
}

class PandittalkApp extends StatelessWidget {
  const PandittalkApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, langProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Pandittalk',
            theme: AppTheme.lightTheme,
            locale: langProvider.locale,
            supportedLocales: LanguageProvider.supportedLanguages
                .map((l) => Locale(l['code']!)),
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            initialRoute: '/',
        routes: {
          '/': (ctx) => const EntryDecider(),
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
          );
        },
      ),
    );
  }
}

class EntryDecider extends StatefulWidget {
  const EntryDecider({Key? key}) : super(key: key);

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
      ),
      body: screen,
    );
  }
}
