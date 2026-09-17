// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kannada (`kn`).
class AppLocalizationsKn extends AppLocalizations {
  AppLocalizationsKn([String locale = 'kn']) : super(locale);

  @override
  String get appTitle => 'Gymologia Referral';

  @override
  String get tryAgain => 'ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ';

  @override
  String get cancel => 'ರದ್ದುಮಾಡಿ';

  @override
  String get save => 'ಉಳಿಸಿ';

  @override
  String get add => 'ಸೇರಿಸಿ';

  @override
  String get change => 'ಬದಲಾಯಿಸಿ';

  @override
  String get genericError => 'ಏನೋ ತಪ್ಪಾಗಿದೆ. ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String cleartextWarning(String host) {
    return '$host ಗೆ ಸುರಕ್ಷತೆ ಇಲ್ಲದೆ (plain http) ಸಂಪರ್ಕಗೊಂಡಿದೆ';
  }

  @override
  String get signInSubtitle =>
      'ಕೋಡ್ ಹಂಚಿಕೊಳ್ಳಿ. ಯಾವುದೇ ಜಿಮ್ ಚಂದಾದಾರಿಕೆ ಪಡೆದರೆ ನಿಮಗೆ ಗಳಿಕೆ.';

  @override
  String get phoneLabel => 'ಮೊಬೈಲ್ ಸಂಖ್ಯೆ';

  @override
  String get phoneHint => '10 ಅಂಕಿಗಳ ಮೊಬೈಲ್ ಸಂಖ್ಯೆ';

  @override
  String get sendCode => 'ಕೋಡ್ ಕಳುಹಿಸಿ';

  @override
  String codeSentTo(String phone) {
    return '$phone ಗೆ ಕೋಡ್ ಕಳುಹಿಸಲಾಗಿದೆ';
  }

  @override
  String get verify => 'ಪರಿಶೀಲಿಸಿ';

  @override
  String resendIn(int seconds) {
    return '$seconds ಸೆಕೆಂಡುಗಳ ನಂತರ ಇನ್ನೊಂದು ಕೋಡ್ ಕೇಳಬಹುದು';
  }

  @override
  String get resend => 'ಇನ್ನೊಂದು ಕೋಡ್ ಕಳುಹಿಸಿ';

  @override
  String get changeNumber => 'ಬೇರೆ ಸಂಖ್ಯೆ ಬಳಸಿ';

  @override
  String get enterTenDigits => 'ನಿಮ್ಮ 10 ಅಂಕಿಗಳ ಮೊಬೈಲ್ ಸಂಖ್ಯೆ ನಮೂದಿಸಿ.';

  @override
  String get enterTheCode => 'ನಾವು ಕಳುಹಿಸಿದ ಕೋಡ್ ನಮೂದಿಸಿ.';

  @override
  String get ownersCannotJoin =>
      'ಜಿಮ್ ಮಾಲೀಕರು ರೆಫರಲ್ ಆ್ಯಪ್ ಬಳಸಲಾಗುವುದಿಲ್ಲ. ಜಿಮ್ ಸಿಬ್ಬಂದಿ ಮತ್ತು ಉಳಿದ ಎಲ್ಲರೂ ಬಳಸಬಹುದು.';

  @override
  String get createAccountTitle => 'ನಿಮ್ಮ ಖಾತೆ ರಚಿಸಿ';

  @override
  String get nameLabel => 'ಹೆಸರು';

  @override
  String get emailLabel => 'ಇಮೇಲ್ (ಐಚ್ಛಿಕ)';

  @override
  String get ageLabel => 'ವಯಸ್ಸು';

  @override
  String get ageWhy =>
      'ನಾವು ವಯಸ್ಸನ್ನು ಮಾತ್ರ ಕೇಳುತ್ತೇವೆ, ಜನ್ಮ ದಿನಾಂಕವನ್ನು ಎಂದಿಗೂ ಅಲ್ಲ. ಜನ್ಮ ದಿನಾಂಕ ನಿಮ್ಮ ಬ್ಯಾಂಕ್ ಮತ್ತು ಸರ್ಕಾರಿ ದಾಖಲೆಗಳ ಕೀಲಿ; ವಯಸ್ಸು ಅಲ್ಲ.';

  @override
  String get ageRange => '13 ರಿಂದ 100 ರ ನಡುವಿನ ವಯಸ್ಸು ನಮೂದಿಸಿ.';

  @override
  String get nameRequired => 'ದಯವಿಟ್ಟು ನಿಮ್ಮ ಹೆಸರು ನಮೂದಿಸಿ.';

  @override
  String get createAccount => 'ಖಾತೆ ರಚಿಸಿ';

  @override
  String get tabCode => 'ನಿಮ್ಮ ಕೋಡ್';

  @override
  String get tabEarnings => 'ಗಳಿಕೆ';

  @override
  String get tabPayout => 'ಪಾವತಿ';

  @override
  String get tabSettings => 'ಸೆಟ್ಟಿಂಗ್‌ಗಳು';

  @override
  String get yourCodeTitle => 'ನಿಮ್ಮ ರೆಫರಲ್ ಕೋಡ್';

  @override
  String get shareCode => 'ಹಂಚಿಕೊಳ್ಳಿ';

  @override
  String get copyCode => 'ನಕಲಿಸಿ';

  @override
  String get copied => 'ನಕಲಿಸಲಾಗಿದೆ.';

  @override
  String get shareUnavailable =>
      'ಇಲ್ಲಿ ಹಂಚಿಕೊಳ್ಳಲು ಸಾಧ್ಯವಿಲ್ಲ. ಸಂದೇಶವನ್ನು ನಕಲಿಸಲಾಗಿದೆ.';

  @override
  String get howItWorksTitle => 'ಇದು ಹೇಗೆ ಕೆಲಸ ಮಾಡುತ್ತದೆ';

  @override
  String get howItWorksStep1 => 'ಜಿಮ್ ನಡೆಸುವವರಿಗೆ ನಿಮ್ಮ ಕೋಡ್ ಕಳುಹಿಸಿ.';

  @override
  String howItWorksStep2(int percent) {
    return 'ಚಂದಾದಾರಿಕೆ ಪಡೆಯುವಾಗ ಯಾವುದೇ Gymologia ಯೋಜನೆಯಲ್ಲಿ ಅವರಿಗೆ $percent% ರಿಯಾಯಿತಿ ಸಿಗುತ್ತದೆ.';
  }

  @override
  String howItWorksStep3(String amount) {
    return 'ಈ ಕೋಡ್‌ನಿಂದ ಚಂದಾದಾರಿಕೆ ಪಡೆಯುವ ಪ್ರತಿ ಜಿಮ್‌ಗೆ ನಿಮಗೆ $amount ಸಿಗುತ್ತದೆ.';
  }

  @override
  String howItWorksStep4(String amount) {
    return 'ನಿಮ್ಮ UPI ID ನಿಜವಾಗಿಯೂ ನಿಮ್ಮದೇ ಎಂದು ಪರಿಶೀಲಿಸಲು ಮೊದಲ ಪಾವತಿಯಿಂದ ಒಮ್ಮೆ $amount ಕಡಿತಗೊಳಿಸಲಾಗುತ್ತದೆ.';
  }

  @override
  String get notForOwners => 'ನಿಮ್ಮದೇ ಜಿಮ್‌ನಿಂದ ನೀವು ಗಳಿಸಲಾಗುವುದಿಲ್ಲ.';

  @override
  String get earnedTotal => 'ಇಲ್ಲಿಯವರೆಗೆ ಗಳಿಸಿದ್ದು';

  @override
  String get heldPending => 'ತಡೆಹಿಡಿದದ್ದು';

  @override
  String get paidOut => 'ಪಾವತಿಸಿದ್ದು';

  @override
  String get taxWithheld => 'ಕಡಿತಗೊಳಿಸಿದ ತೆರಿಗೆ';

  @override
  String get neverUsed => 'ಇಲ್ಲಿಯವರೆಗೆ ಯಾರೂ ನಿಮ್ಮ ಕೋಡ್ ಬಳಸಿಲ್ಲ.';

  @override
  String timesUsed(int count) {
    return '$count ಬಾರಿ ಬಳಸಲಾಗಿದೆ.';
  }

  @override
  String get usedOnce => 'ಒಮ್ಮೆ ಬಳಸಲಾಗಿದೆ.';

  @override
  String awaitingClearance(int count) {
    return '$count ಇನ್ನೂ ಕ್ಲಿಯರ್ ಆಗುತ್ತಿವೆ.';
  }

  @override
  String get earningsTitle => 'ನಿಮ್ಮ ಕೋಡ್ ಗಳಿಸಿದ್ದು';

  @override
  String get earningsEmpty =>
      'ಇನ್ನೂ ಏನೂ ಇಲ್ಲ. ಜಿಮ್ ನಡೆಸುವವರೊಂದಿಗೆ ನಿಮ್ಮ ಕೋಡ್ ಹಂಚಿಕೊಳ್ಳಿ.';

  @override
  String earningsCapped(int count) {
    return 'ಇತ್ತೀಚಿನ $count ತೋರಿಸಲಾಗುತ್ತಿದೆ.';
  }

  @override
  String get statusPending => 'ಕ್ಲಿಯರ್ ಆಗುತ್ತಿದೆ';

  @override
  String get statusEligible => 'ಪಾವತಿಗೆ ಸಿದ್ಧ';

  @override
  String get statusPaid => 'ಪಾವತಿಸಲಾಗಿದೆ';

  @override
  String get statusReversed => 'ಹಿಂಪಡೆಯಲಾಗಿದೆ';

  @override
  String get statusPendingWhy =>
      'ಜಿಮ್‌ನ ಮರುಪಾವತಿ ಅವಧಿ ಮುಗಿಯುವವರೆಗೆ ತಡೆಹಿಡಿಯಲಾಗಿದೆ.';

  @override
  String get statusEligibleWhy =>
      'ಕ್ಲಿಯರ್ ಆಗಿದೆ. ಪಾವತಿಗಳು ಆರಂಭವಾಗುವುದನ್ನು ಕಾಯುತ್ತಿದೆ.';

  @override
  String get statusPaidWhy => 'ನಿಮ್ಮ UPI ID ಗೆ ಕಳುಹಿಸಲಾಗಿದೆ.';

  @override
  String get statusReversedWhy =>
      'ಜಿಮ್‌ನ ಪಾವತಿ ಮರಳಿದ ಕಾರಣ ಈ ಬಹುಮಾನವನ್ನೂ ಹಿಂಪಡೆಯಲಾಗಿದೆ.';

  @override
  String get payoutTitle => 'ನಿಮ್ಮ ಹಣ ಎಲ್ಲಿಗೆ ಹೋಗುತ್ತದೆ';

  @override
  String get withdrawTitle => 'ಹಣ ಹಿಂಪಡೆಯಿರಿ';

  @override
  String get withdrawAvailable => 'ಹಿಂಪಡೆಯಲು ಸಿದ್ಧ';

  @override
  String get withdrawFee => 'ಒಂದು ಬಾರಿಯ UPI ಪರಿಶೀಲನೆ';

  @override
  String get withdrawArrives => 'ನಿಮಗೆ ಸಿಗುವುದು';

  @override
  String withdrawButton(String amount) {
    return '$amount ಹಿಂಪಡೆಯಿರಿ';
  }

  @override
  String withdrawConfirm(String amount, String upi) {
    return '$upi ಗೆ $amount ಕಳುಹಿಸಬೇಕೇ?';
  }

  @override
  String get withdrawConfirmBody =>
      'ಇದನ್ನು ಹಿಂತಿರುಗಿಸಲಾಗದು. ಕಳುಹಿಸುವ ಮೊದಲು ವಿಳಾಸ ಸರಿಯಿದೆಯೇ ಎಂದು ನೋಡಿ.';

  @override
  String get withdrawRequested => 'ಕೋರಲಾಗಿದೆ. ಹಣ ದಾರಿಯಲ್ಲಿದೆ.';

  @override
  String withdrawFeeWhy(String amount) {
    return 'ವಿಳಾಸ ನಿಜವಾಗಿಯೂ ನಿಮ್ಮದೇ ಎಂದು ಪರಿಶೀಲಿಸಲು ಒಮ್ಮೆ $amount ಕಡಿತಗೊಳಿಸಲಾಗುತ್ತದೆ. ನಂತರ ಏನೂ ಕಡಿತವಾಗುವುದಿಲ್ಲ.';
  }

  @override
  String get withdrawNoTax => 'ಈ ಮೊತ್ತಗಳಿಗೆ ಯಾವುದೇ ತೆರಿಗೆ ಕಡಿತಗೊಳಿಸುವುದಿಲ್ಲ.';

  @override
  String get withdrawHistoryTitle => 'ಹಿಂಪಡೆದವು';

  @override
  String get withdrawNone => 'ನೀವು ಇನ್ನೂ ಏನನ್ನೂ ಹಿಂಪಡೆದಿಲ್ಲ.';

  @override
  String get withdrawStatusQueued => 'ಸರತಿಯಲ್ಲಿ';

  @override
  String get withdrawStatusProcessing => 'ಕಳುಹಿಸಲಾಗುತ್ತಿದೆ';

  @override
  String get withdrawStatusSuccess => 'ಕಳುಹಿಸಲಾಗಿದೆ';

  @override
  String get withdrawStatusFailed => 'ವಿಫಲವಾಗಿದೆ';

  @override
  String get withdrawStatusReversed => 'ಹಿಂತಿರುಗಿದೆ';

  @override
  String withdrawUtr(String utr) {
    return 'ಉಲ್ಲೇಖ $utr';
  }

  @override
  String get payoutsNotLive =>
      'ಪಾವತಿಗಳು ಇನ್ನೂ ಆರಂಭವಾಗಿಲ್ಲ. ಅಲ್ಲಿಯವರೆಗೆ ಗಳಿಕೆಯನ್ನು ಎಣಿಸಿ ತಡೆಹಿಡಿಯಲಾಗುತ್ತದೆ.';

  @override
  String get stillNeededTitle => 'ಇನ್ನೂ ಬೇಕಾಗಿರುವುದು';

  @override
  String get payoutInFlight =>
      'ಒಂದು ಪಾವತಿ ದಾರಿಯಲ್ಲಿದೆ. ಅದು ಪೂರ್ಣಗೊಂಡ ಮೇಲೆ ಇವನ್ನು ಬದಲಾಯಿಸಬಹುದು.';

  @override
  String get upiSectionTitle => 'UPI ID';

  @override
  String get upiIdLabel => 'UPI ID';

  @override
  String get upiIdHint => 'name@bank';

  @override
  String get holderNameLabel => 'ಖಾತೆಯಲ್ಲಿರುವ ಹೆಸರು';

  @override
  String get upiNotSet => 'ಹೊಂದಿಸಿಲ್ಲ';

  @override
  String get upiVerifiedYes => 'ಪರಿಶೀಲಿಸಲಾಗಿದೆ';

  @override
  String get upiVerifiedNo => 'ಇನ್ನೂ ಪರಿಶೀಲಿಸಿಲ್ಲ';

  @override
  String get upiTypoWarning =>
      'ಇದನ್ನು ಅಕ್ಷರಶಃ ಪರಿಶೀಲಿಸಿ. UPI ID ಗೆ ಕಾಗುಣಿತ ಪರಿಶೀಲನೆ ಇಲ್ಲ: ಒಂದೇ ಅಕ್ಷರದ ತಪ್ಪು ಬೇರೊಬ್ಬರ ಸಂಪೂರ್ಣ ಸರಿಯಾದ ವಿಳಾಸವಾಗುತ್ತದೆ, ಮತ್ತು ಅಲ್ಲಿಗೆ ಕಳುಹಿಸಿದ ಹಣ ಹಿಂತಿರುಗುವುದಿಲ್ಲ.';

  @override
  String get upiChangedClearsVerification =>
      'ಇದನ್ನು ಬದಲಾಯಿಸಿದರೆ ಪರಿಶೀಲನೆ ರದ್ದಾಗುತ್ತದೆ. ಮೊದಲ ಪಾವತಿಗೆ ಮೊದಲು ವಿಳಾಸವನ್ನು ಮತ್ತೆ ಪರಿಶೀಲಿಸಲಾಗುತ್ತದೆ.';

  @override
  String get holderNameWhy =>
      '₹10 ರ ಪರಿಶೀಲನೆಯಲ್ಲಿ ಆ ಖಾತೆಗೆ ನಿಮ್ಮ ಬ್ಯಾಂಕಿನಲ್ಲಿ ದಾಖಲಾದ ಹೆಸರು ಮರಳಿ ಬರುತ್ತದೆ. ಹೋಲಿಸಲು ಹೆಸರಿಲ್ಲದಿದ್ದರೆ, ವಿಳಾಸ ಇದೆ ಎಂದಷ್ಟೇ ಅದು ಸಾಬೀತುಪಡಿಸುತ್ತದೆ — ಅದು ನಿಮ್ಮದೆಂದು ಅಲ್ಲ.';

  @override
  String get saved => 'ಉಳಿಸಲಾಗಿದೆ.';

  @override
  String get invalidUpi =>
      'ಇದು UPI ID ಯಂತೆ ಕಾಣುತ್ತಿಲ್ಲ. ಇದು name@bank ನಂತೆ ಇರಬೇಕು.';

  @override
  String get holderNameRequired => 'ಬ್ಯಾಂಕ್ ಖಾತೆಯಲ್ಲಿರುವ ಹೆಸರು ನಮೂದಿಸಿ.';

  @override
  String get panSectionTitle => 'PAN';

  @override
  String get panLabel => 'PAN';

  @override
  String get panHint => 'ABCDE1234F';

  @override
  String get panNotSet => 'ಹೊಂದಿಸಿಲ್ಲ';

  @override
  String get panWhy =>
      'ತೆರಿಗೆ ಕಡಿತಗೊಳಿಸಬೇಕಾದ ಮಟ್ಟಕ್ಕೆ ನಿಮ್ಮ ಗಳಿಕೆ ತಲುಪುವ ಮೊದಲು ಇದು ಬೇಕು. ಆರಂಭಿಸಲು ಬೇಕಾಗಿಲ್ಲ.';

  @override
  String get panStatusPending => 'ಸ್ವೀಕರಿಸಲಾಗಿದೆ, ಇನ್ನೂ ಪರಿಶೀಲಿಸಿಲ್ಲ';

  @override
  String get panStatusVerified => 'ಪರಿಶೀಲಿಸಲಾಗಿದೆ';

  @override
  String get panStatusRejected =>
      'ಸ್ವೀಕರಿಸಲಾಗಿಲ್ಲ. ಸಂಖ್ಯೆ ಪರಿಶೀಲಿಸಿ ಮತ್ತೆ ಕಳುಹಿಸಿ.';

  @override
  String get invalidPan =>
      'ಇದು PAN ನಂತೆ ಕಾಣುತ್ತಿಲ್ಲ. ಇದು ABCDE1234F ನಂತೆ ಇರಬೇಕು.';

  @override
  String get settingsTitle => 'ಸೆಟ್ಟಿಂಗ್‌ಗಳು';

  @override
  String get profileTitle => 'ನಿಮ್ಮ ಪ್ರೊಫೈಲ್';

  @override
  String get languageTitle => 'ಭಾಷೆ';

  @override
  String get languageSubtitle => 'ನೀವು ಅತ್ಯಂತ ಸುಲಭವಾಗಿ ಓದುವ ಭಾಷೆಯನ್ನು ಆರಿಸಿ';

  @override
  String get useDeviceLanguage => 'ಸಾಧನದ ಭಾಷೆ ಬಳಸಿ';

  @override
  String get needsReview => 'ಅನುವಾದ ಪರಿಶೀಲನೆಗೆ ಬಾಕಿ ಇದೆ';

  @override
  String get untranslatedFallbackNote =>
      'ಇನ್ನೂ ಅನುವಾದವಾಗದಿರುವುದನ್ನು ಖಾಲಿ ಬಿಡುವ ಬದಲು ಇಂಗ್ಲಿಷ್‌ನಲ್ಲಿ ತೋರಿಸಲಾಗುತ್ತದೆ, ಹಾಗಾಗಿ ಭಾಗಶಃ ಅನುವಾದಗೊಂಡ ಭಾಷೆಯೂ ಬಳಸಬಹುದಾಗಿದೆ.';

  @override
  String get legalTitle => 'ನಿಯಮಗಳು ಮತ್ತು ಗೌಪ್ಯತೆ';

  @override
  String get legalUnavailable => 'ಇದನ್ನು ಈಗ ಲೋಡ್ ಮಾಡಲಾಗಲಿಲ್ಲ.';

  @override
  String get supportTitle => 'ಸಹಾಯ ಬೇಕೇ?';

  @override
  String get supportBody =>
      'ಏನಾಯಿತು ಎಂದು ತಿಳಿಸಿ, ನಾವು ನಿಮ್ಮನ್ನು ಸಂಪರ್ಕಿಸುತ್ತೇವೆ.';

  @override
  String get supportSubject => 'ವಿಷಯ';

  @override
  String get supportMessage => 'ಏನಾಯಿತು?';

  @override
  String get supportSend => 'ಕಳುಹಿಸಿ';

  @override
  String get supportSent => 'ಕಳುಹಿಸಲಾಗಿದೆ. ನಾವು ನಿಮ್ಮನ್ನು ಸಂಪರ್ಕಿಸುತ್ತೇವೆ.';

  @override
  String supportEmailLine(String email) {
    return 'ಅಥವಾ $email ಗೆ ಬರೆಯಿರಿ.';
  }

  @override
  String get supportTooShort =>
      'ಒಂದೆರಡು ವಾಕ್ಯ ಬರೆಯಿರಿ, ಏನನ್ನು ನೋಡಬೇಕೆಂದು ನಮಗೆ ತಿಳಿಯುತ್ತದೆ.';

  @override
  String get signOut => 'ಸೈನ್ ಔಟ್';

  @override
  String get signOutConfirm => 'ಈ ಸಾಧನದಲ್ಲಿ ಸೈನ್ ಔಟ್ ಮಾಡಬೇಕೇ?';

  @override
  String get aboutTitle => 'ಕುರಿತು';

  @override
  String get sessionExpiredSignIn =>
      'ನಿಮ್ಮ ಸೆಷನ್ ಮುಗಿದಿದೆ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಸೈನ್ ಇನ್ ಮಾಡಿ.';

  @override
  String get serverTookTooLong =>
      'ಸರ್ವರ್ ಉತ್ತರಿಸಲು ಬಹಳ ಸಮಯ ತೆಗೆದುಕೊಂಡಿತು. ಸಂಪರ್ಕ ಪರಿಶೀಲಿಸಿ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String couldNotReachServer(String host) {
    return '$host ತಲುಪಲಾಗಲಿಲ್ಲ. ನಿಮ್ಮ ಇಂಟರ್ನೆಟ್ ಸಂಪರ್ಕ ಪರಿಶೀಲಿಸಿ.';
  }

  @override
  String get certificateNotVerified =>
      'ಸರ್ವರ್ ಪ್ರಮಾಣಪತ್ರವನ್ನು ಪರಿಶೀಲಿಸಲಾಗಲಿಲ್ಲ.';

  @override
  String get networkErrorTryAgain => 'ನೆಟ್‌ವರ್ಕ್ ದೋಷ. ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get footerLine => 'Gymologia Referral';

  @override
  String get footerSupport => 'support@gymologia.com';

  @override
  String get deleteAccount => 'ಖಾತೆ ಅಳಿಸಿ';

  @override
  String get deleteAccountIntro =>
      'ನಿಮ್ಮ ಖಾತೆ 30 ದಿನಗಳವರೆಗೆ ಬಳಸಬಹುದು. ನಂತರ ಅದು ಅಳಿಸಲ್ಪಡುತ್ತದೆ, ಮರಳಿ ಪಡೆಯಲಾಗುವುದಿಲ್ಲ.';

  @override
  String get whatIsDeleted => 'ಏನು ಅಳಿಸಲಾಗುತ್ತದೆ';

  @override
  String get whatIsDeletedList =>
      'ನಿಮ್ಮ ಹೆಸರು, ಸಂಖ್ಯೆ ಮತ್ತು ಇಮೇಲ್. ನಿಮ್ಮ UPI ವಿವರಗಳು ಮತ್ತು PAN. ನಿಮ್ಮ ರೆಫರಲ್ ಕೋಡ್ ಮತ್ತು ಗಳಿಕೆಯ ಇತಿಹಾಸ. ಇದು ಒಂದೇ Gymologia ಖಾತೆ — ನೀವು Gymologia ಆ್ಯಪ್ ಕೂಡ ಬಳಸಿದರೆ, ಅಲ್ಲಿನ ಎಲ್ಲವೂ ಹೋಗುತ್ತದೆ.';

  @override
  String get whatIsKept => 'ಏನು ಉಳಿಸಲಾಗುತ್ತದೆ, ನಿಮ್ಮ ಗುರುತು ತೆಗೆದು';

  @override
  String get whatIsKeptList =>
      'ಪಾವತಿ ಮತ್ತು ಸರಕುಪಟ್ಟಿ ದಾಖಲೆಗಳು, ಏಕೆಂದರೆ ಲೆಕ್ಕಪುಸ್ತಕ ಇಡುವುದು ಕಾನೂನು ಅಗತ್ಯ. ಜಿಮ್‌ನಲ್ಲಿ ನಡೆದ ಕ್ರಮಗಳ ದಾಖಲೆ, ವಿವಾದ ಬಗೆಹರಿಸಲು.';

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
