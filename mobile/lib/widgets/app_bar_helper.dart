import 'package:flutter/material.dart';

/// Helper to create AppBar with automatic back button
class AppBarHelper {
  static AppBar buildAppBar({
    required String title,
    required Color backgroundColor,
    List<Widget>? actions,
    bool automaticallyImplyLeading = true,
    Widget? leading,
    Color? titleColor,
  }) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          color: titleColor ?? Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: backgroundColor,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading ??
          (automaticallyImplyLeading
              ? IconButton(
                  icon: Icon(Icons.arrow_back_ios_new, color: titleColor ?? Colors.white, size: 20),
                  onPressed: () => Navigator.of(navigatorKey.currentContext!).pop(),
                )
              : null),
      actions: actions,
      elevation: 0,
    );
  }

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

