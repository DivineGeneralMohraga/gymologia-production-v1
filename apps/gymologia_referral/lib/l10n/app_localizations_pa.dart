// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Panjabi Punjabi (`pa`).
class AppLocalizationsPa extends AppLocalizations {
  AppLocalizationsPa([String locale = 'pa']) : super(locale);

  @override
  String get appTitle => 'Gymologia Referral';

  @override
  String get tryAgain => 'ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ';

  @override
  String get cancel => 'ਰੱਦ ਕਰੋ';

  @override
  String get save => 'ਸੇਵ ਕਰੋ';

  @override
  String get add => 'ਜੋੜੋ';

  @override
  String get change => 'ਬਦਲੋ';

  @override
  String get genericError => 'ਕੁਝ ਗਲਤ ਹੋ ਗਿਆ। ਕਿਰਪਾ ਕਰਕੇ ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ।';

  @override
  String cleartextWarning(String host) {
    return '$host ਨਾਲ ਬਿਨਾਂ ਸੁਰੱਖਿਆ ਦੇ (plain http) ਜੁੜਿਆ ਹੋਇਆ ਹੈ';
  }

  @override
  String get signInSubtitle =>
      'ਕੋਡ ਸਾਂਝਾ ਕਰੋ। ਜਦੋਂ ਕੋਈ ਜਿਮ ਸਬਸਕ੍ਰਿਪਸ਼ਨ ਲਵੇਗਾ, ਤੁਹਾਡੀ ਕਮਾਈ ਹੋਵੇਗੀ।';

  @override
  String get phoneLabel => 'ਮੋਬਾਈਲ ਨੰਬਰ';

  @override
  String get phoneHint => '10 ਅੰਕਾਂ ਦਾ ਮੋਬਾਈਲ ਨੰਬਰ';

  @override
  String get sendCode => 'ਕੋਡ ਭੇਜੋ';

  @override
  String codeSentTo(String phone) {
    return '$phone ਉੱਤੇ ਕੋਡ ਭੇਜਿਆ ਗਿਆ';
  }

  @override
  String get verify => 'ਤਸਦੀਕ ਕਰੋ';

  @override
  String resendIn(int seconds) {
    return '$seconds ਸਕਿੰਟਾਂ ਬਾਅਦ ਤੁਸੀਂ ਹੋਰ ਕੋਡ ਮੰਗ ਸਕਦੇ ਹੋ';
  }

  @override
  String get resend => 'ਹੋਰ ਕੋਡ ਭੇਜੋ';

  @override
  String get changeNumber => 'ਵੱਖਰਾ ਨੰਬਰ ਵਰਤੋ';

  @override
  String get enterTenDigits => 'ਆਪਣਾ 10 ਅੰਕਾਂ ਦਾ ਮੋਬਾਈਲ ਨੰਬਰ ਪਾਓ।';

  @override
  String get enterTheCode => 'ਅਸੀਂ ਜੋ ਕੋਡ ਭੇਜਿਆ ਹੈ ਉਹ ਪਾਓ।';

  @override
  String get ownersCannotJoin =>
      'ਜਿਮ ਮਾਲਕ ਰੈਫਰਲ ਐਪ ਨਹੀਂ ਵਰਤ ਸਕਦੇ। ਜਿਮ ਸਟਾਫ਼ ਅਤੇ ਬਾਕੀ ਸਾਰੇ ਵਰਤ ਸਕਦੇ ਹਨ।';

  @override
  String get createAccountTitle => 'ਆਪਣਾ ਖਾਤਾ ਬਣਾਓ';

  @override
  String get nameLabel => 'ਨਾਮ';

  @override
  String get emailLabel => 'ਈਮੇਲ (ਵਿਕਲਪਿਕ)';

  @override
  String get ageLabel => 'ਉਮਰ';

  @override
  String get ageWhy =>
      'ਅਸੀਂ ਸਿਰਫ਼ ਉਮਰ ਪੁੱਛਦੇ ਹਾਂ, ਜਨਮ ਤਾਰੀਖ਼ ਕਦੇ ਨਹੀਂ। ਜਨਮ ਤਾਰੀਖ਼ ਤੁਹਾਡੇ ਬੈਂਕ ਅਤੇ ਸਰਕਾਰੀ ਦਸਤਾਵੇਜ਼ਾਂ ਦੀ ਚਾਬੀ ਹੈ; ਉਮਰ ਨਹੀਂ।';

  @override
  String get ageRange => '13 ਤੋਂ 100 ਵਿਚਕਾਰ ਉਮਰ ਪਾਓ।';

  @override
  String get nameRequired => 'ਕਿਰਪਾ ਕਰਕੇ ਆਪਣਾ ਨਾਮ ਪਾਓ।';

  @override
  String get createAccount => 'ਖਾਤਾ ਬਣਾਓ';

  @override
  String get tabCode => 'ਤੁਹਾਡਾ ਕੋਡ';

  @override
  String get tabEarnings => 'ਕਮਾਈ';

  @override
  String get tabPayout => 'ਭੁਗਤਾਨ';

  @override
  String get tabSettings => 'ਸੈਟਿੰਗਾਂ';

  @override
  String get yourCodeTitle => 'ਤੁਹਾਡਾ ਰੈਫਰਲ ਕੋਡ';

  @override
  String get shareCode => 'ਸਾਂਝਾ ਕਰੋ';

  @override
  String get copyCode => 'ਕਾਪੀ ਕਰੋ';

  @override
  String get copied => 'ਕਾਪੀ ਹੋ ਗਿਆ।';

  @override
  String get shareUnavailable =>
      'ਇੱਥੇ ਸਾਂਝਾ ਨਹੀਂ ਕੀਤਾ ਜਾ ਸਕਦਾ। ਸੁਨੇਹਾ ਕਾਪੀ ਕਰ ਦਿੱਤਾ ਗਿਆ ਹੈ।';

  @override
  String get howItWorksTitle => 'ਇਹ ਕਿਵੇਂ ਕੰਮ ਕਰਦਾ ਹੈ';

  @override
  String get howItWorksStep1 => 'ਜਿਮ ਚਲਾਉਣ ਵਾਲੇ ਕਿਸੇ ਨੂੰ ਆਪਣਾ ਕੋਡ ਭੇਜੋ।';

  @override
  String howItWorksStep2(int percent) {
    return 'ਸਬਸਕ੍ਰਿਪਸ਼ਨ ਲੈਂਦੇ ਸਮੇਂ ਉਹਨਾਂ ਨੂੰ ਕਿਸੇ ਵੀ Gymologia ਪਲਾਨ ਉੱਤੇ $percent% ਛੋਟ ਮਿਲੇਗੀ।';
  }

  @override
  String howItWorksStep3(String amount) {
    return 'ਇਸ ਕੋਡ ਨਾਲ ਸਬਸਕ੍ਰਿਪਸ਼ਨ ਲੈਣ ਵਾਲੇ ਹਰ ਜਿਮ ਲਈ ਤੁਹਾਨੂੰ $amount ਮਿਲਣਗੇ।';
  }

  @override
  String howItWorksStep4(String amount) {
    return 'ਤੁਹਾਡੀ UPI ID ਸੱਚਮੁੱਚ ਤੁਹਾਡੀ ਹੀ ਹੈ, ਇਹ ਜਾਂਚਣ ਲਈ ਪਹਿਲੇ ਭੁਗਤਾਨ ਵਿੱਚੋਂ ਇੱਕ ਵਾਰ $amount ਕੱਟੇ ਜਾਂਦੇ ਹਨ।';
  }

  @override
  String get notForOwners => 'ਆਪਣੇ ਹੀ ਜਿਮ ਤੋਂ ਤੁਸੀਂ ਕਮਾਈ ਨਹੀਂ ਕਰ ਸਕਦੇ।';

  @override
  String get earnedTotal => 'ਹੁਣ ਤੱਕ ਕਮਾਏ';

  @override
  String get heldPending => 'ਰੋਕੇ ਹੋਏ';

  @override
  String get paidOut => 'ਅਦਾ ਕੀਤੇ';

  @override
  String get taxWithheld => 'ਕੱਟਿਆ ਟੈਕਸ';

  @override
  String get neverUsed => 'ਹਾਲੇ ਤੱਕ ਕਿਸੇ ਨੇ ਤੁਹਾਡਾ ਕੋਡ ਨਹੀਂ ਵਰਤਿਆ।';

  @override
  String timesUsed(int count) {
    return '$count ਵਾਰ ਵਰਤਿਆ ਗਿਆ।';
  }

  @override
  String get usedOnce => 'ਇੱਕ ਵਾਰ ਵਰਤਿਆ ਗਿਆ।';

  @override
  String awaitingClearance(int count) {
    return '$count ਹਾਲੇ ਕਲੀਅਰ ਹੋ ਰਹੇ ਹਨ।';
  }

  @override
  String get earningsTitle => 'ਤੁਹਾਡੇ ਕੋਡ ਨੇ ਕੀ ਕਮਾਇਆ';

  @override
  String get earningsEmpty =>
      'ਹਾਲੇ ਕੁਝ ਨਹੀਂ। ਜਿਮ ਚਲਾਉਣ ਵਾਲੇ ਕਿਸੇ ਨਾਲ ਆਪਣਾ ਕੋਡ ਸਾਂਝਾ ਕਰੋ।';

  @override
  String earningsCapped(int count) {
    return 'ਸਭ ਤੋਂ ਨਵੇਂ $count ਦਿਖਾਏ ਜਾ ਰਹੇ ਹਨ।';
  }

  @override
  String get statusPending => 'ਕਲੀਅਰ ਹੋ ਰਿਹਾ ਹੈ';

  @override
  String get statusEligible => 'ਭੁਗਤਾਨ ਲਈ ਤਿਆਰ';

  @override
  String get statusPaid => 'ਅਦਾ ਕੀਤਾ';

  @override
  String get statusReversed => 'ਵਾਪਸ ਲਿਆ';

  @override
  String get statusPendingWhy =>
      'ਜਿਮ ਦੀ ਰਿਫੰਡ ਮਿਆਦ ਖ਼ਤਮ ਹੋਣ ਤੱਕ ਰੋਕਿਆ ਹੋਇਆ ਹੈ।';

  @override
  String get statusEligibleWhy => 'ਕਲੀਅਰ ਹੋ ਗਿਆ। ਭੁਗਤਾਨ ਸ਼ੁਰੂ ਹੋਣ ਦੀ ਉਡੀਕ ਹੈ।';

  @override
  String get statusPaidWhy => 'ਤੁਹਾਡੀ UPI ID ਉੱਤੇ ਭੇਜ ਦਿੱਤਾ ਗਿਆ।';

  @override
  String get statusReversedWhy =>
      'ਜਿਮ ਦਾ ਭੁਗਤਾਨ ਵਾਪਸ ਹੋ ਗਿਆ, ਇਸ ਲਈ ਇਹ ਇਨਾਮ ਵੀ ਵਾਪਸ ਲੈ ਲਿਆ ਗਿਆ।';

  @override
  String get payoutTitle => 'ਤੁਹਾਡਾ ਪੈਸਾ ਕਿੱਥੇ ਜਾਂਦਾ ਹੈ';

  @override
  String get withdrawTitle => 'ਪੈਸੇ ਕਢਵਾਓ';

  @override
  String get withdrawAvailable => 'ਕਢਵਾਉਣ ਲਈ ਤਿਆਰ';

  @override
  String get withdrawFee => 'ਇੱਕ ਵਾਰ ਦੀ UPI ਜਾਂਚ';

  @override
  String get withdrawArrives => 'ਤੁਹਾਨੂੰ ਮਿਲਣਗੇ';

  @override
  String withdrawButton(String amount) {
    return '$amount ਕਢਵਾਓ';
  }

  @override
  String withdrawConfirm(String amount, String upi) {
    return '$upi ਉੱਤੇ $amount ਭੇਜਣੇ ਹਨ?';
  }

  @override
  String get withdrawConfirmBody =>
      'ਇਹ ਵਾਪਸ ਨਹੀਂ ਲਿਆ ਜਾ ਸਕਦਾ। ਭੇਜਣ ਤੋਂ ਪਹਿਲਾਂ ਪਤਾ ਠੀਕ ਹੈ ਜਾਂ ਨਹੀਂ ਜਾਂਚ ਲਓ।';

  @override
  String get withdrawRequested => 'ਬੇਨਤੀ ਹੋ ਗਈ। ਪੈਸੇ ਰਾਹ ਵਿੱਚ ਹਨ।';

  @override
  String withdrawFeeWhy(String amount) {
    return 'ਪਤਾ ਸੱਚਮੁੱਚ ਤੁਹਾਡਾ ਹੀ ਹੈ, ਇਹ ਜਾਂਚਣ ਲਈ ਇੱਕ ਵਾਰ $amount ਕੱਟੇ ਜਾਂਦੇ ਹਨ। ਉਸ ਤੋਂ ਬਾਅਦ ਕੁਝ ਨਹੀਂ ਕੱਟਿਆ ਜਾਂਦਾ।';
  }

  @override
  String get withdrawNoTax => 'ਇੰਨੀ ਰਕਮ ਉੱਤੇ ਕੋਈ ਟੈਕਸ ਨਹੀਂ ਕੱਟਿਆ ਜਾਂਦਾ।';

  @override
  String get withdrawHistoryTitle => 'ਕਢਵਾਈਆਂ';

  @override
  String get withdrawNone => 'ਤੁਸੀਂ ਹਾਲੇ ਕੁਝ ਨਹੀਂ ਕਢਵਾਇਆ।';

  @override
  String get withdrawStatusQueued => 'ਕਤਾਰ ਵਿੱਚ';

  @override
  String get withdrawStatusProcessing => 'ਭੇਜਿਆ ਜਾ ਰਿਹਾ ਹੈ';

  @override
  String get withdrawStatusSuccess => 'ਭੇਜ ਦਿੱਤਾ';

  @override
  String get withdrawStatusFailed => 'ਅਸਫਲ';

  @override
  String get withdrawStatusReversed => 'ਵਾਪਸ ਆਇਆ';

  @override
  String withdrawUtr(String utr) {
    return 'ਹਵਾਲਾ $utr';
  }

  @override
  String get payoutsNotLive =>
      'ਭੁਗਤਾਨ ਹਾਲੇ ਸ਼ੁਰੂ ਨਹੀਂ ਹੋਏ। ਉਦੋਂ ਤੱਕ ਕਮਾਈ ਗਿਣੀ ਅਤੇ ਰੋਕੀ ਜਾ ਰਹੀ ਹੈ।';

  @override
  String get stillNeededTitle => 'ਹਾਲੇ ਲੋੜੀਂਦਾ';

  @override
  String get payoutInFlight =>
      'ਇੱਕ ਭੁਗਤਾਨ ਰਾਹ ਵਿੱਚ ਹੈ। ਉਹ ਪੂਰਾ ਹੋਣ ਤੋਂ ਬਾਅਦ ਇਹ ਬਦਲੇ ਜਾ ਸਕਦੇ ਹਨ।';

  @override
  String get upiSectionTitle => 'UPI ID';

  @override
  String get upiIdLabel => 'UPI ID';

  @override
  String get upiIdHint => 'name@bank';

  @override
  String get holderNameLabel => 'ਖਾਤੇ ਉੱਤੇ ਲਿਖਿਆ ਨਾਮ';

  @override
  String get upiNotSet => 'ਸੈੱਟ ਨਹੀਂ ਕੀਤਾ';

  @override
  String get upiVerifiedYes => 'ਤਸਦੀਕਸ਼ੁਦਾ';

  @override
  String get upiVerifiedNo => 'ਹਾਲੇ ਤਸਦੀਕ ਨਹੀਂ ਹੋਈ';

  @override
  String get upiTypoWarning =>
      'ਇਸਨੂੰ ਅੱਖਰ-ਦਰ-ਅੱਖਰ ਜਾਂਚੋ। UPI ID ਵਿੱਚ ਕੋਈ ਸਪੈੱਲ-ਚੈੱਕ ਨਹੀਂ ਹੁੰਦਾ: ਇੱਕ ਅੱਖਰ ਦੀ ਗਲਤੀ ਕਿਸੇ ਹੋਰ ਦਾ ਬਿਲਕੁਲ ਸਹੀ ਪਤਾ ਬਣ ਜਾਂਦੀ ਹੈ, ਅਤੇ ਉੱਥੇ ਭੇਜਿਆ ਪੈਸਾ ਵਾਪਸ ਨਹੀਂ ਆਉਂਦਾ।';

  @override
  String get upiChangedClearsVerification =>
      'ਇਸਨੂੰ ਬਦਲਣ ਨਾਲ ਤਸਦੀਕ ਹਟ ਜਾਂਦੀ ਹੈ। ਪਹਿਲੇ ਭੁਗਤਾਨ ਤੋਂ ਪਹਿਲਾਂ ਪਤਾ ਦੁਬਾਰਾ ਜਾਂਚਿਆ ਜਾਵੇਗਾ।';

  @override
  String get holderNameWhy =>
      '₹10 ਦੀ ਜਾਂਚ ਵਿੱਚ ਉਸ ਖਾਤੇ ਲਈ ਤੁਹਾਡੇ ਬੈਂਕ ਕੋਲ ਦਰਜ ਨਾਮ ਵਾਪਸ ਆਉਂਦਾ ਹੈ। ਮਿਲਾਉਣ ਲਈ ਨਾਮ ਨਾ ਹੋਵੇ ਤਾਂ ਜਾਂਚ ਸਿਰਫ਼ ਇਹ ਸਾਬਤ ਕਰਦੀ ਹੈ ਕਿ ਪਤਾ ਮੌਜੂਦ ਹੈ — ਇਹ ਨਹੀਂ ਕਿ ਉਹ ਤੁਹਾਡਾ ਹੈ।';

  @override
  String get saved => 'ਸੇਵ ਹੋ ਗਿਆ।';

  @override
  String get invalidUpi =>
      'ਇਹ UPI ID ਵਰਗਾ ਨਹੀਂ ਲੱਗਦਾ। ਇਹ name@bank ਵਰਗਾ ਹੋਣਾ ਚਾਹੀਦਾ ਹੈ।';

  @override
  String get holderNameRequired => 'ਬੈਂਕ ਖਾਤੇ ਉੱਤੇ ਲਿਖਿਆ ਨਾਮ ਪਾਓ।';

  @override
  String get panSectionTitle => 'PAN';

  @override
  String get panLabel => 'PAN';

  @override
  String get panHint => 'ABCDE1234F';

  @override
  String get panNotSet => 'ਸੈੱਟ ਨਹੀਂ ਕੀਤਾ';

  @override
  String get panWhy =>
      'ਜਦੋਂ ਤੁਹਾਡੀ ਕਮਾਈ ਉਸ ਪੱਧਰ ਤੱਕ ਪਹੁੰਚੇ ਜਿੱਥੇ ਟੈਕਸ ਕੱਟਣਾ ਜ਼ਰੂਰੀ ਹੋ ਜਾਵੇ, ਉਸ ਤੋਂ ਪਹਿਲਾਂ ਇਹ ਚਾਹੀਦਾ ਹੈ। ਸ਼ੁਰੂ ਕਰਨ ਲਈ ਲੋੜੀਂਦਾ ਨਹੀਂ।';

  @override
  String get panStatusPending => 'ਮਿਲ ਗਿਆ, ਹਾਲੇ ਜਾਂਚਿਆ ਨਹੀਂ';

  @override
  String get panStatusVerified => 'ਤਸਦੀਕਸ਼ੁਦਾ';

  @override
  String get panStatusRejected => 'ਸਵੀਕਾਰ ਨਹੀਂ ਹੋਇਆ। ਨੰਬਰ ਜਾਂਚ ਕੇ ਦੁਬਾਰਾ ਭੇਜੋ।';

  @override
  String get invalidPan =>
      'ਇਹ PAN ਵਰਗਾ ਨਹੀਂ ਲੱਗਦਾ। ਇਹ ABCDE1234F ਵਰਗਾ ਹੋਣਾ ਚਾਹੀਦਾ ਹੈ।';

  @override
  String get settingsTitle => 'ਸੈਟਿੰਗਾਂ';

  @override
  String get profileTitle => 'ਤੁਹਾਡੀ ਪ੍ਰੋਫਾਈਲ';

  @override
  String get languageTitle => 'ਭਾਸ਼ਾ';

  @override
  String get languageSubtitle =>
      'ਉਹ ਭਾਸ਼ਾ ਚੁਣੋ ਜੋ ਤੁਸੀਂ ਸਭ ਤੋਂ ਸੌਖ ਨਾਲ ਪੜ੍ਹਦੇ ਹੋ';

  @override
  String get useDeviceLanguage => 'ਡਿਵਾਈਸ ਦੀ ਭਾਸ਼ਾ ਵਰਤੋ';

  @override
  String get needsReview => 'ਅਨੁਵਾਦ ਦੀ ਸਮੀਖਿਆ ਬਾਕੀ ਹੈ';

  @override
  String get untranslatedFallbackNote =>
      'ਜੋ ਹਾਲੇ ਅਨੁਵਾਦ ਨਹੀਂ ਹੋਇਆ ਉਹ ਖਾਲੀ ਛੱਡਣ ਦੀ ਥਾਂ ਅੰਗਰੇਜ਼ੀ ਵਿੱਚ ਦਿਖਾਇਆ ਜਾਂਦਾ ਹੈ, ਤਾਂ ਜੋ ਅੰਸ਼ਿਕ ਅਨੁਵਾਦ ਵਾਲੀ ਭਾਸ਼ਾ ਵੀ ਵਰਤੀ ਜਾ ਸਕੇ।';

  @override
  String get legalTitle => 'ਸ਼ਰਤਾਂ ਅਤੇ ਗੋਪਨੀਯਤਾ';

  @override
  String get legalUnavailable => 'ਇਹ ਹੁਣੇ ਲੋਡ ਨਹੀਂ ਹੋ ਸਕਿਆ।';

  @override
  String get supportTitle => 'ਮਦਦ ਚਾਹੀਦੀ ਹੈ?';

  @override
  String get supportBody => 'ਸਾਨੂੰ ਦੱਸੋ ਕੀ ਹੋਇਆ, ਅਸੀਂ ਤੁਹਾਡੇ ਨਾਲ ਸੰਪਰਕ ਕਰਾਂਗੇ।';

  @override
  String get supportSubject => 'ਵਿਸ਼ਾ';

  @override
  String get supportMessage => 'ਕੀ ਹੋਇਆ?';

  @override
  String get supportSend => 'ਭੇਜੋ';

  @override
  String get supportSent => 'ਭੇਜ ਦਿੱਤਾ। ਅਸੀਂ ਤੁਹਾਡੇ ਨਾਲ ਸੰਪਰਕ ਕਰਾਂਗੇ।';

  @override
  String supportEmailLine(String email) {
    return 'ਜਾਂ $email ਉੱਤੇ ਲਿਖੋ।';
  }

  @override
  String get supportTooShort =>
      'ਇੱਕ-ਦੋ ਵਾਕ ਲਿਖੋ, ਤਾਂ ਜੋ ਸਾਨੂੰ ਪਤਾ ਲੱਗੇ ਕਿ ਕੀ ਦੇਖਣਾ ਹੈ।';

  @override
  String get signOut => 'ਸਾਈਨ ਆਊਟ';

  @override
  String get signOutConfirm => 'ਇਸ ਡਿਵਾਈਸ ਉੱਤੇ ਸਾਈਨ ਆਊਟ ਕਰਨਾ ਹੈ?';

  @override
  String get aboutTitle => 'ਬਾਰੇ';

  @override
  String get sessionExpiredSignIn =>
      'ਤੁਹਾਡਾ ਸੈਸ਼ਨ ਖ਼ਤਮ ਹੋ ਗਿਆ। ਕਿਰਪਾ ਕਰਕੇ ਦੁਬਾਰਾ ਸਾਈਨ ਇਨ ਕਰੋ।';

  @override
  String get serverTookTooLong =>
      'ਸਰਵਰ ਨੇ ਜਵਾਬ ਦੇਣ ਵਿੱਚ ਬਹੁਤ ਸਮਾਂ ਲਿਆ। ਆਪਣਾ ਕੁਨੈਕਸ਼ਨ ਜਾਂਚ ਕੇ ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ।';

  @override
  String couldNotReachServer(String host) {
    return '$host ਤੱਕ ਨਹੀਂ ਪਹੁੰਚ ਸਕੇ। ਆਪਣਾ ਇੰਟਰਨੈੱਟ ਕੁਨੈਕਸ਼ਨ ਜਾਂਚੋ।';
  }

  @override
  String get certificateNotVerified => 'ਸਰਵਰ ਦਾ ਸਰਟੀਫਿਕੇਟ ਤਸਦੀਕ ਨਹੀਂ ਹੋ ਸਕਿਆ।';

  @override
  String get networkErrorTryAgain =>
      'ਨੈੱਟਵਰਕ ਗਲਤੀ। ਕਿਰਪਾ ਕਰਕੇ ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ।';

  @override
  String get footerLine => 'Gymologia Referral';

  @override
  String get footerSupport => 'support@gymologia.com';
}
