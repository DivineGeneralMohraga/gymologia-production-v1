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
  String get somethingWentWrong => 'ஏதோ தவறு நடந்தது';

  @override
  String get phoneNumber => 'கைபேசி எண்';

  @override
  String get enterPhoneNumber => 'உங்கள் கைபேசி எண்ணை உள்ளிடுங்கள்';

  @override
  String get sendCode => 'குறியீடு அனுப்பு';

  @override
  String get verifyCode => 'சரிபார்';

  @override
  String get resendCode => 'மீண்டும் அனுப்பு';

  @override
  String get createAccount => 'உங்கள் கணக்கை உருவாக்குங்கள்';

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
  String get trialStarted =>
      'சோதனை காலம் தொடங்கியது. உங்கள் கூடம் இப்போது தேடலில் தெரியும்.';

  @override
  String get invalidCode => 'குறியீடு செல்லுபடியாகாது.';

  @override
  String get paymentNotCompletedYet =>
      'பணம் செலுத்துவது இன்னும் முடியவில்லை. சிறிது நேரம் கழித்து இழுத்து புதுப்பிக்கவும்.';

  @override
  String planIsActive(String plan) {
    return '$plan திட்டம் இயங்குகிறது.';
  }

  @override
  String get paymentNotCompleted => 'பணம் செலுத்துவது முடியவில்லை.';

  @override
  String get couldNotOpenPayment =>
      'பணம் செலுத்தும் திரையைத் திறக்க முடியவில்லை.';

  @override
  String daysFree(int days) {
    return '$days நாட்கள் இலவசம்';
  }

  @override
  String get trialBlurb =>
      'முழு ப்ரோ, உறுப்பினர் தேடலில் உங்கள் பட்டியல் உட்பட. அட்டை தேவையில்லை, இது தானாக கட்டணத் திட்டமாக மாறாது.';

  @override
  String get startFreeTrial => 'இலவச சோதனையைத் தொடங்கு';

  @override
  String get referralCode => 'பரிந்துரை குறியீடு';

  @override
  String get optional => 'விருப்பத்தேர்வு';

  @override
  String get apply => 'பயன்படுத்து';

  @override
  String get gstNote =>
      'விலைகளில் ஜிஎஸ்டி அடங்கும். ப்ரோ திட்டத்தில் மட்டுமே கூடம் உறுப்பினர் தேடலில் தோன்றும்.';

  @override
  String planNamed(String plan) {
    return '$plan திட்டம்';
  }

  @override
  String get trialBadge => 'சோதனை';

  @override
  String get expired => 'காலாவதி';

  @override
  String daysRemainingPlan(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count நாட்கள் மீதம்',
    );
    return '$_temp0';
  }

  @override
  String get listedInSearch => 'உறுப்பினர் தேடலில் பட்டியலிடப்பட்டது';

  @override
  String get notListedUpgrade =>
      'தேடலில் இல்லை — தோன்ற ப்ரோ-க்கு மேம்படுத்துங்கள்';

  @override
  String get trialEndsNote =>
      'சோதனை முடிந்ததும், நீங்கள் திட்டம் தேர்வு செய்யும் வரை உங்கள் கூடம் தேடலில் இருந்து விலகும். தானாக எதுவும் வசூலிக்கப்படாது.';

  @override
  String get getsYouListed => 'தேடலில் இடம் தரும்';

  @override
  String get perMonth => '/மாதம்';

  @override
  String choosePlanNamed(String plan) {
    return '$plan தேர்வு செய்';
  }

  @override
  String get deleteRoleWarning =>
      'பங்கும் அதன் அனுமதிகளும் நீங்கும். இதில் யாரும் இல்லை, எனவே யாருக்கும் அணுகல் இழக்காது.';

  @override
  String deletedNamed(String name) {
    return '$name நீக்கப்பட்டது';
  }

  @override
  String get needTwoCustomRoles =>
      'வரிசையை மாற்றும் முன், நீங்கள் திருத்தக்கூடிய இரண்டு தனிப்பயன் பங்குகள் தேவை.';

  @override
  String get hierarchySaved => 'படிநிலை சேமிக்கப்பட்டது';

  @override
  String get reorder => 'வரிசை மாற்று';

  @override
  String get newRole => 'புதிய பங்கு';

  @override
  String get rolesIntro =>
      'மூத்தவை முதலில். உங்கள் பங்குக்குக் கீழ் உள்ளவற்றை மட்டுமே திருத்த முடியும், உங்களிடம் உள்ள அனுமதிகளை மட்டுமே வழங்க முடியும்.';

  @override
  String get defaultBadge => 'இயல்பு';

  @override
  String get everyPermission => 'எல்லா அனுமதிகளும், பின்னர் சேர்ப்பவை உட்பட';

  @override
  String permissionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count அனுமதிகள்',
    );
    return '$_temp0';
  }

  @override
  String get nobodyInThisRole => 'இந்தப் பங்கில் யாரும் இல்லை';

  @override
  String peopleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count பேர்',
    );
    return '$_temp0';
  }

  @override
  String get deleteDefaultRolesStay => 'நீக்கு (இயல்பு பங்குகள் இருக்கும்)';

  @override
  String get deleteMovePeopleFirst => 'நீக்கு (முதலில் நபர்களை மாற்று)';

  @override
  String get giveRoleAName => 'பங்குக்கு ஒரு பெயர் கொடுங்கள்';

  @override
  String get editRole => 'பங்கைத் திருத்து';

  @override
  String get createRole => 'பங்கை உருவாக்கு';

  @override
  String get roleName => 'பங்கின் பெயர்';

  @override
  String get roleNameHint => 'வரவேற்பு, பிசியோ, இரவு ஷிப்ட்';

  @override
  String get superRoleNote =>
      'இந்தப் பங்கிடம் எல்லா அனுமதிகளும் உள்ளன, எதிர்காலத்தில் சேர்ப்பவை உட்பட. இதைக் குறைக்க முடியாது — எப்போதும் சரிசெய்யக்கூடிய பங்கு இதுவே.';

  @override
  String get whatThisRoleCanDo => 'இந்தப் பங்கு என்ன செய்யலாம்';

  @override
  String get greyedOutNote =>
      'மங்கலாக இருப்பவை உங்களிடம் இல்லாதவை, எனவே அவற்றை வழங்க முடியாது.';

  @override
  String get ownerOnlyPermission => 'இது கூட உரிமையாளருக்கு மட்டுமே';

  @override
  String get youDoNotHoldThis => 'இது உங்களிடம் இல்லை';

  @override
  String get orderTheHierarchy => 'படிநிலையை வரிசைப்படுத்து';

  @override
  String get hierarchyNote =>
      'மூத்தவை மேலே. இயல்பு பங்குகள் தங்கள் இடத்திலேயே இருக்கும், இங்கே பட்டியலிடப்படாது.';

  @override
  String get saveOrder => 'வரிசையைச் சேமி';

  @override
  String membershipExtendedBy(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'உறுப்பினர் சேர்க்கை $count மாதம் நீட்டிக்கப்பட்டது.',
    );
    return '$_temp0';
  }

  @override
  String get goalUpdated => 'இலக்கு புதுப்பிக்கப்பட்டது.';

  @override
  String get thisMember => 'இந்த உறுப்பினர்';

  @override
  String get removeMemberQuestion => 'உறுப்பினரை நீக்கவா?';

  @override
  String removeMemberWarning(String name) {
    return '$name இந்தக் கூடத்திற்கான அணுகலை இழப்பார். அவரது வருகைப் பதிவும் அளவுகளும் வைக்கப்படும்.';
  }

  @override
  String get member => 'உறுப்பினர்';

  @override
  String get removeMember => 'உறுப்பினரை நீக்கு';

  @override
  String get daysLeft => 'மீதி நாட்கள்';

  @override
  String get leaveUsed => 'எடுத்த விடுப்பு';

  @override
  String get extend => 'நீட்டி';

  @override
  String get editGoal => 'இலக்கைத் திருத்து';

  @override
  String get goal => 'இலக்கு';

  @override
  String get notSet => 'அமைக்கப்படவில்லை';

  @override
  String get noneAssigned => 'யாரும் ஒதுக்கப்படவில்லை';

  @override
  String get attendanceHistory => 'வருகை வரலாறு';

  @override
  String get viewAndCorrectRecords => 'பதிவுகளைப் பார்த்துச் சரிசெய்';

  @override
  String sessionsSoFar(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'இதுவரை $count அமர்வுகள்',
    );
    return '$_temp0';
  }

  @override
  String get progressIsPrivate => 'முன்னேற்றம் தனிப்பட்டது';

  @override
  String get monitoringOffNote =>
      'இந்த உறுப்பினர் முன்னேற்றக் கண்காணிப்பை நிறுத்தியுள்ளார். இது அவரது தேர்வு, எந்தப் பங்கும் இதை மீற முடியாது.';

  @override
  String get progress => 'முன்னேற்றம்';

  @override
  String get noMeasurementsYet =>
      'இதுவரை அளவுகள் பதிவாகவில்லை. உறுப்பினரிடம் அவரது செயலியில் மாதம் ஒருமுறை கேட்கப்படும்.';

  @override
  String holdingAtKg(String kg) {
    return '$kg கிலோவில் நிலையாக';
  }

  @override
  String weightChangeSince(String delta) {
    return 'முதல் அளவுக்குப் பிறகு $delta கிலோ';
  }

  @override
  String get extendMembership => 'உறுப்பினர் சேர்க்கையை நீட்டி';

  @override
  String get extendFromTodayNote =>
      'காலாவதியான உறுப்பினர் சேர்க்கை இன்று முதல் நீட்டிக்கப்படும், முடிந்த தேதியிலிருந்து அல்ல.';

  @override
  String monthsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count மாதம்',
    );
    return '$_temp0';
  }

  @override
  String extendByMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count மாதம் நீட்டி',
    );
    return '$_temp0';
  }

  @override
  String get whatAreTheyWorkingTowards =>
      'அவர் எந்த இலக்கை நோக்கிச் செயல்படுகிறார்?';

  @override
  String get goalDialogHint => '80 கிலோ வரை பல்க், எடை குறைப்பு, மறுவாழ்வு…';

  @override
  String signedUpCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count பேர் பதிவு செய்துள்ளனர்',
    );
    return '$_temp0';
  }

  @override
  String get nobodyYet => 'இன்னும் யாரும் இல்லை.';

  @override
  String get hostAnEvent => 'ஒரு நிகழ்வை நடத்து';

  @override
  String get noEventsYet =>
      'இன்னும் நிகழ்வுகள் இல்லை. ஒன்றை நடத்துங்கள், அது உங்கள் உறுப்பினர்களுக்கு உடனே தெரியும்.';

  @override
  String get eventTitleHint => 'கோடை டெட்லிஃப்ட் சந்திப்பு';

  @override
  String get howToTakePart => 'எப்படிப் பங்கேற்பது';

  @override
  String get howToTakePartHint =>
      'காலை 8 மணிக்கு எடை. உங்கள் பெல்ட்டைக் கொண்டு வாருங்கள்.';

  @override
  String get prizeOptional => 'பரிசு (விருப்பம்)';

  @override
  String get prizeHint => '₹10,000';

  @override
  String get membersCanSignUp => 'உறுப்பினர்கள் செயலியில் பதிவு செய்யலாம்';

  @override
  String get membersCanSignUpNote =>
      'அணைத்தால், பொத்தானுக்குப் பதிலாக உங்கள் தேவைகள் தெரியும்.';

  @override
  String get listPublicly => 'பொதுவில் பட்டியலிடு';

  @override
  String get listPubliclyNote =>
      'நாடு முழுவதும் நிகழ்வுப் பட்டியலில் தோன்றும்.';

  @override
  String get listPubliclyProOnly =>
      'ப்ரோ திட்டத்தில் மட்டும். உங்கள் உறுப்பினர்கள் இதைப் பார்ப்பார்கள்.';

  @override
  String get openToOutsiders =>
      'உங்கள் கூடத்திற்கு வெளியே உள்ளவர்களுக்கும் திறந்தது';

  @override
  String get publishEvent => 'நிகழ்வை வெளியிடு';

  @override
  String get registrationOpen => 'பதிவு திறந்துள்ளது';

  @override
  String get registrationClosed => 'பதிவு மூடப்பட்டது';

  @override
  String get close => 'மூடு';

  @override
  String get markAllRead => 'அனைத்தையும் படித்ததாக குறி';

  @override
  String get nothingYet => 'இன்னும் எதுவும் இல்லை';

  @override
  String get announcementsAppearHere =>
      'உங்கள் கூடத்திலிருந்தும் ஜிமாலஜியாவிலிருந்தும் அறிவிப்புகள் இங்கே தோன்றும்.';

  @override
  String get searchPeople => 'நபர்களைத் தேடு';

  @override
  String get nobodyElseHereYet => 'இங்கே இன்னும் வேறு யாரும் இல்லை.';

  @override
  String get nameTheGroup => 'குழுவுக்குப் பெயரிடு';

  @override
  String get groupNameHint => 'சனிக்கிழமை காலை குழு';

  @override
  String get create => 'உருவாக்கு';

  @override
  String get pickWhoIsInTheGroup => 'குழுவில் யார் என்பதைத் தேர்வு செய்';

  @override
  String createGroupWith(int count) {
    return '$count பேருடன் குழுவை உருவாக்கு';
  }

  @override
  String get termsOfUse => 'பயன்பாட்டு விதிமுறைகள்';

  @override
  String get privacy => 'தனியுரிமை';

  @override
  String versionUpdated(String version, String date) {
    return 'பதிப்பு $version · புதுப்பிப்பு $date';
  }

  @override
  String sessionsAttendedAllTime(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'அமர்வுகள், மொத்தம்',
    );
    return '$_temp0';
  }

  @override
  String get nothingInLast60Days => 'கடந்த 60 நாட்களில் எதுவும் பதிவாகவில்லை.';

  @override
  String correctedReason(String reason) {
    return 'திருத்தப்பட்டது: $reason';
  }

  @override
  String get noReasonGiven => 'காரணம் தரப்படவில்லை';

  @override
  String get keptWithRecordAuditNote =>
      'இது பதிவுடன் வைக்கப்படும், தணிக்கைப் பதிவிலும் தெரியும்.';

  @override
  String get staffBadge => 'பணியாளர்';

  @override
  String get draftCrmNote =>
      'உங்கள் கூடம் வரைவு நிலையில் உள்ளது. CRM செயல்படும், ஆனால் திட்டம் இயங்கும் வரை உறுப்பினர்கள் தேடலில் உங்களைக் காண மாட்டார்கள்.';

  @override
  String roleHiddenNote(String role) {
    return 'இங்கே நீங்கள் $role. உங்கள் பங்கு செய்ய முடியாதவை காட்டி மறுக்கப்படாமல் மறைக்கப்படும்.';
  }

  @override
  String engagedOfActive(int engaged, int total) {
    return '$total உறுப்பினர்களில் $engaged பேர் குறைந்தது ஒருமுறை பயிற்சி செய்தனர்.';
  }

  @override
  String announceGoesTo(String audience) {
    return 'இது இப்போதே $audience சென்றடையும், திரும்பப் பெற முடியாது.';
  }

  @override
  String get audienceEveryMember => 'ஒவ்வொரு உறுப்பினருக்கும்';

  @override
  String get audienceEveryStaff => 'ஒவ்வொரு பணியாளருக்கும்';

  @override
  String get audienceEveryone => 'இந்தக் கூடத்தில் உள்ள அனைவருக்கும்';

  @override
  String sentToPeople(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count பேருக்கு அனுப்பப்பட்டது.',
    );
    return '$_temp0';
  }

  @override
  String recipientCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count பெறுநர்கள்',
    );
    return '$_temp0';
  }

  @override
  String get weTextACodeFirst =>
      'முதலில் அவரது எண்ணுக்கு ஒரு குறியீட்டை அனுப்புகிறோம், அது உண்மையில் அவருடையது என்று உறுதிசெய்ய.';

  @override
  String get memberCanUpdateMetrics =>
      'அவர்கள் உறுப்பினர் செயலியில் தங்கள் எடையையும் உயரத்தையும் பார்க்கவும் மாற்றவும் முடியும். அவர்களே அணைக்காத வரை முன்னேற்றம் பணியாளர்களுக்குத் தெரியும்.';

  @override
  String get noRolesYouCanAssign =>
      'நீங்கள் வழங்கக்கூடிய பங்குகள் இல்லை. உங்கள் பங்குக்குக் கீழ் உள்ளவற்றை மட்டுமே வழங்க முடியும்.';

  @override
  String get noRolesYouCanAssignToThem =>
      'நீங்கள் அவருக்கு வழங்கக்கூடிய பங்குகள் இல்லை.';

  @override
  String heightCm(String cm) {
    return 'உயரம் $cm செ.மீ';
  }

  @override
  String weightOverCheckIns(String delta, int count) {
    return '$count சரிபார்ப்புகளில் $delta கிலோ';
  }

  @override
  String get useDeviceLanguage => 'சாதன மொழியைப் பயன்படுத்து';

  @override
  String get untranslatedFallbackNote =>
      'இன்னும் மொழிபெயர்க்கப்படாதவை காலியாக விடப்படாமல் ஆங்கிலத்தில் காட்டப்படும், அதனால் பகுதியளவு மொழிபெயர்ப்பும் பயன்படும்.';

  @override
  String deleteGymWarning(int members, int staff) {
    return 'அனைத்து $members உறுப்பினர்களும் $staff பணியாளர்களும் அணுகலை இழப்பார்கள். இதைச் செயலியிலிருந்து மீட்க முடியாது.';
  }

  @override
  String shownAsInSearch(String name, String district) {
    return 'தேடலில் “$name - $district” எனத் தோன்றும்.';
  }

  @override
  String get nothingWaitingLeave =>
      'காத்திருப்பில் எதுவும் இல்லை. உங்கள் வரம்பிற்குள் உள்ள கோரிக்கைகள் தானாக ஒப்புக்கொள்ளப்பட்டு இங்கே தோன்றுவதில்லை.';

  @override
  String get quietPeriodsNote =>
      'அமைதியான காலங்கள் விடுபடாமல் காலி பட்டைகளாகக் காட்டப்படும், எனவே பட்டைகளில் உள்ள இடைவெளி உண்மையான இடைவெளி.';

  @override
  String get rankingExplainer =>
      'தேடல் முடிவுகளை வரிசைப்படுத்தும் அதே முறையில் இடம் கணக்கிடப்படுகிறது: முதலில் மதிப்பீடு, பிறகு எத்தனை மதிப்பீடுகள் அதற்கு ஆதரவு. இங்கே தெரிவதே உறுப்பினருக்கும் தெரியும்.';

  @override
  String get deleteTrainerCategoryWarning =>
      'இனி இந்தப் பிரிவில் பயிற்சியாளர்களைச் சேர்க்க முடியாது. ஏற்கனவே இருப்பவர்களின் ஒதுக்கீடு தொடரும்.';

  @override
  String get youLabel => 'நீங்கள்';

  @override
  String get openEvents => 'திறந்த நிகழ்வுகள்';

  @override
  String get nothingHereYetSaySomething =>
      'இங்கே இன்னும் எதுவும் இல்லை. ஏதாவது சொல்லுங்கள்.';

  @override
  String get leavePausesMembership =>
      'நீங்கள் இல்லாத போது உறுப்பினர் சேர்க்கை இடைநிறுத்தப்படும், எனவே நீங்கள் பணம் செலுத்திய நாட்கள் மீதமிருக்கும்.';

  @override
  String get notListedUntilPlan =>
      'திட்டம் இயங்கும் வரை பொதுவில் பட்டியலிடப்படாது.';

  @override
  String gymsListedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count கூடங்கள் பட்டியலிடப்பட்டன',
    );
    return '$_temp0';
  }

  @override
  String get checkInGoalNote =>
      'உங்கள் இலக்கை நோக்கிய முன்னேற்றத்தைக் கண்காணிக்க உங்கள் கூடம் இதைப் பயன்படுத்துகிறது.';

  @override
  String get enterYourGymName => 'உங்கள் கூடத்தின் பெயரை உள்ளிடு';

  @override
  String get sessionExpiredSignIn =>
      'உங்கள் அமர்வு முடிந்தது. மீண்டும் உள்நுழையவும்.';

  @override
  String get somethingWentWrongTryAgain =>
      'ஏதோ தவறாகிவிட்டது. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get serverTookTooLong =>
      'சேவையகம் பதிலளிக்க மிக நேரம் எடுத்தது. இணைப்பைச் சரிபார்த்து மீண்டும் முயற்சிக்கவும்.';

  @override
  String couldNotReachServer(String host) {
    return '$host இல் உள்ள சேவையகத்தை அடைய முடியவில்லை. உங்கள் இணைய இணைப்பைச் சரிபார்க்கவும்.';
  }

  @override
  String get certificateNotVerified =>
      'சேவையகச் சான்றிதழைச் சரிபார்க்க முடியவில்லை.';

  @override
  String get networkErrorTryAgain => 'பிணையப் பிழை. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get enterValidMobile =>
      '10 இலக்க சரியான இந்திய மொபைல் எண்ணை உள்ளிடவும்';

  @override
  String get enterValidTenDigitNumber => '10 இலக்க சரியான எண்ணை உள்ளிடவும்';

  @override
  String get enterYourName => 'உங்கள் பெயரை உள்ளிடவும்';

  @override
  String get nameTooLong => 'அந்தப் பெயர் மிக நீளமானது';

  @override
  String get enterValidEmail => 'சரியான மின்னஞ்சல் முகவரியை உள்ளிடவும்';

  @override
  String get enterYourAge => 'உங்கள் வயதை உள்ளிடவும்';

  @override
  String get mustBeAtLeast13 => 'உங்கள் வயது குறைந்தது 13 இருக்க வேண்டும்';

  @override
  String get enterValidAge => 'சரியான வயதை உள்ளிடவும்';

  @override
  String get enterWeightOrHeight => 'எடை அல்லது உயரத்தை உள்ளிடவும்.';

  @override
  String get noRatingsYet => 'இன்னும் மதிப்பீடுகள் இல்லை';

  @override
  String get giveItATitle => 'ஒரு தலைப்பு கொடுங்கள்.';

  @override
  String get sayWhatYouWantThemToKnow =>
      'அவர்களுக்கு என்ன தெரிவிக்க வேண்டும் என்று எழுதுங்கள்.';

  @override
  String get sayWhyThisIsChanging =>
      'இது ஏன் மாற்றப்படுகிறது என்று எழுதுங்கள்.';

  @override
  String get noMembersYetAddFirst =>
      'இன்னும் உறுப்பினர்கள் இல்லை. முதல் நபரைச் சேருங்கள்.';

  @override
  String get nobodyMatchedSearch => 'அந்தத் தேடலுக்கு யாரும் பொருந்தவில்லை.';

  @override
  String get turningUp => 'வருகை';

  @override
  String get justNow => 'இப்போதே';

  @override
  String minutesAgo(int count) {
    return '$count நிமிடம் முன்';
  }

  @override
  String hoursAgo(int count) {
    return '$count மணி முன்';
  }

  @override
  String daysAgo(int count) {
    return '$count நாள் முன்';
  }

  @override
  String monthsAgo(int count) {
    return '$count மாதம் முன்';
  }

  @override
  String get nowShort => 'இப்போது';

  @override
  String minutesShort(int count) {
    return '$count நி';
  }

  @override
  String hoursShort(int count) {
    return '$count ம';
  }

  @override
  String daysShort(int count) {
    return '$count நா';
  }

  @override
  String weeksShort(int count) {
    return '$count வா';
  }

  @override
  String addedNamed(String name) {
    return '$name சேர்க்கப்பட்டது';
  }

  @override
  String get saved => 'சேமிக்கப்பட்டது';

  @override
  String get trainerCategoriesIntro =>
      'பயிற்சியாளர்களைச் சேர்க்கும்போது இவற்றில் ஒன்றில் வைக்கப்படுவார்கள். பயிற்சியாளர்கள் உள்ள பிரிவை, அவர்களை மாற்றும் வரை நீக்க முடியாது.';

  @override
  String get trainerCategoriesReadOnly =>
      'இந்தக் கூடத்தின் பிரிவுகளை நீங்கள் பார்க்கலாம். மாற்ற பயிற்சியாளர் மேலாண்மை அனுமதி தேவை.';

  @override
  String get oneTrainerManyMembersShort => 'ஒரு பயிற்சியாளர், பல உறுப்பினர்கள்';

  @override
  String get oneMemberPerTrainer => 'ஒரு பயிற்சியாளருக்கு ஒரு உறுப்பினர்';

  @override
  String get noTrainers => 'பயிற்சியாளர்கள் இல்லை';

  @override
  String trainerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count பயிற்சியாளர்கள்',
    );
    return '$_temp0';
  }

  @override
  String get deleteMoveTrainersFirst =>
      'நீக்கு (முதலில் பயிற்சியாளர்களை மாற்று)';

  @override
  String get giveCategoryAName => 'பிரிவுக்கு ஒரு பெயர் கொடுங்கள்';

  @override
  String get editCategory => 'பிரிவைத் திருத்து';

  @override
  String get newTrainerCategory => 'புதிய பயிற்சியாளர் பிரிவு';

  @override
  String get generalTrainingNote => 'பொதுப் பயிற்சிக்கான வழக்கமான அமைப்பு.';

  @override
  String get personalTrainingNote =>
      'தனிப்பட்ட பயிற்சி: இங்குள்ள பயிற்சியாளர் ஒரு நேரத்தில் ஒரு உறுப்பினரை மட்டுமே எடுப்பார்.';

  @override
  String get addCategory => 'பிரிவைச் சேர்';

  @override
  String get listedPublicly => 'பொதுவில் பட்டியலிடப்பட்டது';

  @override
  String get yourMembersOnly => 'உங்கள் உறுப்பினர்களுக்கு மட்டும்';

  @override
  String get whenDoesItStart => 'இது எப்போது தொடங்குகிறது?';

  @override
  String get chooseStartDateFirst =>
      'முதலில் தொடக்கத் தேதியைத் தேர்வு செய்யுங்கள்.';

  @override
  String get lastDayToRegister => 'பதிவு செய்ய கடைசி நாள்';

  @override
  String get giveTheEventATitle => 'நிகழ்வுக்கு ஒரு தலைப்பு கொடுங்கள்.';

  @override
  String get addADescription =>
      'ஒரு விளக்கம் சேருங்கள், குறைந்தது ஒரு வாக்கியம்.';

  @override
  String get sayHowToTakePart =>
      'பங்கேற்க என்ன செய்ய வேண்டும் என்று எழுதுங்கள்.';

  @override
  String get pickTheDates => 'தேதிகளைத் தேர்வு செய்யுங்கள்.';

  @override
  String startsAtWhen(String when) {
    return '$when தொடங்கும்';
  }

  @override
  String registerByWhen(String when) {
    return '$when க்குள் பதிவு செய்யுங்கள்';
  }

  @override
  String get selectYourLeaveDates =>
      'உங்கள் விடுப்புத் தேதிகளைத் தேர்வு செய்யுங்கள்';

  @override
  String get chooseYourDatesFirst =>
      'முதலில் உங்கள் தேதிகளைத் தேர்வு செய்யுங்கள்.';

  @override
  String get sentForApproval => 'ஒப்புதலுக்கு அனுப்பப்பட்டது.';

  @override
  String get leaveApprovedPaused =>
      'விடுப்பு ஒப்புக்கொள்ளப்பட்டது. அந்த நாட்களுக்கு உங்கள் உறுப்பினர் சேர்க்கை இடைநிறுத்தப்படும்.';

  @override
  String get chooseDates => 'தேதிகளைத் தேர்வு செய்';

  @override
  String leaveDaysLeftCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'உங்களுக்கு $count விடுப்பு நாட்கள் மீதம் உள்ளன.',
    );
    return '$_temp0';
  }

  @override
  String moreThanRemainingDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'இது உங்கள் மீதமுள்ள $count நாட்களை விட அதிகம், எனவே ஒரு மேலாளர் ஒப்புதல் அளிக்க வேண்டும்.',
    );
    return '$_temp0';
  }

  @override
  String get withinYourAllowance =>
      'உங்கள் வரம்பிற்குள் — இது உடனே ஒப்புக்கொள்ளப்படும்.';

  @override
  String get sendForApproval => 'ஒப்புதலுக்கு அனுப்பு';

  @override
  String get enterCodeSentToTheirPhone =>
      'அவரது தொலைபேசிக்கு அனுப்பிய குறியீட்டை உள்ளிடவும்.';

  @override
  String get numberIsNewNameNeeded => 'இந்த எண் புதியது, எனவே ஒரு பெயர் தேவை.';

  @override
  String get chooseARole => 'ஒரு பங்கைத் தேர்வு செய்யுங்கள்.';


  @override
  String get isATrainer => 'Is a trainer?';

  @override
  String get chooseATrainerCategory => 'Choose a trainer category.';

  @override
  String get trainerCategory => 'Trainer category';
  @override
  String get addAMember => 'ஒரு உறுப்பினரைச் சேர்';

  @override
  String get codeSentExistingAccount =>
      'குறியீடு அனுப்பப்பட்டது. இந்த எண்ணுக்கு ஏற்கனவே ஜிமாலஜியா கணக்கு உள்ளது.';

  @override
  String get codeSentNewAccount =>
      'குறியீடு அனுப்பப்பட்டது. இந்த எண் புதியது, எனவே ஒரு கணக்கை உருவாக்குவோம்.';

  @override
  String get membershipLength => 'உறுப்பினர் காலம்';

  @override
  String get leaveDaysAllowed => 'அனுமதிக்கப்பட்ட விடுப்பு நாட்கள்';

  @override
  String get ownerStaffMode => 'உரிமையாளர் / பணியாளர் நிலை';

  @override
  String get memberMode => 'உறுப்பினர் நிலை';

  @override
  String get managingGymsNote =>
      'நீங்கள் கூடங்களை நிர்வகிக்கிறீர்கள். உறுப்பினராக ஜிமாலஜியாவைப் பயன்படுத்த மீண்டும் மாறுங்கள்.';

  @override
  String get openingAGymNote =>
      'கூடம் திறக்கிறீர்களா, அல்லது ஒன்றில் வேலை செய்கிறீர்களா? உங்கள் கூடத்தின் CRM ஐ இயக்க மாறுங்கள் — உறுப்பினர்கள், பணியாளர்கள், வருகை மற்றும் விடுப்பு.';

  @override
  String get numberIsHowYouSignIn =>
      'உங்கள் எண் மூலமே நீங்கள் உள்நுழைகிறீர்கள், எனவே இதை இங்கே இப்போது மாற்ற முடியாது.';

  @override
  String get followingYourDevice => 'உங்கள் சாதனத்தைப் பின்பற்றுகிறது';

  @override
  String get yourGym => 'உங்கள் கூடம்';

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
  String noVisitsInLastDays(int days) {
    return 'கடந்த $days நாட்களில் வருகை பதிவாகவில்லை.';
  }

  @override
  String visitsInLastDays(int count, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'கடந்த $days நாட்களில் $count வருகைகள்.',
    );
    return '$_temp0';
  }

  @override
  String get couldNotLoadEvents => 'நிகழ்வுகளை ஏற்ற முடியவில்லை';

  @override
  String get noEventsOnRightNow => 'இப்போது நிகழ்வுகள் எதுவும் இல்லை';

  @override
  String get eventsAppearHere =>
      'உங்கள் கூடத்தின் நிகழ்வுகள் இங்கே தோன்றும், அருகில் அனைவருக்கும் திறந்தவையும் சேர்த்து.';

  @override
  String get atYourGym => 'உங்கள் கூடத்தில்';

  @override
  String trainerStaffMembersAt(String gym) {
    return '$gym இல் உங்கள் பயிற்சியாளர், பணியாளர்கள், உறுப்பினர்கள்';
  }

  @override
  String get trainerStaffOtherMembers =>
      'உங்கள் பயிற்சியாளர், பணியாளர்கள், மற்ற உறுப்பினர்கள்';

  @override
  String get comingNext => 'அடுத்து வருவது';

  @override
  String get progressChartsAgainstGoal =>
      'உங்கள் இலக்குக்கு எதிரான முன்னேற்ற வரைபடங்கள்';

  @override
  String get leaveLeft => 'மீதி விடுப்பு';

  @override
  String approvedMembershipPauses(String name) {
    return '$name ஒப்புக்கொள்ளப்பட்டது. அந்த நாட்களுக்கு அவரது உறுப்பினர் சேர்க்கை இடைநிறுத்தப்படும்.';
  }

  @override
  String get approveInstead => 'மாறாக ஒப்புக்கொள்';

  @override
  String get declineInstead => 'மாறாக நிராகரி';

  @override
  String get needsYou => 'உங்கள் கவனம் தேவை';

  @override
  String get autoApproved => 'தானாக ஒப்புக்கொள்ளப்பட்டது';

  @override
  String get returnedEarly => 'முன்கூட்டியே திரும்பினார்';

  @override
  String get whereYouAre => 'நீங்கள் எங்கே இருக்கிறீர்கள்';

  @override
  String get enterTheAddress => 'முகவரியை உள்ளிடவும்';

  @override
  String get maximumPerMembership => 'ஒரு உறுப்பினர் சேர்க்கைக்கு அதிகபட்சம்';

  @override
  String removeStaffWithAssigned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'இந்தக் கூடத்திற்கான அணுகலை அவர் இழப்பார், அவருக்கு ஒதுக்கப்பட்ட $count உறுப்பினர்களுக்கு நீங்கள் வேறு ஒருவரை நியமிக்கும் வரை பயிற்சியாளர் இருக்க மாட்டார்.',
    );
    return '$_temp0';
  }

  @override
  String get removeStaffPlain =>
      'இந்தக் கூடத்திற்கான அணுகலை அவர் இழப்பார். அவரது வருகைப் பதிவு வைக்கப்படும்.';

  @override
  String get couldNotLoadGyms => 'கூடங்களை ஏற்ற முடியவில்லை';

  @override
  String get noGymsListedYet => 'இன்னும் கூடங்கள் பட்டியலிடப்படவில்லை';

  @override
  String get gymsAppearOnPro =>
      'கூடங்கள் ப்ரோ திட்டத்தில் இருந்து, பட்டியலிடப்பட விரும்பினால் இங்கே தோன்றும்.';

  @override
  String nothingMatchedTry(String query) {
    return '“$query” க்கு எதுவும் பொருந்தவில்லை. வேறு நகரம் அல்லது மாவட்டத்தை முயற்சிக்கவும்.';
  }

  @override
  String get noRatings => 'மதிப்பீடுகள் இல்லை';

  @override
  String fromRatings(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count மதிப்பீடுகளிலிருந்து',
    );
    return '$_temp0';
  }

  @override
  String get onlyProGymHere => 'இங்குள்ள ஒரே ப்ரோ கூடம்';

  @override
  String ofProGyms(int count) {
    return '$count ப்ரோ கூடங்களில்';
  }

  @override
  String get couldNotLoadYourGyms => 'உங்கள் கூடங்களை ஏற்ற முடியவில்லை';

  @override
  String get noGymsYet => 'இன்னும் கூடங்கள் இல்லை';

  @override
  String get createYourGymBlurb =>
      'உறுப்பினர்கள், பணியாளர்கள், வருகை, விடுப்பு அமைக்க உங்கள் கூடத்தை உருவாக்குங்கள். ஒரு கூடத்தில் வேலை செய்தால், உரிமையாளரிடம் சேர்க்கச் சொல்லுங்கள், அது இங்கே தோன்றும்.';

  @override
  String newGroupSelected(int count) {
    return 'புதிய குழு ($count தேர்வு)';
  }

  @override
  String get newMessage => 'புதிய செய்தி';

  @override
  String get oneToOne => 'தனிப்பட்ட உரையாடல்';

  @override
  String get group => 'குழு';

  @override
  String get buildMuscle => 'தசை வளர்';

  @override
  String get loseFat => 'கொழுப்பைக் குறை';

  @override
  String get getStronger => 'வலிமை பெறு';

  @override
  String get officialGroupEmpty =>
      'இந்தக் கூடத்தில் உள்ள அனைவரும். இன்னும் எதுவும் சொல்லப்படவில்லை.';

  @override
  String get unofficialGroupEmpty =>
      'உறுப்பினர்கள் மட்டும். இன்னும் எதுவும் சொல்லப்படவில்லை.';

  @override
  String get noMessagesYet => 'இன்னும் செய்திகள் இல்லை';

  @override
  String get approved => 'ஒப்புக்கொள்ளப்பட்டது';

  @override
  String get declined => 'நிராகரிக்கப்பட்டது';

  @override
  String get cancelled => 'ரத்து செய்யப்பட்டது';

  @override
  String get flexibility => 'நெகிழ்வுத்தன்மை';

  @override
  String get rehab => 'மறுவாழ்வு';

  @override
  String get youPrefix => 'நீங்கள்: ';

  @override
  String get active => 'செயலில்';

  @override
  String get joined => 'சேர்ந்தவர்';

  @override
  String get leftCount => 'விலகியவர்';

  @override
  String get net => 'நிகர';

  @override
  String get daily => 'தினசரி';

  @override
  String get monthly => 'மாதாந்திர';

  @override
  String get yearly => 'ஆண்டுதோறும்';

  @override
  String get add => 'சேர்';

  @override
  String get update => 'புதுப்பி';

  @override
  String get required => 'தேவை';

  @override
  String get contact => 'தொடர்பு';

  @override
  String get owner => 'உரிமையாளர்';

  @override
  String get support => 'ஆதரவு';

  @override
  String get machineTranslatedExercise =>
      'இந்த வழிமுறைகள் இயந்திரத்தால் மொழிபெயர்க்கப்பட்டவை, பயிற்சியாளர் சரிபார்க்கவில்லை. ஏதேனும் விநோதமாகத் தோன்றினால், எடை தூக்கும் முன் ஆங்கிலத்திற்கு மாறிச் சரிபாருங்கள்.';

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
  String get findAGym => 'உடற்பயிற்சி கூடம் தேடு';

  @override
  String get searchGyms => 'பெயர் அல்லது பகுதி மூலம் தேடு';

  @override
  String get perks => 'வசதிகள்';

  @override
  String get rating => 'மதிப்பீடு';

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
  String get checkInDue => 'இந்த மாத பதிவு நிலுவையில்';

  @override
  String get thisMonth => 'இந்த மாதம்';

  @override
  String get perWeek => 'வாரத்திற்கு';

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
  String get onLeave => 'விடுப்பில்';

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
  String get needsReview => 'மொழிபெயர்ப்பு மதிப்பாய்வு நிலுவையில்';

  @override
  String get block => 'தடு';

  @override
  String get unblock => 'தடையை நீக்கு';

  @override
  String get report => 'புகாரளி';

  @override
  String blockPerson(String name) {
    return '$name ஐத் தடு';
  }

  @override
  String reportPerson(String name) {
    return '$name மீது புகாரளி';
  }

  @override
  String get blockConfirmBody =>
      'அவர்களால் உங்களுக்குச் செய்தி அனுப்ப முடியாது, அவர்களின் செய்திகளும் உங்களுக்குத் தெரியாது. நீங்கள் தடுத்ததை அவர்களிடம் சொல்லப்படாது. அமைப்புகளில் இதை மாற்றலாம்.';

  @override
  String get blocked => 'தடுக்கப்பட்டது';

  @override
  String get blockedAccounts => 'தடுக்கப்பட்ட கணக்குகள்';

  @override
  String get noBlockedAccounts => 'நீங்கள் யாரையும் தடுக்கவில்லை.';

  @override
  String get safetyAndPrivacy => 'பாதுகாப்பு';

  @override
  String unblockQuestion(String name) {
    return '$name மீதான தடையை நீக்கவா?';
  }

  @override
  String get unblockExplainer =>
      'அவர்கள் மீண்டும் உங்களுக்குச் செய்தி அனுப்ப முடியும்.';

  @override
  String get whyReporting => 'என்ன பிரச்சினை?';

  @override
  String get reportDetails => 'என்ன நடந்தது?';

  @override
  String get reportDetailsHint =>
      'மதிப்பாய்வாளர்கள் செய்தியைப் பார்ப்பதில்லை. உங்கள் விளக்கத்தைத்தான் அவர்கள் படிப்பார்கள், எனவே என்ன சொல்லப்பட்டது என்பதை உங்கள் சொற்களில் கூறுங்கள்.';

  @override
  String get alsoBlockThem => 'அவர்களைத் தடுக்கவும் செய்';

  @override
  String get alsoBlockThemExplainer =>
      'புகாரை ஒருவர் படிப்பார், அதற்கு நேரம் ஆகும். தடுப்பது உடனடியாகச் செயல்படும்.';

  @override
  String get sendReport => 'புகாரை அனுப்பு';

  @override
  String get reportCategorySpam => 'ஸ்பேம் அல்லது தேவையற்ற விற்பனை';

  @override
  String get reportCategoryHarassment => 'தொந்தரவு அல்லது மிரட்டல்';

  @override
  String get reportCategorySexual => 'பாலியல் அல்லது ஆபாச உள்ளடக்கம்';

  @override
  String get reportCategoryHate => 'வெறுப்புப் பேச்சு';

  @override
  String get reportCategoryViolence => 'வன்முறை அல்லது அச்சுறுத்தல்';

  @override
  String get reportCategoryScam => 'மோசடி அல்லது ஏமாற்று';

  @override
  String get reportCategoryImpersonation => 'வேறு ஒருவராக நடிப்பது';

  @override
  String get reportCategoryOther => 'வேறு ஏதாவது';

  @override
  String get reportSent => 'நன்றி. யாராவது இதைப் பரிசீலிப்பார்கள்.';

  @override
  String get myReports => 'நான் அனுப்பிய புகார்கள்';

  @override
  String get reportStatusOpen => 'பரிசீலனைக்குக் காத்திருக்கிறது';

  @override
  String get reportStatusReviewing => 'பார்க்கப்படுகிறது';

  @override
  String get reportStatusActioned => 'நடவடிக்கை எடுக்கப்பட்டது';

  @override
  String get reportStatusDismissed => 'பரிசீலிக்கப்பட்டது, நடவடிக்கை இல்லை';

  @override
  String get noReportsSent => 'நீங்கள் யார் மீதும் புகார் அளிக்கவில்லை.';

  @override
  String get deleteAccount => 'கணக்கை நீக்கு';

  @override
  String get deleteAccountIntro =>
      'உங்கள் கணக்கு 30 நாட்கள் வரை பயன்படுத்தக்கூடியதாக இருக்கும். அதன் பிறகு அது நீக்கப்படும், திரும்பப் பெற முடியாது.';

  @override
  String get whatIsDeleted => 'எவை நீக்கப்படும்';

  @override
  String get whatIsDeletedList =>
      'உங்கள் பெயர், எண், மின்னஞ்சல், வயது. உயரம், எடை, முன்னேற்றம். உங்கள் அரட்டைச் செய்திகள். அடையாள ஆவணங்கள், UPI விவரங்கள்.';

  @override
  String get whatIsKept => 'எவை வைக்கப்படும், உங்கள் அடையாளம் நீக்கப்பட்டு';

  @override
  String get whatIsKeptList =>
      'பணம் மற்றும் விலைப்பட்டியல் பதிவுகள், கணக்குப் புத்தகங்களை வைத்திருக்கச் சட்டம் கோருவதால். ஜிம்மில் எடுக்கப்பட்ட நடவடிக்கைகளின் பதிவு, தகராறுகளைத் தீர்க்க.';

  @override
  String get deleteGymsFirst =>
      'உங்களிடம் இன்னும் ஒரு ஜிம் உள்ளது. முதலில் அதை நீக்குங்கள் — உங்கள் கணக்கை நீக்கினால் அதிலுள்ள ஒவ்வொரு உறுப்பினரும் ஊழியரும் அணுகலை இழப்பார்கள், மேலும் அது மூடப்பட்டது என்று அவர்களுக்குத் தெரிவிக்கப்படும்.';

  @override
  String unwithdrawnWarning(String amount) {
    return 'நீங்கள் எடுக்காத $amount பரிந்துரை வருமானம் உள்ளது. முதலில் Gymologia Referral செயலியில் எடுத்துக்கொள்ளுங்கள், இல்லையெனில் அது போய்விடும்.';
  }

  @override
  String get iUnderstandLoseEarnings =>
      'இந்தப் பணத்தை இழப்பேன் என்பதை நான் புரிந்துகொள்கிறேன்';

  @override
  String deletionScheduled(String date) {
    return 'உங்கள் கணக்கு $date அன்று நீக்கப்படும்.';
  }

  @override
  String get keepMyAccount => 'என் கணக்கை வைத்திருங்கள்';

  @override
  String get deletionCancelled => 'உங்கள் கணக்கு நீக்கப்படாது.';

  @override
  String get deleteAccountConfirm => 'என் கணக்கை நீக்கு';
}
