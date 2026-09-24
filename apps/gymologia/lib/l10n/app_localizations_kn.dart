// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kannada (`kn`).
class AppLocalizationsKn extends AppLocalizations {
  AppLocalizationsKn([String locale = 'kn']) : super(locale);

  @override
  String get appName => 'Gymologia';

  @override
  String get languageName => 'ಕನ್ನಡ';

  @override
  String get settings => 'ಸೆಟ್ಟಿಂಗ್‌ಗಳು';

  @override
  String get language => 'ಭಾಷೆ';

  @override
  String get languageSubtitle => 'ನೀವು ಆರಾಮವಾಗಿ ಓದುವ ಭಾಷೆಯನ್ನು ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get save => 'ಉಳಿಸಿ';

  @override
  String get cancel => 'ರದ್ದುಮಾಡಿ';

  @override
  String get tryAgain => 'ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ';

  @override
  String get somethingWentWrong => 'ಏನೋ ತಪ್ಪಾಗಿದೆ';

  @override
  String get phoneNumber => 'ಮೊಬೈಲ್ ಸಂಖ್ಯೆ';

  @override
  String get enterPhoneNumber => 'ನಿಮ್ಮ ಮೊಬೈಲ್ ಸಂಖ್ಯೆ ನಮೂದಿಸಿ';

  @override
  String get sendCode => 'ಕೋಡ್ ಕಳುಹಿಸಿ';

  @override
  String get verifyCode => 'ಪರಿಶೀಲಿಸಿ';

  @override
  String get resendCode => 'ಮತ್ತೆ ಕಳುಹಿಸಿ';

  @override
  String get createAccount => 'ನಿಮ್ಮ ಖಾತೆ ರಚಿಸಿ';

  @override
  String get emailOptional => 'ಇಮೇಲ್ (ಐಚ್ಛಿಕ)';

  @override
  String get age => 'ವಯಸ್ಸು';

  @override
  String get whyAgeNotBirthday =>
      'ನಾವು ನಿಮ್ಮ ವಯಸ್ಸನ್ನು ಕೇಳುತ್ತೇವೆ, ಜನ್ಮದಿನಾಂಕವನ್ನಲ್ಲ. ಜನ್ಮದಿನಾಂಕ ನಿಮ್ಮ ಬ್ಯಾಂಕ್ ಮತ್ತು ಸರ್ಕಾರಿ ದಾಖಲೆಗಳಿಗೆ ಸಂಬಂಧಿಸಿದೆ — ಜಿಮ್ ಆ್ಯಪ್‌ಗೆ ವಯಸ್ಸೇ ಸಾಕು.';

  @override
  String get termsAgreement =>
      'ಖಾತೆ ರಚಿಸುವುದು ಬಳಕೆಯ ನಿಯಮಗಳು ಮತ್ತು ಗೌಪ್ಯತಾ ನೀತಿಯನ್ನು ಒಪ್ಪುವುದಾಗಿದೆ.';

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
  String get signInWithMobile => 'ನಿಮ್ಮ ಮೊಬೈಲ್ ಸಂಖ್ಯೆಯಿಂದ ಸೈನ್ ಇನ್ ಮಾಡಿ';

  @override
  String get mobileNumber => 'ಮೊಬೈಲ್ ಸಂಖ್ಯೆ';

  @override
  String get couldNotSendCode => 'ಕೋಡ್ ಕಳುಹಿಸಲಾಗಲಿಲ್ಲ.';

  @override
  String get verificationFailed => 'ಪರಿಶೀಲನೆ ವಿಫಲವಾಯಿತು.';

  @override
  String get couldNotResendCode => 'ಕೋಡ್ ಮತ್ತೆ ಕಳುಹಿಸಲಾಗಲಿಲ್ಲ.';

  @override
  String get couldNotCreateAccount => 'ನಿಮ್ಮ ಖಾತೆ ರಚಿಸಲಾಗಲಿಲ್ಲ.';

  @override
  String weSentCodeTo(String phone) {
    return '$phone ಗೆ ಕೋಡ್ ಕಳುಹಿಸಿದ್ದೇವೆ';
  }

  @override
  String resendInSeconds(int seconds) {
    return '$seconds ಸೆಕೆಂಡುಗಳಲ್ಲಿ ಮತ್ತೆ ಕಳುಹಿಸಿ';
  }

  @override
  String get verified => 'ಪರಿಶೀಲಿಸಲಾಗಿದೆ';

  @override
  String get createAccountAction => 'ಖಾತೆ ರಚಿಸಿ';

  @override
  String get supportSent => 'ಕಳುಹಿಸಲಾಗಿದೆ. ನೀವು ನೀಡಿದ ಸಂಖ್ಯೆಗೆ ಉತ್ತರ ಬರುತ್ತದೆ.';

  @override
  String get supportSubject => 'ಇದು ಯಾವುದರ ಬಗ್ಗೆ?';

  @override
  String get supportSubjectHint => 'ನನ್ನ ಸದಸ್ಯತ್ವದ ದಿನಗಳು ತಪ್ಪಾಗಿ ಕಾಣಿಸುತ್ತಿವೆ';

  @override
  String get supportMessage => 'ಏನಾಯಿತು ಎಂದು ತಿಳಿಸಿ';

  @override
  String get supportReplyTo => 'ನಾವು ಎಲ್ಲಿ ಉತ್ತರಿಸಬೇಕು?';

  @override
  String get supportUrgent => 'ಇದರಿಂದ ನನ್ನ ಜಿಮ್ ನಡೆಯುತ್ತಿಲ್ಲ';

  @override
  String get supportUrgentNote => 'ಆದ್ಯತೆಯನ್ನು ಹೆಚ್ಚಿಸುತ್ತದೆ.';

  @override
  String copiedToClipboard(String value) {
    return '$value ನಕಲಿಸಲಾಗಿದೆ';
  }

  @override
  String orEmailUs(String email) {
    return 'ಅಥವಾ $email ಗೆ ಇಮೇಲ್ ಮಾಡಿ';
  }

  @override
  String get whatYouHaveAsked => 'ನೀವು ಕೇಳಿದ್ದು';

  @override
  String get aFewWordsIsEnough => 'ಕೆಲವು ಪದಗಳು ಸಾಕು';

  @override
  String get aSentenceOrTwoHelps => 'ಒಂದೆರಡು ವಾಕ್ಯ ಬರೆದರೆ ಬೇಗ ಸರಿಪಡಿಸಬಹುದು';

  @override
  String get ticketOpen => 'ಯಾರಾದರೂ ಕೈಗೆತ್ತಿಕೊಳ್ಳಲು ಕಾಯುತ್ತಿದೆ';

  @override
  String get ticketInProgress => 'ಯಾರೋ ಇದನ್ನು ನೋಡುತ್ತಿದ್ದಾರೆ';

  @override
  String get ticketWaitingOnUser => 'ನಿಮ್ಮ ಉತ್ತರಕ್ಕಾಗಿ ಕಾಯುತ್ತಿದೆ';

  @override
  String get ticketResolved => 'ಪರಿಹರಿಸಲಾಗಿದೆ';

  @override
  String get ticketClosed => 'ಮುಚ್ಚಲಾಗಿದೆ';

  @override
  String get referralPitch =>
      'ಕೋಡ್ ಹಂಚಿಕೊಳ್ಳಿ, ಜಿಮ್ ಮಾಲೀಕರು ಚಂದಾದಾರರಾದಾಗ ಗಳಿಸಿ. ರೆಫರಲ್ ಆ್ಯಪ್ ಇನ್ನೂ ಬಂದಿಲ್ಲ.';

  @override
  String get appTagline => 'ಜಿಮಾಲಜಿಯಾ · ಸದಸ್ಯರು ಮತ್ತು ಸಿಬ್ಬಂದಿ';

  @override
  String get signOutQuestion => 'ಸೈನ್ ಔಟ್ ಮಾಡಬೇಕೆ?';

  @override
  String get signOutWarning => 'ಮತ್ತೆ ಸೈನ್ ಇನ್ ಮಾಡಲು ನಿಮ್ಮ ಫೋನ್ ಬೇಕು.';

  @override
  String get profileUpdated => 'ಪ್ರೊಫೈಲ್ ನವೀಕರಿಸಲಾಗಿದೆ.';

  @override
  String get yourProfile => 'ನಿಮ್ಮ ಪ್ರೊಫೈಲ್';

  @override
  String get emailClearToRemove => 'ಐಚ್ಛಿಕ. ತೆಗೆದುಹಾಕಲು ಖಾಲಿ ಮಾಡಿ.';

  @override
  String get phoneIsYourLogin =>
      'ಇದರಿಂದಲೇ ನೀವು ಸೈನ್ ಇನ್ ಮಾಡುತ್ತೀರಿ, ಆದ್ದರಿಂದ ಇಲ್ಲಿ ಈಗ ಬದಲಾಯಿಸಲಾಗದು. ಬದಲಾಯಿಸಬೇಕಿದ್ದರೆ ಬೆಂಬಲವನ್ನು ಸಂಪರ್ಕಿಸಿ.';

  @override
  String get trialStarted =>
      'ಟ್ರಯಲ್ ಆರಂಭವಾಗಿದೆ. ನಿಮ್ಮ ಜಿಮ್ ಈಗ ಹುಡುಕಾಟದಲ್ಲಿ ಕಾಣಿಸುತ್ತದೆ.';

  @override
  String get invalidCode => 'ಕೋಡ್ ಮಾನ್ಯವಲ್ಲ.';

  @override
  String get paymentNotCompletedYet =>
      'ಪಾವತಿ ಇನ್ನೂ ಪೂರ್ಣಗೊಂಡಿಲ್ಲ. ಸ್ವಲ್ಪ ಸಮಯದ ನಂತರ ಎಳೆದು ರಿಫ್ರೆಶ್ ಮಾಡಿ.';

  @override
  String planIsActive(String plan) {
    return '$plan ಯೋಜನೆ ಸಕ್ರಿಯವಾಗಿದೆ.';
  }

  @override
  String get paymentNotCompleted => 'ಪಾವತಿ ಪೂರ್ಣಗೊಂಡಿಲ್ಲ.';

  @override
  String get couldNotOpenPayment => 'ಪಾವತಿ ಪರದೆ ತೆರೆಯಲಾಗಲಿಲ್ಲ.';

  @override
  String daysFree(int days) {
    return '$days ದಿನ ಉಚಿತ';
  }

  @override
  String get trialBlurb =>
      'ಪೂರ್ಣ ಪ್ರೊ, ಸದಸ್ಯರ ಹುಡುಕಾಟದಲ್ಲಿ ನಿಮ್ಮ ಪಟ್ಟಿ ಸೇರಿದಂತೆ. ಕಾರ್ಡ್ ಬೇಕಿಲ್ಲ, ಮತ್ತು ಇದು ತಾನಾಗಿಯೇ ಪಾವತಿ ಯೋಜನೆಯಾಗಿ ಬದಲಾಗುವುದಿಲ್ಲ.';

  @override
  String get startFreeTrial => 'ಉಚಿತ ಟ್ರಯಲ್ ಆರಂಭಿಸಿ';

  @override
  String get referralCode => 'ರೆಫರಲ್ ಕೋಡ್';

  @override
  String get optional => 'ಐಚ್ಛಿಕ';

  @override
  String get apply => 'ಅನ್ವಯಿಸಿ';

  @override
  String get gstNote =>
      'ಬೆಲೆಗಳಲ್ಲಿ ಜಿಎಸ್‌ಟಿ ಸೇರಿದೆ. ಪ್ರೊ ಯೋಜನೆಯಲ್ಲಿ ಮಾತ್ರ ಜಿಮ್ ಸದಸ್ಯರ ಹುಡುಕಾಟದಲ್ಲಿ ಕಾಣಿಸುತ್ತದೆ.';

  @override
  String planNamed(String plan) {
    return '$plan ಯೋಜನೆ';
  }

  @override
  String get trialBadge => 'ಟ್ರಯಲ್';

  @override
  String get expired => 'ಅವಧಿ ಮುಗಿದಿದೆ';

  @override
  String daysRemainingPlan(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ದಿನ ಬಾಕಿ',
    );
    return '$_temp0';
  }

  @override
  String get listedInSearch => 'ಸದಸ್ಯರ ಹುಡುಕಾಟದಲ್ಲಿ ಪಟ್ಟಿಯಾಗಿದೆ';

  @override
  String get notListedUpgrade =>
      'ಹುಡುಕಾಟದಲ್ಲಿ ಇಲ್ಲ — ಕಾಣಿಸಲು ಪ್ರೊಗೆ ಅಪ್‌ಗ್ರೇಡ್ ಮಾಡಿ';

  @override
  String get trialEndsNote =>
      'ಟ್ರಯಲ್ ಮುಗಿದ ಮೇಲೆ ನೀವು ಯೋಜನೆ ಆಯ್ಕೆ ಮಾಡುವವರೆಗೆ ನಿಮ್ಮ ಜಿಮ್ ಹುಡುಕಾಟದಿಂದ ಹೊರಗುಳಿಯುತ್ತದೆ. ತಾನಾಗಿಯೇ ಏನೂ ವಿಧಿಸಲಾಗುವುದಿಲ್ಲ.';

  @override
  String get getsYouListed => 'ಹುಡುಕಾಟದಲ್ಲಿ ತೋರಿಸುತ್ತದೆ';

  @override
  String get perMonth => '/ತಿಂಗಳು';

  @override
  String choosePlanNamed(String plan) {
    return '$plan ಆಯ್ಕೆಮಾಡಿ';
  }

  @override
  String get deleteRoleWarning =>
      'ಪಾತ್ರ ಮತ್ತು ಅದರ ಅನುಮತಿಗಳು ಹೋಗುತ್ತವೆ. ಇದರಲ್ಲಿ ಯಾರೂ ಇಲ್ಲ, ಹಾಗಾಗಿ ಯಾರಿಗೂ ಪ್ರವೇಶ ಕಳೆದುಹೋಗದು.';

  @override
  String deletedNamed(String name) {
    return '$name ಅಳಿಸಲಾಗಿದೆ';
  }

  @override
  String get needTwoCustomRoles =>
      'ಕ್ರಮ ಬದಲಾಯಿಸುವ ಮೊದಲು ನೀವು ಸಂಪಾದಿಸಬಹುದಾದ ಎರಡು ಕಸ್ಟಮ್ ಪಾತ್ರಗಳು ಬೇಕು.';

  @override
  String get hierarchySaved => 'ಶ್ರೇಣಿ ಉಳಿಸಲಾಗಿದೆ';

  @override
  String get reorder => 'ಕ್ರಮ ಬದಲಿಸಿ';

  @override
  String get newRole => 'ಹೊಸ ಪಾತ್ರ';

  @override
  String get rolesIntro =>
      'ಅತ್ಯಂತ ಹಿರಿಯದು ಮೊದಲು. ನಿಮ್ಮದಕ್ಕಿಂತ ಕೆಳಗಿನ ಪಾತ್ರಗಳನ್ನು ಮಾತ್ರ ಸಂಪಾದಿಸಬಹುದು, ನಿಮ್ಮ ಬಳಿ ಇರುವ ಅನುಮತಿಗಳನ್ನು ಮಾತ್ರ ನೀಡಬಹುದು.';

  @override
  String get defaultBadge => 'ಡೀಫಾಲ್ಟ್';

  @override
  String get everyPermission => 'ಪ್ರತಿ ಅನುಮತಿ, ನಂತರ ಸೇರಿಸುವವು ಸೇರಿದಂತೆ';

  @override
  String permissionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ಅನುಮತಿಗಳು',
    );
    return '$_temp0';
  }

  @override
  String get nobodyInThisRole => 'ಈ ಪಾತ್ರದಲ್ಲಿ ಯಾರೂ ಇಲ್ಲ';

  @override
  String peopleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ಜನ',
    );
    return '$_temp0';
  }

  @override
  String get deleteDefaultRolesStay => 'ಅಳಿಸಿ (ಡೀಫಾಲ್ಟ್ ಪಾತ್ರಗಳು ಉಳಿಯುತ್ತವೆ)';

  @override
  String get deleteMovePeopleFirst => 'ಅಳಿಸಿ (ಮೊದಲು ಜನರನ್ನು ಸ್ಥಳಾಂತರಿಸಿ)';

  @override
  String get giveRoleAName => 'ಪಾತ್ರಕ್ಕೆ ಹೆಸರು ನೀಡಿ';

  @override
  String get editRole => 'ಪಾತ್ರ ಸಂಪಾದಿಸಿ';

  @override
  String get createRole => 'ಪಾತ್ರ ರಚಿಸಿ';

  @override
  String get roleName => 'ಪಾತ್ರದ ಹೆಸರು';

  @override
  String get roleNameHint => 'ರಿಸೆಪ್ಶನ್, ಫಿಸಿಯೋ, ನೈಟ್ ಶಿಫ್ಟ್';

  @override
  String get superRoleNote =>
      'ಈ ಪಾತ್ರಕ್ಕೆ ಎಲ್ಲಾ ಅನುಮತಿಗಳಿವೆ, ಮುಂದೆ ಸೇರಿಸುವವೂ ಸೇರಿದಂತೆ. ಅದನ್ನು ಸಂಕುಚಿತಗೊಳಿಸಲಾಗದು — ಯಾವಾಗಲೂ ಸರಿಪಡಿಸಬಲ್ಲ ಪಾತ್ರ ಇದೇ.';

  @override
  String get whatThisRoleCanDo => 'ಈ ಪಾತ್ರ ಏನು ಮಾಡಬಹುದು';

  @override
  String get greyedOutNote =>
      'ಮಸುಕಾಗಿರುವವು ನಿಮ್ಮ ಬಳಿ ಇಲ್ಲದವು, ಹಾಗಾಗಿ ಅವನ್ನು ನೀಡಲಾಗದು.';

  @override
  String get ownerOnlyPermission => 'ಇದು ಜಿಮ್ ಮಾಲೀಕರಿಗೆ ಮಾತ್ರ';

  @override
  String get youDoNotHoldThis => 'ಇದು ನಿಮ್ಮ ಬಳಿ ಇಲ್ಲ';

  @override
  String get orderTheHierarchy => 'ಶ್ರೇಣಿಯನ್ನು ಜೋಡಿಸಿ';

  @override
  String get hierarchyNote =>
      'ಅತ್ಯಂತ ಹಿರಿಯದು ಮೇಲೆ. ಡೀಫಾಲ್ಟ್ ಪಾತ್ರಗಳು ತಮ್ಮ ಸ್ಥಾನದಲ್ಲೇ ಉಳಿಯುತ್ತವೆ, ಇಲ್ಲಿ ಕಾಣಿಸವು.';

  @override
  String get saveOrder => 'ಕ್ರಮ ಉಳಿಸಿ';

  @override
  String membershipExtendedBy(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ಸದಸ್ಯತ್ವ $count ತಿಂಗಳು ವಿಸ್ತರಿಸಲಾಗಿದೆ.',
    );
    return '$_temp0';
  }

  @override
  String get goalUpdated => 'ಗುರಿ ನವೀಕರಿಸಲಾಗಿದೆ.';

  @override
  String get thisMember => 'ಈ ಸದಸ್ಯ';

  @override
  String get removeMemberQuestion => 'ಸದಸ್ಯರನ್ನು ತೆಗೆಯಬೇಕೆ?';

  @override
  String removeMemberWarning(String name) {
    return '$name ಈ ಜಿಮ್‌ಗೆ ಪ್ರವೇಶ ಕಳೆದುಕೊಳ್ಳುತ್ತಾರೆ. ಅವರ ಹಾಜರಾತಿ ದಾಖಲೆ ಮತ್ತು ಅಳತೆಗಳು ಉಳಿಯುತ್ತವೆ.';
  }

  @override
  String get member => 'ಸದಸ್ಯ';

  @override
  String get removeMember => 'ಸದಸ್ಯರನ್ನು ತೆಗೆಯಿರಿ';

  @override
  String get daysLeft => 'ಉಳಿದ ದಿನ';

  @override
  String get leaveUsed => 'ಬಳಸಿದ ರಜೆ';

  @override
  String get extend => 'ವಿಸ್ತರಿಸಿ';

  @override
  String get editGoal => 'ಗುರಿ ಸಂಪಾದಿಸಿ';

  @override
  String get goal => 'ಗುರಿ';

  @override
  String get notSet => 'ಹೊಂದಿಸಿಲ್ಲ';

  @override
  String get noneAssigned => 'ಯಾರನ್ನೂ ನಿಯೋಜಿಸಿಲ್ಲ';

  @override
  String get attendanceHistory => 'ಹಾಜರಾತಿ ಇತಿಹಾಸ';

  @override
  String get viewAndCorrectRecords => 'ದಾಖಲೆಗಳನ್ನು ನೋಡಿ ಸರಿಪಡಿಸಿ';

  @override
  String sessionsSoFar(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ಇಲ್ಲಿಯವರೆಗೆ $count ಅವಧಿಗಳು',
    );
    return '$_temp0';
  }

  @override
  String get progressIsPrivate => 'ಪ್ರಗತಿ ಖಾಸಗಿ';

  @override
  String get monitoringOffNote =>
      'ಈ ಸದಸ್ಯರು ಪ್ರಗತಿ ಮೇಲ್ವಿಚಾರಣೆಯನ್ನು ಆಫ್ ಮಾಡಿದ್ದಾರೆ. ಅದು ಅವರ ಆಯ್ಕೆ, ಯಾವ ಪಾತ್ರವೂ ಅದನ್ನು ಮೀರಲಾಗದು.';

  @override
  String get progress => 'ಪ್ರಗತಿ';

  @override
  String get noMeasurementsYet =>
      'ಇನ್ನೂ ಅಳತೆಗಳು ದಾಖಲಾಗಿಲ್ಲ. ಸದಸ್ಯರನ್ನು ಅವರ ಆ್ಯಪ್‌ನಲ್ಲಿ ತಿಂಗಳಿಗೊಮ್ಮೆ ಕೇಳಲಾಗುತ್ತದೆ.';

  @override
  String holdingAtKg(String kg) {
    return '$kg ಕೆಜಿಯಲ್ಲಿ ಸ್ಥಿರ';
  }

  @override
  String weightChangeSince(String delta) {
    return 'ಮೊದಲ ಅಳತೆಯ ನಂತರ $delta ಕೆಜಿ';
  }

  @override
  String get extendMembership => 'ಸದಸ್ಯತ್ವ ವಿಸ್ತರಿಸಿ';

  @override
  String get extendFromTodayNote =>
      'ಅವಧಿ ಮುಗಿದ ಸದಸ್ಯತ್ವ ಇಂದಿನಿಂದ ವಿಸ್ತರಿಸುತ್ತದೆ, ಮುಗಿದ ದಿನಾಂಕದಿಂದ ಅಲ್ಲ.';

  @override
  String monthsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ತಿಂಗಳು',
    );
    return '$_temp0';
  }

  @override
  String extendByMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ತಿಂಗಳು ವಿಸ್ತರಿಸಿ',
    );
    return '$_temp0';
  }

  @override
  String get whatAreTheyWorkingTowards =>
      'ಅವರು ಯಾವ ಗುರಿಗಾಗಿ ಶ್ರಮಿಸುತ್ತಿದ್ದಾರೆ?';

  @override
  String get goalDialogHint => '80 ಕೆಜಿವರೆಗೆ ಬಲ್ಕ್, ತೂಕ ಇಳಿಕೆ, ಪುನರ್ವಸತಿ…';

  @override
  String signedUpCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ಜನ ಹೆಸರು ನೋಂದಾಯಿಸಿದ್ದಾರೆ',
    );
    return '$_temp0';
  }

  @override
  String get nobodyYet => 'ಇನ್ನೂ ಯಾರೂ ಇಲ್ಲ.';

  @override
  String get hostAnEvent => 'ಒಂದು ಕಾರ್ಯಕ್ರಮ ನಡೆಸಿ';

  @override
  String get noEventsYet =>
      'ಇನ್ನೂ ಕಾರ್ಯಕ್ರಮಗಳಿಲ್ಲ. ಒಂದನ್ನು ನಡೆಸಿ, ಅದು ನಿಮ್ಮ ಸದಸ್ಯರಿಗೆ ತಕ್ಷಣ ಕಾಣಿಸುತ್ತದೆ.';

  @override
  String get editEvent => 'ಈವೆಂಟ್ ಸಂಪಾದಿಸಿ';

  @override
  String get cancelEvent => 'ಈವೆಂಟ್ ರದ್ದುಮಾಡಿ';

  @override
  String get cancelEventConfirmTitle => 'ಈ ಈವೆಂಟ್ ಅನ್ನು ರದ್ದುಮಾಡುವುದೇ?';

  @override
  String get cancelEventConfirmBody =>
      'ಇದು ಈವೆಂಟ್ ಅನ್ನು ಶಾಶ್ವತವಾಗಿ ಅಳಿಸುತ್ತದೆ, ನೋಂದಾಯಿಸಿದವರ ಪಟ್ಟಿ ಸಹಿತ. ಇದನ್ನು ರದ್ದುಗೊಳಿಸಲಾಗುವುದಿಲ್ಲ.';

  @override
  String get keepEvent => 'ಈವೆಂಟ್ ಇರಿಸಿ';

  @override
  String get eventUpdated => 'ಈವೆಂಟ್ ನವೀಕರಿಸಲಾಗಿದೆ';

  @override
  String get eventCancelledSnackbar => 'ಈವೆಂಟ್ ಅಳಿಸಲಾಗಿದೆ';

  @override
  String get eventTitleHint => 'ಸಮ್ಮರ್ ಡೆಡ್‌ಲಿಫ್ಟ್ ಮೀಟ್';

  @override
  String get howToTakePart => 'ಹೇಗೆ ಭಾಗವಹಿಸುವುದು';

  @override
  String get howToTakePartHint => 'ಬೆಳಿಗ್ಗೆ 8 ಗಂಟೆಗೆ ತೂಕ. ನಿಮ್ಮ ಬೆಲ್ಟ್ ತನ್ನಿ.';

  @override
  String get prizeOptional => 'ಬಹುಮಾನ (ಐಚ್ಛಿಕ)';

  @override
  String get prizeHint => '₹10,000';

  @override
  String get membersCanSignUp => 'ಸದಸ್ಯರು ಆ್ಯಪ್‌ನಲ್ಲಿ ನೋಂದಾಯಿಸಬಹುದು';

  @override
  String get membersCanSignUpNote =>
      'ಆಫ್ ಮಾಡಿದರೆ ಬಟನ್ ಬದಲು ನಿಮ್ಮ ಷರತ್ತುಗಳು ಕಾಣಿಸುತ್ತವೆ.';

  @override
  String get listPublicly => 'ಸಾರ್ವಜನಿಕವಾಗಿ ತೋರಿಸಿ';

  @override
  String get listPubliclyNote => 'ದೇಶದಾದ್ಯಂತ ಕಾರ್ಯಕ್ರಮ ಫೀಡ್‌ನಲ್ಲಿ ಕಾಣಿಸುತ್ತದೆ.';

  @override
  String get listPubliclyProOnly =>
      'ಪ್ರೊ ಯೋಜನೆಯಲ್ಲಿ ಮಾತ್ರ. ನಿಮ್ಮ ಸದಸ್ಯರು ಇದನ್ನು ನೋಡುತ್ತಾರೆ.';

  @override
  String get openToOutsiders => 'ನಿಮ್ಮ ಜಿಮ್ ಹೊರಗಿನವರಿಗೂ ತೆರೆದಿದೆ';

  @override
  String get publishEvent => 'ಕಾರ್ಯಕ್ರಮ ಪ್ರಕಟಿಸಿ';

  @override
  String get registrationOpen => 'ನೋಂದಣಿ ತೆರೆದಿದೆ';

  @override
  String get registrationClosed => 'ನೋಂದಣಿ ಮುಚ್ಚಿದೆ';

  @override
  String get close => 'ಮುಚ್ಚಿ';

  @override
  String get markAllRead => 'ಎಲ್ಲವನ್ನೂ ಓದಿದಂತೆ ಗುರುತಿಸಿ';

  @override
  String get nothingYet => 'ಇನ್ನೂ ಏನೂ ಇಲ್ಲ';

  @override
  String get announcementsAppearHere =>
      'ನಿಮ್ಮ ಜಿಮ್ ಮತ್ತು ಜಿಮಾಲಜಿಯಾದಿಂದ ಪ್ರಕಟಣೆಗಳು ಇಲ್ಲಿ ಕಾಣಿಸುತ್ತವೆ.';

  @override
  String get searchPeople => 'ಜನರನ್ನು ಹುಡುಕಿ';

  @override
  String get nobodyElseHereYet => 'ಇಲ್ಲಿ ಇನ್ನೂ ಬೇರೆ ಯಾರೂ ಇಲ್ಲ.';

  @override
  String get nameTheGroup => 'ಗುಂಪಿಗೆ ಹೆಸರಿಡಿ';

  @override
  String get groupNameHint => 'ಶನಿವಾರ ಬೆಳಗಿನ ತಂಡ';

  @override
  String get create => 'ರಚಿಸಿ';

  @override
  String get pickWhoIsInTheGroup => 'ಗುಂಪಿನಲ್ಲಿ ಯಾರಿರಬೇಕು ಎಂದು ಆಯ್ಕೆಮಾಡಿ';

  @override
  String createGroupWith(int count) {
    return '$count ಜನರೊಂದಿಗೆ ಗುಂಪು ರಚಿಸಿ';
  }

  @override
  String get termsOfUse => 'ಬಳಕೆಯ ನಿಯಮಗಳು';

  @override
  String get privacy => 'ಗೌಪ್ಯತೆ';

  @override
  String versionUpdated(String version, String date) {
    return 'ಆವೃತ್ತಿ $version · ನವೀಕರಣ $date';
  }

  @override
  String sessionsAttendedAllTime(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ಅವಧಿಗಳು, ಒಟ್ಟು',
    );
    return '$_temp0';
  }

  @override
  String get nothingInLast60Days => 'ಕಳೆದ 60 ದಿನಗಳಲ್ಲಿ ಏನೂ ದಾಖಲಾಗಿಲ್ಲ.';

  @override
  String correctedReason(String reason) {
    return 'ಸರಿಪಡಿಸಲಾಗಿದೆ: $reason';
  }

  @override
  String get noReasonGiven => 'ಕಾರಣ ನೀಡಿಲ್ಲ';

  @override
  String get keptWithRecordAuditNote =>
      'ಇದು ದಾಖಲೆಯೊಂದಿಗೆ ಉಳಿಯುತ್ತದೆ ಮತ್ತು ಆಡಿಟ್ ಲಾಗ್‌ನಲ್ಲಿ ಕಾಣಿಸುತ್ತದೆ.';

  @override
  String get staffBadge => 'ಸಿಬ್ಬಂದಿ';

  @override
  String get draftCrmNote =>
      'ನಿಮ್ಮ ಜಿಮ್ ಕರಡು. CRM ಕೆಲಸ ಮಾಡುತ್ತದೆ, ಆದರೆ ಯೋಜನೆ ಸಕ್ರಿಯವಾಗುವವರೆಗೆ ಸದಸ್ಯರು ಹುಡುಕಾಟದಲ್ಲಿ ನಿಮ್ಮನ್ನು ಕಾಣಲಾರರು.';

  @override
  String roleHiddenNote(String role) {
    return 'ಇಲ್ಲಿ ನೀವು $role. ನಿಮ್ಮ ಪಾತ್ರಕ್ಕೆ ಸಾಧ್ಯವಿಲ್ಲದವನ್ನು ತೋರಿಸಿ ನಿರಾಕರಿಸುವ ಬದಲು ಮರೆಮಾಡಲಾಗುತ್ತದೆ.';
  }

  @override
  String engagedOfActive(int engaged, int total) {
    return '$total ಸದಸ್ಯರಲ್ಲಿ $engaged ಜನ ಕನಿಷ್ಠ ಒಮ್ಮೆ ತರಬೇತಿ ಪಡೆದರು.';
  }

  @override
  String announceGoesTo(String audience) {
    return 'ಇದು ಈಗಲೇ $audience ತಲುಪುತ್ತದೆ, ಹಿಂಪಡೆಯಲಾಗದು.';
  }

  @override
  String get audienceEveryMember => 'ಪ್ರತಿ ಸದಸ್ಯ';

  @override
  String get audienceEveryStaff => 'ಪ್ರತಿ ಸಿಬ್ಬಂದಿ';

  @override
  String get audienceEveryone => 'ಈ ಜಿಮ್‌ನ ಎಲ್ಲರೂ';

  @override
  String sentToPeople(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ಜನರಿಗೆ ಕಳುಹಿಸಲಾಗಿದೆ.',
    );
    return '$_temp0';
  }

  @override
  String recipientCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ಸ್ವೀಕರಿಸುವವರು',
    );
    return '$_temp0';
  }

  @override
  String get weTextACodeFirst =>
      'ಮೊದಲು ಅವರ ಸಂಖ್ಯೆಗೆ ಕೋಡ್ ಕಳುಹಿಸುತ್ತೇವೆ, ಅದು ನಿಜವಾಗಿಯೂ ಅವರದೇ ಎಂದು ತಿಳಿಯಲು.';

  @override
  String get memberCanUpdateMetrics =>
      'ಅವರು ಸದಸ್ಯ ಆ್ಯಪ್‌ನಲ್ಲಿ ತಮ್ಮ ತೂಕ ಮತ್ತು ಎತ್ತರವನ್ನು ನೋಡಿ ಬದಲಿಸಬಹುದು. ಅವರೇ ಆಫ್ ಮಾಡದ ಹೊರತು ಅವರ ಪ್ರಗತಿ ಸಿಬ್ಬಂದಿಗೆ ಕಾಣಿಸುತ್ತದೆ.';

  @override
  String get noRolesYouCanAssign =>
      'ನೀವು ನೀಡಬಹುದಾದ ಪಾತ್ರಗಳಿಲ್ಲ. ನಿಮ್ಮದಕ್ಕಿಂತ ಕೆಳಗಿನವನ್ನು ಮಾತ್ರ ನೀಡಬಹುದು.';

  @override
  String get noRolesYouCanAssignToThem => 'ಅವರಿಗೆ ನೀವು ನೀಡಬಹುದಾದ ಪಾತ್ರಗಳಿಲ್ಲ.';

  @override
  String heightCm(String cm) {
    return 'ಎತ್ತರ $cm ಸೆಂ.ಮೀ';
  }

  @override
  String weightOverCheckIns(String delta, int count) {
    return '$count ತಪಾಸಣೆಗಳಲ್ಲಿ $delta ಕೆಜಿ';
  }

  @override
  String get useDeviceLanguage => 'ಸಾಧನದ ಭಾಷೆ ಬಳಸಿ';

  @override
  String get untranslatedFallbackNote =>
      'ಇನ್ನೂ ಅನುವಾದವಾಗದವನ್ನು ಖಾಲಿ ಬಿಡುವ ಬದಲು ಇಂಗ್ಲಿಷ್‌ನಲ್ಲಿ ತೋರಿಸಲಾಗುತ್ತದೆ, ಹಾಗಾಗಿ ಭಾಗಶಃ ಅನುವಾದಿತ ಭಾಷೆಯೂ ಬಳಕೆಗೆ ಬರುತ್ತದೆ.';

  @override
  String deleteGymWarning(int members, int staff) {
    return 'ಎಲ್ಲಾ $members ಸದಸ್ಯರು ಮತ್ತು $staff ಸಿಬ್ಬಂದಿ ಪ್ರವೇಶ ಕಳೆದುಕೊಳ್ಳುತ್ತಾರೆ. ಇದನ್ನು ಆ್ಯಪ್‌ನಿಂದ ಹಿಂಪಡೆಯಲಾಗದು.';
  }

  @override
  String shownAsInSearch(String name, String district) {
    return 'ಹುಡುಕಾಟದಲ್ಲಿ “$name - $district” ಎಂದು ಕಾಣಿಸುತ್ತದೆ.';
  }

  @override
  String get nothingWaitingLeave =>
      'ಕಾಯುತ್ತಿರುವುದು ಏನೂ ಇಲ್ಲ. ನಿಮ್ಮ ಮಿತಿಯೊಳಗಿನ ವಿನಂತಿಗಳು ತಂತಾನೇ ಅನುಮೋದನೆಗೊಂಡು ಇಲ್ಲಿ ಕಾಣಿಸವು.';

  @override
  String get quietPeriodsNote =>
      'ಶಾಂತ ಅವಧಿಗಳನ್ನು ಬಿಡದೆ ಖಾಲಿ ಪಟ್ಟಿಗಳಾಗಿ ತೋರಿಸಲಾಗುತ್ತದೆ, ಹಾಗಾಗಿ ಪಟ್ಟಿಗಳಲ್ಲಿನ ಅಂತರ ನಿಜವಾದ ಅಂತರ.';

  @override
  String get rankingExplainer =>
      'ಹುಡುಕಾಟ ಫಲಿತಾಂಶಗಳನ್ನು ಜೋಡಿಸುವ ಅದೇ ರೀತಿಯಲ್ಲಿ ಸ್ಥಾನ ಲೆಕ್ಕ ಹಾಕಲಾಗುತ್ತದೆ: ಮೊದಲು ರೇಟಿಂಗ್, ನಂತರ ಎಷ್ಟು ರೇಟಿಂಗ್‌ಗಳು ಅದನ್ನು ಬೆಂಬಲಿಸುತ್ತವೆ. ಇಲ್ಲಿ ಕಾಣುವುದೇ ಸದಸ್ಯರಿಗೂ ಕಾಣುತ್ತದೆ.';

  @override
  String get deleteTrainerCategoryWarning =>
      'ಇನ್ನು ಈ ವರ್ಗದಲ್ಲಿ ತರಬೇತುದಾರರನ್ನು ಸೇರಿಸಲಾಗದು. ಈಗಾಗಲೇ ಇರುವವರ ನಿಯೋಜನೆ ಮುಂದುವರಿಯುತ್ತದೆ.';

  @override
  String get youLabel => 'ನೀವು';

  @override
  String get openEvents => 'ತೆರೆದ ಕಾರ್ಯಕ್ರಮಗಳು';

  @override
  String get nothingHereYetSaySomething => 'ಇಲ್ಲಿ ಇನ್ನೂ ಏನೂ ಇಲ್ಲ. ಏನಾದರೂ ಹೇಳಿ.';

  @override
  String get leavePausesMembership =>
      'ನೀವು ಇಲ್ಲದಿರುವಾಗ ಸದಸ್ಯತ್ವ ನಿಲ್ಲುತ್ತದೆ, ಹಾಗಾಗಿ ನೀವು ಪಾವತಿಸಿದ ದಿನಗಳು ಉಳಿಯುತ್ತವೆ.';

  @override
  String get notListedUntilPlan =>
      'ಯೋಜನೆ ಸಕ್ರಿಯವಾಗುವವರೆಗೆ ಸಾರ್ವಜನಿಕವಾಗಿ ಕಾಣಿಸದು.';

  @override
  String gymsListedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ಜಿಮ್‌ಗಳು ಪಟ್ಟಿಯಲ್ಲಿವೆ',
    );
    return '$_temp0';
  }

  @override
  String get checkInGoalNote =>
      'ನಿಮ್ಮ ಗುರಿಯತ್ತ ಪ್ರಗತಿಯನ್ನು ಗಮನಿಸಲು ನಿಮ್ಮ ಜಿಮ್ ಇದನ್ನು ಬಳಸುತ್ತದೆ.';

  @override
  String get enterYourGymName => 'ನಿಮ್ಮ ಜಿಮ್ ಹೆಸರು ನಮೂದಿಸಿ';

  @override
  String get sessionExpiredSignIn =>
      'ನಿಮ್ಮ ಸೆಶನ್ ಮುಗಿದಿದೆ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಸೈನ್ ಇನ್ ಮಾಡಿ.';

  @override
  String get somethingWentWrongTryAgain =>
      'ಏನೋ ತಪ್ಪಾಗಿದೆ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get serverTookTooLong =>
      'ಸರ್ವರ್ ಪ್ರತಿಕ್ರಿಯಿಸಲು ಬಹಳ ಸಮಯ ತೆಗೆದುಕೊಂಡಿತು. ಸಂಪರ್ಕ ಪರಿಶೀಲಿಸಿ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String couldNotReachServer(String host) {
    return '$host ನಲ್ಲಿನ ಸರ್ವರ್ ತಲುಪಲಾಗಲಿಲ್ಲ. ನಿಮ್ಮ ಇಂಟರ್ನೆಟ್ ಸಂಪರ್ಕ ಪರಿಶೀಲಿಸಿ.';
  }

  @override
  String get certificateNotVerified =>
      'ಸರ್ವರ್ ಪ್ರಮಾಣಪತ್ರವನ್ನು ಪರಿಶೀಲಿಸಲಾಗಲಿಲ್ಲ.';

  @override
  String get networkErrorTryAgain =>
      'ನೆಟ್‌ವರ್ಕ್ ದೋಷ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get enterValidMobile => '10 ಅಂಕಿಯ ಸರಿಯಾದ ಭಾರತೀಯ ಮೊಬೈಲ್ ಸಂಖ್ಯೆ ನಮೂದಿಸಿ';

  @override
  String get enterValidTenDigitNumber => '10 ಅಂಕಿಯ ಸರಿಯಾದ ಸಂಖ್ಯೆ ನಮೂದಿಸಿ';

  @override
  String get enterYourName => 'ನಿಮ್ಮ ಹೆಸರು ನಮೂದಿಸಿ';

  @override
  String get nameTooLong => 'ಆ ಹೆಸರು ತುಂಬಾ ಉದ್ದವಾಗಿದೆ';

  @override
  String get enterValidEmail => 'ಸರಿಯಾದ ಇಮೇಲ್ ವಿಳಾಸ ನಮೂದಿಸಿ';

  @override
  String get enterYourAge => 'ನಿಮ್ಮ ವಯಸ್ಸು ನಮೂದಿಸಿ';

  @override
  String get mustBeAtLeast13 => 'ನಿಮ್ಮ ವಯಸ್ಸು ಕನಿಷ್ಠ 13 ಇರಬೇಕು';

  @override
  String get enterValidAge => 'ಸರಿಯಾದ ವಯಸ್ಸು ನಮೂದಿಸಿ';

  @override
  String get enterWeightOrHeight => 'ತೂಕ ಅಥವಾ ಎತ್ತರ ನಮೂದಿಸಿ.';

  @override
  String get noRatingsYet => 'ಇನ್ನೂ ರೇಟಿಂಗ್‌ಗಳಿಲ್ಲ';

  @override
  String get giveItATitle => 'ಒಂದು ಶೀರ್ಷಿಕೆ ನೀಡಿ.';

  @override
  String get sayWhatYouWantThemToKnow => 'ಅವರಿಗೆ ಏನು ತಿಳಿಸಬೇಕೆಂದು ಬರೆಯಿರಿ.';

  @override
  String get sayWhyThisIsChanging =>
      'ಇದನ್ನು ಏಕೆ ಬದಲಾಯಿಸಲಾಗುತ್ತಿದೆ ಎಂದು ಬರೆಯಿರಿ.';

  @override
  String get noMembersYetAddFirst => 'ಇನ್ನೂ ಸದಸ್ಯರಿಲ್ಲ. ಮೊದಲಿಗರನ್ನು ಸೇರಿಸಿ.';

  @override
  String get nobodyMatchedSearch => 'ಆ ಹುಡುಕಾಟಕ್ಕೆ ಯಾರೂ ಹೊಂದಲಿಲ್ಲ.';

  @override
  String get turningUp => 'ಹಾಜರಾತಿ';

  @override
  String get justNow => 'ಈಗಷ್ಟೇ';

  @override
  String minutesAgo(int count) {
    return '$count ನಿಮಿಷದ ಹಿಂದೆ';
  }

  @override
  String hoursAgo(int count) {
    return '$count ಗಂಟೆ ಹಿಂದೆ';
  }

  @override
  String daysAgo(int count) {
    return '$count ದಿನ ಹಿಂದೆ';
  }

  @override
  String monthsAgo(int count) {
    return '$count ತಿಂಗಳ ಹಿಂದೆ';
  }

  @override
  String get nowShort => 'ಈಗ';

  @override
  String minutesShort(int count) {
    return '$count ನಿ';
  }

  @override
  String hoursShort(int count) {
    return '$count ಗಂ';
  }

  @override
  String daysShort(int count) {
    return '$count ದಿ';
  }

  @override
  String weeksShort(int count) {
    return '$count ವಾ';
  }

  @override
  String addedNamed(String name) {
    return '$name ಸೇರಿಸಲಾಗಿದೆ';
  }

  @override
  String get saved => 'ಉಳಿಸಲಾಗಿದೆ';

  @override
  String get trainerCategoriesIntro =>
      'ತರಬೇತುದಾರರನ್ನು ಸೇರಿಸುವಾಗ ಇವುಗಳಲ್ಲಿ ಒಂದರಲ್ಲಿ ಇರಿಸಲಾಗುತ್ತದೆ. ತರಬೇತುದಾರರಿರುವ ವರ್ಗವನ್ನು ಅವರನ್ನು ಸ್ಥಳಾಂತರಿಸುವವರೆಗೆ ಅಳಿಸಲಾಗದು.';

  @override
  String get trainerCategoriesReadOnly =>
      'ಈ ಜಿಮ್‌ನ ವರ್ಗಗಳನ್ನು ನೀವು ನೋಡಬಹುದು. ಬದಲಿಸಲು ತರಬೇತುದಾರ-ನಿರ್ವಹಣೆ ಅನುಮತಿ ಬೇಕು.';

  @override
  String get oneTrainerManyMembersShort => 'ಒಬ್ಬ ತರಬೇತುದಾರ, ಹಲವು ಸದಸ್ಯರು';

  @override
  String get oneMemberPerTrainer => 'ಪ್ರತಿ ತರಬೇತುದಾರರಿಗೆ ಒಬ್ಬ ಸದಸ್ಯ';

  @override
  String get noTrainers => 'ತರಬೇತುದಾರರಿಲ್ಲ';

  @override
  String trainerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ತರಬೇತುದಾರರು',
    );
    return '$_temp0';
  }

  @override
  String get deleteMoveTrainersFirst =>
      'ಅಳಿಸಿ (ಮೊದಲು ತರಬೇತುದಾರರನ್ನು ಸ್ಥಳಾಂತರಿಸಿ)';

  @override
  String get giveCategoryAName => 'ವರ್ಗಕ್ಕೆ ಹೆಸರು ನೀಡಿ';

  @override
  String get editCategory => 'ವರ್ಗ ಸಂಪಾದಿಸಿ';

  @override
  String get newTrainerCategory => 'ಹೊಸ ತರಬೇತುದಾರ ವರ್ಗ';

  @override
  String get generalTrainingNote => 'ಸಾಮಾನ್ಯ ತರಬೇತಿಗೆ ಇದೇ ಸಾಮಾನ್ಯ ಸೆಟ್ಟಿಂಗ್.';

  @override
  String get personalTrainingNote =>
      'ವೈಯಕ್ತಿಕ ತರಬೇತಿ: ಇಲ್ಲಿನ ತರಬೇತುದಾರ ಒಂದು ಬಾರಿಗೆ ಒಬ್ಬ ಸದಸ್ಯರನ್ನೇ ತೆಗೆದುಕೊಳ್ಳುತ್ತಾರೆ.';

  @override
  String get addCategory => 'ವರ್ಗ ಸೇರಿಸಿ';

  @override
  String get listedPublicly => 'ಸಾರ್ವಜನಿಕವಾಗಿ ಪಟ್ಟಿಯಾಗಿದೆ';

  @override
  String get yourMembersOnly => 'ನಿಮ್ಮ ಸದಸ್ಯರಿಗೆ ಮಾತ್ರ';

  @override
  String get whenDoesItStart => 'ಇದು ಯಾವಾಗ ಆರಂಭವಾಗುತ್ತದೆ?';

  @override
  String get chooseStartDateFirst => 'ಮೊದಲು ಆರಂಭದ ದಿನಾಂಕ ಆಯ್ಕೆಮಾಡಿ.';

  @override
  String get lastDayToRegister => 'ನೋಂದಣಿಗೆ ಕೊನೆಯ ದಿನ';

  @override
  String get giveTheEventATitle => 'ಕಾರ್ಯಕ್ರಮಕ್ಕೆ ಶೀರ್ಷಿಕೆ ನೀಡಿ.';

  @override
  String get addADescription => 'ಒಂದು ವಿವರಣೆ ಸೇರಿಸಿ, ಕನಿಷ್ಠ ಒಂದು ವಾಕ್ಯ.';

  @override
  String get sayHowToTakePart => 'ಭಾಗವಹಿಸಲು ಏನು ಮಾಡಬೇಕೆಂದು ಬರೆಯಿರಿ.';

  @override
  String get pickTheDates => 'ದಿನಾಂಕಗಳನ್ನು ಆಯ್ಕೆಮಾಡಿ.';

  @override
  String startsAtWhen(String when) {
    return '$when ಆರಂಭ';
  }

  @override
  String registerByWhen(String when) {
    return '$when ಒಳಗೆ ನೋಂದಾಯಿಸಿ';
  }

  @override
  String get selectYourLeaveDates => 'ನಿಮ್ಮ ರಜೆಯ ದಿನಾಂಕಗಳನ್ನು ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get chooseYourDatesFirst => 'ಮೊದಲು ನಿಮ್ಮ ದಿನಾಂಕಗಳನ್ನು ಆಯ್ಕೆಮಾಡಿ.';

  @override
  String get sentForApproval => 'ಅನುಮೋದನೆಗೆ ಕಳುಹಿಸಲಾಗಿದೆ.';

  @override
  String get leaveApprovedPaused =>
      'ರಜೆ ಅನುಮೋದಿಸಲಾಗಿದೆ. ಆ ದಿನಗಳಿಗೆ ನಿಮ್ಮ ಸದಸ್ಯತ್ವ ನಿಲ್ಲುತ್ತದೆ.';

  @override
  String get chooseDates => 'ದಿನಾಂಕ ಆಯ್ಕೆಮಾಡಿ';

  @override
  String leaveDaysLeftCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ನಿಮಗೆ $count ರಜೆ ದಿನಗಳು ಉಳಿದಿವೆ.',
    );
    return '$_temp0';
  }

  @override
  String moreThanRemainingDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'ಇದು ನಿಮ್ಮ ಉಳಿದ $count ದಿನಗಳಿಗಿಂತ ಹೆಚ್ಚು, ಹಾಗಾಗಿ ಒಬ್ಬ ಮ್ಯಾನೇಜರ್ ಅನುಮೋದಿಸಬೇಕು.',
    );
    return '$_temp0';
  }

  @override
  String get withinYourAllowance =>
      'ನಿಮ್ಮ ಮಿತಿಯೊಳಗೆ — ಇದು ತಕ್ಷಣ ಅನುಮೋದನೆಯಾಗುತ್ತದೆ.';

  @override
  String get sendForApproval => 'ಅನುಮೋದನೆಗೆ ಕಳುಹಿಸಿ';

  @override
  String get enterCodeSentToTheirPhone => 'ಅವರ ಫೋನ್‌ಗೆ ಕಳುಹಿಸಿದ ಕೋಡ್ ನಮೂದಿಸಿ.';

  @override
  String get numberIsNewNameNeeded => 'ಈ ಸಂಖ್ಯೆ ಹೊಸದು, ಹಾಗಾಗಿ ಹೆಸರು ಬೇಕು.';

  @override
  String get chooseARole => 'ಒಂದು ಪಾತ್ರ ಆಯ್ಕೆಮಾಡಿ.';

  @override
  String get isATrainer => 'Is a trainer?';

  @override
  String get chooseATrainerCategory => 'Choose a trainer category.';

  @override
  String get trainerCategory => 'Trainer category';

  @override
  String get addAMember => 'ಒಬ್ಬ ಸದಸ್ಯರನ್ನು ಸೇರಿಸಿ';

  @override
  String get codeSentExistingAccount =>
      'ಕೋಡ್ ಕಳುಹಿಸಲಾಗಿದೆ. ಈ ಸಂಖ್ಯೆಗೆ ಈಗಾಗಲೇ ಜಿಮಾಲಜಿಯಾ ಖಾತೆ ಇದೆ.';

  @override
  String get codeSentNewAccount =>
      'ಕೋಡ್ ಕಳುಹಿಸಲಾಗಿದೆ. ಈ ಸಂಖ್ಯೆ ಹೊಸದು, ಹಾಗಾಗಿ ನಾವು ಖಾತೆ ರಚಿಸುತ್ತೇವೆ.';

  @override
  String get membershipLength => 'ಸದಸ್ಯತ್ವದ ಅವಧಿ';

  @override
  String get leaveDaysAllowed => 'ಅನುಮತಿಸಿದ ರಜೆ ದಿನಗಳು';

  @override
  String get ownerStaffMode => 'ಮಾಲೀಕ / ಸಿಬ್ಬಂದಿ ಮೋಡ್';

  @override
  String get memberMode => 'ಸದಸ್ಯ ಮೋಡ್';

  @override
  String get managingGymsNote =>
      'ನೀವು ಜಿಮ್‌ಗಳನ್ನು ನಿರ್ವಹಿಸುತ್ತಿದ್ದೀರಿ. ಸದಸ್ಯರಾಗಿ ಜಿಮಾಲಜಿಯಾ ಬಳಸಲು ಮರಳಿ ಬದಲಿಸಿ.';

  @override
  String get openingAGymNote =>
      'ಜಿಮ್ ತೆರೆಯುತ್ತಿದ್ದೀರಾ, ಅಥವಾ ಒಂದರಲ್ಲಿ ಕೆಲಸ ಮಾಡುತ್ತೀರಾ? ನಿಮ್ಮ ಜಿಮ್‌ನ CRM ನಡೆಸಲು ಬದಲಿಸಿ — ಸದಸ್ಯರು, ಸಿಬ್ಬಂದಿ, ಹಾಜರಾತಿ ಮತ್ತು ರಜೆ.';

  @override
  String get numberIsHowYouSignIn =>
      'ನಿಮ್ಮ ಸಂಖ್ಯೆಯಿಂದಲೇ ನೀವು ಸೈನ್ ಇನ್ ಮಾಡುತ್ತೀರಿ, ಹಾಗಾಗಿ ಇಲ್ಲಿ ಈಗ ಬದಲಾಯಿಸಲಾಗದು.';

  @override
  String get followingYourDevice => 'ನಿಮ್ಮ ಸಾಧನವನ್ನು ಅನುಸರಿಸುತ್ತಿದೆ';

  @override
  String get yourGym => 'ನಿಮ್ಮ ಜಿಮ್';

  @override
  String weeksRunning(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ಸತತ ವಾರಗಳು',
      one: 'ಸತತ ವಾರ',
    );
    return '$_temp0';
  }

  @override
  String noVisitsInLastDays(int days) {
    return 'ಕಳೆದ $days ದಿನಗಳಲ್ಲಿ ಭೇಟಿ ದಾಖಲಾಗಿಲ್ಲ.';
  }

  @override
  String visitsInLastDays(int count, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ಕಳೆದ $days ದಿನಗಳಲ್ಲಿ $count ಭೇಟಿಗಳು.',
    );
    return '$_temp0';
  }

  @override
  String get couldNotLoadEvents => 'ಕಾರ್ಯಕ್ರಮಗಳನ್ನು ಲೋಡ್ ಮಾಡಲಾಗಲಿಲ್ಲ';

  @override
  String get noEventsOnRightNow => 'ಈಗ ಯಾವುದೇ ಕಾರ್ಯಕ್ರಮಗಳಿಲ್ಲ';

  @override
  String get eventsAppearHere =>
      'ನಿಮ್ಮ ಜಿಮ್ ನಡೆಸುವ ಕಾರ್ಯಕ್ರಮಗಳು ಇಲ್ಲಿ ಕಾಣಿಸುತ್ತವೆ, ಹತ್ತಿರದ ಎಲ್ಲರಿಗೂ ತೆರೆದವು ಸಹ.';

  @override
  String get atYourGym => 'ನಿಮ್ಮ ಜಿಮ್‌ನಲ್ಲಿ';

  @override
  String trainerStaffMembersAt(String gym) {
    return '$gym ನಲ್ಲಿನ ನಿಮ್ಮ ತರಬೇತುದಾರ, ಸಿಬ್ಬಂದಿ ಮತ್ತು ಸದಸ್ಯರು';
  }

  @override
  String get trainerStaffOtherMembers =>
      'ನಿಮ್ಮ ತರಬೇತುದಾರ, ಸಿಬ್ಬಂದಿ ಮತ್ತು ಇತರ ಸದಸ್ಯರು';

  @override
  String get comingNext => 'ಮುಂದೆ ಬರುತ್ತಿದೆ';

  @override
  String get progressChartsAgainstGoal =>
      'ನಿಮ್ಮ ಗುರಿಗೆ ಹೋಲಿಸಿ ಪ್ರಗತಿ ಚಾರ್ಟ್‌ಗಳು';

  @override
  String get leaveLeft => 'ಉಳಿದ ರಜೆ';

  @override
  String approvedMembershipPauses(String name) {
    return '$name ಅನುಮೋದಿಸಲಾಗಿದೆ. ಆ ದಿನಗಳಿಗೆ ಅವರ ಸದಸ್ಯತ್ವ ನಿಲ್ಲುತ್ತದೆ.';
  }

  @override
  String get approveInstead => 'ಬದಲಿಗೆ ಅನುಮೋದಿಸಿ';

  @override
  String get declineInstead => 'ಬದಲಿಗೆ ನಿರಾಕರಿಸಿ';

  @override
  String get needsYou => 'ನಿಮ್ಮ ಗಮನ ಬೇಕು';

  @override
  String get autoApproved => 'ತಾನಾಗಿಯೇ ಅನುಮೋದನೆ';

  @override
  String get returnedEarly => 'ಬೇಗ ಮರಳಿದರು';

  @override
  String get whereYouAre => 'ನೀವು ಎಲ್ಲಿದ್ದೀರಿ';

  @override
  String get enterTheAddress => 'ವಿಳಾಸ ನಮೂದಿಸಿ';

  @override
  String get maximumPerMembership => 'ಪ್ರತಿ ಸದಸ್ಯತ್ವಕ್ಕೆ ಗರಿಷ್ಠ';

  @override
  String removeStaffWithAssigned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'ಅವರು ಈ ಜಿಮ್‌ಗೆ ಪ್ರವೇಶ ಕಳೆದುಕೊಳ್ಳುತ್ತಾರೆ, ಅವರಿಗೆ ನಿಯೋಜಿಸಿದ $count ಸದಸ್ಯರಿಗೆ ನೀವು ಬೇರೊಬ್ಬರನ್ನು ನಿಯೋಜಿಸುವವರೆಗೆ ತರಬೇತುದಾರರಿರುವುದಿಲ್ಲ.',
    );
    return '$_temp0';
  }

  @override
  String get removeStaffPlain =>
      'ಅವರು ಈ ಜಿಮ್‌ಗೆ ಪ್ರವೇಶ ಕಳೆದುಕೊಳ್ಳುತ್ತಾರೆ. ಅವರ ಹಾಜರಾತಿ ದಾಖಲೆ ಉಳಿಯುತ್ತದೆ.';

  @override
  String get couldNotLoadGyms => 'ಜಿಮ್‌ಗಳನ್ನು ಲೋಡ್ ಮಾಡಲಾಗಲಿಲ್ಲ';

  @override
  String get noGymsListedYet => 'ಇನ್ನೂ ಜಿಮ್‌ಗಳು ಪಟ್ಟಿಯಾಗಿಲ್ಲ';

  @override
  String get gymsAppearOnPro =>
      'ಪ್ರೊ ಯೋಜನೆಯಲ್ಲಿದ್ದು ಪಟ್ಟಿಯಾಗಲು ಆಯ್ಕೆ ಮಾಡಿದ ಜಿಮ್‌ಗಳು ಇಲ್ಲಿ ಕಾಣಿಸುತ್ತವೆ.';

  @override
  String nothingMatchedTry(String query) {
    return '“$query” ಗೆ ಏನೂ ಹೊಂದಲಿಲ್ಲ. ಬೇರೆ ನಗರ ಅಥವಾ ಜಿಲ್ಲೆ ಪ್ರಯತ್ನಿಸಿ.';
  }

  @override
  String get noRatings => 'ರೇಟಿಂಗ್‌ಗಳಿಲ್ಲ';

  @override
  String get noPerksYet => 'ಇನ್ನೂ ಯಾವುದೇ ಸೌಲಭ್ಯಗಳನ್ನು ಪಟ್ಟಿ ಮಾಡಿಲ್ಲ';

  @override
  String fromRatings(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ರೇಟಿಂಗ್‌ಗಳಿಂದ',
    );
    return '$_temp0';
  }

  @override
  String get onlyProGymHere => 'ಇಲ್ಲಿನ ಏಕೈಕ ಪ್ರೊ ಜಿಮ್';

  @override
  String ofProGyms(int count) {
    return '$count ಪ್ರೊ ಜಿಮ್‌ಗಳಲ್ಲಿ';
  }

  @override
  String get couldNotLoadYourGyms => 'ನಿಮ್ಮ ಜಿಮ್‌ಗಳನ್ನು ಲೋಡ್ ಮಾಡಲಾಗಲಿಲ್ಲ';

  @override
  String get noGymsYet => 'ಇನ್ನೂ ಜಿಮ್‌ಗಳಿಲ್ಲ';

  @override
  String get createYourGymBlurb =>
      'ಸದಸ್ಯರು, ಸಿಬ್ಬಂದಿ, ಹಾಜರಾತಿ ಮತ್ತು ರಜೆ ಹೊಂದಿಸಲು ನಿಮ್ಮ ಜಿಮ್ ರಚಿಸಿ. ಯಾವುದಾದರೂ ಜಿಮ್‌ನಲ್ಲಿ ಕೆಲಸ ಮಾಡಿದರೆ ಮಾಲೀಕರನ್ನು ಸೇರಿಸಲು ಕೇಳಿ, ಅದು ಇಲ್ಲಿ ಕಾಣಿಸುತ್ತದೆ.';

  @override
  String newGroupSelected(int count) {
    return 'ಹೊಸ ಗುಂಪು ($count ಆಯ್ಕೆ)';
  }

  @override
  String get newMessage => 'ಹೊಸ ಸಂದೇಶ';

  @override
  String get oneToOne => 'ಒಬ್ಬರಿಗೊಬ್ಬರು';

  @override
  String get group => 'ಗುಂಪು';

  @override
  String get buildMuscle => 'ಸ್ನಾಯು ಬೆಳೆಸಿ';

  @override
  String get loseFat => 'ಕೊಬ್ಬು ಇಳಿಸಿ';

  @override
  String get getStronger => 'ಬಲ ಹೆಚ್ಚಿಸಿ';

  @override
  String get officialGroupEmpty => 'ಈ ಜಿಮ್‌ನ ಎಲ್ಲರೂ. ಇನ್ನೂ ಏನೂ ಹೇಳಿಲ್ಲ.';

  @override
  String get unofficialGroupEmpty => 'ಸದಸ್ಯರು ಮಾತ್ರ. ಇನ್ನೂ ಏನೂ ಹೇಳಿಲ್ಲ.';

  @override
  String get noMessagesYet => 'ಇನ್ನೂ ಸಂದೇಶಗಳಿಲ್ಲ';

  @override
  String get approved => 'ಅನುಮೋದಿಸಲಾಗಿದೆ';

  @override
  String get declined => 'ನಿರಾಕರಿಸಲಾಗಿದೆ';

  @override
  String get cancelled => 'ರದ್ದುಗೊಳಿಸಲಾಗಿದೆ';

  @override
  String get flexibility => 'ನಮ್ಯತೆ';

  @override
  String get rehab => 'ಪುನರ್ವಸತಿ';

  @override
  String get youPrefix => 'ನೀವು: ';

  @override
  String get active => 'ಸಕ್ರಿಯ';

  @override
  String get joined => 'ಸೇರಿದವರು';

  @override
  String get leftCount => 'ಬಿಟ್ಟವರು';

  @override
  String get net => 'ನಿವ್ವಳ';

  @override
  String get daily => 'ದೈನಂದಿನ';

  @override
  String get monthly => 'ಮಾಸಿಕ';

  @override
  String get yearly => 'ವಾರ್ಷಿಕ';

  @override
  String get add => 'ಸೇರಿಸಿ';

  @override
  String get update => 'ನವೀಕರಿಸಿ';

  @override
  String get required => 'ಅಗತ್ಯ';

  @override
  String get contact => 'ಸಂಪರ್ಕ';

  @override
  String get owner => 'ಮಾಲೀಕ';

  @override
  String get support => 'ಬೆಂಬಲ';

  @override
  String get machineTranslatedExercise =>
      'ಈ ಸೂಚನೆಗಳು ಯಂತ್ರಾನುವಾದ, ಯಾವ ತರಬೇತುದಾರರೂ ಪರಿಶೀಲಿಸಿಲ್ಲ. ಏನಾದರೂ ವಿಚಿತ್ರವೆನಿಸಿದರೆ ತೂಕ ಎತ್ತುವ ಮೊದಲು ಇಂಗ್ಲಿಷ್‌ಗೆ ಬದಲಾಯಿಸಿ ಹೋಲಿಸಿ.';

  @override
  String get home => 'ಮುಖಪುಟ';

  @override
  String get myGym => 'ನನ್ನ ಜಿಮ್';

  @override
  String get discover => 'ಅನ್ವೇಷಿಸಿ';

  @override
  String get sendOtp => 'OTP ಕಳುಹಿಸಿ';

  @override
  String get verifyYourNumber => 'ನಿಮ್ಮ ಸಂಖ್ಯೆ ಪರಿಶೀಲಿಸಿ';

  @override
  String get codeResent => 'ಹೊಸ ಕೋಡ್ ಕಳುಹಿಸಲಾಗುತ್ತಿದೆ.';

  @override
  String get name => 'ಹೆಸರು';

  @override
  String get email => 'ಇಮೇಲ್';

  @override
  String get connection => 'ಸಂಪರ್ಕ';

  @override
  String get account => 'ಖಾತೆ';

  @override
  String get session => 'ಸೆಷನ್';

  @override
  String get earnByReferring => 'ಶಿಫಾರಸು ಮಾಡಿ ಗಳಿಸಿ';

  @override
  String get gyms => 'ಜಿಮ್‌ಗಳು';

  @override
  String get events => 'ಕಾರ್ಯಕ್ರಮಗಳು';

  @override
  String get chat => 'ಚಾಟ್';

  @override
  String get findAGym => 'ಜಿಮ್ ಹುಡುಕಿ';

  @override
  String get searchGyms => 'ಹೆಸರು ಅಥವಾ ಪ್ರದೇಶದಿಂದ ಹುಡುಕಿ';

  @override
  String get perks => 'ಸೌಲಭ್ಯಗಳು';

  @override
  String get rating => 'ರೇಟಿಂಗ್';

  @override
  String get onLeavePaused => 'ರಜೆಯಲ್ಲಿ — ನಿಮ್ಮ ಸದಸ್ಯತ್ವ ನಿಲ್ಲಿಸಲಾಗಿದೆ';

  @override
  String get monthlyCheckIn => 'ಮಾಸಿಕ ಚೆಕ್-ಇನ್';

  @override
  String get notNow => 'ಈಗ ಬೇಡ';

  @override
  String trainerNamed(String name) {
    return 'ತರಬೇತುದಾರ: $name';
  }

  @override
  String goalAtGym(String gym) {
    return '$gym ನಲ್ಲಿ ನಿಮ್ಮ ಗುರಿ';
  }

  @override
  String daysRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ದಿನ ಬಾಕಿ',
      one: '1 ದಿನ ಬಾಕಿ',
      zero: 'ಇಂದು ಮುಗಿಯುತ್ತದೆ',
    );
    return '$_temp0';
  }

  @override
  String get yourGoal => 'ನಿಮ್ಮ ಗುರಿ';

  @override
  String get trainer => 'ತರಬೇತುದಾರ';

  @override
  String get requestLeave => 'ರಜೆ ಕೋರಿಕೆ';

  @override
  String get yourProgress => 'ನಿಮ್ಮ ಪ್ರಗತಿ';

  @override
  String get addMeasurementsPrompt =>
      'ನಿಮ್ಮ ತೂಕ ಮತ್ತು ಎತ್ತರ ಸೇರಿಸಿ, ಆಗ ಜಿಮ್ ನಿಮ್ಮೊಂದಿಗೆ ಪ್ರಗತಿ ನೋಡಬಹುದು.';

  @override
  String get progressSubtitle =>
      'ಕಾಲಾನಂತರ ತೂಕ, ಮತ್ತು ನೀವು ಎಷ್ಟು ಬಾರಿ ಬಂದಿದ್ದೀರಿ.';

  @override
  String get attendanceAppearsHere =>
      'ನೀವು ಜಿಮ್‌ನ ಸದಸ್ಯರಾದ ನಂತರ ಮತ್ತು ಸಿಬ್ಬಂದಿ ಹಾಜರಾತಿ ದಾಖಲಿಸಲು ಆರಂಭಿಸಿದ ನಂತರ ಇದು ಇಲ್ಲಿ ಕಾಣಿಸುತ್ತದೆ.';

  @override
  String get twoCheckInsDrawALine =>
      'ಎರಡು ದಾಖಲೆಗಳು ಒಂದು ಗೆರೆ ಎಳೆಯುತ್ತವೆ. ಪ್ರತಿ ತಿಂಗಳು ತೂಕ ಸೇರಿಸಿದರೆ ಇದು ತುಂಬುತ್ತದೆ.';

  @override
  String get nothingMatchesFilters => 'ಈ ಫಿಲ್ಟರ್‌ಗಳಿಗೆ ಏನೂ ಹೊಂದಿಕೆಯಾಗಲಿಲ್ಲ.';

  @override
  String get howToJoinGym =>
      'ಸೇರಲು ನೇರವಾಗಿ ಜಿಮ್ ಸಂಪರ್ಕಿಸಿ. ಅವರು ನಿಮ್ಮನ್ನು ಸದಸ್ಯರಾಗಿ ಸೇರಿಸುತ್ತಾರೆ.';

  @override
  String get weight => 'ತೂಕ';

  @override
  String get height => 'ಎತ್ತರ';

  @override
  String get yourMeasurements => 'ನಿಮ್ಮ ಅಳತೆಗಳು';

  @override
  String get checkInDue => 'ಈ ತಿಂಗಳ ಚೆಕ್-ಇನ್ ಬಾಕಿ ಇದೆ';

  @override
  String get thisMonth => 'ಈ ತಿಂಗಳು';

  @override
  String get perWeek => 'ವಾರಕ್ಕೆ';

  @override
  String get lastEightWeeks => 'ಕಳೆದ 8 ವಾರಗಳು';

  @override
  String get exerciseDirectory => 'ವ್ಯಾಯಾಮ ಪಟ್ಟಿ';

  @override
  String get exercises => 'ವ್ಯಾಯಾಮಗಳು';

  @override
  String get searchExercises => 'ವ್ಯಾಯಾಮ ಹುಡುಕಿ';

  @override
  String get clear => 'ಅಳಿಸಿ';

  @override
  String get howToDoIt => 'ಹೇಗೆ ಮಾಡಬೇಕು';

  @override
  String get watchOutFor => 'ಗಮನಿಸಿ';

  @override
  String get whatYouGet => 'ನಿಮಗೆ ಸಿಗುವುದು';

  @override
  String get removeYourEntry => 'ನಿಮ್ಮ ನೋಂದಣಿ ತೆಗೆಯುವುದೇ?';

  @override
  String get stayIn => 'ಇರಲಿ';

  @override
  String get removeMe => 'ನನ್ನನ್ನು ತೆಗೆಯಿರಿ';

  @override
  String get youAreInTapToWithdraw => 'ನೀವು ಸೇರಿದ್ದೀರಿ — ಹಿಂದೆ ಸರಿಯಲು ಒತ್ತಿ';

  @override
  String get participate => 'ಭಾಗವಹಿಸಿ';

  @override
  String takenOffList(String event) {
    return '$event ಪಟ್ಟಿಯಿಂದ ನಿಮ್ಮ ಹೆಸರು ತೆಗೆಯಲಾಗುತ್ತದೆ.';
  }

  @override
  String contactWithPhone(String phone) {
    return 'ಸಂಪರ್ಕಿಸಿ $phone';
  }

  @override
  String get reasonOptional => 'ಕಾರಣ (ಐಚ್ಛಿಕ)';

  @override
  String get searchByGymCityDistrict => 'ಜಿಮ್, ನಗರ ಅಥವಾ ಜಿಲ್ಲೆಯಿಂದ ಹುಡುಕಿ';

  @override
  String get useMyLocation => 'ಹತ್ತಿರದ ಜಿಮ್‌ಗಳನ್ನು ಹುಡುಕಲು ನನ್ನ ಸ್ಥಳವನ್ನು ಬಳಸಿ';

  @override
  String get findingNearbyGyms => 'ನಿಮ್ಮ ಹತ್ತಿರದ ಜಿಮ್‌ಗಳನ್ನು ಹುಡುಕಲಾಗುತ್ತಿದೆ…';

  @override
  String get locationUnavailable =>
      'ನಿಮ್ಮ ಸ್ಥಳ ಪಡೆಯಲಾಗಲಿಲ್ಲ — ಎಲ್ಲಾ ಜಿಮ್‌ಗಳನ್ನು ತೋರಿಸಲಾಗುತ್ತಿದೆ';

  @override
  String get exerciseDirectorySubtitle =>
      'ಶಕ್ತಿ, ಕಾರ್ಡಿಯೋ ಮತ್ತು ಯೋಗ, ಹಂತ ಹಂತದ ಸೂಚನೆಗಳೊಂದಿಗೆ';

  @override
  String get attendance => 'ಹಾಜರಾತಿ';

  @override
  String get manage => 'ನಿರ್ವಹಣೆ';

  @override
  String get choosePlan => 'ಯೋಜನೆ ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get seeGrowthOverTime => 'ಕಾಲಾನಂತರ ಬೆಳವಣಿಗೆ ನೋಡಿ';

  @override
  String lastNDays(int days) {
    return 'ಕಳೆದ $days ದಿನಗಳು';
  }

  @override
  String get addMember => 'ಸದಸ್ಯರನ್ನು ಸೇರಿಸಿ';

  @override
  String get addStaff => 'ಸಿಬ್ಬಂದಿ ಸೇರಿಸಿ';

  @override
  String get searchByNameOrNumber => 'ಹೆಸರು ಅಥವಾ ಸಂಖ್ಯೆಯಿಂದ ಹುಡುಕಿ';

  @override
  String get tapCircleToMarkPresent =>
      'ಹಾಜರಾತಿಗೆ ವೃತ್ತವನ್ನು ಒತ್ತಿ, ವಿವರಗಳಿಗೆ ಸಾಲನ್ನು';

  @override
  String markedPresent(String name) {
    return '$name ಹಾಜರು ಎಂದು ಗುರುತಿಸಲಾಗಿದೆ';
  }

  @override
  String get approve => 'ಅನುಮೋದಿಸಿ';

  @override
  String get role => 'ಪಾತ್ರ';

  @override
  String get theirName => 'ಅವರ ಹೆಸರು';

  @override
  String get theirMobileNumber => 'ಅವರ ಮೊಬೈಲ್ ಸಂಖ್ಯೆ';

  @override
  String get codeFromTheirPhone => 'ಅವರ ಫೋನ್ ಕೋಡ್';

  @override
  String get whatDoTheyWant => 'ಅವರಿಗೆ ಜಿಮ್‌ನಿಂದ ಏನು ಬೇಕು?';

  @override
  String get goalHint => 'ತೂಕ ಹೆಚ್ಚಿಸು, ಕಡಿಮೆ ಮಾಡು, ಪುನರ್ವಸತಿ…';

  @override
  String get saveChanges => 'ಬದಲಾವಣೆ ಉಳಿಸಿ';

  @override
  String get removeFromGym => 'ಜಿಮ್‌ನಿಂದ ತೆಗೆ';

  @override
  String get remove => 'ತೆಗೆ';

  @override
  String removePerson(String name) {
    return '$name ತೆಗೆಯುವುದೇ?';
  }

  @override
  String get onLeave => 'ರಜೆಯಲ್ಲಿ';

  @override
  String get tapDayToCorrect => 'ಸರಿಪಡಿಸಲು ದಿನವನ್ನು ಒತ್ತಿ';

  @override
  String correctDate(String date) {
    return '$date ಸರಿಪಡಿಸಿ';
  }

  @override
  String get whyIsThisChanging => 'ಇದು ಏಕೆ ಬದಲಾಗುತ್ತಿದೆ?';

  @override
  String get correctionReasonHint =>
      'ತಪ್ಪಾಗಿ ಗುರುತಿಸಲಾಗಿದೆ, ಯಂತ್ರ ಕೆಲಸ ಮಾಡಲಿಲ್ಲ…';

  @override
  String get saveCorrection => 'ತಿದ್ದುಪಡಿ ಉಳಿಸಿ';

  @override
  String get recordCorrected => 'ದಾಖಲೆ ಸರಿಪಡಿಸಲಾಗಿದೆ.';

  @override
  String get trainerCategories => 'ತರಬೇತುದಾರ ವರ್ಗಗಳು';

  @override
  String get newCategory => 'ಹೊಸ ವರ್ಗ';

  @override
  String get noTrainerCategoriesYet => 'ಇನ್ನೂ ತರಬೇತುದಾರ ವರ್ಗಗಳಿಲ್ಲ.';

  @override
  String get oneTrainerManyMembers =>
      'ಒಬ್ಬ ತರಬೇತುದಾರ ಹಲವು ಸದಸ್ಯರನ್ನು ಹೊಂದಬಹುದು';

  @override
  String get categoryNameHint => 'ಪುನರ್ವಸತಿ, ಶಕ್ತಿ, ಯೋಗ';

  @override
  String get edit => 'ಸಂಪಾದಿಸಿ';

  @override
  String get delete => 'ಅಳಿಸಿ';

  @override
  String get keepIt => 'ಇರಲಿ';

  @override
  String deleteNamed(String name) {
    return '$name ಅಳಿಸುವುದೇ?';
  }

  @override
  String get decline => 'ತಿರಸ್ಕರಿಸಿ';

  @override
  String decidedBy(String name) {
    return '$name ನಿರ್ಧರಿಸಿದರು';
  }

  @override
  String get createAGym => 'ಜಿಮ್ ರಚಿಸಿ';

  @override
  String get createYourGym => 'ನಿಮ್ಮ ಜಿಮ್ ರಚಿಸಿ';

  @override
  String get gymName => 'ಜಿಮ್ ಹೆಸರು';

  @override
  String get gymNameHint => 'ಐರನ್ ಟೆಂಪಲ್ ಫಿಟ್‌ನೆಸ್';

  @override
  String get descriptionOptional => 'ವಿವರಣೆ (ಐಚ್ಛಿಕ)';

  @override
  String get descriptionHint => 'ನಿಮ್ಮ ಜಿಮ್‌ಗೆ ಸೇರಲು ಏನು ವಿಶೇಷ?';

  @override
  String get address => 'ವಿಳಾಸ';

  @override
  String get city => 'ನಗರ';

  @override
  String get district => 'ಜಿಲ್ಲೆ';

  @override
  String get districtNote =>
      'ಹುಡುಕಾಟದಲ್ಲಿ ಜಿಮ್ ಹೆಸರಿನ ಪಕ್ಕ ಜಿಲ್ಲೆ ಕಾಣಿಸುತ್ತದೆ, ಇದರಿಂದ ಸದಸ್ಯರು ಗುರುತಿಸಬಹುದು.';

  @override
  String get state => 'ರಾಜ್ಯ';

  @override
  String get pinCode => 'ಪಿನ್ ಕೋಡ್';

  @override
  String get contactNumber => 'ಸಂಪರ್ಕ ಸಂಖ್ಯೆ';

  @override
  String get leavePolicyNote =>
      'ಸದಸ್ಯರು ತಿಂಗಳಲ್ಲಿ ಕೆಲವು ದಿನ ಸದಸ್ಯತ್ವ ನಿಲ್ಲಿಸಬಹುದು. ಅದಕ್ಕಿಂತ ಹೆಚ್ಚಾದರೆ ಅನುಮೋದನೆ ಬೇಕು.';

  @override
  String get perksLabel => 'ಸೌಲಭ್ಯಗಳು, ಅಲ್ಪವಿರಾಮದಿಂದ ಬೇರ್ಪಡಿಸಿ';

  @override
  String get perksHint => 'ಸ್ಟೀಮ್ ರೂಮ್, ಉಚಿತ ಪಾರ್ಕಿಂಗ್, ಪರ್ಸನಲ್ ಟ್ರೈನಿಂಗ್';

  @override
  String get createGym => 'ಜಿಮ್ ರಚಿಸಿ';

  @override
  String get deleteGym => 'ಜಿಮ್ ಅಳಿಸಿ';

  @override
  String get gymProfile => 'ಜಿಮ್ ಪ್ರೊಫೈಲ್';

  @override
  String get description => 'ವಿವರಣೆ';

  @override
  String get leavePolicy => 'ರಜೆ ನೀತಿ';

  @override
  String get leaveDaysPerMonth => 'ತಿಂಗಳಿಗೆ ರಜೆ ದಿನಗಳು';

  @override
  String get deleteThisGym => 'ಈ ಜಿಮ್ ಅಳಿಸಿ';

  @override
  String get leaveLimitNote =>
      'ಈ ಮಿತಿಯೊಳಗಿನ ಸದಸ್ಯರ ವಿನಂತಿಗಳು ಸ್ವಯಂಚಾಲಿತವಾಗಿ ಅನುಮೋದನೆಯಾಗುತ್ತವೆ. ಅದಕ್ಕಿಂತ ಹೆಚ್ಚಾದರೆ ಯಾರಾದರೂ ಅನುಮೋದಿಸಬೇಕು.';

  @override
  String get draftNote =>
      'ನಿಮ್ಮ ಜಿಮ್ ಕರಡಾಗಿ ಆರಂಭವಾಗುತ್ತದೆ. ಪರಿಶೀಲನೆ ಪೂರ್ಣಗೊಳಿಸಿ ಯೋಜನೆ ತೆಗೆದುಕೊಳ್ಳುವವರೆಗೆ ಹುಡುಕಾಟದಲ್ಲಿ ಕಾಣಿಸದು.';

  @override
  String get sendThis => 'ಇದನ್ನು ಕಳುಹಿಸುವುದೇ?';

  @override
  String get send => 'ಕಳುಹಿಸಿ';

  @override
  String get announcements => 'ಪ್ರಕಟಣೆಗಳು';

  @override
  String get title => 'ಶೀರ್ಷಿಕೆ';

  @override
  String get announceTitleHint => 'ನಿರ್ವಹಣೆಗಾಗಿ ಭಾನುವಾರ ಮುಚ್ಚಲಾಗಿದೆ';

  @override
  String get message => 'ಸಂದೇಶ';

  @override
  String get announceBodyHint =>
      'ಸೋಮವಾರ ಬೆಳಿಗ್ಗೆ 6 ಗಂಟೆಗೆ ಮತ್ತೆ ತೆರೆಯುತ್ತೇವೆ. ಕಡಿಮೆ ಸೂಚನೆಗೆ ಕ್ಷಮಿಸಿ.';

  @override
  String get whoSeesIt => 'ಯಾರು ನೋಡುತ್ತಾರೆ';

  @override
  String get everyone => 'ಎಲ್ಲರೂ';

  @override
  String get sendAnnouncement => 'ಪ್ರಕಟಣೆ ಕಳುಹಿಸಿ';

  @override
  String get sent => 'ಕಳುಹಿಸಲಾಗಿದೆ';

  @override
  String get newGym => 'ಹೊಸ ಜಿಮ್';

  @override
  String get draft => 'ಕರಡು';

  @override
  String get nothingToChartYet => 'ಇನ್ನೂ ತೋರಿಸಲು ಏನೂ ಇಲ್ಲ.';

  @override
  String peakValue(int value) {
    return 'ಗರಿಷ್ಠ $value';
  }

  @override
  String get searchRanking => 'ಹುಡುಕಾಟ ಶ್ರೇಯಾಂಕ';

  @override
  String get notInSearch => 'ಹುಡುಕಾಟದಲ್ಲಿ ಇಲ್ಲ';

  @override
  String get members => 'ಸದಸ್ಯರು';

  @override
  String get staff => 'ಸಿಬ್ಬಂದಿ';

  @override
  String get leave => 'ರಜೆ';

  @override
  String get roles => 'ಪಾತ್ರಗಳು';

  @override
  String get analytics => 'ವಿಶ್ಲೇಷಣೆ';

  @override
  String get growth => 'ಬೆಳವಣಿಗೆ';

  @override
  String get ranking => 'ಶ್ರೇಯಾಂಕ';

  @override
  String get plan => 'ಯೋಜನೆ';

  @override
  String get announce => 'ಪ್ರಕಟಣೆ';

  @override
  String get trainers => 'ತರಬೇತುದಾರರು';

  @override
  String get present => 'ಹಾಜರು';

  @override
  String get absent => 'ಗೈರುಹಾಜರು';

  @override
  String get markAttendance => 'ಹಾಜರಾತಿ ದಾಖಲಿಸಿ';

  @override
  String get getHelp => 'ಸಹಾಯ ಪಡೆಯಿರಿ';

  @override
  String get getHelpSubtitle => 'ನಮಗೆ ಸಂದೇಶ ಕಳುಹಿಸಿ, ನಾವು ಸಂಪರ್ಕಿಸುತ್ತೇವೆ';

  @override
  String get termsAndPrivacy => 'ನಿಯಮಗಳು ಮತ್ತು ಗೌಪ್ಯತೆ';

  @override
  String get signOut => 'ಸೈನ್ ಔಟ್';

  @override
  String get switchToStaff => 'ಮಾಲೀಕ/ಸಿಬ್ಬಂದಿ ಮೋಡ್‌ಗೆ ಬದಲಿಸಿ';

  @override
  String get switchToMember => 'ಸದಸ್ಯ ಮೋಡ್‌ಗೆ ಬದಲಿಸಿ';

  @override
  String get notifications => 'ಅಧಿಸೂಚನೆಗಳು';

  @override
  String get needsReview => 'ಅನುವಾದ ಪರಿಶೀಲನೆ ಬಾಕಿ';

  @override
  String get block => 'ನಿರ್ಬಂಧಿಸಿ';

  @override
  String get unblock => 'ನಿರ್ಬಂಧ ತೆಗೆಯಿರಿ';

  @override
  String get report => 'ವರದಿ ಮಾಡಿ';

  @override
  String blockPerson(String name) {
    return '$name ಅವರನ್ನು ನಿರ್ಬಂಧಿಸಿ';
  }

  @override
  String reportPerson(String name) {
    return '$name ಬಗ್ಗೆ ವರದಿ ಮಾಡಿ';
  }

  @override
  String get blockConfirmBody =>
      'ಅವರು ನಿಮಗೆ ಸಂದೇಶ ಕಳುಹಿಸಲಾಗುವುದಿಲ್ಲ, ಅವರ ಸಂದೇಶಗಳು ನಿಮಗೆ ಕಾಣಿಸುವುದಿಲ್ಲ. ನೀವು ನಿರ್ಬಂಧಿಸಿದ್ದನ್ನು ಅವರಿಗೆ ತಿಳಿಸಲಾಗುವುದಿಲ್ಲ. ಸೆಟ್ಟಿಂಗ್‌ಗಳಲ್ಲಿ ಇದನ್ನು ಬದಲಾಯಿಸಬಹುದು.';

  @override
  String get blocked => 'ನಿರ್ಬಂಧಿಸಲಾಗಿದೆ';

  @override
  String get blockedAccounts => 'ನಿರ್ಬಂಧಿಸಿದ ಖಾತೆಗಳು';

  @override
  String get noBlockedAccounts => 'ನೀವು ಯಾರನ್ನೂ ನಿರ್ಬಂಧಿಸಿಲ್ಲ.';

  @override
  String get safetyAndPrivacy => 'ಸುರಕ್ಷತೆ';

  @override
  String unblockQuestion(String name) {
    return '$name ಅವರ ನಿರ್ಬಂಧ ತೆಗೆಯಬೇಕೆ?';
  }

  @override
  String get unblockExplainer => 'ಅವರು ಮತ್ತೆ ನಿಮಗೆ ಸಂದೇಶ ಕಳುಹಿಸಬಹುದು.';

  @override
  String get whyReporting => 'ಸಮಸ್ಯೆ ಏನು?';

  @override
  String get reportDetails => 'ಏನಾಯಿತು?';

  @override
  String get reportDetailsHint =>
      'ಪರಿಶೀಲಕರು ಸಂದೇಶವನ್ನು ನೋಡುವುದಿಲ್ಲ. ಅವರು ಓದುವುದು ನಿಮ್ಮ ವಿವರಣೆಯನ್ನೇ, ಆದ್ದರಿಂದ ಏನು ಹೇಳಲಾಯಿತು ಎಂಬುದನ್ನು ನಿಮ್ಮ ಮಾತುಗಳಲ್ಲಿ ತಿಳಿಸಿ.';

  @override
  String get alsoBlockThem => 'ಅವರನ್ನು ನಿರ್ಬಂಧಿಸಿ ಕೂಡ';

  @override
  String get alsoBlockThemExplainer =>
      'ವರದಿಯನ್ನು ಒಬ್ಬ ವ್ಯಕ್ತಿ ಓದುತ್ತಾರೆ, ಅದಕ್ಕೆ ಸಮಯ ಬೇಕು. ನಿರ್ಬಂಧಿಸುವುದು ತಕ್ಷಣ ಕೆಲಸ ಮಾಡುತ್ತದೆ.';

  @override
  String get sendReport => 'ವರದಿ ಕಳುಹಿಸಿ';

  @override
  String get reportCategorySpam => 'ಸ್ಪ್ಯಾಮ್ ಅಥವಾ ಬೇಡದ ಮಾರಾಟ';

  @override
  String get reportCategoryHarassment => 'ಕಿರುಕುಳ ಅಥವಾ ಬೆದರಿಕೆ';

  @override
  String get reportCategorySexual => 'ಲೈಂಗಿಕ ಅಥವಾ ಅಶ್ಲೀಲ ವಿಷಯ';

  @override
  String get reportCategoryHate => 'ದ್ವೇಷ ಭಾಷಣ';

  @override
  String get reportCategoryViolence => 'ಹಿಂಸೆ ಅಥವಾ ಬೆದರಿಕೆ';

  @override
  String get reportCategoryScam => 'ವಂಚನೆ ಅಥವಾ ಮೋಸ';

  @override
  String get reportCategoryImpersonation => 'ಬೇರೊಬ್ಬರಂತೆ ನಟಿಸುವುದು';

  @override
  String get reportCategoryOther => 'ಬೇರೆ ಏನೋ';

  @override
  String get reportSent => 'ಧನ್ಯವಾದಗಳು. ಯಾರಾದರೂ ಇದನ್ನು ಪರಿಶೀಲಿಸುತ್ತಾರೆ.';

  @override
  String get myReports => 'ನಾನು ಕಳುಹಿಸಿದ ವರದಿಗಳು';

  @override
  String get reportStatusOpen => 'ಪರಿಶೀಲನೆಗೆ ಕಾಯುತ್ತಿದೆ';

  @override
  String get reportStatusReviewing => 'ಪರಿಶೀಲಿಸಲಾಗುತ್ತಿದೆ';

  @override
  String get reportStatusActioned => 'ಕ್ರಮ ಕೈಗೊಳ್ಳಲಾಗಿದೆ';

  @override
  String get reportStatusDismissed => 'ಪರಿಶೀಲಿಸಲಾಗಿದೆ, ಕ್ರಮವಿಲ್ಲ';

  @override
  String get noReportsSent => 'ನೀವು ಯಾರ ಬಗ್ಗೆಯೂ ವರದಿ ಮಾಡಿಲ್ಲ.';

  @override
  String get deleteAccount => 'ಖಾತೆ ಅಳಿಸಿ';

  @override
  String get deleteAccountIntro =>
      'ನಿಮ್ಮ ಖಾತೆ 30 ದಿನಗಳವರೆಗೆ ಬಳಸಬಹುದು. ನಂತರ ಅದು ಅಳಿಸಲ್ಪಡುತ್ತದೆ, ಮರಳಿ ಪಡೆಯಲಾಗುವುದಿಲ್ಲ.';

  @override
  String get whatIsDeleted => 'ಏನು ಅಳಿಸಲಾಗುತ್ತದೆ';

  @override
  String get whatIsDeletedList =>
      'ನಿಮ್ಮ ಹೆಸರು, ಸಂಖ್ಯೆ, ಇಮೇಲ್, ವಯಸ್ಸು. ನಿಮ್ಮ ಎತ್ತರ, ತೂಕ, ಪ್ರಗತಿ. ನಿಮ್ಮ ಚಾಟ್ ಸಂದೇಶಗಳು. ಗುರುತಿನ ದಾಖಲೆಗಳು ಮತ್ತು UPI ವಿವರಗಳು.';

  @override
  String get whatIsKept => 'ಏನು ಉಳಿಸಲಾಗುತ್ತದೆ, ನಿಮ್ಮ ಗುರುತು ತೆಗೆದು';

  @override
  String get whatIsKeptList =>
      'ಪಾವತಿ ಮತ್ತು ಸರಕುಪಟ್ಟಿ ದಾಖಲೆಗಳು, ಏಕೆಂದರೆ ಲೆಕ್ಕಪುಸ್ತಕ ಇಡುವುದು ಕಾನೂನು ಅಗತ್ಯ. ಜಿಮ್‌ನಲ್ಲಿ ನಡೆದ ಕ್ರಮಗಳ ದಾಖಲೆ, ವಿವಾದ ಬಗೆಹರಿಸಲು.';

  @override
  String get deleteGymsFirst =>
      'ನಿಮ್ಮ ಬಳಿ ಇನ್ನೂ ಒಂದು ಜಿಮ್ ಇದೆ. ಮೊದಲು ಅದನ್ನು ಅಳಿಸಿ — ನಿಮ್ಮ ಖಾತೆ ಅಳಿಸಿದರೆ ಅದರ ಪ್ರತಿ ಸದಸ್ಯ ಮತ್ತು ಸಿಬ್ಬಂದಿ ಪ್ರವೇಶ ಕಳೆದುಕೊಳ್ಳುತ್ತಾರೆ, ಮತ್ತು ಅದು ಮುಚ್ಚಲ್ಪಟ್ಟಿದೆ ಎಂದು ಅವರಿಗೆ ತಿಳಿಸಲಾಗುತ್ತದೆ.';

  @override
  String unwithdrawnWarning(String amount) {
    return 'ನೀವು ಹಿಂಪಡೆಯದ $amount ರೆಫರಲ್ ಗಳಿಕೆ ಇದೆ. ಮೊದಲು Gymologia Referral ಆ್ಯಪ್‌ನಲ್ಲಿ ಹಿಂಪಡೆಯಿರಿ, ಇಲ್ಲದಿದ್ದರೆ ಅದು ಕಳೆದುಹೋಗುತ್ತದೆ.';
  }

  @override
  String get iUnderstandLoseEarnings =>
      'ಈ ಹಣ ಕಳೆದುಹೋಗುತ್ತದೆ ಎಂದು ನಾನು ಅರ್ಥಮಾಡಿಕೊಂಡಿದ್ದೇನೆ';

  @override
  String deletionScheduled(String date) {
    return 'ನಿಮ್ಮ ಖಾತೆಯನ್ನು $date ರಂದು ಅಳಿಸಲಾಗುತ್ತದೆ.';
  }

  @override
  String get keepMyAccount => 'ನನ್ನ ಖಾತೆ ಉಳಿಸಿ';

  @override
  String get deletionCancelled => 'ನಿಮ್ಮ ಖಾತೆ ಅಳಿಸಲಾಗುವುದಿಲ್ಲ.';

  @override
  String get deleteAccountConfirm => 'ನನ್ನ ಖಾತೆ ಅಳಿಸಿ';
}
