// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get appTitle => 'Gymologia Referral';

  @override
  String get tryAgain => 'पुन्हा प्रयत्न करा';

  @override
  String get cancel => 'रद्द करा';

  @override
  String get save => 'सेव्ह करा';

  @override
  String get add => 'जोडा';

  @override
  String get change => 'बदला';

  @override
  String get genericError => 'काहीतरी चुकले. कृपया पुन्हा प्रयत्न करा.';

  @override
  String cleartextWarning(String host) {
    return '$host शी सुरक्षेशिवाय (plain http) जोडलेले आहे';
  }

  @override
  String get signInSubtitle =>
      'कोड शेअर करा. एखाद्या जिमने सदस्यता घेतली की तुमची कमाई होते.';

  @override
  String get phoneLabel => 'मोबाइल क्रमांक';

  @override
  String get phoneHint => '10 अंकी मोबाइल क्रमांक';

  @override
  String get sendCode => 'कोड पाठवा';

  @override
  String codeSentTo(String phone) {
    return '$phone वर कोड पाठवला';
  }

  @override
  String get verify => 'पडताळा';

  @override
  String resendIn(int seconds) {
    return '$seconds सेकंदांनंतर तुम्ही दुसरा कोड मागू शकता';
  }

  @override
  String get resend => 'दुसरा कोड पाठवा';

  @override
  String get changeNumber => 'दुसरा क्रमांक वापरा';

  @override
  String get enterTenDigits => 'तुमचा 10 अंकी मोबाइल क्रमांक टाका.';

  @override
  String get enterTheCode => 'आम्ही पाठवलेला कोड टाका.';

  @override
  String get ownersCannotJoin =>
      'जिम मालक रेफरल अ‍ॅप वापरू शकत नाहीत. जिम कर्मचारी आणि इतर सर्वजण वापरू शकतात.';

  @override
  String get createAccountTitle => 'तुमचे खाते तयार करा';

  @override
  String get nameLabel => 'नाव';

  @override
  String get emailLabel => 'ईमेल (ऐच्छिक)';

  @override
  String get ageLabel => 'वय';

  @override
  String get ageWhy =>
      'आम्ही फक्त वय विचारतो, जन्मतारीख कधीच नाही. जन्मतारीख ही तुमच्या बँक आणि सरकारी कागदपत्रांची किल्ली आहे; वय नाही.';

  @override
  String get ageRange => '13 ते 100 दरम्यानचे वय टाका.';

  @override
  String get nameRequired => 'कृपया तुमचे नाव टाका.';

  @override
  String get createAccount => 'खाते तयार करा';

  @override
  String get tabCode => 'तुमचा कोड';

  @override
  String get tabEarnings => 'कमाई';

  @override
  String get tabPayout => 'पेमेंट';

  @override
  String get tabSettings => 'सेटिंग्ज';

  @override
  String get yourCodeTitle => 'तुमचा रेफरल कोड';

  @override
  String get shareCode => 'शेअर करा';

  @override
  String get copyCode => 'कॉपी करा';

  @override
  String get copied => 'कॉपी झाले.';

  @override
  String get shareUnavailable =>
      'इथे शेअर करता येत नाही. संदेश कॉपी करून ठेवला आहे.';

  @override
  String get howItWorksTitle => 'हे कसे चालते';

  @override
  String get howItWorksStep1 => 'जिम चालवणाऱ्या कोणालातरी तुमचा कोड पाठवा.';

  @override
  String howItWorksStep2(int percent) {
    return 'सदस्यता घेताना त्यांना कोणत्याही Gymologia प्लॅनवर $percent% सूट मिळेल.';
  }

  @override
  String howItWorksStep3(String amount) {
    return 'या कोडने सदस्यता घेणाऱ्या प्रत्येक जिमसाठी तुम्हाला $amount मिळतील.';
  }

  @override
  String howItWorksStep4(String amount) {
    return 'तुमची UPI ID खरोखर तुमचीच आहे हे तपासण्यासाठी पहिल्या पेमेंटमधून एकदा $amount कापले जातात.';
  }

  @override
  String get notForOwners => 'स्वतःच्या जिममधून तुम्ही कमाई करू शकत नाही.';

  @override
  String get earnedTotal => 'आतापर्यंत कमावले';

  @override
  String get heldPending => 'रोखून ठेवले';

  @override
  String get paidOut => 'दिले गेले';

  @override
  String get taxWithheld => 'कापलेला कर';

  @override
  String get neverUsed => 'अजून कोणीही तुमचा कोड वापरलेला नाही.';

  @override
  String timesUsed(int count) {
    return '$count वेळा वापरला.';
  }

  @override
  String get usedOnce => 'एकदा वापरला.';

  @override
  String awaitingClearance(int count) {
    return '$count अजून क्लिअर होत आहेत.';
  }

  @override
  String get earningsTitle => 'तुमच्या कोडने काय कमावले';

  @override
  String get earningsEmpty =>
      'अजून काही नाही. जिम चालवणाऱ्या कोणासोबत तरी तुमचा कोड शेअर करा.';

  @override
  String earningsCapped(int count) {
    return 'सर्वात अलीकडचे $count दाखवत आहोत.';
  }

  @override
  String get statusPending => 'क्लिअर होत आहे';

  @override
  String get statusEligible => 'पेमेंटसाठी तयार';

  @override
  String get statusPaid => 'दिले';

  @override
  String get statusReversed => 'परत घेतले';

  @override
  String get statusPendingWhy =>
      'जिमची परतावा मुदत संपेपर्यंत रोखून ठेवले आहे.';

  @override
  String get statusEligibleWhy =>
      'क्लिअर झाले. पेमेंट सुरू होण्याची वाट पाहत आहे.';

  @override
  String get statusPaidWhy => 'तुमच्या UPI ID वर पाठवले.';

  @override
  String get statusReversedWhy =>
      'जिमचे पेमेंट परत गेले, म्हणून हे बक्षीसही परत घेतले.';

  @override
  String get payoutTitle => 'तुमचे पैसे कुठे जातात';

  @override
  String get withdrawTitle => 'पैसे काढा';

  @override
  String get withdrawAvailable => 'काढण्यासाठी तयार';

  @override
  String get withdrawFee => 'एकदाची UPI तपासणी';

  @override
  String get withdrawArrives => 'तुम्हाला मिळतील';

  @override
  String withdrawButton(String amount) {
    return '$amount काढा';
  }

  @override
  String withdrawConfirm(String amount, String upi) {
    return '$upi वर $amount पाठवायचे?';
  }

  @override
  String get withdrawConfirmBody =>
      'हे परत घेता येणार नाही. पाठवण्यापूर्वी पत्ता बरोबर आहे का ते तपासा.';

  @override
  String get withdrawRequested => 'विनंती झाली. पैसे वाटेवर आहेत.';

  @override
  String withdrawFeeWhy(String amount) {
    return 'पत्ता खरोखर तुमचाच आहे हे तपासण्यासाठी एकदा $amount कापले जातात. त्यानंतर काहीही कापले जात नाही.';
  }

  @override
  String get withdrawNoTax => 'इतक्या रकमेवर कोणताही कर कापला जात नाही.';

  @override
  String get withdrawHistoryTitle => 'काढलेले पैसे';

  @override
  String get withdrawNone => 'तुम्ही अजून काहीही काढलेले नाही.';

  @override
  String get withdrawStatusQueued => 'रांगेत';

  @override
  String get withdrawStatusProcessing => 'पाठवत आहे';

  @override
  String get withdrawStatusSuccess => 'पाठवले';

  @override
  String get withdrawStatusFailed => 'अयशस्वी';

  @override
  String get withdrawStatusReversed => 'परत आले';

  @override
  String withdrawUtr(String utr) {
    return 'संदर्भ $utr';
  }

  @override
  String get payoutsNotLive =>
      'पेमेंट अजून सुरू झालेले नाहीत. तोपर्यंत कमाई मोजली आणि रोखून ठेवली जाते.';

  @override
  String get stillNeededTitle => 'अजून आवश्यक';

  @override
  String get payoutInFlight =>
      'एक पेमेंट वाटेवर आहे. ते पूर्ण झाल्यावर हे बदलता येईल.';

  @override
  String get upiSectionTitle => 'UPI ID';

  @override
  String get upiIdLabel => 'UPI ID';

  @override
  String get upiIdHint => 'name@bank';

  @override
  String get holderNameLabel => 'खात्यावरील नाव';

  @override
  String get upiNotSet => 'सेट केलेले नाही';

  @override
  String get upiVerifiedYes => 'पडताळले';

  @override
  String get upiVerifiedNo => 'अजून पडताळलेले नाही';

  @override
  String get upiTypoWarning =>
      'हे अक्षरा-अक्षराने तपासा. UPI ID ला स्पेल-चेक नसतो: एका अक्षराची चूक दुसऱ्या कोणाचातरी पूर्णपणे बरोबर पत्ता बनते, आणि तिथे पाठवलेले पैसे परत येत नाहीत.';

  @override
  String get upiChangedClearsVerification =>
      'हे बदलल्यास पडताळणी रद्द होते. पहिल्या पेमेंटपूर्वी पत्ता पुन्हा तपासला जाईल.';

  @override
  String get holderNameWhy =>
      '₹10 च्या तपासणीत त्या खात्यासाठी तुमच्या बँकेकडे नोंदलेले नाव परत येते. तुलना करण्यासाठी नाव नसेल तर तपासणी फक्त पत्ता अस्तित्वात आहे एवढेच सिद्ध करते — तो तुमचा आहे हे नाही.';

  @override
  String get saved => 'सेव्ह झाले.';

  @override
  String get invalidUpi =>
      'हे UPI ID सारखे दिसत नाही. ते name@bank सारखे असावे.';

  @override
  String get holderNameRequired => 'बँक खात्यावरील नाव टाका.';

  @override
  String get panSectionTitle => 'PAN';

  @override
  String get panLabel => 'PAN';

  @override
  String get panHint => 'ABCDE1234F';

  @override
  String get panNotSet => 'सेट केलेले नाही';

  @override
  String get panWhy =>
      'कर कापावा लागेल इतकी तुमची कमाई होण्यापूर्वी हे लागते. सुरुवात करण्यासाठी गरजेचे नाही.';

  @override
  String get panStatusPending => 'मिळाले, अजून तपासलेले नाही';

  @override
  String get panStatusVerified => 'पडताळले';

  @override
  String get panStatusRejected =>
      'स्वीकारले गेले नाही. क्रमांक तपासून पुन्हा पाठवा.';

  @override
  String get invalidPan => 'हे PAN सारखे दिसत नाही. ते ABCDE1234F सारखे असावे.';

  @override
  String get settingsTitle => 'सेटिंग्ज';

  @override
  String get profileTitle => 'तुमची प्रोफाइल';

  @override
  String get languageTitle => 'भाषा';

  @override
  String get languageSubtitle => 'तुम्ही सर्वात सहजपणे वाचता ती भाषा निवडा';

  @override
  String get useDeviceLanguage => 'डिव्हाइसची भाषा वापरा';

  @override
  String get needsReview => 'भाषांतराची तपासणी बाकी आहे';

  @override
  String get untranslatedFallbackNote =>
      'जे अजून भाषांतरित झालेले नाही ते रिकामे ठेवण्याऐवजी इंग्रजीत दाखवले जाते, त्यामुळे अंशतः भाषांतरित भाषाही वापरता येते.';

  @override
  String get legalTitle => 'अटी आणि गोपनीयता';

  @override
  String get legalUnavailable => 'हे आत्ता लोड करता आले नाही.';

  @override
  String get supportTitle => 'मदत हवी आहे?';

  @override
  String get supportBody => 'काय झाले ते सांगा, आम्ही तुमच्याशी संपर्क करू.';

  @override
  String get supportSubject => 'विषय';

  @override
  String get supportMessage => 'काय झाले?';

  @override
  String get supportSend => 'पाठवा';

  @override
  String get supportSent => 'पाठवले. आम्ही तुमच्याशी संपर्क करू.';

  @override
  String supportEmailLine(String email) {
    return 'किंवा $email वर लिहा.';
  }

  @override
  String get supportTooShort =>
      'एक-दोन वाक्ये लिहा, म्हणजे काय बघायचे ते आम्हाला कळेल.';

  @override
  String get signOut => 'साइन आउट';

  @override
  String get signOutConfirm => 'या डिव्हाइसवर साइन आउट करायचे?';

  @override
  String get aboutTitle => 'विषयी';

  @override
  String get sessionExpiredSignIn =>
      'तुमचे सत्र संपले. कृपया पुन्हा साइन इन करा.';

  @override
  String get serverTookTooLong =>
      'सर्व्हरने उत्तर द्यायला खूप वेळ घेतला. तुमचे कनेक्शन तपासून पुन्हा प्रयत्न करा.';

  @override
  String couldNotReachServer(String host) {
    return '$host पर्यंत पोहोचता आले नाही. तुमचे इंटरनेट कनेक्शन तपासा.';
  }

  @override
  String get certificateNotVerified => 'सर्व्हरचे प्रमाणपत्र पडताळता आले नाही.';

  @override
  String get networkErrorTryAgain =>
      'नेटवर्क त्रुटी. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get footerLine => 'Gymologia Referral';

  @override
  String get footerSupport => 'support@gymologia.com';

  @override
  String get deleteAccount => 'खाते हटवा';

  @override
  String get deleteAccountIntro =>
      'तुमचे खाते ३० दिवस वापरता येईल. त्यानंतर ते हटवले जाईल आणि परत मिळवता येणार नाही.';

  @override
  String get whatIsDeleted => 'काय हटवले जाईल';

  @override
  String get whatIsDeletedList =>
      'तुमचे नाव, नंबर आणि ईमेल. तुमचे UPI तपशील आणि PAN. तुमचा रेफरल कोड आणि कमाईचा इतिहास. हे एकच Gymologia खाते आहे — तुम्ही Gymologia अॅपही वापरत असाल, तर तिथलेही सर्व जाईल.';

  @override
  String get whatIsKept => 'काय ठेवले जाईल, तुमची ओळख काढून';

  @override
  String get whatIsKeptList =>
      'देयक आणि पावती नोंदी, कारण कायद्याने हिशेबाच्या वह्या ठेवाव्या लागतात. जिममधील कृतींची नोंद, जेणेकरून वाद सोडवता येतील.';

  @override
  String unwithdrawnWarning(String amount) {
    return 'तुमची $amount रेफरल कमाई अजून काढलेली नाही. आधी Gymologia Referral अॅपमधून काढून घ्या, अन्यथा ती जाईल.';
  }

  @override
  String get iUnderstandLoseEarnings => 'मला समजते की हे पैसे जातील';

  @override
  String deletionScheduled(String date) {
    return 'तुमचे खाते $date रोजी हटवले जाईल.';
  }

  @override
  String get keepMyAccount => 'माझे खाते ठेवा';

  @override
  String get deletionCancelled => 'तुमचे खाते हटवले जाणार नाही.';

  @override
  String get deleteAccountConfirm => 'माझे खाते हटवा';
}
