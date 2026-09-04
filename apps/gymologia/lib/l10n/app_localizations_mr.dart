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
  String get signInWithMobile => 'तुमच्या मोबाइल नंबरने साइन इन करा';

  @override
  String get mobileNumber => 'मोबाइल नंबर';

  @override
  String get couldNotSendCode => 'कोड पाठवता आला नाही.';

  @override
  String get verificationFailed => 'पडताळणी अयशस्वी झाली.';

  @override
  String get couldNotResendCode => 'कोड पुन्हा पाठवता आला नाही.';

  @override
  String get couldNotCreateAccount => 'तुमचे खाते तयार करता आले नाही.';

  @override
  String weSentCodeTo(String phone) {
    return 'आम्ही $phone वर कोड पाठवला आहे';
  }

  @override
  String resendInSeconds(int seconds) {
    return '$seconds सेकंदात पुन्हा पाठवा';
  }

  @override
  String get verified => 'पडताळले';

  @override
  String get createAccountAction => 'खाते तयार करा';

  @override
  String get home => 'होम';

  @override
  String get myGym => 'माझे जिम';

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
  String get addMeasurementsPrompt =>
      'तुमचे वजन आणि उंची भरा म्हणजे जिम तुमच्यासोबत प्रगती पाहू शकेल.';

  @override
  String get progressSubtitle => 'कालांतराने वजन, आणि तुम्ही किती वेळा आलात.';

  @override
  String get attendanceAppearsHere =>
      'तुम्ही एखाद्या जिमचे सदस्य झाल्यावर आणि कर्मचारी उपस्थिती नोंदवू लागल्यावर हे इथे दिसेल.';

  @override
  String get twoCheckInsDrawALine =>
      'दोन नोंदींनी रेषा तयार होते. दर महिन्याला वजन भरा, हे भरत जाईल.';

  @override
  String get nothingMatchesFilters => 'या फिल्टरशी काहीही जुळत नाही.';

  @override
  String get howToJoinGym =>
      'सामील होण्यासाठी थेट जिमशी संपर्क साधा. ते तुम्हाला सदस्य म्हणून जोडतील.';

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
  String get manage => 'व्यवस्थापन';

  @override
  String get choosePlan => 'प्लॅन निवडा';

  @override
  String get seeGrowthOverTime => 'कालांतराने वाढ पहा';

  @override
  String lastNDays(int days) {
    return 'मागील $days दिवस';
  }

  @override
  String get addMember => 'सदस्य जोडा';

  @override
  String get addStaff => 'कर्मचारी जोडा';

  @override
  String get searchByNameOrNumber => 'नाव किंवा नंबरने शोधा';

  @override
  String get tapCircleToMarkPresent =>
      'उपस्थितीसाठी वर्तुळावर टॅप करा, तपशिलांसाठी ओळीवर';

  @override
  String markedPresent(String name) {
    return '$name उपस्थित नोंदवले';
  }

  @override
  String get approve => 'मंजूर करा';

  @override
  String get role => 'भूमिका';

  @override
  String get theirName => 'त्यांचे नाव';

  @override
  String get theirMobileNumber => 'त्यांचा मोबाईल नंबर';

  @override
  String get codeFromTheirPhone => 'त्यांच्या फोनवरील कोड';

  @override
  String get whatDoTheyWant => 'त्यांना जिमकडून काय हवे आहे?';

  @override
  String get goalHint => 'वजन वाढवणे, कमी करणे, रिहॅब…';

  @override
  String get saveChanges => 'बदल जतन करा';

  @override
  String get removeFromGym => 'जिममधून काढा';

  @override
  String get remove => 'काढा';

  @override
  String removePerson(String name) {
    return '$name ला काढायचे?';
  }

  @override
  String get onLeave => 'रजा';

  @override
  String get tapDayToCorrect => 'दुरुस्त करण्यासाठी दिवसावर टॅप करा';

  @override
  String correctDate(String date) {
    return '$date दुरुस्त करा';
  }

  @override
  String get whyIsThisChanging => 'हे का बदलत आहे?';

  @override
  String get correctionReasonHint => 'चुकून नोंदवले, मशीन बंद होते…';

  @override
  String get saveCorrection => 'दुरुस्ती जतन करा';

  @override
  String get recordCorrected => 'नोंद दुरुस्त झाली.';

  @override
  String get trainerCategories => 'प्रशिक्षक श्रेणी';

  @override
  String get newCategory => 'नवीन श्रेणी';

  @override
  String get noTrainerCategoriesYet => 'अजून प्रशिक्षक श्रेणी नाहीत.';

  @override
  String get oneTrainerManyMembers => 'एक प्रशिक्षक अनेक सदस्य घेऊ शकतो';

  @override
  String get categoryNameHint => 'रिहॅब, स्ट्रेंथ, योग';

  @override
  String get edit => 'संपादित करा';

  @override
  String get delete => 'हटवा';

  @override
  String get keepIt => 'राहू द्या';

  @override
  String deleteNamed(String name) {
    return '$name हटवायचे?';
  }

  @override
  String get decline => 'नाकारा';

  @override
  String decidedBy(String name) {
    return '$name यांनी ठरवले';
  }

  @override
  String get createAGym => 'जिम तयार करा';

  @override
  String get createYourGym => 'तुमचे जिम तयार करा';

  @override
  String get gymName => 'जिमचे नाव';

  @override
  String get gymNameHint => 'आयर्न टेंपल फिटनेस';

  @override
  String get descriptionOptional => 'वर्णन (ऐच्छिक)';

  @override
  String get descriptionHint => 'तुमच्या जिममध्ये सामील होण्यासारखे काय आहे?';

  @override
  String get address => 'पत्ता';

  @override
  String get city => 'शहर';

  @override
  String get district => 'जिल्हा';

  @override
  String get districtNote =>
      'शोधात तुमच्या जिमच्या नावापुढे जिल्हा दिसतो, त्यामुळे सदस्य ओळखू शकतात.';

  @override
  String get state => 'राज्य';

  @override
  String get pinCode => 'पिन कोड';

  @override
  String get contactNumber => 'संपर्क क्रमांक';

  @override
  String get leavePolicyNote =>
      'सदस्य महिन्यातून काही दिवस सदस्यत्व थांबवू शकतात. त्यापेक्षा जास्त विनंत्यांना मंजुरी लागते.';

  @override
  String get perksLabel => 'सुविधा, स्वल्पविरामाने वेगळ्या';

  @override
  String get perksHint => 'स्टीम रूम, मोफत पार्किंग, वैयक्तिक प्रशिक्षण';

  @override
  String get createGym => 'जिम तयार करा';

  @override
  String get deleteGym => 'जिम हटवा';

  @override
  String get gymProfile => 'जिम प्रोफाइल';

  @override
  String get description => 'वर्णन';

  @override
  String get leavePolicy => 'रजा धोरण';

  @override
  String get leaveDaysPerMonth => 'दरमहा रजेचे दिवस';

  @override
  String get deleteThisGym => 'हे जिम हटवा';

  @override
  String get leaveLimitNote =>
      'या मर्यादेतील सदस्यांच्या विनंत्या आपोआप मंजूर होतात. त्यापेक्षा जास्तसाठी कोणाची तरी मंजुरी लागते.';

  @override
  String get draftNote =>
      'तुमचे जिम मसुदा म्हणून सुरू होते. पडताळणी पूर्ण करून प्लॅन घेईपर्यंत ते शोधात दिसणार नाही.';

  @override
  String get sendThis => 'हे पाठवायचे?';

  @override
  String get send => 'पाठवा';

  @override
  String get announcements => 'घोषणा';

  @override
  String get title => 'शीर्षक';

  @override
  String get announceTitleHint => 'देखभालीसाठी रविवारी बंद';

  @override
  String get message => 'संदेश';

  @override
  String get announceBodyHint =>
      'आम्ही सोमवारी सकाळी 6 वाजता पुन्हा उघडू. कमी सूचनेबद्दल क्षमस्व.';

  @override
  String get whoSeesIt => 'कोण पाहील';

  @override
  String get everyone => 'सर्वजण';

  @override
  String get sendAnnouncement => 'घोषणा पाठवा';

  @override
  String get sent => 'पाठवले';

  @override
  String get newGym => 'नवीन जिम';

  @override
  String get draft => 'मसुदा';

  @override
  String get nothingToChartYet => 'अजून दाखवण्यासारखे काही नाही.';

  @override
  String peakValue(int value) {
    return 'उच्चांक $value';
  }

  @override
  String get searchRanking => 'शोध क्रमवारी';

  @override
  String get notInSearch => 'शोधात नाही';

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
