import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pandittalk_app/providers/user_provider.dart';
import 'package:pandittalk_app/providers/booking_provider.dart';
import 'package:pandittalk_app/screens/auth/login_screen.dart';

void main() {
  testWidgets('Login screen UI test', (WidgetTester tester) async {
    // Wrap LoginScreen with the same providers as in main.dart
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(create: (_) => BookingProvider()),
        ],
        child: MaterialApp(home: LoginScreen()),
      ),
    );

    // Expect 2 input fields
    expect(find.byType(TextField), findsNWidgets(2));

    // Expect at least one widget with "Login" text
    final loginFinder = find.textContaining(RegExp(r'login', caseSensitive: false));
    expect(loginFinder, findsAtLeastNWidgets(1));

    // Tap login button safely
    await tester.tap(loginFinder.first);
    await tester.pump();

    // If no exceptions -> pass
  });
}
