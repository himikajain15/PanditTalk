import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Helper class to easily access translations throughout the app
/// Usage: AppLocalizationsHelper.of(context).hi('John')
class AppLocalizationsHelper {
  static AppLocalizations? of(BuildContext context) {
    return AppLocalizations.of(context);
  }

  /// Get localized string with fallback
  static String getString(BuildContext context, String Function(AppLocalizations) getter, {String fallback = ''}) {
    final l10n = of(context);
    if (l10n == null) return fallback;
    try {
      return getter(l10n);
    } catch (e) {
      return fallback;
    }
  }
}

