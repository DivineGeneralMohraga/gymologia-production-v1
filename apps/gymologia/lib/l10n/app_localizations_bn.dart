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
  String get loading => 'লোড হচ্ছে';

  @override
  String get somethingWentWrong => 'কিছু ভুল হয়েছে';

  @override
  String get signIn => 'সাইন ইন';

  @override
  String get phoneNumber => 'মোবাইল নম্বর';

  @override
  String get enterPhoneNumber => 'আপনার মোবাইল নম্বর দিন';

  @override
  String get sendCode => 'কোড পাঠান';

  @override
  String get verifyCode => 'যাচাই করুন';

  @override
  String get enterCode => 'আমরা যে কোড পাঠিয়েছি সেটি দিন';

  @override
  String get resendCode => 'আবার পাঠান';

  @override
  String get createAccount => 'আপনার অ্যাকাউন্ট তৈরি করুন';

  @override
  String get yourName => 'আপনার নাম';

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
  String get profile => 'প্রোফাইল';

  @override
  String get findAGym => 'জিম খুঁজুন';

  @override
  String get searchGyms => 'নাম বা এলাকা দিয়ে খুঁজুন';

  @override
  String get noGymsFound => 'এখানে এখনও কোনো জিম নেই';

  @override
  String get perks => 'সুবিধা';

  @override
  String get contactGym => 'এই জিমে যোগাযোগ করুন';

  @override
  String get rating => 'রেটিং';

  @override
  String get yourMembership => 'আপনার সদস্যপদ';

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
  String get addMeasurements =>
      'আপনার ওজন ও উচ্চতা দিন যাতে জিম আপনার সঙ্গে অগ্রগতি দেখতে পারে';

  @override
  String get checkInDue => 'এই মাসের চেক-ইন বাকি';

  @override
  String get thisMonth => 'এই মাসে';

  @override
  String get perWeek => 'প্রতি সপ্তাহে';

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
  String get exerciseDirectorySubtitle =>
      'শক্তি, কার্ডিও ও যোগ, ধাপে ধাপে নির্দেশনা সহ';

  @override
  String get steps => 'ধাপ';

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
  String get onLeave => 'ছুটি';

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
      'আপনার জিম খসড়া হিসেবে শুরু হয়। যাচাই সম্পূর্ণ করে প্ল্যান না নেওয়া পর্যন্ত এটি সার্চে দেখা যাবে না।';

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
  String get noNotifications => 'নতুন কিছু নেই';

  @override
  String get needsReview => 'অনুবাদ পর্যালোচনার অপেক্ষায়';
}
