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
  String get onLeavePaused => 'छुट्टी पर — आपकी सदस्यता रुकी हुई है';

  @override
  String get monthlyCheckIn => 'मासिक जाँच';

  @override
  String get notNow => 'अभी नहीं';

  @override
  String trainerNamed(String name) {
    return 'ट्रेनर: $name';
  }

  @override
  String goalAtGym(String gym) {
    return '$gym में आपका लक्ष्य';
  }

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
  String get addMeasurementsPrompt =>
      'अपना वज़न और कद डालें ताकि आपका जिम आपके साथ प्रगति देख सके।';

  @override
  String get progressSubtitle => 'समय के साथ वज़न, और आप कितनी बार आए।';

  @override
  String get attendanceAppearsHere =>
      'जब आप किसी जिम के सदस्य बनेंगे और स्टाफ आपकी उपस्थिति दर्ज करना शुरू करेगा, तब यह यहाँ दिखेगी।';

  @override
  String get twoCheckInsDrawALine =>
      'दो जाँचों से रेखा बनती है। हर महीने अपना वज़न डालें और यह भर जाएगा।';

  @override
  String get nothingMatchesFilters => 'इन फ़िल्टरों से कुछ मेल नहीं खाता।';

  @override
  String get howToJoinGym =>
      'जुड़ने के लिए सीधे जिम से संपर्क करें। वे आपको सदस्य के रूप में जोड़ेंगे।';

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
  String get exercises => 'व्यायाम';

  @override
  String get searchExercises => 'व्यायाम खोजें';

  @override
  String get clear => 'साफ़ करें';

  @override
  String get howToDoIt => 'कैसे करें';

  @override
  String get watchOutFor => 'ध्यान रखें';

  @override
  String get whatYouGet => 'आपको क्या मिलता है';

  @override
  String get removeYourEntry => 'अपनी एंट्री हटाएं?';

  @override
  String get stayIn => 'बने रहें';

  @override
  String get removeMe => 'मुझे हटाएं';

  @override
  String get youAreInTapToWithdraw => 'आप शामिल हैं — हटने के लिए टैप करें';

  @override
  String get participate => 'भाग लें';

  @override
  String takenOffList(String event) {
    return '$event की सूची से आपका नाम हटा दिया जाएगा।';
  }

  @override
  String contactWithPhone(String phone) {
    return 'संपर्क करें $phone';
  }

  @override
  String get reasonOptional => 'कारण (वैकल्पिक)';

  @override
  String get searchByGymCityDistrict => 'जिम, शहर या ज़िले से खोजें';

  @override
  String get exerciseDirectorySubtitle =>
      'ताकत, कार्डियो और योग, हर कदम के निर्देश के साथ';

  @override
  String get steps => 'चरण';

  @override
  String get attendance => 'उपस्थिति';

  @override
  String get manage => 'प्रबंधन';

  @override
  String get choosePlan => 'प्लान चुनें';

  @override
  String get seeGrowthOverTime => 'समय के साथ वृद्धि देखें';

  @override
  String lastNDays(int days) {
    return 'पिछले $days दिन';
  }

  @override
  String get addMember => 'सदस्य जोड़ें';

  @override
  String get addStaff => 'स्टाफ जोड़ें';

  @override
  String get searchByNameOrNumber => 'नाम या नंबर से खोजें';

  @override
  String get tapCircleToMarkPresent =>
      'उपस्थिति के लिए गोले पर टैप करें, विवरण के लिए पंक्ति पर';

  @override
  String markedPresent(String name) {
    return '$name की उपस्थिति दर्ज';
  }

  @override
  String get approve => 'स्वीकृत करें';

  @override
  String get role => 'भूमिका';

  @override
  String get theirName => 'उनका नाम';

  @override
  String get theirMobileNumber => 'उनका मोबाइल नंबर';

  @override
  String get codeFromTheirPhone => 'उनके फ़ोन से कोड';

  @override
  String get whatDoTheyWant => 'वे जिम से क्या चाहते हैं?';

  @override
  String get goalHint => 'वज़न बढ़ाना, वज़न घटाना, रिहैब…';

  @override
  String get saveChanges => 'बदलाव सहेजें';

  @override
  String get removeFromGym => 'जिम से हटाएं';

  @override
  String get remove => 'हटाएं';

  @override
  String removePerson(String name) {
    return '$name को हटाएं?';
  }

  @override
  String get onLeave => 'छुट्टी';

  @override
  String get tapDayToCorrect => 'सुधारने के लिए किसी दिन पर टैप करें';

  @override
  String correctDate(String date) {
    return '$date सुधारें';
  }

  @override
  String get whyIsThisChanging => 'यह क्यों बदल रहा है?';

  @override
  String get correctionReasonHint => 'गलती से दर्ज, मशीन बंद थी…';

  @override
  String get saveCorrection => 'सुधार सहेजें';

  @override
  String get recordCorrected => 'रिकॉर्ड सुधर गया।';

  @override
  String get trainerCategories => 'ट्रेनर श्रेणियां';

  @override
  String get newCategory => 'नई श्रेणी';

  @override
  String get noTrainerCategoriesYet => 'अभी कोई ट्रेनर श्रेणी नहीं।';

  @override
  String get oneTrainerManyMembers => 'एक ट्रेनर कई सदस्य ले सकता है';

  @override
  String get categoryNameHint => 'रिहैब, स्ट्रेंथ, योग';

  @override
  String get edit => 'संपादित करें';

  @override
  String get delete => 'हटाएं';

  @override
  String get keepIt => 'रहने दें';

  @override
  String deleteNamed(String name) {
    return '$name हटाएं?';
  }

  @override
  String get decline => 'अस्वीकार करें';

  @override
  String decidedBy(String name) {
    return '$name द्वारा तय';
  }

  @override
  String get createAGym => 'जिम बनाएं';

  @override
  String get createYourGym => 'अपना जिम बनाएं';

  @override
  String get gymName => 'जिम का नाम';

  @override
  String get gymNameHint => 'आयरन टेंपल फिटनेस';

  @override
  String get descriptionOptional => 'विवरण (वैकल्पिक)';

  @override
  String get descriptionHint => 'आपके जिम में जुड़ने लायक क्या है?';

  @override
  String get address => 'पता';

  @override
  String get city => 'शहर';

  @override
  String get district => 'ज़िला';

  @override
  String get districtNote =>
      'खोज में आपके जिम के नाम के आगे आपका ज़िला दिखता है, ताकि सदस्य पहचान सकें।';

  @override
  String get state => 'राज्य';

  @override
  String get pinCode => 'पिन कोड';

  @override
  String get contactNumber => 'संपर्क नंबर';

  @override
  String get leavePolicyNote =>
      'सदस्य महीने में कुछ दिनों के लिए अपनी सदस्यता रोक सकते हैं। इससे ज़्यादा के अनुरोध मंज़ूरी मांगते हैं।';

  @override
  String get perksLabel => 'सुविधाएं, अल्पविराम से अलग';

  @override
  String get perksHint => 'स्टीम रूम, मुफ़्त पार्किंग, पर्सनल ट्रेनिंग';

  @override
  String get createGym => 'जिम बनाएं';

  @override
  String get draftNote =>
      'आपका जिम ड्राफ्ट के रूप में शुरू होता है। प्लान लेने तक यह खोज में नहीं दिखेगा।';

  @override
  String get sendThis => 'यह भेजें?';

  @override
  String get send => 'भेजें';

  @override
  String get announcements => 'घोषणाएं';

  @override
  String get title => 'शीर्षक';

  @override
  String get announceTitleHint => 'रखरखाव के लिए रविवार बंद';

  @override
  String get message => 'संदेश';

  @override
  String get announceBodyHint =>
      'हम सोमवार सुबह 6 बजे फिर खुलेंगे। कम सूचना के लिए क्षमा करें।';

  @override
  String get whoSeesIt => 'कौन देखेगा';

  @override
  String get everyone => 'सभी';

  @override
  String get sendAnnouncement => 'घोषणा भेजें';

  @override
  String get sent => 'भेजा गया';

  @override
  String get newGym => 'नया जिम';

  @override
  String get draft => 'ड्राफ्ट';

  @override
  String get nothingToChartYet => 'अभी दिखाने को कुछ नहीं।';

  @override
  String peakValue(int value) {
    return 'शिखर $value';
  }

  @override
  String get searchRanking => 'खोज रैंकिंग';

  @override
  String get notInSearch => 'खोज में नहीं';

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
