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
  String get loading => 'లోడ్ అవుతోంది';

  @override
  String get somethingWentWrong => 'ఏదో తప్పు జరిగింది';

  @override
  String get signIn => 'సైన్ ఇన్';

  @override
  String get phoneNumber => 'మొబైల్ నంబర్';

  @override
  String get enterPhoneNumber => 'మీ మొబైల్ నంబర్ నమోదు చేయండి';

  @override
  String get sendCode => 'కోడ్ పంపండి';

  @override
  String get verifyCode => 'ధృవీకరించండి';

  @override
  String get enterCode => 'మేము పంపిన కోడ్‌ను నమోదు చేయండి';

  @override
  String get resendCode => 'మళ్లీ పంపండి';

  @override
  String get createAccount => 'మీ ఖాతాను సృష్టించండి';

  @override
  String get yourName => 'మీ పేరు';

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
  String get profile => 'ప్రొఫైల్';

  @override
  String get findAGym => 'జిమ్ కనుగొనండి';

  @override
  String get searchGyms => 'పేరు లేదా ప్రాంతం ద్వారా వెతకండి';

  @override
  String get noGymsFound => 'ఇక్కడ ఇంకా జిమ్‌లు లేవు';

  @override
  String get perks => 'సౌకర్యాలు';

  @override
  String get contactGym => 'ఈ జిమ్‌ను సంప్రదించండి';

  @override
  String get rating => 'రేటింగ్';

  @override
  String get yourMembership => 'మీ సభ్యత్వం';

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
  String get addMeasurements =>
      'మీ బరువు మరియు ఎత్తును జోడించండి, తద్వారా జిమ్ మీతో పురోగతిని చూడగలదు';

  @override
  String get checkInDue => 'ఈ నెల చెక్-ఇన్ పెండింగ్‌లో ఉంది';

  @override
  String get thisMonth => 'ఈ నెల';

  @override
  String get perWeek => 'వారానికి';

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
  String get exerciseDirectorySubtitle =>
      'బలం, కార్డియో మరియు యోగా, దశలవారీ సూచనలతో';

  @override
  String get steps => 'దశలు';

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
  String get onLeave => 'సెలవు';

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
  String get draftNote =>
      'మీ జిమ్ చిత్తుప్రతిగా మొదలవుతుంది. ప్లాన్ తీసుకునే వరకు సెర్చ్‌లో కనిపించదు.';

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
  String get gymProfile => 'జిమ్ ప్రొఫైల్';

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
  String get noNotifications => 'కొత్తది ఏమీ లేదు';

  @override
  String get needsReview => 'అనువాద సమీక్ష పెండింగ్‌లో';
}
