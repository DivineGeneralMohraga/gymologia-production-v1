// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'Gymologia Referral';

  @override
  String get tryAgain => 'फिर कोशिश करें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get save => 'सेव करें';

  @override
  String get add => 'जोड़ें';

  @override
  String get change => 'बदलें';

  @override
  String get genericError => 'कुछ गड़बड़ हो गई। कृपया फिर कोशिश करें।';

  @override
  String cleartextWarning(String host) {
    return '$host से बिना सुरक्षा (plain http) के जुड़ा है';
  }

  @override
  String get signInSubtitle =>
      'कोड शेयर करें। जब कोई जिम सदस्यता लेगा, आपकी कमाई होगी।';

  @override
  String get phoneLabel => 'मोबाइल नंबर';

  @override
  String get phoneHint => '10 अंकों का मोबाइल नंबर';

  @override
  String get sendCode => 'कोड भेजें';

  @override
  String codeSentTo(String phone) {
    return '$phone पर कोड भेजा गया';
  }

  @override
  String get verify => 'पुष्टि करें';

  @override
  String resendIn(int seconds) {
    return 'आप $seconds सेकंड बाद दूसरा कोड माँग सकते हैं';
  }

  @override
  String get resend => 'दूसरा कोड भेजें';

  @override
  String get changeNumber => 'दूसरा नंबर इस्तेमाल करें';

  @override
  String get enterTenDigits => 'अपना 10 अंकों का मोबाइल नंबर डालें।';

  @override
  String get enterTheCode => 'हमने जो कोड भेजा है वह डालें।';

  @override
  String get ownersCannotJoin =>
      'जिम मालिक रेफरल ऐप इस्तेमाल नहीं कर सकते। जिम स्टाफ और बाकी सभी कर सकते हैं।';

  @override
  String get createAccountTitle => 'अपना खाता बनाएँ';

  @override
  String get nameLabel => 'नाम';

  @override
  String get emailLabel => 'ईमेल (वैकल्पिक)';

  @override
  String get ageLabel => 'उम्र';

  @override
  String get ageWhy =>
      'हम सिर्फ़ उम्र पूछते हैं, जन्मतिथि कभी नहीं। जन्मतिथि आपके बैंक और सरकारी दस्तावेज़ों की चाबी है; उम्र नहीं।';

  @override
  String get ageRange => '13 से 100 के बीच उम्र डालें।';

  @override
  String get nameRequired => 'कृपया अपना नाम डालें।';

  @override
  String get createAccount => 'खाता बनाएँ';

  @override
  String get tabCode => 'आपका कोड';

  @override
  String get tabEarnings => 'कमाई';

  @override
  String get tabPayout => 'भुगतान';

  @override
  String get tabSettings => 'सेटिंग्स';

  @override
  String get yourCodeTitle => 'आपका रेफरल कोड';

  @override
  String get shareCode => 'शेयर करें';

  @override
  String get copyCode => 'कॉपी करें';

  @override
  String get copied => 'कॉपी हो गया।';

  @override
  String get shareUnavailable =>
      'यहाँ शेयर करना उपलब्ध नहीं है। संदेश कॉपी कर दिया गया है।';

  @override
  String get howItWorksTitle => 'यह कैसे काम करता है';

  @override
  String get howItWorksStep1 => 'अपना कोड किसी जिम चलाने वाले को भेजें।';

  @override
  String howItWorksStep2(int percent) {
    return 'सदस्यता लेते समय उन्हें किसी भी Gymologia प्लान पर $percent% की छूट मिलेगी।';
  }

  @override
  String howItWorksStep3(String amount) {
    return 'इस कोड से सदस्यता लेने वाले हर जिम पर आपको $amount मिलेंगे।';
  }

  @override
  String howItWorksStep4(String amount) {
    return 'आपकी UPI ID वाकई आपकी है, यह जाँचने के लिए पहले भुगतान में से एक बार $amount काटे जाते हैं।';
  }

  @override
  String get notForOwners => 'अपने ही जिम से आप कमाई नहीं कर सकते।';

  @override
  String get earnedTotal => 'अब तक कमाए';

  @override
  String get heldPending => 'रोके गए';

  @override
  String get paidOut => 'भुगतान किए गए';

  @override
  String get taxWithheld => 'काटा गया कर';

  @override
  String get neverUsed => 'अभी तक किसी ने आपका कोड इस्तेमाल नहीं किया।';

  @override
  String timesUsed(int count) {
    return '$count बार इस्तेमाल हुआ।';
  }

  @override
  String get usedOnce => 'एक बार इस्तेमाल हुआ।';

  @override
  String awaitingClearance(int count) {
    return '$count अब भी क्लियर हो रहे हैं।';
  }

  @override
  String get earningsTitle => 'आपके कोड ने क्या कमाया';

  @override
  String get earningsEmpty =>
      'अभी कुछ नहीं। अपना कोड किसी जिम चलाने वाले के साथ शेयर करें।';

  @override
  String earningsCapped(int count) {
    return 'सबसे नए $count दिखाए जा रहे हैं।';
  }

  @override
  String get statusPending => 'क्लियर हो रहा है';

  @override
  String get statusEligible => 'भुगतान के लिए तैयार';

  @override
  String get statusPaid => 'भुगतान हो गया';

  @override
  String get statusReversed => 'वापस लिया गया';

  @override
  String get statusPendingWhy => 'जिम की रिफंड अवधि खत्म होने तक रोका गया है।';

  @override
  String get statusEligibleWhy =>
      'क्लियर हो गया। भुगतान चालू होने का इंतज़ार है।';

  @override
  String get statusPaidWhy => 'आपकी UPI ID पर भेज दिया गया।';

  @override
  String get statusReversedWhy =>
      'जिम का भुगतान वापस हो गया, इसलिए यह इनाम भी वापस ले लिया गया।';

  @override
  String get payoutTitle => 'आपका पैसा कहाँ जाएगा';

  @override
  String get withdrawTitle => 'पैसे निकालें';

  @override
  String get withdrawAvailable => 'निकालने के लिए तैयार';

  @override
  String get withdrawFee => 'एक बार की UPI जाँच';

  @override
  String get withdrawArrives => 'आपको मिलेंगे';

  @override
  String withdrawButton(String amount) {
    return '$amount निकालें';
  }

  @override
  String withdrawConfirm(String amount, String upi) {
    return '$upi पर $amount भेजें?';
  }

  @override
  String get withdrawConfirmBody =>
      'यह वापस नहीं हो सकता। भेजने से पहले पता ठीक से जाँच लें।';

  @override
  String get withdrawRequested => 'अनुरोध हो गया। पैसे रास्ते में हैं।';

  @override
  String withdrawFeeWhy(String amount) {
    return 'पता वाकई आपका है, यह जाँचने के लिए एक बार $amount काटे जाते हैं। उसके बाद कुछ नहीं कटता।';
  }

  @override
  String get withdrawNoTax => 'इतनी रकम पर कोई कर नहीं काटा जाता।';

  @override
  String get withdrawHistoryTitle => 'निकासी';

  @override
  String get withdrawNone => 'आपने अभी तक कुछ नहीं निकाला।';

  @override
  String get withdrawStatusQueued => 'कतार में';

  @override
  String get withdrawStatusProcessing => 'भेजा जा रहा है';

  @override
  String get withdrawStatusSuccess => 'भेज दिया';

  @override
  String get withdrawStatusFailed => 'असफल';

  @override
  String get withdrawStatusReversed => 'वापस आया';

  @override
  String withdrawUtr(String utr) {
    return 'संदर्भ $utr';
  }

  @override
  String get payoutsNotLive =>
      'भुगतान अभी चालू नहीं हुए हैं। तब तक कमाई गिनी और रोकी जा रही है।';

  @override
  String get stillNeededTitle => 'अभी भी ज़रूरी';

  @override
  String get payoutInFlight =>
      'एक भुगतान रास्ते में है। यह सेटल होने के बाद ये बदले जा सकते हैं।';

  @override
  String get upiSectionTitle => 'UPI ID';

  @override
  String get upiIdLabel => 'UPI ID';

  @override
  String get upiIdHint => 'name@bank';

  @override
  String get holderNameLabel => 'खाते पर लिखा नाम';

  @override
  String get upiNotSet => 'सेट नहीं है';

  @override
  String get upiVerifiedYes => 'सत्यापित';

  @override
  String get upiVerifiedNo => 'अभी सत्यापित नहीं';

  @override
  String get upiTypoWarning =>
      'इसे एक-एक अक्षर जाँचें। UPI ID में कोई स्पेल-चेक नहीं होता: एक अक्षर की गलती किसी और का बिल्कुल सही पता बन जाती है, और वहाँ भेजा पैसा वापस नहीं आता।';

  @override
  String get upiChangedClearsVerification =>
      'इसे बदलने पर सत्यापन हट जाता है। पहले भुगतान से पहले पते की दोबारा जाँच होगी।';

  @override
  String get holderNameWhy =>
      '₹10 की जाँच में आपके बैंक के पास उस खाते पर दर्ज नाम वापस आता है। तुलना के लिए नाम न हो तो जाँच सिर्फ़ यह बताती है कि पता मौजूद है — यह नहीं कि वह आपका है।';

  @override
  String get saved => 'सेव हो गया।';

  @override
  String get invalidUpi =>
      'यह UPI ID जैसी नहीं लगती। यह name@bank जैसी होनी चाहिए।';

  @override
  String get holderNameRequired => 'बैंक खाते पर लिखा नाम डालें।';

  @override
  String get panSectionTitle => 'PAN';

  @override
  String get panLabel => 'PAN';

  @override
  String get panHint => 'ABCDE1234F';

  @override
  String get panNotSet => 'सेट नहीं है';

  @override
  String get panWhy =>
      'जब आपकी कमाई उस स्तर तक पहुँचे जहाँ कर काटना ज़रूरी हो जाए, उससे पहले यह चाहिए। शुरू करने के लिए ज़रूरी नहीं।';

  @override
  String get panStatusPending => 'मिल गया, अभी जाँचा नहीं गया';

  @override
  String get panStatusVerified => 'सत्यापित';

  @override
  String get panStatusRejected => 'स्वीकार नहीं हुआ। नंबर जाँचकर दोबारा भेजें।';

  @override
  String get invalidPan =>
      'यह PAN जैसा नहीं लगता। यह ABCDE1234F जैसा होना चाहिए।';

  @override
  String get settingsTitle => 'सेटिंग्स';

  @override
  String get profileTitle => 'आपकी प्रोफ़ाइल';

  @override
  String get languageTitle => 'भाषा';

  @override
  String get languageSubtitle => 'वह भाषा चुनें जो आप सबसे आराम से पढ़ते हैं';

  @override
  String get useDeviceLanguage => 'डिवाइस की भाषा इस्तेमाल करें';

  @override
  String get needsReview => 'अनुवाद की समीक्षा बाकी है';

  @override
  String get untranslatedFallbackNote =>
      'जो अभी अनुवादित नहीं है वह खाली छोड़ने के बजाय अंग्रेज़ी में दिखाया जाता है, ताकि आंशिक रूप से अनुवादित भाषा भी इस्तेमाल की जा सके।';

  @override
  String get legalTitle => 'शर्तें और गोपनीयता';

  @override
  String get legalUnavailable => 'अभी यह लोड नहीं हो सका।';

  @override
  String get supportTitle => 'मदद चाहिए?';

  @override
  String get supportBody => 'हमें बताएँ क्या हुआ, हम आपसे संपर्क करेंगे।';

  @override
  String get supportSubject => 'विषय';

  @override
  String get supportMessage => 'क्या हुआ?';

  @override
  String get supportSend => 'भेजें';

  @override
  String get supportSent => 'भेज दिया गया। हम आपसे संपर्क करेंगे।';

  @override
  String supportEmailLine(String email) {
    return 'या $email पर लिखें।';
  }

  @override
  String get supportTooShort =>
      'एक-दो वाक्य लिखें, ताकि हमें पता चले कि क्या देखना है।';

  @override
  String get signOut => 'साइन आउट';

  @override
  String get signOutConfirm => 'इस डिवाइस पर साइन आउट करें?';

  @override
  String get aboutTitle => 'ऐप के बारे में';

  @override
  String get sessionExpiredSignIn =>
      'आपका सत्र खत्म हो गया। कृपया दोबारा साइन इन करें।';

  @override
  String get serverTookTooLong =>
      'सर्वर ने जवाब देने में बहुत समय लिया। अपना कनेक्शन जाँचकर फिर कोशिश करें।';

  @override
  String couldNotReachServer(String host) {
    return '$host तक नहीं पहुँच सके। अपना इंटरनेट कनेक्शन जाँचें।';
  }

  @override
  String get certificateNotVerified =>
      'सर्वर का प्रमाणपत्र सत्यापित नहीं हो सका।';

  @override
  String get networkErrorTryAgain => 'नेटवर्क त्रुटि। कृपया फिर कोशिश करें।';

  @override
  String get footerLine => 'Gymologia Referral';

  @override
  String get footerSupport => 'support@gymologia.com';

  @override
  String get deleteAccount => 'खाता हटाएं';

  @override
  String get deleteAccountIntro =>
      'आपका खाता 30 दिन तक चलता रहेगा। उसके बाद यह हटा दिया जाएगा और वापस नहीं लाया जा सकता।';

  @override
  String get whatIsDeleted => 'क्या हटाया जाएगा';

  @override
  String get whatIsDeletedList =>
      'आपका नाम, नंबर और ईमेल। आपके UPI विवरण और PAN। आपका रेफरल कोड और कमाई का इतिहास। यह एक ही Gymologia खाता है — अगर आप Gymologia ऐप भी इस्तेमाल करते हैं, वहां का सब कुछ भी चला जाएगा।';

  @override
  String get whatIsKept => 'क्या रखा जाएगा, आपकी पहचान हटाकर';

  @override
  String get whatIsKeptList =>
      'भुगतान और चालान रिकॉर्ड, क्योंकि कानून हमें लेखा-बही रखने को कहता है। जिम में की गई कार्रवाइयों का रिकॉर्ड, ताकि विवाद सुलझाए जा सकें।';

  @override
  String unwithdrawnWarning(String amount) {
    return 'आपकी $amount की रेफरल कमाई अभी निकाली नहीं गई है। पहले Gymologia Referral ऐप से निकाल लें, वरना वह चली जाएगी।';
  }

  @override
  String get iUnderstandLoseEarnings =>
      'मैं समझता/समझती हूं कि यह पैसा चला जाएगा';

  @override
  String deletionScheduled(String date) {
    return 'आपका खाता $date को हटा दिया जाएगा।';
  }

  @override
  String get keepMyAccount => 'मेरा खाता रहने दें';

  @override
  String get deletionCancelled => 'आपका खाता नहीं हटाया जाएगा।';

  @override
  String get deleteAccountConfirm => 'मेरा खाता हटाएं';
}
