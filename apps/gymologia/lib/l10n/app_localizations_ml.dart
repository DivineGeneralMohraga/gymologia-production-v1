// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malayalam (`ml`).
class AppLocalizationsMl extends AppLocalizations {
  AppLocalizationsMl([String locale = 'ml']) : super(locale);

  @override
  String get appName => 'Gymologia';

  @override
  String get languageName => 'മലയാളം';

  @override
  String get settings => 'ക്രമീകരണങ്ങൾ';

  @override
  String get language => 'ഭാഷ';

  @override
  String get languageSubtitle =>
      'നിങ്ങൾക്ക് സൗകര്യപ്രദമായി വായിക്കാവുന്ന ഭാഷ തിരഞ്ഞെടുക്കുക';

  @override
  String get save => 'സേവ് ചെയ്യുക';

  @override
  String get cancel => 'റദ്ദാക്കുക';

  @override
  String get tryAgain => 'വീണ്ടും ശ്രമിക്കുക';

  @override
  String get loading => 'ലോഡ് ചെയ്യുന്നു';

  @override
  String get somethingWentWrong => 'എന്തോ കുഴപ്പം സംഭവിച്ചു';

  @override
  String get signIn => 'സൈൻ ഇൻ';

  @override
  String get phoneNumber => 'മൊബൈൽ നമ്പർ';

  @override
  String get enterPhoneNumber => 'നിങ്ങളുടെ മൊബൈൽ നമ്പർ നൽകുക';

  @override
  String get sendCode => 'കോഡ് അയയ്ക്കുക';

  @override
  String get verifyCode => 'സ്ഥിരീകരിക്കുക';

  @override
  String get enterCode => 'ഞങ്ങൾ അയച്ച കോഡ് നൽകുക';

  @override
  String get resendCode => 'വീണ്ടും അയയ്ക്കുക';

  @override
  String get createAccount => 'നിങ്ങളുടെ അക്കൗണ്ട് ഉണ്ടാക്കുക';

  @override
  String get yourName => 'നിങ്ങളുടെ പേര്';

  @override
  String get emailOptional => 'ഇമെയിൽ (ഐച്ഛികം)';

  @override
  String get age => 'വയസ്സ്';

  @override
  String get whyAgeNotBirthday =>
      'ഞങ്ങൾ നിങ്ങളുടെ വയസ്സാണ് ചോദിക്കുന്നത്, ജനനത്തീയതിയല്ല. ജനനത്തീയതി നിങ്ങളുടെ ബാങ്ക്, സർക്കാർ രേഖകളുമായി ബന്ധപ്പെട്ടതാണ് — ജിം ആപ്പിന് വയസ്സ് മതി.';

  @override
  String get termsAgreement =>
      'അക്കൗണ്ട് ഉണ്ടാക്കുന്നത് ഉപയോഗ നിബന്ധനകളും സ്വകാര്യതാ നയവും അംഗീകരിക്കുന്നു എന്നാണ്.';

  @override
  String get signInWithMobile =>
      'നിങ്ങളുടെ മൊബൈൽ നമ്പർ ഉപയോഗിച്ച് സൈൻ ഇൻ ചെയ്യുക';

  @override
  String get mobileNumber => 'മൊബൈൽ നമ്പർ';

  @override
  String get couldNotSendCode => 'കോഡ് അയയ്ക്കാൻ കഴിഞ്ഞില്ല.';

  @override
  String get verificationFailed => 'പരിശോധന പരാജയപ്പെട്ടു.';

  @override
  String get couldNotResendCode => 'കോഡ് വീണ്ടും അയയ്ക്കാൻ കഴിഞ്ഞില്ല.';

  @override
  String get couldNotCreateAccount =>
      'നിങ്ങളുടെ അക്കൗണ്ട് ഉണ്ടാക്കാൻ കഴിഞ്ഞില്ല.';

  @override
  String weSentCodeTo(String phone) {
    return '$phone എന്ന നമ്പറിലേക്ക് കോഡ് അയച്ചു';
  }

  @override
  String resendInSeconds(int seconds) {
    return '$seconds സെക്കൻഡിൽ വീണ്ടും അയയ്ക്കുക';
  }

  @override
  String get verified => 'പരിശോധിച്ചു';

  @override
  String get createAccountAction => 'അക്കൗണ്ട് ഉണ്ടാക്കുക';

  @override
  String get supportSent => 'അയച്ചു. നിങ്ങൾ നൽകിയ നമ്പറിൽ മറുപടി വരും.';

  @override
  String get supportSubject => 'ഇത് എന്തിനെക്കുറിച്ചാണ്?';

  @override
  String get supportSubjectHint => 'എന്റെ അംഗത്വ ദിവസങ്ങൾ തെറ്റായി കാണുന്നു';

  @override
  String get supportMessage => 'എന്താണ് സംഭവിച്ചതെന്ന് പറയൂ';

  @override
  String get supportReplyTo => 'ഞങ്ങൾ എവിടെ മറുപടി നൽകണം?';

  @override
  String get supportUrgent => 'ഇതുകാരണം എന്റെ ജിം പ്രവർത്തിക്കാൻ കഴിയുന്നില്ല';

  @override
  String get supportUrgentNote => 'മുൻഗണന കൂട്ടുന്നു.';

  @override
  String copiedToClipboard(String value) {
    return '$value പകർത്തി';
  }

  @override
  String orEmailUs(String email) {
    return 'അല്ലെങ്കിൽ $email എന്ന വിലാസത്തിൽ ഇമെയിൽ ചെയ്യുക';
  }

  @override
  String get whatYouHaveAsked => 'നിങ്ങൾ ചോദിച്ചത്';

  @override
  String get aFewWordsIsEnough => 'കുറച്ച് വാക്കുകൾ മതി';

  @override
  String get aSentenceOrTwoHelps =>
      'ഒന്നോ രണ്ടോ വാചകം എഴുതിയാൽ വേഗം പരിഹരിക്കാം';

  @override
  String get ticketOpen => 'ആരെങ്കിലും ഏറ്റെടുക്കാൻ കാത്തിരിക്കുന്നു';

  @override
  String get ticketInProgress => 'ആരോ ഇത് നോക്കുന്നു';

  @override
  String get ticketWaitingOnUser => 'നിങ്ങളുടെ മറുപടിക്കായി കാത്തിരിക്കുന്നു';

  @override
  String get ticketResolved => 'പരിഹരിച്ചു';

  @override
  String get ticketClosed => 'അടച്ചു';

  @override
  String get referralPitch =>
      'കോഡ് പങ്കിടുക, ഒരു ജിം ഉടമ സബ്‌സ്‌ക്രിപ്ഷൻ എടുക്കുമ്പോൾ സമ്പാദിക്കുക. റഫറൽ ആപ്പ് ഇനിയും വന്നിട്ടില്ല.';

  @override
  String get appTagline => 'ജിമോളജിയ · അംഗങ്ങളും ജീവനക്കാരും';

  @override
  String get signOutQuestion => 'സൈൻ ഔട്ട് ചെയ്യണോ?';

  @override
  String get signOutWarning => 'വീണ്ടും സൈൻ ഇൻ ചെയ്യാൻ നിങ്ങളുടെ ഫോൺ വേണം.';

  @override
  String get profileUpdated => 'പ്രൊഫൈൽ പുതുക്കി.';

  @override
  String get yourProfile => 'നിങ്ങളുടെ പ്രൊഫൈൽ';

  @override
  String get emailClearToRemove => 'ഐച്ഛികം. നീക്കാൻ ഒഴിവാക്കുക.';

  @override
  String get phoneIsYourLogin =>
      'ഇതുപയോഗിച്ചാണ് നിങ്ങൾ സൈൻ ഇൻ ചെയ്യുന്നത്, അതിനാൽ ഇവിടെ ഇപ്പോൾ മാറ്റാനാകില്ല. മാറ്റണമെങ്കിൽ പിന്തുണയുമായി ബന്ധപ്പെടുക.';

  @override
  String get trialStarted =>
      'ട്രയൽ ആരംഭിച്ചു. നിങ്ങളുടെ ജിം ഇപ്പോൾ തിരയലിൽ കാണാം.';

  @override
  String get invalidCode => 'കോഡ് സാധുവല്ല.';

  @override
  String get paymentNotCompletedYet =>
      'പണമടയ്ക്കൽ ഇനിയും പൂർത്തിയായിട്ടില്ല. അല്പസമയത്തിനു ശേഷം വലിച്ചു പുതുക്കുക.';

  @override
  String planIsActive(String plan) {
    return '$plan പ്ലാൻ സജീവമാണ്.';
  }

  @override
  String get paymentNotCompleted => 'പണമടയ്ക്കൽ പൂർത്തിയായില്ല.';

  @override
  String get couldNotOpenPayment => 'പണമടയ്ക്കൽ സ്ക്രീൻ തുറക്കാൻ കഴിഞ്ഞില്ല.';

  @override
  String daysFree(int days) {
    return '$days ദിവസം സൗജന്യം';
  }

  @override
  String get trialBlurb =>
      'പൂർണ്ണ പ്രോ, അംഗ തിരയലിലെ നിങ്ങളുടെ ലിസ്റ്റിംഗ് ഉൾപ്പെടെ. കാർഡ് വേണ്ട, ഇത് സ്വയം പണമടച്ചുള്ള പ്ലാനായി മാറില്ല.';

  @override
  String get startFreeTrial => 'സൗജന്യ ട്രയൽ തുടങ്ങുക';

  @override
  String get referralCode => 'റഫറൽ കോഡ്';

  @override
  String get optional => 'ഐച്ഛികം';

  @override
  String get apply => 'ബാധകമാക്കുക';

  @override
  String get gstNote =>
      'വിലയിൽ ജിഎസ്ടി ഉൾപ്പെടും. പ്രോ പ്ലാനിൽ മാത്രമേ ജിം അംഗ തിരയലിൽ വരൂ.';

  @override
  String planNamed(String plan) {
    return '$plan പ്ലാൻ';
  }

  @override
  String get trialBadge => 'ട്രയൽ';

  @override
  String get expired => 'കാലാവധി കഴിഞ്ഞു';

  @override
  String daysRemainingPlan(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ദിവസം ബാക്കി',
    );
    return '$_temp0';
  }

  @override
  String get listedInSearch => 'അംഗ തിരയലിൽ ലിസ്റ്റ് ചെയ്തു';

  @override
  String get notListedUpgrade => 'തിരയലിൽ ഇല്ല — കാണാൻ പ്രോയിലേക്ക് മാറുക';

  @override
  String get trialEndsNote =>
      'ട്രയൽ കഴിഞ്ഞാൽ നിങ്ങൾ പ്ലാൻ തിരഞ്ഞെടുക്കുന്നത് വരെ ജിം തിരയലിൽ നിന്ന് പുറത്താകും. സ്വയമേവ ഒന്നും ഈടാക്കില്ല.';

  @override
  String get getsYouListed => 'തിരയലിൽ ഇടം നൽകുന്നു';

  @override
  String get perMonth => '/മാസം';

  @override
  String choosePlanNamed(String plan) {
    return '$plan തിരഞ്ഞെടുക്കുക';
  }

  @override
  String get home => 'ഹോം';

  @override
  String get myGym => 'എന്റെ ജിം';

  @override
  String get discover => 'കണ്ടെത്തുക';

  @override
  String get sendOtp => 'OTP അയയ്ക്കുക';

  @override
  String get verifyYourNumber => 'നിങ്ങളുടെ നമ്പർ സ്ഥിരീകരിക്കുക';

  @override
  String get codeResent => 'പുതിയ കോഡ് അയയ്ക്കുന്നു.';

  @override
  String get name => 'പേര്';

  @override
  String get email => 'ഇമെയിൽ';

  @override
  String get connection => 'കണക്ഷൻ';

  @override
  String get account => 'അക്കൗണ്ട്';

  @override
  String get session => 'സെഷൻ';

  @override
  String get earnByReferring => 'റഫർ ചെയ്ത് സമ്പാദിക്കുക';

  @override
  String get gyms => 'ജിമ്മുകൾ';

  @override
  String get events => 'ഇവന്റുകൾ';

  @override
  String get chat => 'ചാറ്റ്';

  @override
  String get profile => 'പ്രൊഫൈൽ';

  @override
  String get findAGym => 'ജിം കണ്ടെത്തുക';

  @override
  String get searchGyms => 'പേരോ പ്രദേശമോ ഉപയോഗിച്ച് തിരയുക';

  @override
  String get noGymsFound => 'ഇവിടെ ഇതുവരെ ജിമ്മുകളൊന്നുമില്ല';

  @override
  String get perks => 'സൗകര്യങ്ങൾ';

  @override
  String get contactGym => 'ഈ ജിമ്മുമായി ബന്ധപ്പെടുക';

  @override
  String get rating => 'റേറ്റിംഗ്';

  @override
  String get yourMembership => 'നിങ്ങളുടെ അംഗത്വം';

  @override
  String get onLeavePaused => 'അവധിയിൽ — നിങ്ങളുടെ അംഗത്വം നിർത്തിവച്ചു';

  @override
  String get monthlyCheckIn => 'മാസ ചെക്ക്-ഇൻ';

  @override
  String get notNow => 'ഇപ്പോൾ വേണ്ട';

  @override
  String trainerNamed(String name) {
    return 'പരിശീലകൻ: $name';
  }

  @override
  String goalAtGym(String gym) {
    return '$gym-ൽ നിങ്ങളുടെ ലക്ഷ്യം';
  }

  @override
  String daysRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ദിവസം ബാക്കി',
      one: '1 ദിവസം ബാക്കി',
      zero: 'ഇന്ന് അവസാനിക്കുന്നു',
    );
    return '$_temp0';
  }

  @override
  String get yourGoal => 'നിങ്ങളുടെ ലക്ഷ്യം';

  @override
  String get trainer => 'പരിശീലകൻ';

  @override
  String get requestLeave => 'അവധി അപേക്ഷ';

  @override
  String get yourProgress => 'നിങ്ങളുടെ പുരോഗതി';

  @override
  String get addMeasurementsPrompt =>
      'നിങ്ങളുടെ ഭാരവും ഉയരവും ചേർക്കുക, അപ്പോൾ ജിമ്മിന് നിങ്ങളുടെ പുരോഗതി കാണാം.';

  @override
  String get progressSubtitle =>
      'കാലക്രമേണ ഭാരം, നിങ്ങൾ എത്ര തവണ വന്നു എന്നതും.';

  @override
  String get attendanceAppearsHere =>
      'നിങ്ങൾ ഒരു ജിമ്മിലെ അംഗമായി ജീവനക്കാർ ഹാജർ രേഖപ്പെടുത്താൻ തുടങ്ങിയാൽ ഇത് ഇവിടെ കാണാം.';

  @override
  String get twoCheckInsDrawALine =>
      'രണ്ട് രേഖപ്പെടുത്തലുകൾ ഒരു വര വരയ്ക്കും. എല്ലാ മാസവും ഭാരം ചേർത്താൽ ഇത് നിറയും.';

  @override
  String get nothingMatchesFilters =>
      'ഈ ഫിൽട്ടറുകൾക്ക് ഒന്നും യോജിക്കുന്നില്ല.';

  @override
  String get howToJoinGym =>
      'ചേരാൻ ജിമ്മുമായി നേരിട്ട് ബന്ധപ്പെടുക. അവർ നിങ്ങളെ അംഗമായി ചേർക്കും.';

  @override
  String get weight => 'ഭാരം';

  @override
  String get height => 'ഉയരം';

  @override
  String get yourMeasurements => 'നിങ്ങളുടെ അളവുകൾ';

  @override
  String get addMeasurements =>
      'നിങ്ങളുടെ ഭാരവും ഉയരവും ചേർക്കുക, അപ്പോൾ ജിമ്മിന് നിങ്ങളുടെ പുരോഗതി കാണാം';

  @override
  String get checkInDue => 'ഈ മാസത്തെ ചെക്ക്-ഇൻ ബാക്കിയുണ്ട്';

  @override
  String get thisMonth => 'ഈ മാസം';

  @override
  String get perWeek => 'ആഴ്ചയിൽ';

  @override
  String weeksRunning(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'തുടർച്ചയായ ആഴ്ചകൾ',
      one: 'തുടർച്ചയായ ആഴ്ച',
    );
    return '$_temp0';
  }

  @override
  String get lastEightWeeks => 'കഴിഞ്ഞ 8 ആഴ്ച';

  @override
  String get exerciseDirectory => 'വ്യായാമ പട്ടിക';

  @override
  String get exercises => 'വ്യായാമങ്ങൾ';

  @override
  String get searchExercises => 'വ്യായാമങ്ങൾ തിരയുക';

  @override
  String get clear => 'മായ്ക്കുക';

  @override
  String get howToDoIt => 'എങ്ങനെ ചെയ്യാം';

  @override
  String get watchOutFor => 'ശ്രദ്ധിക്കുക';

  @override
  String get whatYouGet => 'നിങ്ങൾക്ക് ലഭിക്കുന്നത്';

  @override
  String get removeYourEntry => 'നിങ്ങളുടെ പേര് നീക്കണോ?';

  @override
  String get stayIn => 'തുടരുക';

  @override
  String get removeMe => 'എന്നെ നീക്കുക';

  @override
  String get youAreInTapToWithdraw =>
      'നിങ്ങൾ ചേർന്നിട്ടുണ്ട് — പിന്മാറാൻ ടാപ്പ് ചെയ്യുക';

  @override
  String get participate => 'പങ്കെടുക്കുക';

  @override
  String takenOffList(String event) {
    return '$event പട്ടികയിൽ നിന്ന് നിങ്ങളുടെ പേര് നീക്കും.';
  }

  @override
  String contactWithPhone(String phone) {
    return 'ബന്ധപ്പെടുക $phone';
  }

  @override
  String get reasonOptional => 'കാരണം (ഐച്ഛികം)';

  @override
  String get searchByGymCityDistrict =>
      'ജിം, നഗരം അല്ലെങ്കിൽ ജില്ല ഉപയോഗിച്ച് തിരയുക';

  @override
  String get exerciseDirectorySubtitle =>
      'കരുത്ത്, കാർഡിയോ, യോഗ — ഓരോ ഘട്ടത്തിന്റെയും നിർദ്ദേശങ്ങളോടെ';

  @override
  String get steps => 'ഘട്ടങ്ങൾ';

  @override
  String get attendance => 'ഹാജർ';

  @override
  String get manage => 'നിർവഹണം';

  @override
  String get choosePlan => 'പ്ലാൻ തിരഞ്ഞെടുക്കുക';

  @override
  String get seeGrowthOverTime => 'കാലക്രമേണ വളർച്ച കാണുക';

  @override
  String lastNDays(int days) {
    return 'കഴിഞ്ഞ $days ദിവസം';
  }

  @override
  String get addMember => 'അംഗത്തെ ചേർക്കുക';

  @override
  String get addStaff => 'ജീവനക്കാരനെ ചേർക്കുക';

  @override
  String get searchByNameOrNumber => 'പേരോ നമ്പറോ ഉപയോഗിച്ച് തിരയുക';

  @override
  String get tapCircleToMarkPresent =>
      'ഹാജരിന് വൃത്തത്തിൽ ടാപ്പ് ചെയ്യുക, വിവരങ്ങൾക്ക് വരിയിൽ';

  @override
  String markedPresent(String name) {
    return '$name ഹാജരായി രേഖപ്പെടുത്തി';
  }

  @override
  String get approve => 'അംഗീകരിക്കുക';

  @override
  String get role => 'റോൾ';

  @override
  String get theirName => 'അവരുടെ പേര്';

  @override
  String get theirMobileNumber => 'അവരുടെ മൊബൈൽ നമ്പർ';

  @override
  String get codeFromTheirPhone => 'അവരുടെ ഫോണിലെ കോഡ്';

  @override
  String get whatDoTheyWant => 'അവർക്ക് ജിമ്മിൽ നിന്ന് എന്താണ് വേണ്ടത്?';

  @override
  String get goalHint => 'ഭാരം കൂട്ടൽ, കുറയ്ക്കൽ, റീഹാബ്…';

  @override
  String get saveChanges => 'മാറ്റങ്ങൾ സേവ് ചെയ്യുക';

  @override
  String get removeFromGym => 'ജിമ്മിൽ നിന്ന് നീക്കുക';

  @override
  String get remove => 'നീക്കുക';

  @override
  String removePerson(String name) {
    return '$name നീക്കണോ?';
  }

  @override
  String get onLeave => 'അവധി';

  @override
  String get tapDayToCorrect => 'തിരുത്താൻ ഒരു ദിവസത്തിൽ ടാപ്പ് ചെയ്യുക';

  @override
  String correctDate(String date) {
    return '$date തിരുത്തുക';
  }

  @override
  String get whyIsThisChanging => 'ഇത് എന്തുകൊണ്ട് മാറുന്നു?';

  @override
  String get correctionReasonHint =>
      'തെറ്റായി രേഖപ്പെടുത്തി, യന്ത്രം പ്രവർത്തിച്ചില്ല…';

  @override
  String get saveCorrection => 'തിരുത്തൽ സേവ് ചെയ്യുക';

  @override
  String get recordCorrected => 'രേഖ തിരുത്തി.';

  @override
  String get trainerCategories => 'പരിശീലക വിഭാഗങ്ങൾ';

  @override
  String get newCategory => 'പുതിയ വിഭാഗം';

  @override
  String get noTrainerCategoriesYet => 'ഇതുവരെ പരിശീലക വിഭാഗങ്ങളില്ല.';

  @override
  String get oneTrainerManyMembers => 'ഒരു പരിശീലകന് പല അംഗങ്ങളെ എടുക്കാം';

  @override
  String get categoryNameHint => 'റീഹാബ്, സ്ട്രെങ്ത്, യോഗ';

  @override
  String get edit => 'തിരുത്തുക';

  @override
  String get delete => 'ഇല്ലാതാക്കുക';

  @override
  String get keepIt => 'നിലനിർത്തുക';

  @override
  String deleteNamed(String name) {
    return '$name ഇല്ലാതാക്കണോ?';
  }

  @override
  String get decline => 'നിരസിക്കുക';

  @override
  String decidedBy(String name) {
    return '$name തീരുമാനിച്ചു';
  }

  @override
  String get createAGym => 'ജിം ഉണ്ടാക്കുക';

  @override
  String get createYourGym => 'നിങ്ങളുടെ ജിം ഉണ്ടാക്കുക';

  @override
  String get gymName => 'ജിമ്മിന്റെ പേര്';

  @override
  String get gymNameHint => 'അയൺ ടെമ്പിൾ ഫിറ്റ്നസ്';

  @override
  String get descriptionOptional => 'വിവരണം (ഐച്ഛികം)';

  @override
  String get descriptionHint => 'നിങ്ങളുടെ ജിമ്മിൽ ചേരാൻ എന്താണ് പ്രത്യേകത?';

  @override
  String get address => 'വിലാസം';

  @override
  String get city => 'നഗരം';

  @override
  String get district => 'ജില്ല';

  @override
  String get districtNote =>
      'തിരയലിൽ ജിമ്മിന്റെ പേരിനൊപ്പം ജില്ല കാണിക്കും, അതിനാൽ അംഗങ്ങൾക്ക് തിരിച്ചറിയാം.';

  @override
  String get state => 'സംസ്ഥാനം';

  @override
  String get pinCode => 'പിൻ കോഡ്';

  @override
  String get contactNumber => 'ബന്ധപ്പെടാനുള്ള നമ്പർ';

  @override
  String get leavePolicyNote =>
      'അംഗങ്ങൾക്ക് മാസത്തിൽ ചില ദിവസം അംഗത്വം നിർത്താം. അതിലധികമായാൽ അനുമതി വേണം.';

  @override
  String get perksLabel => 'സൗകര്യങ്ങൾ, കോമ കൊണ്ട് വേർതിരിക്കുക';

  @override
  String get perksHint => 'സ്റ്റീം റൂം, സൗജന്യ പാർക്കിംഗ്, പേഴ്സണൽ ട്രെയിനിംഗ്';

  @override
  String get createGym => 'ജിം ഉണ്ടാക്കുക';

  @override
  String get deleteGym => 'ജിം ഇല്ലാതാക്കുക';

  @override
  String get gymProfile => 'ജിം പ്രൊഫൈൽ';

  @override
  String get description => 'വിവരണം';

  @override
  String get leavePolicy => 'അവധി നയം';

  @override
  String get leaveDaysPerMonth => 'മാസത്തിൽ അവധി ദിവസങ്ങൾ';

  @override
  String get deleteThisGym => 'ഈ ജിം ഇല്ലാതാക്കുക';

  @override
  String get leaveLimitNote =>
      'ഈ പരിധിക്കുള്ളിലെ അംഗങ്ങളുടെ അപേക്ഷകൾ സ്വയമേവ അംഗീകരിക്കപ്പെടും. അതിലധികമായാൽ ആരുടെയെങ്കിലും അനുമതി വേണം.';

  @override
  String get draftNote =>
      'നിങ്ങളുടെ ജിം കരടായി തുടങ്ങുന്നു. പരിശോധന പൂർത്തിയാക്കി പ്ലാൻ എടുക്കുന്നത് വരെ തിരയലിൽ വരില്ല.';

  @override
  String get sendThis => 'ഇത് അയയ്ക്കണോ?';

  @override
  String get send => 'അയയ്ക്കുക';

  @override
  String get announcements => 'അറിയിപ്പുകൾ';

  @override
  String get title => 'തലക്കെട്ട്';

  @override
  String get announceTitleHint => 'അറ്റകുറ്റപ്പണിക്കായി ഞായറാഴ്ച അടച്ചിരിക്കും';

  @override
  String get message => 'സന്ദേശം';

  @override
  String get announceBodyHint =>
      'തിങ്കളാഴ്ച രാവിലെ 6 മണിക്ക് വീണ്ടും തുറക്കും. ചുരുങ്ങിയ അറിയിപ്പിന് ക്ഷമിക്കണം.';

  @override
  String get whoSeesIt => 'ആരു കാണും';

  @override
  String get everyone => 'എല്ലാവരും';

  @override
  String get sendAnnouncement => 'അറിയിപ്പ് അയയ്ക്കുക';

  @override
  String get sent => 'അയച്ചു';

  @override
  String get newGym => 'പുതിയ ജിം';

  @override
  String get draft => 'കരട്';

  @override
  String get nothingToChartYet => 'ഇതുവരെ കാണിക്കാൻ ഒന്നുമില്ല.';

  @override
  String peakValue(int value) {
    return 'ഉച്ചസ്ഥായി $value';
  }

  @override
  String get searchRanking => 'തിരയൽ റാങ്കിംഗ്';

  @override
  String get notInSearch => 'തിരയലിൽ ഇല്ല';

  @override
  String get members => 'അംഗങ്ങൾ';

  @override
  String get staff => 'ജീവനക്കാർ';

  @override
  String get leave => 'അവധി';

  @override
  String get roles => 'റോളുകൾ';

  @override
  String get analytics => 'വിശകലനം';

  @override
  String get growth => 'വളർച്ച';

  @override
  String get ranking => 'റാങ്കിംഗ്';

  @override
  String get plan => 'പ്ലാൻ';

  @override
  String get announce => 'അറിയിപ്പ്';

  @override
  String get trainers => 'പരിശീലകർ';

  @override
  String get present => 'ഹാജർ';

  @override
  String get absent => 'ഹാജരല്ല';

  @override
  String get markAttendance => 'ഹാജർ രേഖപ്പെടുത്തുക';

  @override
  String get getHelp => 'സഹായം തേടുക';

  @override
  String get getHelpSubtitle =>
      'ഞങ്ങൾക്ക് സന്ദേശം അയയ്ക്കുക, ഞങ്ങൾ ബന്ധപ്പെടും';

  @override
  String get termsAndPrivacy => 'നിബന്ധനകളും സ്വകാര്യതയും';

  @override
  String get signOut => 'സൈൻ ഔട്ട്';

  @override
  String get switchToStaff => 'ഉടമ/ജീവനക്കാർ മോഡിലേക്ക് മാറുക';

  @override
  String get switchToMember => 'അംഗ മോഡിലേക്ക് മാറുക';

  @override
  String get notifications => 'അറിയിപ്പുകൾ';

  @override
  String get noNotifications => 'പുതിയതായി ഒന്നുമില്ല';

  @override
  String get needsReview => 'വിവർത്തനം പരിശോധിക്കാനുണ്ട്';
}
