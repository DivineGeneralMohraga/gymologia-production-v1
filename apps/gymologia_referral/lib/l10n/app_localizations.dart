import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_pa.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en'),
    Locale('gu'),
    Locale('hi'),
    Locale('kn'),
    Locale('ml'),
    Locale('mr'),
    Locale('pa'),
    Locale('ta'),
    Locale('te'),
  ];

  /// The app's own name. Not translated -- it is a product name.
  ///
  /// In en, this message translates to:
  /// **'Gymologia Referral'**
  String get appTitle;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @genericError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get genericError;

  /// Shown in the header while the API has no certificate. Deliberately hard to miss.
  ///
  /// In en, this message translates to:
  /// **'Connected to {host} over plain http'**
  String cleartextWarning(String host);

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share a code. Earn when a gym subscribes.'**
  String get signInSubtitle;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneLabel;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'10-digit mobile number'**
  String get phoneHint;

  /// No description provided for @sendCode.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get sendCode;

  /// No description provided for @codeSentTo.
  ///
  /// In en, this message translates to:
  /// **'Code sent to {phone}'**
  String codeSentTo(String phone);

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @resendIn.
  ///
  /// In en, this message translates to:
  /// **'You can ask for another in {seconds}s'**
  String resendIn(int seconds);

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Send another code'**
  String get resend;

  /// No description provided for @changeNumber.
  ///
  /// In en, this message translates to:
  /// **'Use a different number'**
  String get changeNumber;

  /// No description provided for @enterTenDigits.
  ///
  /// In en, this message translates to:
  /// **'Enter your 10-digit mobile number.'**
  String get enterTenDigits;

  /// No description provided for @enterTheCode.
  ///
  /// In en, this message translates to:
  /// **'Enter the code we sent you.'**
  String get enterTheCode;

  /// No description provided for @ownersCannotJoin.
  ///
  /// In en, this message translates to:
  /// **'Gym owners cannot use the referral app. Gym staff and everyone else can.'**
  String get ownersCannotJoin;

  /// No description provided for @createAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get createAccountTitle;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email (optional)'**
  String get emailLabel;

  /// No description provided for @ageLabel.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get ageLabel;

  /// No description provided for @ageWhy.
  ///
  /// In en, this message translates to:
  /// **'We ask for an age, never a date of birth. A date of birth is a key into your bank and government records; an age is not.'**
  String get ageWhy;

  /// No description provided for @ageRange.
  ///
  /// In en, this message translates to:
  /// **'Enter an age between 13 and 100.'**
  String get ageRange;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name.'**
  String get nameRequired;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @tabCode.
  ///
  /// In en, this message translates to:
  /// **'Your code'**
  String get tabCode;

  /// No description provided for @tabEarnings.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get tabEarnings;

  /// No description provided for @tabPayout.
  ///
  /// In en, this message translates to:
  /// **'Payout'**
  String get tabPayout;

  /// No description provided for @tabSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get tabSettings;

  /// No description provided for @yourCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Your referral code'**
  String get yourCodeTitle;

  /// No description provided for @shareCode.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareCode;

  /// No description provided for @copyCode.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copyCode;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied.'**
  String get copied;

  /// No description provided for @shareUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Sharing is not available here. The message has been copied instead.'**
  String get shareUnavailable;

  /// No description provided for @howItWorksTitle.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get howItWorksTitle;

  /// No description provided for @howItWorksStep1.
  ///
  /// In en, this message translates to:
  /// **'Send your code to someone who runs a gym.'**
  String get howItWorksStep1;

  /// No description provided for @howItWorksStep2.
  ///
  /// In en, this message translates to:
  /// **'They get {percent}% off any Gymologia plan when they subscribe.'**
  String howItWorksStep2(int percent);

  /// No description provided for @howItWorksStep3.
  ///
  /// In en, this message translates to:
  /// **'You earn {amount} for every gym that subscribes with it.'**
  String howItWorksStep3(String amount);

  /// No description provided for @howItWorksStep4.
  ///
  /// In en, this message translates to:
  /// **'{amount} is taken once, out of your first payout, to check that the UPI ID is really yours.'**
  String howItWorksStep4(String amount);

  /// No description provided for @notForOwners.
  ///
  /// In en, this message translates to:
  /// **'You cannot earn from a gym you own yourself.'**
  String get notForOwners;

  /// No description provided for @earnedTotal.
  ///
  /// In en, this message translates to:
  /// **'Earned so far'**
  String get earnedTotal;

  /// No description provided for @heldPending.
  ///
  /// In en, this message translates to:
  /// **'Held'**
  String get heldPending;

  /// No description provided for @paidOut.
  ///
  /// In en, this message translates to:
  /// **'Paid out'**
  String get paidOut;

  /// No description provided for @taxWithheld.
  ///
  /// In en, this message translates to:
  /// **'Tax withheld'**
  String get taxWithheld;

  /// No description provided for @neverUsed.
  ///
  /// In en, this message translates to:
  /// **'Nobody has used your code yet.'**
  String get neverUsed;

  /// No description provided for @timesUsed.
  ///
  /// In en, this message translates to:
  /// **'Used {count} times.'**
  String timesUsed(int count);

  /// No description provided for @usedOnce.
  ///
  /// In en, this message translates to:
  /// **'Used once.'**
  String get usedOnce;

  /// No description provided for @awaitingClearance.
  ///
  /// In en, this message translates to:
  /// **'{count} still clearing.'**
  String awaitingClearance(int count);

  /// No description provided for @earningsTitle.
  ///
  /// In en, this message translates to:
  /// **'What your code has earned'**
  String get earningsTitle;

  /// No description provided for @earningsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing yet. Share your code with someone who runs a gym.'**
  String get earningsEmpty;

  /// No description provided for @earningsCapped.
  ///
  /// In en, this message translates to:
  /// **'Showing the most recent {count}.'**
  String earningsCapped(int count);

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Clearing'**
  String get statusPending;

  /// No description provided for @statusEligible.
  ///
  /// In en, this message translates to:
  /// **'Ready to pay'**
  String get statusEligible;

  /// No description provided for @statusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get statusPaid;

  /// No description provided for @statusReversed.
  ///
  /// In en, this message translates to:
  /// **'Reversed'**
  String get statusReversed;

  /// No description provided for @statusPendingWhy.
  ///
  /// In en, this message translates to:
  /// **'Held until the gym\'s refund window closes.'**
  String get statusPendingWhy;

  /// No description provided for @statusEligibleWhy.
  ///
  /// In en, this message translates to:
  /// **'Cleared. Waiting on payouts being switched on.'**
  String get statusEligibleWhy;

  /// No description provided for @statusPaidWhy.
  ///
  /// In en, this message translates to:
  /// **'Sent to your UPI ID.'**
  String get statusPaidWhy;

  /// No description provided for @statusReversedWhy.
  ///
  /// In en, this message translates to:
  /// **'The gym\'s payment was refunded, so this reward was taken back.'**
  String get statusReversedWhy;

  /// No description provided for @payoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Where your money goes'**
  String get payoutTitle;

  /// No description provided for @payoutsNotLive.
  ///
  /// In en, this message translates to:
  /// **'Payouts are not switched on yet. Rewards are counted and held until they are.'**
  String get payoutsNotLive;

  /// No description provided for @stillNeededTitle.
  ///
  /// In en, this message translates to:
  /// **'Still needed'**
  String get stillNeededTitle;

  /// No description provided for @payoutInFlight.
  ///
  /// In en, this message translates to:
  /// **'A payout is on its way. These can be changed once it settles.'**
  String get payoutInFlight;

  /// No description provided for @upiSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'UPI ID'**
  String get upiSectionTitle;

  /// No description provided for @upiIdLabel.
  ///
  /// In en, this message translates to:
  /// **'UPI ID'**
  String get upiIdLabel;

  /// No description provided for @upiIdHint.
  ///
  /// In en, this message translates to:
  /// **'name@bank'**
  String get upiIdHint;

  /// No description provided for @holderNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name on the account'**
  String get holderNameLabel;

  /// No description provided for @upiNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get upiNotSet;

  /// No description provided for @upiVerifiedYes.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get upiVerifiedYes;

  /// No description provided for @upiVerifiedNo.
  ///
  /// In en, this message translates to:
  /// **'Not verified yet'**
  String get upiVerifiedNo;

  /// No description provided for @upiTypoWarning.
  ///
  /// In en, this message translates to:
  /// **'Check this character by character. A UPI ID has no spell-check: a one-letter slip is somebody else\'s perfectly valid address, and money sent there cannot be brought back.'**
  String get upiTypoWarning;

  /// No description provided for @upiChangedClearsVerification.
  ///
  /// In en, this message translates to:
  /// **'Changing this clears the verification. The address will be checked again before the first payout.'**
  String get upiChangedClearsVerification;

  /// No description provided for @holderNameWhy.
  ///
  /// In en, this message translates to:
  /// **'The ₹10 check comes back with the name your bank has on that account. Without a name to compare it against, the check only proves the address exists -- not that it is yours.'**
  String get holderNameWhy;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved.'**
  String get saved;

  /// No description provided for @invalidUpi.
  ///
  /// In en, this message translates to:
  /// **'That does not look like a UPI ID. It should look like name@bank.'**
  String get invalidUpi;

  /// No description provided for @holderNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the name on the bank account.'**
  String get holderNameRequired;

  /// No description provided for @panSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'PAN'**
  String get panSectionTitle;

  /// No description provided for @panLabel.
  ///
  /// In en, this message translates to:
  /// **'PAN'**
  String get panLabel;

  /// No description provided for @panHint.
  ///
  /// In en, this message translates to:
  /// **'ABCDE1234F'**
  String get panHint;

  /// No description provided for @panNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get panNotSet;

  /// No description provided for @panWhy.
  ///
  /// In en, this message translates to:
  /// **'Needed before your earnings reach the point where tax has to be withheld. Not needed to start earning.'**
  String get panWhy;

  /// No description provided for @panStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Received, not checked yet'**
  String get panStatusPending;

  /// No description provided for @panStatusVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get panStatusVerified;

  /// No description provided for @panStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Not accepted. Check the number and send it again.'**
  String get panStatusRejected;

  /// No description provided for @invalidPan.
  ///
  /// In en, this message translates to:
  /// **'That does not look like a PAN. It should look like ABCDE1234F.'**
  String get invalidPan;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Your profile'**
  String get profileTitle;

  /// No description provided for @languageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageTitle;

  /// No description provided for @languageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the language you read most comfortably'**
  String get languageSubtitle;

  /// No description provided for @useDeviceLanguage.
  ///
  /// In en, this message translates to:
  /// **'Use device language'**
  String get useDeviceLanguage;

  /// No description provided for @needsReview.
  ///
  /// In en, this message translates to:
  /// **'Translation pending review'**
  String get needsReview;

  /// No description provided for @untranslatedFallbackNote.
  ///
  /// In en, this message translates to:
  /// **'Anything not yet translated is shown in English rather than left blank, so a partly translated language is still usable.'**
  String get untranslatedFallbackNote;

  /// No description provided for @legalTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms and privacy'**
  String get legalTitle;

  /// No description provided for @legalUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Could not load this right now.'**
  String get legalUnavailable;

  /// No description provided for @supportTitle.
  ///
  /// In en, this message translates to:
  /// **'Need help?'**
  String get supportTitle;

  /// No description provided for @supportBody.
  ///
  /// In en, this message translates to:
  /// **'Tell us what happened and we will come back to you.'**
  String get supportBody;

  /// No description provided for @supportSubject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get supportSubject;

  /// No description provided for @supportMessage.
  ///
  /// In en, this message translates to:
  /// **'What happened?'**
  String get supportMessage;

  /// No description provided for @supportSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get supportSend;

  /// No description provided for @supportSent.
  ///
  /// In en, this message translates to:
  /// **'Sent. We will get back to you.'**
  String get supportSent;

  /// No description provided for @supportEmailLine.
  ///
  /// In en, this message translates to:
  /// **'Or write to {email}.'**
  String supportEmailLine(String email);

  /// No description provided for @supportTooShort.
  ///
  /// In en, this message translates to:
  /// **'A sentence or two, so we know what to look at.'**
  String get supportTooShort;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @signOutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Sign out on this device?'**
  String get signOutConfirm;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTitle;

  /// No description provided for @sessionExpiredSignIn.
  ///
  /// In en, this message translates to:
  /// **'Your session has ended. Please sign in again.'**
  String get sessionExpiredSignIn;

  /// No description provided for @serverTookTooLong.
  ///
  /// In en, this message translates to:
  /// **'The server took too long to answer. Check your connection and try again.'**
  String get serverTookTooLong;

  /// No description provided for @couldNotReachServer.
  ///
  /// In en, this message translates to:
  /// **'Could not reach {host}. Check your internet connection.'**
  String couldNotReachServer(String host);

  /// No description provided for @certificateNotVerified.
  ///
  /// In en, this message translates to:
  /// **'The server certificate could not be verified.'**
  String get certificateNotVerified;

  /// No description provided for @networkErrorTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please try again.'**
  String get networkErrorTryAgain;

  /// No description provided for @footerLine.
  ///
  /// In en, this message translates to:
  /// **'Gymologia Referral'**
  String get footerLine;

  /// No description provided for @footerSupport.
  ///
  /// In en, this message translates to:
  /// **'support@gymologia.com'**
  String get footerSupport;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'bn',
    'en',
    'gu',
    'hi',
    'kn',
    'ml',
    'mr',
    'pa',
    'ta',
    'te',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
    case 'gu':
      return AppLocalizationsGu();
    case 'hi':
      return AppLocalizationsHi();
    case 'kn':
      return AppLocalizationsKn();
    case 'ml':
      return AppLocalizationsMl();
    case 'mr':
      return AppLocalizationsMr();
    case 'pa':
      return AppLocalizationsPa();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
