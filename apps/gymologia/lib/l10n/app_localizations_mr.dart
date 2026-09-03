// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get appName => 'Gymologia';

  @override
  String get languageName => 'मराठी';

  @override
  String get settings => 'सेटिंग्ज';

  @override
  String get language => 'भाषा';

  @override
  String get languageSubtitle => 'तुम्हाला सर्वात सोयीची वाटणारी भाषा निवडा';

  @override
  String get save => 'जतन करा';

  @override
  String get cancel => 'रद्द करा';

  @override
  String get tryAgain => 'पुन्हा प्रयत्न करा';

  @override
  String get loading => 'लोड होत आहे';

  @override
  String get somethingWentWrong => 'काहीतरी चूक झाली';

  @override
  String get signIn => 'साइन इन';

  @override
  String get phoneNumber => 'मोबाईल नंबर';

  @override
  String get enterPhoneNumber => 'तुमचा मोबाईल नंबर टाका';

  @override
  String get sendCode => 'कोड पाठवा';

  @override
  String get verifyCode => 'पडताळणी करा';

  @override
  String get enterCode => 'आम्ही पाठवलेला कोड टाका';

  @override
  String get resendCode => 'पुन्हा पाठवा';

  @override
  String get createAccount => 'तुमचे खाते तयार करा';

  @override
  String get yourName => 'तुमचे नाव';

  @override
  String get emailOptional => 'ईमेल (ऐच्छिक)';

  @override
  String get age => 'वय';

  @override
  String get whyAgeNotBirthday =>
      'आम्ही तुमचे वय विचारतो, जन्मतारीख नाही. जन्मतारीख तुमच्या बँक आणि सरकारी कागदपत्रांशी जोडलेली असते — जिम अ‍ॅपसाठी वय पुरेसे आहे.';

  @override
  String get termsAgreement =>
      'खाते तयार करणे म्हणजे तुम्ही वापराच्या अटी आणि गोपनीयता धोरण स्वीकारता.';

  @override
  String get home => 'होम';

  @override
  String get myGym => 'माझे जिम';

  @override
  String get findAGymTab => 'जिम शोधा';

  @override
  String get discover => 'शोधा';

  @override
  String get sendOtp => 'OTP पाठवा';

  @override
  String get verifyYourNumber => 'तुमचा नंबर पडताळा';

  @override
  String get codeResent => 'नवीन कोड पाठवला जात आहे.';

  @override
  String get name => 'नाव';

  @override
  String get email => 'ईमेल';

  @override
  String get connection => 'कनेक्शन';

  @override
  String get account => 'खाते';

  @override
  String get session => 'सत्र';

  @override
  String get earnByReferring => 'संदर्भ देऊन कमवा';

  @override
  String get gyms => 'जिम';

  @override
  String get events => 'कार्यक्रम';

  @override
  String get chat => 'चॅट';

  @override
  String get profile => 'प्रोफाइल';

  @override
  String get findAGym => 'जिम शोधा';

  @override
  String get searchGyms => 'नाव किंवा परिसरानुसार शोधा';

  @override
  String get noGymsFound => 'इथे अजून कोणतेही जिम नाही';

  @override
  String get perks => 'सुविधा';

  @override
  String get contactGym => 'या जिमशी संपर्क साधा';

  @override
  String get rating => 'रेटिंग';

  @override
  String get yourMembership => 'तुमचे सदस्यत्व';

  @override
  String get onLeavePaused => 'रजेवर — तुमचे सदस्यत्व थांबले आहे';

  @override
  String get monthlyCheckIn => 'मासिक नोंद';

  @override
  String get notNow => 'आता नाही';

  @override
  String trainerNamed(String name) {
    return 'प्रशिक्षक: $name';
  }

  @override
  String goalAtGym(String gym) {
    return '$gym मध्ये तुमचे ध्येय';
  }

  @override
  String daysRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दिवस बाकी',
      one: '1 दिवस बाकी',
      zero: 'आज संपते',
    );
    return '$_temp0';
  }

  @override
  String get yourGoal => 'तुमचे ध्येय';

  @override
  String get trainer => 'प्रशिक्षक';

  @override
  String get requestLeave => 'रजेची विनंती';

  @override
  String get yourProgress => 'तुमची प्रगती';

  @override
  String get weight => 'वजन';

  @override
  String get height => 'उंची';

  @override
  String get yourMeasurements => 'तुमची मापे';

  @override
  String get addMeasurements =>
      'तुमचे वजन आणि उंची भरा म्हणजे जिम तुमच्यासोबत प्रगती पाहू शकेल';

  @override
  String get checkInDue => 'या महिन्याची नोंद बाकी आहे';

  @override
  String get thisMonth => 'या महिन्यात';

  @override
  String get perWeek => 'दर आठवड्याला';

  @override
  String weeksRunning(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'सलग आठवडे',
      one: 'सलग आठवडा',
    );
    return '$_temp0';
  }

  @override
  String get lastEightWeeks => 'मागील 8 आठवडे';

  @override
  String get exerciseDirectory => 'व्यायाम सूची';

  @override
  String get exercises => 'व्यायाम';

  @override
  String get searchExercises => 'व्यायाम शोधा';

  @override
  String get clear => 'साफ करा';

  @override
  String get howToDoIt => 'कसे करावे';

  @override
  String get watchOutFor => 'लक्षात ठेवा';

  @override
  String get whatYouGet => 'तुम्हाला काय मिळते';

  @override
  String get removeYourEntry => 'तुमची नोंद काढायची?';

  @override
  String get stayIn => 'राहा';

  @override
  String get removeMe => 'मला काढा';

  @override
  String get youAreInTapToWithdraw =>
      'तुम्ही सहभागी आहात — काढण्यासाठी टॅप करा';

  @override
  String get participate => 'सहभागी व्हा';

  @override
  String takenOffList(String event) {
    return '$event च्या यादीतून तुमचे नाव काढले जाईल.';
  }

  @override
  String contactWithPhone(String phone) {
    return 'संपर्क $phone';
  }

  @override
  String get reasonOptional => 'कारण (ऐच्छिक)';

  @override
  String get searchByGymCityDistrict => 'जिम, शहर किंवा जिल्ह्याने शोधा';

  @override
  String get exerciseDirectorySubtitle =>
      'ताकद, कार्डिओ आणि योग, प्रत्येक पायरीच्या सूचनांसह';

  @override
  String get steps => 'पायऱ्या';

  @override
  String get attendance => 'उपस्थिती';

  @override
  String get members => 'सदस्य';

  @override
  String get staff => 'कर्मचारी';

  @override
  String get leave => 'रजा';

  @override
  String get roles => 'भूमिका';

  @override
  String get analytics => 'विश्लेषण';

  @override
  String get growth => 'वाढ';

  @override
  String get ranking => 'क्रमवारी';

  @override
  String get plan => 'प्लॅन';

  @override
  String get announce => 'घोषणा';

  @override
  String get gymProfile => 'जिम प्रोफाइल';

  @override
  String get trainers => 'प्रशिक्षक';

  @override
  String get present => 'हजर';

  @override
  String get absent => 'गैरहजर';

  @override
  String get markAttendance => 'उपस्थिती नोंदवा';

  @override
  String get getHelp => 'मदत मिळवा';

  @override
  String get getHelpSubtitle => 'आम्हाला संदेश पाठवा, आम्ही संपर्क करू';

  @override
  String get termsAndPrivacy => 'अटी आणि गोपनीयता धोरण';

  @override
  String get signOut => 'साइन आउट';

  @override
  String get switchToStaff => 'मालक/कर्मचारी मोडमध्ये जा';

  @override
  String get switchToMember => 'सदस्य मोडमध्ये जा';

  @override
  String get notifications => 'सूचना';

  @override
  String get noNotifications => 'नवीन काही नाही';

  @override
  String get needsReview => 'भाषांतर पुनरावलोकनाच्या प्रतीक्षेत';
}
