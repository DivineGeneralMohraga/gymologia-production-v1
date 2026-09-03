// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malayalam (`ml`).
class AppLocalizationsMl extends AppLocalizations {
  AppLocalizationsMl([String locale = 'ml']) : super(locale);

  @override
  String get appName => 'Gymologia';

  @override
  String get languageName => 'മലയാളം';

  @override
  String get settings => 'ക്രമീകരണങ്ങൾ';

  @override
  String get language => 'ഭാഷ';

  @override
  String get languageSubtitle =>
      'നിങ്ങൾക്ക് സൗകര്യപ്രദമായി വായിക്കാവുന്ന ഭാഷ തിരഞ്ഞെടുക്കുക';

  @override
  String get save => 'സേവ് ചെയ്യുക';

  @override
  String get cancel => 'റദ്ദാക്കുക';

  @override
  String get tryAgain => 'വീണ്ടും ശ്രമിക്കുക';

  @override
  String get loading => 'ലോഡ് ചെയ്യുന്നു';

  @override
  String get somethingWentWrong => 'എന്തോ കുഴപ്പം സംഭവിച്ചു';

  @override
  String get signIn => 'സൈൻ ഇൻ';

  @override
  String get phoneNumber => 'മൊബൈൽ നമ്പർ';

  @override
  String get enterPhoneNumber => 'നിങ്ങളുടെ മൊബൈൽ നമ്പർ നൽകുക';

  @override
  String get sendCode => 'കോഡ് അയയ്ക്കുക';

  @override
  String get verifyCode => 'സ്ഥിരീകരിക്കുക';

  @override
  String get enterCode => 'ഞങ്ങൾ അയച്ച കോഡ് നൽകുക';

  @override
  String get resendCode => 'വീണ്ടും അയയ്ക്കുക';

  @override
  String get createAccount => 'നിങ്ങളുടെ അക്കൗണ്ട് ഉണ്ടാക്കുക';

  @override
  String get yourName => 'നിങ്ങളുടെ പേര്';

  @override
  String get emailOptional => 'ഇമെയിൽ (ഐച്ഛികം)';

  @override
  String get age => 'വയസ്സ്';

  @override
  String get whyAgeNotBirthday =>
      'ഞങ്ങൾ നിങ്ങളുടെ വയസ്സാണ് ചോദിക്കുന്നത്, ജനനത്തീയതിയല്ല. ജനനത്തീയതി നിങ്ങളുടെ ബാങ്ക്, സർക്കാർ രേഖകളുമായി ബന്ധപ്പെട്ടതാണ് — ജിം ആപ്പിന് വയസ്സ് മതി.';

  @override
  String get termsAgreement =>
      'അക്കൗണ്ട് ഉണ്ടാക്കുന്നത് ഉപയോഗ നിബന്ധനകളും സ്വകാര്യതാ നയവും അംഗീകരിക്കുന്നു എന്നാണ്.';

  @override
  String get home => 'ഹോം';

  @override
  String get gyms => 'ജിമ്മുകൾ';

  @override
  String get events => 'ഇവന്റുകൾ';

  @override
  String get chat => 'ചാറ്റ്';

  @override
  String get profile => 'പ്രൊഫൈൽ';

  @override
  String get findAGym => 'ജിം കണ്ടെത്തുക';

  @override
  String get searchGyms => 'പേരോ പ്രദേശമോ ഉപയോഗിച്ച് തിരയുക';

  @override
  String get noGymsFound => 'ഇവിടെ ഇതുവരെ ജിമ്മുകളൊന്നുമില്ല';

  @override
  String get perks => 'സൗകര്യങ്ങൾ';

  @override
  String get contactGym => 'ഈ ജിമ്മുമായി ബന്ധപ്പെടുക';

  @override
  String get rating => 'റേറ്റിംഗ്';

  @override
  String get yourMembership => 'നിങ്ങളുടെ അംഗത്വം';

  @override
  String daysRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ദിവസം ബാക്കി',
      one: '1 ദിവസം ബാക്കി',
      zero: 'ഇന്ന് അവസാനിക്കുന്നു',
    );
    return '$_temp0';
  }

  @override
  String get yourGoal => 'നിങ്ങളുടെ ലക്ഷ്യം';

  @override
  String get trainer => 'പരിശീലകൻ';

  @override
  String get requestLeave => 'അവധി അപേക്ഷ';

  @override
  String get yourProgress => 'നിങ്ങളുടെ പുരോഗതി';

  @override
  String get weight => 'ഭാരം';

  @override
  String get height => 'ഉയരം';

  @override
  String get yourMeasurements => 'നിങ്ങളുടെ അളവുകൾ';

  @override
  String get addMeasurements =>
      'നിങ്ങളുടെ ഭാരവും ഉയരവും ചേർക്കുക, അപ്പോൾ ജിമ്മിന് നിങ്ങളുടെ പുരോഗതി കാണാം';

  @override
  String get checkInDue => 'ഈ മാസത്തെ ചെക്ക്-ഇൻ ബാക്കിയുണ്ട്';

  @override
  String get thisMonth => 'ഈ മാസം';

  @override
  String get perWeek => 'ആഴ്ചയിൽ';

  @override
  String weeksRunning(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'തുടർച്ചയായ ആഴ്ചകൾ',
      one: 'തുടർച്ചയായ ആഴ്ച',
    );
    return '$_temp0';
  }

  @override
  String get lastEightWeeks => 'കഴിഞ്ഞ 8 ആഴ്ച';

  @override
  String get exerciseDirectory => 'വ്യായാമ പട്ടിക';

  @override
  String get exerciseDirectorySubtitle =>
      'കരുത്ത്, കാർഡിയോ, യോഗ — ഓരോ ഘട്ടത്തിന്റെയും നിർദ്ദേശങ്ങളോടെ';

  @override
  String get steps => 'ഘട്ടങ്ങൾ';

  @override
  String get attendance => 'ഹാജർ';

  @override
  String get members => 'അംഗങ്ങൾ';

  @override
  String get staff => 'ജീവനക്കാർ';

  @override
  String get leave => 'അവധി';

  @override
  String get roles => 'റോളുകൾ';

  @override
  String get analytics => 'വിശകലനം';

  @override
  String get growth => 'വളർച്ച';

  @override
  String get ranking => 'റാങ്കിംഗ്';

  @override
  String get plan => 'പ്ലാൻ';

  @override
  String get announce => 'അറിയിപ്പ്';

  @override
  String get gymProfile => 'ജിം പ്രൊഫൈൽ';

  @override
  String get trainers => 'പരിശീലകർ';

  @override
  String get present => 'ഹാജർ';

  @override
  String get absent => 'ഹാജരല്ല';

  @override
  String get markAttendance => 'ഹാജർ രേഖപ്പെടുത്തുക';

  @override
  String get getHelp => 'സഹായം തേടുക';

  @override
  String get getHelpSubtitle =>
      'ഞങ്ങൾക്ക് സന്ദേശം അയയ്ക്കുക, ഞങ്ങൾ ബന്ധപ്പെടും';

  @override
  String get termsAndPrivacy => 'നിബന്ധനകളും സ്വകാര്യതയും';

  @override
  String get signOut => 'സൈൻ ഔട്ട്';

  @override
  String get switchToStaff => 'ഉടമ/ജീവനക്കാർ മോഡിലേക്ക് മാറുക';

  @override
  String get switchToMember => 'അംഗ മോഡിലേക്ക് മാറുക';

  @override
  String get notifications => 'അറിയിപ്പുകൾ';

  @override
  String get noNotifications => 'പുതിയതായി ഒന്നുമില്ല';

  @override
  String get needsReview => 'വിവർത്തനം പരിശോധിക്കാനുണ്ട്';
}
