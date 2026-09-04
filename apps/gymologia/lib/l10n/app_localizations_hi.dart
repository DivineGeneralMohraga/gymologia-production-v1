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
  String get signInWithMobile => 'अपने मोबाइल नंबर से साइन इन करें';

  @override
  String get mobileNumber => 'मोबाइल नंबर';

  @override
  String get couldNotSendCode => 'कोड नहीं भेजा जा सका।';

  @override
  String get verificationFailed => 'सत्यापन विफल रहा।';

  @override
  String get couldNotResendCode => 'कोड दोबारा नहीं भेजा जा सका।';

  @override
  String get couldNotCreateAccount => 'आपका खाता नहीं बन सका।';

  @override
  String weSentCodeTo(String phone) {
    return 'हमने $phone पर कोड भेजा है';
  }

  @override
  String resendInSeconds(int seconds) {
    return '$seconds सेकंड में दोबारा भेजें';
  }

  @override
  String get verified => 'सत्यापित';

  @override
  String get createAccountAction => 'खाता बनाएं';

  @override
  String get supportSent => 'भेज दिया गया। आपके दिए नंबर पर जवाब आएगा।';

  @override
  String get supportSubject => 'यह किस बारे में है?';

  @override
  String get supportSubjectHint => 'मेरी सदस्यता के दिन गलत दिख रहे हैं';

  @override
  String get supportMessage => 'बताइए क्या हुआ';

  @override
  String get supportReplyTo => 'हम कहाँ जवाब दें?';

  @override
  String get supportUrgent => 'इससे मेरा जिम चल नहीं पा रहा';

  @override
  String get supportUrgentNote => 'प्राथमिकता बढ़ा देता है।';

  @override
  String copiedToClipboard(String value) {
    return '$value कॉपी हो गया';
  }

  @override
  String orEmailUs(String email) {
    return 'या $email पर ईमेल करें';
  }

  @override
  String get whatYouHaveAsked => 'आपने क्या पूछा है';

  @override
  String get aFewWordsIsEnough => 'कुछ शब्द काफी हैं';

  @override
  String get aSentenceOrTwoHelps => 'एक-दो वाक्य लिखें, इससे जल्दी हल होगा';

  @override
  String get ticketOpen => 'किसी के उठाने का इंतज़ार है';

  @override
  String get ticketInProgress => 'कोई इसे देख रहा है';

  @override
  String get ticketWaitingOnUser => 'आपके जवाब का इंतज़ार है';

  @override
  String get ticketResolved => 'हल हो गया';

  @override
  String get ticketClosed => 'बंद';

  @override
  String get referralPitch =>
      'कोड साझा करें और जब कोई जिम मालिक सदस्यता लेता है तो कमाएँ। रेफरल ऐप अभी नहीं आया है।';

  @override
  String get appTagline => 'जिमोलॉजिया · सदस्य और स्टाफ';

  @override
  String get signOutQuestion => 'साइन आउट करें?';

  @override
  String get signOutWarning =>
      'वापस साइन इन करने के लिए आपको अपना फ़ोन चाहिए होगा।';

  @override
  String get profileUpdated => 'प्रोफ़ाइल अपडेट हो गई।';

  @override
  String get yourProfile => 'आपकी प्रोफ़ाइल';

  @override
  String get emailClearToRemove => 'वैकल्पिक। हटाने के लिए खाली कर दें।';

  @override
  String get phoneIsYourLogin =>
      'इसी से आप साइन इन करते हैं, इसलिए इसे यहाँ अभी बदला नहीं जा सकता। बदलवाना हो तो सहायता से संपर्क करें।';

  @override
  String get trialStarted =>
      'ट्रायल शुरू हो गया। आपका जिम अब खोज में दिख रहा है।';

  @override
  String get invalidCode => 'कोड मान्य नहीं है।';

  @override
  String get paymentNotCompletedYet =>
      'भुगतान अभी पूरा नहीं हुआ। थोड़ी देर बाद खींचकर रिफ्रेश करें।';

  @override
  String planIsActive(String plan) {
    return '$plan प्लान चालू है।';
  }

  @override
  String get paymentNotCompleted => 'भुगतान पूरा नहीं हुआ।';

  @override
  String get couldNotOpenPayment => 'भुगतान स्क्रीन नहीं खुल सकी।';

  @override
  String daysFree(int days) {
    return '$days दिन मुफ़्त';
  }

  @override
  String get trialBlurb =>
      'पूरा प्रो, सदस्य खोज में आपकी लिस्टिंग सहित। कार्ड की ज़रूरत नहीं, और यह अपने आप किसी पेड प्लान में नहीं बदलता।';

  @override
  String get startFreeTrial => 'मुफ़्त ट्रायल शुरू करें';

  @override
  String get referralCode => 'रेफरल कोड';

  @override
  String get optional => 'वैकल्पिक';

  @override
  String get apply => 'लागू करें';

  @override
  String get gstNote =>
      'कीमतों में जीएसटी शामिल है। जिम सदस्य खोज में केवल प्रो प्लान पर दिखता है।';

  @override
  String planNamed(String plan) {
    return '$plan प्लान';
  }

  @override
  String get trialBadge => 'ट्रायल';

  @override
  String get expired => 'समाप्त';

  @override
  String daysRemainingPlan(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दिन बाकी',
    );
    return '$_temp0';
  }

  @override
  String get listedInSearch => 'सदस्य खोज में सूचीबद्ध';

  @override
  String get notListedUpgrade =>
      'खोज में नहीं — दिखने के लिए प्रो में अपग्रेड करें';

  @override
  String get trialEndsNote =>
      'ट्रायल खत्म होने पर जब तक आप प्लान नहीं चुनते, आपका जिम खोज से हट जाता है। अपने आप कुछ भी नहीं कटता।';

  @override
  String get getsYouListed => 'खोज में दिखाता है';

  @override
  String get perMonth => '/माह';

  @override
  String choosePlanNamed(String plan) {
    return '$plan चुनें';
  }

  @override
  String get deleteRoleWarning =>
      'भूमिका और उसकी अनुमतियाँ हट जाएँगी। इसमें कोई नहीं है, इसलिए किसी की पहुँच नहीं जाएगी।';

  @override
  String deletedNamed(String name) {
    return '$name हटा दिया गया';
  }

  @override
  String get needTwoCustomRoles =>
      'क्रम बदलने से पहले आपके पास दो ऐसी कस्टम भूमिकाएँ होनी चाहिए जिन्हें आप बदल सकें।';

  @override
  String get hierarchySaved => 'क्रम सहेजा गया';

  @override
  String get reorder => 'क्रम बदलें';

  @override
  String get newRole => 'नई भूमिका';

  @override
  String get rolesIntro =>
      'सबसे वरिष्ठ पहले। आप केवल अपनी भूमिका से नीचे की भूमिकाएँ बदल सकते हैं, और केवल वही अनुमतियाँ दे सकते हैं जो आपके पास हैं।';

  @override
  String get defaultBadge => 'डिफ़ॉल्ट';

  @override
  String get everyPermission => 'हर अनुमति, बाद में जुड़ने वाली भी';

  @override
  String permissionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count अनुमतियाँ',
    );
    return '$_temp0';
  }

  @override
  String get nobodyInThisRole => 'इस भूमिका में कोई नहीं';

  @override
  String peopleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count लोग',
    );
    return '$_temp0';
  }

  @override
  String get deleteDefaultRolesStay => 'हटाएं (डिफ़ॉल्ट भूमिकाएँ रहती हैं)';

  @override
  String get deleteMovePeopleFirst => 'हटाएं (पहले लोगों को हटाएं)';

  @override
  String get giveRoleAName => 'भूमिका को नाम दें';

  @override
  String get editRole => 'भूमिका बदलें';

  @override
  String get createRole => 'भूमिका बनाएं';

  @override
  String get roleName => 'भूमिका का नाम';

  @override
  String get roleNameHint => 'रिसेप्शन, फिजियो, नाइट शिफ्ट';

  @override
  String get superRoleNote =>
      'इस भूमिका के पास हर अनुमति है, आगे जुड़ने वाली भी। इसे सीमित नहीं किया जा सकता — यही वह भूमिका है जो हमेशा चीज़ें ठीक कर सकती है।';

  @override
  String get whatThisRoleCanDo => 'यह भूमिका क्या कर सकती है';

  @override
  String get greyedOutNote =>
      'जो धुंधला दिख रहा है वह आपके पास नहीं है, इसलिए आप उसे आगे नहीं दे सकते।';

  @override
  String get ownerOnlyPermission => 'यह केवल जिम मालिक के पास रहती है';

  @override
  String get youDoNotHoldThis => 'यह आपके पास नहीं है';

  @override
  String get orderTheHierarchy => 'क्रम तय करें';

  @override
  String get hierarchyNote =>
      'सबसे वरिष्ठ ऊपर। डिफ़ॉल्ट भूमिकाएँ अपनी जगह पर रहती हैं और यहाँ नहीं दिखतीं।';

  @override
  String get saveOrder => 'क्रम सहेजें';

  @override
  String membershipExtendedBy(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'सदस्यता $count महीने बढ़ा दी गई।',
    );
    return '$_temp0';
  }

  @override
  String get goalUpdated => 'लक्ष्य अपडेट हो गया।';

  @override
  String get thisMember => 'यह सदस्य';

  @override
  String get removeMemberQuestion => 'सदस्य हटाएं?';

  @override
  String removeMemberWarning(String name) {
    return '$name की इस जिम तक पहुँच खत्म हो जाएगी। उनका उपस्थिति रिकॉर्ड और माप सुरक्षित रहते हैं।';
  }

  @override
  String get member => 'सदस्य';

  @override
  String get removeMember => 'सदस्य हटाएं';

  @override
  String get daysLeft => 'बचे दिन';

  @override
  String get leaveUsed => 'ली गई छुट्टी';

  @override
  String get extend => 'बढ़ाएं';

  @override
  String get editGoal => 'लक्ष्य बदलें';

  @override
  String get goal => 'लक्ष्य';

  @override
  String get notSet => 'तय नहीं';

  @override
  String get noneAssigned => 'कोई नहीं दिया गया';

  @override
  String get attendanceHistory => 'उपस्थिति इतिहास';

  @override
  String get viewAndCorrectRecords => 'रिकॉर्ड देखें और ठीक करें';

  @override
  String sessionsSoFar(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'अब तक $count सत्र',
    );
    return '$_temp0';
  }

  @override
  String get progressIsPrivate => 'प्रगति निजी है';

  @override
  String get monitoringOffNote =>
      'इस सदस्य ने प्रगति निगरानी बंद कर दी है। यह उनका फैसला है और कोई भी भूमिका इसे नहीं बदल सकती।';

  @override
  String get progress => 'प्रगति';

  @override
  String get noMeasurementsYet =>
      'अभी कोई माप दर्ज नहीं है। सदस्य से यह उनके अपने ऐप में महीने में एक बार पूछा जाता है।';

  @override
  String holdingAtKg(String kg) {
    return '$kg किग्रा पर स्थिर';
  }

  @override
  String weightChangeSince(String delta) {
    return 'पहली माप के बाद से $delta किग्रा';
  }

  @override
  String get extendMembership => 'सदस्यता बढ़ाएं';

  @override
  String get extendFromTodayNote =>
      'समाप्त हो चुकी सदस्यता आज से बढ़ती है, उस तारीख से नहीं जब वह खत्म हुई थी।';

  @override
  String monthsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count महीने',
    );
    return '$_temp0';
  }

  @override
  String extendByMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count महीने बढ़ाएं',
    );
    return '$_temp0';
  }

  @override
  String get whatAreTheyWorkingTowards => 'वे किस लक्ष्य पर काम कर रहे हैं?';

  @override
  String get goalDialogHint => '80 किग्रा तक बल्क, वज़न घटाना, रिहैब…';

  @override
  String signedUpCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ने नाम लिखाया',
    );
    return '$_temp0';
  }

  @override
  String get nobodyYet => 'अभी कोई नहीं।';

  @override
  String get hostAnEvent => 'आयोजन करें';

  @override
  String get noEventsYet =>
      'अभी कोई आयोजन नहीं। एक बनाइए और यह आपके सदस्यों को तुरंत दिखने लगेगा।';

  @override
  String get eventTitleHint => 'समर डेडलिफ्ट मीट';

  @override
  String get howToTakePart => 'भाग कैसे लें';

  @override
  String get howToTakePartHint => 'सुबह 8 बजे वज़न। अपनी बेल्ट लाएं।';

  @override
  String get prizeOptional => 'इनाम (वैकल्पिक)';

  @override
  String get prizeHint => '₹10,000';

  @override
  String get membersCanSignUp => 'सदस्य ऐप में नाम लिखा सकते हैं';

  @override
  String get membersCanSignUpNote =>
      'बंद करने पर उन्हें बटन के बजाय आपकी शर्तें दिखेंगी।';

  @override
  String get listPublicly => 'सार्वजनिक रूप से दिखाएं';

  @override
  String get listPubliclyNote => 'पूरे देश की इवेंट फ़ीड में दिखता है।';

  @override
  String get listPubliclyProOnly =>
      'केवल प्रो प्लान पर। आपके सदस्य फिर भी इसे देखेंगे।';

  @override
  String get openToOutsiders => 'आपके जिम के बाहर के लोगों के लिए भी खुला';

  @override
  String get publishEvent => 'आयोजन प्रकाशित करें';

  @override
  String get registrationOpen => 'पंजीकरण खुला';

  @override
  String get registrationClosed => 'पंजीकरण बंद';

  @override
  String get close => 'बंद करें';

  @override
  String get markAllRead => 'सब पढ़ा हुआ करें';

  @override
  String get nothingYet => 'अभी कुछ नहीं';

  @override
  String get announcementsAppearHere =>
      'आपके जिम और जिमोलॉजिया की घोषणाएँ यहाँ दिखेंगी।';

  @override
  String get searchPeople => 'लोग खोजें';

  @override
  String get nobodyElseHereYet => 'अभी यहाँ और कोई नहीं है।';

  @override
  String get nameTheGroup => 'समूह को नाम दें';

  @override
  String get groupNameHint => 'शनिवार सुबह वाला ग्रुप';

  @override
  String get create => 'बनाएं';

  @override
  String get pickWhoIsInTheGroup => 'चुनें कि समूह में कौन है';

  @override
  String createGroupWith(int count) {
    return '$count के साथ समूह बनाएं';
  }

  @override
  String get termsOfUse => 'उपयोग की शर्तें';

  @override
  String get privacy => 'गोपनीयता';

  @override
  String versionUpdated(String version, String date) {
    return 'संस्करण $version · अपडेट $date';
  }

  @override
  String sessionsAttendedAllTime(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'सत्र, अब तक कुल',
    );
    return '$_temp0';
  }

  @override
  String get nothingInLast60Days => 'पिछले 60 दिनों में कुछ दर्ज नहीं हुआ।';

  @override
  String correctedReason(String reason) {
    return 'सुधारा गया: $reason';
  }

  @override
  String get noReasonGiven => 'कोई कारण नहीं दिया';

  @override
  String get keptWithRecordAuditNote =>
      'यह रिकॉर्ड के साथ रखा जाता है और ऑडिट लॉग में दिखता है।';

  @override
  String get staffBadge => 'स्टाफ';

  @override
  String get draftCrmNote =>
      'आपका जिम ड्राफ्ट है। सीआरएम चलता है, लेकिन प्लान चालू होने तक सदस्य आपको खोज में नहीं पाएंगे।';

  @override
  String roleHiddenNote(String role) {
    return 'यहाँ आप $role हैं। जो आपकी भूमिका नहीं कर सकती, वह दिखाकर मना करने के बजाय छिपा दिया जाता है।';
  }

  @override
  String engagedOfActive(int engaged, int total) {
    return '$total में से $engaged सदस्यों ने कम से कम एक बार कसरत की।';
  }

  @override
  String announceGoesTo(String audience) {
    return 'यह अभी $audience को जाएगा, और वापस नहीं लिया जा सकता।';
  }

  @override
  String get audienceEveryMember => 'हर सदस्य';

  @override
  String get audienceEveryStaff => 'हर स्टाफ सदस्य';

  @override
  String get audienceEveryone => 'इस जिम के सभी लोग';

  @override
  String sentToPeople(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count लोगों को भेजा गया।',
    );
    return '$_temp0';
  }

  @override
  String recipientCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count प्राप्तकर्ता',
    );
    return '$_temp0';
  }

  @override
  String get weTextACodeFirst =>
      'हम पहले उनके नंबर पर एक कोड भेजते हैं, ताकि पक्का हो कि नंबर सच में उन्हीं का है।';

  @override
  String get memberCanUpdateMetrics =>
      'वे सदस्य ऐप में अपना वज़न और लंबाई देख और बदल सकते हैं। जब तक वे खुद बंद न करें, उनकी प्रगति स्टाफ को दिखती है।';

  @override
  String get noRolesYouCanAssign =>
      'आप कोई भूमिका नहीं दे सकते। केवल अपनी भूमिका से नीचे की भूमिकाएँ दी जा सकती हैं।';

  @override
  String get noRolesYouCanAssignToThem => 'आप उन्हें कोई भूमिका नहीं दे सकते।';

  @override
  String heightCm(String cm) {
    return 'लंबाई $cm सेमी';
  }

  @override
  String weightOverCheckIns(String delta, int count) {
    return '$count जाँचों में $delta किग्रा';
  }

  @override
  String get useDeviceLanguage => 'डिवाइस की भाषा का उपयोग करें';

  @override
  String get untranslatedFallbackNote =>
      'जो अभी अनूदित नहीं है वह खाली छोड़ने के बजाय अंग्रेज़ी में दिखता है, ताकि आंशिक रूप से अनूदित भाषा भी काम की रहे।';

  @override
  String deleteGymWarning(int members, int staff) {
    return 'सभी $members सदस्यों और $staff स्टाफ की पहुँच खत्म हो जाएगी। इसे ऐप से वापस नहीं किया जा सकता।';
  }

  @override
  String shownAsInSearch(String name, String district) {
    return 'खोज में “$name - $district” के रूप में दिखेगा।';
  }

  @override
  String get nothingWaitingLeave =>
      'कुछ लंबित नहीं। आपकी सीमा के भीतर के अनुरोध अपने आप मंज़ूर होते हैं और यहाँ कभी नहीं दिखते।';

  @override
  String get quietPeriodsNote =>
      'सुनसान दौर को छोड़ा नहीं जाता, खाली पट्टी के रूप में दिखाया जाता है, ताकि पट्टियों में खाली जगह असली खाली जगह हो।';

  @override
  String get rankingExplainer =>
      'स्थान उसी तरह निकाला जाता है जैसे खोज नतीजे क्रम में लगाती है: पहले रेटिंग, फिर कितनी रेटिंग उसका समर्थन करती हैं। यहाँ जो दिख रहा है, वही सदस्य को भी दिखेगा।';

  @override
  String get deleteTrainerCategoryWarning =>
      'अब इस श्रेणी में ट्रेनर नहीं डाले जा सकेंगे। जो पहले से इसमें हैं, उनका असाइनमेंट बना रहेगा।';

  @override
  String get youLabel => 'आप';

  @override
  String get openEvents => 'खुले आयोजन';

  @override
  String get nothingHereYetSaySomething => 'अभी यहाँ कुछ नहीं। कुछ कहिए।';

  @override
  String get leavePausesMembership =>
      'आपकी अनुपस्थिति में सदस्यता रुक जाती है, इसलिए जिन दिनों का आपने भुगतान किया है वे बचे रहते हैं।';

  @override
  String get notListedUntilPlan =>
      'प्लान चालू होने तक सार्वजनिक रूप से नहीं दिखेगा।';

  @override
  String gymsListedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count जिम सूचीबद्ध',
    );
    return '$_temp0';
  }

  @override
  String get checkInGoalNote =>
      'आपका जिम इसका उपयोग आपके लक्ष्य की ओर प्रगति देखने के लिए करता है।';

  @override
  String get enterYourGymName => 'अपने जिम का नाम लिखें';

  @override
  String get sessionExpiredSignIn =>
      'आपका सत्र समाप्त हो गया। कृपया दोबारा साइन इन करें।';

  @override
  String get somethingWentWrongTryAgain =>
      'कुछ गड़बड़ हो गई। कृपया दोबारा कोशिश करें।';

  @override
  String get serverTookTooLong =>
      'सर्वर ने जवाब देने में बहुत समय लिया। अपना कनेक्शन देखें और दोबारा कोशिश करें।';

  @override
  String couldNotReachServer(String host) {
    return '$host पर सर्वर से संपर्क नहीं हो सका। अपना इंटरनेट कनेक्शन देखें।';
  }

  @override
  String get certificateNotVerified =>
      'सर्वर का प्रमाणपत्र सत्यापित नहीं हो सका।';

  @override
  String get networkErrorTryAgain =>
      'नेटवर्क में गड़बड़ी। कृपया दोबारा कोशिश करें।';

  @override
  String get enterValidMobile => '10 अंकों का सही भारतीय मोबाइल नंबर लिखें';

  @override
  String get enterValidTenDigitNumber => '10 अंकों का सही नंबर लिखें';

  @override
  String get enterYourName => 'अपना नाम लिखें';

  @override
  String get nameTooLong => 'यह नाम बहुत लंबा है';

  @override
  String get enterValidEmail => 'सही ईमेल पता लिखें';

  @override
  String get enterYourAge => 'अपनी उम्र लिखें';

  @override
  String get mustBeAtLeast13 => 'आपकी उम्र कम से कम 13 होनी चाहिए';

  @override
  String get enterValidAge => 'सही उम्र लिखें';

  @override
  String get enterWeightOrHeight => 'वज़न या लंबाई लिखें।';

  @override
  String get noRatingsYet => 'अभी कोई रेटिंग नहीं';

  @override
  String get giveItATitle => 'इसे एक शीर्षक दें।';

  @override
  String get sayWhatYouWantThemToKnow =>
      'बताइए कि आप उन्हें क्या बताना चाहते हैं।';

  @override
  String get sayWhyThisIsChanging => 'बताइए कि यह क्यों बदला जा रहा है।';

  @override
  String get noMembersYetAddFirst => 'अभी कोई सदस्य नहीं। पहला सदस्य जोड़ें।';

  @override
  String get nobodyMatchedSearch => 'उस खोज से कोई नहीं मिला।';

  @override
  String get turningUp => 'आना-जाना';

  @override
  String get justNow => 'अभी अभी';

  @override
  String minutesAgo(int count) {
    return '$count मिनट पहले';
  }

  @override
  String hoursAgo(int count) {
    return '$count घंटे पहले';
  }

  @override
  String daysAgo(int count) {
    return '$count दिन पहले';
  }

  @override
  String monthsAgo(int count) {
    return '$count माह पहले';
  }

  @override
  String get nowShort => 'अभी';

  @override
  String minutesShort(int count) {
    return '$count मि';
  }

  @override
  String hoursShort(int count) {
    return '$count घं';
  }

  @override
  String daysShort(int count) {
    return '$count दि';
  }

  @override
  String weeksShort(int count) {
    return '$count सप्';
  }

  @override
  String addedNamed(String name) {
    return '$name जोड़ा गया';
  }

  @override
  String get saved => 'सहेजा गया';

  @override
  String get trainerCategoriesIntro =>
      'ट्रेनर जोड़ते समय उन्हें इन्हीं में से किसी एक में रखा जाता है। जिस श्रेणी में ट्रेनर हैं, उसे तब तक नहीं हटाया जा सकता जब तक उन्हें कहीं और न ले जाया जाए।';

  @override
  String get trainerCategoriesReadOnly =>
      'आप इस जिम की श्रेणियाँ देख सकते हैं। इन्हें बदलने के लिए ट्रेनर-प्रबंधन की अनुमति चाहिए।';

  @override
  String get oneTrainerManyMembersShort => 'एक ट्रेनर, कई सदस्य';

  @override
  String get oneMemberPerTrainer => 'हर ट्रेनर के लिए एक सदस्य';

  @override
  String get noTrainers => 'कोई ट्रेनर नहीं';

  @override
  String trainerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ट्रेनर',
    );
    return '$_temp0';
  }

  @override
  String get deleteMoveTrainersFirst => 'हटाएं (पहले ट्रेनर हटाएं)';

  @override
  String get giveCategoryAName => 'श्रेणी को नाम दें';

  @override
  String get editCategory => 'श्रेणी बदलें';

  @override
  String get newTrainerCategory => 'नई ट्रेनर श्रेणी';

  @override
  String get generalTrainingNote => 'सामान्य ट्रेनिंग के लिए यही आम सेटिंग है।';

  @override
  String get personalTrainingNote =>
      'पर्सनल ट्रेनिंग: यहाँ का ट्रेनर एक बार में एक ही सदस्य लेता है।';

  @override
  String get addCategory => 'श्रेणी जोड़ें';

  @override
  String get listedPublicly => 'सार्वजनिक रूप से सूचीबद्ध';

  @override
  String get yourMembersOnly => 'केवल आपके सदस्य';

  @override
  String get whenDoesItStart => 'यह कब शुरू होता है?';

  @override
  String get chooseStartDateFirst => 'पहले शुरू होने की तारीख चुनें।';

  @override
  String get lastDayToRegister => 'पंजीकरण की आखिरी तारीख';

  @override
  String get giveTheEventATitle => 'आयोजन को शीर्षक दें।';

  @override
  String get addADescription => 'एक विवरण जोड़ें, कम से कम एक वाक्य।';

  @override
  String get sayHowToTakePart => 'बताइए कि भाग लेने के लिए क्या करना होगा।';

  @override
  String get pickTheDates => 'तारीखें चुनें।';

  @override
  String startsAtWhen(String when) {
    return '$when को शुरू';
  }

  @override
  String registerByWhen(String when) {
    return '$when तक पंजीकरण करें';
  }

  @override
  String get selectYourLeaveDates => 'अपनी छुट्टी की तारीखें चुनें';

  @override
  String get chooseYourDatesFirst => 'पहले अपनी तारीखें चुनें।';

  @override
  String get sentForApproval => 'मंज़ूरी के लिए भेज दिया गया।';

  @override
  String get leaveApprovedPaused =>
      'छुट्टी मंज़ूर। उन दिनों के लिए आपकी सदस्यता रुकी रहेगी।';

  @override
  String get chooseDates => 'तारीखें चुनें';

  @override
  String leaveDaysLeftCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'आपके पास $count छुट्टी के दिन बचे हैं।',
    );
    return '$_temp0';
  }

  @override
  String moreThanRemainingDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'यह आपके बचे $count दिनों से ज़्यादा है, इसलिए इसे मैनेजर को मंज़ूर करना होगा।',
    );
    return '$_temp0';
  }

  @override
  String get withinYourAllowance =>
      'आपकी सीमा के भीतर — यह तुरंत मंज़ूर हो जाएगा।';

  @override
  String get sendForApproval => 'मंज़ूरी के लिए भेजें';

  @override
  String get enterCodeSentToTheirPhone => 'उनके फ़ोन पर भेजा गया कोड लिखें।';

  @override
  String get numberIsNewNameNeeded => 'यह नंबर नया है, इसलिए नाम चाहिए।';

  @override
  String get chooseARole => 'एक भूमिका चुनें।';

  @override
  String get addAMember => 'एक सदस्य जोड़ें';

  @override
  String get codeSentExistingAccount =>
      'कोड भेज दिया। इस नंबर पर पहले से जिमोलॉजिया खाता है।';

  @override
  String get codeSentNewAccount =>
      'कोड भेज दिया। यह नंबर नया है, इसलिए हम एक खाता बनाएंगे।';

  @override
  String get membershipLength => 'सदस्यता की अवधि';

  @override
  String get leaveDaysAllowed => 'मिलने वाली छुट्टी के दिन';

  @override
  String get ownerStaffMode => 'मालिक / स्टाफ मोड';

  @override
  String get memberMode => 'सदस्य मोड';

  @override
  String get managingGymsNote =>
      'आप जिम संभाल रहे हैं। सदस्य के रूप में जिमोलॉजिया इस्तेमाल करने के लिए वापस स्विच करें।';

  @override
  String get openingAGymNote =>
      'जिम खोल रहे हैं, या किसी में काम करते हैं? अपने जिम का सीआरएम चलाने के लिए स्विच करें — सदस्य, स्टाफ, उपस्थिति और छुट्टी।';

  @override
  String get numberIsHowYouSignIn =>
      'आप अपने नंबर से साइन इन करते हैं, इसलिए इसे यहाँ अभी नहीं बदला जा सकता।';

  @override
  String get followingYourDevice => 'आपके डिवाइस के अनुसार';

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
  String get onLeave => 'छुट्टी पर';

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
  String get deleteGym => 'जिम हटाएं';

  @override
  String get gymProfile => 'जिम प्रोफ़ाइल';

  @override
  String get description => 'विवरण';

  @override
  String get leavePolicy => 'छुट्टी नीति';

  @override
  String get leaveDaysPerMonth => 'प्रति माह छुट्टी के दिन';

  @override
  String get deleteThisGym => 'यह जिम हटाएं';

  @override
  String get leaveLimitNote =>
      'इस सीमा के भीतर सदस्यों के अनुरोध अपने आप मंज़ूर हो जाते हैं। इससे ज़्यादा के लिए किसी की मंज़ूरी चाहिए।';

  @override
  String get draftNote =>
      'आपका जिम ड्राफ्ट के रूप में शुरू होता है। सत्यापन पूरा करने और प्लान लेने तक यह खोज में नहीं दिखेगा।';

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
