// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get appName => 'Gymologia';

  @override
  String get languageName => 'தமிழ்';

  @override
  String get settings => 'அமைப்புகள்';

  @override
  String get language => 'மொழி';

  @override
  String get languageSubtitle =>
      'நீங்கள் வசதியாகப் படிக்கும் மொழியைத் தேர்ந்தெடுங்கள்';

  @override
  String get save => 'சேமி';

  @override
  String get cancel => 'ரத்து';

  @override
  String get tryAgain => 'மீண்டும் முயற்சி';

  @override
  String get loading => 'ஏற்றுகிறது';

  @override
  String get somethingWentWrong => 'ஏதோ தவறு நடந்தது';

  @override
  String get signIn => 'உள்நுழை';

  @override
  String get phoneNumber => 'கைபேசி எண்';

  @override
  String get enterPhoneNumber => 'உங்கள் கைபேசி எண்ணை உள்ளிடுங்கள்';

  @override
  String get sendCode => 'குறியீடு அனுப்பு';

  @override
  String get verifyCode => 'சரிபார்';

  @override
  String get enterCode => 'நாங்கள் அனுப்பிய குறியீட்டை உள்ளிடுங்கள்';

  @override
  String get resendCode => 'மீண்டும் அனுப்பு';

  @override
  String get createAccount => 'உங்கள் கணக்கை உருவாக்குங்கள்';

  @override
  String get yourName => 'உங்கள் பெயர்';

  @override
  String get emailOptional => 'மின்னஞ்சல் (விருப்பம்)';

  @override
  String get age => 'வயது';

  @override
  String get whyAgeNotBirthday =>
      'நாங்கள் உங்கள் வயதைக் கேட்கிறோம், பிறந்த தேதியை அல்ல. பிறந்த தேதி உங்கள் வங்கி மற்றும் அரசு ஆவணங்களுடன் இணைந்தது — உடற்பயிற்சி செயலிக்கு வயது போதும்.';

  @override
  String get termsAgreement =>
      'கணக்கை உருவாக்குவது பயன்பாட்டு விதிமுறைகளையும் தனியுரிமைக் கொள்கையையும் ஏற்பதாகும்.';

  @override
  String get home => 'முகப்பு';

  @override
  String get gyms => 'உடற்பயிற்சி கூடம்';

  @override
  String get events => 'நிகழ்வுகள்';

  @override
  String get chat => 'அரட்டை';

  @override
  String get profile => 'சுயவிவரம்';

  @override
  String get findAGym => 'உடற்பயிற்சி கூடம் தேடு';

  @override
  String get searchGyms => 'பெயர் அல்லது பகுதி மூலம் தேடு';

  @override
  String get noGymsFound => 'இங்கு இன்னும் எதுவும் இல்லை';

  @override
  String get perks => 'வசதிகள்';

  @override
  String get contactGym => 'இந்தக் கூடத்தைத் தொடர்பு கொள்ளுங்கள்';

  @override
  String get rating => 'மதிப்பீடு';

  @override
  String get yourMembership => 'உங்கள் உறுப்பினர் சேர்க்கை';

  @override
  String daysRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count நாட்கள் மீதம்',
      one: '1 நாள் மீதம்',
      zero: 'இன்று முடிகிறது',
    );
    return '$_temp0';
  }

  @override
  String get yourGoal => 'உங்கள் இலக்கு';

  @override
  String get trainer => 'பயிற்சியாளர்';

  @override
  String get requestLeave => 'விடுப்பு கோரிக்கை';

  @override
  String get yourProgress => 'உங்கள் முன்னேற்றம்';

  @override
  String get weight => 'எடை';

  @override
  String get height => 'உயரம்';

  @override
  String get yourMeasurements => 'உங்கள் அளவுகள்';

  @override
  String get addMeasurements =>
      'உங்கள் எடை மற்றும் உயரத்தைச் சேர்க்கவும், அப்போது கூடம் உங்களுடன் முன்னேற்றத்தைக் காணும்';

  @override
  String get checkInDue => 'இந்த மாத பதிவு நிலுவையில்';

  @override
  String get thisMonth => 'இந்த மாதம்';

  @override
  String get perWeek => 'வாரத்திற்கு';

  @override
  String weeksRunning(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'தொடர் வாரங்கள்',
      one: 'தொடர் வாரம்',
    );
    return '$_temp0';
  }

  @override
  String get lastEightWeeks => 'கடந்த 8 வாரங்கள்';

  @override
  String get exerciseDirectory => 'பயிற்சி பட்டியல்';

  @override
  String get exerciseDirectorySubtitle =>
      'வலிமை, கார்டியோ மற்றும் யோகா, படிப்படியான வழிகாட்டுதலுடன்';

  @override
  String get steps => 'படிகள்';

  @override
  String get attendance => 'வருகை';

  @override
  String get members => 'உறுப்பினர்கள்';

  @override
  String get staff => 'பணியாளர்கள்';

  @override
  String get leave => 'விடுப்பு';

  @override
  String get roles => 'பங்குகள்';

  @override
  String get analytics => 'பகுப்பாய்வு';

  @override
  String get growth => 'வளர்ச்சி';

  @override
  String get ranking => 'தரவரிசை';

  @override
  String get plan => 'திட்டம்';

  @override
  String get announce => 'அறிவிப்பு';

  @override
  String get gymProfile => 'கூட சுயவிவரம்';

  @override
  String get trainers => 'பயிற்சியாளர்கள்';

  @override
  String get present => 'வந்தார்';

  @override
  String get absent => 'வரவில்லை';

  @override
  String get markAttendance => 'வருகையைப் பதிவு செய்';

  @override
  String get getHelp => 'உதவி பெறு';

  @override
  String get getHelpSubtitle =>
      'எங்களுக்குச் செய்தி அனுப்புங்கள், நாங்கள் தொடர்பு கொள்வோம்';

  @override
  String get termsAndPrivacy => 'விதிமுறைகள் மற்றும் தனியுரிமை';

  @override
  String get signOut => 'வெளியேறு';

  @override
  String get switchToStaff => 'உரிமையாளர்/பணியாளர் பயன்முறைக்கு மாறு';

  @override
  String get switchToMember => 'உறுப்பினர் பயன்முறைக்கு மாறு';

  @override
  String get notifications => 'அறிவிப்புகள்';

  @override
  String get noNotifications => 'புதிதாக ஏதுமில்லை';

  @override
  String get needsReview => 'மொழிபெயர்ப்பு மதிப்பாய்வு நிலுவையில்';
}
