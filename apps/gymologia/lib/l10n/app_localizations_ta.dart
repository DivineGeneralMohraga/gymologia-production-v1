// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get appName => 'Gymologia';

  @override
  String get languageName => 'தமிழ்';

  @override
  String get settings => 'அமைப்புகள்';

  @override
  String get language => 'மொழி';

  @override
  String get languageSubtitle =>
      'நீங்கள் வசதியாகப் படிக்கும் மொழியைத் தேர்ந்தெடுங்கள்';

  @override
  String get save => 'சேமி';

  @override
  String get cancel => 'ரத்து';

  @override
  String get tryAgain => 'மீண்டும் முயற்சி';

  @override
  String get loading => 'ஏற்றுகிறது';

  @override
  String get somethingWentWrong => 'ஏதோ தவறு நடந்தது';

  @override
  String get signIn => 'உள்நுழை';

  @override
  String get phoneNumber => 'கைபேசி எண்';

  @override
  String get enterPhoneNumber => 'உங்கள் கைபேசி எண்ணை உள்ளிடுங்கள்';

  @override
  String get sendCode => 'குறியீடு அனுப்பு';

  @override
  String get verifyCode => 'சரிபார்';

  @override
  String get enterCode => 'நாங்கள் அனுப்பிய குறியீட்டை உள்ளிடுங்கள்';

  @override
  String get resendCode => 'மீண்டும் அனுப்பு';

  @override
  String get createAccount => 'உங்கள் கணக்கை உருவாக்குங்கள்';

  @override
  String get yourName => 'உங்கள் பெயர்';

  @override
  String get emailOptional => 'மின்னஞ்சல் (விருப்பம்)';

  @override
  String get age => 'வயது';

  @override
  String get whyAgeNotBirthday =>
      'நாங்கள் உங்கள் வயதைக் கேட்கிறோம், பிறந்த தேதியை அல்ல. பிறந்த தேதி உங்கள் வங்கி மற்றும் அரசு ஆவணங்களுடன் இணைந்தது — உடற்பயிற்சி செயலிக்கு வயது போதும்.';

  @override
  String get termsAgreement =>
      'கணக்கை உருவாக்குவது பயன்பாட்டு விதிமுறைகளையும் தனியுரிமைக் கொள்கையையும் ஏற்பதாகும்.';

  @override
  String get signInWithMobile => 'உங்கள் மொபைல் எண்ணுடன் உள்நுழையவும்';

  @override
  String get mobileNumber => 'மொபைல் எண்';

  @override
  String get couldNotSendCode => 'குறியீட்டை அனுப்ப முடியவில்லை.';

  @override
  String get verificationFailed => 'சரிபார்ப்பு தோல்வியடைந்தது.';

  @override
  String get couldNotResendCode => 'குறியீட்டை மீண்டும் அனுப்ப முடியவில்லை.';

  @override
  String get couldNotCreateAccount => 'உங்கள் கணக்கை உருவாக்க முடியவில்லை.';

  @override
  String weSentCodeTo(String phone) {
    return '$phone க்கு குறியீட்டை அனுப்பியுள்ளோம்';
  }

  @override
  String resendInSeconds(int seconds) {
    return '$seconds வினாடிகளில் மீண்டும் அனுப்பவும்';
  }

  @override
  String get verified => 'சரிபார்க்கப்பட்டது';

  @override
  String get createAccountAction => 'கணக்கை உருவாக்கு';

  @override
  String get supportSent =>
      'அனுப்பப்பட்டது. நீங்கள் தந்த எண்ணுக்கு பதில் வரும்.';

  @override
  String get supportSubject => 'இது எதைப் பற்றியது?';

  @override
  String get supportSubjectHint => 'என் உறுப்பினர் நாட்கள் தவறாக தெரிகிறது';

  @override
  String get supportMessage => 'என்ன நடந்தது என்று சொல்லுங்கள்';

  @override
  String get supportReplyTo => 'நாங்கள் எங்கே பதில் அளிக்க வேண்டும்?';

  @override
  String get supportUrgent =>
      'இதனால் என் உடற்பயிற்சிக் கூடம் இயங்க முடியவில்லை';

  @override
  String get supportUrgentNote => 'முன்னுரிமையை உயர்த்தும்.';

  @override
  String copiedToClipboard(String value) {
    return '$value நகலெடுக்கப்பட்டது';
  }

  @override
  String orEmailUs(String email) {
    return 'அல்லது $email க்கு மின்னஞ்சல் அனுப்புங்கள்';
  }

  @override
  String get whatYouHaveAsked => 'நீங்கள் கேட்டவை';

  @override
  String get aFewWordsIsEnough => 'சில வார்த்தைகள் போதும்';

  @override
  String get aSentenceOrTwoHelps =>
      'ஓரிரு வாக்கியங்கள் விரைவாக சரிசெய்ய உதவும்';

  @override
  String get ticketOpen => 'யாராவது எடுக்கக் காத்திருக்கிறது';

  @override
  String get ticketInProgress => 'ஒருவர் இதைப் பார்க்கிறார்';

  @override
  String get ticketWaitingOnUser => 'உங்கள் பதிலுக்குக் காத்திருக்கிறோம்';

  @override
  String get ticketResolved => 'தீர்க்கப்பட்டது';

  @override
  String get ticketClosed => 'மூடப்பட்டது';

  @override
  String get referralPitch =>
      'குறியீட்டைப் பகிருங்கள், ஒரு உரிமையாளர் சந்தா எடுக்கும்போது சம்பாதியுங்கள். பரிந்துரை செயலி இன்னும் வரவில்லை.';

  @override
  String get appTagline => 'ஜிமாலஜியா · உறுப்பினர் மற்றும் பணியாளர்';

  @override
  String get signOutQuestion => 'வெளியேறவா?';

  @override
  String get signOutWarning => 'மீண்டும் உள்நுழைய உங்கள் தொலைபேசி தேவைப்படும்.';

  @override
  String get profileUpdated => 'சுயவிவரம் புதுப்பிக்கப்பட்டது.';

  @override
  String get yourProfile => 'உங்கள் சுயவிவரம்';

  @override
  String get emailClearToRemove => 'விருப்பத்தேர்வு. நீக்க காலியாக விடுங்கள்.';

  @override
  String get phoneIsYourLogin =>
      'இதன் மூலம்தான் நீங்கள் உள்நுழைகிறீர்கள், எனவே இங்கே இப்போது மாற்ற முடியாது. மாற்ற வேண்டுமானால் ஆதரவைத் தொடர்பு கொள்ளுங்கள்.';

  @override
  String get home => 'முகப்பு';

  @override
  String get myGym => 'என் கூடம்';

  @override
  String get discover => 'கண்டறி';

  @override
  String get sendOtp => 'OTP அனுப்பு';

  @override
  String get verifyYourNumber => 'உங்கள் எண்ணைச் சரிபார்க்கவும்';

  @override
  String get codeResent => 'புதிய குறியீடு அனுப்பப்படுகிறது.';

  @override
  String get name => 'பெயர்';

  @override
  String get email => 'மின்னஞ்சல்';

  @override
  String get connection => 'இணைப்பு';

  @override
  String get account => 'கணக்கு';

  @override
  String get session => 'அமர்வு';

  @override
  String get earnByReferring => 'பரிந்துரைத்து சம்பாதிக்கவும்';

  @override
  String get gyms => 'உடற்பயிற்சி கூடம்';

  @override
  String get events => 'நிகழ்வுகள்';

  @override
  String get chat => 'அரட்டை';

  @override
  String get profile => 'சுயவிவரம்';

  @override
  String get findAGym => 'உடற்பயிற்சி கூடம் தேடு';

  @override
  String get searchGyms => 'பெயர் அல்லது பகுதி மூலம் தேடு';

  @override
  String get noGymsFound => 'இங்கு இன்னும் எதுவும் இல்லை';

  @override
  String get perks => 'வசதிகள்';

  @override
  String get contactGym => 'இந்தக் கூடத்தைத் தொடர்பு கொள்ளுங்கள்';

  @override
  String get rating => 'மதிப்பீடு';

  @override
  String get yourMembership => 'உங்கள் உறுப்பினர் சேர்க்கை';

  @override
  String get onLeavePaused =>
      'விடுப்பில் — உங்கள் உறுப்பினர் சேர்க்கை நிறுத்தப்பட்டுள்ளது';

  @override
  String get monthlyCheckIn => 'மாதாந்திர பதிவு';

  @override
  String get notNow => 'இப்போது வேண்டாம்';

  @override
  String trainerNamed(String name) {
    return 'பயிற்சியாளர்: $name';
  }

  @override
  String goalAtGym(String gym) {
    return '$gym இல் உங்கள் இலக்கு';
  }

  @override
  String daysRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count நாட்கள் மீதம்',
      one: '1 நாள் மீதம்',
      zero: 'இன்று முடிகிறது',
    );
    return '$_temp0';
  }

  @override
  String get yourGoal => 'உங்கள் இலக்கு';

  @override
  String get trainer => 'பயிற்சியாளர்';

  @override
  String get requestLeave => 'விடுப்பு கோரிக்கை';

  @override
  String get yourProgress => 'உங்கள் முன்னேற்றம்';

  @override
  String get addMeasurementsPrompt =>
      'உங்கள் எடை மற்றும் உயரத்தைச் சேர்க்கவும், அப்போது கூடம் உங்களுடன் முன்னேற்றத்தைக் காணும்.';

  @override
  String get progressSubtitle =>
      'காலப்போக்கில் எடை, மற்றும் நீங்கள் எத்தனை முறை வந்தீர்கள்.';

  @override
  String get attendanceAppearsHere =>
      'நீங்கள் ஒரு கூடத்தின் உறுப்பினரானதும், பணியாளர்கள் வருகையைப் பதிவு செய்யத் தொடங்கியதும் இது இங்கே தோன்றும்.';

  @override
  String get twoCheckInsDrawALine =>
      'இரண்டு பதிவுகள் ஒரு கோட்டை வரையும். ஒவ்வொரு மாதமும் எடையைச் சேர்த்தால் இது நிரம்பும்.';

  @override
  String get nothingMatchesFilters =>
      'இந்த வடிகட்டிகளுக்கு எதுவும் பொருந்தவில்லை.';

  @override
  String get howToJoinGym =>
      'சேர, கூடத்தை நேரடியாகத் தொடர்பு கொள்ளுங்கள். அவர்கள் உங்களை உறுப்பினராகச் சேர்ப்பார்கள்.';

  @override
  String get weight => 'எடை';

  @override
  String get height => 'உயரம்';

  @override
  String get yourMeasurements => 'உங்கள் அளவுகள்';

  @override
  String get addMeasurements =>
      'உங்கள் எடை மற்றும் உயரத்தைச் சேர்க்கவும், அப்போது கூடம் உங்களுடன் முன்னேற்றத்தைக் காணும்';

  @override
  String get checkInDue => 'இந்த மாத பதிவு நிலுவையில்';

  @override
  String get thisMonth => 'இந்த மாதம்';

  @override
  String get perWeek => 'வாரத்திற்கு';

  @override
  String weeksRunning(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'தொடர் வாரங்கள்',
      one: 'தொடர் வாரம்',
    );
    return '$_temp0';
  }

  @override
  String get lastEightWeeks => 'கடந்த 8 வாரங்கள்';

  @override
  String get exerciseDirectory => 'பயிற்சி பட்டியல்';

  @override
  String get exercises => 'பயிற்சிகள்';

  @override
  String get searchExercises => 'பயிற்சிகளைத் தேடு';

  @override
  String get clear => 'அழி';

  @override
  String get howToDoIt => 'எப்படிச் செய்வது';

  @override
  String get watchOutFor => 'கவனிக்க வேண்டியவை';

  @override
  String get whatYouGet => 'உங்களுக்குக் கிடைப்பவை';

  @override
  String get removeYourEntry => 'உங்கள் பதிவை நீக்கவா?';

  @override
  String get stayIn => 'இருக்கிறேன்';

  @override
  String get removeMe => 'என்னை நீக்கு';

  @override
  String get youAreInTapToWithdraw =>
      'நீங்கள் பங்கேற்கிறீர்கள் — விலக தட்டவும்';

  @override
  String get participate => 'பங்கேற்க';

  @override
  String takenOffList(String event) {
    return '$event பட்டியலிலிருந்து உங்கள் பெயர் நீக்கப்படும்.';
  }

  @override
  String contactWithPhone(String phone) {
    return 'தொடர்பு $phone';
  }

  @override
  String get reasonOptional => 'காரணம் (விருப்பம்)';

  @override
  String get searchByGymCityDistrict =>
      'கூடம், நகரம் அல்லது மாவட்டம் மூலம் தேடு';

  @override
  String get exerciseDirectorySubtitle =>
      'வலிமை, கார்டியோ மற்றும் யோகா, படிப்படியான வழிகாட்டுதலுடன்';

  @override
  String get steps => 'படிகள்';

  @override
  String get attendance => 'வருகை';

  @override
  String get manage => 'நிர்வாகம்';

  @override
  String get choosePlan => 'திட்டத்தைத் தேர்வுசெய்';

  @override
  String get seeGrowthOverTime => 'காலப்போக்கில் வளர்ச்சியைப் பார்';

  @override
  String lastNDays(int days) {
    return 'கடந்த $days நாட்கள்';
  }

  @override
  String get addMember => 'உறுப்பினர் சேர்';

  @override
  String get addStaff => 'பணியாளர் சேர்';

  @override
  String get searchByNameOrNumber => 'பெயர் அல்லது எண் மூலம் தேடு';

  @override
  String get tapCircleToMarkPresent =>
      'வருகைக்கு வட்டத்தைத் தட்டவும், விவரங்களுக்கு வரிசையை';

  @override
  String markedPresent(String name) {
    return '$name வந்ததாகக் குறிக்கப்பட்டது';
  }

  @override
  String get approve => 'ஒப்புதல்';

  @override
  String get role => 'பங்கு';

  @override
  String get theirName => 'அவரது பெயர்';

  @override
  String get theirMobileNumber => 'அவரது கைபேசி எண்';

  @override
  String get codeFromTheirPhone => 'அவரது தொலைபேசியிலிருந்து குறியீடு';

  @override
  String get whatDoTheyWant => 'அவர் கூடத்திலிருந்து என்ன விரும்புகிறார்?';

  @override
  String get goalHint => 'எடை கூட்ட, எடை குறைக்க, மறுவாழ்வு…';

  @override
  String get saveChanges => 'மாற்றங்களைச் சேமி';

  @override
  String get removeFromGym => 'கூடத்திலிருந்து நீக்கு';

  @override
  String get remove => 'நீக்கு';

  @override
  String removePerson(String name) {
    return '$name ஐ நீக்கவா?';
  }

  @override
  String get onLeave => 'விடுப்பு';

  @override
  String get tapDayToCorrect => 'திருத்த ஒரு நாளைத் தட்டவும்';

  @override
  String correctDate(String date) {
    return '$date ஐத் திருத்து';
  }

  @override
  String get whyIsThisChanging => 'இது ஏன் மாறுகிறது?';

  @override
  String get correctionReasonHint =>
      'தவறாகக் குறிக்கப்பட்டது, இயந்திரம் இயங்கவில்லை…';

  @override
  String get saveCorrection => 'திருத்தத்தைச் சேமி';

  @override
  String get recordCorrected => 'பதிவு திருத்தப்பட்டது.';

  @override
  String get trainerCategories => 'பயிற்சியாளர் வகைகள்';

  @override
  String get newCategory => 'புதிய வகை';

  @override
  String get noTrainerCategoriesYet => 'இன்னும் பயிற்சியாளர் வகைகள் இல்லை.';

  @override
  String get oneTrainerManyMembers =>
      'ஒரு பயிற்சியாளர் பல உறுப்பினர்களை ஏற்கலாம்';

  @override
  String get categoryNameHint => 'மறுவாழ்வு, வலிமை, யோகா';

  @override
  String get edit => 'திருத்து';

  @override
  String get delete => 'நீக்கு';

  @override
  String get keepIt => 'வைத்திரு';

  @override
  String deleteNamed(String name) {
    return '$name ஐ நீக்கவா?';
  }

  @override
  String get decline => 'நிராகரி';

  @override
  String decidedBy(String name) {
    return '$name முடிவு செய்தார்';
  }

  @override
  String get createAGym => 'கூடம் உருவாக்கு';

  @override
  String get createYourGym => 'உங்கள் கூடத்தை உருவாக்குங்கள்';

  @override
  String get gymName => 'கூடத்தின் பெயர்';

  @override
  String get gymNameHint => 'அயர்ன் டெம்பிள் ஃபிட்னஸ்';

  @override
  String get descriptionOptional => 'விவரம் (விருப்பம்)';

  @override
  String get descriptionHint => 'உங்கள் கூடத்தில் சேர என்ன சிறப்பு?';

  @override
  String get address => 'முகவரி';

  @override
  String get city => 'நகரம்';

  @override
  String get district => 'மாவட்டம்';

  @override
  String get districtNote =>
      'தேடலில் உங்கள் கூடத்தின் பெயருக்கு அருகில் மாவட்டம் தோன்றும், அதனால் உறுப்பினர்கள் அடையாளம் காண்பர்.';

  @override
  String get state => 'மாநிலம்';

  @override
  String get pinCode => 'அஞ்சல் குறியீடு';

  @override
  String get contactNumber => 'தொடர்பு எண்';

  @override
  String get leavePolicyNote =>
      'உறுப்பினர்கள் மாதத்தில் சில நாட்கள் உறுப்பினர் சேர்க்கையை நிறுத்தலாம். அதற்கு மேல் ஒப்புதல் தேவை.';

  @override
  String get perksLabel => 'வசதிகள், காற்புள்ளியால் பிரிக்கவும்';

  @override
  String get perksHint => 'நீராவி அறை, இலவச நிறுத்தம், தனிப்பட்ட பயிற்சி';

  @override
  String get createGym => 'கூடத்தை உருவாக்கு';

  @override
  String get deleteGym => 'கூடத்தை நீக்கு';

  @override
  String get gymProfile => 'கூட சுயவிவரம்';

  @override
  String get description => 'விவரம்';

  @override
  String get leavePolicy => 'விடுப்புக் கொள்கை';

  @override
  String get leaveDaysPerMonth => 'மாதத்திற்கு விடுப்பு நாட்கள்';

  @override
  String get deleteThisGym => 'இந்தக் கூடத்தை நீக்கு';

  @override
  String get leaveLimitNote =>
      'இந்த வரம்பிற்குள் உறுப்பினர் கோரிக்கைகள் தானாக ஒப்புக்கொள்ளப்படும். அதற்கு மேல் ஒருவரின் ஒப்புதல் தேவை.';

  @override
  String get draftNote =>
      'உங்கள் கூடம் வரைவாகத் தொடங்குகிறது. சரிபார்ப்பை முடித்து திட்டம் எடுக்கும் வரை தேடலில் தோன்றாது.';

  @override
  String get sendThis => 'இதை அனுப்பவா?';

  @override
  String get send => 'அனுப்பு';

  @override
  String get announcements => 'அறிவிப்புகள்';

  @override
  String get title => 'தலைப்பு';

  @override
  String get announceTitleHint => 'பராமரிப்புக்காக ஞாயிறு மூடப்பட்டுள்ளது';

  @override
  String get message => 'செய்தி';

  @override
  String get announceBodyHint =>
      'திங்கள் காலை 6 மணிக்கு மீண்டும் திறக்கிறோம். குறுகிய அறிவிப்புக்கு வருந்துகிறோம்.';

  @override
  String get whoSeesIt => 'யார் பார்ப்பார்கள்';

  @override
  String get everyone => 'அனைவரும்';

  @override
  String get sendAnnouncement => 'அறிவிப்பை அனுப்பு';

  @override
  String get sent => 'அனுப்பப்பட்டது';

  @override
  String get newGym => 'புதிய கூடம்';

  @override
  String get draft => 'வரைவு';

  @override
  String get nothingToChartYet => 'இன்னும் காட்ட எதுவும் இல்லை.';

  @override
  String peakValue(int value) {
    return 'உச்சம் $value';
  }

  @override
  String get searchRanking => 'தேடல் தரவரிசை';

  @override
  String get notInSearch => 'தேடலில் இல்லை';

  @override
  String get members => 'உறுப்பினர்கள்';

  @override
  String get staff => 'பணியாளர்கள்';

  @override
  String get leave => 'விடுப்பு';

  @override
  String get roles => 'பங்குகள்';

  @override
  String get analytics => 'பகுப்பாய்வு';

  @override
  String get growth => 'வளர்ச்சி';

  @override
  String get ranking => 'தரவரிசை';

  @override
  String get plan => 'திட்டம்';

  @override
  String get announce => 'அறிவிப்பு';

  @override
  String get trainers => 'பயிற்சியாளர்கள்';

  @override
  String get present => 'வந்தார்';

  @override
  String get absent => 'வரவில்லை';

  @override
  String get markAttendance => 'வருகையைப் பதிவு செய்';

  @override
  String get getHelp => 'உதவி பெறு';

  @override
  String get getHelpSubtitle =>
      'எங்களுக்குச் செய்தி அனுப்புங்கள், நாங்கள் தொடர்பு கொள்வோம்';

  @override
  String get termsAndPrivacy => 'விதிமுறைகள் மற்றும் தனியுரிமை';

  @override
  String get signOut => 'வெளியேறு';

  @override
  String get switchToStaff => 'உரிமையாளர்/பணியாளர் பயன்முறைக்கு மாறு';

  @override
  String get switchToMember => 'உறுப்பினர் பயன்முறைக்கு மாறு';

  @override
  String get notifications => 'அறிவிப்புகள்';

  @override
  String get noNotifications => 'புதிதாக ஏதுமில்லை';

  @override
  String get needsReview => 'மொழிபெயர்ப்பு மதிப்பாய்வு நிலுவையில்';
}
