// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appName => 'Gymologia';

  @override
  String get languageName => 'বাংলা';

  @override
  String get settings => 'সেটিংস';

  @override
  String get language => 'ভাষা';

  @override
  String get languageSubtitle =>
      'যে ভাষায় আপনি সবচেয়ে স্বচ্ছন্দে পড়েন সেটি বেছে নিন';

  @override
  String get save => 'সংরক্ষণ';

  @override
  String get cancel => 'বাতিল';

  @override
  String get tryAgain => 'আবার চেষ্টা করুন';

  @override
  String get somethingWentWrong => 'কিছু ভুল হয়েছে';

  @override
  String get phoneNumber => 'মোবাইল নম্বর';

  @override
  String get enterPhoneNumber => 'আপনার মোবাইল নম্বর দিন';

  @override
  String get sendCode => 'কোড পাঠান';

  @override
  String get verifyCode => 'যাচাই করুন';

  @override
  String get resendCode => 'আবার পাঠান';

  @override
  String get createAccount => 'আপনার অ্যাকাউন্ট তৈরি করুন';

  @override
  String get emailOptional => 'ইমেল (ঐচ্ছিক)';

  @override
  String get age => 'বয়স';

  @override
  String get whyAgeNotBirthday =>
      'আমরা আপনার বয়স জানতে চাই, জন্মতারিখ নয়। জন্মতারিখ আপনার ব্যাংক ও সরকারি নথির সঙ্গে যুক্ত — জিম অ্যাপের জন্য বয়সই যথেষ্ট।';

  @override
  String get termsAgreement =>
      'অ্যাকাউন্ট তৈরি করার অর্থ আপনি ব্যবহারের শর্তাবলী ও গোপনীয়তা নীতি মেনে নিচ্ছেন।';

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
  String get signInWithMobile => 'আপনার মোবাইল নম্বর দিয়ে সাইন ইন করুন';

  @override
  String get mobileNumber => 'মোবাইল নম্বর';

  @override
  String get couldNotSendCode => 'কোড পাঠানো যায়নি।';

  @override
  String get verificationFailed => 'যাচাই ব্যর্থ হয়েছে।';

  @override
  String get couldNotResendCode => 'কোড আবার পাঠানো যায়নি।';

  @override
  String get couldNotCreateAccount => 'আপনার অ্যাকাউন্ট তৈরি করা যায়নি।';

  @override
  String weSentCodeTo(String phone) {
    return 'আমরা $phone নম্বরে কোড পাঠিয়েছি';
  }

  @override
  String resendInSeconds(int seconds) {
    return '$seconds সেকেন্ডে আবার পাঠান';
  }

  @override
  String get verified => 'যাচাই করা হয়েছে';

  @override
  String get createAccountAction => 'অ্যাকাউন্ট তৈরি করুন';

  @override
  String get supportSent => 'পাঠানো হয়েছে। আপনার দেওয়া নম্বরে উত্তর আসবে।';

  @override
  String get supportSubject => 'এটি কী নিয়ে?';

  @override
  String get supportSubjectHint => 'আমার সদস্যপদের দিন ভুল দেখাচ্ছে';

  @override
  String get supportMessage => 'কী হয়েছে বলুন';

  @override
  String get supportReplyTo => 'আমরা কোথায় উত্তর দেব?';

  @override
  String get supportUrgent => 'এতে আমার জিম চালানো যাচ্ছে না';

  @override
  String get supportUrgentNote => 'অগ্রাধিকার বাড়ায়।';

  @override
  String copiedToClipboard(String value) {
    return '$value কপি হয়েছে';
  }

  @override
  String orEmailUs(String email) {
    return 'অথবা $email এ ইমেল করুন';
  }

  @override
  String get whatYouHaveAsked => 'আপনি যা জিজ্ঞাসা করেছেন';

  @override
  String get aFewWordsIsEnough => 'কয়েকটি শব্দই যথেষ্ট';

  @override
  String get aSentenceOrTwoHelps => 'এক-দুই বাক্য লিখলে দ্রুত সমাধান হয়';

  @override
  String get ticketOpen => 'কেউ হাতে নেওয়ার অপেক্ষায়';

  @override
  String get ticketInProgress => 'কেউ এটি দেখছেন';

  @override
  String get ticketWaitingOnUser => 'আপনার উত্তরের অপেক্ষায়';

  @override
  String get ticketResolved => 'সমাধান হয়েছে';

  @override
  String get ticketClosed => 'বন্ধ';

  @override
  String get referralPitch =>
      'কোড শেয়ার করুন, আর কোনো জিম মালিক সাবস্ক্রিপশন নিলে আয় করুন। রেফারেল অ্যাপ এখনও আসেনি।';

  @override
  String get appTagline => 'জিমোলজিয়া · সদস্য ও স্টাফ';

  @override
  String get signOutQuestion => 'সাইন আউট করবেন?';

  @override
  String get signOutWarning => 'আবার সাইন ইন করতে আপনার ফোন লাগবে।';

  @override
  String get profileUpdated => 'প্রোফাইল আপডেট হয়েছে।';

  @override
  String get yourProfile => 'আপনার প্রোফাইল';

  @override
  String get emailClearToRemove => 'ঐচ্ছিক। মুছতে খালি করে দিন।';

  @override
  String get phoneIsYourLogin =>
      'এটি দিয়েই আপনি সাইন ইন করেন, তাই এখানে এখনই বদলানো যায় না। বদলাতে হলে সহায়তায় যোগাযোগ করুন।';

  @override
  String get trialStarted =>
      'ট্রায়াল শুরু হয়েছে। আপনার জিম এখন সার্চে দেখা যাচ্ছে।';

  @override
  String get invalidCode => 'কোডটি সঠিক নয়।';

  @override
  String get paymentNotCompletedYet =>
      'পেমেন্ট এখনও সম্পূর্ণ হয়নি। একটু পরে টেনে রিফ্রেশ করুন।';

  @override
  String planIsActive(String plan) {
    return '$plan প্ল্যান চালু আছে।';
  }

  @override
  String get paymentNotCompleted => 'পেমেন্ট সম্পূর্ণ হয়নি।';

  @override
  String get couldNotOpenPayment => 'পেমেন্ট স্ক্রিন খোলা যায়নি।';

  @override
  String daysFree(int days) {
    return '$days দিন বিনামূল্যে';
  }

  @override
  String get trialBlurb =>
      'সম্পূর্ণ প্রো, সদস্য সার্চে আপনার তালিকাভুক্তি সহ। কার্ড লাগবে না, আর এটি নিজে থেকে কোনো পেইড প্ল্যানে বদলায় না।';

  @override
  String get startFreeTrial => 'বিনামূল্যে ট্রায়াল শুরু করুন';

  @override
  String get referralCode => 'রেফারেল কোড';

  @override
  String get optional => 'ঐচ্ছিক';

  @override
  String get apply => 'প্রয়োগ করুন';

  @override
  String get gstNote =>
      'দামে জিএসটি ধরা আছে। জিম কেবল প্রো প্ল্যানেই সদস্য সার্চে দেখা যায়।';

  @override
  String planNamed(String plan) {
    return '$plan প্ল্যান';
  }

  @override
  String get trialBadge => 'ট্রায়াল';

  @override
  String get expired => 'মেয়াদ শেষ';

  @override
  String daysRemainingPlan(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count দিন বাকি',
    );
    return '$_temp0';
  }

  @override
  String get listedInSearch => 'সদস্য সার্চে তালিকাভুক্ত';

  @override
  String get notListedUpgrade => 'সার্চে নেই — দেখাতে হলে প্রো-তে আপগ্রেড করুন';

  @override
  String get trialEndsNote =>
      'ট্রায়াল শেষ হলে আপনি প্ল্যান না নেওয়া পর্যন্ত জিম সার্চ থেকে সরে যায়। নিজে থেকে কিছু কাটা হয় না।';

  @override
  String get getsYouListed => 'সার্চে জায়গা দেয়';

  @override
  String get perMonth => '/মাস';

  @override
  String choosePlanNamed(String plan) {
    return '$plan বেছে নিন';
  }

  @override
  String get deleteRoleWarning =>
      'ভূমিকা ও তার অনুমতিগুলি চলে যাবে। এতে কেউ নেই, তাই কারও অ্যাক্সেস যাবে না।';

  @override
  String deletedNamed(String name) {
    return '$name মুছে ফেলা হয়েছে';
  }

  @override
  String get needTwoCustomRoles =>
      'ক্রম বদলানোর আগে আপনার এমন দুটি কাস্টম ভূমিকা লাগবে যা আপনি সম্পাদনা করতে পারেন।';

  @override
  String get hierarchySaved => 'ক্রম সংরক্ষিত হয়েছে';

  @override
  String get reorder => 'ক্রম বদলান';

  @override
  String get newRole => 'নতুন ভূমিকা';

  @override
  String get rolesIntro =>
      'সবচেয়ে জ্যেষ্ঠ প্রথমে। আপনি কেবল নিজের নিচের ভূমিকাগুলি সম্পাদনা করতে পারেন, আর কেবল নিজের কাছে থাকা অনুমতিই দিতে পারেন।';

  @override
  String get defaultBadge => 'ডিফল্ট';

  @override
  String get everyPermission => 'প্রতিটি অনুমতি, পরে যোগ হওয়া সহ';

  @override
  String permissionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count অনুমতি',
    );
    return '$_temp0';
  }

  @override
  String get nobodyInThisRole => 'এই ভূমিকায় কেউ নেই';

  @override
  String peopleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count জন',
    );
    return '$_temp0';
  }

  @override
  String get deleteDefaultRolesStay => 'মুছুন (ডিফল্ট ভূমিকা থেকে যায়)';

  @override
  String get deleteMovePeopleFirst => 'মুছুন (আগে লোকজন সরান)';

  @override
  String get giveRoleAName => 'ভূমিকাটির একটি নাম দিন';

  @override
  String get editRole => 'ভূমিকা সম্পাদনা';

  @override
  String get createRole => 'ভূমিকা তৈরি করুন';

  @override
  String get roleName => 'ভূমিকার নাম';

  @override
  String get roleNameHint => 'রিসেপশন, ফিজিও, নাইট শিফট';

  @override
  String get superRoleNote =>
      'এই ভূমিকার কাছে সব অনুমতি আছে, ভবিষ্যতে যোগ হওয়া সহ। এটি সীমিত করা যায় না — এ কারণেই এটি সব সময় সমস্যা মেটাতে পারে।';

  @override
  String get whatThisRoleCanDo => 'এই ভূমিকা কী করতে পারে';

  @override
  String get greyedOutNote =>
      'যা ধূসর দেখাচ্ছে তা আপনার নিজের কাছে নেই, তাই সেটি আপনি দিতে পারবেন না।';

  @override
  String get ownerOnlyPermission => 'এটি কেবল জিম মালিকের';

  @override
  String get youDoNotHoldThis => 'এটি আপনার কাছে নেই';

  @override
  String get orderTheHierarchy => 'ক্রম ঠিক করুন';

  @override
  String get hierarchyNote =>
      'সবচেয়ে জ্যেষ্ঠ উপরে। ডিফল্ট ভূমিকাগুলি নিজের জায়গায় থাকে এবং এখানে দেখা যায় না।';

  @override
  String get saveOrder => 'ক্রম সংরক্ষণ করুন';

  @override
  String membershipExtendedBy(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'সদস্যপদ $count মাস বাড়ানো হয়েছে।',
    );
    return '$_temp0';
  }

  @override
  String get goalUpdated => 'লক্ষ্য আপডেট হয়েছে।';

  @override
  String get thisMember => 'এই সদস্য';

  @override
  String get removeMemberQuestion => 'সদস্য সরাবেন?';

  @override
  String removeMemberWarning(String name) {
    return '$name এই জিমে আর ঢুকতে পারবেন না। তাঁর উপস্থিতির রেকর্ড ও মাপ রাখা থাকে।';
  }

  @override
  String get member => 'সদস্য';

  @override
  String get removeMember => 'সদস্য সরান';

  @override
  String get daysLeft => 'বাকি দিন';

  @override
  String get leaveUsed => 'নেওয়া ছুটি';

  @override
  String get extend => 'বাড়ান';

  @override
  String get editGoal => 'লক্ষ্য সম্পাদনা';

  @override
  String get goal => 'লক্ষ্য';

  @override
  String get notSet => 'নির্ধারিত নয়';

  @override
  String get noneAssigned => 'কেউ নিযুক্ত নন';

  @override
  String get attendanceHistory => 'উপস্থিতির ইতিহাস';

  @override
  String get viewAndCorrectRecords => 'রেকর্ড দেখুন ও ঠিক করুন';

  @override
  String sessionsSoFar(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'এ পর্যন্ত $count সেশন',
    );
    return '$_temp0';
  }

  @override
  String get progressIsPrivate => 'অগ্রগতি ব্যক্তিগত';

  @override
  String get monitoringOffNote =>
      'এই সদস্য অগ্রগতি পর্যবেক্ষণ বন্ধ করেছেন। এটি তাঁর সিদ্ধান্ত এবং কোনো ভূমিকা তা বদলাতে পারে না।';

  @override
  String get progress => 'অগ্রগতি';

  @override
  String get noMeasurementsYet =>
      'এখনও কোনো মাপ নথিভুক্ত হয়নি। সদস্যকে তাঁর নিজের অ্যাপে মাসে একবার এটি জিজ্ঞাসা করা হয়।';

  @override
  String holdingAtKg(String kg) {
    return '$kg কেজিতে স্থির';
  }

  @override
  String weightChangeSince(String delta) {
    return 'প্রথম মাপের পর থেকে $delta কেজি';
  }

  @override
  String get extendMembership => 'সদস্যপদ বাড়ান';

  @override
  String get extendFromTodayNote =>
      'মেয়াদ শেষ হওয়া সদস্যপদ আজ থেকে বাড়ে, যেদিন শেষ হয়েছিল সেদিন থেকে নয়।';

  @override
  String monthsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count মাস',
    );
    return '$_temp0';
  }

  @override
  String extendByMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count মাস বাড়ান',
    );
    return '$_temp0';
  }

  @override
  String get whatAreTheyWorkingTowards => 'তিনি কোন লক্ষ্যে কাজ করছেন?';

  @override
  String get goalDialogHint => '৮০ কেজি পর্যন্ত বাল্ক, ওজন কমানো, রিহ্যাব…';

  @override
  String signedUpCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count জন নাম লিখিয়েছেন',
    );
    return '$_temp0';
  }

  @override
  String get nobodyYet => 'এখনও কেউ নেই।';

  @override
  String get hostAnEvent => 'একটি ইভেন্ট আয়োজন করুন';

  @override
  String get noEventsYet =>
      'এখনও কোনো ইভেন্ট নেই। একটি আয়োজন করুন, সেটি আপনার সদস্যদের সঙ্গে সঙ্গে দেখা যাবে।';

  @override
  String get editEvent => 'ইভেন্ট সম্পাদনা করুন';

  @override
  String get cancelEvent => 'ইভেন্ট বাতিল করুন';

  @override
  String get cancelEventConfirmTitle => 'এই ইভেন্টটি বাতিল করবেন?';

  @override
  String get cancelEventConfirmBody =>
      'এটি ইভেন্টটি স্থায়ীভাবে মুছে ফেলবে, নিবন্ধিতদের তালিকাসহ। এটি ফিরিয়ে আনা যাবে না।';

  @override
  String get keepEvent => 'ইভেন্ট রাখুন';

  @override
  String get eventUpdated => 'ইভেন্ট আপডেট হয়েছে';

  @override
  String get eventCancelledSnackbar => 'ইভেন্ট মুছে ফেলা হয়েছে';

  @override
  String get eventTitleHint => 'সামার ডেডলিফট মিট';

  @override
  String get howToTakePart => 'কীভাবে অংশ নেবেন';

  @override
  String get howToTakePartHint => 'সকাল ৮টায় ওজন। নিজের বেল্ট আনুন।';

  @override
  String get prizeOptional => 'পুরস্কার (ঐচ্ছিক)';

  @override
  String get prizeHint => '₹10,000';

  @override
  String get membersCanSignUp => 'সদস্যরা অ্যাপে নাম লেখাতে পারেন';

  @override
  String get membersCanSignUpNote =>
      'বন্ধ করলে তাঁরা বোতামের বদলে আপনার শর্তগুলি দেখবেন।';

  @override
  String get listPublicly => 'সর্বসাধারণে দেখান';

  @override
  String get listPubliclyNote => 'সারা দেশের ইভেন্ট ফিডে দেখা যায়।';

  @override
  String get listPubliclyProOnly =>
      'কেবল প্রো প্ল্যানে। আপনার সদস্যরা তবুও দেখতে পাবেন।';

  @override
  String get openToOutsiders => 'আপনার জিমের বাইরের মানুষদের জন্যও খোলা';

  @override
  String get publishEvent => 'ইভেন্ট প্রকাশ করুন';

  @override
  String get registrationOpen => 'নিবন্ধন খোলা';

  @override
  String get registrationClosed => 'নিবন্ধন বন্ধ';

  @override
  String get close => 'বন্ধ করুন';

  @override
  String get markAllRead => 'সব পঠিত চিহ্নিত করুন';

  @override
  String get nothingYet => 'এখনও কিছু নেই';

  @override
  String get announcementsAppearHere =>
      'আপনার জিম ও জিমোলজিয়ার ঘোষণা এখানে দেখা যাবে।';

  @override
  String get searchPeople => 'মানুষ খুঁজুন';

  @override
  String get nobodyElseHereYet => 'এখানে এখনও আর কেউ নেই।';

  @override
  String get nameTheGroup => 'গ্রুপের নাম দিন';

  @override
  String get groupNameHint => 'শনিবার সকালের দল';

  @override
  String get create => 'তৈরি করুন';

  @override
  String get pickWhoIsInTheGroup => 'গ্রুপে কে থাকবে বেছে নিন';

  @override
  String createGroupWith(int count) {
    return '$count জনকে নিয়ে গ্রুপ তৈরি করুন';
  }

  @override
  String get termsOfUse => 'ব্যবহারের শর্তাবলি';

  @override
  String get privacy => 'গোপনীয়তা';

  @override
  String versionUpdated(String version, String date) {
    return 'সংস্করণ $version · আপডেট $date';
  }

  @override
  String sessionsAttendedAllTime(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'সেশন, সব মিলিয়ে',
    );
    return '$_temp0';
  }

  @override
  String get nothingInLast60Days => 'গত ৬০ দিনে কিছু নথিভুক্ত হয়নি।';

  @override
  String correctedReason(String reason) {
    return 'সংশোধিত: $reason';
  }

  @override
  String get noReasonGiven => 'কোনো কারণ দেওয়া হয়নি';

  @override
  String get keptWithRecordAuditNote =>
      'এটি রেকর্ডের সঙ্গে রাখা হয় এবং অডিট লগে দেখা যায়।';

  @override
  String get staffBadge => 'স্টাফ';

  @override
  String roleHiddenNote(String role) {
    return 'এখানে আপনি $role। আপনার ভূমিকা যা করতে পারে না তা দেখিয়ে বারণ করার বদলে লুকিয়ে রাখা হয়।';
  }

  @override
  String engagedOfActive(int engaged, int total) {
    return '$total জনের মধ্যে $engaged জন সদস্য অন্তত একবার অনুশীলন করেছেন।';
  }

  @override
  String announceGoesTo(String audience) {
    return 'এটি এখনই $audience কাছে যাবে, আর ফিরিয়ে নেওয়া যাবে না।';
  }

  @override
  String get audienceEveryMember => 'প্রত্যেক সদস্য';

  @override
  String get audienceEveryStaff => 'প্রত্যেক স্টাফ';

  @override
  String get audienceEveryone => 'এই জিমের সবাই';

  @override
  String sentToPeople(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count জনকে পাঠানো হয়েছে।',
    );
    return '$_temp0';
  }

  @override
  String recipientCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count প্রাপক',
    );
    return '$_temp0';
  }

  @override
  String get weTextACodeFirst =>
      'আমরা প্রথমে তাঁর নম্বরে একটি কোড পাঠাই, যাতে বোঝা যায় নম্বরটি সত্যিই তাঁর।';

  @override
  String get memberCanUpdateMetrics =>
      'তাঁরা সদস্য অ্যাপে নিজের ওজন ও উচ্চতা দেখতে ও বদলাতে পারেন। নিজে বন্ধ না করলে তাঁদের অগ্রগতি স্টাফ দেখতে পান।';

  @override
  String get noRolesYouCanAssign =>
      'আপনি কোনো ভূমিকা দিতে পারবেন না। কেবল নিজের নিচের ভূমিকাগুলিই দেওয়া যায়।';

  @override
  String get noRolesYouCanAssignToThem =>
      'আপনি তাঁকে কোনো ভূমিকা দিতে পারবেন না।';

  @override
  String heightCm(String cm) {
    return 'উচ্চতা $cm সেমি';
  }

  @override
  String weightOverCheckIns(String delta, int count) {
    return '$count বার মাপে $delta কেজি';
  }

  @override
  String get useDeviceLanguage => 'ডিভাইসের ভাষা ব্যবহার করুন';

  @override
  String get untranslatedFallbackNote =>
      'যা এখনও অনূদিত হয়নি তা খালি না রেখে ইংরেজিতে দেখানো হয়, যাতে আংশিক অনূদিত ভাষাও ব্যবহারযোগ্য থাকে।';

  @override
  String deleteGymWarning(int members, int staff) {
    return 'সব $members সদস্য ও $staff স্টাফের অ্যাক্সেস চলে যাবে। অ্যাপ থেকে এটি ফেরানো যায় না।';
  }

  @override
  String shownAsInSearch(String name, String district) {
    return 'সার্চে “$name - $district” হিসেবে দেখা যাবে।';
  }

  @override
  String get nothingWaitingLeave =>
      'কিছু অপেক্ষায় নেই। আপনার সীমার মধ্যের অনুরোধ স্বয়ংক্রিয়ভাবে অনুমোদিত হয় এবং এখানে আসে না।';

  @override
  String get quietPeriodsNote =>
      'শান্ত সময়গুলি বাদ না দিয়ে খালি বার হিসেবে দেখানো হয়, তাই বারে ফাঁক মানে সত্যিকারের ফাঁক।';

  @override
  String get rankingExplainer =>
      'অবস্থান সেই একই নিয়মে বার করা হয় যেভাবে সার্চ ফল সাজায়: আগে রেটিং, তারপর কতগুলি রেটিং তাকে সমর্থন করে। এখানে যা দেখছেন, সদস্যও তাই দেখবেন।';

  @override
  String get deleteTrainerCategoryWarning =>
      'এই বিভাগে আর প্রশিক্ষক রাখা যাবে না। যাঁরা আগে থেকে আছেন, তাঁদের দায়িত্ব থাকবে।';

  @override
  String get youLabel => 'আপনি';

  @override
  String get openEvents => 'খোলা ইভেন্ট';

  @override
  String get nothingHereYetSaySomething => 'এখানে এখনও কিছু নেই। কিছু বলুন।';

  @override
  String get leavePausesMembership =>
      'আপনি না থাকলে সদস্যপদ থেমে থাকে, তাই যে দিনগুলির জন্য টাকা দিয়েছেন সেগুলি থাকে।';

  @override
  String get notListedUntilPlan =>
      'প্ল্যান চালু না হওয়া পর্যন্ত সর্বসাধারণে দেখা যাবে না।';

  @override
  String gymsListedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count জিম তালিকাভুক্ত',
    );
    return '$_temp0';
  }

  @override
  String get checkInGoalNote =>
      'আপনার জিম এটি দিয়ে আপনার লক্ষ্যের দিকে অগ্রগতি দেখে।';

  @override
  String get enterYourGymName => 'আপনার জিমের নাম লিখুন';

  @override
  String get sessionExpiredSignIn =>
      'আপনার সেশন শেষ হয়েছে। আবার সাইন ইন করুন।';

  @override
  String get somethingWentWrongTryAgain =>
      'কিছু একটা ভুল হয়েছে। আবার চেষ্টা করুন।';

  @override
  String get serverTookTooLong =>
      'সার্ভার উত্তর দিতে অনেক সময় নিয়েছে। সংযোগ দেখে আবার চেষ্টা করুন।';

  @override
  String get couldNotReachServer =>
      'সার্ভারে পৌঁছানো যায়নি। আপনার ইন্টারনেট সংযোগ দেখুন।';

  @override
  String get certificateNotVerified =>
      'সার্ভারের সার্টিফিকেট যাচাই করা যায়নি।';

  @override
  String get networkErrorTryAgain => 'নেটওয়ার্ক সমস্যা। আবার চেষ্টা করুন।';

  @override
  String get enterValidMobile => '১০ সংখ্যার সঠিক ভারতীয় মোবাইল নম্বর লিখুন';

  @override
  String get enterValidTenDigitNumber => '১০ সংখ্যার সঠিক নম্বর লিখুন';

  @override
  String get enterYourName => 'আপনার নাম লিখুন';

  @override
  String get nameTooLong => 'নামটি খুব লম্বা';

  @override
  String get enterValidEmail => 'সঠিক ইমেল ঠিকানা লিখুন';

  @override
  String get enterYourAge => 'আপনার বয়স লিখুন';

  @override
  String get mustBeAtLeast13 => 'আপনার বয়স অন্তত ১৩ হতে হবে';

  @override
  String get enterValidAge => 'সঠিক বয়স লিখুন';

  @override
  String get enterWeightOrHeight => 'ওজন বা উচ্চতা লিখুন।';

  @override
  String get noRatingsYet => 'এখনও কোনো রেটিং নেই';

  @override
  String get giveItATitle => 'একটি শিরোনাম দিন।';

  @override
  String get sayWhatYouWantThemToKnow => 'আপনি তাঁদের কী জানাতে চান লিখুন।';

  @override
  String get sayWhyThisIsChanging => 'কেন এটি বদলানো হচ্ছে লিখুন।';

  @override
  String get noMembersYetAddFirst =>
      'এখনও কোনো সদস্য নেই। প্রথম জনকে যোগ করুন।';

  @override
  String get nobodyMatchedSearch => 'সেই সার্চে কাউকে পাওয়া যায়নি।';

  @override
  String get turningUp => 'উপস্থিতি';

  @override
  String get justNow => 'এইমাত্র';

  @override
  String minutesAgo(int count) {
    return '$count মিনিট আগে';
  }

  @override
  String hoursAgo(int count) {
    return '$count ঘণ্টা আগে';
  }

  @override
  String daysAgo(int count) {
    return '$count দিন আগে';
  }

  @override
  String monthsAgo(int count) {
    return '$count মাস আগে';
  }

  @override
  String get nowShort => 'এখন';

  @override
  String minutesShort(int count) {
    return '$count মি';
  }

  @override
  String hoursShort(int count) {
    return '$count ঘ';
  }

  @override
  String daysShort(int count) {
    return '$count দি';
  }

  @override
  String weeksShort(int count) {
    return '$count সপ্';
  }

  @override
  String addedNamed(String name) {
    return '$name যোগ হয়েছে';
  }

  @override
  String get saved => 'সংরক্ষিত';

  @override
  String get trainerCategoriesIntro =>
      'প্রশিক্ষক যোগ করার সময় তাঁকে এর একটিতে রাখা হয়। যে বিভাগে প্রশিক্ষক আছেন, তাঁদের সরানোর আগে সেটি মোছা যায় না।';

  @override
  String get trainerCategoriesReadOnly =>
      'আপনি এই জিমের বিভাগগুলি দেখতে পারেন। বদলাতে হলে প্রশিক্ষক-ব্যবস্থাপনার অনুমতি লাগে।';

  @override
  String get oneTrainerManyMembersShort => 'একজন প্রশিক্ষক, অনেক সদস্য';

  @override
  String get oneMemberPerTrainer => 'প্রতি প্রশিক্ষকে একজন সদস্য';

  @override
  String get noTrainers => 'কোনো প্রশিক্ষক নেই';

  @override
  String trainerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count প্রশিক্ষক',
    );
    return '$_temp0';
  }

  @override
  String get deleteMoveTrainersFirst => 'মুছুন (আগে প্রশিক্ষক সরান)';

  @override
  String get giveCategoryAName => 'বিভাগটির একটি নাম দিন';

  @override
  String get editCategory => 'বিভাগ সম্পাদনা';

  @override
  String get newTrainerCategory => 'নতুন প্রশিক্ষক বিভাগ';

  @override
  String get generalTrainingNote =>
      'সাধারণ প্রশিক্ষণের জন্য এটিই স্বাভাবিক সেটিং।';

  @override
  String get personalTrainingNote =>
      'ব্যক্তিগত প্রশিক্ষণ: এখানে একজন প্রশিক্ষক একবারে একজন সদস্য নেন।';

  @override
  String get addCategory => 'বিভাগ যোগ করুন';

  @override
  String get listedPublicly => 'সর্বসাধারণে তালিকাভুক্ত';

  @override
  String get yourMembersOnly => 'কেবল আপনার সদস্যরা';

  @override
  String get whenDoesItStart => 'এটি কখন শুরু হয়?';

  @override
  String get chooseStartDateFirst => 'আগে শুরুর তারিখ বেছে নিন।';

  @override
  String get lastDayToRegister => 'নিবন্ধনের শেষ দিন';

  @override
  String get giveTheEventATitle => 'ইভেন্টের একটি শিরোনাম দিন।';

  @override
  String get addADescription => 'একটি বিবরণ যোগ করুন, অন্তত একটি বাক্য।';

  @override
  String get sayHowToTakePart => 'অংশ নিতে কী করতে হবে তা লিখুন।';

  @override
  String get pickTheDates => 'তারিখগুলি বেছে নিন।';

  @override
  String startsAtWhen(String when) {
    return '$when শুরু';
  }

  @override
  String registerByWhen(String when) {
    return '$when এর মধ্যে নিবন্ধন করুন';
  }

  @override
  String get selectYourLeaveDates => 'আপনার ছুটির তারিখ বেছে নিন';

  @override
  String get chooseYourDatesFirst => 'আগে আপনার তারিখ বেছে নিন।';

  @override
  String get sentForApproval => 'অনুমোদনের জন্য পাঠানো হয়েছে।';

  @override
  String get leaveApprovedPaused =>
      'ছুটি অনুমোদিত। ওই দিনগুলিতে আপনার সদস্যপদ থেমে থাকবে।';

  @override
  String get chooseDates => 'তারিখ বেছে নিন';

  @override
  String leaveDaysLeftCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'আপনার $count দিন ছুটি বাকি আছে।',
    );
    return '$_temp0';
  }

  @override
  String moreThanRemainingDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'এটি আপনার বাকি $count দিনের চেয়ে বেশি, তাই একজন ম্যানেজারকে অনুমোদন করতে হবে।',
    );
    return '$_temp0';
  }

  @override
  String get withinYourAllowance =>
      'আপনার সীমার মধ্যে — এটি সঙ্গে সঙ্গে অনুমোদিত হবে।';

  @override
  String get sendForApproval => 'অনুমোদনের জন্য পাঠান';

  @override
  String get enterCodeSentToTheirPhone => 'তাঁর ফোনে পাঠানো কোড লিখুন।';

  @override
  String get numberIsNewNameNeeded => 'এই নম্বরটি নতুন, তাই নাম লাগবে।';

  @override
  String get chooseARole => 'একটি ভূমিকা বেছে নিন।';

  @override
  String get isATrainer => 'Is a trainer?';

  @override
  String get chooseATrainerCategory => 'Choose a trainer category.';

  @override
  String get trainerCategory => 'Trainer category';

  @override
  String get addAMember => 'একজন সদস্য যোগ করুন';

  @override
  String get codeSentExistingAccount =>
      'কোড পাঠানো হয়েছে। এই নম্বরে আগে থেকেই জিমোলজিয়া অ্যাকাউন্ট আছে।';

  @override
  String get codeSentNewAccount =>
      'কোড পাঠানো হয়েছে। এই নম্বরটি নতুন, তাই আমরা একটি অ্যাকাউন্ট তৈরি করব।';

  @override
  String get membershipLength => 'সদস্যপদের মেয়াদ';

  @override
  String get leaveDaysAllowed => 'অনুমোদিত ছুটির দিন';

  @override
  String get ownerStaffMode => 'মালিক / স্টাফ মোড';

  @override
  String get memberMode => 'সদস্য মোড';

  @override
  String get managingGymsNote =>
      'আপনি জিম পরিচালনা করছেন। সদস্য হিসেবে জিমোলজিয়া ব্যবহার করতে ফিরে যান।';

  @override
  String get openingAGymNote =>
      'জিম খুলছেন, নাকি কোনোটিতে কাজ করেন? আপনার জিমের সিআরএম চালাতে সুইচ করুন — সদস্য, স্টাফ, উপস্থিতি ও ছুটি।';

  @override
  String get numberIsHowYouSignIn =>
      'আপনি নম্বর দিয়েই সাইন ইন করেন, তাই এটি এখানে এখনই বদলানো যায় না।';

  @override
  String get followingYourDevice => 'আপনার ডিভাইস অনুসরণ করছে';

  @override
  String get yourGym => 'আপনার জিম';

  @override
  String weeksRunning(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'টানা সপ্তাহ',
      one: 'টানা সপ্তাহ',
    );
    return '$_temp0';
  }

  @override
  String noVisitsInLastDays(int days) {
    return 'গত $days দিনে কোনো আসা নথিভুক্ত হয়নি।';
  }

  @override
  String visitsInLastDays(int count, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'গত $days দিনে $count বার আসা।',
    );
    return '$_temp0';
  }

  @override
  String get couldNotLoadEvents => 'ইভেন্ট লোড করা যায়নি';

  @override
  String get noEventsOnRightNow => 'এখন কোনো ইভেন্ট নেই';

  @override
  String get eventsAppearHere =>
      'আপনার জিমের ইভেন্ট এখানে দেখা যায়, সঙ্গে আশেপাশের সবার জন্য খোলা ইভেন্টও।';

  @override
  String get atYourGym => 'আপনার জিমে';

  @override
  String trainerStaffMembersAt(String gym) {
    return '$gym এ আপনার প্রশিক্ষক, স্টাফ ও সদস্যরা';
  }

  @override
  String get trainerStaffOtherMembers =>
      'আপনার প্রশিক্ষক, স্টাফ ও অন্য সদস্যরা';

  @override
  String get comingNext => 'পরে আসছে';

  @override
  String get progressChartsAgainstGoal =>
      'আপনার লক্ষ্যের বিপরীতে অগ্রগতির চার্ট';

  @override
  String get leaveLeft => 'বাকি ছুটি';

  @override
  String approvedMembershipPauses(String name) {
    return '$name অনুমোদিত। ওই দিনগুলিতে তাঁর সদস্যপদ থেমে থাকবে।';
  }

  @override
  String get approveInstead => 'বরং অনুমোদন করুন';

  @override
  String get declineInstead => 'বরং প্রত্যাখ্যান করুন';

  @override
  String get needsYou => 'আপনাকে দরকার';

  @override
  String get autoApproved => 'স্বয়ংক্রিয় অনুমোদিত';

  @override
  String get returnedEarly => 'আগেই ফিরেছেন';

  @override
  String get whereYouAre => 'আপনি কোথায়';

  @override
  String get enterTheAddress => 'ঠিকানা লিখুন';

  @override
  String get maximumPerMembership => 'প্রতি সদস্যপদে সর্বোচ্চ';

  @override
  String removeStaffWithAssigned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'তিনি এই জিমে আর ঢুকতে পারবেন না, আর তাঁকে দেওয়া $count জন সদস্যের কোনো প্রশিক্ষক থাকবে না যতক্ষণ না আপনি অন্য কাউকে দেন।',
    );
    return '$_temp0';
  }

  @override
  String get removeStaffPlain =>
      'তিনি এই জিমে আর ঢুকতে পারবেন না। তাঁর উপস্থিতির রেকর্ড রাখা হয়।';

  @override
  String get couldNotLoadGyms => 'জিম লোড করা যায়নি';

  @override
  String get noGymsListedYet => 'এখনও কোনো জিম তালিকাভুক্ত নয়';

  @override
  String get gymsAppearOnPro =>
      'জিম এখানে তখনই দেখা যায় যখন তারা প্রো প্ল্যানে থাকে এবং তালিকাভুক্ত হতে চায়।';

  @override
  String nothingMatchedTry(String query) {
    return '“$query” এর সঙ্গে কিছু মেলেনি। অন্য শহর বা জেলা দেখুন।';
  }

  @override
  String get noRatings => 'কোনো রেটিং নেই';

  @override
  String get noPerksYet => 'এখনো কোনো সুবিধা তালিকাভুক্ত নেই';

  @override
  String fromRatings(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count রেটিং থেকে',
    );
    return '$_temp0';
  }

  @override
  String get onlyProGymHere => 'এখানে একমাত্র প্রো জিম';

  @override
  String ofProGyms(int count) {
    return '$count প্রো জিমের মধ্যে';
  }

  @override
  String get couldNotLoadYourGyms => 'আপনার জিম লোড করা যায়নি';

  @override
  String get noGymsYet => 'এখনও কোনো জিম নেই';

  @override
  String get createYourGymBlurb =>
      'সদস্য, স্টাফ, উপস্থিতি ও ছুটি সেট করতে আপনার জিম তৈরি করুন। কোনো জিমে কাজ করলে মালিককে যোগ করতে বলুন, সেটি এখানে দেখা যাবে।';

  @override
  String newGroupSelected(int count) {
    return 'নতুন গ্রুপ ($count নির্বাচিত)';
  }

  @override
  String get newMessage => 'নতুন বার্তা';

  @override
  String get oneToOne => 'একের সঙ্গে এক';

  @override
  String get group => 'গ্রুপ';

  @override
  String get buildMuscle => 'পেশি বাড়ান';

  @override
  String get loseFat => 'চর্বি কমান';

  @override
  String get getStronger => 'শক্তি বাড়ান';

  @override
  String get officialGroupEmpty => 'এই জিমের সবাই। এখনও কিছু বলা হয়নি।';

  @override
  String get unofficialGroupEmpty => 'কেবল সদস্যরা। এখনও কিছু বলা হয়নি।';

  @override
  String get noMessagesYet => 'এখনও কোনো বার্তা নেই';

  @override
  String get approved => 'অনুমোদিত';

  @override
  String get declined => 'প্রত্যাখ্যাত';

  @override
  String get cancelled => 'বাতিল';

  @override
  String get flexibility => 'নমনীয়তা';

  @override
  String get rehab => 'রিহ্যাব';

  @override
  String get youPrefix => 'আপনি: ';

  @override
  String get active => 'সক্রিয়';

  @override
  String get joined => 'যোগ দিয়েছেন';

  @override
  String get leftCount => 'ছেড়েছেন';

  @override
  String get net => 'নিট';

  @override
  String get daily => 'দৈনিক';

  @override
  String get monthly => 'মাসিক';

  @override
  String get yearly => 'বার্ষিক';

  @override
  String get add => 'যোগ করুন';

  @override
  String get update => 'আপডেট করুন';

  @override
  String get required => 'আবশ্যক';

  @override
  String get contact => 'যোগাযোগ';

  @override
  String get owner => 'মালিক';

  @override
  String get support => 'সহায়তা';

  @override
  String get machineTranslatedExercise =>
      'এই নির্দেশগুলি যন্ত্রে অনূদিত এবং কোনো কোচ যাচাই করেননি। কিছু অদ্ভুত মনে হলে ওজন তোলার আগে ইংরেজিতে বদলে মিলিয়ে নিন।';

  @override
  String get home => 'হোম';

  @override
  String get myGym => 'আমার জিম';

  @override
  String get discover => 'খুঁজুন';

  @override
  String get sendOtp => 'OTP পাঠান';

  @override
  String get verifyYourNumber => 'আপনার নম্বর যাচাই করুন';

  @override
  String get codeResent => 'নতুন কোড পাঠানো হচ্ছে।';

  @override
  String get name => 'নাম';

  @override
  String get email => 'ইমেল';

  @override
  String get connection => 'সংযোগ';

  @override
  String get account => 'অ্যাকাউন্ট';

  @override
  String get session => 'সেশন';

  @override
  String get earnByReferring => 'রেফার করে আয় করুন';

  @override
  String get gyms => 'জিম';

  @override
  String get events => 'ইভেন্ট';

  @override
  String get chat => 'চ্যাট';

  @override
  String get findAGym => 'জিম খুঁজুন';

  @override
  String get searchGyms => 'নাম বা এলাকা দিয়ে খুঁজুন';

  @override
  String get perks => 'সুবিধা';

  @override
  String get rating => 'রেটিং';

  @override
  String get onLeavePaused => 'ছুটিতে — আপনার সদস্যপদ থামানো';

  @override
  String get monthlyCheckIn => 'মাসিক চেক-ইন';

  @override
  String get notNow => 'এখন নয়';

  @override
  String trainerNamed(String name) {
    return 'ট্রেনার: $name';
  }

  @override
  String goalAtGym(String gym) {
    return '$gym-এ আপনার লক্ষ্য';
  }

  @override
  String daysRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count দিন বাকি',
      one: '১ দিন বাকি',
      zero: 'আজ শেষ',
    );
    return '$_temp0';
  }

  @override
  String get yourGoal => 'আপনার লক্ষ্য';

  @override
  String get trainer => 'ট্রেনার';

  @override
  String get requestLeave => 'ছুটির আবেদন';

  @override
  String get yourProgress => 'আপনার অগ্রগতি';

  @override
  String get addMeasurementsPrompt =>
      'আপনার ওজন ও উচ্চতা দিন যাতে জিম আপনার সঙ্গে অগ্রগতি দেখতে পারে।';

  @override
  String get progressSubtitle => 'সময়ের সাথে ওজন, এবং আপনি কতবার এসেছেন।';

  @override
  String get attendanceAppearsHere =>
      'আপনি কোনো জিমের সদস্য হলে এবং কর্মীরা উপস্থিতি চিহ্নিত করা শুরু করলে এটি এখানে দেখা যাবে।';

  @override
  String get twoCheckInsDrawALine =>
      'দুটি রেকর্ড থেকে রেখা তৈরি হয়। প্রতি মাসে ওজন দিন, এটি ভরে উঠবে।';

  @override
  String get nothingMatchesFilters => 'এই ফিল্টারের সঙ্গে কিছু মেলে না।';

  @override
  String get howToJoinGym =>
      'যোগ দিতে সরাসরি জিমে যোগাযোগ করুন। তাঁরা আপনাকে সদস্য হিসেবে যুক্ত করবেন।';

  @override
  String get weight => 'ওজন';

  @override
  String get height => 'উচ্চতা';

  @override
  String get yourMeasurements => 'আপনার মাপ';

  @override
  String get checkInDue => 'এই মাসের চেক-ইন বাকি';

  @override
  String get thisMonth => 'এই মাসে';

  @override
  String get perWeek => 'প্রতি সপ্তাহে';

  @override
  String get lastEightWeeks => 'গত ৮ সপ্তাহ';

  @override
  String get exerciseDirectory => 'ব্যায়াম তালিকা';

  @override
  String get exercises => 'ব্যায়াম';

  @override
  String get searchExercises => 'ব্যায়াম খুঁজুন';

  @override
  String get clear => 'মুছুন';

  @override
  String get howToDoIt => 'কীভাবে করবেন';

  @override
  String get watchOutFor => 'খেয়াল রাখুন';

  @override
  String get whatYouGet => 'আপনি যা পাবেন';

  @override
  String get removeYourEntry => 'আপনার নাম সরাবেন?';

  @override
  String get stayIn => 'থেকে যান';

  @override
  String get removeMe => 'আমাকে সরান';

  @override
  String get youAreInTapToWithdraw => 'আপনি আছেন — সরতে ট্যাপ করুন';

  @override
  String get participate => 'অংশ নিন';

  @override
  String takenOffList(String event) {
    return '$event-এর তালিকা থেকে আপনার নাম সরানো হবে।';
  }

  @override
  String contactWithPhone(String phone) {
    return 'যোগাযোগ $phone';
  }

  @override
  String get reasonOptional => 'কারণ (ঐচ্ছিক)';

  @override
  String get searchByGymCityDistrict => 'জিম, শহর বা জেলা দিয়ে খুঁজুন';

  @override
  String get useMyLocation => 'কাছের জিম খুঁজতে আমার লোকেশন ব্যবহার করুন';

  @override
  String get findingNearbyGyms => 'আপনার কাছের জিম খোঁজা হচ্ছে…';

  @override
  String get locationUnavailable =>
      'আপনার লোকেশন পাওয়া যায়নি — সব জিম দেখানো হচ্ছে';

  @override
  String get exerciseDirectorySubtitle =>
      'শক্তি, কার্ডিও ও যোগ, ধাপে ধাপে নির্দেশনা সহ';

  @override
  String get attendance => 'উপস্থিতি';

  @override
  String get manage => 'পরিচালনা';

  @override
  String get choosePlan => 'প্ল্যান বাছুন';

  @override
  String get seeGrowthOverTime => 'সময়ের সাথে বৃদ্ধি দেখুন';

  @override
  String lastNDays(int days) {
    return 'গত $days দিন';
  }

  @override
  String get addMember => 'সদস্য যোগ করুন';

  @override
  String get addStaff => 'কর্মী যোগ করুন';

  @override
  String get searchByNameOrNumber => 'নাম বা নম্বর দিয়ে খুঁজুন';

  @override
  String get tapCircleToMarkPresent =>
      'উপস্থিতির জন্য বৃত্তে ট্যাপ করুন, বিস্তারিত জন্য সারিতে';

  @override
  String markedPresent(String name) {
    return '$name উপস্থিত হিসেবে চিহ্নিত';
  }

  @override
  String get approve => 'অনুমোদন';

  @override
  String get role => 'ভূমিকা';

  @override
  String get theirName => 'তাঁর নাম';

  @override
  String get theirMobileNumber => 'তাঁর মোবাইল নম্বর';

  @override
  String get codeFromTheirPhone => 'তাঁর ফোনের কোড';

  @override
  String get whatDoTheyWant => 'তিনি জিম থেকে কী চান?';

  @override
  String get goalHint => 'ওজন বাড়ানো, ওজন কমানো, রিহ্যাব…';

  @override
  String get saveChanges => 'পরিবর্তন সংরক্ষণ';

  @override
  String get removeFromGym => 'জিম থেকে সরান';

  @override
  String get remove => 'সরান';

  @override
  String removePerson(String name) {
    return '$name-কে সরাবেন?';
  }

  @override
  String get onLeave => 'ছুটিতে';

  @override
  String get tapDayToCorrect => 'সংশোধনের জন্য একটি দিনে ট্যাপ করুন';

  @override
  String correctDate(String date) {
    return '$date সংশোধন করুন';
  }

  @override
  String get whyIsThisChanging => 'এটি কেন বদলাচ্ছে?';

  @override
  String get correctionReasonHint => 'ভুলে চিহ্নিত, মেশিন বন্ধ ছিল…';

  @override
  String get saveCorrection => 'সংশোধন সংরক্ষণ';

  @override
  String get recordCorrected => 'রেকর্ড সংশোধিত।';

  @override
  String get trainerCategories => 'ট্রেনার বিভাগ';

  @override
  String get newCategory => 'নতুন বিভাগ';

  @override
  String get noTrainerCategoriesYet => 'এখনও কোনো ট্রেনার বিভাগ নেই।';

  @override
  String get oneTrainerManyMembers => 'একজন ট্রেনার অনেক সদস্য নিতে পারেন';

  @override
  String get categoryNameHint => 'রিহ্যাব, স্ট্রেংথ, যোগ';

  @override
  String get edit => 'সম্পাদনা';

  @override
  String get delete => 'মুছুন';

  @override
  String get keepIt => 'রেখে দিন';

  @override
  String deleteNamed(String name) {
    return '$name মুছবেন?';
  }

  @override
  String get decline => 'প্রত্যাখ্যান';

  @override
  String decidedBy(String name) {
    return '$name দ্বারা সিদ্ধান্ত';
  }

  @override
  String get createAGym => 'জিম তৈরি করুন';

  @override
  String get createYourGym => 'আপনার জিম তৈরি করুন';

  @override
  String get gymName => 'জিমের নাম';

  @override
  String get gymNameHint => 'আয়রন টেম্পল ফিটনেস';

  @override
  String get descriptionOptional => 'বিবরণ (ঐচ্ছিক)';

  @override
  String get descriptionHint => 'আপনার জিমে যোগ দেওয়ার মতো কী আছে?';

  @override
  String get address => 'ঠিকানা';

  @override
  String get city => 'শহর';

  @override
  String get district => 'জেলা';

  @override
  String get districtNote =>
      'সার্চে আপনার জিমের নামের পাশে জেলা দেখা যায়, যাতে সদস্যরা চিনতে পারেন।';

  @override
  String get state => 'রাজ্য';

  @override
  String get pinCode => 'পিন কোড';

  @override
  String get contactNumber => 'যোগাযোগ নম্বর';

  @override
  String get leavePolicyNote =>
      'সদস্যরা মাসে কয়েক দিন সদস্যপদ থামাতে পারেন। এর বেশি হলে অনুমোদন লাগে।';

  @override
  String get perksLabel => 'সুবিধা, কমা দিয়ে আলাদা';

  @override
  String get perksHint => 'স্টিম রুম, বিনামূল্যে পার্কিং, পার্সোনাল ট্রেনিং';

  @override
  String get createGym => 'জিম তৈরি করুন';

  @override
  String get deleteGym => 'জিম মুছুন';

  @override
  String get gymProfile => 'জিম প্রোফাইল';

  @override
  String get description => 'বিবরণ';

  @override
  String get leavePolicy => 'ছুটির নীতি';

  @override
  String get leaveDaysPerMonth => 'মাসে ছুটির দিন';

  @override
  String get deleteThisGym => 'এই জিম মুছুন';

  @override
  String get leaveLimitNote =>
      'এই সীমার মধ্যে সদস্যদের অনুরোধ স্বয়ংক্রিয়ভাবে অনুমোদিত হয়। তার বেশি হলে কারও অনুমোদন লাগে।';

  @override
  String get draftNote =>
      'আপনার জিম খসড়া হিসেবে শুরু হয়। ব্যবহার শুরু করতে একটি প্ল্যান বেছে নিন। Pro প্ল্যানের জিম Gymologia সার্চেও দেখায়।';

  @override
  String get sendThis => 'এটি পাঠাবেন?';

  @override
  String get send => 'পাঠান';

  @override
  String get announcements => 'ঘোষণা';

  @override
  String get title => 'শিরোনাম';

  @override
  String get announceTitleHint => 'রক্ষণাবেক্ষণের জন্য রবিবার বন্ধ';

  @override
  String get message => 'বার্তা';

  @override
  String get announceBodyHint =>
      'আমরা সোমবার সকাল ৬টায় আবার খুলব। স্বল্প নোটিশের জন্য দুঃখিত।';

  @override
  String get whoSeesIt => 'কে দেখবে';

  @override
  String get everyone => 'সবাই';

  @override
  String get sendAnnouncement => 'ঘোষণা পাঠান';

  @override
  String get sent => 'পাঠানো হয়েছে';

  @override
  String get newGym => 'নতুন জিম';

  @override
  String get draft => 'খসড়া';

  @override
  String get nothingToChartYet => 'এখনও দেখানোর কিছু নেই।';

  @override
  String peakValue(int value) {
    return 'সর্বোচ্চ $value';
  }

  @override
  String get searchRanking => 'সার্চ র‍্যাঙ্কিং';

  @override
  String get notInSearch => 'সার্চে নেই';

  @override
  String get members => 'সদস্য';

  @override
  String get staff => 'কর্মী';

  @override
  String get leave => 'ছুটি';

  @override
  String get roles => 'ভূমিকা';

  @override
  String get analytics => 'বিশ্লেষণ';

  @override
  String get growth => 'বৃদ্ধি';

  @override
  String get ranking => 'র‍্যাঙ্কিং';

  @override
  String get plan => 'প্ল্যান';

  @override
  String get announce => 'ঘোষণা';

  @override
  String get trainers => 'ট্রেনার';

  @override
  String get present => 'উপস্থিত';

  @override
  String get absent => 'অনুপস্থিত';

  @override
  String get markAttendance => 'উপস্থিতি দিন';

  @override
  String get getHelp => 'সহায়তা নিন';

  @override
  String get getHelpSubtitle => 'আমাদের বার্তা পাঠান, আমরা যোগাযোগ করব';

  @override
  String get termsAndPrivacy => 'শর্তাবলী ও গোপনীয়তা নীতি';

  @override
  String get signOut => 'সাইন আউট';

  @override
  String get switchToStaff => 'মালিক/কর্মী মোডে যান';

  @override
  String get switchToMember => 'সদস্য মোডে যান';

  @override
  String get notifications => 'বিজ্ঞপ্তি';

  @override
  String get needsReview => 'অনুবাদ পর্যালোচনার অপেক্ষায়';

  @override
  String get block => 'ব্লক করুন';

  @override
  String get unblock => 'আনব্লক করুন';

  @override
  String get report => 'রিপোর্ট করুন';

  @override
  String blockPerson(String name) {
    return '$name কে ব্লক করুন';
  }

  @override
  String reportPerson(String name) {
    return '$name এর বিরুদ্ধে রিপোর্ট করুন';
  }

  @override
  String get blockConfirmBody =>
      'তারা আপনাকে বার্তা পাঠাতে পারবে না, এবং আপনি তাদের বার্তা দেখতে পাবেন না। আপনি তাদের ব্লক করেছেন তা তাদের জানানো হবে না। আপনি সেটিংসে এটি ফিরিয়ে নিতে পারেন।';

  @override
  String get blocked => 'ব্লক করা হয়েছে';

  @override
  String get blockedAccounts => 'ব্লক করা অ্যাকাউন্ট';

  @override
  String get noBlockedAccounts => 'আপনি কাউকে ব্লক করেননি।';

  @override
  String get safetyAndPrivacy => 'নিরাপত্তা';

  @override
  String unblockQuestion(String name) {
    return '$name কে আনব্লক করবেন?';
  }

  @override
  String get unblockExplainer => 'তারা আবার আপনাকে বার্তা পাঠাতে পারবে।';

  @override
  String get whyReporting => 'কী সমস্যা?';

  @override
  String get reportDetails => 'কী ঘটেছে?';

  @override
  String get reportDetailsHint =>
      'পর্যালোচকরা বার্তাটি নিজে দেখেন না। তাঁরা আপনার বর্ণনাই পড়েন, তাই নিজের ভাষায় বলুন কী বলা হয়েছিল।';

  @override
  String get alsoBlockThem => 'তাদের ব্লকও করুন';

  @override
  String get alsoBlockThemExplainer =>
      'রিপোর্ট একজন মানুষ পড়েন এবং সময় লাগে। ব্লক করা সঙ্গে সঙ্গে কাজ করে।';

  @override
  String get sendReport => 'রিপোর্ট পাঠান';

  @override
  String get reportCategorySpam => 'স্প্যাম বা অবাঞ্ছিত বিক্রি';

  @override
  String get reportCategoryHarassment => 'হয়রানি বা উৎপীড়ন';

  @override
  String get reportCategorySexual => 'যৌন বা অশ্লীল বিষয়বস্তু';

  @override
  String get reportCategoryHate => 'ঘৃণামূলক বক্তব্য';

  @override
  String get reportCategoryViolence => 'সহিংসতা বা হুমকি';

  @override
  String get reportCategoryScam => 'প্রতারণা বা জালিয়াতি';

  @override
  String get reportCategoryImpersonation => 'অন্য কারও ছদ্মবেশ ধারণ';

  @override
  String get reportCategoryOther => 'অন্য কিছু';

  @override
  String get reportSent => 'ধন্যবাদ। কেউ এটি পর্যালোচনা করবেন।';

  @override
  String get myReports => 'আমার পাঠানো রিপোর্ট';

  @override
  String get reportStatusOpen => 'পর্যালোচনার অপেক্ষায়';

  @override
  String get reportStatusReviewing => 'দেখা হচ্ছে';

  @override
  String get reportStatusActioned => 'ব্যবস্থা নেওয়া হয়েছে';

  @override
  String get reportStatusDismissed => 'পর্যালোচিত, কোনো ব্যবস্থা নয়';

  @override
  String get noReportsSent => 'আপনি কারও বিরুদ্ধে রিপোর্ট করেননি।';

  @override
  String get deleteAccount => 'অ্যাকাউন্ট মুছুন';

  @override
  String get deleteAccountIntro =>
      'আপনার অ্যাকাউন্ট ৩০ দিন পর্যন্ত ব্যবহারযোগ্য থাকবে। তারপর এটি মুছে যাবে এবং ফেরানো যাবে না।';

  @override
  String get whatIsDeleted => 'কী মুছে যাবে';

  @override
  String get whatIsDeletedList =>
      'আপনার নাম, নম্বর, ইমেল ও বয়স। আপনার উচ্চতা, ওজন ও অগ্রগতি। আপনার চ্যাট বার্তা। যেকোনো পরিচয়পত্র ও UPI তথ্য।';

  @override
  String get whatIsKept => 'কী রাখা হবে, আপনার পরিচয় সরিয়ে';

  @override
  String get whatIsKeptList =>
      'পেমেন্ট ও চালানের রেকর্ড, কারণ আইন অনুযায়ী হিসাবের বই রাখতে হয়। জিমে নেওয়া পদক্ষেপের রেকর্ড, যাতে বিরোধ মেটানো যায়।';

  @override
  String get deleteGymsFirst =>
      'আপনার এখনও একটি জিম আছে। আগে সেটি মুছুন — আপনার অ্যাকাউন্ট মুছলে এর প্রতিটি সদস্য ও কর্মীর প্রবেশ বন্ধ হয়ে যাবে, এবং তাদের জানানো হবে যে এটি বন্ধ হয়ে গেছে।';

  @override
  String unwithdrawnWarning(String amount) {
    return 'আপনার $amount রেফারেল আয় এখনও তোলা হয়নি। আগে Gymologia Referral অ্যাপে তুলে নিন, নাহলে তা হারিয়ে যাবে।';
  }

  @override
  String get iUnderstandLoseEarnings => 'আমি বুঝেছি এই টাকা হারাব';

  @override
  String deletionScheduled(String date) {
    return 'আপনার অ্যাকাউন্ট $date তারিখে মুছে যাবে।';
  }

  @override
  String get keepMyAccount => 'আমার অ্যাকাউন্ট রাখুন';

  @override
  String get deletionCancelled => 'আপনার অ্যাকাউন্ট মোছা হবে না।';

  @override
  String get deleteAccountConfirm => 'আমার অ্যাকাউন্ট মুছুন';

  @override
  String get about => 'পরিচিতি';

  @override
  String get participated => 'আপনি আছেন';

  @override
  String letsGoName(String name) {
    return 'চলো, $name';
  }

  @override
  String get yourTraining => 'আপনার ট্রেনিং';

  @override
  String get tagline => 'ট্রেন করুন। ট্র্যাক করুন। বদলে যান।';

  @override
  String get appearance => 'থিম';

  @override
  String get themeDark => 'ডার্ক';

  @override
  String get themeLight => 'লাইট';

  @override
  String get takePhoto => 'ছবি তুলুন';

  @override
  String get chooseFromGallery => 'গ্যালারি থেকে বেছে নিন';

  @override
  String get chooseFile => 'ফাইল বেছে নিন';

  @override
  String get chooseFileHint => 'আগে থেকে থাকা PDF বা ছবি';

  @override
  String get uploading => 'আপলোড হচ্ছে…';

  @override
  String fileTooLarge(int mb) {
    return 'ফাইলটি খুব বড়। সীমা $mb MB।';
  }

  @override
  String get gymPhotos => 'জিমের ছবি';

  @override
  String get gymPhotosHint =>
      'প্রথম ছবিটি কভার, সদস্যরা সার্চে এটি দেখেন। অন্য ছবিকে কভার করতে সেটিতে ট্যাপ করুন।';

  @override
  String get addPhoto => 'ছবি যোগ করুন';

  @override
  String get coverPhoto => 'কভার';

  @override
  String get removePhoto => 'ছবি সরান';

  @override
  String maxPhotos(int count) {
    return 'আপনি সর্বোচ্চ $countটি ছবি যোগ করতে পারেন।';
  }

  @override
  String get verification => 'যাচাইকরণ';

  @override
  String get kycIntro =>
      'Gymologia-র জিম ব্রাউজারে দেখাতে আপনার জিম যাচাই করুন। আমাদের টিম সাধারণত ২ কর্মদিবসের মধ্যে নথি যাচাই করে।';

  @override
  String get kycEncryptedNote =>
      'আধার, PAN ও GST নম্বর এনক্রিপ্ট করে রাখা হয়। আপনার নথি ব্যক্তিগত, শুধু আমাদের যাচাই টিম খুলতে পারে।';

  @override
  String get identity => 'পরিচয়';

  @override
  String get business => 'ব্যবসা';

  @override
  String get aadhaarNumber => 'আধার নম্বর';

  @override
  String get enterValidAadhaar => 'আপনার ১২ সংখ্যার আধার নম্বর দিন';

  @override
  String get panNumber => 'PAN';

  @override
  String get enterValidPan => 'সঠিক PAN দিন, যেমন ABCDE1234F';

  @override
  String get hasGstRegistration => 'আমার জিম GST-তে নিবন্ধিত';

  @override
  String get gstin => 'GSTIN';

  @override
  String get enterValidGstin => 'আপনার ১৫ অক্ষরের GSTIN দিন';

  @override
  String get businessProof => 'ব্যবসার প্রমাণ';

  @override
  String get businessProofHint => 'GST নেই? এর যেকোনো একটি আপলোড করুন।';

  @override
  String get proofUdyam => 'উদ্যম';

  @override
  String get proofElectricityBill => 'বিদ্যুৎ বিল';

  @override
  String get proofOther => 'অন্য';

  @override
  String get premisesQuestion => 'প্রাঙ্গণ';

  @override
  String get premisesOwned => 'নিজস্ব';

  @override
  String get premisesRented => 'ভাড়া';

  @override
  String get landlordNoc => 'বাড়িওয়ালার NOC';

  @override
  String get landlordNocHint => 'প্রাঙ্গণের মালিকের অনাপত্তি পত্র';

  @override
  String get uploadDocument => 'আপলোড';

  @override
  String get documentUploaded => 'আপলোড হয়েছে';

  @override
  String get replaceDocument => 'বদলান';

  @override
  String get documentRequired => 'অনুগ্রহ করে এই নথিটি আপলোড করুন।';

  @override
  String get submitForVerification => 'যাচাইয়ের জন্য জমা দিন';

  @override
  String get kycSubmittedSnackbar => 'যাচাইয়ের জন্য পাঠানো হয়েছে';

  @override
  String get whatYouSent => 'আপনি যা পাঠিয়েছেন';

  @override
  String get kycUnderReview => 'পর্যালোচনা চলছে';

  @override
  String get kycUnderReviewBody =>
      'আমাদের টিম আপনার নথি যাচাই করছে। শেষ হলেই জানানো হবে।';

  @override
  String kycVerifiedOn(String date) {
    return '$date তারিখে যাচাই হয়েছে। আপনার জিম এখন সার্চে দেখাতে পারে।';
  }

  @override
  String get kycNeedsChanges => 'পরিবর্তন দরকার';

  @override
  String get kycOnlyOwner =>
      'শুধু জিমের নিবন্ধিত মালিকই যাচাইয়ের নথি জমা দিতে পারেন।';

  @override
  String get statusPending => 'অপেক্ষমাণ';

  @override
  String get statusRejected => 'প্রত্যাখ্যাত';

  @override
  String get statusNotSubmitted => 'পাঠানো হয়নি';

  @override
  String get getVerified => 'যাচাই করান';

  @override
  String get gymLocation => 'জিমের অবস্থান';

  @override
  String get gymLocationHint =>
      'আপনার জিম ম্যাপে পিন করুন যাতে কাছের সদস্যরা খুঁজে পান।';

  @override
  String get setGymLocation => 'ম্যাপে বেছে নিন';

  @override
  String get updateGymLocation => 'বদলান';

  @override
  String get gymLocationSet => 'অবস্থান সেট হয়েছে';

  @override
  String get gymLocationFailed =>
      'আপনার অবস্থান পাওয়া যায়নি। লোকেশন চালু করে আবার চেষ্টা করুন।';

  @override
  String gymCreatedAddPhotos(String name) {
    return '$name তৈরি হয়েছে। ছবিসহ জিম বেশি সদস্য পায়, তাই এখনই কয়েকটি যোগ করুন। পরে জিম প্রোফাইলে বদলাতে পারবেন।';
  }

  @override
  String get finish => 'সম্পন্ন';

  @override
  String get skipForNow => 'এখন এড়িয়ে যান';

  @override
  String get gymLocationNotSet => 'এখনও সেট হয়নি';

  @override
  String get moveMapHint =>
      'ম্যাপটি সরান যাতে পিনটি আপনার জিমের প্রবেশপথে থাকে।';

  @override
  String get confirmLocation => 'অবস্থান নিশ্চিত করুন';

  @override
  String get myLocation => 'আমার অবস্থান';

  @override
  String get gymContactHelp =>
      'যে নম্বরে সদস্যরা ফোন করবেন — জিমের রিসেপশন বা ব্যবসার নম্বর। এটি আপনার জিমের পেজে সবাই দেখতে পাবেন।';

  @override
  String get crmLockedDraft =>
      'CRM খুলতে একটি প্ল্যান বেছে নিন: সদস্য, স্টাফ, হাজিরা, ইভেন্ট ও চ্যাট। নতুন মালিকরা ৭ দিনের ফ্রি ট্রায়াল পান।';

  @override
  String get crmLockedExpired =>
      'আপনার প্ল্যান শেষ হয়েছে। আপনি এখনও সদস্য ও ডেটা দেখতে পারবেন, কিন্তু কিছু যোগ বা বদলাতে রিনিউ করুন।';

  @override
  String get crmLockedAskOwner =>
      'এই জিমের কোনো চালু প্ল্যান নেই, তাই CRM বন্ধ। জিম মালিককে একটি প্ল্যান বেছে নিতে বলুন।';

  @override
  String get attendanceToday => 'আজ';

  @override
  String get notMarked => 'চিহ্নিত নয়';

  @override
  String get markAbsent => 'অনুপস্থিত চিহ্নিত করুন';

  @override
  String markedAbsent(String name) {
    return '$name অনুপস্থিত চিহ্নিত';
  }

  @override
  String get attendanceFilterAll => 'সব';

  @override
  String attendanceChangeTitle(String name, String status) {
    return '$name-কে $status করবেন?';
  }

  @override
  String get attendanceChangeReason => 'পরিবর্তনের কারণ';

  @override
  String get attendanceChangeReasonHint => 'যেমন: ভুল করে চিহ্নিত';

  @override
  String get attendanceChanged => 'হাজিরা আপডেট হয়েছে';

  @override
  String attendanceNeedsEditPermission(String status) {
    return 'আগেই $status চিহ্নিত। বদলাতে হাজিরা সম্পাদনার অনুমতি লাগবে।';
  }

  @override
  String get attendanceNobody => 'এখানে চিহ্নিত করার কেউ নেই';

  @override
  String get attendanceNobodyHint =>
      'যাদের প্ল্যান শেষ এবং যে রোলের হাজিরা হয় না, তারা এখানে নেই।';

  @override
  String get attendanceCantView =>
      'আপনি এখানে হাজিরা দিতে পারেন, কিন্তু কে আগে চিহ্নিত তা আপনার রোল দেখতে পারে না।';

  @override
  String get reportGym => 'এই জিমটি রিপোর্ট করুন';

  @override
  String get reportEvent => 'এই ইভেন্টটি রিপোর্ট করুন';

  @override
  String get reportCategoryFakeListing => 'ভুয়া, বা যেমন বলা হয়েছে তেমন নয়';

  @override
  String get reportCategoryMisleading => 'ভুল দাম, পুরস্কার বা তথ্য';

  @override
  String get reportDetailsOptional => 'বিস্তারিত (ঐচ্ছিক)';

  @override
  String get reportListingDetailsHint =>
      'ঐচ্ছিক। যা সাহায্য করবে তা জানান, যেমন কী আপত্তিকর বা ভুল।';

  @override
  String get reportListingSent => 'ধন্যবাদ। আমাদের টিম এটি দেখবে।';

  @override
  String hiddenByGymologia(String reason) {
    return 'Gymologia লুকিয়ে রেখেছে: $reason';
  }

  @override
  String get mobileNumberHint => '১০ সংখ্যার মোবাইল নম্বর';
}
