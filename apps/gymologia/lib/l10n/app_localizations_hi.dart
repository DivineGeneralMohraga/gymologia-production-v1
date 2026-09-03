// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appName => 'Gymologia';

  @override
  String get languageName => 'हिन्दी';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get language => 'भाषा';

  @override
  String get languageSubtitle =>
      'वह भाषा चुनें जिसमें आप सबसे आराम से पढ़ते हैं';

  @override
  String get save => 'सहेजें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get tryAgain => 'फिर कोशिश करें';

  @override
  String get loading => 'लोड हो रहा है';

  @override
  String get somethingWentWrong => 'कुछ गड़बड़ हो गई';

  @override
  String get signIn => 'साइन इन करें';

  @override
  String get phoneNumber => 'मोबाइल नंबर';

  @override
  String get enterPhoneNumber => 'अपना मोबाइल नंबर डालें';

  @override
  String get sendCode => 'कोड भेजें';

  @override
  String get verifyCode => 'सत्यापित करें';

  @override
  String get enterCode => 'हमने जो कोड भेजा है वह डालें';

  @override
  String get resendCode => 'दोबारा भेजें';

  @override
  String get createAccount => 'अपना खाता बनाएं';

  @override
  String get yourName => 'आपका नाम';

  @override
  String get emailOptional => 'ईमेल (वैकल्पिक)';

  @override
  String get age => 'उम्र';

  @override
  String get whyAgeNotBirthday =>
      'हम आपकी उम्र पूछते हैं, जन्मतिथि नहीं। जन्मतिथि आपके बैंक और सरकारी दस्तावेज़ों से जुड़ी होती है — जिम ऐप के लिए उम्र ही काफी है।';

  @override
  String get termsAgreement =>
      'खाता बनाने का मतलब है कि आप उपयोग की शर्तें और गोपनीयता नीति स्वीकार करते हैं।';

  @override
  String get home => 'होम';

  @override
  String get myGym => 'मेरा जिम';

  @override
  String get findAGymTab => 'जिम खोजें';

  @override
  String get discover => 'खोजें';

  @override
  String get sendOtp => 'OTP भेजें';

  @override
  String get verifyYourNumber => 'अपना नंबर सत्यापित करें';

  @override
  String get codeResent => 'नया कोड भेजा जा रहा है।';

  @override
  String get name => 'नाम';

  @override
  String get email => 'ईमेल';

  @override
  String get connection => 'कनेक्शन';

  @override
  String get account => 'खाता';

  @override
  String get session => 'सत्र';

  @override
  String get earnByReferring => 'रेफ़र करके कमाएं';

  @override
  String get gyms => 'जिम';

  @override
  String get events => 'इवेंट';

  @override
  String get chat => 'चैट';

  @override
  String get profile => 'प्रोफ़ाइल';

  @override
  String get findAGym => 'जिम खोजें';

  @override
  String get searchGyms => 'नाम या इलाके से खोजें';

  @override
  String get noGymsFound => 'यहाँ अभी कोई जिम नहीं मिला';

  @override
  String get perks => 'सुविधाएं';

  @override
  String get contactGym => 'इस जिम से संपर्क करें';

  @override
  String get rating => 'रेटिंग';

  @override
  String get yourMembership => 'आपकी सदस्यता';

  @override
  String daysRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दिन बचे',
      one: '1 दिन बचा',
      zero: 'आज समाप्त',
    );
    return '$_temp0';
  }

  @override
  String get yourGoal => 'आपका लक्ष्य';

  @override
  String get trainer => 'ट्रेनर';

  @override
  String get requestLeave => 'छुट्टी का अनुरोध';

  @override
  String get yourProgress => 'आपकी प्रगति';

  @override
  String get weight => 'वज़न';

  @override
  String get height => 'कद';

  @override
  String get yourMeasurements => 'आपके माप';

  @override
  String get addMeasurements =>
      'अपना वज़न और कद डालें ताकि आपका जिम आपके साथ प्रगति देख सके';

  @override
  String get checkInDue => 'इस महीने की जाँच बाकी है';

  @override
  String get thisMonth => 'इस महीने';

  @override
  String get perWeek => 'प्रति सप्ताह';

  @override
  String weeksRunning(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'लगातार सप्ताह',
      one: 'लगातार सप्ताह',
    );
    return '$_temp0';
  }

  @override
  String get lastEightWeeks => 'पिछले 8 सप्ताह';

  @override
  String get exerciseDirectory => 'व्यायाम सूची';

  @override
  String get exerciseDirectorySubtitle =>
      'ताकत, कार्डियो और योग, हर कदम के निर्देश के साथ';

  @override
  String get steps => 'चरण';

  @override
  String get attendance => 'उपस्थिति';

  @override
  String get members => 'सदस्य';

  @override
  String get staff => 'स्टाफ';

  @override
  String get leave => 'छुट्टी';

  @override
  String get roles => 'भूमिकाएं';

  @override
  String get analytics => 'विश्लेषण';

  @override
  String get growth => 'वृद्धि';

  @override
  String get ranking => 'रैंकिंग';

  @override
  String get plan => 'प्लान';

  @override
  String get announce => 'घोषणा';

  @override
  String get gymProfile => 'जिम प्रोफ़ाइल';

  @override
  String get trainers => 'ट्रेनर';

  @override
  String get present => 'उपस्थित';

  @override
  String get absent => 'अनुपस्थित';

  @override
  String get markAttendance => 'उपस्थिति दर्ज करें';

  @override
  String get getHelp => 'मदद लें';

  @override
  String get getHelpSubtitle => 'हमें संदेश भेजें, हम आपसे संपर्क करेंगे';

  @override
  String get termsAndPrivacy => 'शर्तें और गोपनीयता नीति';

  @override
  String get signOut => 'साइन आउट';

  @override
  String get switchToStaff => 'मालिक/स्टाफ मोड में जाएं';

  @override
  String get switchToMember => 'सदस्य मोड में जाएं';

  @override
  String get notifications => 'सूचनाएं';

  @override
  String get noNotifications => 'कुछ नया नहीं';

  @override
  String get needsReview => 'अनुवाद की समीक्षा बाकी है';
}
