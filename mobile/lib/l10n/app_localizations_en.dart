// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Pandittalk';

  @override
  String hi(String name) {
    return 'Hi $name';
  }

  @override
  String get addCash => 'Add Cash';

  @override
  String get searchAstrologers => 'Search astrologers...';

  @override
  String get chatWithAstrologer => 'Chat with Astrologer';

  @override
  String get callWithAstrologer => 'Call with Astrologer';

  @override
  String get chat => 'Chat';

  @override
  String get call => 'Call';

  @override
  String get home => 'Home';

  @override
  String get profile => 'Profile';

  @override
  String get wallet => 'Wallet';

  @override
  String get settings => 'Settings';

  @override
  String get login => 'Login';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get enterPhone => 'Enter your phone number';

  @override
  String get getOTP => 'Get OTP';

  @override
  String get verifyOTP => 'Verify OTP';

  @override
  String get enterOTP => 'Enter OTP';

  @override
  String get submit => 'Submit';

  @override
  String get cancel => 'Cancel';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get retry => 'Retry';

  @override
  String get freeKundli => 'Free Kundli (AI)';

  @override
  String get startAIKundliChat => 'Start AI Kundli Chat';

  @override
  String get aiPoweredKundliAnalysis => 'AI-Powered Kundli Analysis';

  @override
  String get getInstantKundliReading =>
      'Get instant Kundli reading powered by AI';

  @override
  String get dailyHoroscope => 'Daily Horoscope';

  @override
  String get kundliMatching => 'Kundli Matching';

  @override
  String get celebrityAstrologers => 'Celebrity Astrologers';

  @override
  String get liveAstrologers => 'Astrologers Live';

  @override
  String get viewAll => 'View All';

  @override
  String get registerForFreebie => 'Register for Freebie';

  @override
  String get first1000UsersGetFreebie => 'First 1000 users get a freebie!';

  @override
  String get loginAndRegisterNow =>
      'Login and register now to claim your welcome gift before the slots run out.';

  @override
  String get cashback100 => '100% CASHBACK!';

  @override
  String get onYourFirstRecharge => 'on your first recharge';

  @override
  String get rechargeNow => 'RECHARGE NOW';

  @override
  String get recharge => 'Recharge';

  @override
  String get addCashToWallet => 'Add Cash to Wallet';

  @override
  String get proceedToPay => 'Proceed to Pay';

  @override
  String get rechargeNowTitle => 'Recharge Now';

  @override
  String get get100CashbackOnFirstRecharge =>
      'Get 100% Cashback on your First recharge';

  @override
  String get tip90UsersRecharge =>
      'Tip: 90% users recharge for 10 mins or more';

  @override
  String extra(String percent) {
    return '$percent% Extra';
  }

  @override
  String get name => 'Name';

  @override
  String get dateOfBirth => 'Date of Birth (YYYY-MM-DD)';

  @override
  String get timeOfBirth => 'Time of Birth (HH:MM 24h)';

  @override
  String get timezone => 'Timezone (e.g. +05:30)';

  @override
  String get birthPlace => 'Birth Place (City, Country)';

  @override
  String get generateKundli => 'Generate Kundli';

  @override
  String get generatingKundli => 'Generating your Kundli… 🕉️ Please wait.';

  @override
  String get failedToGenerateKundli => 'Failed to generate Kundli';

  @override
  String kundliSummary(String name) {
    return 'Kundli Summary for $name';
  }

  @override
  String get summary => 'Summary';

  @override
  String get planetDetails => 'Planet Details';

  @override
  String get houseDetails => 'House Details';

  @override
  String get whatIsYourName => 'What is your name?';

  @override
  String get whereWereYouBorn => 'Where were you born (place of birth)?';

  @override
  String get lookingUpLocation => 'Looking up the location on map...';

  @override
  String get couldNotFindPlace =>
      'Sorry, I couldn\'t find that place. Please try again with a more specific city or region name.';

  @override
  String hereIsYourKundli(String name) {
    return 'Here is your Kundli, $name 🧘‍♀️...';
  }
}
