// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class AppLocalizationsTe extends AppLocalizations {
  AppLocalizationsTe([String locale = 'te']) : super(locale);

  @override
  String get appTitle => 'Gymologia Referral';

  @override
  String get tryAgain => 'మళ్లీ ప్రయత్నించండి';

  @override
  String get cancel => 'రద్దు';

  @override
  String get save => 'సేవ్ చేయి';

  @override
  String get add => 'జోడించు';

  @override
  String get change => 'మార్చు';

  @override
  String get genericError => 'ఏదో తప్పు జరిగింది. మళ్లీ ప్రయత్నించండి.';

  @override
  String cleartextWarning(String host) {
    return '$hostతో రక్షణ లేకుండా (plain http) కనెక్ట్ అయ్యింది';
  }

  @override
  String get signInSubtitle =>
      'కోడ్ షేర్ చేయండి. ఏదైనా జిమ్ సబ్‌స్క్రిప్షన్ తీసుకుంటే మీకు ఆదాయం.';

  @override
  String get phoneLabel => 'మొబైల్ నంబర్';

  @override
  String get phoneHint => '10 అంకెల మొబైల్ నంబర్';

  @override
  String get sendCode => 'కోడ్ పంపు';

  @override
  String codeSentTo(String phone) {
    return '$phoneకి కోడ్ పంపబడింది';
  }

  @override
  String get verify => 'ధృవీకరించు';

  @override
  String resendIn(int seconds) {
    return '$seconds సెకన్ల తర్వాత మరో కోడ్ అడగవచ్చు';
  }

  @override
  String get resend => 'మరో కోడ్ పంపు';

  @override
  String get changeNumber => 'వేరే నంబర్ వాడండి';

  @override
  String get enterTenDigits => 'మీ 10 అంకెల మొబైల్ నంబర్ నమోదు చేయండి.';

  @override
  String get enterTheCode => 'మేము పంపిన కోడ్‌ను నమోదు చేయండి.';

  @override
  String get ownersCannotJoin =>
      'జిమ్ యజమానులు రిఫరల్ యాప్‌ను వాడలేరు. జిమ్ సిబ్బంది, మిగిలిన అందరూ వాడవచ్చు.';

  @override
  String get createAccountTitle => 'మీ ఖాతా సృష్టించండి';

  @override
  String get nameLabel => 'పేరు';

  @override
  String get emailLabel => 'ఇమెయిల్ (ఐచ్ఛికం)';

  @override
  String get ageLabel => 'వయస్సు';

  @override
  String get ageWhy =>
      'మేము వయస్సు మాత్రమే అడుగుతాము, పుట్టిన తేదీని ఎప్పుడూ కాదు. పుట్టిన తేదీ మీ బ్యాంక్, ప్రభుత్వ పత్రాలకు తాళంచెవి; వయస్సు కాదు.';

  @override
  String get ageRange => '13 నుండి 100 మధ్య వయస్సు నమోదు చేయండి.';

  @override
  String get nameRequired => 'దయచేసి మీ పేరు నమోదు చేయండి.';

  @override
  String get createAccount => 'ఖాతా సృష్టించు';

  @override
  String get tabCode => 'మీ కోడ్';

  @override
  String get tabEarnings => 'ఆదాయం';

  @override
  String get tabPayout => 'చెల్లింపు';

  @override
  String get tabSettings => 'సెట్టింగ్‌లు';

  @override
  String get yourCodeTitle => 'మీ రిఫరల్ కోడ్';

  @override
  String get shareCode => 'షేర్ చేయి';

  @override
  String get copyCode => 'కాపీ చేయి';

  @override
  String get copied => 'కాపీ అయ్యింది.';

  @override
  String get shareUnavailable =>
      'ఇక్కడ షేర్ చేయడం అందుబాటులో లేదు. సందేశం కాపీ చేయబడింది.';

  @override
  String get howItWorksTitle => 'ఇది ఎలా పనిచేస్తుంది';

  @override
  String get howItWorksStep1 => 'జిమ్ నడిపే వారికి మీ కోడ్ పంపండి.';

  @override
  String howItWorksStep2(int percent) {
    return 'సబ్‌స్క్రిప్షన్ తీసుకునేటప్పుడు వారికి ఏ Gymologia ప్లాన్‌పైనైనా $percent% తగ్గింపు లభిస్తుంది.';
  }

  @override
  String howItWorksStep3(String amount) {
    return 'ఈ కోడ్‌తో సబ్‌స్క్రిప్షన్ తీసుకున్న ప్రతి జిమ్‌కు మీకు $amount లభిస్తుంది.';
  }

  @override
  String howItWorksStep4(String amount) {
    return 'మీ UPI ID నిజంగా మీదేనా అని తనిఖీ చేయడానికి మొదటి చెల్లింపు నుండి ఒకసారి $amount తీసుకుంటాము.';
  }

  @override
  String get notForOwners => 'మీ సొంత జిమ్ నుండి మీరు సంపాదించలేరు.';

  @override
  String get earnedTotal => 'ఇప్పటివరకు సంపాదించినది';

  @override
  String get heldPending => 'నిలిపి ఉంచినది';

  @override
  String get paidOut => 'చెల్లించినది';

  @override
  String get taxWithheld => 'మినహాయించిన పన్ను';

  @override
  String get neverUsed => 'ఇప్పటివరకు ఎవరూ మీ కోడ్ వాడలేదు.';

  @override
  String timesUsed(int count) {
    return '$count సార్లు వాడారు.';
  }

  @override
  String get usedOnce => 'ఒకసారి వాడారు.';

  @override
  String awaitingClearance(int count) {
    return '$count ఇంకా క్లియర్ అవుతున్నాయి.';
  }

  @override
  String get earningsTitle => 'మీ కోడ్ సంపాదించినది';

  @override
  String get earningsEmpty =>
      'ఇంకా ఏమీ లేదు. జిమ్ నడిపే వారితో మీ కోడ్ షేర్ చేయండి.';

  @override
  String earningsCapped(int count) {
    return 'అత్యంత ఇటీవలి $count చూపుతున్నాము.';
  }

  @override
  String get statusPending => 'క్లియర్ అవుతోంది';

  @override
  String get statusEligible => 'చెల్లించడానికి సిద్ధం';

  @override
  String get statusPaid => 'చెల్లించారు';

  @override
  String get statusReversed => 'వెనక్కి తీసుకున్నారు';

  @override
  String get statusPendingWhy => 'జిమ్ రీఫండ్ గడువు ముగిసే వరకు నిలిపి ఉంచాము.';

  @override
  String get statusEligibleWhy =>
      'క్లియర్ అయ్యింది. చెల్లింపులు ప్రారంభమయ్యే వరకు వేచి ఉంది.';

  @override
  String get statusPaidWhy => 'మీ UPI IDకి పంపాము.';

  @override
  String get statusReversedWhy =>
      'జిమ్ చెల్లింపు వాపసు అయ్యింది, కాబట్టి ఈ బహుమతి కూడా వెనక్కి తీసుకున్నాము.';

  @override
  String get payoutTitle => 'మీ డబ్బు ఎక్కడికి వెళ్తుంది';

  @override
  String get payoutsNotLive =>
      'చెల్లింపులు ఇంకా ప్రారంభం కాలేదు. అప్పటివరకు ఆదాయం లెక్కించి నిలిపి ఉంచుతున్నాము.';

  @override
  String get stillNeededTitle => 'ఇంకా అవసరం';

  @override
  String get payoutInFlight =>
      'ఒక చెల్లింపు మార్గంలో ఉంది. అది పూర్తయ్యాక వీటిని మార్చవచ్చు.';

  @override
  String get upiSectionTitle => 'UPI ID';

  @override
  String get upiIdLabel => 'UPI ID';

  @override
  String get upiIdHint => 'name@bank';

  @override
  String get holderNameLabel => 'ఖాతాపై ఉన్న పేరు';

  @override
  String get upiNotSet => 'సెట్ చేయలేదు';

  @override
  String get upiVerifiedYes => 'ధృవీకరించారు';

  @override
  String get upiVerifiedNo => 'ఇంకా ధృవీకరించలేదు';

  @override
  String get upiTypoWarning =>
      'దీన్ని అక్షరం అక్షరం తనిఖీ చేయండి. UPI IDకి స్పెల్-చెక్ ఉండదు: ఒక్క అక్షరం పొరపాటు వేరొకరి పూర్తిగా సరైన చిరునామా అవుతుంది, అక్కడికి పంపిన డబ్బు తిరిగి రాదు.';

  @override
  String get upiChangedClearsVerification =>
      'దీన్ని మార్చితే ధృవీకరణ తొలగిపోతుంది. మొదటి చెల్లింపుకు ముందు చిరునామా మళ్లీ తనిఖీ అవుతుంది.';

  @override
  String get holderNameWhy =>
      '₹10 తనిఖీలో ఆ ఖాతాకు మీ బ్యాంక్‌లో నమోదైన పేరు తిరిగి వస్తుంది. పోల్చడానికి పేరు లేకపోతే, చిరునామా ఉందని మాత్రమే అది నిరూపిస్తుంది — అది మీదని కాదు.';

  @override
  String get saved => 'సేవ్ అయ్యింది.';

  @override
  String get invalidUpi =>
      'ఇది UPI IDలా కనిపించడం లేదు. ఇది name@bank లా ఉండాలి.';

  @override
  String get holderNameRequired => 'బ్యాంక్ ఖాతాపై ఉన్న పేరు నమోదు చేయండి.';

  @override
  String get panSectionTitle => 'PAN';

  @override
  String get panLabel => 'PAN';

  @override
  String get panHint => 'ABCDE1234F';

  @override
  String get panNotSet => 'సెట్ చేయలేదు';

  @override
  String get panWhy =>
      'పన్ను మినహాయించాల్సిన స్థాయికి మీ ఆదాయం చేరుకునే ముందు ఇది అవసరం. ప్రారంభించడానికి అవసరం లేదు.';

  @override
  String get panStatusPending => 'అందింది, ఇంకా తనిఖీ చేయలేదు';

  @override
  String get panStatusVerified => 'ధృవీకరించారు';

  @override
  String get panStatusRejected => 'ఆమోదించలేదు. నంబర్ చూసి మళ్లీ పంపండి.';

  @override
  String get invalidPan =>
      'ఇది PANలా కనిపించడం లేదు. ఇది ABCDE1234F లా ఉండాలి.';

  @override
  String get settingsTitle => 'సెట్టింగ్‌లు';

  @override
  String get profileTitle => 'మీ ప్రొఫైల్';

  @override
  String get languageTitle => 'భాష';

  @override
  String get languageSubtitle => 'మీరు అత్యంత సౌకర్యంగా చదివే భాషను ఎంచుకోండి';

  @override
  String get useDeviceLanguage => 'పరికర భాషను వాడు';

  @override
  String get needsReview => 'అనువాదం సమీక్ష కోసం వేచి ఉంది';

  @override
  String get untranslatedFallbackNote =>
      'ఇంకా అనువదించనివి ఖాళీగా వదలకుండా ఇంగ్లీషులో చూపుతాము, తద్వారా పాక్షికంగా అనువదించిన భాష కూడా వాడదగినదిగా ఉంటుంది.';

  @override
  String get legalTitle => 'నిబంధనలు మరియు గోప్యత';

  @override
  String get legalUnavailable => 'దీన్ని ఇప్పుడు లోడ్ చేయలేకపోయాము.';

  @override
  String get supportTitle => 'సహాయం కావాలా?';

  @override
  String get supportBody =>
      'ఏమి జరిగిందో చెప్పండి, మేము మిమ్మల్ని సంప్రదిస్తాము.';

  @override
  String get supportSubject => 'విషయం';

  @override
  String get supportMessage => 'ఏమి జరిగింది?';

  @override
  String get supportSend => 'పంపు';

  @override
  String get supportSent => 'పంపాము. మేము మిమ్మల్ని సంప్రదిస్తాము.';

  @override
  String supportEmailLine(String email) {
    return 'లేదా $emailకి రాయండి.';
  }

  @override
  String get supportTooShort =>
      'ఒకటి రెండు వాక్యాలు రాయండి, ఏమి చూడాలో మాకు తెలుస్తుంది.';

  @override
  String get signOut => 'సైన్ అవుట్';

  @override
  String get signOutConfirm => 'ఈ పరికరంలో సైన్ అవుట్ చేయాలా?';

  @override
  String get aboutTitle => 'గురించి';

  @override
  String get sessionExpiredSignIn =>
      'మీ సెషన్ ముగిసింది. దయచేసి మళ్లీ సైన్ ఇన్ చేయండి.';

  @override
  String get serverTookTooLong =>
      'సర్వర్ సమాధానం ఇవ్వడానికి చాలా సమయం తీసుకుంది. కనెక్షన్ చూసి మళ్లీ ప్రయత్నించండి.';

  @override
  String couldNotReachServer(String host) {
    return '$hostని చేరుకోలేకపోయాము. మీ ఇంటర్నెట్ కనెక్షన్ చూడండి.';
  }

  @override
  String get certificateNotVerified =>
      'సర్వర్ సర్టిఫికెట్‌ను ధృవీకరించలేకపోయాము.';

  @override
  String get networkErrorTryAgain => 'నెట్‌వర్క్ లోపం. మళ్లీ ప్రయత్నించండి.';

  @override
  String get footerLine => 'Gymologia Referral';

  @override
  String get footerSupport => 'support@gymologia.com';
}
