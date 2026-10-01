// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class AppLocalizationsTe extends AppLocalizations {
  AppLocalizationsTe([String locale = 'te']) : super(locale);

  @override
  String get appName => 'Gymologia';

  @override
  String get languageName => 'తెలుగు';

  @override
  String get settings => 'సెట్టింగ్‌లు';

  @override
  String get language => 'భాష';

  @override
  String get languageSubtitle => 'మీరు సౌకర్యంగా చదివే భాషను ఎంచుకోండి';

  @override
  String get save => 'సేవ్';

  @override
  String get cancel => 'రద్దు';

  @override
  String get tryAgain => 'మళ్లీ ప్రయత్నించండి';

  @override
  String get somethingWentWrong => 'ఏదో తప్పు జరిగింది';

  @override
  String get phoneNumber => 'మొబైల్ నంబర్';

  @override
  String get enterPhoneNumber => 'మీ మొబైల్ నంబర్ నమోదు చేయండి';

  @override
  String get sendCode => 'కోడ్ పంపండి';

  @override
  String get verifyCode => 'ధృవీకరించండి';

  @override
  String get resendCode => 'మళ్లీ పంపండి';

  @override
  String get createAccount => 'మీ ఖాతాను సృష్టించండి';

  @override
  String get emailOptional => 'ఇమెయిల్ (ఐచ్ఛికం)';

  @override
  String get age => 'వయస్సు';

  @override
  String get whyAgeNotBirthday =>
      'మేము మీ వయస్సు అడుగుతాము, పుట్టిన తేదీ కాదు. పుట్టిన తేదీ మీ బ్యాంక్ మరియు ప్రభుత్వ పత్రాలతో ముడిపడి ఉంటుంది — జిమ్ యాప్‌కు వయస్సు చాలు.';

  @override
  String get termsAgreement =>
      'ఖాతా సృష్టించడం అంటే మీరు వినియోగ నిబంధనలు మరియు గోప్యతా విధానాన్ని అంగీకరిస్తున్నారు.';

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
  String get signInWithMobile => 'మీ మొబైల్ నంబర్‌తో సైన్ ఇన్ చేయండి';

  @override
  String get mobileNumber => 'మొబైల్ నంబర్';

  @override
  String get couldNotSendCode => 'కోడ్ పంపడం సాధ్యం కాలేదు.';

  @override
  String get verificationFailed => 'ధృవీకరణ విఫలమైంది.';

  @override
  String get couldNotResendCode => 'కోడ్ మళ్లీ పంపడం సాధ్యం కాలేదు.';

  @override
  String get couldNotCreateAccount => 'మీ ఖాతా సృష్టించడం సాధ్యం కాలేదు.';

  @override
  String weSentCodeTo(String phone) {
    return '$phoneకి కోడ్ పంపాము';
  }

  @override
  String resendInSeconds(int seconds) {
    return '$seconds సెకన్లలో మళ్లీ పంపండి';
  }

  @override
  String get verified => 'ధృవీకరించబడింది';

  @override
  String get createAccountAction => 'ఖాతా సృష్టించండి';

  @override
  String get supportSent => 'పంపబడింది. మీరు ఇచ్చిన నంబర్‌కు సమాధానం వస్తుంది.';

  @override
  String get supportSubject => 'ఇది దేని గురించి?';

  @override
  String get supportSubjectHint => 'నా సభ్యత్వ రోజులు తప్పుగా కనిపిస్తున్నాయి';

  @override
  String get supportMessage => 'ఏమి జరిగిందో చెప్పండి';

  @override
  String get supportReplyTo => 'మేము ఎక్కడ సమాధానం ఇవ్వాలి?';

  @override
  String get supportUrgent => 'దీనివల్ల నా జిమ్ నడవడం లేదు';

  @override
  String get supportUrgentNote => 'ప్రాధాన్యతను పెంచుతుంది.';

  @override
  String copiedToClipboard(String value) {
    return '$value కాపీ అయ్యింది';
  }

  @override
  String orEmailUs(String email) {
    return 'లేదా $emailకి ఇమెయిల్ చేయండి';
  }

  @override
  String get whatYouHaveAsked => 'మీరు అడిగినవి';

  @override
  String get aFewWordsIsEnough => 'కొన్ని పదాలు చాలు';

  @override
  String get aSentenceOrTwoHelps =>
      'ఒకటి రెండు వాక్యాలు రాస్తే త్వరగా పరిష్కరిస్తాం';

  @override
  String get ticketOpen => 'ఎవరైనా చేపట్టడం కోసం వేచి ఉంది';

  @override
  String get ticketInProgress => 'ఎవరో దీన్ని చూస్తున్నారు';

  @override
  String get ticketWaitingOnUser => 'మీ సమాధానం కోసం వేచి ఉంది';

  @override
  String get ticketResolved => 'పరిష్కరించబడింది';

  @override
  String get ticketClosed => 'మూసివేయబడింది';

  @override
  String get referralPitch =>
      'కోడ్ పంచుకోండి, ఏ జిమ్ యజమాని అయినా సబ్‌స్క్రిప్షన్ తీసుకుంటే సంపాదించండి. రెఫరల్ యాప్ ఇంకా రాలేదు.';

  @override
  String get appTagline => 'జిమాలజియా · సభ్యులు మరియు సిబ్బంది';

  @override
  String get signOutQuestion => 'సైన్ అవుట్ చేయాలా?';

  @override
  String get signOutWarning => 'మళ్లీ సైన్ ఇన్ చేయడానికి మీ ఫోన్ కావాలి.';

  @override
  String get profileUpdated => 'ప్రొఫైల్ నవీకరించబడింది.';

  @override
  String get yourProfile => 'మీ ప్రొఫైల్';

  @override
  String get emailClearToRemove => 'ఐచ్ఛికం. తీసివేయడానికి ఖాళీ చేయండి.';

  @override
  String get phoneIsYourLogin =>
      'దీనితోనే మీరు సైన్ ఇన్ చేస్తారు, కాబట్టి ఇక్కడ ఇప్పుడు మార్చలేరు. మార్చాలంటే సహాయాన్ని సంప్రదించండి.';

  @override
  String get trialStarted =>
      'ట్రయల్ ప్రారంభమైంది. మీ జిమ్ ఇప్పుడు సెర్చ్‌లో కనిపిస్తుంది.';

  @override
  String get invalidCode => 'కోడ్ చెల్లదు.';

  @override
  String get paymentNotCompletedYet =>
      'చెల్లింపు ఇంకా పూర్తి కాలేదు. కాసేపటి తర్వాత లాగి రిఫ్రెష్ చేయండి.';

  @override
  String planIsActive(String plan) {
    return '$plan ప్లాన్ చురుకుగా ఉంది.';
  }

  @override
  String get paymentNotCompleted => 'చెల్లింపు పూర్తి కాలేదు.';

  @override
  String get couldNotOpenPayment => 'చెల్లింపు స్క్రీన్ తెరవడం సాధ్యం కాలేదు.';

  @override
  String daysFree(int days) {
    return '$days రోజులు ఉచితం';
  }

  @override
  String get trialBlurb =>
      'పూర్తి ప్రో, సభ్యుల సెర్చ్‌లో మీ లిస్టింగ్‌తో సహా. కార్డు అవసరం లేదు, ఇది తనంతట తానే చెల్లింపు ప్లాన్‌గా మారదు.';

  @override
  String get startFreeTrial => 'ఉచిత ట్రయల్ ప్రారంభించండి';

  @override
  String get referralCode => 'రెఫరల్ కోడ్';

  @override
  String get optional => 'ఐచ్ఛికం';

  @override
  String get apply => 'వర్తింపజేయి';

  @override
  String get gstNote =>
      'ధరల్లో జీఎస్టీ కలిసి ఉంది. ప్రో ప్లాన్‌లో మాత్రమే జిమ్ సభ్యుల సెర్చ్‌లో కనిపిస్తుంది.';

  @override
  String planNamed(String plan) {
    return '$plan ప్లాన్';
  }

  @override
  String get trialBadge => 'ట్రయల్';

  @override
  String get expired => 'గడువు ముగిసింది';

  @override
  String daysRemainingPlan(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count రోజులు మిగిలాయి',
    );
    return '$_temp0';
  }

  @override
  String get listedInSearch => 'సభ్యుల సెర్చ్‌లో జాబితా చేయబడింది';

  @override
  String get notListedUpgrade =>
      'సెర్చ్‌లో లేదు — కనిపించాలంటే ప్రోకి అప్‌గ్రేడ్ చేయండి';

  @override
  String get trialEndsNote =>
      'ట్రయల్ ముగిసాక మీరు ప్లాన్ ఎంచుకునే వరకు మీ జిమ్ సెర్చ్ నుంచి తొలగిపోతుంది. తనంతట తానే ఏమీ వసూలు కాదు.';

  @override
  String get getsYouListed => 'సెర్చ్‌లో చోటు ఇస్తుంది';

  @override
  String get perMonth => '/నెల';

  @override
  String choosePlanNamed(String plan) {
    return '$plan ఎంచుకోండి';
  }

  @override
  String get deleteRoleWarning =>
      'పాత్ర, దాని అనుమతులు తొలగిపోతాయి. ఇందులో ఎవరూ లేరు, కాబట్టి ఎవరికీ యాక్సెస్ పోదు.';

  @override
  String deletedNamed(String name) {
    return '$name తొలగించబడింది';
  }

  @override
  String get needTwoCustomRoles =>
      'క్రమం మార్చే ముందు మీరు సవరించగల రెండు కస్టమ్ పాత్రలు అవసరం.';

  @override
  String get hierarchySaved => 'క్రమం సేవ్ చేయబడింది';

  @override
  String get reorder => 'క్రమం మార్చు';

  @override
  String get newRole => 'కొత్త పాత్ర';

  @override
  String get rolesIntro =>
      'అత్యంత సీనియర్ మొదట. మీ పాత్ర కంటే కింది వాటిని మాత్రమే సవరించగలరు, మీ దగ్గర ఉన్న అనుమతులను మాత్రమే ఇవ్వగలరు.';

  @override
  String get defaultBadge => 'డిఫాల్ట్';

  @override
  String get everyPermission => 'ప్రతి అనుమతి, తర్వాత చేర్చేవి కూడా';

  @override
  String permissionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count అనుమతులు',
    );
    return '$_temp0';
  }

  @override
  String get nobodyInThisRole => 'ఈ పాత్రలో ఎవరూ లేరు';

  @override
  String peopleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count మంది',
    );
    return '$_temp0';
  }

  @override
  String get deleteDefaultRolesStay => 'తొలగించు (డిఫాల్ట్ పాత్రలు ఉంటాయి)';

  @override
  String get deleteMovePeopleFirst => 'తొలగించు (ముందు వ్యక్తులను తరలించండి)';

  @override
  String get giveRoleAName => 'పాత్రకు ఒక పేరు ఇవ్వండి';

  @override
  String get editRole => 'పాత్రను సవరించు';

  @override
  String get createRole => 'పాత్ర సృష్టించండి';

  @override
  String get roleName => 'పాత్ర పేరు';

  @override
  String get roleNameHint => 'రిసెప్షన్, ఫిజియో, నైట్ షిఫ్ట్';

  @override
  String get superRoleNote =>
      'ఈ పాత్రకు అన్ని అనుమతులు ఉన్నాయి, భవిష్యత్తులో చేర్చేవి కూడా. దీన్ని కుదించలేరు — ఎప్పుడైనా సరిదిద్దగల పాత్ర ఇదే.';

  @override
  String get whatThisRoleCanDo => 'ఈ పాత్ర ఏమి చేయగలదు';

  @override
  String get greyedOutNote =>
      'మసకగా ఉన్నవి మీ దగ్గర లేవు, కాబట్టి వాటిని ఇవ్వలేరు.';

  @override
  String get ownerOnlyPermission => 'ఇది జిమ్ యజమానికి మాత్రమే';

  @override
  String get youDoNotHoldThis => 'ఇది మీ దగ్గర లేదు';

  @override
  String get orderTheHierarchy => 'క్రమాన్ని అమర్చండి';

  @override
  String get hierarchyNote =>
      'అత్యంత సీనియర్ పైన. డిఫాల్ట్ పాత్రలు తమ స్థానంలోనే ఉంటాయి, ఇక్కడ కనిపించవు.';

  @override
  String get saveOrder => 'క్రమాన్ని సేవ్ చేయి';

  @override
  String membershipExtendedBy(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'సభ్యత్వం $count నెలలు పొడిగించబడింది.',
    );
    return '$_temp0';
  }

  @override
  String get goalUpdated => 'లక్ష్యం నవీకరించబడింది.';

  @override
  String get thisMember => 'ఈ సభ్యుడు';

  @override
  String get removeMemberQuestion => 'సభ్యుడిని తొలగించాలా?';

  @override
  String removeMemberWarning(String name) {
    return '$name ఈ జిమ్‌కు యాక్సెస్ కోల్పోతారు. వారి హాజరు రికార్డు, కొలతలు ఉంచబడతాయి.';
  }

  @override
  String get member => 'సభ్యుడు';

  @override
  String get removeMember => 'సభ్యుడిని తొలగించు';

  @override
  String get daysLeft => 'మిగిలిన రోజులు';

  @override
  String get leaveUsed => 'వాడిన సెలవు';

  @override
  String get extend => 'పొడిగించు';

  @override
  String get editGoal => 'లక్ష్యాన్ని సవరించు';

  @override
  String get goal => 'లక్ష్యం';

  @override
  String get notSet => 'సెట్ చేయలేదు';

  @override
  String get noneAssigned => 'ఎవరూ కేటాయించలేదు';

  @override
  String get attendanceHistory => 'హాజరు చరిత్ర';

  @override
  String get viewAndCorrectRecords => 'రికార్డులు చూసి సరిదిద్దండి';

  @override
  String sessionsSoFar(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ఇప్పటివరకు $count సెషన్లు',
    );
    return '$_temp0';
  }

  @override
  String get progressIsPrivate => 'పురోగతి ప్రైవేటు';

  @override
  String get monitoringOffNote =>
      'ఈ సభ్యుడు పురోగతి పర్యవేక్షణను ఆపారు. ఇది వారి నిర్ణయం, ఏ పాత్ర కూడా దాన్ని అధిగమించలేదు.';

  @override
  String get progress => 'పురోగతి';

  @override
  String get noMeasurementsYet =>
      'ఇంకా కొలతలు నమోదు కాలేదు. సభ్యుడిని వారి యాప్‌లో నెలకు ఒకసారి అడుగుతారు.';

  @override
  String holdingAtKg(String kg) {
    return '$kg కిలోల వద్ద స్థిరం';
  }

  @override
  String weightChangeSince(String delta) {
    return 'మొదటి కొలత నుంచి $delta కిలోలు';
  }

  @override
  String get extendMembership => 'సభ్యత్వాన్ని పొడిగించు';

  @override
  String get extendFromTodayNote =>
      'గడువు ముగిసిన సభ్యత్వం ఈ రోజు నుంచి పొడిగించబడుతుంది, ముగిసిన తేదీ నుంచి కాదు.';

  @override
  String monthsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count నెలలు',
    );
    return '$_temp0';
  }

  @override
  String extendByMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count నెలలు పొడిగించు',
    );
    return '$_temp0';
  }

  @override
  String get whatAreTheyWorkingTowards =>
      'వారు ఏ లక్ష్యం కోసం కృషి చేస్తున్నారు?';

  @override
  String get goalDialogHint => '80 కిలోల వరకు బల్క్, బరువు తగ్గడం, రీహాబ్…';

  @override
  String signedUpCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count మంది నమోదు చేసుకున్నారు',
    );
    return '$_temp0';
  }

  @override
  String get nobodyYet => 'ఇంకా ఎవరూ లేరు.';

  @override
  String get hostAnEvent => 'ఒక ఈవెంట్ నిర్వహించండి';

  @override
  String get noEventsYet =>
      'ఇంకా ఈవెంట్లు లేవు. ఒకటి నిర్వహించండి, అది మీ సభ్యులకు వెంటనే కనిపిస్తుంది.';

  @override
  String get editEvent => 'ఈవెంట్ సవరించండి';

  @override
  String get cancelEvent => 'ఈవెంట్ రద్దు చేయండి';

  @override
  String get cancelEventConfirmTitle => 'ఈ ఈవెంట్‌ను రద్దు చేయాలా?';

  @override
  String get cancelEventConfirmBody =>
      'ఇది ఈవెంట్‌ను శాశ్వతంగా తొలగిస్తుంది, నమోదు చేసుకున్నవారి జాబితాతో సహా. దీన్ని వెనక్కి తీసుకోలేరు.';

  @override
  String get keepEvent => 'ఈవెంట్ ఉంచండి';

  @override
  String get eventUpdated => 'ఈవెంట్ నవీకరించబడింది';

  @override
  String get eventCancelledSnackbar => 'ఈవెంట్ తొలగించబడింది';

  @override
  String get eventTitleHint => 'సమ్మర్ డెడ్‌లిఫ్ట్ మీట్';

  @override
  String get howToTakePart => 'ఎలా పాల్గొనాలి';

  @override
  String get howToTakePartHint => 'ఉదయం 8 గంటలకు బరువు. మీ బెల్ట్ తెచ్చుకోండి.';

  @override
  String get prizeOptional => 'బహుమతి (ఐచ్ఛికం)';

  @override
  String get prizeHint => '₹10,000';

  @override
  String get membersCanSignUp => 'సభ్యులు యాప్‌లో నమోదు చేసుకోవచ్చు';

  @override
  String get membersCanSignUpNote =>
      'ఆఫ్ చేస్తే బటన్‌కు బదులు మీ నిబంధనలు కనిపిస్తాయి.';

  @override
  String get listPublicly => 'బహిరంగంగా చూపించు';

  @override
  String get listPubliclyNote => 'దేశవ్యాప్త ఈవెంట్ ఫీడ్‌లో కనిపిస్తుంది.';

  @override
  String get listPubliclyProOnly =>
      'ప్రో ప్లాన్‌లో మాత్రమే. మీ సభ్యులు అయితే చూస్తారు.';

  @override
  String get openToOutsiders => 'మీ జిమ్ బయటి వారికి కూడా తెరిచి ఉంది';

  @override
  String get publishEvent => 'ఈవెంట్ ప్రచురించు';

  @override
  String get registrationOpen => 'నమోదు తెరిచి ఉంది';

  @override
  String get registrationClosed => 'నమోదు మూసివేయబడింది';

  @override
  String get close => 'మూసివేయి';

  @override
  String get markAllRead => 'అన్నీ చదివినట్టు గుర్తించు';

  @override
  String get nothingYet => 'ఇంకా ఏమీ లేదు';

  @override
  String get announcementsAppearHere =>
      'మీ జిమ్ నుంచి, జిమాలజియా నుంచి ప్రకటనలు ఇక్కడ కనిపిస్తాయి.';

  @override
  String get searchPeople => 'వ్యక్తులను వెతకండి';

  @override
  String get nobodyElseHereYet => 'ఇక్కడ ఇంకా ఎవరూ లేరు.';

  @override
  String get nameTheGroup => 'గ్రూప్‌కు పేరు ఇవ్వండి';

  @override
  String get groupNameHint => 'శనివారం ఉదయం బృందం';

  @override
  String get create => 'సృష్టించు';

  @override
  String get pickWhoIsInTheGroup => 'గ్రూప్‌లో ఎవరు ఉండాలో ఎంచుకోండి';

  @override
  String createGroupWith(int count) {
    return '$count మందితో గ్రూప్ సృష్టించు';
  }

  @override
  String get termsOfUse => 'వినియోగ నిబంధనలు';

  @override
  String get privacy => 'గోప్యత';

  @override
  String versionUpdated(String version, String date) {
    return 'వెర్షన్ $version · నవీకరణ $date';
  }

  @override
  String sessionsAttendedAllTime(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'సెషన్లు, మొత్తం',
    );
    return '$_temp0';
  }

  @override
  String get nothingInLast60Days => 'గత 60 రోజుల్లో ఏదీ నమోదు కాలేదు.';

  @override
  String correctedReason(String reason) {
    return 'సరిదిద్దబడింది: $reason';
  }

  @override
  String get noReasonGiven => 'కారణం ఇవ్వలేదు';

  @override
  String get keptWithRecordAuditNote =>
      'ఇది రికార్డుతో పాటు ఉంచబడుతుంది, ఆడిట్ లాగ్‌లో కనిపిస్తుంది.';

  @override
  String get staffBadge => 'సిబ్బంది';

  @override
  String get draftCrmNote =>
      'మీ జిమ్ చిత్తుప్రతి. CRM పనిచేస్తుంది, కానీ ప్లాన్ చురుకుగా ఉండే వరకు సభ్యులు సెర్చ్‌లో మిమ్మల్ని కనుగొనలేరు.';

  @override
  String roleHiddenNote(String role) {
    return 'ఇక్కడ మీరు $role. మీ పాత్ర చేయలేనివి చూపి నిరాకరించే బదులు దాచబడతాయి.';
  }

  @override
  String engagedOfActive(int engaged, int total) {
    return '$total సభ్యుల్లో $engaged మంది కనీసం ఒకసారి శిక్షణ పొందారు.';
  }

  @override
  String announceGoesTo(String audience) {
    return 'ఇది ఇప్పుడే $audienceకి వెళ్తుంది, వెనక్కి తీసుకోలేరు.';
  }

  @override
  String get audienceEveryMember => 'ప్రతి సభ్యుడు';

  @override
  String get audienceEveryStaff => 'ప్రతి సిబ్బంది';

  @override
  String get audienceEveryone => 'ఈ జిమ్‌లోని అందరూ';

  @override
  String sentToPeople(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count మందికి పంపబడింది.',
    );
    return '$_temp0';
  }

  @override
  String recipientCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count స్వీకర్తలు',
    );
    return '$_temp0';
  }

  @override
  String get weTextACodeFirst =>
      'ముందుగా వారి నంబర్‌కు ఒక కోడ్ పంపుతాము, అది నిజంగా వారిదేనని తెలుసుకోవడానికి.';

  @override
  String get memberCanUpdateMetrics =>
      'వారు సభ్యుల యాప్‌లో తమ బరువు, ఎత్తు చూసి మార్చుకోగలరు. వారే ఆఫ్ చేయనంత వరకు వారి పురోగతి సిబ్బందికి కనిపిస్తుంది.';

  @override
  String get noRolesYouCanAssign =>
      'మీరు ఇవ్వగల పాత్రలు లేవు. మీ పాత్ర కంటే కింది వాటిని మాత్రమే ఇవ్వగలరు.';

  @override
  String get noRolesYouCanAssignToThem => 'మీరు వారికి ఇవ్వగల పాత్రలు లేవు.';

  @override
  String heightCm(String cm) {
    return 'ఎత్తు $cm సెం.మీ';
  }

  @override
  String weightOverCheckIns(String delta, int count) {
    return '$count తనిఖీల్లో $delta కిలోలు';
  }

  @override
  String get useDeviceLanguage => 'పరికర భాషను వాడండి';

  @override
  String get untranslatedFallbackNote =>
      'ఇంకా అనువదించనవి ఖాళీగా ఉంచకుండా ఇంగ్లీషులో చూపబడతాయి, తద్వారా పాక్షికంగా అనువదించిన భాష కూడా ఉపయోగపడుతుంది.';

  @override
  String deleteGymWarning(int members, int staff) {
    return 'మొత్తం $members సభ్యులు, $staff సిబ్బంది యాక్సెస్ కోల్పోతారు. దీన్ని యాప్ నుంచి వెనక్కి తీసుకోలేరు.';
  }

  @override
  String shownAsInSearch(String name, String district) {
    return 'సెర్చ్‌లో “$name - $district” గా కనిపిస్తుంది.';
  }

  @override
  String get nothingWaitingLeave =>
      'వేచి ఉన్నవి ఏమీ లేవు. మీ పరిమితిలోని అభ్యర్థనలు స్వయంచాలకంగా ఆమోదించబడి ఇక్కడ కనిపించవు.';

  @override
  String get quietPeriodsNote =>
      'నిశ్శబ్ద కాలాలను వదిలేయకుండా ఖాళీ బార్లుగా చూపిస్తాం, కాబట్టి బార్లలో ఖాళీ అంటే నిజమైన ఖాళీ.';

  @override
  String get rankingExplainer =>
      'సెర్చ్ ఫలితాలను క్రమపరిచే అదే విధంగా స్థానం లెక్కిస్తారు: ముందు రేటింగ్, తర్వాత ఎన్ని రేటింగ్‌లు దానికి మద్దతు ఇస్తాయో. ఇక్కడ కనిపించేదే సభ్యుడికీ కనిపిస్తుంది.';

  @override
  String get deleteTrainerCategoryWarning =>
      'ఇకపై ఈ విభాగంలో శిక్షకులను చేర్చలేరు. ఇప్పటికే ఉన్నవారి కేటాయింపు కొనసాగుతుంది.';

  @override
  String get youLabel => 'మీరు';

  @override
  String get openEvents => 'తెరిచిన ఈవెంట్లు';

  @override
  String get nothingHereYetSaySomething =>
      'ఇక్కడ ఇంకా ఏమీ లేదు. ఏదైనా చెప్పండి.';

  @override
  String get leavePausesMembership =>
      'మీరు లేనప్పుడు సభ్యత్వం ఆగుతుంది, కాబట్టి మీరు చెల్లించిన రోజులు మిగులుతాయి.';

  @override
  String get notListedUntilPlan =>
      'ప్లాన్ చురుకుగా ఉండే వరకు బహిరంగంగా కనిపించదు.';

  @override
  String gymsListedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count జిమ్‌లు జాబితాలో ఉన్నాయి',
    );
    return '$_temp0';
  }

  @override
  String get checkInGoalNote =>
      'మీ లక్ష్యం వైపు పురోగతిని గమనించడానికి మీ జిమ్ దీన్ని ఉపయోగిస్తుంది.';

  @override
  String get enterYourGymName => 'మీ జిమ్ పేరు రాయండి';

  @override
  String get sessionExpiredSignIn =>
      'మీ సెషన్ ముగిసింది. దయచేసి మళ్లీ సైన్ ఇన్ చేయండి.';

  @override
  String get somethingWentWrongTryAgain =>
      'ఏదో తప్పు జరిగింది. దయచేసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get serverTookTooLong =>
      'సర్వర్ స్పందించడానికి చాలా సమయం తీసుకుంది. కనెక్షన్ చూసి మళ్లీ ప్రయత్నించండి.';

  @override
  String couldNotReachServer(String host) {
    return '$host వద్ద సర్వర్‌ను చేరుకోలేకపోయాం. మీ ఇంటర్నెట్ కనెక్షన్ చూడండి.';
  }

  @override
  String get certificateNotVerified =>
      'సర్వర్ సర్టిఫికెట్‌ను ధృవీకరించలేకపోయాం.';

  @override
  String get networkErrorTryAgain =>
      'నెట్‌వర్క్ లోపం. దయచేసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get enterValidMobile => '10 అంకెల సరైన భారతీయ మొబైల్ నంబర్ రాయండి';

  @override
  String get enterValidTenDigitNumber => '10 అంకెల సరైన నంబర్ రాయండి';

  @override
  String get enterYourName => 'మీ పేరు రాయండి';

  @override
  String get nameTooLong => 'ఆ పేరు చాలా పొడవుగా ఉంది';

  @override
  String get enterValidEmail => 'సరైన ఇమెయిల్ చిరునామా రాయండి';

  @override
  String get enterYourAge => 'మీ వయసు రాయండి';

  @override
  String get mustBeAtLeast13 => 'మీ వయసు కనీసం 13 ఉండాలి';

  @override
  String get enterValidAge => 'సరైన వయసు రాయండి';

  @override
  String get enterWeightOrHeight => 'బరువు లేదా ఎత్తు రాయండి.';

  @override
  String get noRatingsYet => 'ఇంకా రేటింగ్‌లు లేవు';

  @override
  String get giveItATitle => 'ఒక శీర్షిక ఇవ్వండి.';

  @override
  String get sayWhatYouWantThemToKnow => 'వారికి ఏమి తెలియజేయాలో రాయండి.';

  @override
  String get sayWhyThisIsChanging => 'ఇది ఎందుకు మారుస్తున్నారో రాయండి.';

  @override
  String get noMembersYetAddFirst =>
      'ఇంకా సభ్యులు లేరు. మొదటి వారిని చేర్చండి.';

  @override
  String get nobodyMatchedSearch => 'ఆ శోధనకు ఎవరూ సరిపోలేదు.';

  @override
  String get turningUp => 'హాజరు';

  @override
  String get justNow => 'ఇప్పుడే';

  @override
  String minutesAgo(int count) {
    return '$count నిమిషాల క్రితం';
  }

  @override
  String hoursAgo(int count) {
    return '$count గంటల క్రితం';
  }

  @override
  String daysAgo(int count) {
    return '$count రోజుల క్రితం';
  }

  @override
  String monthsAgo(int count) {
    return '$count నెలల క్రితం';
  }

  @override
  String get nowShort => 'ఇప్పుడు';

  @override
  String minutesShort(int count) {
    return '$count ని';
  }

  @override
  String hoursShort(int count) {
    return '$count గం';
  }

  @override
  String daysShort(int count) {
    return '$count రో';
  }

  @override
  String weeksShort(int count) {
    return '$count వా';
  }

  @override
  String addedNamed(String name) {
    return '$name చేర్చబడింది';
  }

  @override
  String get saved => 'సేవ్ చేయబడింది';

  @override
  String get trainerCategoriesIntro =>
      'శిక్షకులను చేర్చేటప్పుడు వీటిలో ఒకదానిలో ఉంచుతారు. శిక్షకులు ఉన్న విభాగాన్ని వారిని తరలించే వరకు తొలగించలేరు.';

  @override
  String get trainerCategoriesReadOnly =>
      'ఈ జిమ్ విభాగాలను మీరు చూడవచ్చు. మార్చడానికి శిక్షకుల నిర్వహణ అనుమతి కావాలి.';

  @override
  String get oneTrainerManyMembersShort => 'ఒక శిక్షకుడు, చాలా మంది సభ్యులు';

  @override
  String get oneMemberPerTrainer => 'ఒక్కో శిక్షకుడికి ఒక సభ్యుడు';

  @override
  String get noTrainers => 'శిక్షకులు లేరు';

  @override
  String trainerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count శిక్షకులు',
    );
    return '$_temp0';
  }

  @override
  String get deleteMoveTrainersFirst => 'తొలగించు (ముందు శిక్షకులను తరలించండి)';

  @override
  String get giveCategoryAName => 'విభాగానికి ఒక పేరు ఇవ్వండి';

  @override
  String get editCategory => 'విభాగాన్ని సవరించు';

  @override
  String get newTrainerCategory => 'కొత్త శిక్షకుల విభాగం';

  @override
  String get generalTrainingNote => 'సాధారణ శిక్షణకు ఇదే మామూలు సెట్టింగ్.';

  @override
  String get personalTrainingNote =>
      'వ్యక్తిగత శిక్షణ: ఇక్కడి శిక్షకుడు ఒకసారి ఒక సభ్యుడినే తీసుకుంటారు.';

  @override
  String get addCategory => 'విభాగం చేర్చు';

  @override
  String get listedPublicly => 'బహిరంగంగా జాబితాలో ఉంది';

  @override
  String get yourMembersOnly => 'మీ సభ్యులకు మాత్రమే';

  @override
  String get whenDoesItStart => 'ఇది ఎప్పుడు మొదలవుతుంది?';

  @override
  String get chooseStartDateFirst => 'ముందు ప్రారంభ తేదీని ఎంచుకోండి.';

  @override
  String get lastDayToRegister => 'నమోదుకు చివరి రోజు';

  @override
  String get giveTheEventATitle => 'ఈవెంట్‌కు ఒక శీర్షిక ఇవ్వండి.';

  @override
  String get addADescription => 'ఒక వివరణ చేర్చండి, కనీసం ఒక వాక్యం.';

  @override
  String get sayHowToTakePart => 'పాల్గొనడానికి ఏమి చేయాలో రాయండి.';

  @override
  String get pickTheDates => 'తేదీలను ఎంచుకోండి.';

  @override
  String startsAtWhen(String when) {
    return '$when మొదలు';
  }

  @override
  String registerByWhen(String when) {
    return '$when లోపు నమోదు చేసుకోండి';
  }

  @override
  String get selectYourLeaveDates => 'మీ సెలవు తేదీలను ఎంచుకోండి';

  @override
  String get chooseYourDatesFirst => 'ముందు మీ తేదీలను ఎంచుకోండి.';

  @override
  String get sentForApproval => 'ఆమోదం కోసం పంపబడింది.';

  @override
  String get leaveApprovedPaused =>
      'సెలవు ఆమోదించబడింది. ఆ రోజులకు మీ సభ్యత్వం ఆగుతుంది.';

  @override
  String get chooseDates => 'తేదీలు ఎంచుకోండి';

  @override
  String leaveDaysLeftCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'మీకు $count సెలవు రోజులు మిగిలాయి.',
    );
    return '$_temp0';
  }

  @override
  String moreThanRemainingDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'ఇది మీ మిగిలిన $count రోజుల కంటే ఎక్కువ, కాబట్టి ఒక మేనేజర్ ఆమోదించాలి.',
    );
    return '$_temp0';
  }

  @override
  String get withinYourAllowance =>
      'మీ పరిమితిలోపే — ఇది వెంటనే ఆమోదించబడుతుంది.';

  @override
  String get sendForApproval => 'ఆమోదం కోసం పంపు';

  @override
  String get enterCodeSentToTheirPhone => 'వారి ఫోన్‌కు పంపిన కోడ్ రాయండి.';

  @override
  String get numberIsNewNameNeeded => 'ఈ నంబర్ కొత్తది, కాబట్టి పేరు కావాలి.';

  @override
  String get chooseARole => 'ఒక పాత్రను ఎంచుకోండి.';

  @override
  String get isATrainer => 'Is a trainer?';

  @override
  String get chooseATrainerCategory => 'Choose a trainer category.';

  @override
  String get trainerCategory => 'Trainer category';

  @override
  String get addAMember => 'ఒక సభ్యుడిని చేర్చు';

  @override
  String get codeSentExistingAccount =>
      'కోడ్ పంపబడింది. ఈ నంబర్‌కు ఇప్పటికే జిమాలజియా ఖాతా ఉంది.';

  @override
  String get codeSentNewAccount =>
      'కోడ్ పంపబడింది. ఈ నంబర్ కొత్తది, కాబట్టి మేము ఖాతా సృష్టిస్తాము.';

  @override
  String get membershipLength => 'సభ్యత్వ కాలం';

  @override
  String get leaveDaysAllowed => 'అనుమతించిన సెలవు రోజులు';

  @override
  String get ownerStaffMode => 'యజమాని / సిబ్బంది మోడ్';

  @override
  String get memberMode => 'సభ్యుల మోడ్';

  @override
  String get managingGymsNote =>
      'మీరు జిమ్‌లను నిర్వహిస్తున్నారు. సభ్యుడిగా జిమాలజియా వాడేందుకు తిరిగి మారండి.';

  @override
  String get openingAGymNote =>
      'జిమ్ తెరుస్తున్నారా, లేక ఒకదానిలో పనిచేస్తున్నారా? మీ జిమ్ CRM నడపడానికి మారండి — సభ్యులు, సిబ్బంది, హాజరు, సెలవులు.';

  @override
  String get numberIsHowYouSignIn =>
      'మీ నంబర్‌తోనే మీరు సైన్ ఇన్ చేస్తారు, కాబట్టి దీన్ని ఇక్కడ ఇప్పుడు మార్చలేరు.';

  @override
  String get followingYourDevice => 'మీ పరికరాన్ని అనుసరిస్తోంది';

  @override
  String get yourGym => 'మీ జిమ్';

  @override
  String weeksRunning(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'వరుస వారాలు',
      one: 'వరుస వారం',
    );
    return '$_temp0';
  }

  @override
  String noVisitsInLastDays(int days) {
    return 'గత $days రోజుల్లో రాక నమోదు కాలేదు.';
  }

  @override
  String visitsInLastDays(int count, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'గత $days రోజుల్లో $count రాకలు.',
    );
    return '$_temp0';
  }

  @override
  String get couldNotLoadEvents => 'ఈవెంట్లు లోడ్ కాలేదు';

  @override
  String get noEventsOnRightNow => 'ప్రస్తుతం ఈవెంట్లు లేవు';

  @override
  String get eventsAppearHere =>
      'మీ జిమ్ నిర్వహించే ఈవెంట్లు ఇక్కడ కనిపిస్తాయి, దగ్గరలో అందరికీ తెరిచినవి కూడా.';

  @override
  String get atYourGym => 'మీ జిమ్‌లో';

  @override
  String trainerStaffMembersAt(String gym) {
    return '$gymలో మీ శిక్షకుడు, సిబ్బంది, సభ్యులు';
  }

  @override
  String get trainerStaffOtherMembers => 'మీ శిక్షకుడు, సిబ్బంది, ఇతర సభ్యులు';

  @override
  String get comingNext => 'తర్వాత వస్తున్నది';

  @override
  String get progressChartsAgainstGoal =>
      'మీ లక్ష్యానికి వ్యతిరేకంగా పురోగతి చార్టులు';

  @override
  String get leaveLeft => 'మిగిలిన సెలవు';

  @override
  String approvedMembershipPauses(String name) {
    return '$name ఆమోదించబడింది. ఆ రోజులకు వారి సభ్యత్వం ఆగుతుంది.';
  }

  @override
  String get approveInstead => 'బదులుగా ఆమోదించు';

  @override
  String get declineInstead => 'బదులుగా తిరస్కరించు';

  @override
  String get needsYou => 'మీ చర్య కావాలి';

  @override
  String get autoApproved => 'స్వయంచాలకంగా ఆమోదం';

  @override
  String get returnedEarly => 'ముందుగానే తిరిగి వచ్చారు';

  @override
  String get whereYouAre => 'మీరు ఎక్కడ ఉన్నారు';

  @override
  String get enterTheAddress => 'చిరునామా రాయండి';

  @override
  String get maximumPerMembership => 'ఒక్కో సభ్యత్వానికి గరిష్ఠం';

  @override
  String removeStaffWithAssigned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'వారు ఈ జిమ్‌కు యాక్సెస్ కోల్పోతారు, వారికి కేటాయించిన $count సభ్యులకు మీరు వేరొకరిని కేటాయించే వరకు శిక్షకుడు ఉండరు.',
    );
    return '$_temp0';
  }

  @override
  String get removeStaffPlain =>
      'వారు ఈ జిమ్‌కు యాక్సెస్ కోల్పోతారు. వారి హాజరు రికార్డు ఉంచబడుతుంది.';

  @override
  String get couldNotLoadGyms => 'జిమ్‌లు లోడ్ కాలేదు';

  @override
  String get noGymsListedYet => 'ఇంకా జిమ్‌లు జాబితాలో లేవు';

  @override
  String get gymsAppearOnPro =>
      'జిమ్‌లు ప్రో ప్లాన్‌లో ఉండి, జాబితాలో ఉండాలని ఎంచుకుంటే ఇక్కడ కనిపిస్తాయి.';

  @override
  String nothingMatchedTry(String query) {
    return '“$query”కి ఏదీ సరిపోలలేదు. వేరే నగరం లేదా జిల్లా ప్రయత్నించండి.';
  }

  @override
  String get noRatings => 'రేటింగ్‌లు లేవు';

  @override
  String get noPerksYet => 'ఇంకా ఎలాంటి ప్రయోజనాలు జాబితా చేయలేదు';

  @override
  String fromRatings(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count రేటింగ్‌ల నుంచి',
    );
    return '$_temp0';
  }

  @override
  String get onlyProGymHere => 'ఇక్కడ ఏకైక ప్రో జిమ్';

  @override
  String ofProGyms(int count) {
    return '$count ప్రో జిమ్‌లలో';
  }

  @override
  String get couldNotLoadYourGyms => 'మీ జిమ్‌లు లోడ్ కాలేదు';

  @override
  String get noGymsYet => 'ఇంకా జిమ్‌లు లేవు';

  @override
  String get createYourGymBlurb =>
      'సభ్యులు, సిబ్బంది, హాజరు, సెలవులు సెట్ చేయడానికి మీ జిమ్ సృష్టించండి. ఏదైనా జిమ్‌లో పనిచేస్తే యజమానిని చేర్చమని అడగండి, అది ఇక్కడ కనిపిస్తుంది.';

  @override
  String newGroupSelected(int count) {
    return 'కొత్త గ్రూప్ ($count ఎంచుకున్నారు)';
  }

  @override
  String get newMessage => 'కొత్త సందేశం';

  @override
  String get oneToOne => 'ఒకరితో ఒకరు';

  @override
  String get group => 'గ్రూప్';

  @override
  String get buildMuscle => 'కండరాలు పెంచు';

  @override
  String get loseFat => 'కొవ్వు తగ్గించు';

  @override
  String get getStronger => 'బలం పెంచు';

  @override
  String get officialGroupEmpty => 'ఈ జిమ్‌లోని అందరూ. ఇంకా ఏమీ చెప్పలేదు.';

  @override
  String get unofficialGroupEmpty => 'సభ్యులు మాత్రమే. ఇంకా ఏమీ చెప్పలేదు.';

  @override
  String get noMessagesYet => 'ఇంకా సందేశాలు లేవు';

  @override
  String get approved => 'ఆమోదించబడింది';

  @override
  String get declined => 'తిరస్కరించబడింది';

  @override
  String get cancelled => 'రద్దు చేయబడింది';

  @override
  String get flexibility => 'సౌలభ్యం';

  @override
  String get rehab => 'రీహాబ్';

  @override
  String get youPrefix => 'మీరు: ';

  @override
  String get active => 'చురుకైన';

  @override
  String get joined => 'చేరినవారు';

  @override
  String get leftCount => 'వెళ్లినవారు';

  @override
  String get net => 'నికర';

  @override
  String get daily => 'రోజువారీ';

  @override
  String get monthly => 'నెలవారీ';

  @override
  String get yearly => 'వార్షిక';

  @override
  String get add => 'చేర్చు';

  @override
  String get update => 'నవీకరించు';

  @override
  String get required => 'అవసరం';

  @override
  String get contact => 'సంప్రదింపు';

  @override
  String get owner => 'యజమాని';

  @override
  String get support => 'మద్దతు';

  @override
  String get machineTranslatedExercise =>
      'ఈ సూచనలు యంత్రానువాదం, ఏ శిక్షకుడూ వీటిని తనిఖీ చేయలేదు. ఏదైనా విచిత్రంగా అనిపిస్తే బరువు ఎత్తే ముందు ఇంగ్లీషుకు మారి సరిచూసుకోండి.';

  @override
  String get home => 'హోమ్';

  @override
  String get myGym => 'నా జిమ్';

  @override
  String get discover => 'అన్వేషించండి';

  @override
  String get sendOtp => 'OTP పంపండి';

  @override
  String get verifyYourNumber => 'మీ నంబర్ ధృవీకరించండి';

  @override
  String get codeResent => 'కొత్త కోడ్ పంపబడుతోంది.';

  @override
  String get name => 'పేరు';

  @override
  String get email => 'ఇమెయిల్';

  @override
  String get connection => 'కనెక్షన్';

  @override
  String get account => 'ఖాతా';

  @override
  String get session => 'సెషన్';

  @override
  String get earnByReferring => 'రిఫర్ చేసి సంపాదించండి';

  @override
  String get gyms => 'జిమ్‌లు';

  @override
  String get events => 'ఈవెంట్‌లు';

  @override
  String get chat => 'చాట్';

  @override
  String get findAGym => 'జిమ్ కనుగొనండి';

  @override
  String get searchGyms => 'పేరు లేదా ప్రాంతం ద్వారా వెతకండి';

  @override
  String get perks => 'సౌకర్యాలు';

  @override
  String get rating => 'రేటింగ్';

  @override
  String get onLeavePaused => 'సెలవులో — మీ సభ్యత్వం నిలిపివేయబడింది';

  @override
  String get monthlyCheckIn => 'నెలవారీ చెక్-ఇన్';

  @override
  String get notNow => 'ఇప్పుడు కాదు';

  @override
  String trainerNamed(String name) {
    return 'శిక్షకుడు: $name';
  }

  @override
  String goalAtGym(String gym) {
    return '$gymలో మీ లక్ష్యం';
  }

  @override
  String daysRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count రోజులు మిగిలాయి',
      one: '1 రోజు మిగిలింది',
      zero: 'ఈరోజు ముగుస్తుంది',
    );
    return '$_temp0';
  }

  @override
  String get yourGoal => 'మీ లక్ష్యం';

  @override
  String get trainer => 'శిక్షకుడు';

  @override
  String get requestLeave => 'సెలవు అభ్యర్థన';

  @override
  String get yourProgress => 'మీ పురోగతి';

  @override
  String get addMeasurementsPrompt =>
      'మీ బరువు మరియు ఎత్తును జోడించండి, తద్వారా జిమ్ మీతో పురోగతిని చూడగలదు.';

  @override
  String get progressSubtitle =>
      'కాలక్రమేణా బరువు, మరియు మీరు ఎన్నిసార్లు వచ్చారు.';

  @override
  String get attendanceAppearsHere =>
      'మీరు ఒక జిమ్‌లో సభ్యులైన తర్వాత, సిబ్బంది హాజరు నమోదు మొదలుపెట్టాక ఇది ఇక్కడ కనిపిస్తుంది.';

  @override
  String get twoCheckInsDrawALine =>
      'రెండు నమోదులు ఒక గీతను గీస్తాయి. ప్రతి నెలా బరువు జోడిస్తే ఇది నిండుతుంది.';

  @override
  String get nothingMatchesFilters => 'ఈ ఫిల్టర్‌లకు ఏదీ సరిపోలలేదు.';

  @override
  String get howToJoinGym =>
      'చేరడానికి నేరుగా జిమ్‌ను సంప్రదించండి. వారు మిమ్మల్ని సభ్యుడిగా చేరుస్తారు.';

  @override
  String get weight => 'బరువు';

  @override
  String get height => 'ఎత్తు';

  @override
  String get yourMeasurements => 'మీ కొలతలు';

  @override
  String get checkInDue => 'ఈ నెల చెక్-ఇన్ పెండింగ్‌లో ఉంది';

  @override
  String get thisMonth => 'ఈ నెల';

  @override
  String get perWeek => 'వారానికి';

  @override
  String get lastEightWeeks => 'గత 8 వారాలు';

  @override
  String get exerciseDirectory => 'వ్యాయామ జాబితా';

  @override
  String get exercises => 'వ్యాయామాలు';

  @override
  String get searchExercises => 'వ్యాయామాలు వెతకండి';

  @override
  String get clear => 'తొలగించు';

  @override
  String get howToDoIt => 'ఎలా చేయాలి';

  @override
  String get watchOutFor => 'జాగ్రత్తలు';

  @override
  String get whatYouGet => 'మీకు లభించేవి';

  @override
  String get removeYourEntry => 'మీ నమోదును తీసివేయాలా?';

  @override
  String get stayIn => 'ఉండిపో';

  @override
  String get removeMe => 'నన్ను తీసివేయి';

  @override
  String get youAreInTapToWithdraw => 'మీరు చేరారు — వైదొలగడానికి నొక్కండి';

  @override
  String get participate => 'పాల్గొనండి';

  @override
  String takenOffList(String event) {
    return '$event జాబితా నుండి మీ పేరు తీసివేయబడుతుంది.';
  }

  @override
  String contactWithPhone(String phone) {
    return 'సంప్రదించండి $phone';
  }

  @override
  String get reasonOptional => 'కారణం (ఐచ్ఛికం)';

  @override
  String get searchByGymCityDistrict => 'జిమ్, నగరం లేదా జిల్లా ద్వారా వెతకండి';

  @override
  String get useMyLocation =>
      'సమీపంలోని జిమ్‌లను కనుగొనడానికి నా లొకేషన్‌ను ఉపయోగించండి';

  @override
  String get findingNearbyGyms => 'మీ సమీపంలోని జిమ్‌లు కనుగొనబడుతున్నాయి…';

  @override
  String get locationUnavailable =>
      'మీ లొకేషన్ పొందడం సాధ్యపడలేదు — అన్ని జిమ్‌లు చూపబడుతున్నాయి';

  @override
  String get exerciseDirectorySubtitle =>
      'బలం, కార్డియో మరియు యోగా, దశలవారీ సూచనలతో';

  @override
  String get attendance => 'హాజరు';

  @override
  String get manage => 'నిర్వహణ';

  @override
  String get choosePlan => 'ప్లాన్ ఎంచుకోండి';

  @override
  String get seeGrowthOverTime => 'కాలక్రమేణా వృద్ధిని చూడండి';

  @override
  String lastNDays(int days) {
    return 'గత $days రోజులు';
  }

  @override
  String get addMember => 'సభ్యుడిని జోడించండి';

  @override
  String get addStaff => 'సిబ్బందిని జోడించండి';

  @override
  String get searchByNameOrNumber => 'పేరు లేదా నంబర్‌తో వెతకండి';

  @override
  String get tapCircleToMarkPresent =>
      'హాజరుకు వృత్తాన్ని నొక్కండి, వివరాలకు వరుసను';

  @override
  String markedPresent(String name) {
    return '$name హాజరుగా గుర్తించబడింది';
  }

  @override
  String get approve => 'ఆమోదించు';

  @override
  String get role => 'పాత్ర';

  @override
  String get theirName => 'వారి పేరు';

  @override
  String get theirMobileNumber => 'వారి మొబైల్ నంబర్';

  @override
  String get codeFromTheirPhone => 'వారి ఫోన్ నుండి కోడ్';

  @override
  String get whatDoTheyWant => 'వారు జిమ్ నుండి ఏమి కోరుకుంటున్నారు?';

  @override
  String get goalHint => 'బరువు పెంచడం, తగ్గించడం, రీహాబ్…';

  @override
  String get saveChanges => 'మార్పులు సేవ్ చేయి';

  @override
  String get removeFromGym => 'జిమ్ నుండి తీసివేయి';

  @override
  String get remove => 'తీసివేయి';

  @override
  String removePerson(String name) {
    return '$nameను తీసివేయాలా?';
  }

  @override
  String get onLeave => 'సెలవులో';

  @override
  String get tapDayToCorrect => 'సరిచేయడానికి ఒక రోజును నొక్కండి';

  @override
  String correctDate(String date) {
    return '$date సరిచేయి';
  }

  @override
  String get whyIsThisChanging => 'ఇది ఎందుకు మారుతోంది?';

  @override
  String get correctionReasonHint => 'పొరపాటున గుర్తించారు, యంత్రం పనిచేయలేదు…';

  @override
  String get saveCorrection => 'సవరణ సేవ్ చేయి';

  @override
  String get recordCorrected => 'రికార్డు సరిచేయబడింది.';

  @override
  String get trainerCategories => 'శిక్షకుల విభాగాలు';

  @override
  String get newCategory => 'కొత్త విభాగం';

  @override
  String get noTrainerCategoriesYet => 'ఇంకా శిక్షకుల విభాగాలు లేవు.';

  @override
  String get oneTrainerManyMembers =>
      'ఒక శిక్షకుడు చాలా మంది సభ్యులను తీసుకోవచ్చు';

  @override
  String get categoryNameHint => 'రీహాబ్, స్ట్రెంగ్త్, యోగా';

  @override
  String get edit => 'సవరించు';

  @override
  String get delete => 'తొలగించు';

  @override
  String get keepIt => 'ఉంచు';

  @override
  String deleteNamed(String name) {
    return '$name తొలగించాలా?';
  }

  @override
  String get decline => 'తిరస్కరించు';

  @override
  String decidedBy(String name) {
    return '$name నిర్ణయించారు';
  }

  @override
  String get createAGym => 'జిమ్ సృష్టించండి';

  @override
  String get createYourGym => 'మీ జిమ్ సృష్టించండి';

  @override
  String get gymName => 'జిమ్ పేరు';

  @override
  String get gymNameHint => 'ఐరన్ టెంపుల్ ఫిట్‌నెస్';

  @override
  String get descriptionOptional => 'వివరణ (ఐచ్ఛికం)';

  @override
  String get descriptionHint => 'మీ జిమ్‌లో చేరడానికి ఏమి ప్రత్యేకం?';

  @override
  String get address => 'చిరునామా';

  @override
  String get city => 'నగరం';

  @override
  String get district => 'జిల్లా';

  @override
  String get districtNote =>
      'సెర్చ్‌లో మీ జిమ్ పేరు పక్కన జిల్లా కనిపిస్తుంది, తద్వారా సభ్యులు గుర్తించగలరు.';

  @override
  String get state => 'రాష్ట్రం';

  @override
  String get pinCode => 'పిన్ కోడ్';

  @override
  String get contactNumber => 'సంప్రదింపు నంబర్';

  @override
  String get leavePolicyNote =>
      'సభ్యులు నెలలో కొన్ని రోజులు సభ్యత్వాన్ని ఆపవచ్చు. అంతకు మించితే ఆమోదం అవసరం.';

  @override
  String get perksLabel => 'సౌకర్యాలు, కామాతో వేరు చేయండి';

  @override
  String get perksHint => 'స్టీమ్ రూమ్, ఉచిత పార్కింగ్, పర్సనల్ ట్రైనింగ్';

  @override
  String get createGym => 'జిమ్ సృష్టించు';

  @override
  String get deleteGym => 'జిమ్ తొలగించు';

  @override
  String get gymProfile => 'జిమ్ ప్రొఫైల్';

  @override
  String get description => 'వివరణ';

  @override
  String get leavePolicy => 'సెలవు విధానం';

  @override
  String get leaveDaysPerMonth => 'నెలకు సెలవు రోజులు';

  @override
  String get deleteThisGym => 'ఈ జిమ్ తొలగించు';

  @override
  String get leaveLimitNote =>
      'ఈ పరిమితిలోపు సభ్యుల అభ్యర్థనలు స్వయంచాలకంగా ఆమోదించబడతాయి. అంతకు మించితే ఎవరైనా ఆమోదించాలి.';

  @override
  String get draftNote =>
      'మీ జిమ్ డ్రాఫ్ట్‌గా ప్రారంభమవుతుంది. ఉపయోగించడం ప్రారంభించడానికి ఒక ప్లాన్ ఎంచుకోండి. Pro ప్లాన్ జిమ్‌లు Gymologia శోధనలో కూడా కనిపిస్తాయి.';

  @override
  String get sendThis => 'దీన్ని పంపాలా?';

  @override
  String get send => 'పంపు';

  @override
  String get announcements => 'ప్రకటనలు';

  @override
  String get title => 'శీర్షిక';

  @override
  String get announceTitleHint => 'నిర్వహణ కోసం ఆదివారం మూసివేత';

  @override
  String get message => 'సందేశం';

  @override
  String get announceBodyHint =>
      'సోమవారం ఉదయం 6 గంటలకు మళ్లీ తెరుస్తాము. తక్కువ సమయ సూచనకు క్షమించండి.';

  @override
  String get whoSeesIt => 'ఎవరు చూస్తారు';

  @override
  String get everyone => 'అందరూ';

  @override
  String get sendAnnouncement => 'ప్రకటన పంపు';

  @override
  String get sent => 'పంపబడింది';

  @override
  String get newGym => 'కొత్త జిమ్';

  @override
  String get draft => 'చిత్తుప్రతి';

  @override
  String get nothingToChartYet => 'ఇంకా చూపించడానికి ఏమీ లేదు.';

  @override
  String peakValue(int value) {
    return 'గరిష్ఠం $value';
  }

  @override
  String get searchRanking => 'సెర్చ్ ర్యాంకింగ్';

  @override
  String get notInSearch => 'సెర్చ్‌లో లేదు';

  @override
  String get members => 'సభ్యులు';

  @override
  String get staff => 'సిబ్బంది';

  @override
  String get leave => 'సెలవు';

  @override
  String get roles => 'పాత్రలు';

  @override
  String get analytics => 'విశ్లేషణ';

  @override
  String get growth => 'వృద్ధి';

  @override
  String get ranking => 'ర్యాంకింగ్';

  @override
  String get plan => 'ప్లాన్';

  @override
  String get announce => 'ప్రకటన';

  @override
  String get trainers => 'శిక్షకులు';

  @override
  String get present => 'హాజరు';

  @override
  String get absent => 'గైర్హాజరు';

  @override
  String get markAttendance => 'హాజరు నమోదు చేయండి';

  @override
  String get getHelp => 'సహాయం పొందండి';

  @override
  String get getHelpSubtitle => 'మాకు సందేశం పంపండి, మేము సంప్రదిస్తాము';

  @override
  String get termsAndPrivacy => 'నిబంధనలు మరియు గోప్యత';

  @override
  String get signOut => 'సైన్ అవుట్';

  @override
  String get switchToStaff => 'యజమాని/సిబ్బంది మోడ్‌కు మారండి';

  @override
  String get switchToMember => 'సభ్యుల మోడ్‌కు మారండి';

  @override
  String get notifications => 'నోటిఫికేషన్‌లు';

  @override
  String get needsReview => 'అనువాద సమీక్ష పెండింగ్‌లో';

  @override
  String get block => 'బ్లాక్ చేయండి';

  @override
  String get unblock => 'అన్‌బ్లాక్ చేయండి';

  @override
  String get report => 'నివేదించండి';

  @override
  String blockPerson(String name) {
    return '$nameని బ్లాక్ చేయండి';
  }

  @override
  String reportPerson(String name) {
    return '$nameపై నివేదించండి';
  }

  @override
  String get blockConfirmBody =>
      'వారు మీకు సందేశం పంపలేరు, వారి సందేశాలు మీకు కనిపించవు. మీరు బ్లాక్ చేసినట్టు వారికి చెప్పబడదు. సెట్టింగ్‌లలో దీన్ని మార్చుకోవచ్చు.';

  @override
  String get blocked => 'బ్లాక్ చేయబడింది';

  @override
  String get blockedAccounts => 'బ్లాక్ చేసిన ఖాతాలు';

  @override
  String get noBlockedAccounts => 'మీరు ఎవరినీ బ్లాక్ చేయలేదు.';

  @override
  String get safetyAndPrivacy => 'భద్రత';

  @override
  String unblockQuestion(String name) {
    return '$nameని అన్‌బ్లాక్ చేయాలా?';
  }

  @override
  String get unblockExplainer => 'వారు మళ్లీ మీకు సందేశం పంపగలరు.';

  @override
  String get whyReporting => 'సమస్య ఏమిటి?';

  @override
  String get reportDetails => 'ఏమి జరిగింది?';

  @override
  String get reportDetailsHint =>
      'సమీక్షకులు సందేశాన్ని చూడరు. వారు మీ వివరణనే చదువుతారు, కాబట్టి ఏమి చెప్పారో మీ మాటల్లో తెలియజేయండి.';

  @override
  String get alsoBlockThem => 'వారిని బ్లాక్ కూడా చేయండి';

  @override
  String get alsoBlockThemExplainer =>
      'నివేదికను ఒక వ్యక్తి చదువుతారు, దానికి సమయం పడుతుంది. బ్లాక్ చేయడం వెంటనే పనిచేస్తుంది.';

  @override
  String get sendReport => 'నివేదిక పంపండి';

  @override
  String get reportCategorySpam => 'స్పామ్ లేదా అవాంఛిత అమ్మకం';

  @override
  String get reportCategoryHarassment => 'వేధింపు లేదా బెదిరింపు';

  @override
  String get reportCategorySexual => 'లైంగిక లేదా అసభ్య విషయం';

  @override
  String get reportCategoryHate => 'ద్వేషపూరిత ప్రసంగం';

  @override
  String get reportCategoryViolence => 'హింస లేదా బెదిరింపు';

  @override
  String get reportCategoryScam => 'మోసం లేదా దగా';

  @override
  String get reportCategoryImpersonation => 'వేరొకరిలా నటించడం';

  @override
  String get reportCategoryOther => 'మరేదైనా';

  @override
  String get reportSent => 'ధన్యవాదాలు. ఎవరైనా దీన్ని సమీక్షిస్తారు.';

  @override
  String get myReports => 'నేను పంపిన నివేదికలు';

  @override
  String get reportStatusOpen => 'సమీక్ష కోసం వేచి ఉంది';

  @override
  String get reportStatusReviewing => 'పరిశీలిస్తున్నారు';

  @override
  String get reportStatusActioned => 'చర్య తీసుకోబడింది';

  @override
  String get reportStatusDismissed => 'సమీక్షించారు, చర్య లేదు';

  @override
  String get noReportsSent => 'మీరు ఎవరిపైనా నివేదించలేదు.';

  @override
  String get deleteAccount => 'ఖాతాను తొలగించండి';

  @override
  String get deleteAccountIntro =>
      'మీ ఖాతా 30 రోజుల పాటు వాడుకోవచ్చు. ఆ తర్వాత అది తొలగించబడుతుంది, తిరిగి పొందలేరు.';

  @override
  String get whatIsDeleted => 'ఏమి తొలగించబడుతుంది';

  @override
  String get whatIsDeletedList =>
      'మీ పేరు, నంబర్, ఇమెయిల్, వయస్సు. మీ ఎత్తు, బరువు, పురోగతి. మీ చాట్ సందేశాలు. గుర్తింపు పత్రాలు, UPI వివరాలు.';

  @override
  String get whatIsKept => 'ఏమి ఉంచబడుతుంది, మీ గుర్తింపు తీసేసి';

  @override
  String get whatIsKeptList =>
      'చెల్లింపు, ఇన్‌వాయిస్ రికార్డులు, ఎందుకంటే ఖాతా పుస్తకాలు ఉంచడం చట్టపరమైన అవసరం. జిమ్‌లో తీసుకున్న చర్యల రికార్డు, వివాదాలు పరిష్కరించడానికి.';

  @override
  String get deleteGymsFirst =>
      'మీకు ఇంకా ఒక జిమ్ ఉంది. ముందుగా దాన్ని తొలగించండి — మీ ఖాతా తొలగిస్తే అందులోని ప్రతి సభ్యుడు, సిబ్బంది ప్రవేశం కోల్పోతారు, మరియు అది మూసివేయబడిందని వారికి తెలియజేయబడుతుంది.';

  @override
  String unwithdrawnWarning(String amount) {
    return 'మీరు తీసుకోని $amount రెఫరల్ ఆదాయం ఉంది. ముందుగా Gymologia Referral యాప్‌లో తీసుకోండి, లేకుంటే అది పోతుంది.';
  }

  @override
  String get iUnderstandLoseEarnings =>
      'ఈ డబ్బు పోతుందని నేను అర్థం చేసుకున్నాను';

  @override
  String deletionScheduled(String date) {
    return 'మీ ఖాతా $dateన తొలగించబడుతుంది.';
  }

  @override
  String get keepMyAccount => 'నా ఖాతాను ఉంచండి';

  @override
  String get deletionCancelled => 'మీ ఖాతా తొలగించబడదు.';

  @override
  String get deleteAccountConfirm => 'నా ఖాతాను తొలగించండి';

  @override
  String get about => 'పరిచయం';

  @override
  String get participated => 'మీరు చేరారు';

  @override
  String letsGoName(String name) {
    return 'రండి, $name';
  }

  @override
  String get yourTraining => 'మీ శిక్షణ';

  @override
  String get tagline => 'శిక్షణ. ట్రాక్. మార్పు.';

  @override
  String get appearance => 'రూపం';

  @override
  String get themeDark => 'డార్క్';

  @override
  String get themeLight => 'లైట్';

  @override
  String get takePhoto => 'ఫోటో తీయండి';

  @override
  String get chooseFromGallery => 'గ్యాలరీ నుండి ఎంచుకోండి';

  @override
  String get chooseFile => 'ఫైల్ ఎంచుకోండి';

  @override
  String get chooseFileHint => 'మీ వద్ద ఉన్న PDF లేదా చిత్రం';

  @override
  String get uploading => 'అప్‌లోడ్ అవుతోంది…';

  @override
  String fileTooLarge(int mb) {
    return 'ఈ ఫైల్ చాలా పెద్దది. పరిమితి $mb MB.';
  }

  @override
  String get gymPhotos => 'జిమ్ ఫోటోలు';

  @override
  String get gymPhotosHint =>
      'మొదటి ఫోటో కవర్, సభ్యులు శోధనలో దీన్ని చూస్తారు. వేరే ఫోటోను కవర్ చేయడానికి దానిపై నొక్కండి.';

  @override
  String get addPhoto => 'ఫోటో జోడించండి';

  @override
  String get coverPhoto => 'కవర్';

  @override
  String get removePhoto => 'ఫోటో తీసివేయండి';

  @override
  String maxPhotos(int count) {
    return 'గరిష్టంగా $count ఫోటోలు జోడించవచ్చు.';
  }

  @override
  String get verification => 'ధృవీకరణ';

  @override
  String get kycIntro =>
      'Gymologia జిమ్ బ్రౌజర్‌లో కనిపించడానికి మీ జిమ్‌ను ధృవీకరించండి. మా బృందం సాధారణంగా 2 పని దినాల్లో పత్రాలను తనిఖీ చేస్తుంది.';

  @override
  String get kycEncryptedNote =>
      'ఆధార్, PAN, GST నంబర్లు ఎన్‌క్రిప్ట్ చేసి నిల్వ చేయబడతాయి. మీ పత్రాలు గోప్యమైనవి, మా ధృవీకరణ బృందం మాత్రమే తెరవగలదు.';

  @override
  String get identity => 'గుర్తింపు';

  @override
  String get business => 'వ్యాపారం';

  @override
  String get aadhaarNumber => 'ఆధార్ నంబర్';

  @override
  String get enterValidAadhaar => 'మీ 12 అంకెల ఆధార్ నంబర్ నమోదు చేయండి';

  @override
  String get panNumber => 'PAN';

  @override
  String get enterValidPan =>
      'చెల్లుబాటు అయ్యే PAN నమోదు చేయండి, ఉదా. ABCDE1234F';

  @override
  String get hasGstRegistration => 'నా జిమ్ GST నమోదైంది';

  @override
  String get gstin => 'GSTIN';

  @override
  String get enterValidGstin => 'మీ 15 అక్షరాల GSTIN నమోదు చేయండి';

  @override
  String get businessProof => 'వ్యాపార రుజువు';

  @override
  String get businessProofHint => 'GST లేదా? వీటిలో ఒకటి అప్‌లోడ్ చేయండి.';

  @override
  String get proofUdyam => 'ఉద్యమ్';

  @override
  String get proofElectricityBill => 'కరెంట్ బిల్';

  @override
  String get proofOther => 'ఇతర';

  @override
  String get premisesQuestion => 'ప్రాంగణం';

  @override
  String get premisesOwned => 'సొంతం';

  @override
  String get premisesRented => 'అద్దె';

  @override
  String get landlordNoc => 'యజమాని NOC';

  @override
  String get landlordNocHint => 'ప్రాంగణ యజమాని నుండి నిరభ్యంతర పత్రం';

  @override
  String get uploadDocument => 'అప్‌లోడ్';

  @override
  String get documentUploaded => 'అప్‌లోడ్ అయింది';

  @override
  String get replaceDocument => 'మార్చండి';

  @override
  String get documentRequired => 'దయచేసి ఈ పత్రాన్ని అప్‌లోడ్ చేయండి.';

  @override
  String get submitForVerification => 'ధృవీకరణకు సమర్పించండి';

  @override
  String get kycSubmittedSnackbar => 'ధృవీకరణకు పంపబడింది';

  @override
  String get whatYouSent => 'మీరు పంపినవి';

  @override
  String get kycUnderReview => 'పరిశీలనలో ఉంది';

  @override
  String get kycUnderReviewBody =>
      'మా బృందం మీ పత్రాలను తనిఖీ చేస్తోంది. పూర్తయిన వెంటనే మీకు తెలియజేస్తాం.';

  @override
  String kycVerifiedOn(String date) {
    return '$dateన ధృవీకరించబడింది. మీ జిమ్ ఇప్పుడు శోధనలో కనిపించవచ్చు.';
  }

  @override
  String get kycNeedsChanges => 'మార్పులు అవసరం';

  @override
  String get kycOnlyOwner =>
      'జిమ్ నమోదిత యజమాని మాత్రమే ధృవీకరణ పత్రాలను సమర్పించగలరు.';

  @override
  String get statusPending => 'పెండింగ్';

  @override
  String get statusRejected => 'తిరస్కరించబడింది';

  @override
  String get statusNotSubmitted => 'పంపలేదు';

  @override
  String get getVerified => 'ధృవీకరణ పొందండి';
}
