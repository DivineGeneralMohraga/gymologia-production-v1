// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Gymologia';

  @override
  String get languageName => 'English';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get languageSubtitle =>
      'Choose the language you read most comfortably';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get tryAgain => 'Try again';

  @override
  String get loading => 'Loading';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get signIn => 'Sign in';

  @override
  String get phoneNumber => 'Phone number';

  @override
  String get enterPhoneNumber => 'Enter your mobile number';

  @override
  String get sendCode => 'Send code';

  @override
  String get verifyCode => 'Verify';

  @override
  String get enterCode => 'Enter the code we sent you';

  @override
  String get resendCode => 'Send it again';

  @override
  String get createAccount => 'Create your account';

  @override
  String get yourName => 'Your name';

  @override
  String get emailOptional => 'Email (optional)';

  @override
  String get age => 'Age';

  @override
  String get whyAgeNotBirthday =>
      'We ask for your age, not your date of birth. A date of birth is tied to your bank and government records — an age is all a gym app needs.';

  @override
  String get termsAgreement =>
      'Creating an account means you accept the Terms of Use and Privacy Policy.';

  @override
  String get home => 'Home';

  @override
  String get myGym => 'My gym';

  @override
  String get findAGymTab => 'Find a gym';

  @override
  String get discover => 'Discover';

  @override
  String get sendOtp => 'Send OTP';

  @override
  String get verifyYourNumber => 'Verify your number';

  @override
  String get codeResent => 'A new code is on its way.';

  @override
  String get name => 'Name';

  @override
  String get email => 'Email';

  @override
  String get connection => 'Connection';

  @override
  String get account => 'Account';

  @override
  String get session => 'Session';

  @override
  String get earnByReferring => 'Earn by referring gyms';

  @override
  String get gyms => 'Gyms';

  @override
  String get events => 'Events';

  @override
  String get chat => 'Chat';

  @override
  String get profile => 'Profile';

  @override
  String get findAGym => 'Find a gym';

  @override
  String get searchGyms => 'Search by name or locality';

  @override
  String get noGymsFound => 'No gyms found here yet';

  @override
  String get perks => 'Perks';

  @override
  String get contactGym => 'Contact this gym';

  @override
  String get rating => 'Rating';

  @override
  String get yourMembership => 'Your membership';

  @override
  String daysRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days left',
      one: '1 day left',
      zero: 'Ends today',
    );
    return '$_temp0';
  }

  @override
  String get yourGoal => 'Your goal';

  @override
  String get trainer => 'Trainer';

  @override
  String get requestLeave => 'Request leave';

  @override
  String get yourProgress => 'Your progress';

  @override
  String get weight => 'Weight';

  @override
  String get height => 'Height';

  @override
  String get yourMeasurements => 'Your measurements';

  @override
  String get addMeasurements =>
      'Add your weight and height so your gym can track progress with you';

  @override
  String get checkInDue => 'This month\'s check-in is due';

  @override
  String get thisMonth => 'This month';

  @override
  String get perWeek => 'Per week';

  @override
  String weeksRunning(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Weeks running',
      one: 'Week running',
    );
    return '$_temp0';
  }

  @override
  String get lastEightWeeks => 'Last 8 weeks';

  @override
  String get exerciseDirectory => 'Exercise directory';

  @override
  String get exerciseDirectorySubtitle =>
      'Strength, cardio and yoga, with step-by-step form cues';

  @override
  String get steps => 'Steps';

  @override
  String get attendance => 'Attendance';

  @override
  String get members => 'Members';

  @override
  String get staff => 'Staff';

  @override
  String get leave => 'Leave';

  @override
  String get roles => 'Roles';

  @override
  String get analytics => 'Analytics';

  @override
  String get growth => 'Growth';

  @override
  String get ranking => 'Ranking';

  @override
  String get plan => 'Plan';

  @override
  String get announce => 'Announce';

  @override
  String get gymProfile => 'Gym profile';

  @override
  String get trainers => 'Trainers';

  @override
  String get present => 'Present';

  @override
  String get absent => 'Absent';

  @override
  String get markAttendance => 'Mark attendance';

  @override
  String get getHelp => 'Get help';

  @override
  String get getHelpSubtitle => 'Send us a message and we will get back to you';

  @override
  String get termsAndPrivacy => 'Terms & Privacy Policy';

  @override
  String get signOut => 'Sign out';

  @override
  String get switchToStaff => 'Switch to owner/staff mode';

  @override
  String get switchToMember => 'Switch to member mode';

  @override
  String get notifications => 'Notifications';

  @override
  String get noNotifications => 'Nothing new';

  @override
  String get needsReview => 'Translation pending review';
}
