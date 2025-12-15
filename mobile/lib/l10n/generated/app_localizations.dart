import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_te.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('gu'),
    Locale('hi'),
    Locale('kn'),
    Locale('mr'),
    Locale('te')
  ];

  /// The application name
  ///
  /// In en, this message translates to:
  /// **'Pandittalk'**
  String get appName;

  /// Greeting with name
  ///
  /// In en, this message translates to:
  /// **'Hi {name}'**
  String hi(String name);

  /// No description provided for @addCash.
  ///
  /// In en, this message translates to:
  /// **'Add Cash'**
  String get addCash;

  /// No description provided for @searchAstrologers.
  ///
  /// In en, this message translates to:
  /// **'Search astrologers...'**
  String get searchAstrologers;

  /// No description provided for @chatWithAstrologer.
  ///
  /// In en, this message translates to:
  /// **'Chat with Astrologer'**
  String get chatWithAstrologer;

  /// No description provided for @callWithAstrologer.
  ///
  /// In en, this message translates to:
  /// **'Call with Astrologer'**
  String get callWithAstrologer;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @enterPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enterPhone;

  /// No description provided for @getOTP.
  ///
  /// In en, this message translates to:
  /// **'Get OTP'**
  String get getOTP;

  /// No description provided for @verifyOTP.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOTP;

  /// No description provided for @enterOTP.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get enterOTP;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @freeKundli.
  ///
  /// In en, this message translates to:
  /// **'Free Kundli (AI)'**
  String get freeKundli;

  /// No description provided for @startAIKundliChat.
  ///
  /// In en, this message translates to:
  /// **'Start AI Kundli Chat'**
  String get startAIKundliChat;

  /// No description provided for @aiPoweredKundliAnalysis.
  ///
  /// In en, this message translates to:
  /// **'AI-Powered Kundli Analysis'**
  String get aiPoweredKundliAnalysis;

  /// No description provided for @getInstantKundliReading.
  ///
  /// In en, this message translates to:
  /// **'Get instant Kundli reading powered by AI'**
  String get getInstantKundliReading;

  /// No description provided for @dailyHoroscope.
  ///
  /// In en, this message translates to:
  /// **'Daily Horoscope'**
  String get dailyHoroscope;

  /// No description provided for @kundliMatching.
  ///
  /// In en, this message translates to:
  /// **'Kundli Matching'**
  String get kundliMatching;

  /// No description provided for @celebrityAstrologers.
  ///
  /// In en, this message translates to:
  /// **'Celebrity Astrologers'**
  String get celebrityAstrologers;

  /// No description provided for @liveAstrologers.
  ///
  /// In en, this message translates to:
  /// **'Astrologers Live'**
  String get liveAstrologers;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @registerForFreebie.
  ///
  /// In en, this message translates to:
  /// **'Register for Freebie'**
  String get registerForFreebie;

  /// No description provided for @first1000UsersGetFreebie.
  ///
  /// In en, this message translates to:
  /// **'First 1000 users get a freebie!'**
  String get first1000UsersGetFreebie;

  /// No description provided for @loginAndRegisterNow.
  ///
  /// In en, this message translates to:
  /// **'Login and register now to claim your welcome gift before the slots run out.'**
  String get loginAndRegisterNow;

  /// No description provided for @cashback100.
  ///
  /// In en, this message translates to:
  /// **'100% CASHBACK!'**
  String get cashback100;

  /// No description provided for @onYourFirstRecharge.
  ///
  /// In en, this message translates to:
  /// **'on your first recharge'**
  String get onYourFirstRecharge;

  /// No description provided for @rechargeNow.
  ///
  /// In en, this message translates to:
  /// **'RECHARGE NOW'**
  String get rechargeNow;

  /// No description provided for @recharge.
  ///
  /// In en, this message translates to:
  /// **'Recharge'**
  String get recharge;

  /// No description provided for @addCashToWallet.
  ///
  /// In en, this message translates to:
  /// **'Add Cash to Wallet'**
  String get addCashToWallet;

  /// No description provided for @proceedToPay.
  ///
  /// In en, this message translates to:
  /// **'Proceed to Pay'**
  String get proceedToPay;

  /// No description provided for @rechargeNowTitle.
  ///
  /// In en, this message translates to:
  /// **'Recharge Now'**
  String get rechargeNowTitle;

  /// No description provided for @get100CashbackOnFirstRecharge.
  ///
  /// In en, this message translates to:
  /// **'Get 100% Cashback on your First recharge'**
  String get get100CashbackOnFirstRecharge;

  /// No description provided for @tip90UsersRecharge.
  ///
  /// In en, this message translates to:
  /// **'Tip: 90% users recharge for 10 mins or more'**
  String get tip90UsersRecharge;

  /// No description provided for @extra.
  ///
  /// In en, this message translates to:
  /// **'{percent}% Extra'**
  String extra(String percent);

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth (YYYY-MM-DD)'**
  String get dateOfBirth;

  /// No description provided for @timeOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Time of Birth (HH:MM 24h)'**
  String get timeOfBirth;

  /// No description provided for @timezone.
  ///
  /// In en, this message translates to:
  /// **'Timezone (e.g. +05:30)'**
  String get timezone;

  /// No description provided for @birthPlace.
  ///
  /// In en, this message translates to:
  /// **'Birth Place (City, Country)'**
  String get birthPlace;

  /// No description provided for @generateKundli.
  ///
  /// In en, this message translates to:
  /// **'Generate Kundli'**
  String get generateKundli;

  /// No description provided for @generatingKundli.
  ///
  /// In en, this message translates to:
  /// **'Generating your Kundli… 🕉️ Please wait.'**
  String get generatingKundli;

  /// No description provided for @failedToGenerateKundli.
  ///
  /// In en, this message translates to:
  /// **'Failed to generate Kundli'**
  String get failedToGenerateKundli;

  /// No description provided for @kundliSummary.
  ///
  /// In en, this message translates to:
  /// **'Kundli Summary for {name}'**
  String kundliSummary(String name);

  /// No description provided for @summary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summary;

  /// No description provided for @planetDetails.
  ///
  /// In en, this message translates to:
  /// **'Planet Details'**
  String get planetDetails;

  /// No description provided for @houseDetails.
  ///
  /// In en, this message translates to:
  /// **'House Details'**
  String get houseDetails;

  /// No description provided for @whatIsYourName.
  ///
  /// In en, this message translates to:
  /// **'What is your name?'**
  String get whatIsYourName;

  /// No description provided for @whereWereYouBorn.
  ///
  /// In en, this message translates to:
  /// **'Where were you born (place of birth)?'**
  String get whereWereYouBorn;

  /// No description provided for @lookingUpLocation.
  ///
  /// In en, this message translates to:
  /// **'Looking up the location on map...'**
  String get lookingUpLocation;

  /// No description provided for @couldNotFindPlace.
  ///
  /// In en, this message translates to:
  /// **'Sorry, I couldn\'t find that place. Please try again with a more specific city or region name.'**
  String get couldNotFindPlace;

  /// No description provided for @hereIsYourKundli.
  ///
  /// In en, this message translates to:
  /// **'Here is your Kundli, {name} 🧘‍♀️...'**
  String hereIsYourKundli(String name);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'en',
        'gu',
        'hi',
        'kn',
        'mr',
        'te'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'gu':
      return AppLocalizationsGu();
    case 'hi':
      return AppLocalizationsHi();
    case 'kn':
      return AppLocalizationsKn();
    case 'mr':
      return AppLocalizationsMr();
    case 'te':
      return AppLocalizationsTe();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
