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
  String get somethingWentWrong => 'काहीतरी चूक झाली';

  @override
  String get phoneNumber => 'मोबाईल नंबर';

  @override
  String get enterPhoneNumber => 'तुमचा मोबाईल नंबर टाका';

  @override
  String get sendCode => 'कोड पाठवा';

  @override
  String get verifyCode => 'पडताळणी करा';

  @override
  String get resendCode => 'पुन्हा पाठवा';

  @override
  String get createAccount => 'तुमचे खाते तयार करा';

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
  String get consentCheckboxLabel =>
      'I have read and agree to the Terms of Use and Privacy Policy.';

  @override
  String get consentRequired =>
      'You must agree to the Terms and Privacy Policy to continue.';

  @override
  String get under18GuardianNotice =>
      'You are under 18. A parent or guardian must verify their consent by OTP before your account can be fully activated. Our support team will contact you after sign-up.';

  @override
  String shareProgressWithGym(String gym) {
    return 'Share my measurements with $gym staff';
  }

  @override
  String get shareProgressWithGymHint =>
      'Your trainer can see your weight and height only while this is on. Off by default — you choose to turn it on.';

  @override
  String get monitoringTurnedOn => 'Staff can now see your progress.';

  @override
  String get monitoringTurnedOff => 'Staff can no longer see your progress.';

  @override
  String get couldNotUpdateSetting => 'Could not update this setting.';

  @override
  String get downloadMyData => 'Download my data';

  @override
  String get downloadMyDataHint =>
      'Everything Gymologia holds about your account, as JSON. Encrypted fields such as identity documents are not included in readable form.';

  @override
  String get copyToClipboard => 'Copy to clipboard';

  @override
  String get yourData => 'Your data';

  @override
  String get theirAge => 'Their age';

  @override
  String get enterAValidAge => 'Enter a valid age.';

  @override
  String get guardianConsentRequired =>
      'A parent or guardian\'s consent is required before this person can be added.';

  @override
  String get guardianConsentExplainer =>
      'This person is under 18. Before adding them, confirm a parent or guardian has verified their consent (by phone, in person, or in writing).';

  @override
  String get guardianConsentCheckboxLabel =>
      'I confirm a parent or guardian has given verified consent.';

  @override
  String get guardianPhoneLabel => 'Parent/guardian\'s mobile number';

  @override
  String get guardianCodeLabel => 'Code from guardian\'s phone';

  @override
  String get guardianVerifiedConfirmation => 'Guardian consent verified.';

  @override
  String get guardianConsentBlocksSubmit =>
      'Verify your guardian\'s consent above before creating the account.';

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
  String get supportSent => 'पाठवले. तुम्ही दिलेल्या नंबरवर उत्तर येईल.';

  @override
  String get supportSubject => 'हे कशाबद्दल आहे?';

  @override
  String get supportSubjectHint => 'माझ्या सदस्यत्वाचे दिवस चुकीचे दिसत आहेत';

  @override
  String get supportMessage => 'काय झाले ते सांगा';

  @override
  String get supportReplyTo => 'आम्ही कुठे उत्तर देऊ?';

  @override
  String get supportUrgent => 'यामुळे माझे जिम चालत नाही';

  @override
  String get supportUrgentNote => 'प्राधान्य वाढवते.';

  @override
  String copiedToClipboard(String value) {
    return '$value कॉपी झाले';
  }

  @override
  String orEmailUs(String email) {
    return 'किंवा $email वर ईमेल करा';
  }

  @override
  String get whatYouHaveAsked => 'तुम्ही काय विचारले आहे';

  @override
  String get aFewWordsIsEnough => 'काही शब्द पुरेसे आहेत';

  @override
  String get aSentenceOrTwoHelps => 'एक-दोन वाक्ये लिहिल्यास लवकर सुटेल';

  @override
  String get ticketOpen => 'कोणीतरी हाती घेण्याची वाट पाहत आहे';

  @override
  String get ticketInProgress => 'कोणीतरी हे पाहत आहे';

  @override
  String get ticketWaitingOnUser => 'तुमच्या उत्तराची वाट पाहत आहे';

  @override
  String get ticketResolved => 'सोडवले';

  @override
  String get ticketClosed => 'बंद';

  @override
  String get referralPitch =>
      'कोड शेअर करा आणि एखाद्या जिम मालकाने सदस्यत्व घेतल्यावर कमवा. रेफरल अ‍ॅप अजून आलेले नाही.';

  @override
  String get appTagline => 'जिमोलॉजिया · सदस्य आणि कर्मचारी';

  @override
  String get signOutQuestion => 'साइन आउट करायचे?';

  @override
  String get signOutWarning => 'पुन्हा साइन इन करण्यासाठी तुमचा फोन लागेल.';

  @override
  String get profileUpdated => 'प्रोफाइल अपडेट झाली.';

  @override
  String get yourProfile => 'तुमची प्रोफाइल';

  @override
  String get emailClearToRemove => 'ऐच्छिक. काढण्यासाठी रिकामे करा.';

  @override
  String get phoneIsYourLogin =>
      'याच्यानेच तुम्ही साइन इन करता, म्हणून ते इथे आत्ता बदलता येत नाही. बदलायचे असल्यास सहाय्याशी संपर्क करा.';

  @override
  String get trialStarted => 'ट्रायल सुरू झाले. तुमचे जिम आता शोधात दिसते.';

  @override
  String get invalidCode => 'कोड वैध नाही.';

  @override
  String get paymentNotCompletedYet =>
      'पेमेंट अजून पूर्ण झालेले नाही. थोड्या वेळाने खेचून रिफ्रेश करा.';

  @override
  String planIsActive(String plan) {
    return '$plan प्लॅन सुरू आहे.';
  }

  @override
  String get paymentNotCompleted => 'पेमेंट पूर्ण झाले नाही.';

  @override
  String get couldNotOpenPayment => 'पेमेंट स्क्रीन उघडता आली नाही.';

  @override
  String daysFree(int days) {
    return '$days दिवस मोफत';
  }

  @override
  String get trialBlurb =>
      'पूर्ण प्रो, सदस्य शोधातील तुमच्या नोंदीसह. कार्डाची गरज नाही, आणि ते आपोआप सशुल्क प्लॅनमध्ये बदलत नाही.';

  @override
  String get startFreeTrial => 'मोफत ट्रायल सुरू करा';

  @override
  String get referralCode => 'रेफरल कोड';

  @override
  String get optional => 'ऐच्छिक';

  @override
  String get apply => 'लागू करा';

  @override
  String get gstNote =>
      'किमतींमध्ये जीएसटी समाविष्ट आहे. जिम फक्त प्रो प्लॅनवरच सदस्य शोधात दिसते.';

  @override
  String planNamed(String plan) {
    return '$plan प्लॅन';
  }

  @override
  String get trialBadge => 'ट्रायल';

  @override
  String get expired => 'मुदत संपली';

  @override
  String daysRemainingPlan(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दिवस शिल्लक',
    );
    return '$_temp0';
  }

  @override
  String get listedInSearch => 'सदस्य शोधात नोंदवलेले';

  @override
  String get notListedUpgrade => 'शोधात नाही — दिसण्यासाठी प्रो घ्या';

  @override
  String get trialEndsNote =>
      'ट्रायल संपल्यावर तुम्ही प्लॅन निवडेपर्यंत तुमचे जिम शोधातून बाहेर पडते. आपोआप काहीही आकारले जात नाही.';

  @override
  String get getsYouListed => 'शोधात दाखवते';

  @override
  String get perMonth => '/महिना';

  @override
  String choosePlanNamed(String plan) {
    return '$plan निवडा';
  }

  @override
  String get deleteRoleWarning =>
      'भूमिका आणि तिच्या परवानग्या जातील. यात कोणी नाही, त्यामुळे कोणाचाही प्रवेश जाणार नाही.';

  @override
  String deletedNamed(String name) {
    return '$name काढून टाकले';
  }

  @override
  String get needTwoCustomRoles =>
      'क्रम बदलण्याआधी तुम्हाला संपादित करता येतील अशा दोन कस्टम भूमिका हव्यात.';

  @override
  String get hierarchySaved => 'उतरंड जतन केली';

  @override
  String get reorder => 'क्रम बदला';

  @override
  String get newRole => 'नवी भूमिका';

  @override
  String get rolesIntro =>
      'सर्वात वरिष्ठ आधी. तुम्ही फक्त तुमच्या खालच्या भूमिका बदलू शकता, आणि फक्त तुमच्याकडे असलेल्या परवानग्या देऊ शकता.';

  @override
  String get defaultBadge => 'डीफॉल्ट';

  @override
  String get everyPermission => 'प्रत्येक परवानगी, नंतर जोडल्या जाणाऱ्यांसह';

  @override
  String permissionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count परवानग्या',
    );
    return '$_temp0';
  }

  @override
  String get nobodyInThisRole => 'या भूमिकेत कोणी नाही';

  @override
  String peopleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count जण',
    );
    return '$_temp0';
  }

  @override
  String get deleteDefaultRolesStay => 'काढा (डीफॉल्ट भूमिका राहतात)';

  @override
  String get deleteMovePeopleFirst => 'काढा (आधी लोकांना हलवा)';

  @override
  String get giveRoleAName => 'भूमिकेला नाव द्या';

  @override
  String get editRole => 'भूमिका संपादित करा';

  @override
  String get createRole => 'भूमिका तयार करा';

  @override
  String get roleName => 'भूमिकेचे नाव';

  @override
  String get roleNameHint => 'रिसेप्शन, फिजिओ, नाइट शिफ्ट';

  @override
  String get superRoleNote =>
      'या भूमिकेकडे प्रत्येक परवानगी आहे, पुढे जोडल्या जाणाऱ्यांसह. ती मर्यादित करता येत नाही — म्हणूनच ती नेहमी गोष्टी दुरुस्त करू शकते.';

  @override
  String get whatThisRoleCanDo => 'ही भूमिका काय करू शकते';

  @override
  String get greyedOutNote =>
      'जे धूसर दिसते ते तुमच्याकडे नाही, त्यामुळे तुम्ही ते देऊ शकत नाही.';

  @override
  String get ownerOnlyPermission => 'हे फक्त जिम मालकाकडेच असते';

  @override
  String get youDoNotHoldThis => 'हे तुमच्याकडे नाही';

  @override
  String get orderTheHierarchy => 'उतरंड ठरवा';

  @override
  String get hierarchyNote =>
      'सर्वात वरिष्ठ वर. डीफॉल्ट भूमिका आपल्या जागी राहतात आणि इथे दिसत नाहीत.';

  @override
  String get saveOrder => 'क्रम जतन करा';

  @override
  String membershipExtendedBy(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'सदस्यत्व $count महिने वाढवले.',
    );
    return '$_temp0';
  }

  @override
  String get goalUpdated => 'ध्येय अपडेट झाले.';

  @override
  String get thisMember => 'हा सदस्य';

  @override
  String get removeMemberQuestion => 'सदस्य काढायचा?';

  @override
  String removeMemberWarning(String name) {
    return '$name यांना या जिमचा प्रवेश राहणार नाही. त्यांची हजेरी नोंद आणि मापे ठेवली जातात.';
  }

  @override
  String get member => 'सदस्य';

  @override
  String get removeMember => 'सदस्य काढा';

  @override
  String get daysLeft => 'उरलेले दिवस';

  @override
  String get leaveUsed => 'घेतलेली रजा';

  @override
  String get extend => 'वाढवा';

  @override
  String get editGoal => 'ध्येय बदला';

  @override
  String get goal => 'ध्येय';

  @override
  String get notSet => 'ठरवलेले नाही';

  @override
  String get noneAssigned => 'कोणीही नेमलेले नाही';

  @override
  String get attendanceHistory => 'हजेरी इतिहास';

  @override
  String get viewAndCorrectRecords => 'नोंदी पहा आणि दुरुस्त करा';

  @override
  String sessionsSoFar(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'आतापर्यंत $count सत्रे',
    );
    return '$_temp0';
  }

  @override
  String get progressIsPrivate => 'प्रगती खाजगी आहे';

  @override
  String get monitoringOffNote =>
      'या सदस्याने प्रगती देखरेख बंद केली आहे. हा त्यांचा निर्णय आहे आणि कोणतीही भूमिका तो बदलू शकत नाही.';

  @override
  String get progress => 'प्रगती';

  @override
  String get noMeasurementsYet =>
      'अजून कोणतीही मापे नोंदवलेली नाहीत. सदस्याला त्यांच्या अ‍ॅपमध्ये महिन्यातून एकदा विचारले जाते.';

  @override
  String holdingAtKg(String kg) {
    return '$kg किलोवर स्थिर';
  }

  @override
  String weightChangeSince(String delta) {
    return 'पहिल्या मापानंतर $delta किलो';
  }

  @override
  String get extendMembership => 'सदस्यत्व वाढवा';

  @override
  String get extendFromTodayNote =>
      'मुदत संपलेले सदस्यत्व आजपासून वाढते, ते संपलेल्या तारखेपासून नाही.';

  @override
  String monthsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count महिने',
    );
    return '$_temp0';
  }

  @override
  String extendByMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count महिने वाढवा',
    );
    return '$_temp0';
  }

  @override
  String get whatAreTheyWorkingTowards => 'ते कोणत्या ध्येयावर काम करत आहेत?';

  @override
  String get goalDialogHint => '80 किलोपर्यंत बल्क, वजन कमी, रिहॅब…';

  @override
  String signedUpCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count जणांनी नाव नोंदवले',
    );
    return '$_temp0';
  }

  @override
  String get nobodyYet => 'अजून कोणी नाही.';

  @override
  String get hostAnEvent => 'कार्यक्रम आयोजित करा';

  @override
  String get noEventsYet =>
      'अजून कार्यक्रम नाहीत. एक आयोजित करा, तो तुमच्या सदस्यांना लगेच दिसेल.';

  @override
  String get editEvent => 'इव्हेंट संपादित करा';

  @override
  String get cancelEvent => 'इव्हेंट रद्द करा';

  @override
  String get cancelEventConfirmTitle => 'हा इव्हेंट रद्द करायचा आहे का?';

  @override
  String get cancelEventConfirmBody =>
      'हे इव्हेंट कायमचे हटवेल, नोंदणी केलेल्यांच्या यादीसह. हे परत घेता येणार नाही.';

  @override
  String get keepEvent => 'इव्हेंट ठेवा';

  @override
  String get eventUpdated => 'इव्हेंट अपडेट झाला';

  @override
  String get eventCancelledSnackbar => 'इव्हेंट हटवला';

  @override
  String get eventTitleHint => 'समर डेडलिफ्ट मीट';

  @override
  String get howToTakePart => 'सहभाग कसा घ्यायचा';

  @override
  String get howToTakePartHint => 'सकाळी 8 वाजता वजन. स्वतःचा बेल्ट आणा.';

  @override
  String get prizeOptional => 'बक्षीस (ऐच्छिक)';

  @override
  String get prizeHint => '₹10,000';

  @override
  String get membersCanSignUp => 'सदस्य अ‍ॅपमध्ये नाव नोंदवू शकतात';

  @override
  String get membersCanSignUpNote =>
      'बंद केल्यास त्यांना बटणाऐवजी तुमच्या अटी दिसतील.';

  @override
  String get listPublicly => 'सार्वजनिक करा';

  @override
  String get listPubliclyNote => 'देशभरातील कार्यक्रम फीडमध्ये दिसते.';

  @override
  String get listPubliclyProOnly =>
      'फक्त प्रो प्लॅनवर. तुमचे सदस्य तरीही ते पाहतील.';

  @override
  String get openToOutsiders => 'तुमच्या जिमबाहेरील लोकांसाठीही खुले';

  @override
  String get publishEvent => 'कार्यक्रम प्रकाशित करा';

  @override
  String get registrationOpen => 'नोंदणी सुरू';

  @override
  String get registrationClosed => 'नोंदणी बंद';

  @override
  String get close => 'बंद करा';

  @override
  String get markAllRead => 'सर्व वाचलेले म्हणून खुणा करा';

  @override
  String get nothingYet => 'अजून काही नाही';

  @override
  String get announcementsAppearHere =>
      'तुमच्या जिमकडून आणि जिमोलॉजियाकडून घोषणा इथे दिसतील.';

  @override
  String get searchPeople => 'लोक शोधा';

  @override
  String get nobodyElseHereYet => 'इथे अजून दुसरे कोणी नाही.';

  @override
  String get nameTheGroup => 'गटाला नाव द्या';

  @override
  String get groupNameHint => 'शनिवार सकाळचा गट';

  @override
  String get create => 'तयार करा';

  @override
  String get pickWhoIsInTheGroup => 'गटात कोण असेल ते निवडा';

  @override
  String createGroupWith(int count) {
    return '$count जणांसह गट तयार करा';
  }

  @override
  String get termsOfUse => 'वापराच्या अटी';

  @override
  String get privacy => 'गोपनीयता';

  @override
  String versionUpdated(String version, String date) {
    return 'आवृत्ती $version · अपडेट $date';
  }

  @override
  String sessionsAttendedAllTime(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'सत्रे, एकूण',
    );
    return '$_temp0';
  }

  @override
  String get nothingInLast60Days =>
      'गेल्या 60 दिवसांत काहीही नोंदवले गेले नाही.';

  @override
  String correctedReason(String reason) {
    return 'दुरुस्त केले: $reason';
  }

  @override
  String get noReasonGiven => 'कारण दिलेले नाही';

  @override
  String get keptWithRecordAuditNote =>
      'हे नोंदीसोबत ठेवले जाते आणि ऑडिट लॉगमध्ये दिसते.';

  @override
  String get staffBadge => 'कर्मचारी';

  @override
  String roleHiddenNote(String role) {
    return 'इथे तुम्ही $role आहात. तुमची भूमिका जे करू शकत नाही ते दाखवून नाकारण्याऐवजी लपवले जाते.';
  }

  @override
  String engagedOfActive(int engaged, int total) {
    return '$total पैकी $engaged सदस्यांनी किमान एकदा सराव केला.';
  }

  @override
  String announceGoesTo(String audience) {
    return 'हे आत्ताच $audience जाईल, आणि परत घेता येणार नाही.';
  }

  @override
  String get audienceEveryMember => 'प्रत्येक सदस्य';

  @override
  String get audienceEveryStaff => 'प्रत्येक कर्मचारी';

  @override
  String get audienceEveryone => 'या जिममधील सर्वजण';

  @override
  String sentToPeople(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count जणांना पाठवले.',
    );
    return '$_temp0';
  }

  @override
  String recipientCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count प्राप्तकर्ते',
    );
    return '$_temp0';
  }

  @override
  String get weTextACodeFirst =>
      'आम्ही आधी त्यांच्या नंबरवर कोड पाठवतो, म्हणजे तो खरोखर त्यांचाच आहे हे कळते.';

  @override
  String get memberCanUpdateMetrics =>
      'ते सदस्य अ‍ॅपमध्ये आपले वजन आणि उंची पाहू आणि बदलू शकतात. त्यांनी स्वतः बंद केल्याशिवाय त्यांची प्रगती कर्मचाऱ्यांना दिसते.';

  @override
  String get noRolesYouCanAssign =>
      'तुम्ही देऊ शकाल अशा भूमिका नाहीत. फक्त तुमच्या खालच्या भूमिका देता येतात.';

  @override
  String get noRolesYouCanAssignToThem =>
      'तुम्ही त्यांना देऊ शकाल अशा भूमिका नाहीत.';

  @override
  String heightCm(String cm) {
    return 'उंची $cm सेमी';
  }

  @override
  String weightOverCheckIns(String delta, int count) {
    return '$count तपासण्यांत $delta किलो';
  }

  @override
  String get useDeviceLanguage => 'डिव्हाइसची भाषा वापरा';

  @override
  String get untranslatedFallbackNote =>
      'जे अजून भाषांतरित नाही ते रिकामे ठेवण्याऐवजी इंग्रजीत दाखवले जाते, त्यामुळे अंशतः भाषांतरित भाषाही वापरता येते.';

  @override
  String deleteGymWarning(int members, int staff) {
    return 'सर्व $members सदस्य आणि $staff कर्मचारी प्रवेश गमावतील. हे अ‍ॅपमधून पूर्ववत करता येत नाही.';
  }

  @override
  String shownAsInSearch(String name, String district) {
    return 'शोधात “$name - $district” असे दिसेल.';
  }

  @override
  String get nothingWaitingLeave =>
      'काहीही प्रलंबित नाही. तुमच्या मर्यादेतील विनंत्या आपोआप मंजूर होतात आणि इथे कधीच दिसत नाहीत.';

  @override
  String get quietPeriodsNote =>
      'शांत काळ वगळले जात नाहीत, रिकाम्या पट्ट्या म्हणून दाखवले जातात, त्यामुळे पट्ट्यांतील फट खरी फट असते.';

  @override
  String get rankingExplainer =>
      'शोध निकाल ज्या पद्धतीने क्रमवारीत लावतो, त्याच पद्धतीने स्थान ठरते: आधी रेटिंग, मग किती रेटिंग त्याला आधार देतात. इथे जे दिसते तेच सदस्यालाही दिसते.';

  @override
  String get deleteTrainerCategoryWarning =>
      'यापुढे या श्रेणीत प्रशिक्षक ठेवता येणार नाहीत. आधीच असलेल्यांची नेमणूक कायम राहते.';

  @override
  String get youLabel => 'तुम्ही';

  @override
  String get openEvents => 'खुले कार्यक्रम';

  @override
  String get nothingHereYetSaySomething => 'इथे अजून काही नाही. काहीतरी बोला.';

  @override
  String get leavePausesMembership =>
      'तुम्ही नसताना सदस्यत्व थांबते, त्यामुळे तुम्ही पैसे भरलेले दिवस शिल्लक राहतात.';

  @override
  String get notListedUntilPlan =>
      'प्लॅन सुरू होईपर्यंत सार्वजनिकपणे दिसणार नाही.';

  @override
  String gymsListedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count जिम नोंदवलेली',
    );
    return '$_temp0';
  }

  @override
  String get checkInGoalNote =>
      'तुमच्या ध्येयाकडील प्रगती पाहण्यासाठी तुमचे जिम याचा वापर करते.';

  @override
  String get enterYourGymName => 'तुमच्या जिमचे नाव लिहा';

  @override
  String get sessionExpiredSignIn =>
      'तुमचे सत्र संपले. कृपया पुन्हा साइन इन करा.';

  @override
  String get somethingWentWrongTryAgain =>
      'काहीतरी चुकले. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get serverTookTooLong =>
      'सर्व्हरने उत्तर द्यायला खूप वेळ घेतला. तुमचे कनेक्शन तपासून पुन्हा प्रयत्न करा.';

  @override
  String get couldNotReachServer =>
      'सर्व्हरशी संपर्क होऊ शकला नाही. तुमचे इंटरनेट कनेक्शन तपासा.';

  @override
  String get certificateNotVerified => 'सर्व्हरचे प्रमाणपत्र पडताळता आले नाही.';

  @override
  String get networkErrorTryAgain =>
      'नेटवर्क त्रुटी. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get enterValidMobile => '10 अंकी योग्य भारतीय मोबाइल नंबर लिहा';

  @override
  String get enterValidTenDigitNumber => '10 अंकी योग्य नंबर लिहा';

  @override
  String get enterYourName => 'तुमचे नाव लिहा';

  @override
  String get nameTooLong => 'हे नाव खूप लांब आहे';

  @override
  String get enterValidEmail => 'योग्य ईमेल पत्ता लिहा';

  @override
  String get enterYourAge => 'तुमचे वय लिहा';

  @override
  String get mustBeAtLeast13 => 'तुमचे वय किमान 13 असावे';

  @override
  String get enterValidAge => 'योग्य वय लिहा';

  @override
  String get enterWeightOrHeight => 'वजन किंवा उंची लिहा.';

  @override
  String get noRatingsYet => 'अजून कोणतेही रेटिंग नाही';

  @override
  String get giveItATitle => 'याला शीर्षक द्या.';

  @override
  String get sayWhatYouWantThemToKnow => 'त्यांना काय सांगायचे आहे ते लिहा.';

  @override
  String get sayWhyThisIsChanging => 'हे का बदलले जात आहे ते लिहा.';

  @override
  String get noMembersYetAddFirst => 'अजून सदस्य नाहीत. पहिला सदस्य जोडा.';

  @override
  String get nobodyMatchedSearch => 'त्या शोधाशी कोणीही जुळले नाही.';

  @override
  String get turningUp => 'उपस्थिती';

  @override
  String get justNow => 'आत्ताच';

  @override
  String minutesAgo(int count) {
    return '$count मिनिटांपूर्वी';
  }

  @override
  String hoursAgo(int count) {
    return '$count तासांपूर्वी';
  }

  @override
  String daysAgo(int count) {
    return '$count दिवसांपूर्वी';
  }

  @override
  String monthsAgo(int count) {
    return '$count महिन्यांपूर्वी';
  }

  @override
  String get nowShort => 'आत्ता';

  @override
  String minutesShort(int count) {
    return '$count मि';
  }

  @override
  String hoursShort(int count) {
    return '$count ता';
  }

  @override
  String daysShort(int count) {
    return '$count दि';
  }

  @override
  String weeksShort(int count) {
    return '$count आ';
  }

  @override
  String addedNamed(String name) {
    return '$name जोडले';
  }

  @override
  String get saved => 'जतन केले';

  @override
  String get trainerCategoriesIntro =>
      'प्रशिक्षक जोडताना त्यांना यापैकी एका श्रेणीत ठेवले जाते. ज्या श्रेणीत प्रशिक्षक आहेत ती त्यांना हलवेपर्यंत काढता येत नाही.';

  @override
  String get trainerCategoriesReadOnly =>
      'तुम्ही या जिमच्या श्रेणी पाहू शकता. त्या बदलण्यासाठी प्रशिक्षक-व्यवस्थापनाची परवानगी लागते.';

  @override
  String get oneTrainerManyMembersShort => 'एक प्रशिक्षक, अनेक सदस्य';

  @override
  String get oneMemberPerTrainer => 'प्रत्येक प्रशिक्षकाला एक सदस्य';

  @override
  String get noTrainers => 'प्रशिक्षक नाहीत';

  @override
  String trainerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count प्रशिक्षक',
    );
    return '$_temp0';
  }

  @override
  String get deleteMoveTrainersFirst => 'काढा (आधी प्रशिक्षक हलवा)';

  @override
  String get giveCategoryAName => 'श्रेणीला नाव द्या';

  @override
  String get editCategory => 'श्रेणी संपादित करा';

  @override
  String get newTrainerCategory => 'नवी प्रशिक्षक श्रेणी';

  @override
  String get generalTrainingNote =>
      'सामान्य प्रशिक्षणासाठी हीच नेहमीची सेटिंग.';

  @override
  String get personalTrainingNote =>
      'वैयक्तिक प्रशिक्षण: इथला प्रशिक्षक एका वेळी एकच सदस्य घेतो.';

  @override
  String get addCategory => 'श्रेणी जोडा';

  @override
  String get listedPublicly => 'सार्वजनिकपणे नोंदवलेले';

  @override
  String get yourMembersOnly => 'फक्त तुमचे सदस्य';

  @override
  String get whenDoesItStart => 'हे कधी सुरू होते?';

  @override
  String get chooseStartDateFirst => 'आधी सुरुवातीची तारीख निवडा.';

  @override
  String get lastDayToRegister => 'नोंदणीचा शेवटचा दिवस';

  @override
  String get giveTheEventATitle => 'कार्यक्रमाला शीर्षक द्या.';

  @override
  String get addADescription => 'एक वर्णन जोडा, किमान एक वाक्य.';

  @override
  String get sayHowToTakePart => 'सहभागी होण्यासाठी काय करावे लागेल ते लिहा.';

  @override
  String get pickTheDates => 'तारखा निवडा.';

  @override
  String startsAtWhen(String when) {
    return '$when सुरू';
  }

  @override
  String registerByWhen(String when) {
    return '$when पर्यंत नोंदणी करा';
  }

  @override
  String get selectYourLeaveDates => 'तुमच्या रजेच्या तारखा निवडा';

  @override
  String get chooseYourDatesFirst => 'आधी तुमच्या तारखा निवडा.';

  @override
  String get sentForApproval => 'मंजुरीसाठी पाठवले.';

  @override
  String get leaveApprovedPaused =>
      'रजा मंजूर. त्या दिवसांसाठी तुमचे सदस्यत्व थांबेल.';

  @override
  String get chooseDates => 'तारखा निवडा';

  @override
  String leaveDaysLeftCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'तुमच्याकडे $count रजेचे दिवस शिल्लक आहेत.',
    );
    return '$_temp0';
  }

  @override
  String moreThanRemainingDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'हे तुमच्या उरलेल्या $count दिवसांपेक्षा जास्त आहे, त्यामुळे व्यवस्थापकाला मंजूर करावे लागेल.',
    );
    return '$_temp0';
  }

  @override
  String get withinYourAllowance => 'तुमच्या मर्यादेत — हे लगेच मंजूर होईल.';

  @override
  String get sendForApproval => 'मंजुरीसाठी पाठवा';

  @override
  String get enterCodeSentToTheirPhone => 'त्यांच्या फोनवर पाठवलेला कोड लिहा.';

  @override
  String get numberIsNewNameNeeded => 'हा नंबर नवा आहे, त्यामुळे नाव हवे.';

  @override
  String get chooseARole => 'एक भूमिका निवडा.';

  @override
  String get isATrainer => 'Is a trainer?';

  @override
  String get chooseATrainerCategory => 'Choose a trainer category.';

  @override
  String get trainerCategory => 'Trainer category';

  @override
  String get addAMember => 'एक सदस्य जोडा';

  @override
  String get codeSentExistingAccount =>
      'कोड पाठवला. या नंबरवर आधीच जिमोलॉजिया खाते आहे.';

  @override
  String get codeSentNewAccount =>
      'कोड पाठवला. हा नंबर नवा आहे, त्यामुळे आम्ही खाते तयार करू.';

  @override
  String get membershipLength => 'सदस्यत्वाचा कालावधी';

  @override
  String get leaveDaysAllowed => 'मिळणारे रजेचे दिवस';

  @override
  String get ownerStaffMode => 'मालक / कर्मचारी मोड';

  @override
  String get memberMode => 'सदस्य मोड';

  @override
  String get managingGymsNote =>
      'तुम्ही जिम सांभाळत आहात. सदस्य म्हणून जिमोलॉजिया वापरण्यासाठी परत जा.';

  @override
  String get openingAGymNote =>
      'जिम सुरू करत आहात, की एखाद्यात काम करता? तुमच्या जिमचे CRM चालवण्यासाठी स्विच करा — सदस्य, कर्मचारी, हजेरी आणि रजा.';

  @override
  String get numberIsHowYouSignIn =>
      'तुम्ही तुमच्या नंबरनेच साइन इन करता, म्हणून तो इथे आत्ता बदलता येत नाही.';

  @override
  String get followingYourDevice => 'तुमच्या डिव्हाइसनुसार';

  @override
  String get yourGym => 'तुमचे जिम';

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
  String noVisitsInLastDays(int days) {
    return 'गेल्या $days दिवसांत कोणतीही भेट नोंदवली गेली नाही.';
  }

  @override
  String visitsInLastDays(int count, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'गेल्या $days दिवसांत $count भेटी.',
    );
    return '$_temp0';
  }

  @override
  String get couldNotLoadEvents => 'कार्यक्रम लोड होऊ शकले नाहीत';

  @override
  String get noEventsOnRightNow => 'आत्ता कोणताही कार्यक्रम नाही';

  @override
  String get eventsAppearHere =>
      'तुमच्या जिमचे कार्यक्रम इथे दिसतात, सोबत जवळपासचे सर्वांसाठी खुले कार्यक्रमही.';

  @override
  String get atYourGym => 'तुमच्या जिममध्ये';

  @override
  String trainerStaffMembersAt(String gym) {
    return '$gym मधील तुमचे प्रशिक्षक, कर्मचारी आणि सदस्य';
  }

  @override
  String get trainerStaffOtherMembers =>
      'तुमचे प्रशिक्षक, कर्मचारी आणि इतर सदस्य';

  @override
  String get comingNext => 'पुढे येत आहे';

  @override
  String get progressChartsAgainstGoal =>
      'तुमच्या ध्येयाच्या तुलनेत प्रगती तक्ते';

  @override
  String get leaveLeft => 'उरलेली रजा';

  @override
  String approvedMembershipPauses(String name) {
    return '$name मंजूर. त्या दिवसांसाठी त्यांचे सदस्यत्व थांबेल.';
  }

  @override
  String get approveInstead => 'त्याऐवजी मंजूर करा';

  @override
  String get declineInstead => 'त्याऐवजी नाकारा';

  @override
  String get needsYou => 'तुमची गरज आहे';

  @override
  String get autoApproved => 'आपोआप मंजूर';

  @override
  String get returnedEarly => 'लवकर परतले';

  @override
  String get whereYouAre => 'तुम्ही कुठे आहात';

  @override
  String get enterTheAddress => 'पत्ता लिहा';

  @override
  String get maximumPerMembership => 'प्रति सदस्यत्व कमाल';

  @override
  String removeStaffWithAssigned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'त्यांचा या जिमचा प्रवेश जाईल, आणि त्यांना नेमून दिलेल्या $count सदस्यांना तुम्ही दुसऱ्याला नेमेपर्यंत प्रशिक्षक नसेल.',
    );
    return '$_temp0';
  }

  @override
  String get removeStaffPlain =>
      'त्यांचा या जिमचा प्रवेश जाईल. त्यांची हजेरी नोंद ठेवली जाते.';

  @override
  String get couldNotLoadGyms => 'जिम लोड होऊ शकली नाहीत';

  @override
  String get noGymsListedYet => 'अजून कोणतेही जिम नोंदवलेले नाही';

  @override
  String get gymsAppearOnPro =>
      'जिम प्रो प्लॅनवर असल्यास आणि नोंदवले जाणे निवडल्यास इथे दिसतात.';

  @override
  String nothingMatchedTry(String query) {
    return '“$query” शी काहीही जुळले नाही. दुसरे शहर किंवा जिल्हा वापरून पहा.';
  }

  @override
  String get noRatings => 'रेटिंग नाही';

  @override
  String get noPerksYet => 'अजून कोणतेही फायदे सूचीबद्ध नाहीत';

  @override
  String fromRatings(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count रेटिंगमधून',
    );
    return '$_temp0';
  }

  @override
  String get onlyProGymHere => 'इथले एकमेव प्रो जिम';

  @override
  String ofProGyms(int count) {
    return '$count प्रो जिमपैकी';
  }

  @override
  String get couldNotLoadYourGyms => 'तुमची जिम लोड होऊ शकली नाहीत';

  @override
  String get noGymsYet => 'अजून कोणतेही जिम नाही';

  @override
  String get createYourGymBlurb =>
      'सदस्य, कर्मचारी, हजेरी आणि रजा सेट करण्यासाठी तुमचे जिम तयार करा. तुम्ही एखाद्या जिममध्ये काम करत असाल तर मालकाला जोडायला सांगा, ते इथे दिसेल.';

  @override
  String newGroupSelected(int count) {
    return 'नवा गट ($count निवडले)';
  }

  @override
  String get newMessage => 'नवा संदेश';

  @override
  String get oneToOne => 'एकास एक';

  @override
  String get group => 'गट';

  @override
  String get buildMuscle => 'स्नायू वाढवा';

  @override
  String get loseFat => 'चरबी कमी करा';

  @override
  String get getStronger => 'ताकद वाढवा';

  @override
  String get officialGroupEmpty => 'या जिममधील सर्वजण. अजून काही बोललेले नाही.';

  @override
  String get unofficialGroupEmpty => 'फक्त सदस्य. अजून काही बोललेले नाही.';

  @override
  String get noMessagesYet => 'अजून कोणताही संदेश नाही';

  @override
  String get approved => 'मंजूर';

  @override
  String get declined => 'नाकारले';

  @override
  String get cancelled => 'रद्द';

  @override
  String get flexibility => 'लवचिकता';

  @override
  String get rehab => 'रिहॅब';

  @override
  String get youPrefix => 'तुम्ही: ';

  @override
  String get active => 'सक्रिय';

  @override
  String get joined => 'सामील झाले';

  @override
  String get leftCount => 'सोडले';

  @override
  String get net => 'निव्वळ';

  @override
  String get daily => 'दैनिक';

  @override
  String get monthly => 'मासिक';

  @override
  String get yearly => 'वार्षिक';

  @override
  String get add => 'जोडा';

  @override
  String get update => 'अपडेट करा';

  @override
  String get required => 'आवश्यक';

  @override
  String get contact => 'संपर्क';

  @override
  String get owner => 'मालक';

  @override
  String get support => 'सहाय्य';

  @override
  String get machineTranslatedExercise =>
      'या सूचना यंत्राने भाषांतरित केल्या आहेत आणि कोणत्याही प्रशिक्षकाने त्या तपासलेल्या नाहीत. काही विचित्र वाटल्यास वजन उचलण्याआधी इंग्रजीत बदलून पडताळा.';

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
  String get findAGym => 'जिम शोधा';

  @override
  String get searchGyms => 'नाव किंवा परिसरानुसार शोधा';

  @override
  String get perks => 'सुविधा';

  @override
  String get rating => 'रेटिंग';

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
  String get checkInDue => 'या महिन्याची नोंद बाकी आहे';

  @override
  String get thisMonth => 'या महिन्यात';

  @override
  String get perWeek => 'दर आठवड्याला';

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
  String get useMyLocation => 'जवळचे जिम शोधण्यासाठी माझे स्थान वापरा';

  @override
  String get findingNearbyGyms => 'तुमच्या जवळचे जिम शोधले जात आहेत…';

  @override
  String get locationUnavailable =>
      'तुमचे स्थान मिळू शकले नाही — सर्व जिम दाखवले जात आहेत';

  @override
  String get exerciseDirectorySubtitle =>
      'ताकद, कार्डिओ आणि योग, प्रत्येक पायरीच्या सूचनांसह';

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
  String get onLeave => 'रजेवर';

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
      'तुमचे जिम ड्राफ्ट म्हणून सुरू होते. वापर सुरू करण्यासाठी प्लॅन निवडा. Pro प्लॅनवरील जिम Gymologia शोधातही दिसतात.';

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
  String get needsReview => 'भाषांतर पुनरावलोकनाच्या प्रतीक्षेत';

  @override
  String get block => 'ब्लॉक करा';

  @override
  String get unblock => 'अनब्लॉक करा';

  @override
  String get report => 'तक्रार करा';

  @override
  String blockPerson(String name) {
    return '$name ला ब्लॉक करा';
  }

  @override
  String reportPerson(String name) {
    return '$name बद्दल तक्रार करा';
  }

  @override
  String get blockConfirmBody =>
      'ते तुम्हाला संदेश पाठवू शकणार नाहीत, आणि तुम्हाला त्यांचे संदेश दिसणार नाहीत. तुम्ही ब्लॉक केल्याचे त्यांना सांगितले जाणार नाही. तुम्ही हे सेटिंग्जमध्ये बदलू शकता.';

  @override
  String get blocked => 'ब्लॉक केले';

  @override
  String get blockedAccounts => 'ब्लॉक केलेली खाती';

  @override
  String get noBlockedAccounts => 'तुम्ही कोणालाही ब्लॉक केलेले नाही.';

  @override
  String get safetyAndPrivacy => 'सुरक्षा';

  @override
  String unblockQuestion(String name) {
    return '$name ला अनब्लॉक करायचे?';
  }

  @override
  String get unblockExplainer => 'ते तुम्हाला पुन्हा संदेश पाठवू शकतील.';

  @override
  String get whyReporting => 'काय अडचण आहे?';

  @override
  String get reportDetails => 'काय घडले?';

  @override
  String get reportDetailsHint =>
      'पुनरावलोकन करणारे संदेश स्वतः पाहत नाहीत. ते तुमचे वर्णनच वाचतात, म्हणून काय बोलले गेले ते तुमच्या शब्दांत सांगा.';

  @override
  String get alsoBlockThem => 'त्यांना ब्लॉकही करा';

  @override
  String get alsoBlockThemExplainer =>
      'तक्रार एक व्यक्ती वाचते आणि त्याला वेळ लागतो. ब्लॉक करणे लगेच लागू होते.';

  @override
  String get sendReport => 'तक्रार पाठवा';

  @override
  String get reportCategorySpam => 'स्पॅम किंवा नको असलेली विक्री';

  @override
  String get reportCategoryHarassment => 'छळ किंवा दादागिरी';

  @override
  String get reportCategorySexual => 'लैंगिक किंवा अश्लील मजकूर';

  @override
  String get reportCategoryHate => 'द्वेषपूर्ण भाषण';

  @override
  String get reportCategoryViolence => 'हिंसा किंवा धमकी';

  @override
  String get reportCategoryScam => 'फसवणूक किंवा ठगबाजी';

  @override
  String get reportCategoryImpersonation => 'दुसऱ्याचे सोंग घेणे';

  @override
  String get reportCategoryOther => 'इतर काही';

  @override
  String get reportSent => 'धन्यवाद. कोणीतरी याचे पुनरावलोकन करेल.';

  @override
  String get myReports => 'मी पाठवलेल्या तक्रारी';

  @override
  String get reportStatusOpen => 'पुनरावलोकनाच्या प्रतीक्षेत';

  @override
  String get reportStatusReviewing => 'पाहिले जात आहे';

  @override
  String get reportStatusActioned => 'कारवाई केली';

  @override
  String get reportStatusDismissed => 'पुनरावलोकन झाले, कारवाई नाही';

  @override
  String get noReportsSent => 'तुम्ही कोणाबद्दलही तक्रार केलेली नाही.';

  @override
  String get deleteAccount => 'खाते हटवा';

  @override
  String get deleteAccountIntro =>
      'तुमचे खाते ३० दिवस वापरता येईल. त्यानंतर ते हटवले जाईल आणि परत मिळवता येणार नाही.';

  @override
  String get whatIsDeleted => 'काय हटवले जाईल';

  @override
  String get whatIsDeletedList =>
      'तुमचे नाव, नंबर, ईमेल आणि वय. तुमची उंची, वजन आणि प्रगती. तुमचे चॅट संदेश. कोणतीही ओळखपत्रे आणि UPI तपशील.';

  @override
  String get whatIsKept => 'काय ठेवले जाईल, तुमची ओळख काढून';

  @override
  String get whatIsKeptList =>
      'देयक आणि पावती नोंदी, कारण कायद्याने हिशेबाच्या वह्या ठेवाव्या लागतात. जिममधील कृतींची नोंद, जेणेकरून वाद सोडवता येतील.';

  @override
  String get deleteGymsFirst =>
      'तुमच्याकडे अजूनही एक जिम आहे. आधी ते हटवा — तुमचे खाते हटवल्यास त्यातील प्रत्येक सदस्य आणि कर्मचाऱ्याचा प्रवेश बंद होईल, आणि ते बंद झाल्याचे त्यांना कळवले जाईल.';

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

  @override
  String get about => 'माहिती';

  @override
  String get participated => 'तुम्ही सहभागी';

  @override
  String letsGoName(String name) {
    return 'चला, $name';
  }

  @override
  String get yourTraining => 'तुमचे प्रशिक्षण';

  @override
  String get tagline => 'ट्रेन करा. ट्रॅक करा. बदला.';

  @override
  String get appearance => 'स्वरूप';

  @override
  String get themeDark => 'डार्क';

  @override
  String get themeLight => 'लाइट';

  @override
  String get takePhoto => 'फोटो काढा';

  @override
  String get chooseFromGallery => 'गॅलरीमधून निवडा';

  @override
  String get chooseFile => 'फाइल निवडा';

  @override
  String get chooseFileHint => 'तुमच्याकडील PDF किंवा फोटो';

  @override
  String get uploading => 'अपलोड होत आहे…';

  @override
  String fileTooLarge(int mb) {
    return 'ही फाइल खूप मोठी आहे. मर्यादा $mb MB आहे.';
  }

  @override
  String get gymPhotos => 'जिमचे फोटो';

  @override
  String get gymPhotosHint =>
      'पहिला फोटो कव्हर आहे, सदस्य तो शोधात पाहतात. दुसरा फोटो कव्हर करण्यासाठी त्यावर टॅप करा.';

  @override
  String get addPhoto => 'फोटो जोडा';

  @override
  String get coverPhoto => 'कव्हर';

  @override
  String get removePhoto => 'फोटो काढून टाका';

  @override
  String maxPhotos(int count) {
    return 'तुम्ही जास्तीत जास्त $count फोटो जोडू शकता.';
  }

  @override
  String get verification => 'पडताळणी';

  @override
  String get kycIntro =>
      'Gymologia जिम ब्राउझरमध्ये दिसण्यासाठी तुमचे जिम पडताळा. आमची टीम साधारणपणे 2 कामकाजाच्या दिवसांत कागदपत्रे तपासते.';

  @override
  String get kycEncryptedNote =>
      'आधार, PAN आणि GST क्रमांक एन्क्रिप्ट करून ठेवले जातात. तुमची कागदपत्रे खाजगी आहेत, फक्त आमची पडताळणी टीम ती उघडू शकते.';

  @override
  String get identity => 'ओळख';

  @override
  String get business => 'व्यवसाय';

  @override
  String get aadhaarNumber => 'आधार क्रमांक';

  @override
  String get enterValidAadhaar => 'तुमचा 12 अंकी आधार क्रमांक टाका';

  @override
  String get panNumber => 'PAN';

  @override
  String get enterValidPan => 'वैध PAN टाका, उदा. ABCDE1234F';

  @override
  String get hasGstRegistration => 'माझे जिम GST नोंदणीकृत आहे';

  @override
  String get gstin => 'GSTIN';

  @override
  String get enterValidGstin => 'तुमचा 15 अक्षरी GSTIN टाका';

  @override
  String get businessProof => 'व्यवसायाचा पुरावा';

  @override
  String get businessProofHint => 'GST नाही? यापैकी एक अपलोड करा.';

  @override
  String get proofUdyam => 'उद्यम';

  @override
  String get proofElectricityBill => 'वीज बिल';

  @override
  String get proofOther => 'इतर';

  @override
  String get premisesQuestion => 'जागा';

  @override
  String get premisesOwned => 'स्वतःचे';

  @override
  String get premisesRented => 'भाड्याचे';

  @override
  String get landlordNoc => 'घरमालकाची NOC';

  @override
  String get landlordNocHint => 'जागेच्या मालकाचे ना-हरकत पत्र';

  @override
  String get uploadDocument => 'अपलोड';

  @override
  String get documentUploaded => 'अपलोड झाले';

  @override
  String get replaceDocument => 'बदला';

  @override
  String get documentRequired => 'कृपया हे कागदपत्र अपलोड करा.';

  @override
  String get submitForVerification => 'पडताळणीसाठी पाठवा';

  @override
  String get kycSubmittedSnackbar => 'पडताळणीसाठी पाठवले';

  @override
  String get whatYouSent => 'तुम्ही काय पाठवले';

  @override
  String get kycUnderReview => 'तपासणी सुरू आहे';

  @override
  String get kycUnderReviewBody =>
      'आमची टीम तुमची कागदपत्रे तपासत आहे. पूर्ण होताच तुम्हाला कळवले जाईल.';

  @override
  String kycVerifiedOn(String date) {
    return '$date रोजी पडताळले. तुमचे जिम आता शोधात दिसू शकते.';
  }

  @override
  String get kycNeedsChanges => 'बदल आवश्यक';

  @override
  String get kycOnlyOwner =>
      'फक्त जिमचे नोंदणीकृत मालकच पडताळणी कागदपत्रे पाठवू शकतात.';

  @override
  String get statusPending => 'प्रलंबित';

  @override
  String get statusRejected => 'नाकारले';

  @override
  String get statusNotSubmitted => 'पाठवले नाही';

  @override
  String get getVerified => 'पडताळणी करून घ्या';

  @override
  String get gymLocation => 'जिमचे ठिकाण';

  @override
  String get gymLocationHint =>
      'जवळच्या सदस्यांना सापडावे म्हणून तुमचे जिम नकाशावर पिन करा.';

  @override
  String get setGymLocation => 'नकाशावर निवडा';

  @override
  String get updateGymLocation => 'बदला';

  @override
  String get gymLocationSet => 'ठिकाण सेट झाले';

  @override
  String get gymLocationFailed =>
      'तुमचे ठिकाण मिळाले नाही. लोकेशन सुरू करून पुन्हा प्रयत्न करा.';

  @override
  String gymCreatedAddPhotos(String name) {
    return '$name तयार झाले. फोटो असलेल्या जिमना जास्त सदस्य मिळतात, म्हणून आताच काही जोडा. नंतर जिम प्रोफाइलमध्ये बदलू शकता.';
  }

  @override
  String get finish => 'झाले';

  @override
  String get skipForNow => 'आता वगळा';

  @override
  String get gymLocationNotSet => 'अजून सेट नाही';

  @override
  String get moveMapHint =>
      'पिन तुमच्या जिमच्या प्रवेशद्वारावर येईल असा नकाशा हलवा.';

  @override
  String get confirmLocation => 'ठिकाण निश्चित करा';

  @override
  String get myLocation => 'माझे ठिकाण';

  @override
  String get gymContactHelp =>
      'सदस्य ज्या नंबरवर कॉल करतील तो — जिमचा रिसेप्शन किंवा व्यवसाय नंबर. तो तुमच्या जिम पेजवर सर्वांना दिसतो.';

  @override
  String get crmLockedDraft =>
      'CRM उघडण्यासाठी प्लॅन निवडा: सदस्य, स्टाफ, हजेरी, इव्हेंट आणि चॅट. नवीन मालकांना 7 दिवसांचा मोफत ट्रायल मिळतो.';

  @override
  String get crmLockedExpired =>
      'तुमचा प्लॅन संपला आहे. तुम्ही अजूनही सदस्य आणि डेटा पाहू शकता, पण काही जोडण्यासाठी किंवा बदलण्यासाठी रिन्यू करा.';

  @override
  String get crmLockedAskOwner =>
      'या जिमचा कोणताही प्लॅन चालू नाही, म्हणून CRM बंद आहे. जिम मालकाला प्लॅन निवडायला सांगा.';

  @override
  String get attendanceToday => 'आज';

  @override
  String get notMarked => 'मार्क नाही';

  @override
  String get markAbsent => 'गैरहजर मार्क करा';

  @override
  String markedAbsent(String name) {
    return '$name गैरहजर मार्क केले';
  }

  @override
  String get attendanceFilterAll => 'सर्व';

  @override
  String attendanceChangeTitle(String name, String status) {
    return '$name ला $status मध्ये बदलायचे?';
  }

  @override
  String get attendanceChangeReason => 'बदलाचे कारण';

  @override
  String get attendanceChangeReasonHint => 'उदा: चुकून मार्क झाले';

  @override
  String get attendanceChanged => 'हजेरी अपडेट झाली';

  @override
  String attendanceNeedsEditPermission(String status) {
    return 'आधीच $status मार्क आहे. बदलण्यासाठी हजेरी एडिट करण्याची परवानगी हवी.';
  }

  @override
  String get attendanceNobody => 'येथे मार्क करण्यासाठी कोणी नाही';

  @override
  String get attendanceNobodyHint =>
      'ज्यांचा प्लॅन संपला आहे आणि ज्या रोल्सची हजेरी होत नाही, ते येथे दिसत नाहीत.';

  @override
  String get attendanceCantView =>
      'तुम्ही येथे हजेरी मार्क करू शकता, पण कोण आधीच मार्क आहे ते तुमचा रोल पाहू शकत नाही.';

  @override
  String get reportGym => 'या जिमची तक्रार करा';

  @override
  String get reportEvent => 'या इव्हेंटची तक्रार करा';

  @override
  String get reportCategoryFakeListing => 'बनावट, किंवा सांगितल्याप्रमाणे नाही';

  @override
  String get reportCategoryMisleading => 'चुकीची किंमत, बक्षीस किंवा माहिती';

  @override
  String get reportDetailsOptional => 'तपशील (पर्यायी)';

  @override
  String get reportListingDetailsHint =>
      'पर्यायी. जे मदत करेल ते सांगा, जसे काय आक्षेपार्ह किंवा चुकीचे आहे.';

  @override
  String get reportListingSent => 'धन्यवाद. आमची टीम हे पाहील.';

  @override
  String hiddenByGymologia(String reason) {
    return 'Gymologia ने लपवले: $reason';
  }
}
