# 🌍 Internationalization (i18n) Usage Guide

Your PanditTalk app now supports **6 languages**:
- 🇬🇧 English (en)
- 🇮🇳 Hindi (hi)
- 🇮🇳 Marathi (mr)
- 🇮🇳 Gujarati (gu)
- 🇮🇳 Telugu (te)
- 🇮🇳 Kannada (kn)

## ✅ Setup Complete

1. ✅ Translation files created in `lib/l10n/` (ARB format)
2. ✅ Flutter localization configured in `pubspec.yaml` and `l10n.yaml`
3. ✅ `main.dart` updated to use `AppLocalizations`
4. ✅ Helper class created at `lib/utils/app_localizations_helper.dart`

## 📖 How to Use Translations

### Method 1: Direct Access (Recommended)

```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// In your widget's build method:
Text(AppLocalizations.of(context)?.hi('John') ?? 'Hi John')
Text(AppLocalizations.of(context)?.addCash ?? 'Add Cash')
```

### Method 2: Using Helper Class

```dart
import '../../utils/app_localizations_helper.dart';

Text(AppLocalizationsHelper.of(context)?.hi('John') ?? 'Hi John')
```

### Method 3: With Fallback

```dart
final l10n = AppLocalizations.of(context);
Text(l10n?.searchAstrologers ?? 'Search astrologers...')
```

## 🔧 Adding New Translations

1. **Add to English ARB file** (`lib/l10n/app_en.arb`):
```json
{
  "myNewKey": "My New Text",
  "@myNewKey": {
    "description": "Description of what this text is for"
  }
}
```

2. **Add translations to other language files** (`app_hi.arb`, `app_mr.arb`, etc.)

3. **Run code generation**:
```bash
flutter gen-l10n
```

4. **Use in code**:
```dart
AppLocalizations.of(context)?.myNewKey ?? 'My New Text'
```

## 📝 Available Translation Keys

All keys are available in all 6 languages. Key examples:
- `appName` - App name
- `hi` - Greeting with name parameter
- `addCash` - Add Cash button
- `searchAstrologers` - Search placeholder
- `chatWithAstrologer` - Chat button
- `callWithAstrologer` - Call button
- `freeKundli` - Free Kundli title
- `generateKundli` - Generate button
- And many more...

## 🎯 Example: Converting a Screen

**Before:**
```dart
Text('Hi ${user.name}')
```

**After:**
```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Text(AppLocalizations.of(context)?.hi(user.name) ?? 'Hi ${user.name}')
```

## 🌐 Language Switching

Users can switch languages using the language selector in the header. The app automatically:
- Saves the preference
- Updates all UI text immediately
- Persists across app restarts

## 📚 Next Steps

1. **Convert remaining screens** - Replace hardcoded strings with `AppLocalizations.of(context)?.key`
2. **Add more translations** - As you add new features, add translations to all ARB files
3. **Test each language** - Verify translations display correctly in all 6 languages

## 🐛 Troubleshooting

- **Translations not showing?** Run `flutter gen-l10n` to regenerate files
- **Missing translations?** Check that the key exists in all ARB files
- **Build errors?** Ensure `flutter_localizations` is in `pubspec.yaml` dependencies

---

**Happy Localizing! 🌍**

