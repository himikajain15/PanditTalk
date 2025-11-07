import 'package:flutter/material.dart';

class AppTheme {
  // Professional Yellow/White/Black Theme
  static const Color primaryYellow = Color(0xFFFFC107);  // Vibrant yellow
  static const Color darkYellow = Color(0xFFFFB300);     // Darker yellow accent
  static const Color lightYellow = Color(0xFFFFF9C4);    // Light yellow background
  static const Color accentYellow = Color(0xFFFFD54F);   // Medium yellow
  
  static const Color white = Colors.white;
  static const Color black = Color(0xFF212121);
  static const Color darkGray = Color(0xFF424242);
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color mediumGray = Color(0xFF757575);
  
  // Backwards-compatible aliases
  static const Color gold = primaryYellow;
  static const Color yellow = accentYellow;
  static const Color saffron = primaryYellow;
  static const Color deepSaffron = darkYellow;
  static const Color lightGold = lightYellow;

  // 🌞 PROFESSIONAL LIGHT THEME
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryYellow,
    scaffoldBackgroundColor: white,
    colorScheme: ColorScheme.light(
      primary: primaryYellow,
      secondary: accentYellow,
      surface: white,
      onPrimary: black,
      onSurface: black,
      background: white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryYellow,
      foregroundColor: black,
      elevation: 2,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: black,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(color: black),
    ),
    cardTheme: CardThemeData(
      color: white,
      elevation: 3,
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shadowColor: primaryYellow.withOpacity(0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(primaryYellow),
        foregroundColor: MaterialStateProperty.all(black),
        textStyle: MaterialStateProperty.all(TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        )),
        elevation: MaterialStateProperty.all(2),
        padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 24, vertical: 14)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: lightGray,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: mediumGray, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: mediumGray.withOpacity(0.3), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryYellow, width: 2),
      ),
      labelStyle: TextStyle(color: mediumGray),
      prefixIconColor: primaryYellow,
      suffixIconColor: primaryYellow,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: primaryYellow,
      contentTextStyle: TextStyle(color: black, fontWeight: FontWeight.w600),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: white,
      selectedItemColor: primaryYellow,
      unselectedItemColor: mediumGray,
      selectedIconTheme: IconThemeData(color: primaryYellow, size: 28),
      unselectedIconTheme: IconThemeData(color: mediumGray, size: 24),
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 11),
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),
    dividerTheme: DividerThemeData(
      color: lightGray,
      thickness: 1,
    ),
    iconTheme: IconThemeData(color: primaryYellow),
    textTheme: TextTheme(
      displayLarge: TextStyle(color: black, fontWeight: FontWeight.bold, fontSize: 32),
      displayMedium: TextStyle(color: black, fontWeight: FontWeight.bold, fontSize: 28),
      displaySmall: TextStyle(color: black, fontWeight: FontWeight.w600, fontSize: 24),
      headlineLarge: TextStyle(color: black, fontWeight: FontWeight.w600, fontSize: 20),
      bodyLarge: TextStyle(color: black, fontSize: 16),
      bodyMedium: TextStyle(color: darkGray, fontSize: 14),
    ),
  );

  // 🌙 PROFESSIONAL DARK THEME
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryYellow,
    scaffoldBackgroundColor: black,
    colorScheme: ColorScheme.dark(
      primary: primaryYellow,
      secondary: accentYellow,
      surface: darkGray,
      onPrimary: black,
      onSurface: white,
      background: black,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: darkGray,
      foregroundColor: white,
      elevation: 2,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(color: primaryYellow),
    ),
    cardTheme: CardThemeData(
      color: darkGray,
      elevation: 3,
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shadowColor: primaryYellow.withOpacity(0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(primaryYellow),
        foregroundColor: MaterialStateProperty.all(black),
        textStyle: MaterialStateProperty.all(TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        )),
        elevation: MaterialStateProperty.all(2),
        padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 24, vertical: 14)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkGray,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: mediumGray, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: mediumGray.withOpacity(0.3), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryYellow, width: 2),
      ),
      labelStyle: TextStyle(color: white.withOpacity(0.7)),
      prefixIconColor: primaryYellow,
      suffixIconColor: primaryYellow,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: primaryYellow,
      contentTextStyle: TextStyle(color: black, fontWeight: FontWeight.w600),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: darkGray,
      selectedItemColor: primaryYellow,
      unselectedItemColor: white.withOpacity(0.6),
      selectedIconTheme: IconThemeData(color: primaryYellow, size: 28),
      unselectedIconTheme: IconThemeData(color: white.withOpacity(0.6), size: 24),
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 11),
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),
    dividerTheme: DividerThemeData(
      color: mediumGray,
      thickness: 1,
    ),
    iconTheme: IconThemeData(color: primaryYellow),
    textTheme: TextTheme(
      displayLarge: TextStyle(color: white, fontWeight: FontWeight.bold, fontSize: 32),
      displayMedium: TextStyle(color: white, fontWeight: FontWeight.bold, fontSize: 28),
      displaySmall: TextStyle(color: white, fontWeight: FontWeight.w600, fontSize: 24),
      headlineLarge: TextStyle(color: white, fontWeight: FontWeight.w600, fontSize: 20),
      bodyLarge: TextStyle(color: white, fontSize: 16),
      bodyMedium: TextStyle(color: white.withOpacity(0.7), fontSize: 14),
    ),
  );
}