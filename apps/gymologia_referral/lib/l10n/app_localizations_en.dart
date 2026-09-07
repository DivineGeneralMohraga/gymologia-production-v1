// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Gymologia Referral';

  @override
  String get tryAgain => 'Try again';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get add => 'Add';

  @override
  String get change => 'Change';

  @override
  String get genericError => 'Something went wrong. Please try again.';

  @override
  String cleartextWarning(String host) {
    return 'Connected to $host over plain http';
  }

  @override
  String get signInSubtitle => 'Share a code. Earn when a gym subscribes.';

  @override
  String get phoneLabel => 'Phone number';

  @override
  String get phoneHint => '10-digit mobile number';

  @override
  String get sendCode => 'Send code';

  @override
  String codeSentTo(String phone) {
    return 'Code sent to $phone';
  }

  @override
  String get verify => 'Verify';

  @override
  String resendIn(int seconds) {
    return 'You can ask for another in ${seconds}s';
  }

  @override
  String get resend => 'Send another code';

  @override
  String get changeNumber => 'Use a different number';

  @override
  String get enterTenDigits => 'Enter your 10-digit mobile number.';

  @override
  String get enterTheCode => 'Enter the code we sent you.';

  @override
  String get ownersCannotJoin =>
      'Gym owners cannot use the referral app. Gym staff and everyone else can.';

  @override
  String get createAccountTitle => 'Create your account';

  @override
  String get nameLabel => 'Name';

  @override
  String get emailLabel => 'Email (optional)';

  @override
  String get ageLabel => 'Age';

  @override
  String get ageWhy =>
      'We ask for an age, never a date of birth. A date of birth is a key into your bank and government records; an age is not.';

  @override
  String get ageRange => 'Enter an age between 13 and 100.';

  @override
  String get nameRequired => 'Please enter your name.';

  @override
  String get createAccount => 'Create account';

  @override
  String get tabCode => 'Your code';

  @override
  String get tabEarnings => 'Earnings';

  @override
  String get tabPayout => 'Payout';

  @override
  String get tabSettings => 'Settings';

  @override
  String get yourCodeTitle => 'Your referral code';

  @override
  String get shareCode => 'Share';

  @override
  String get copyCode => 'Copy';

  @override
  String get copied => 'Copied.';

  @override
  String get shareUnavailable =>
      'Sharing is not available here. The message has been copied instead.';

  @override
  String get howItWorksTitle => 'How it works';

  @override
  String get howItWorksStep1 => 'Send your code to someone who runs a gym.';

  @override
  String howItWorksStep2(int percent) {
    return 'They get $percent% off any Gymologia plan when they subscribe.';
  }

  @override
  String howItWorksStep3(String amount) {
    return 'You earn $amount for every gym that subscribes with it.';
  }

  @override
  String howItWorksStep4(String amount) {
    return '$amount is taken once, out of your first payout, to check that the UPI ID is really yours.';
  }

  @override
  String get notForOwners => 'You cannot earn from a gym you own yourself.';

  @override
  String get earnedTotal => 'Earned so far';

  @override
  String get heldPending => 'Held';

  @override
  String get paidOut => 'Paid out';

  @override
  String get taxWithheld => 'Tax withheld';

  @override
  String get neverUsed => 'Nobody has used your code yet.';

  @override
  String timesUsed(int count) {
    return 'Used $count times.';
  }

  @override
  String get usedOnce => 'Used once.';

  @override
  String awaitingClearance(int count) {
    return '$count still clearing.';
  }

  @override
  String get earningsTitle => 'What your code has earned';

  @override
  String get earningsEmpty =>
      'Nothing yet. Share your code with someone who runs a gym.';

  @override
  String earningsCapped(int count) {
    return 'Showing the most recent $count.';
  }

  @override
  String get statusPending => 'Clearing';

  @override
  String get statusEligible => 'Ready to pay';

  @override
  String get statusPaid => 'Paid';

  @override
  String get statusReversed => 'Reversed';

  @override
  String get statusPendingWhy => 'Held until the gym\'s refund window closes.';

  @override
  String get statusEligibleWhy =>
      'Cleared. Waiting on payouts being switched on.';

  @override
  String get statusPaidWhy => 'Sent to your UPI ID.';

  @override
  String get statusReversedWhy =>
      'The gym\'s payment was refunded, so this reward was taken back.';

  @override
  String get payoutTitle => 'Where your money goes';

  @override
  String get payoutsNotLive =>
      'Payouts are not switched on yet. Rewards are counted and held until they are.';

  @override
  String get stillNeededTitle => 'Still needed';

  @override
  String get payoutInFlight =>
      'A payout is on its way. These can be changed once it settles.';

  @override
  String get upiSectionTitle => 'UPI ID';

  @override
  String get upiIdLabel => 'UPI ID';

  @override
  String get upiIdHint => 'name@bank';

  @override
  String get holderNameLabel => 'Name on the account';

  @override
  String get upiNotSet => 'Not set';

  @override
  String get upiVerifiedYes => 'Verified';

  @override
  String get upiVerifiedNo => 'Not verified yet';

  @override
  String get upiTypoWarning =>
      'Check this character by character. A UPI ID has no spell-check: a one-letter slip is somebody else\'s perfectly valid address, and money sent there cannot be brought back.';

  @override
  String get upiChangedClearsVerification =>
      'Changing this clears the verification. The address will be checked again before the first payout.';

  @override
  String get holderNameWhy =>
      'The ₹10 check comes back with the name your bank has on that account. Without a name to compare it against, the check only proves the address exists -- not that it is yours.';

  @override
  String get saved => 'Saved.';

  @override
  String get invalidUpi =>
      'That does not look like a UPI ID. It should look like name@bank.';

  @override
  String get holderNameRequired => 'Enter the name on the bank account.';

  @override
  String get panSectionTitle => 'PAN';

  @override
  String get panLabel => 'PAN';

  @override
  String get panHint => 'ABCDE1234F';

  @override
  String get panNotSet => 'Not set';

  @override
  String get panWhy =>
      'Needed before your earnings reach the point where tax has to be withheld. Not needed to start earning.';

  @override
  String get panStatusPending => 'Received, not checked yet';

  @override
  String get panStatusVerified => 'Verified';

  @override
  String get panStatusRejected =>
      'Not accepted. Check the number and send it again.';

  @override
  String get invalidPan =>
      'That does not look like a PAN. It should look like ABCDE1234F.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get profileTitle => 'Your profile';

  @override
  String get languageTitle => 'Language';

  @override
  String get languageSubtitle =>
      'Choose the language you read most comfortably';

  @override
  String get useDeviceLanguage => 'Use device language';

  @override
  String get needsReview => 'Translation pending review';

  @override
  String get untranslatedFallbackNote =>
      'Anything not yet translated is shown in English rather than left blank, so a partly translated language is still usable.';

  @override
  String get legalTitle => 'Terms and privacy';

  @override
  String get legalUnavailable => 'Could not load this right now.';

  @override
  String get supportTitle => 'Need help?';

  @override
  String get supportBody =>
      'Tell us what happened and we will come back to you.';

  @override
  String get supportSubject => 'Subject';

  @override
  String get supportMessage => 'What happened?';

  @override
  String get supportSend => 'Send';

  @override
  String get supportSent => 'Sent. We will get back to you.';

  @override
  String supportEmailLine(String email) {
    return 'Or write to $email.';
  }

  @override
  String get supportTooShort =>
      'A sentence or two, so we know what to look at.';

  @override
  String get signOut => 'Sign out';

  @override
  String get signOutConfirm => 'Sign out on this device?';

  @override
  String get aboutTitle => 'About';

  @override
  String get sessionExpiredSignIn =>
      'Your session has ended. Please sign in again.';

  @override
  String get serverTookTooLong =>
      'The server took too long to answer. Check your connection and try again.';

  @override
  String couldNotReachServer(String host) {
    return 'Could not reach $host. Check your internet connection.';
  }

  @override
  String get certificateNotVerified =>
      'The server certificate could not be verified.';

  @override
  String get networkErrorTryAgain => 'Network error. Please try again.';

  @override
  String get footerLine => 'Gymologia Referral';

  @override
  String get footerSupport => 'support@gymologia.com';
}
