// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get appTitle => 'Gymologia Referral';

  @override
  String get tryAgain => 'மீண்டும் முயற்சிக்கவும்';

  @override
  String get cancel => 'ரத்து செய்';

  @override
  String get save => 'சேமி';

  @override
  String get add => 'சேர்';

  @override
  String get change => 'மாற்று';

  @override
  String get genericError => 'ஏதோ தவறு நடந்துவிட்டது. மீண்டும் முயற்சிக்கவும்.';

  @override
  String cleartextWarning(String host) {
    return '$host உடன் பாதுகாப்பின்றி (plain http) இணைக்கப்பட்டுள்ளது';
  }

  @override
  String get signInSubtitle =>
      'குறியீட்டைப் பகிருங்கள். ஒரு ஜிம் சந்தா செலுத்தினால் உங்களுக்கு வருமானம்.';

  @override
  String get phoneLabel => 'மொபைல் எண்';

  @override
  String get phoneHint => '10 இலக்க மொபைல் எண்';

  @override
  String get sendCode => 'குறியீட்டை அனுப்பு';

  @override
  String codeSentTo(String phone) {
    return '$phone க்கு குறியீடு அனுப்பப்பட்டது';
  }

  @override
  String get verify => 'சரிபார்';

  @override
  String resendIn(int seconds) {
    return '$seconds வினாடிகளில் மற்றொரு குறியீடு கேட்கலாம்';
  }

  @override
  String get resend => 'மற்றொரு குறியீட்டை அனுப்பு';

  @override
  String get changeNumber => 'வேறு எண்ணைப் பயன்படுத்து';

  @override
  String get enterTenDigits => 'உங்கள் 10 இலக்க மொபைல் எண்ணை உள்ளிடவும்.';

  @override
  String get enterTheCode => 'நாங்கள் அனுப்பிய குறியீட்டை உள்ளிடவும்.';

  @override
  String get ownersCannotJoin =>
      'ஜிம் உரிமையாளர்கள் இந்த ரெஃபரல் செயலியைப் பயன்படுத்த முடியாது. ஜிம் ஊழியர்களும் மற்ற அனைவரும் பயன்படுத்தலாம்.';

  @override
  String get createAccountTitle => 'உங்கள் கணக்கை உருவாக்குங்கள்';

  @override
  String get nameLabel => 'பெயர்';

  @override
  String get emailLabel => 'மின்னஞ்சல் (விருப்பம்)';

  @override
  String get ageLabel => 'வயது';

  @override
  String get ageWhy =>
      'நாங்கள் வயதை மட்டுமே கேட்கிறோம், பிறந்த தேதியை ஒருபோதும் இல்லை. பிறந்த தேதி உங்கள் வங்கி மற்றும் அரசு ஆவணங்களுக்கான சாவி; வயது அல்ல.';

  @override
  String get ageRange => '13 முதல் 100 வரையிலான வயதை உள்ளிடவும்.';

  @override
  String get nameRequired => 'உங்கள் பெயரை உள்ளிடவும்.';

  @override
  String get createAccount => 'கணக்கை உருவாக்கு';

  @override
  String get tabCode => 'உங்கள் குறியீடு';

  @override
  String get tabEarnings => 'வருமானம்';

  @override
  String get tabPayout => 'பணப்பரிமாற்றம்';

  @override
  String get tabSettings => 'அமைப்புகள்';

  @override
  String get yourCodeTitle => 'உங்கள் ரெஃபரல் குறியீடு';

  @override
  String get shareCode => 'பகிர்';

  @override
  String get copyCode => 'நகலெடு';

  @override
  String get copied => 'நகலெடுக்கப்பட்டது.';

  @override
  String get shareUnavailable =>
      'இங்கே பகிர முடியவில்லை. செய்தி நகலெடுக்கப்பட்டுள்ளது.';

  @override
  String get howItWorksTitle => 'இது எப்படி வேலை செய்கிறது';

  @override
  String get howItWorksStep1 =>
      'ஜிம் நடத்தும் ஒருவருக்கு உங்கள் குறியீட்டை அனுப்புங்கள்.';

  @override
  String howItWorksStep2(int percent) {
    return 'சந்தா செலுத்தும்போது எந்த Gymologia திட்டத்திலும் அவர்களுக்கு $percent% தள்ளுபடி கிடைக்கும்.';
  }

  @override
  String howItWorksStep3(String amount) {
    return 'இந்தக் குறியீட்டைப் பயன்படுத்தி சந்தா செலுத்தும் ஒவ்வொரு ஜிம்முக்கும் உங்களுக்கு $amount கிடைக்கும்.';
  }

  @override
  String howItWorksStep4(String amount) {
    return 'உங்கள் UPI ID உண்மையிலேயே உங்களுடையதா என்பதைச் சரிபார்க்க, முதல் பணப்பரிமாற்றத்தில் ஒருமுறை $amount பிடிக்கப்படும்.';
  }

  @override
  String get notForOwners =>
      'உங்கள் சொந்த ஜிம்மிலிருந்து நீங்கள் சம்பாதிக்க முடியாது.';

  @override
  String get earnedTotal => 'இதுவரை சம்பாதித்தது';

  @override
  String get heldPending => 'நிறுத்தி வைக்கப்பட்டது';

  @override
  String get paidOut => 'செலுத்தப்பட்டது';

  @override
  String get taxWithheld => 'பிடித்தம் செய்யப்பட்ட வரி';

  @override
  String get neverUsed => 'இதுவரை யாரும் உங்கள் குறியீட்டைப் பயன்படுத்தவில்லை.';

  @override
  String timesUsed(int count) {
    return '$count முறை பயன்படுத்தப்பட்டது.';
  }

  @override
  String get usedOnce => 'ஒரு முறை பயன்படுத்தப்பட்டது.';

  @override
  String awaitingClearance(int count) {
    return '$count இன்னும் தீர்வு பெறவில்லை.';
  }

  @override
  String get earningsTitle => 'உங்கள் குறியீடு சம்பாதித்தது';

  @override
  String get earningsEmpty =>
      'இன்னும் எதுவும் இல்லை. ஜிம் நடத்தும் ஒருவருடன் உங்கள் குறியீட்டைப் பகிருங்கள்.';

  @override
  String earningsCapped(int count) {
    return 'மிக அண்மைய $count காட்டப்படுகின்றன.';
  }

  @override
  String get statusPending => 'தீர்வு பெறுகிறது';

  @override
  String get statusEligible => 'செலுத்தத் தயார்';

  @override
  String get statusPaid => 'செலுத்தப்பட்டது';

  @override
  String get statusReversed => 'திரும்பப் பெறப்பட்டது';

  @override
  String get statusPendingWhy =>
      'ஜிம்மின் பணத்திரும்பக் கால அவகாசம் முடியும் வரை நிறுத்தி வைக்கப்பட்டுள்ளது.';

  @override
  String get statusEligibleWhy =>
      'தீர்வு பெற்றுவிட்டது. பணப்பரிமாற்றம் தொடங்கும் வரை காத்திருப்பு.';

  @override
  String get statusPaidWhy => 'உங்கள் UPI ID க்கு அனுப்பப்பட்டது.';

  @override
  String get statusReversedWhy =>
      'ஜிம்மின் கட்டணம் திரும்பப் பெறப்பட்டதால், இந்தச் சன்மானமும் திரும்பப் பெறப்பட்டது.';

  @override
  String get payoutTitle => 'உங்கள் பணம் எங்கே செல்கிறது';

  @override
  String get withdrawTitle => 'பணம் எடுக்க';

  @override
  String get withdrawAvailable => 'எடுக்கத் தயார்';

  @override
  String get withdrawFee => 'ஒரு முறை UPI சரிபார்ப்பு';

  @override
  String get withdrawArrives => 'உங்களுக்குக் கிடைப்பது';

  @override
  String withdrawButton(String amount) {
    return '$amount எடுக்கவும்';
  }

  @override
  String withdrawConfirm(String amount, String upi) {
    return '$upi க்கு $amount அனுப்பவா?';
  }

  @override
  String get withdrawConfirmBody =>
      'இதைத் திரும்பப் பெற முடியாது. அனுப்பும் முன் முகவரியைச் சரிபாருங்கள்.';

  @override
  String get withdrawRequested => 'கோரப்பட்டது. பணம் வழியில் உள்ளது.';

  @override
  String withdrawFeeWhy(String amount) {
    return 'முகவரி உண்மையிலேயே உங்களுடையதா எனச் சரிபார்க்க ஒரு முறை $amount பிடிக்கப்படும். அதன் பிறகு எதுவும் பிடிக்கப்படாது.';
  }

  @override
  String get withdrawNoTax =>
      'இந்தத் தொகைகளுக்கு எந்த வரியும் பிடிக்கப்படுவதில்லை.';

  @override
  String get withdrawHistoryTitle => 'பணம் எடுத்தவை';

  @override
  String get withdrawNone => 'நீங்கள் இதுவரை எதுவும் எடுக்கவில்லை.';

  @override
  String get withdrawStatusQueued => 'வரிசையில்';

  @override
  String get withdrawStatusProcessing => 'அனுப்பப்படுகிறது';

  @override
  String get withdrawStatusSuccess => 'அனுப்பப்பட்டது';

  @override
  String get withdrawStatusFailed => 'தோல்வி';

  @override
  String get withdrawStatusReversed => 'திரும்பியது';

  @override
  String withdrawUtr(String utr) {
    return 'குறிப்பு $utr';
  }

  @override
  String get payoutsNotLive =>
      'பணப்பரிமாற்றம் இன்னும் தொடங்கவில்லை. அதுவரை வருமானம் கணக்கிடப்பட்டு நிறுத்தி வைக்கப்படுகிறது.';

  @override
  String get stillNeededTitle => 'இன்னும் தேவை';

  @override
  String get payoutInFlight =>
      'ஒரு பணப்பரிமாற்றம் நடந்துகொண்டிருக்கிறது. அது முடிந்த பிறகு இவற்றை மாற்றலாம்.';

  @override
  String get upiSectionTitle => 'UPI ID';

  @override
  String get upiIdLabel => 'UPI ID';

  @override
  String get upiIdHint => 'name@bank';

  @override
  String get holderNameLabel => 'கணக்கில் உள்ள பெயர்';

  @override
  String get upiNotSet => 'அமைக்கப்படவில்லை';

  @override
  String get upiVerifiedYes => 'சரிபார்க்கப்பட்டது';

  @override
  String get upiVerifiedNo => 'இன்னும் சரிபார்க்கப்படவில்லை';

  @override
  String get upiTypoWarning =>
      'இதை எழுத்துக்கு எழுத்து சரிபாருங்கள். UPI ID க்கு எழுத்துப்பிழை திருத்தம் இல்லை: ஒரே எழுத்துப் பிழை வேறொருவரின் முற்றிலும் சரியான முகவரியாகிவிடும், அங்கு அனுப்பிய பணம் திரும்பி வராது.';

  @override
  String get upiChangedClearsVerification =>
      'இதை மாற்றினால் சரிபார்ப்பு நீக்கப்படும். முதல் பணப்பரிமாற்றத்திற்கு முன் முகவரி மீண்டும் சரிபார்க்கப்படும்.';

  @override
  String get holderNameWhy =>
      '₹10 சரிபார்ப்பில், அந்தக் கணக்கிற்கு உங்கள் வங்கியில் பதிவான பெயர் திரும்பி வரும். ஒப்பிட ஒரு பெயர் இல்லாவிட்டால், முகவரி இருக்கிறது என்பதை மட்டுமே அது நிரூபிக்கும் — அது உங்களுடையது என்பதை அல்ல.';

  @override
  String get saved => 'சேமிக்கப்பட்டது.';

  @override
  String get invalidUpi =>
      'இது UPI ID போல் தெரியவில்லை. இது name@bank போல் இருக்க வேண்டும்.';

  @override
  String get holderNameRequired => 'வங்கிக் கணக்கில் உள்ள பெயரை உள்ளிடவும்.';

  @override
  String get panSectionTitle => 'PAN';

  @override
  String get panLabel => 'PAN';

  @override
  String get panHint => 'ABCDE1234F';

  @override
  String get panNotSet => 'அமைக்கப்படவில்லை';

  @override
  String get panWhy =>
      'வரி பிடித்தம் செய்ய வேண்டிய அளவுக்கு உங்கள் வருமானம் உயரும் முன் இது தேவை. தொடங்குவதற்குத் தேவையில்லை.';

  @override
  String get panStatusPending => 'பெறப்பட்டது, இன்னும் சரிபார்க்கப்படவில்லை';

  @override
  String get panStatusVerified => 'சரிபார்க்கப்பட்டது';

  @override
  String get panStatusRejected =>
      'ஏற்கப்படவில்லை. எண்ணைச் சரிபார்த்து மீண்டும் அனுப்பவும்.';

  @override
  String get invalidPan =>
      'இது PAN போல் தெரியவில்லை. இது ABCDE1234F போல் இருக்க வேண்டும்.';

  @override
  String get settingsTitle => 'அமைப்புகள்';

  @override
  String get profileTitle => 'உங்கள் சுயவிவரம்';

  @override
  String get languageTitle => 'மொழி';

  @override
  String get languageSubtitle =>
      'நீங்கள் மிகவும் வசதியாகப் படிக்கும் மொழியைத் தேர்ந்தெடுங்கள்';

  @override
  String get useDeviceLanguage => 'சாதனத்தின் மொழியைப் பயன்படுத்து';

  @override
  String get needsReview => 'மொழிபெயர்ப்பு மறுபரிசீலனைக்குக் காத்திருக்கிறது';

  @override
  String get untranslatedFallbackNote =>
      'இன்னும் மொழிபெயர்க்கப்படாதவை காலியாக விடப்படாமல் ஆங்கிலத்தில் காட்டப்படுகின்றன, அதனால் பகுதியளவு மொழிபெயர்க்கப்பட்ட மொழியும் பயன்படுத்தக்கூடியதாக இருக்கும்.';

  @override
  String get legalTitle => 'விதிமுறைகளும் தனியுரிமையும்';

  @override
  String get legalUnavailable => 'இதை இப்போது ஏற்ற முடியவில்லை.';

  @override
  String get supportTitle => 'உதவி தேவையா?';

  @override
  String get supportBody =>
      'என்ன நடந்தது என்று சொல்லுங்கள், நாங்கள் உங்களைத் தொடர்புகொள்கிறோம்.';

  @override
  String get supportSubject => 'பொருள்';

  @override
  String get supportMessage => 'என்ன நடந்தது?';

  @override
  String get supportSend => 'அனுப்பு';

  @override
  String get supportSent =>
      'அனுப்பப்பட்டது. நாங்கள் உங்களைத் தொடர்புகொள்கிறோம்.';

  @override
  String supportEmailLine(String email) {
    return 'அல்லது $email க்கு எழுதுங்கள்.';
  }

  @override
  String get supportTooShort =>
      'ஓரிரு வாக்கியங்கள் எழுதுங்கள், எதைப் பார்க்க வேண்டும் என்று எங்களுக்குத் தெரியும்.';

  @override
  String get signOut => 'வெளியேறு';

  @override
  String get signOutConfirm => 'இந்தச் சாதனத்தில் வெளியேற வேண்டுமா?';

  @override
  String get aboutTitle => 'பற்றி';

  @override
  String get sessionExpiredSignIn =>
      'உங்கள் அமர்வு முடிந்தது. மீண்டும் உள்நுழையவும்.';

  @override
  String get serverTookTooLong =>
      'சேவையகம் பதிலளிக்க நீண்ட நேரம் எடுத்தது. இணைப்பைச் சரிபார்த்து மீண்டும் முயற்சிக்கவும்.';

  @override
  String couldNotReachServer(String host) {
    return '$host ஐ அடைய முடியவில்லை. உங்கள் இணைய இணைப்பைச் சரிபார்க்கவும்.';
  }

  @override
  String get certificateNotVerified =>
      'சேவையகச் சான்றிதழைச் சரிபார்க்க முடியவில்லை.';

  @override
  String get networkErrorTryAgain => 'பிணையப் பிழை. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get footerLine => 'Gymologia Referral';

  @override
  String get footerSupport => 'support@gymologia.com';
}
