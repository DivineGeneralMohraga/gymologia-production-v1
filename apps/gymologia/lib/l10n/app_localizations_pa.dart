// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Panjabi Punjabi (`pa`).
class AppLocalizationsPa extends AppLocalizations {
  AppLocalizationsPa([String locale = 'pa']) : super(locale);

  @override
  String get appName => 'Gymologia';

  @override
  String get languageName => 'ਪੰਜਾਬੀ';

  @override
  String get settings => 'ਸੈਟਿੰਗਾਂ';

  @override
  String get language => 'ਭਾਸ਼ਾ';

  @override
  String get languageSubtitle =>
      'ਉਹ ਭਾਸ਼ਾ ਚੁਣੋ ਜਿਸ ਵਿੱਚ ਤੁਸੀਂ ਸਭ ਤੋਂ ਆਰਾਮ ਨਾਲ ਪੜ੍ਹਦੇ ਹੋ';

  @override
  String get save => 'ਸੰਭਾਲੋ';

  @override
  String get cancel => 'ਰੱਦ ਕਰੋ';

  @override
  String get tryAgain => 'ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ';

  @override
  String get loading => 'ਲੋਡ ਹੋ ਰਿਹਾ ਹੈ';

  @override
  String get somethingWentWrong => 'ਕੁਝ ਗਲਤ ਹੋ ਗਿਆ';

  @override
  String get signIn => 'ਸਾਈਨ ਇਨ';

  @override
  String get phoneNumber => 'ਮੋਬਾਈਲ ਨੰਬਰ';

  @override
  String get enterPhoneNumber => 'ਆਪਣਾ ਮੋਬਾਈਲ ਨੰਬਰ ਦਰਜ ਕਰੋ';

  @override
  String get sendCode => 'ਕੋਡ ਭੇਜੋ';

  @override
  String get verifyCode => 'ਤਸਦੀਕ ਕਰੋ';

  @override
  String get enterCode => 'ਅਸੀਂ ਭੇਜਿਆ ਕੋਡ ਦਰਜ ਕਰੋ';

  @override
  String get resendCode => 'ਦੁਬਾਰਾ ਭੇਜੋ';

  @override
  String get createAccount => 'ਆਪਣਾ ਖਾਤਾ ਬਣਾਓ';

  @override
  String get yourName => 'ਤੁਹਾਡਾ ਨਾਮ';

  @override
  String get emailOptional => 'ਈਮੇਲ (ਵਿਕਲਪਿਕ)';

  @override
  String get age => 'ਉਮਰ';

  @override
  String get whyAgeNotBirthday =>
      'ਅਸੀਂ ਤੁਹਾਡੀ ਉਮਰ ਪੁੱਛਦੇ ਹਾਂ, ਜਨਮ ਤਾਰੀਖ ਨਹੀਂ। ਜਨਮ ਤਾਰੀਖ ਤੁਹਾਡੇ ਬੈਂਕ ਅਤੇ ਸਰਕਾਰੀ ਦਸਤਾਵੇਜ਼ਾਂ ਨਾਲ ਜੁੜੀ ਹੁੰਦੀ ਹੈ — ਜਿਮ ਐਪ ਲਈ ਉਮਰ ਹੀ ਕਾਫ਼ੀ ਹੈ।';

  @override
  String get termsAgreement =>
      'ਖਾਤਾ ਬਣਾਉਣ ਦਾ ਮਤਲਬ ਹੈ ਕਿ ਤੁਸੀਂ ਵਰਤੋਂ ਦੀਆਂ ਸ਼ਰਤਾਂ ਅਤੇ ਪਰਦੇਦਾਰੀ ਨੀਤੀ ਮੰਨਦੇ ਹੋ।';

  @override
  String get signInWithMobile => 'ਆਪਣੇ ਮੋਬਾਈਲ ਨੰਬਰ ਨਾਲ ਸਾਈਨ ਇਨ ਕਰੋ';

  @override
  String get mobileNumber => 'ਮੋਬਾਈਲ ਨੰਬਰ';

  @override
  String get couldNotSendCode => 'ਕੋਡ ਨਹੀਂ ਭੇਜਿਆ ਜਾ ਸਕਿਆ।';

  @override
  String get verificationFailed => 'ਤਸਦੀਕ ਅਸਫਲ ਰਹੀ।';

  @override
  String get couldNotResendCode => 'ਕੋਡ ਦੁਬਾਰਾ ਨਹੀਂ ਭੇਜਿਆ ਜਾ ਸਕਿਆ।';

  @override
  String get couldNotCreateAccount => 'ਤੁਹਾਡਾ ਖਾਤਾ ਨਹੀਂ ਬਣ ਸਕਿਆ।';

  @override
  String weSentCodeTo(String phone) {
    return 'ਅਸੀਂ $phone ਉੱਤੇ ਕੋਡ ਭੇਜਿਆ ਹੈ';
  }

  @override
  String resendInSeconds(int seconds) {
    return '$seconds ਸਕਿੰਟਾਂ ਵਿੱਚ ਦੁਬਾਰਾ ਭੇਜੋ';
  }

  @override
  String get verified => 'ਤਸਦੀਕਸ਼ੁਦਾ';

  @override
  String get createAccountAction => 'ਖਾਤਾ ਬਣਾਓ';

  @override
  String get supportSent => 'ਭੇਜ ਦਿੱਤਾ। ਤੁਹਾਡੇ ਦਿੱਤੇ ਨੰਬਰ ਉੱਤੇ ਜਵਾਬ ਆਵੇਗਾ।';

  @override
  String get supportSubject => 'ਇਹ ਕਿਸ ਬਾਰੇ ਹੈ?';

  @override
  String get supportSubjectHint => 'ਮੇਰੇ ਮੈਂਬਰਸ਼ਿਪ ਦੇ ਦਿਨ ਗਲਤ ਦਿਖ ਰਹੇ ਹਨ';

  @override
  String get supportMessage => 'ਦੱਸੋ ਕੀ ਹੋਇਆ';

  @override
  String get supportReplyTo => 'ਅਸੀਂ ਕਿੱਥੇ ਜਵਾਬ ਦੇਈਏ?';

  @override
  String get supportUrgent => 'ਇਸ ਕਰਕੇ ਮੇਰਾ ਜਿਮ ਚੱਲ ਨਹੀਂ ਰਿਹਾ';

  @override
  String get supportUrgentNote => 'ਤਰਜੀਹ ਵਧਾਉਂਦਾ ਹੈ।';

  @override
  String copiedToClipboard(String value) {
    return '$value ਕਾਪੀ ਹੋ ਗਿਆ';
  }

  @override
  String orEmailUs(String email) {
    return 'ਜਾਂ $email ਉੱਤੇ ਈਮੇਲ ਕਰੋ';
  }

  @override
  String get whatYouHaveAsked => 'ਤੁਸੀਂ ਕੀ ਪੁੱਛਿਆ ਹੈ';

  @override
  String get aFewWordsIsEnough => 'ਕੁਝ ਸ਼ਬਦ ਹੀ ਕਾਫ਼ੀ ਹਨ';

  @override
  String get aSentenceOrTwoHelps => 'ਇੱਕ-ਦੋ ਵਾਕ ਲਿਖੋ, ਇਸ ਨਾਲ ਛੇਤੀ ਹੱਲ ਹੋਵੇਗਾ';

  @override
  String get ticketOpen => 'ਕਿਸੇ ਦੇ ਚੁੱਕਣ ਦੀ ਉਡੀਕ ਹੈ';

  @override
  String get ticketInProgress => 'ਕੋਈ ਇਸ ਨੂੰ ਵੇਖ ਰਿਹਾ ਹੈ';

  @override
  String get ticketWaitingOnUser => 'ਤੁਹਾਡੇ ਜਵਾਬ ਦੀ ਉਡੀਕ ਹੈ';

  @override
  String get ticketResolved => 'ਹੱਲ ਹੋ ਗਿਆ';

  @override
  String get ticketClosed => 'ਬੰਦ';

  @override
  String get referralPitch =>
      'ਕੋਡ ਸਾਂਝਾ ਕਰੋ, ਅਤੇ ਜਦੋਂ ਕੋਈ ਜਿਮ ਮਾਲਕ ਸਬਸਕ੍ਰਿਪਸ਼ਨ ਲਵੇ ਤਾਂ ਕਮਾਓ। ਰੈਫ਼ਰਲ ਐਪ ਅਜੇ ਨਹੀਂ ਆਈ।';

  @override
  String get appTagline => 'ਜਿਮੋਲੋਜੀਆ · ਮੈਂਬਰ ਅਤੇ ਸਟਾਫ';

  @override
  String get signOutQuestion => 'ਸਾਈਨ ਆਊਟ ਕਰਨਾ ਹੈ?';

  @override
  String get signOutWarning =>
      'ਦੁਬਾਰਾ ਸਾਈਨ ਇਨ ਕਰਨ ਲਈ ਤੁਹਾਡਾ ਫ਼ੋਨ ਚਾਹੀਦਾ ਹੋਵੇਗਾ।';

  @override
  String get profileUpdated => 'ਪ੍ਰੋਫਾਈਲ ਅੱਪਡੇਟ ਹੋ ਗਈ।';

  @override
  String get yourProfile => 'ਤੁਹਾਡੀ ਪ੍ਰੋਫਾਈਲ';

  @override
  String get emailClearToRemove => 'ਵਿਕਲਪਿਕ। ਹਟਾਉਣ ਲਈ ਖਾਲੀ ਕਰੋ।';

  @override
  String get phoneIsYourLogin =>
      'ਇਸੇ ਨਾਲ ਤੁਸੀਂ ਸਾਈਨ ਇਨ ਕਰਦੇ ਹੋ, ਇਸ ਲਈ ਇਸ ਨੂੰ ਇੱਥੇ ਹੁਣੇ ਬਦਲਿਆ ਨਹੀਂ ਜਾ ਸਕਦਾ। ਬਦਲਵਾਉਣਾ ਹੋਵੇ ਤਾਂ ਸਹਾਇਤਾ ਨਾਲ ਸੰਪਰਕ ਕਰੋ।';

  @override
  String get trialStarted =>
      'ਟ੍ਰਾਇਲ ਸ਼ੁਰੂ ਹੋ ਗਿਆ। ਤੁਹਾਡਾ ਜਿਮ ਹੁਣ ਖੋਜ ਵਿੱਚ ਦਿਖਦਾ ਹੈ।';

  @override
  String get invalidCode => 'ਕੋਡ ਵੈਧ ਨਹੀਂ ਹੈ।';

  @override
  String get paymentNotCompletedYet =>
      'ਭੁਗਤਾਨ ਅਜੇ ਪੂਰਾ ਨਹੀਂ ਹੋਇਆ। ਥੋੜ੍ਹੀ ਦੇਰ ਬਾਅਦ ਖਿੱਚ ਕੇ ਰਿਫ੍ਰੈਸ਼ ਕਰੋ।';

  @override
  String planIsActive(String plan) {
    return '$plan ਪਲਾਨ ਚਾਲੂ ਹੈ।';
  }

  @override
  String get paymentNotCompleted => 'ਭੁਗਤਾਨ ਪੂਰਾ ਨਹੀਂ ਹੋਇਆ।';

  @override
  String get couldNotOpenPayment => 'ਭੁਗਤਾਨ ਸਕਰੀਨ ਨਹੀਂ ਖੁੱਲ੍ਹ ਸਕੀ।';

  @override
  String daysFree(int days) {
    return '$days ਦਿਨ ਮੁਫ਼ਤ';
  }

  @override
  String get trialBlurb =>
      'ਪੂਰਾ ਪ੍ਰੋ, ਮੈਂਬਰ ਖੋਜ ਵਿੱਚ ਤੁਹਾਡੀ ਸੂਚੀ ਸਮੇਤ। ਕਾਰਡ ਦੀ ਲੋੜ ਨਹੀਂ, ਅਤੇ ਇਹ ਆਪਣੇ ਆਪ ਕਿਸੇ ਭੁਗਤਾਨ ਵਾਲੇ ਪਲਾਨ ਵਿੱਚ ਨਹੀਂ ਬਦਲਦਾ।';

  @override
  String get startFreeTrial => 'ਮੁਫ਼ਤ ਟ੍ਰਾਇਲ ਸ਼ੁਰੂ ਕਰੋ';

  @override
  String get referralCode => 'ਰੈਫ਼ਰਲ ਕੋਡ';

  @override
  String get optional => 'ਵਿਕਲਪਿਕ';

  @override
  String get apply => 'ਲਾਗੂ ਕਰੋ';

  @override
  String get gstNote =>
      'ਕੀਮਤਾਂ ਵਿੱਚ ਜੀਐਸਟੀ ਸ਼ਾਮਲ ਹੈ। ਜਿਮ ਸਿਰਫ਼ ਪ੍ਰੋ ਪਲਾਨ ਉੱਤੇ ਹੀ ਮੈਂਬਰ ਖੋਜ ਵਿੱਚ ਦਿਖਦਾ ਹੈ।';

  @override
  String planNamed(String plan) {
    return '$plan ਪਲਾਨ';
  }

  @override
  String get trialBadge => 'ਟ੍ਰਾਇਲ';

  @override
  String get expired => 'ਮਿਆਦ ਪੁੱਗੀ';

  @override
  String daysRemainingPlan(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ਦਿਨ ਬਾਕੀ',
    );
    return '$_temp0';
  }

  @override
  String get listedInSearch => 'ਮੈਂਬਰ ਖੋਜ ਵਿੱਚ ਸੂਚੀਬੱਧ';

  @override
  String get notListedUpgrade =>
      'ਖੋਜ ਵਿੱਚ ਨਹੀਂ — ਦਿਖਣ ਲਈ ਪ੍ਰੋ ਵਿੱਚ ਅੱਪਗ੍ਰੇਡ ਕਰੋ';

  @override
  String get trialEndsNote =>
      'ਟ੍ਰਾਇਲ ਖ਼ਤਮ ਹੋਣ ਉੱਤੇ ਜਦੋਂ ਤੱਕ ਤੁਸੀਂ ਪਲਾਨ ਨਹੀਂ ਚੁਣਦੇ, ਤੁਹਾਡਾ ਜਿਮ ਖੋਜ ਵਿੱਚੋਂ ਹਟ ਜਾਂਦਾ ਹੈ। ਆਪਣੇ ਆਪ ਕੁਝ ਨਹੀਂ ਕੱਟਿਆ ਜਾਂਦਾ।';

  @override
  String get getsYouListed => 'ਖੋਜ ਵਿੱਚ ਦਿਖਾਉਂਦਾ ਹੈ';

  @override
  String get perMonth => '/ਮਹੀਨਾ';

  @override
  String choosePlanNamed(String plan) {
    return '$plan ਚੁਣੋ';
  }

  @override
  String get home => 'ਹੋਮ';

  @override
  String get myGym => 'ਮੇਰਾ ਜਿਮ';

  @override
  String get discover => 'ਖੋਜੋ';

  @override
  String get sendOtp => 'OTP ਭੇਜੋ';

  @override
  String get verifyYourNumber => 'ਆਪਣਾ ਨੰਬਰ ਤਸਦੀਕ ਕਰੋ';

  @override
  String get codeResent => 'ਨਵਾਂ ਕੋਡ ਭੇਜਿਆ ਜਾ ਰਿਹਾ ਹੈ।';

  @override
  String get name => 'ਨਾਮ';

  @override
  String get email => 'ਈਮੇਲ';

  @override
  String get connection => 'ਕਨੈਕਸ਼ਨ';

  @override
  String get account => 'ਖਾਤਾ';

  @override
  String get session => 'ਸੈਸ਼ਨ';

  @override
  String get earnByReferring => 'ਰੈਫਰ ਕਰਕੇ ਕਮਾਓ';

  @override
  String get gyms => 'ਜਿਮ';

  @override
  String get events => 'ਸਮਾਗਮ';

  @override
  String get chat => 'ਚੈਟ';

  @override
  String get profile => 'ਪ੍ਰੋਫਾਈਲ';

  @override
  String get findAGym => 'ਜਿਮ ਲੱਭੋ';

  @override
  String get searchGyms => 'ਨਾਮ ਜਾਂ ਇਲਾਕੇ ਨਾਲ ਲੱਭੋ';

  @override
  String get noGymsFound => 'ਇੱਥੇ ਅਜੇ ਕੋਈ ਜਿਮ ਨਹੀਂ';

  @override
  String get perks => 'ਸਹੂਲਤਾਂ';

  @override
  String get contactGym => 'ਇਸ ਜਿਮ ਨਾਲ ਸੰਪਰਕ ਕਰੋ';

  @override
  String get rating => 'ਰੇਟਿੰਗ';

  @override
  String get yourMembership => 'ਤੁਹਾਡੀ ਮੈਂਬਰਸ਼ਿਪ';

  @override
  String get onLeavePaused => 'ਛੁੱਟੀ \'ਤੇ — ਤੁਹਾਡੀ ਮੈਂਬਰਸ਼ਿਪ ਰੁਕੀ ਹੋਈ ਹੈ';

  @override
  String get monthlyCheckIn => 'ਮਹੀਨਾਵਾਰ ਜਾਂਚ';

  @override
  String get notNow => 'ਹੁਣ ਨਹੀਂ';

  @override
  String trainerNamed(String name) {
    return 'ਟ੍ਰੇਨਰ: $name';
  }

  @override
  String goalAtGym(String gym) {
    return '$gym ਵਿੱਚ ਤੁਹਾਡਾ ਟੀਚਾ';
  }

  @override
  String daysRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ਦਿਨ ਬਾਕੀ',
      one: '1 ਦਿਨ ਬਾਕੀ',
      zero: 'ਅੱਜ ਖਤਮ',
    );
    return '$_temp0';
  }

  @override
  String get yourGoal => 'ਤੁਹਾਡਾ ਟੀਚਾ';

  @override
  String get trainer => 'ਟ੍ਰੇਨਰ';

  @override
  String get requestLeave => 'ਛੁੱਟੀ ਦੀ ਬੇਨਤੀ';

  @override
  String get yourProgress => 'ਤੁਹਾਡੀ ਤਰੱਕੀ';

  @override
  String get addMeasurementsPrompt =>
      'ਆਪਣਾ ਭਾਰ ਅਤੇ ਕੱਦ ਦਰਜ ਕਰੋ ਤਾਂ ਜੋ ਜਿਮ ਤੁਹਾਡੇ ਨਾਲ ਤਰੱਕੀ ਦੇਖ ਸਕੇ।';

  @override
  String get progressSubtitle => 'ਸਮੇਂ ਨਾਲ ਭਾਰ, ਅਤੇ ਤੁਸੀਂ ਕਿੰਨੀ ਵਾਰ ਆਏ।';

  @override
  String get attendanceAppearsHere =>
      'ਜਦੋਂ ਤੁਸੀਂ ਕਿਸੇ ਜਿਮ ਦੇ ਮੈਂਬਰ ਬਣੋਗੇ ਅਤੇ ਸਟਾਫ਼ ਹਾਜ਼ਰੀ ਲਗਾਉਣ ਲੱਗੇਗਾ, ਤਾਂ ਇਹ ਇੱਥੇ ਦਿਖੇਗੀ।';

  @override
  String get twoCheckInsDrawALine =>
      'ਦੋ ਦਰਜਾਂ ਨਾਲ ਰੇਖਾ ਬਣਦੀ ਹੈ। ਹਰ ਮਹੀਨੇ ਭਾਰ ਦਰਜ ਕਰੋ, ਇਹ ਭਰਦੀ ਜਾਵੇਗੀ।';

  @override
  String get nothingMatchesFilters => 'ਇਹਨਾਂ ਫਿਲਟਰਾਂ ਨਾਲ ਕੁਝ ਮੇਲ ਨਹੀਂ ਖਾਂਦਾ।';

  @override
  String get howToJoinGym =>
      'ਜੁੜਨ ਲਈ ਸਿੱਧਾ ਜਿਮ ਨਾਲ ਸੰਪਰਕ ਕਰੋ। ਉਹ ਤੁਹਾਨੂੰ ਮੈਂਬਰ ਵਜੋਂ ਜੋੜਨਗੇ।';

  @override
  String get weight => 'ਭਾਰ';

  @override
  String get height => 'ਕੱਦ';

  @override
  String get yourMeasurements => 'ਤੁਹਾਡੇ ਮਾਪ';

  @override
  String get addMeasurements =>
      'ਆਪਣਾ ਭਾਰ ਅਤੇ ਕੱਦ ਦਰਜ ਕਰੋ ਤਾਂ ਜੋ ਜਿਮ ਤੁਹਾਡੇ ਨਾਲ ਤਰੱਕੀ ਦੇਖ ਸਕੇ';

  @override
  String get checkInDue => 'ਇਸ ਮਹੀਨੇ ਦੀ ਜਾਂਚ ਬਾਕੀ ਹੈ';

  @override
  String get thisMonth => 'ਇਸ ਮਹੀਨੇ';

  @override
  String get perWeek => 'ਹਰ ਹਫ਼ਤੇ';

  @override
  String weeksRunning(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ਲਗਾਤਾਰ ਹਫ਼ਤੇ',
      one: 'ਲਗਾਤਾਰ ਹਫ਼ਤਾ',
    );
    return '$_temp0';
  }

  @override
  String get lastEightWeeks => 'ਪਿਛਲੇ 8 ਹਫ਼ਤੇ';

  @override
  String get exerciseDirectory => 'ਕਸਰਤ ਸੂਚੀ';

  @override
  String get exercises => 'ਕਸਰਤਾਂ';

  @override
  String get searchExercises => 'ਕਸਰਤ ਲੱਭੋ';

  @override
  String get clear => 'ਸਾਫ਼ ਕਰੋ';

  @override
  String get howToDoIt => 'ਕਿਵੇਂ ਕਰਨਾ ਹੈ';

  @override
  String get watchOutFor => 'ਧਿਆਨ ਰੱਖੋ';

  @override
  String get whatYouGet => 'ਤੁਹਾਨੂੰ ਕੀ ਮਿਲਦਾ ਹੈ';

  @override
  String get removeYourEntry => 'ਆਪਣੀ ਐਂਟਰੀ ਹਟਾਉਣੀ?';

  @override
  String get stayIn => 'ਰਹੋ';

  @override
  String get removeMe => 'ਮੈਨੂੰ ਹਟਾਓ';

  @override
  String get youAreInTapToWithdraw => 'ਤੁਸੀਂ ਸ਼ਾਮਲ ਹੋ — ਹਟਣ ਲਈ ਟੈਪ ਕਰੋ';

  @override
  String get participate => 'ਭਾਗ ਲਵੋ';

  @override
  String takenOffList(String event) {
    return '$event ਦੀ ਸੂਚੀ ਵਿੱਚੋਂ ਤੁਹਾਡਾ ਨਾਮ ਹਟਾ ਦਿੱਤਾ ਜਾਵੇਗਾ।';
  }

  @override
  String contactWithPhone(String phone) {
    return 'ਸੰਪਰਕ $phone';
  }

  @override
  String get reasonOptional => 'ਕਾਰਨ (ਵਿਕਲਪਿਕ)';

  @override
  String get searchByGymCityDistrict => 'ਜਿਮ, ਸ਼ਹਿਰ ਜਾਂ ਜ਼ਿਲ੍ਹੇ ਨਾਲ ਲੱਭੋ';

  @override
  String get exerciseDirectorySubtitle =>
      'ਤਾਕਤ, ਕਾਰਡੀਓ ਅਤੇ ਯੋਗ, ਹਰ ਕਦਮ ਦੀ ਹਿਦਾਇਤ ਨਾਲ';

  @override
  String get steps => 'ਕਦਮ';

  @override
  String get attendance => 'ਹਾਜ਼ਰੀ';

  @override
  String get manage => 'ਪ੍ਰਬੰਧਨ';

  @override
  String get choosePlan => 'ਪਲਾਨ ਚੁਣੋ';

  @override
  String get seeGrowthOverTime => 'ਸਮੇਂ ਨਾਲ ਵਾਧਾ ਵੇਖੋ';

  @override
  String lastNDays(int days) {
    return 'ਪਿਛਲੇ $days ਦਿਨ';
  }

  @override
  String get addMember => 'ਮੈਂਬਰ ਸ਼ਾਮਲ ਕਰੋ';

  @override
  String get addStaff => 'ਸਟਾਫ਼ ਸ਼ਾਮਲ ਕਰੋ';

  @override
  String get searchByNameOrNumber => 'ਨਾਮ ਜਾਂ ਨੰਬਰ ਨਾਲ ਲੱਭੋ';

  @override
  String get tapCircleToMarkPresent =>
      'ਹਾਜ਼ਰੀ ਲਈ ਗੋਲੇ \'ਤੇ ਟੈਪ ਕਰੋ, ਵੇਰਵਿਆਂ ਲਈ ਕਤਾਰ \'ਤੇ';

  @override
  String markedPresent(String name) {
    return '$name ਹਾਜ਼ਰ ਦਰਜ';
  }

  @override
  String get approve => 'ਮਨਜ਼ੂਰ ਕਰੋ';

  @override
  String get role => 'ਭੂਮਿਕਾ';

  @override
  String get theirName => 'ਉਹਨਾਂ ਦਾ ਨਾਮ';

  @override
  String get theirMobileNumber => 'ਉਹਨਾਂ ਦਾ ਮੋਬਾਈਲ ਨੰਬਰ';

  @override
  String get codeFromTheirPhone => 'ਉਹਨਾਂ ਦੇ ਫ਼ੋਨ ਦਾ ਕੋਡ';

  @override
  String get whatDoTheyWant => 'ਉਹ ਜਿਮ ਤੋਂ ਕੀ ਚਾਹੁੰਦੇ ਹਨ?';

  @override
  String get goalHint => 'ਭਾਰ ਵਧਾਉਣਾ, ਘਟਾਉਣਾ, ਰੀਹੈਬ…';

  @override
  String get saveChanges => 'ਤਬਦੀਲੀਆਂ ਸੰਭਾਲੋ';

  @override
  String get removeFromGym => 'ਜਿਮ ਤੋਂ ਹਟਾਓ';

  @override
  String get remove => 'ਹਟਾਓ';

  @override
  String removePerson(String name) {
    return '$name ਨੂੰ ਹਟਾਉਣਾ?';
  }

  @override
  String get onLeave => 'ਛੁੱਟੀ';

  @override
  String get tapDayToCorrect => 'ਸੁਧਾਰਨ ਲਈ ਦਿਨ ਉੱਤੇ ਟੈਪ ਕਰੋ';

  @override
  String correctDate(String date) {
    return '$date ਸੁਧਾਰੋ';
  }

  @override
  String get whyIsThisChanging => 'ਇਹ ਕਿਉਂ ਬਦਲ ਰਿਹਾ ਹੈ?';

  @override
  String get correctionReasonHint => 'ਗਲਤੀ ਨਾਲ ਦਰਜ, ਮਸ਼ੀਨ ਬੰਦ ਸੀ…';

  @override
  String get saveCorrection => 'ਸੁਧਾਰ ਸੰਭਾਲੋ';

  @override
  String get recordCorrected => 'ਰਿਕਾਰਡ ਸੁਧਰ ਗਿਆ।';

  @override
  String get trainerCategories => 'ਟ੍ਰੇਨਰ ਸ਼੍ਰੇਣੀਆਂ';

  @override
  String get newCategory => 'ਨਵੀਂ ਸ਼੍ਰੇਣੀ';

  @override
  String get noTrainerCategoriesYet => 'ਹਾਲੇ ਕੋਈ ਟ੍ਰੇਨਰ ਸ਼੍ਰੇਣੀ ਨਹੀਂ।';

  @override
  String get oneTrainerManyMembers => 'ਇੱਕ ਟ੍ਰੇਨਰ ਕਈ ਮੈਂਬਰ ਲੈ ਸਕਦਾ ਹੈ';

  @override
  String get categoryNameHint => 'ਰੀਹੈਬ, ਤਾਕਤ, ਯੋਗ';

  @override
  String get edit => 'ਸੋਧੋ';

  @override
  String get delete => 'ਮਿਟਾਓ';

  @override
  String get keepIt => 'ਰਹਿਣ ਦਿਓ';

  @override
  String deleteNamed(String name) {
    return '$name ਮਿਟਾਉਣਾ?';
  }

  @override
  String get decline => 'ਰੱਦ ਕਰੋ';

  @override
  String decidedBy(String name) {
    return '$name ਵੱਲੋਂ ਫੈਸਲਾ';
  }

  @override
  String get createAGym => 'ਜਿਮ ਬਣਾਓ';

  @override
  String get createYourGym => 'ਆਪਣਾ ਜਿਮ ਬਣਾਓ';

  @override
  String get gymName => 'ਜਿਮ ਦਾ ਨਾਮ';

  @override
  String get gymNameHint => 'ਆਇਰਨ ਟੈਂਪਲ ਫਿਟਨੈਸ';

  @override
  String get descriptionOptional => 'ਵਰਣਨ (ਵਿਕਲਪਿਕ)';

  @override
  String get descriptionHint => 'ਤੁਹਾਡੇ ਜਿਮ ਵਿੱਚ ਜੁੜਨ ਵਾਲੀ ਕੀ ਗੱਲ ਹੈ?';

  @override
  String get address => 'ਪਤਾ';

  @override
  String get city => 'ਸ਼ਹਿਰ';

  @override
  String get district => 'ਜ਼ਿਲ੍ਹਾ';

  @override
  String get districtNote =>
      'ਖੋਜ ਵਿੱਚ ਤੁਹਾਡੇ ਜਿਮ ਦੇ ਨਾਮ ਕੋਲ ਜ਼ਿਲ੍ਹਾ ਦਿਖਦਾ ਹੈ, ਤਾਂ ਜੋ ਮੈਂਬਰ ਪਛਾਣ ਸਕਣ।';

  @override
  String get state => 'ਰਾਜ';

  @override
  String get pinCode => 'ਪਿੰਨ ਕੋਡ';

  @override
  String get contactNumber => 'ਸੰਪਰਕ ਨੰਬਰ';

  @override
  String get leavePolicyNote =>
      'ਮੈਂਬਰ ਮਹੀਨੇ ਵਿੱਚ ਕੁਝ ਦਿਨ ਮੈਂਬਰਸ਼ਿਪ ਰੋਕ ਸਕਦੇ ਹਨ। ਇਸ ਤੋਂ ਵੱਧ ਲਈ ਮਨਜ਼ੂਰੀ ਚਾਹੀਦੀ ਹੈ।';

  @override
  String get perksLabel => 'ਸਹੂਲਤਾਂ, ਕਾਮੇ ਨਾਲ ਵੱਖ';

  @override
  String get perksHint => 'ਸਟੀਮ ਰੂਮ, ਮੁਫ਼ਤ ਪਾਰਕਿੰਗ, ਪਰਸਨਲ ਟ੍ਰੇਨਿੰਗ';

  @override
  String get createGym => 'ਜਿਮ ਬਣਾਓ';

  @override
  String get deleteGym => 'ਜਿਮ ਮਿਟਾਓ';

  @override
  String get gymProfile => 'ਜਿਮ ਪ੍ਰੋਫਾਈਲ';

  @override
  String get description => 'ਵਰਣਨ';

  @override
  String get leavePolicy => 'ਛੁੱਟੀ ਨੀਤੀ';

  @override
  String get leaveDaysPerMonth => 'ਮਹੀਨੇ ਵਿੱਚ ਛੁੱਟੀ ਦੇ ਦਿਨ';

  @override
  String get deleteThisGym => 'ਇਹ ਜਿਮ ਮਿਟਾਓ';

  @override
  String get leaveLimitNote =>
      'ਇਸ ਹੱਦ ਅੰਦਰ ਮੈਂਬਰਾਂ ਦੀਆਂ ਬੇਨਤੀਆਂ ਆਪਣੇ ਆਪ ਮਨਜ਼ੂਰ ਹੋ ਜਾਂਦੀਆਂ ਹਨ। ਇਸ ਤੋਂ ਵੱਧ ਲਈ ਕਿਸੇ ਦੀ ਮਨਜ਼ੂਰੀ ਚਾਹੀਦੀ ਹੈ।';

  @override
  String get draftNote =>
      'ਤੁਹਾਡਾ ਜਿਮ ਖਰੜੇ ਵਜੋਂ ਸ਼ੁਰੂ ਹੁੰਦਾ ਹੈ। ਤਸਦੀਕ ਪੂਰੀ ਕਰਕੇ ਪਲਾਨ ਲੈਣ ਤੱਕ ਇਹ ਖੋਜ ਵਿੱਚ ਨਹੀਂ ਦਿਖੇਗਾ।';

  @override
  String get sendThis => 'ਇਹ ਭੇਜਣਾ?';

  @override
  String get send => 'ਭੇਜੋ';

  @override
  String get announcements => 'ਐਲਾਨ';

  @override
  String get title => 'ਸਿਰਲੇਖ';

  @override
  String get announceTitleHint => 'ਦੇਖਭਾਲ ਲਈ ਐਤਵਾਰ ਬੰਦ';

  @override
  String get message => 'ਸੁਨੇਹਾ';

  @override
  String get announceBodyHint =>
      'ਅਸੀਂ ਸੋਮਵਾਰ ਸਵੇਰੇ 6 ਵਜੇ ਦੁਬਾਰਾ ਖੋਲ੍ਹਾਂਗੇ। ਥੋੜ੍ਹੀ ਸੂਚਨਾ ਲਈ ਮਾਫ਼ ਕਰਨਾ।';

  @override
  String get whoSeesIt => 'ਕੌਣ ਵੇਖੇਗਾ';

  @override
  String get everyone => 'ਸਾਰੇ';

  @override
  String get sendAnnouncement => 'ਐਲਾਨ ਭੇਜੋ';

  @override
  String get sent => 'ਭੇਜਿਆ ਗਿਆ';

  @override
  String get newGym => 'ਨਵਾਂ ਜਿਮ';

  @override
  String get draft => 'ਖਰੜਾ';

  @override
  String get nothingToChartYet => 'ਹਾਲੇ ਦਿਖਾਉਣ ਲਈ ਕੁਝ ਨਹੀਂ।';

  @override
  String peakValue(int value) {
    return 'ਸਿਖਰ $value';
  }

  @override
  String get searchRanking => 'ਖੋਜ ਦਰਜਾਬੰਦੀ';

  @override
  String get notInSearch => 'ਖੋਜ ਵਿੱਚ ਨਹੀਂ';

  @override
  String get members => 'ਮੈਂਬਰ';

  @override
  String get staff => 'ਸਟਾਫ਼';

  @override
  String get leave => 'ਛੁੱਟੀ';

  @override
  String get roles => 'ਭੂਮਿਕਾਵਾਂ';

  @override
  String get analytics => 'ਵਿਸ਼ਲੇਸ਼ਣ';

  @override
  String get growth => 'ਵਾਧਾ';

  @override
  String get ranking => 'ਦਰਜਾਬੰਦੀ';

  @override
  String get plan => 'ਪਲਾਨ';

  @override
  String get announce => 'ਐਲਾਨ';

  @override
  String get trainers => 'ਟ੍ਰੇਨਰ';

  @override
  String get present => 'ਹਾਜ਼ਰ';

  @override
  String get absent => 'ਗੈਰਹਾਜ਼ਰ';

  @override
  String get markAttendance => 'ਹਾਜ਼ਰੀ ਲਗਾਓ';

  @override
  String get getHelp => 'ਮਦਦ ਲਵੋ';

  @override
  String get getHelpSubtitle => 'ਸਾਨੂੰ ਸੁਨੇਹਾ ਭੇਜੋ, ਅਸੀਂ ਸੰਪਰਕ ਕਰਾਂਗੇ';

  @override
  String get termsAndPrivacy => 'ਸ਼ਰਤਾਂ ਅਤੇ ਪਰਦੇਦਾਰੀ';

  @override
  String get signOut => 'ਸਾਈਨ ਆਊਟ';

  @override
  String get switchToStaff => 'ਮਾਲਕ/ਸਟਾਫ਼ ਮੋਡ ਵਿੱਚ ਜਾਓ';

  @override
  String get switchToMember => 'ਮੈਂਬਰ ਮੋਡ ਵਿੱਚ ਜਾਓ';

  @override
  String get notifications => 'ਸੂਚਨਾਵਾਂ';

  @override
  String get noNotifications => 'ਨਵਾਂ ਕੁਝ ਨਹੀਂ';

  @override
  String get needsReview => 'ਅਨੁਵਾਦ ਦੀ ਸਮੀਖਿਆ ਬਾਕੀ';
}
