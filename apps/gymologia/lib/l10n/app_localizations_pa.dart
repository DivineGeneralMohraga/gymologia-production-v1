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
  String get somethingWentWrong => 'ਕੁਝ ਗਲਤ ਹੋ ਗਿਆ';

  @override
  String get phoneNumber => 'ਮੋਬਾਈਲ ਨੰਬਰ';

  @override
  String get enterPhoneNumber => 'ਆਪਣਾ ਮੋਬਾਈਲ ਨੰਬਰ ਦਰਜ ਕਰੋ';

  @override
  String get sendCode => 'ਕੋਡ ਭੇਜੋ';

  @override
  String get verifyCode => 'ਤਸਦੀਕ ਕਰੋ';

  @override
  String get resendCode => 'ਦੁਬਾਰਾ ਭੇਜੋ';

  @override
  String get createAccount => 'ਆਪਣਾ ਖਾਤਾ ਬਣਾਓ';

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
  String get deleteRoleWarning =>
      'ਭੂਮਿਕਾ ਅਤੇ ਉਸ ਦੀਆਂ ਇਜਾਜ਼ਤਾਂ ਚਲੀਆਂ ਜਾਣਗੀਆਂ। ਇਸ ਵਿੱਚ ਕੋਈ ਨਹੀਂ ਹੈ, ਇਸ ਲਈ ਕਿਸੇ ਦੀ ਪਹੁੰਚ ਨਹੀਂ ਜਾਵੇਗੀ।';

  @override
  String deletedNamed(String name) {
    return '$name ਮਿਟਾ ਦਿੱਤਾ';
  }

  @override
  String get needTwoCustomRoles =>
      'ਕ੍ਰਮ ਬਦਲਣ ਤੋਂ ਪਹਿਲਾਂ ਤੁਹਾਨੂੰ ਦੋ ਅਜਿਹੀਆਂ ਕਸਟਮ ਭੂਮਿਕਾਵਾਂ ਚਾਹੀਦੀਆਂ ਹਨ ਜੋ ਤੁਸੀਂ ਸੋਧ ਸਕੋ।';

  @override
  String get hierarchySaved => 'ਦਰਜਾਬੰਦੀ ਸੰਭਾਲੀ ਗਈ';

  @override
  String get reorder => 'ਕ੍ਰਮ ਬਦਲੋ';

  @override
  String get newRole => 'ਨਵੀਂ ਭੂਮਿਕਾ';

  @override
  String get rolesIntro =>
      'ਸਭ ਤੋਂ ਸੀਨੀਅਰ ਪਹਿਲਾਂ। ਤੁਸੀਂ ਸਿਰਫ਼ ਆਪਣੇ ਤੋਂ ਹੇਠਲੀਆਂ ਭੂਮਿਕਾਵਾਂ ਸੋਧ ਸਕਦੇ ਹੋ, ਅਤੇ ਸਿਰਫ਼ ਉਹੀ ਇਜਾਜ਼ਤਾਂ ਦੇ ਸਕਦੇ ਹੋ ਜੋ ਤੁਹਾਡੇ ਕੋਲ ਹਨ।';

  @override
  String get defaultBadge => 'ਡਿਫਾਲਟ';

  @override
  String get everyPermission => 'ਹਰ ਇਜਾਜ਼ਤ, ਬਾਅਦ ਵਿੱਚ ਜੁੜਨ ਵਾਲੀਆਂ ਸਮੇਤ';

  @override
  String permissionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ਇਜਾਜ਼ਤਾਂ',
    );
    return '$_temp0';
  }

  @override
  String get nobodyInThisRole => 'ਇਸ ਭੂਮਿਕਾ ਵਿੱਚ ਕੋਈ ਨਹੀਂ';

  @override
  String peopleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ਲੋਕ',
    );
    return '$_temp0';
  }

  @override
  String get deleteDefaultRolesStay => 'ਮਿਟਾਓ (ਡਿਫਾਲਟ ਭੂਮਿਕਾਵਾਂ ਰਹਿੰਦੀਆਂ ਹਨ)';

  @override
  String get deleteMovePeopleFirst => 'ਮਿਟਾਓ (ਪਹਿਲਾਂ ਲੋਕਾਂ ਨੂੰ ਹਟਾਓ)';

  @override
  String get giveRoleAName => 'ਭੂਮਿਕਾ ਨੂੰ ਨਾਮ ਦਿਓ';

  @override
  String get editRole => 'ਭੂਮਿਕਾ ਸੋਧੋ';

  @override
  String get createRole => 'ਭੂਮਿਕਾ ਬਣਾਓ';

  @override
  String get roleName => 'ਭੂਮਿਕਾ ਦਾ ਨਾਮ';

  @override
  String get roleNameHint => 'ਰਿਸੈਪਸ਼ਨ, ਫਿਜ਼ੀਓ, ਨਾਈਟ ਸ਼ਿਫਟ';

  @override
  String get superRoleNote =>
      'ਇਸ ਭੂਮਿਕਾ ਕੋਲ ਹਰ ਇਜਾਜ਼ਤ ਹੈ, ਅੱਗੇ ਜੁੜਨ ਵਾਲੀਆਂ ਸਮੇਤ। ਇਸ ਨੂੰ ਸੀਮਤ ਨਹੀਂ ਕੀਤਾ ਜਾ ਸਕਦਾ — ਇਹੀ ਉਹ ਭੂਮਿਕਾ ਹੈ ਜੋ ਹਮੇਸ਼ਾ ਚੀਜ਼ਾਂ ਠੀਕ ਕਰ ਸਕਦੀ ਹੈ।';

  @override
  String get whatThisRoleCanDo => 'ਇਹ ਭੂਮਿਕਾ ਕੀ ਕਰ ਸਕਦੀ ਹੈ';

  @override
  String get greyedOutNote =>
      'ਜੋ ਧੁੰਦਲਾ ਦਿਖਦਾ ਹੈ ਉਹ ਤੁਹਾਡੇ ਕੋਲ ਨਹੀਂ ਹੈ, ਇਸ ਲਈ ਤੁਸੀਂ ਉਹ ਅੱਗੇ ਨਹੀਂ ਦੇ ਸਕਦੇ।';

  @override
  String get ownerOnlyPermission => 'ਇਹ ਸਿਰਫ਼ ਜਿਮ ਮਾਲਕ ਕੋਲ ਹੈ';

  @override
  String get youDoNotHoldThis => 'ਇਹ ਤੁਹਾਡੇ ਕੋਲ ਨਹੀਂ ਹੈ';

  @override
  String get orderTheHierarchy => 'ਦਰਜਾਬੰਦੀ ਤੈਅ ਕਰੋ';

  @override
  String get hierarchyNote =>
      'ਸਭ ਤੋਂ ਸੀਨੀਅਰ ਉੱਪਰ। ਡਿਫਾਲਟ ਭੂਮਿਕਾਵਾਂ ਆਪਣੀ ਥਾਂ ਰਹਿੰਦੀਆਂ ਹਨ ਅਤੇ ਇੱਥੇ ਨਹੀਂ ਦਿਖਦੀਆਂ।';

  @override
  String get saveOrder => 'ਕ੍ਰਮ ਸੰਭਾਲੋ';

  @override
  String membershipExtendedBy(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ਮੈਂਬਰਸ਼ਿਪ $count ਮਹੀਨੇ ਵਧਾ ਦਿੱਤੀ।',
    );
    return '$_temp0';
  }

  @override
  String get goalUpdated => 'ਟੀਚਾ ਅੱਪਡੇਟ ਹੋ ਗਿਆ।';

  @override
  String get thisMember => 'ਇਹ ਮੈਂਬਰ';

  @override
  String get removeMemberQuestion => 'ਮੈਂਬਰ ਹਟਾਉਣਾ ਹੈ?';

  @override
  String removeMemberWarning(String name) {
    return '$name ਦੀ ਇਸ ਜਿਮ ਤੱਕ ਪਹੁੰਚ ਖ਼ਤਮ ਹੋ ਜਾਵੇਗੀ। ਉਹਨਾਂ ਦਾ ਹਾਜ਼ਰੀ ਰਿਕਾਰਡ ਅਤੇ ਮਾਪ ਰੱਖੇ ਜਾਂਦੇ ਹਨ।';
  }

  @override
  String get member => 'ਮੈਂਬਰ';

  @override
  String get removeMember => 'ਮੈਂਬਰ ਹਟਾਓ';

  @override
  String get daysLeft => 'ਬਾਕੀ ਦਿਨ';

  @override
  String get leaveUsed => 'ਲਈ ਗਈ ਛੁੱਟੀ';

  @override
  String get extend => 'ਵਧਾਓ';

  @override
  String get editGoal => 'ਟੀਚਾ ਸੋਧੋ';

  @override
  String get goal => 'ਟੀਚਾ';

  @override
  String get notSet => 'ਤੈਅ ਨਹੀਂ';

  @override
  String get noneAssigned => 'ਕੋਈ ਨਹੀਂ ਸੌਂਪਿਆ';

  @override
  String get attendanceHistory => 'ਹਾਜ਼ਰੀ ਇਤਿਹਾਸ';

  @override
  String get viewAndCorrectRecords => 'ਰਿਕਾਰਡ ਵੇਖੋ ਅਤੇ ਠੀਕ ਕਰੋ';

  @override
  String sessionsSoFar(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ਹੁਣ ਤੱਕ $count ਸੈਸ਼ਨ',
    );
    return '$_temp0';
  }

  @override
  String get progressIsPrivate => 'ਤਰੱਕੀ ਨਿੱਜੀ ਹੈ';

  @override
  String get monitoringOffNote =>
      'ਇਸ ਮੈਂਬਰ ਨੇ ਤਰੱਕੀ ਦੀ ਨਿਗਰਾਨੀ ਬੰਦ ਕੀਤੀ ਹੈ। ਇਹ ਉਹਨਾਂ ਦਾ ਫ਼ੈਸਲਾ ਹੈ ਅਤੇ ਕੋਈ ਭੂਮਿਕਾ ਇਸ ਨੂੰ ਨਹੀਂ ਬਦਲ ਸਕਦੀ।';

  @override
  String get progress => 'ਤਰੱਕੀ';

  @override
  String get noMeasurementsYet =>
      'ਅਜੇ ਕੋਈ ਮਾਪ ਦਰਜ ਨਹੀਂ ਹੋਏ। ਮੈਂਬਰ ਨੂੰ ਉਹਨਾਂ ਦੀ ਆਪਣੀ ਐਪ ਵਿੱਚ ਮਹੀਨੇ ਵਿੱਚ ਇੱਕ ਵਾਰ ਪੁੱਛਿਆ ਜਾਂਦਾ ਹੈ।';

  @override
  String holdingAtKg(String kg) {
    return '$kg ਕਿਲੋ ਉੱਤੇ ਸਥਿਰ';
  }

  @override
  String weightChangeSince(String delta) {
    return 'ਪਹਿਲੇ ਮਾਪ ਤੋਂ ਬਾਅਦ $delta ਕਿਲੋ';
  }

  @override
  String get extendMembership => 'ਮੈਂਬਰਸ਼ਿਪ ਵਧਾਓ';

  @override
  String get extendFromTodayNote =>
      'ਮਿਆਦ ਪੁੱਗੀ ਮੈਂਬਰਸ਼ਿਪ ਅੱਜ ਤੋਂ ਵਧਦੀ ਹੈ, ਉਸ ਤਾਰੀਖ਼ ਤੋਂ ਨਹੀਂ ਜਦੋਂ ਉਹ ਖ਼ਤਮ ਹੋਈ ਸੀ।';

  @override
  String monthsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ਮਹੀਨੇ',
    );
    return '$_temp0';
  }

  @override
  String extendByMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ਮਹੀਨੇ ਵਧਾਓ',
    );
    return '$_temp0';
  }

  @override
  String get whatAreTheyWorkingTowards => 'ਉਹ ਕਿਸ ਟੀਚੇ ਉੱਤੇ ਕੰਮ ਕਰ ਰਹੇ ਹਨ?';

  @override
  String get goalDialogHint => '80 ਕਿਲੋ ਤੱਕ ਬਲਕ, ਭਾਰ ਘਟਾਉਣਾ, ਰੀਹੈਬ…';

  @override
  String signedUpCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ਨੇ ਨਾਮ ਲਿਖਵਾਇਆ',
    );
    return '$_temp0';
  }

  @override
  String get nobodyYet => 'ਅਜੇ ਕੋਈ ਨਹੀਂ।';

  @override
  String get hostAnEvent => 'ਇੱਕ ਸਮਾਗਮ ਕਰਵਾਓ';

  @override
  String get noEventsYet =>
      'ਅਜੇ ਕੋਈ ਸਮਾਗਮ ਨਹੀਂ। ਇੱਕ ਕਰਵਾਓ, ਉਹ ਤੁਹਾਡੇ ਮੈਂਬਰਾਂ ਨੂੰ ਤੁਰੰਤ ਦਿਖੇਗਾ।';

  @override
  String get editEvent => 'ਇਵੈਂਟ ਸੰਪਾਦਿਤ ਕਰੋ';

  @override
  String get cancelEvent => 'ਇਵੈਂਟ ਰੱਦ ਕਰੋ';

  @override
  String get cancelEventConfirmTitle => 'ਕੀ ਇਸ ਇਵੈਂਟ ਨੂੰ ਰੱਦ ਕਰਨਾ ਹੈ?';

  @override
  String get cancelEventConfirmBody =>
      'ਇਹ ਮੈਂਬਰਾਂ ਦੀ ਇਵੈਂਟ ਫੀਡ ਤੋਂ ਗਾਇਬ ਹੋ ਜਾਵੇਗਾ। ਜਿਨ੍ਹਾਂ ਨੇ ਪਹਿਲਾਂ ਹੀ ਰਜਿਸਟਰ ਕੀਤਾ ਹੈ ਉਹਨਾਂ ਦਾ ਰਿਕਾਰਡ ਰਹੇਗਾ, ਅਤੇ ਇਹ ਇੱਥੋਂ ਵਾਪਸ ਨਹੀਂ ਲਿਆ ਜਾ ਸਕਦਾ।';

  @override
  String get keepEvent => 'ਇਵੈਂਟ ਰੱਖੋ';

  @override
  String get eventCancelledBadge => 'ਰੱਦ';

  @override
  String get eventUpdated => 'ਇਵੈਂਟ ਅੱਪਡੇਟ ਹੋਇਆ';

  @override
  String get eventCancelledSnackbar => 'ਇਵੈਂਟ ਰੱਦ ਕਰ ਦਿੱਤਾ ਗਿਆ';

  @override
  String get eventTitleHint => 'ਸਮਰ ਡੈੱਡਲਿਫਟ ਮੀਟ';

  @override
  String get howToTakePart => 'ਹਿੱਸਾ ਕਿਵੇਂ ਲੈਣਾ ਹੈ';

  @override
  String get howToTakePartHint => 'ਸਵੇਰੇ 8 ਵਜੇ ਭਾਰ। ਆਪਣੀ ਬੈਲਟ ਲਿਆਓ।';

  @override
  String get prizeOptional => 'ਇਨਾਮ (ਵਿਕਲਪਿਕ)';

  @override
  String get prizeHint => '₹10,000';

  @override
  String get membersCanSignUp => 'ਮੈਂਬਰ ਐਪ ਵਿੱਚ ਨਾਮ ਲਿਖਵਾ ਸਕਦੇ ਹਨ';

  @override
  String get membersCanSignUpNote =>
      'ਬੰਦ ਕਰਨ ਉੱਤੇ ਉਹਨਾਂ ਨੂੰ ਬਟਨ ਦੀ ਥਾਂ ਤੁਹਾਡੀਆਂ ਸ਼ਰਤਾਂ ਦਿਖਣਗੀਆਂ।';

  @override
  String get listPublicly => 'ਜਨਤਕ ਤੌਰ ਉੱਤੇ ਦਿਖਾਓ';

  @override
  String get listPubliclyNote => 'ਪੂਰੇ ਦੇਸ਼ ਦੀ ਸਮਾਗਮ ਫੀਡ ਵਿੱਚ ਦਿਖਦਾ ਹੈ।';

  @override
  String get listPubliclyProOnly =>
      'ਸਿਰਫ਼ ਪ੍ਰੋ ਪਲਾਨ ਉੱਤੇ। ਤੁਹਾਡੇ ਮੈਂਬਰ ਫਿਰ ਵੀ ਇਹ ਵੇਖਣਗੇ।';

  @override
  String get openToOutsiders => 'ਤੁਹਾਡੇ ਜਿਮ ਤੋਂ ਬਾਹਰ ਦੇ ਲੋਕਾਂ ਲਈ ਵੀ ਖੁੱਲ੍ਹਾ';

  @override
  String get publishEvent => 'ਸਮਾਗਮ ਪ੍ਰਕਾਸ਼ਿਤ ਕਰੋ';

  @override
  String get registrationOpen => 'ਰਜਿਸਟਰੇਸ਼ਨ ਖੁੱਲ੍ਹੀ';

  @override
  String get registrationClosed => 'ਰਜਿਸਟਰੇਸ਼ਨ ਬੰਦ';

  @override
  String get close => 'ਬੰਦ ਕਰੋ';

  @override
  String get markAllRead => 'ਸਭ ਪੜ੍ਹਿਆ ਹੋਇਆ ਕਰੋ';

  @override
  String get nothingYet => 'ਅਜੇ ਕੁਝ ਨਹੀਂ';

  @override
  String get announcementsAppearHere =>
      'ਤੁਹਾਡੇ ਜਿਮ ਅਤੇ ਜਿਮੋਲੋਜੀਆ ਵੱਲੋਂ ਐਲਾਨ ਇੱਥੇ ਦਿਖਣਗੇ।';

  @override
  String get searchPeople => 'ਲੋਕ ਲੱਭੋ';

  @override
  String get nobodyElseHereYet => 'ਇੱਥੇ ਅਜੇ ਹੋਰ ਕੋਈ ਨਹੀਂ ਹੈ।';

  @override
  String get nameTheGroup => 'ਗਰੁੱਪ ਨੂੰ ਨਾਮ ਦਿਓ';

  @override
  String get groupNameHint => 'ਸ਼ਨੀਵਾਰ ਸਵੇਰ ਦਾ ਗਰੁੱਪ';

  @override
  String get create => 'ਬਣਾਓ';

  @override
  String get pickWhoIsInTheGroup => 'ਚੁਣੋ ਕਿ ਗਰੁੱਪ ਵਿੱਚ ਕੌਣ ਹੈ';

  @override
  String createGroupWith(int count) {
    return '$count ਨਾਲ ਗਰੁੱਪ ਬਣਾਓ';
  }

  @override
  String get termsOfUse => 'ਵਰਤੋਂ ਦੀਆਂ ਸ਼ਰਤਾਂ';

  @override
  String get privacy => 'ਨਿੱਜਤਾ';

  @override
  String versionUpdated(String version, String date) {
    return 'ਵਰਜਨ $version · ਅੱਪਡੇਟ $date';
  }

  @override
  String sessionsAttendedAllTime(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ਸੈਸ਼ਨ, ਕੁੱਲ',
    );
    return '$_temp0';
  }

  @override
  String get nothingInLast60Days => 'ਪਿਛਲੇ 60 ਦਿਨਾਂ ਵਿੱਚ ਕੁਝ ਦਰਜ ਨਹੀਂ ਹੋਇਆ।';

  @override
  String correctedReason(String reason) {
    return 'ਠੀਕ ਕੀਤਾ: $reason';
  }

  @override
  String get noReasonGiven => 'ਕੋਈ ਕਾਰਨ ਨਹੀਂ ਦਿੱਤਾ';

  @override
  String get keptWithRecordAuditNote =>
      'ਇਹ ਰਿਕਾਰਡ ਨਾਲ ਰੱਖਿਆ ਜਾਂਦਾ ਹੈ ਅਤੇ ਆਡਿਟ ਲੌਗ ਵਿੱਚ ਦਿਖਦਾ ਹੈ।';

  @override
  String get staffBadge => 'ਸਟਾਫ';

  @override
  String get draftCrmNote =>
      'ਤੁਹਾਡਾ ਜਿਮ ਖਰੜਾ ਹੈ। CRM ਚੱਲਦਾ ਹੈ, ਪਰ ਪਲਾਨ ਚਾਲੂ ਹੋਣ ਤੱਕ ਮੈਂਬਰ ਤੁਹਾਨੂੰ ਖੋਜ ਵਿੱਚ ਨਹੀਂ ਲੱਭਣਗੇ।';

  @override
  String roleHiddenNote(String role) {
    return 'ਇੱਥੇ ਤੁਸੀਂ $role ਹੋ। ਜੋ ਤੁਹਾਡੀ ਭੂਮਿਕਾ ਨਹੀਂ ਕਰ ਸਕਦੀ, ਉਹ ਦਿਖਾ ਕੇ ਨਾਂਹ ਕਰਨ ਦੀ ਥਾਂ ਲੁਕਾ ਦਿੱਤਾ ਜਾਂਦਾ ਹੈ।';
  }

  @override
  String engagedOfActive(int engaged, int total) {
    return '$total ਵਿੱਚੋਂ $engaged ਮੈਂਬਰਾਂ ਨੇ ਘੱਟੋ-ਘੱਟ ਇੱਕ ਵਾਰ ਕਸਰਤ ਕੀਤੀ।';
  }

  @override
  String announceGoesTo(String audience) {
    return 'ਇਹ ਹੁਣੇ $audience ਜਾਵੇਗਾ, ਅਤੇ ਵਾਪਸ ਨਹੀਂ ਲਿਆ ਜਾ ਸਕਦਾ।';
  }

  @override
  String get audienceEveryMember => 'ਹਰ ਮੈਂਬਰ';

  @override
  String get audienceEveryStaff => 'ਹਰ ਸਟਾਫ਼ ਮੈਂਬਰ';

  @override
  String get audienceEveryone => 'ਇਸ ਜਿਮ ਦੇ ਸਾਰੇ';

  @override
  String sentToPeople(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ਲੋਕਾਂ ਨੂੰ ਭੇਜਿਆ ਗਿਆ।',
    );
    return '$_temp0';
  }

  @override
  String recipientCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ਪ੍ਰਾਪਤਕਰਤਾ',
    );
    return '$_temp0';
  }

  @override
  String get weTextACodeFirst =>
      'ਅਸੀਂ ਪਹਿਲਾਂ ਉਹਨਾਂ ਦੇ ਨੰਬਰ ਉੱਤੇ ਇੱਕ ਕੋਡ ਭੇਜਦੇ ਹਾਂ, ਤਾਂ ਜੋ ਪਤਾ ਲੱਗੇ ਕਿ ਨੰਬਰ ਸੱਚਮੁੱਚ ਉਹਨਾਂ ਦਾ ਹੈ।';

  @override
  String get memberCanUpdateMetrics =>
      'ਉਹ ਮੈਂਬਰ ਐਪ ਵਿੱਚ ਆਪਣਾ ਭਾਰ ਅਤੇ ਕੱਦ ਵੇਖ ਅਤੇ ਬਦਲ ਸਕਦੇ ਹਨ। ਜਦ ਤੱਕ ਉਹ ਆਪ ਬੰਦ ਨਾ ਕਰਨ, ਉਹਨਾਂ ਦੀ ਤਰੱਕੀ ਸਟਾਫ਼ ਨੂੰ ਦਿਖਦੀ ਹੈ।';

  @override
  String get noRolesYouCanAssign =>
      'ਤੁਸੀਂ ਦੇ ਸਕਣ ਵਾਲੀਆਂ ਭੂਮਿਕਾਵਾਂ ਨਹੀਂ ਹਨ। ਸਿਰਫ਼ ਆਪਣੇ ਤੋਂ ਹੇਠਲੀਆਂ ਭੂਮਿਕਾਵਾਂ ਹੀ ਦਿੱਤੀਆਂ ਜਾ ਸਕਦੀਆਂ ਹਨ।';

  @override
  String get noRolesYouCanAssignToThem =>
      'ਤੁਸੀਂ ਉਹਨਾਂ ਨੂੰ ਦੇ ਸਕਣ ਵਾਲੀਆਂ ਭੂਮਿਕਾਵਾਂ ਨਹੀਂ ਹਨ।';

  @override
  String heightCm(String cm) {
    return 'ਕੱਦ $cm ਸੈਮੀ';
  }

  @override
  String weightOverCheckIns(String delta, int count) {
    return '$count ਜਾਂਚਾਂ ਵਿੱਚ $delta ਕਿਲੋ';
  }

  @override
  String get useDeviceLanguage => 'ਡਿਵਾਈਸ ਦੀ ਭਾਸ਼ਾ ਵਰਤੋ';

  @override
  String get untranslatedFallbackNote =>
      'ਜੋ ਅਜੇ ਅਨੁਵਾਦ ਨਹੀਂ ਹੋਇਆ, ਉਹ ਖਾਲੀ ਛੱਡਣ ਦੀ ਥਾਂ ਅੰਗਰੇਜ਼ੀ ਵਿੱਚ ਦਿਖਾਇਆ ਜਾਂਦਾ ਹੈ, ਤਾਂ ਜੋ ਅੰਸ਼ਕ ਅਨੁਵਾਦਿਤ ਭਾਸ਼ਾ ਵੀ ਵਰਤੋਂਯੋਗ ਰਹੇ।';

  @override
  String deleteGymWarning(int members, int staff) {
    return 'ਸਾਰੇ $members ਮੈਂਬਰਾਂ ਅਤੇ $staff ਸਟਾਫ਼ ਦੀ ਪਹੁੰਚ ਖ਼ਤਮ ਹੋ ਜਾਵੇਗੀ। ਇਸ ਨੂੰ ਐਪ ਤੋਂ ਵਾਪਸ ਨਹੀਂ ਕੀਤਾ ਜਾ ਸਕਦਾ।';
  }

  @override
  String shownAsInSearch(String name, String district) {
    return 'ਖੋਜ ਵਿੱਚ “$name - $district” ਵਜੋਂ ਦਿਖੇਗਾ।';
  }

  @override
  String get nothingWaitingLeave =>
      'ਕੁਝ ਬਕਾਇਆ ਨਹੀਂ। ਤੁਹਾਡੀ ਹੱਦ ਦੇ ਅੰਦਰ ਦੀਆਂ ਬੇਨਤੀਆਂ ਆਪਣੇ ਆਪ ਮਨਜ਼ੂਰ ਹੁੰਦੀਆਂ ਹਨ ਅਤੇ ਇੱਥੇ ਕਦੇ ਨਹੀਂ ਦਿਖਦੀਆਂ।';

  @override
  String get quietPeriodsNote =>
      'ਸ਼ਾਂਤ ਸਮੇਂ ਛੱਡੇ ਨਹੀਂ ਜਾਂਦੇ, ਖਾਲੀ ਪੱਟੀਆਂ ਵਜੋਂ ਦਿਖਾਏ ਜਾਂਦੇ ਹਨ, ਇਸ ਲਈ ਪੱਟੀਆਂ ਵਿਚਲਾ ਪਾੜਾ ਅਸਲੀ ਪਾੜਾ ਹੈ।';

  @override
  String get rankingExplainer =>
      'ਸਥਿਤੀ ਉਸੇ ਤਰ੍ਹਾਂ ਕੱਢੀ ਜਾਂਦੀ ਹੈ ਜਿਵੇਂ ਖੋਜ ਨਤੀਜੇ ਕ੍ਰਮ ਵਿੱਚ ਲਾਉਂਦੀ ਹੈ: ਪਹਿਲਾਂ ਰੇਟਿੰਗ, ਫਿਰ ਕਿੰਨੀਆਂ ਰੇਟਿੰਗਾਂ ਉਸ ਦਾ ਸਮਰਥਨ ਕਰਦੀਆਂ ਹਨ। ਇੱਥੇ ਜੋ ਦਿਖਦਾ ਹੈ, ਉਹੀ ਮੈਂਬਰ ਨੂੰ ਵੀ ਦਿਖੇਗਾ।';

  @override
  String get deleteTrainerCategoryWarning =>
      'ਹੁਣ ਇਸ ਸ਼੍ਰੇਣੀ ਵਿੱਚ ਟ੍ਰੇਨਰ ਨਹੀਂ ਪਾਏ ਜਾ ਸਕਣਗੇ। ਜੋ ਪਹਿਲਾਂ ਹੀ ਹਨ, ਉਹਨਾਂ ਦੀ ਨਿਯੁਕਤੀ ਰਹੇਗੀ।';

  @override
  String get youLabel => 'ਤੁਸੀਂ';

  @override
  String get openEvents => 'ਖੁੱਲ੍ਹੇ ਸਮਾਗਮ';

  @override
  String get nothingHereYetSaySomething => 'ਇੱਥੇ ਅਜੇ ਕੁਝ ਨਹੀਂ। ਕੁਝ ਕਹੋ।';

  @override
  String get leavePausesMembership =>
      'ਤੁਹਾਡੀ ਗੈਰ-ਹਾਜ਼ਰੀ ਵਿੱਚ ਮੈਂਬਰਸ਼ਿਪ ਰੁਕ ਜਾਂਦੀ ਹੈ, ਇਸ ਲਈ ਜਿਹੜੇ ਦਿਨਾਂ ਦਾ ਤੁਸੀਂ ਭੁਗਤਾਨ ਕੀਤਾ ਹੈ ਉਹ ਬਚੇ ਰਹਿੰਦੇ ਹਨ।';

  @override
  String get notListedUntilPlan =>
      'ਪਲਾਨ ਚਾਲੂ ਹੋਣ ਤੱਕ ਜਨਤਕ ਤੌਰ ਉੱਤੇ ਨਹੀਂ ਦਿਖੇਗਾ।';

  @override
  String gymsListedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ਜਿਮ ਸੂਚੀਬੱਧ',
    );
    return '$_temp0';
  }

  @override
  String get checkInGoalNote =>
      'ਤੁਹਾਡੇ ਟੀਚੇ ਵੱਲ ਤਰੱਕੀ ਵੇਖਣ ਲਈ ਤੁਹਾਡਾ ਜਿਮ ਇਸ ਦੀ ਵਰਤੋਂ ਕਰਦਾ ਹੈ।';

  @override
  String get enterYourGymName => 'ਆਪਣੇ ਜਿਮ ਦਾ ਨਾਮ ਲਿਖੋ';

  @override
  String get sessionExpiredSignIn =>
      'ਤੁਹਾਡਾ ਸੈਸ਼ਨ ਖ਼ਤਮ ਹੋ ਗਿਆ। ਕਿਰਪਾ ਕਰਕੇ ਦੁਬਾਰਾ ਸਾਈਨ ਇਨ ਕਰੋ।';

  @override
  String get somethingWentWrongTryAgain =>
      'ਕੁਝ ਗਲਤ ਹੋ ਗਿਆ। ਕਿਰਪਾ ਕਰਕੇ ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ।';

  @override
  String get serverTookTooLong =>
      'ਸਰਵਰ ਨੇ ਜਵਾਬ ਦੇਣ ਵਿੱਚ ਬਹੁਤ ਸਮਾਂ ਲਿਆ। ਆਪਣਾ ਕੁਨੈਕਸ਼ਨ ਵੇਖੋ ਅਤੇ ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ।';

  @override
  String couldNotReachServer(String host) {
    return '$host ਉੱਤੇ ਸਰਵਰ ਨਾਲ ਸੰਪਰਕ ਨਹੀਂ ਹੋ ਸਕਿਆ। ਆਪਣਾ ਇੰਟਰਨੈੱਟ ਕੁਨੈਕਸ਼ਨ ਵੇਖੋ।';
  }

  @override
  String get certificateNotVerified => 'ਸਰਵਰ ਦਾ ਸਰਟੀਫਿਕੇਟ ਤਸਦੀਕ ਨਹੀਂ ਹੋ ਸਕਿਆ।';

  @override
  String get networkErrorTryAgain =>
      'ਨੈੱਟਵਰਕ ਗੜਬੜ। ਕਿਰਪਾ ਕਰਕੇ ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ।';

  @override
  String get enterValidMobile => '10 ਅੰਕਾਂ ਦਾ ਸਹੀ ਭਾਰਤੀ ਮੋਬਾਈਲ ਨੰਬਰ ਲਿਖੋ';

  @override
  String get enterValidTenDigitNumber => '10 ਅੰਕਾਂ ਦਾ ਸਹੀ ਨੰਬਰ ਲਿਖੋ';

  @override
  String get enterYourName => 'ਆਪਣਾ ਨਾਮ ਲਿਖੋ';

  @override
  String get nameTooLong => 'ਇਹ ਨਾਮ ਬਹੁਤ ਲੰਮਾ ਹੈ';

  @override
  String get enterValidEmail => 'ਸਹੀ ਈਮੇਲ ਪਤਾ ਲਿਖੋ';

  @override
  String get enterYourAge => 'ਆਪਣੀ ਉਮਰ ਲਿਖੋ';

  @override
  String get mustBeAtLeast13 => 'ਤੁਹਾਡੀ ਉਮਰ ਘੱਟੋ-ਘੱਟ 13 ਹੋਣੀ ਚਾਹੀਦੀ ਹੈ';

  @override
  String get enterValidAge => 'ਸਹੀ ਉਮਰ ਲਿਖੋ';

  @override
  String get enterWeightOrHeight => 'ਭਾਰ ਜਾਂ ਕੱਦ ਲਿਖੋ।';

  @override
  String get noRatingsYet => 'ਅਜੇ ਕੋਈ ਰੇਟਿੰਗ ਨਹੀਂ';

  @override
  String get giveItATitle => 'ਇਸ ਨੂੰ ਸਿਰਲੇਖ ਦਿਓ।';

  @override
  String get sayWhatYouWantThemToKnow =>
      'ਦੱਸੋ ਕਿ ਤੁਸੀਂ ਉਹਨਾਂ ਨੂੰ ਕੀ ਦੱਸਣਾ ਚਾਹੁੰਦੇ ਹੋ।';

  @override
  String get sayWhyThisIsChanging => 'ਦੱਸੋ ਕਿ ਇਹ ਕਿਉਂ ਬਦਲਿਆ ਜਾ ਰਿਹਾ ਹੈ।';

  @override
  String get noMembersYetAddFirst => 'ਅਜੇ ਕੋਈ ਮੈਂਬਰ ਨਹੀਂ। ਪਹਿਲਾ ਮੈਂਬਰ ਜੋੜੋ।';

  @override
  String get nobodyMatchedSearch => 'ਉਸ ਖੋਜ ਨਾਲ ਕੋਈ ਨਹੀਂ ਮਿਲਿਆ।';

  @override
  String get turningUp => 'ਹਾਜ਼ਰੀ';

  @override
  String get justNow => 'ਹੁਣੇ ਹੀ';

  @override
  String minutesAgo(int count) {
    return '$count ਮਿੰਟ ਪਹਿਲਾਂ';
  }

  @override
  String hoursAgo(int count) {
    return '$count ਘੰਟੇ ਪਹਿਲਾਂ';
  }

  @override
  String daysAgo(int count) {
    return '$count ਦਿਨ ਪਹਿਲਾਂ';
  }

  @override
  String monthsAgo(int count) {
    return '$count ਮਹੀਨੇ ਪਹਿਲਾਂ';
  }

  @override
  String get nowShort => 'ਹੁਣ';

  @override
  String minutesShort(int count) {
    return '$count ਮਿੰ';
  }

  @override
  String hoursShort(int count) {
    return '$count ਘੰ';
  }

  @override
  String daysShort(int count) {
    return '$count ਦਿ';
  }

  @override
  String weeksShort(int count) {
    return '$count ਹਫ਼';
  }

  @override
  String addedNamed(String name) {
    return '$name ਜੋੜਿਆ ਗਿਆ';
  }

  @override
  String get saved => 'ਸੰਭਾਲਿਆ ਗਿਆ';

  @override
  String get trainerCategoriesIntro =>
      'ਟ੍ਰੇਨਰ ਜੋੜਦੇ ਸਮੇਂ ਉਹਨਾਂ ਨੂੰ ਇਹਨਾਂ ਵਿੱਚੋਂ ਇੱਕ ਵਿੱਚ ਰੱਖਿਆ ਜਾਂਦਾ ਹੈ। ਜਿਸ ਸ਼੍ਰੇਣੀ ਵਿੱਚ ਟ੍ਰੇਨਰ ਹਨ, ਉਸ ਨੂੰ ਉਹਨਾਂ ਨੂੰ ਹਟਾਏ ਬਿਨਾਂ ਮਿਟਾਇਆ ਨਹੀਂ ਜਾ ਸਕਦਾ।';

  @override
  String get trainerCategoriesReadOnly =>
      'ਤੁਸੀਂ ਇਸ ਜਿਮ ਦੀਆਂ ਸ਼੍ਰੇਣੀਆਂ ਵੇਖ ਸਕਦੇ ਹੋ। ਬਦਲਣ ਲਈ ਟ੍ਰੇਨਰ-ਪ੍ਰਬੰਧਨ ਦੀ ਇਜਾਜ਼ਤ ਚਾਹੀਦੀ ਹੈ।';

  @override
  String get oneTrainerManyMembersShort => 'ਇੱਕ ਟ੍ਰੇਨਰ, ਕਈ ਮੈਂਬਰ';

  @override
  String get oneMemberPerTrainer => 'ਹਰ ਟ੍ਰੇਨਰ ਲਈ ਇੱਕ ਮੈਂਬਰ';

  @override
  String get noTrainers => 'ਕੋਈ ਟ੍ਰੇਨਰ ਨਹੀਂ';

  @override
  String trainerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ਟ੍ਰੇਨਰ',
    );
    return '$_temp0';
  }

  @override
  String get deleteMoveTrainersFirst => 'ਮਿਟਾਓ (ਪਹਿਲਾਂ ਟ੍ਰੇਨਰ ਹਟਾਓ)';

  @override
  String get giveCategoryAName => 'ਸ਼੍ਰੇਣੀ ਨੂੰ ਨਾਮ ਦਿਓ';

  @override
  String get editCategory => 'ਸ਼੍ਰੇਣੀ ਸੋਧੋ';

  @override
  String get newTrainerCategory => 'ਨਵੀਂ ਟ੍ਰੇਨਰ ਸ਼੍ਰੇਣੀ';

  @override
  String get generalTrainingNote => 'ਆਮ ਸਿਖਲਾਈ ਲਈ ਇਹੀ ਆਮ ਸੈਟਿੰਗ ਹੈ।';

  @override
  String get personalTrainingNote =>
      'ਨਿੱਜੀ ਸਿਖਲਾਈ: ਇੱਥੋਂ ਦਾ ਟ੍ਰੇਨਰ ਇੱਕ ਵਾਰ ਵਿੱਚ ਇੱਕ ਹੀ ਮੈਂਬਰ ਲੈਂਦਾ ਹੈ।';

  @override
  String get addCategory => 'ਸ਼੍ਰੇਣੀ ਜੋੜੋ';

  @override
  String get listedPublicly => 'ਜਨਤਕ ਤੌਰ ਉੱਤੇ ਸੂਚੀਬੱਧ';

  @override
  String get yourMembersOnly => 'ਸਿਰਫ਼ ਤੁਹਾਡੇ ਮੈਂਬਰ';

  @override
  String get whenDoesItStart => 'ਇਹ ਕਦੋਂ ਸ਼ੁਰੂ ਹੁੰਦਾ ਹੈ?';

  @override
  String get chooseStartDateFirst => 'ਪਹਿਲਾਂ ਸ਼ੁਰੂ ਹੋਣ ਦੀ ਤਾਰੀਖ਼ ਚੁਣੋ।';

  @override
  String get lastDayToRegister => 'ਰਜਿਸਟਰ ਕਰਨ ਦੀ ਆਖਰੀ ਤਾਰੀਖ਼';

  @override
  String get giveTheEventATitle => 'ਸਮਾਗਮ ਨੂੰ ਸਿਰਲੇਖ ਦਿਓ।';

  @override
  String get addADescription => 'ਇੱਕ ਵੇਰਵਾ ਜੋੜੋ, ਘੱਟੋ-ਘੱਟ ਇੱਕ ਵਾਕ।';

  @override
  String get sayHowToTakePart => 'ਦੱਸੋ ਕਿ ਹਿੱਸਾ ਲੈਣ ਲਈ ਕੀ ਕਰਨਾ ਪਵੇਗਾ।';

  @override
  String get pickTheDates => 'ਤਾਰੀਖ਼ਾਂ ਚੁਣੋ।';

  @override
  String startsAtWhen(String when) {
    return '$when ਸ਼ੁਰੂ';
  }

  @override
  String registerByWhen(String when) {
    return '$when ਤੱਕ ਰਜਿਸਟਰ ਕਰੋ';
  }

  @override
  String get selectYourLeaveDates => 'ਆਪਣੀਆਂ ਛੁੱਟੀ ਦੀਆਂ ਤਾਰੀਖ਼ਾਂ ਚੁਣੋ';

  @override
  String get chooseYourDatesFirst => 'ਪਹਿਲਾਂ ਆਪਣੀਆਂ ਤਾਰੀਖ਼ਾਂ ਚੁਣੋ।';

  @override
  String get sentForApproval => 'ਮਨਜ਼ੂਰੀ ਲਈ ਭੇਜ ਦਿੱਤਾ।';

  @override
  String get leaveApprovedPaused =>
      'ਛੁੱਟੀ ਮਨਜ਼ੂਰ। ਉਹਨਾਂ ਦਿਨਾਂ ਲਈ ਤੁਹਾਡੀ ਮੈਂਬਰਸ਼ਿਪ ਰੁਕੀ ਰਹੇਗੀ।';

  @override
  String get chooseDates => 'ਤਾਰੀਖ਼ਾਂ ਚੁਣੋ';

  @override
  String leaveDaysLeftCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ਤੁਹਾਡੇ ਕੋਲ $count ਛੁੱਟੀ ਦੇ ਦਿਨ ਬਾਕੀ ਹਨ।',
    );
    return '$_temp0';
  }

  @override
  String moreThanRemainingDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'ਇਹ ਤੁਹਾਡੇ ਬਾਕੀ $count ਦਿਨਾਂ ਤੋਂ ਵੱਧ ਹੈ, ਇਸ ਲਈ ਮੈਨੇਜਰ ਨੂੰ ਮਨਜ਼ੂਰ ਕਰਨਾ ਪਵੇਗਾ।',
    );
    return '$_temp0';
  }

  @override
  String get withinYourAllowance =>
      'ਤੁਹਾਡੀ ਹੱਦ ਦੇ ਅੰਦਰ — ਇਹ ਤੁਰੰਤ ਮਨਜ਼ੂਰ ਹੋ ਜਾਵੇਗਾ।';

  @override
  String get sendForApproval => 'ਮਨਜ਼ੂਰੀ ਲਈ ਭੇਜੋ';

  @override
  String get enterCodeSentToTheirPhone => 'ਉਹਨਾਂ ਦੇ ਫ਼ੋਨ ਉੱਤੇ ਭੇਜਿਆ ਕੋਡ ਲਿਖੋ।';

  @override
  String get numberIsNewNameNeeded => 'ਇਹ ਨੰਬਰ ਨਵਾਂ ਹੈ, ਇਸ ਲਈ ਨਾਮ ਚਾਹੀਦਾ ਹੈ।';

  @override
  String get chooseARole => 'ਇੱਕ ਭੂਮਿਕਾ ਚੁਣੋ।';

  @override
  String get isATrainer => 'Is a trainer?';

  @override
  String get chooseATrainerCategory => 'Choose a trainer category.';

  @override
  String get trainerCategory => 'Trainer category';

  @override
  String get addAMember => 'ਇੱਕ ਮੈਂਬਰ ਜੋੜੋ';

  @override
  String get codeSentExistingAccount =>
      'ਕੋਡ ਭੇਜ ਦਿੱਤਾ। ਇਸ ਨੰਬਰ ਉੱਤੇ ਪਹਿਲਾਂ ਹੀ ਜਿਮੋਲੋਜੀਆ ਖਾਤਾ ਹੈ।';

  @override
  String get codeSentNewAccount =>
      'ਕੋਡ ਭੇਜ ਦਿੱਤਾ। ਇਹ ਨੰਬਰ ਨਵਾਂ ਹੈ, ਇਸ ਲਈ ਅਸੀਂ ਖਾਤਾ ਬਣਾਵਾਂਗੇ।';

  @override
  String get membershipLength => 'ਮੈਂਬਰਸ਼ਿਪ ਦੀ ਮਿਆਦ';

  @override
  String get leaveDaysAllowed => 'ਮਿਲਣ ਵਾਲੇ ਛੁੱਟੀ ਦੇ ਦਿਨ';

  @override
  String get ownerStaffMode => 'ਮਾਲਕ / ਸਟਾਫ਼ ਮੋਡ';

  @override
  String get memberMode => 'ਮੈਂਬਰ ਮੋਡ';

  @override
  String get managingGymsNote =>
      'ਤੁਸੀਂ ਜਿਮ ਸੰਭਾਲ ਰਹੇ ਹੋ। ਮੈਂਬਰ ਵਜੋਂ ਜਿਮੋਲੋਜੀਆ ਵਰਤਣ ਲਈ ਵਾਪਸ ਜਾਓ।';

  @override
  String get openingAGymNote =>
      'ਜਿਮ ਖੋਲ੍ਹ ਰਹੇ ਹੋ, ਜਾਂ ਕਿਸੇ ਵਿੱਚ ਕੰਮ ਕਰਦੇ ਹੋ? ਆਪਣੇ ਜਿਮ ਦਾ CRM ਚਲਾਉਣ ਲਈ ਸਵਿੱਚ ਕਰੋ — ਮੈਂਬਰ, ਸਟਾਫ਼, ਹਾਜ਼ਰੀ ਅਤੇ ਛੁੱਟੀ।';

  @override
  String get numberIsHowYouSignIn =>
      'ਤੁਸੀਂ ਆਪਣੇ ਨੰਬਰ ਨਾਲ ਹੀ ਸਾਈਨ ਇਨ ਕਰਦੇ ਹੋ, ਇਸ ਲਈ ਇਸ ਨੂੰ ਇੱਥੇ ਹੁਣੇ ਨਹੀਂ ਬਦਲਿਆ ਜਾ ਸਕਦਾ।';

  @override
  String get followingYourDevice => 'ਤੁਹਾਡੇ ਡਿਵਾਈਸ ਅਨੁਸਾਰ';

  @override
  String get yourGym => 'ਤੁਹਾਡਾ ਜਿਮ';

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
  String noVisitsInLastDays(int days) {
    return 'ਪਿਛਲੇ $days ਦਿਨਾਂ ਵਿੱਚ ਕੋਈ ਆਉਣਾ ਦਰਜ ਨਹੀਂ ਹੋਇਆ।';
  }

  @override
  String visitsInLastDays(int count, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ਪਿਛਲੇ $days ਦਿਨਾਂ ਵਿੱਚ $count ਵਾਰ ਆਉਣਾ।',
    );
    return '$_temp0';
  }

  @override
  String get couldNotLoadEvents => 'ਸਮਾਗਮ ਲੋਡ ਨਹੀਂ ਹੋ ਸਕੇ';

  @override
  String get noEventsOnRightNow => 'ਹੁਣ ਕੋਈ ਸਮਾਗਮ ਨਹੀਂ';

  @override
  String get eventsAppearHere =>
      'ਤੁਹਾਡੇ ਜਿਮ ਦੇ ਸਮਾਗਮ ਇੱਥੇ ਦਿਖਦੇ ਹਨ, ਨਾਲ ਹੀ ਨੇੜੇ ਸਾਰਿਆਂ ਲਈ ਖੁੱਲ੍ਹੇ ਸਮਾਗਮ ਵੀ।';

  @override
  String get atYourGym => 'ਤੁਹਾਡੇ ਜਿਮ ਵਿੱਚ';

  @override
  String trainerStaffMembersAt(String gym) {
    return '$gym ਵਿੱਚ ਤੁਹਾਡੇ ਟ੍ਰੇਨਰ, ਸਟਾਫ਼ ਅਤੇ ਮੈਂਬਰ';
  }

  @override
  String get trainerStaffOtherMembers => 'ਤੁਹਾਡੇ ਟ੍ਰੇਨਰ, ਸਟਾਫ਼ ਅਤੇ ਹੋਰ ਮੈਂਬਰ';

  @override
  String get comingNext => 'ਅੱਗੇ ਆ ਰਿਹਾ ਹੈ';

  @override
  String get progressChartsAgainstGoal => 'ਤੁਹਾਡੇ ਟੀਚੇ ਦੇ ਮੁਕਾਬਲੇ ਤਰੱਕੀ ਚਾਰਟ';

  @override
  String get leaveLeft => 'ਬਾਕੀ ਛੁੱਟੀ';

  @override
  String approvedMembershipPauses(String name) {
    return '$name ਮਨਜ਼ੂਰ। ਉਹਨਾਂ ਦਿਨਾਂ ਲਈ ਉਹਨਾਂ ਦੀ ਮੈਂਬਰਸ਼ਿਪ ਰੁਕੀ ਰਹੇਗੀ।';
  }

  @override
  String get approveInstead => 'ਇਸ ਦੀ ਥਾਂ ਮਨਜ਼ੂਰ ਕਰੋ';

  @override
  String get declineInstead => 'ਇਸ ਦੀ ਥਾਂ ਇਨਕਾਰ ਕਰੋ';

  @override
  String get needsYou => 'ਤੁਹਾਡੀ ਲੋੜ ਹੈ';

  @override
  String get autoApproved => 'ਆਪਣੇ ਆਪ ਮਨਜ਼ੂਰ';

  @override
  String get returnedEarly => 'ਜਲਦੀ ਵਾਪਸ ਆਏ';

  @override
  String get whereYouAre => 'ਤੁਸੀਂ ਕਿੱਥੇ ਹੋ';

  @override
  String get enterTheAddress => 'ਪਤਾ ਲਿਖੋ';

  @override
  String get maximumPerMembership => 'ਪ੍ਰਤੀ ਮੈਂਬਰਸ਼ਿਪ ਵੱਧ ਤੋਂ ਵੱਧ';

  @override
  String removeStaffWithAssigned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'ਉਹਨਾਂ ਦੀ ਇਸ ਜਿਮ ਤੱਕ ਪਹੁੰਚ ਖ਼ਤਮ ਹੋ ਜਾਵੇਗੀ, ਅਤੇ ਉਹਨਾਂ ਨੂੰ ਸੌਂਪੇ $count ਮੈਂਬਰਾਂ ਕੋਲ ਤੁਹਾਡੇ ਕਿਸੇ ਹੋਰ ਨੂੰ ਸੌਂਪਣ ਤੱਕ ਕੋਈ ਟ੍ਰੇਨਰ ਨਹੀਂ ਹੋਵੇਗਾ।',
    );
    return '$_temp0';
  }

  @override
  String get removeStaffPlain =>
      'ਉਹਨਾਂ ਦੀ ਇਸ ਜਿਮ ਤੱਕ ਪਹੁੰਚ ਖ਼ਤਮ ਹੋ ਜਾਵੇਗੀ। ਉਹਨਾਂ ਦਾ ਹਾਜ਼ਰੀ ਰਿਕਾਰਡ ਰੱਖਿਆ ਜਾਂਦਾ ਹੈ।';

  @override
  String get couldNotLoadGyms => 'ਜਿਮ ਲੋਡ ਨਹੀਂ ਹੋ ਸਕੇ';

  @override
  String get noGymsListedYet => 'ਅਜੇ ਕੋਈ ਜਿਮ ਸੂਚੀਬੱਧ ਨਹੀਂ';

  @override
  String get gymsAppearOnPro =>
      'ਜਿਮ ਪ੍ਰੋ ਪਲਾਨ ਉੱਤੇ ਹੋਣ ਅਤੇ ਸੂਚੀਬੱਧ ਹੋਣਾ ਚੁਣਨ ਉੱਤੇ ਇੱਥੇ ਦਿਖਦੇ ਹਨ।';

  @override
  String nothingMatchedTry(String query) {
    return '“$query” ਨਾਲ ਕੁਝ ਨਹੀਂ ਮਿਲਿਆ। ਕੋਈ ਹੋਰ ਸ਼ਹਿਰ ਜਾਂ ਜ਼ਿਲ੍ਹਾ ਅਜ਼ਮਾਓ।';
  }

  @override
  String get noRatings => 'ਕੋਈ ਰੇਟਿੰਗ ਨਹੀਂ';

  @override
  String get noPerksYet => 'ਅਜੇ ਤੱਕ ਕੋਈ ਲਾਭ ਸੂਚੀਬੱਧ ਨਹੀਂ';

  @override
  String fromRatings(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ਰੇਟਿੰਗਾਂ ਤੋਂ',
    );
    return '$_temp0';
  }

  @override
  String get onlyProGymHere => 'ਇੱਥੋਂ ਦਾ ਇਕੱਲਾ ਪ੍ਰੋ ਜਿਮ';

  @override
  String ofProGyms(int count) {
    return '$count ਪ੍ਰੋ ਜਿਮਾਂ ਵਿੱਚੋਂ';
  }

  @override
  String get couldNotLoadYourGyms => 'ਤੁਹਾਡੇ ਜਿਮ ਲੋਡ ਨਹੀਂ ਹੋ ਸਕੇ';

  @override
  String get noGymsYet => 'ਅਜੇ ਕੋਈ ਜਿਮ ਨਹੀਂ';

  @override
  String get createYourGymBlurb =>
      'ਮੈਂਬਰ, ਸਟਾਫ਼, ਹਾਜ਼ਰੀ ਅਤੇ ਛੁੱਟੀ ਸੈੱਟ ਕਰਨ ਲਈ ਆਪਣਾ ਜਿਮ ਬਣਾਓ। ਜੇ ਤੁਸੀਂ ਕਿਸੇ ਜਿਮ ਵਿੱਚ ਕੰਮ ਕਰਦੇ ਹੋ, ਤਾਂ ਮਾਲਕ ਨੂੰ ਜੋੜਨ ਲਈ ਕਹੋ, ਉਹ ਇੱਥੇ ਦਿਖੇਗਾ।';

  @override
  String newGroupSelected(int count) {
    return 'ਨਵਾਂ ਗਰੁੱਪ ($count ਚੁਣੇ)';
  }

  @override
  String get newMessage => 'ਨਵਾਂ ਸੁਨੇਹਾ';

  @override
  String get oneToOne => 'ਇੱਕ ਨਾਲ ਇੱਕ';

  @override
  String get group => 'ਗਰੁੱਪ';

  @override
  String get buildMuscle => 'ਮਾਸਪੇਸ਼ੀ ਬਣਾਓ';

  @override
  String get loseFat => 'ਚਰਬੀ ਘਟਾਓ';

  @override
  String get getStronger => 'ਤਾਕਤ ਵਧਾਓ';

  @override
  String get officialGroupEmpty => 'ਇਸ ਜਿਮ ਦੇ ਸਾਰੇ। ਅਜੇ ਕੁਝ ਨਹੀਂ ਕਿਹਾ ਗਿਆ।';

  @override
  String get unofficialGroupEmpty => 'ਸਿਰਫ਼ ਮੈਂਬਰ। ਅਜੇ ਕੁਝ ਨਹੀਂ ਕਿਹਾ ਗਿਆ।';

  @override
  String get noMessagesYet => 'ਅਜੇ ਕੋਈ ਸੁਨੇਹਾ ਨਹੀਂ';

  @override
  String get approved => 'ਮਨਜ਼ੂਰ';

  @override
  String get declined => 'ਇਨਕਾਰ ਕੀਤਾ';

  @override
  String get cancelled => 'ਰੱਦ';

  @override
  String get flexibility => 'ਲਚਕ';

  @override
  String get rehab => 'ਰੀਹੈਬ';

  @override
  String get youPrefix => 'ਤੁਸੀਂ: ';

  @override
  String get active => 'ਸਰਗਰਮ';

  @override
  String get joined => 'ਜੁੜੇ';

  @override
  String get leftCount => 'ਛੱਡਿਆ';

  @override
  String get net => 'ਸ਼ੁੱਧ';

  @override
  String get daily => 'ਰੋਜ਼ਾਨਾ';

  @override
  String get monthly => 'ਮਹੀਨਾਵਾਰ';

  @override
  String get yearly => 'ਸਾਲਾਨਾ';

  @override
  String get add => 'ਜੋੜੋ';

  @override
  String get update => 'ਅੱਪਡੇਟ ਕਰੋ';

  @override
  String get required => 'ਲਾਜ਼ਮੀ';

  @override
  String get contact => 'ਸੰਪਰਕ';

  @override
  String get owner => 'ਮਾਲਕ';

  @override
  String get support => 'ਸਹਾਇਤਾ';

  @override
  String get machineTranslatedExercise =>
      'ਇਹ ਹਦਾਇਤਾਂ ਮਸ਼ੀਨ ਨਾਲ ਅਨੁਵਾਦ ਕੀਤੀਆਂ ਗਈਆਂ ਹਨ ਅਤੇ ਕਿਸੇ ਕੋਚ ਨੇ ਜਾਂਚੀਆਂ ਨਹੀਂ। ਜੇ ਕੁਝ ਅਜੀਬ ਲੱਗੇ ਤਾਂ ਭਾਰ ਚੁੱਕਣ ਤੋਂ ਪਹਿਲਾਂ ਅੰਗਰੇਜ਼ੀ ਵਿੱਚ ਬਦਲ ਕੇ ਮਿਲਾ ਲਵੋ।';

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
  String get findAGym => 'ਜਿਮ ਲੱਭੋ';

  @override
  String get searchGyms => 'ਨਾਮ ਜਾਂ ਇਲਾਕੇ ਨਾਲ ਲੱਭੋ';

  @override
  String get perks => 'ਸਹੂਲਤਾਂ';

  @override
  String get rating => 'ਰੇਟਿੰਗ';

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
  String get checkInDue => 'ਇਸ ਮਹੀਨੇ ਦੀ ਜਾਂਚ ਬਾਕੀ ਹੈ';

  @override
  String get thisMonth => 'ਇਸ ਮਹੀਨੇ';

  @override
  String get perWeek => 'ਹਰ ਹਫ਼ਤੇ';

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
  String get useMyLocation => 'ਨੇੜਲੇ ਜਿਮ ਲੱਭਣ ਲਈ ਮੇਰੀ ਲੋਕੇਸ਼ਨ ਵਰਤੋ';

  @override
  String get findingNearbyGyms => 'ਤੁਹਾਡੇ ਨੇੜੇ ਦੇ ਜਿਮ ਲੱਭੇ ਜਾ ਰਹੇ ਹਨ…';

  @override
  String get locationUnavailable =>
      'ਤੁਹਾਡੀ ਲੋਕੇਸ਼ਨ ਨਹੀਂ ਮਿਲ ਸਕੀ — ਸਾਰੇ ਜਿਮ ਦਿਖਾਏ ਜਾ ਰਹੇ ਹਨ';

  @override
  String get exerciseDirectorySubtitle =>
      'ਤਾਕਤ, ਕਾਰਡੀਓ ਅਤੇ ਯੋਗ, ਹਰ ਕਦਮ ਦੀ ਹਿਦਾਇਤ ਨਾਲ';

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
  String get onLeave => 'ਛੁੱਟੀ ਉੱਤੇ';

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
  String get needsReview => 'ਅਨੁਵਾਦ ਦੀ ਸਮੀਖਿਆ ਬਾਕੀ';

  @override
  String get block => 'ਬਲਾਕ ਕਰੋ';

  @override
  String get unblock => 'ਅਣਬਲਾਕ ਕਰੋ';

  @override
  String get report => 'ਰਿਪੋਰਟ ਕਰੋ';

  @override
  String blockPerson(String name) {
    return '$name ਨੂੰ ਬਲਾਕ ਕਰੋ';
  }

  @override
  String reportPerson(String name) {
    return '$name ਦੀ ਰਿਪੋਰਟ ਕਰੋ';
  }

  @override
  String get blockConfirmBody =>
      'ਉਹ ਤੁਹਾਨੂੰ ਸੁਨੇਹਾ ਨਹੀਂ ਭੇਜ ਸਕਣਗੇ, ਅਤੇ ਤੁਹਾਨੂੰ ਉਨ੍ਹਾਂ ਦੇ ਸੁਨੇਹੇ ਨਹੀਂ ਦਿਖਣਗੇ। ਉਨ੍ਹਾਂ ਨੂੰ ਨਹੀਂ ਦੱਸਿਆ ਜਾਵੇਗਾ ਕਿ ਤੁਸੀਂ ਬਲਾਕ ਕੀਤਾ ਹੈ। ਤੁਸੀਂ ਇਹ ਸੈਟਿੰਗਾਂ ਵਿੱਚ ਬਦਲ ਸਕਦੇ ਹੋ।';

  @override
  String get blocked => 'ਬਲਾਕ ਕੀਤਾ';

  @override
  String get blockedAccounts => 'ਬਲਾਕ ਕੀਤੇ ਖਾਤੇ';

  @override
  String get noBlockedAccounts => 'ਤੁਸੀਂ ਕਿਸੇ ਨੂੰ ਬਲਾਕ ਨਹੀਂ ਕੀਤਾ।';

  @override
  String get safetyAndPrivacy => 'ਸੁਰੱਖਿਆ';

  @override
  String unblockQuestion(String name) {
    return '$name ਨੂੰ ਅਣਬਲਾਕ ਕਰਨਾ ਹੈ?';
  }

  @override
  String get unblockExplainer => 'ਉਹ ਦੁਬਾਰਾ ਤੁਹਾਨੂੰ ਸੁਨੇਹਾ ਭੇਜ ਸਕਣਗੇ।';

  @override
  String get whyReporting => 'ਕੀ ਸਮੱਸਿਆ ਹੈ?';

  @override
  String get reportDetails => 'ਕੀ ਹੋਇਆ?';

  @override
  String get reportDetailsHint =>
      'ਸਮੀਖਿਅਕ ਸੁਨੇਹਾ ਖੁਦ ਨਹੀਂ ਦੇਖਦੇ। ਉਹ ਤੁਹਾਡਾ ਵੇਰਵਾ ਹੀ ਪੜ੍ਹਦੇ ਹਨ, ਇਸ ਲਈ ਕੀ ਕਿਹਾ ਗਿਆ ਸੀ ਉਹ ਆਪਣੇ ਸ਼ਬਦਾਂ ਵਿੱਚ ਦੱਸੋ।';

  @override
  String get alsoBlockThem => 'ਉਨ੍ਹਾਂ ਨੂੰ ਬਲਾਕ ਵੀ ਕਰੋ';

  @override
  String get alsoBlockThemExplainer =>
      'ਰਿਪੋਰਟ ਇੱਕ ਵਿਅਕਤੀ ਪੜ੍ਹਦਾ ਹੈ ਅਤੇ ਸਮਾਂ ਲੱਗਦਾ ਹੈ। ਬਲਾਕ ਕਰਨਾ ਤੁਰੰਤ ਕੰਮ ਕਰਦਾ ਹੈ।';

  @override
  String get sendReport => 'ਰਿਪੋਰਟ ਭੇਜੋ';

  @override
  String get reportCategorySpam => 'ਸਪੈਮ ਜਾਂ ਅਣਚਾਹੀ ਵਿਕਰੀ';

  @override
  String get reportCategoryHarassment => 'ਪਰੇਸ਼ਾਨੀ ਜਾਂ ਧਮਕਾਉਣਾ';

  @override
  String get reportCategorySexual => 'ਜਿਨਸੀ ਜਾਂ ਅਸ਼ਲੀਲ ਸਮੱਗਰੀ';

  @override
  String get reportCategoryHate => 'ਨਫ਼ਰਤ ਭਰੀ ਬੋਲੀ';

  @override
  String get reportCategoryViolence => 'ਹਿੰਸਾ ਜਾਂ ਧਮਕੀ';

  @override
  String get reportCategoryScam => 'ਧੋਖਾ ਜਾਂ ਠੱਗੀ';

  @override
  String get reportCategoryImpersonation => 'ਕਿਸੇ ਹੋਰ ਦਾ ਰੂਪ ਧਾਰਨਾ';

  @override
  String get reportCategoryOther => 'ਕੁਝ ਹੋਰ';

  @override
  String get reportSent => 'ਧੰਨਵਾਦ। ਕੋਈ ਇਸ ਦੀ ਸਮੀਖਿਆ ਕਰੇਗਾ।';

  @override
  String get myReports => 'ਮੇਰੀਆਂ ਭੇਜੀਆਂ ਰਿਪੋਰਟਾਂ';

  @override
  String get reportStatusOpen => 'ਸਮੀਖਿਆ ਦੀ ਉਡੀਕ ਵਿੱਚ';

  @override
  String get reportStatusReviewing => 'ਦੇਖਿਆ ਜਾ ਰਿਹਾ ਹੈ';

  @override
  String get reportStatusActioned => 'ਕਾਰਵਾਈ ਕੀਤੀ ਗਈ';

  @override
  String get reportStatusDismissed => 'ਸਮੀਖਿਆ ਹੋਈ, ਕੋਈ ਕਾਰਵਾਈ ਨਹੀਂ';

  @override
  String get noReportsSent => 'ਤੁਸੀਂ ਕਿਸੇ ਦੀ ਰਿਪੋਰਟ ਨਹੀਂ ਕੀਤੀ।';

  @override
  String get deleteAccount => 'ਖਾਤਾ ਮਿਟਾਓ';

  @override
  String get deleteAccountIntro =>
      'ਤੁਹਾਡਾ ਖਾਤਾ 30 ਦਿਨ ਤੱਕ ਵਰਤਿਆ ਜਾ ਸਕਦਾ ਹੈ। ਉਸ ਤੋਂ ਬਾਅਦ ਇਹ ਮਿਟਾ ਦਿੱਤਾ ਜਾਵੇਗਾ ਅਤੇ ਵਾਪਸ ਨਹੀਂ ਆਵੇਗਾ।';

  @override
  String get whatIsDeleted => 'ਕੀ ਮਿਟਾਇਆ ਜਾਵੇਗਾ';

  @override
  String get whatIsDeletedList =>
      'ਤੁਹਾਡਾ ਨਾਮ, ਨੰਬਰ, ਈਮੇਲ ਅਤੇ ਉਮਰ। ਤੁਹਾਡੀ ਉਚਾਈ, ਭਾਰ ਅਤੇ ਤਰੱਕੀ। ਤੁਹਾਡੇ ਚੈਟ ਸੁਨੇਹੇ। ਕੋਈ ਵੀ ਪਛਾਣ ਦਸਤਾਵੇਜ਼ ਅਤੇ UPI ਵੇਰਵੇ।';

  @override
  String get whatIsKept => 'ਕੀ ਰੱਖਿਆ ਜਾਵੇਗਾ, ਤੁਹਾਡੀ ਪਛਾਣ ਹਟਾ ਕੇ';

  @override
  String get whatIsKeptList =>
      'ਭੁਗਤਾਨ ਅਤੇ ਬਿੱਲ ਦੇ ਰਿਕਾਰਡ, ਕਿਉਂਕਿ ਕਾਨੂੰਨ ਹਿਸਾਬ ਦੀਆਂ ਕਿਤਾਬਾਂ ਰੱਖਣ ਲਈ ਕਹਿੰਦਾ ਹੈ। ਜਿਮ ਵਿੱਚ ਕੀਤੀਆਂ ਕਾਰਵਾਈਆਂ ਦਾ ਰਿਕਾਰਡ, ਤਾਂ ਜੋ ਝਗੜੇ ਨਿਬੇੜੇ ਜਾ ਸਕਣ।';

  @override
  String get deleteGymsFirst =>
      'ਤੁਹਾਡੇ ਕੋਲ ਹਾਲੇ ਵੀ ਇੱਕ ਜਿਮ ਹੈ। ਪਹਿਲਾਂ ਇਸਨੂੰ ਮਿਟਾਓ — ਤੁਹਾਡਾ ਖਾਤਾ ਮਿਟਾਉਣ ਨਾਲ ਇਸਦੇ ਹਰ ਮੈਂਬਰ ਅਤੇ ਸਟਾਫ ਦੀ ਪਹੁੰਚ ਬੰਦ ਹੋ ਜਾਵੇਗੀ, ਅਤੇ ਉਨ੍ਹਾਂ ਨੂੰ ਦੱਸਿਆ ਜਾਵੇਗਾ ਕਿ ਇਹ ਬੰਦ ਹੋ ਗਿਆ ਹੈ।';

  @override
  String unwithdrawnWarning(String amount) {
    return 'ਤੁਹਾਡੀ $amount ਰੈਫਰਲ ਕਮਾਈ ਹਾਲੇ ਕਢਵਾਈ ਨਹੀਂ ਗਈ। ਪਹਿਲਾਂ Gymologia Referral ਐਪ ਵਿੱਚੋਂ ਕਢਵਾ ਲਵੋ, ਨਹੀਂ ਤਾਂ ਇਹ ਚਲੀ ਜਾਵੇਗੀ।';
  }

  @override
  String get iUnderstandLoseEarnings =>
      'ਮੈਂ ਸਮਝਦਾ/ਸਮਝਦੀ ਹਾਂ ਕਿ ਇਹ ਪੈਸੇ ਚਲੇ ਜਾਣਗੇ';

  @override
  String deletionScheduled(String date) {
    return 'ਤੁਹਾਡਾ ਖਾਤਾ $date ਨੂੰ ਮਿਟਾ ਦਿੱਤਾ ਜਾਵੇਗਾ।';
  }

  @override
  String get keepMyAccount => 'ਮੇਰਾ ਖਾਤਾ ਰੱਖੋ';

  @override
  String get deletionCancelled => 'ਤੁਹਾਡਾ ਖਾਤਾ ਨਹੀਂ ਮਿਟਾਇਆ ਜਾਵੇਗਾ।';

  @override
  String get deleteAccountConfirm => 'ਮੇਰਾ ਖਾਤਾ ਮਿਟਾਓ';
}
