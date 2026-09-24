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

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Gymologia'**
  String get appName;

  /// This language's own name, shown in the language picker. Always written in the language itself, because someone looking for their language cannot read the list in a language they do not have.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageName;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the language you read most comfortably'**
  String get languageSubtitle;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @enterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number'**
  String get enterPhoneNumber;

  /// No description provided for @sendCode.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get sendCode;

  /// No description provided for @verifyCode.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verifyCode;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Send it again'**
  String get resendCode;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get createAccount;

  /// No description provided for @emailOptional.
  ///
  /// In en, this message translates to:
  /// **'Email (optional)'**
  String get emailOptional;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @whyAgeNotBirthday.
  ///
  /// In en, this message translates to:
  /// **'We ask for your age, not your date of birth. A date of birth is tied to your bank and government records — an age is all a gym app needs.'**
  String get whyAgeNotBirthday;

  /// No description provided for @termsAgreement.
  ///
  /// In en, this message translates to:
  /// **'Creating an account means you accept the Terms of Use and Privacy Policy.'**
  String get termsAgreement;

  /// No description provided for @consentCheckboxLabel.
  ///
  /// In en, this message translates to:
  /// **'I have read and agree to the Terms of Use and Privacy Policy.'**
  String get consentCheckboxLabel;

  /// No description provided for @consentRequired.
  ///
  /// In en, this message translates to:
  /// **'You must agree to the Terms and Privacy Policy to continue.'**
  String get consentRequired;

  /// No description provided for @under18GuardianNotice.
  ///
  /// In en, this message translates to:
  /// **'You are under 18. A parent or guardian must verify their consent by OTP before your account can be fully activated. Our support team will contact you after sign-up.'**
  String get under18GuardianNotice;

  /// No description provided for @shareProgressWithGym.
  ///
  /// In en, this message translates to:
  /// **'Share my measurements with {gym} staff'**
  String shareProgressWithGym(String gym);

  /// No description provided for @shareProgressWithGymHint.
  ///
  /// In en, this message translates to:
  /// **'Your trainer can see your weight and height only while this is on. Off by default — you choose to turn it on.'**
  String get shareProgressWithGymHint;

  /// No description provided for @monitoringTurnedOn.
  ///
  /// In en, this message translates to:
  /// **'Staff can now see your progress.'**
  String get monitoringTurnedOn;

  /// No description provided for @monitoringTurnedOff.
  ///
  /// In en, this message translates to:
  /// **'Staff can no longer see your progress.'**
  String get monitoringTurnedOff;

  /// No description provided for @couldNotUpdateSetting.
  ///
  /// In en, this message translates to:
  /// **'Could not update this setting.'**
  String get couldNotUpdateSetting;

  /// No description provided for @downloadMyData.
  ///
  /// In en, this message translates to:
  /// **'Download my data'**
  String get downloadMyData;

  /// No description provided for @downloadMyDataHint.
  ///
  /// In en, this message translates to:
  /// **'Everything Gymologia holds about your account, as JSON. Encrypted fields such as identity documents are not included in readable form.'**
  String get downloadMyDataHint;

  /// No description provided for @copyToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copy to clipboard'**
  String get copyToClipboard;

  /// No description provided for @yourData.
  ///
  /// In en, this message translates to:
  /// **'Your data'**
  String get yourData;

  /// No description provided for @theirAge.
  ///
  /// In en, this message translates to:
  /// **'Their age'**
  String get theirAge;

  /// No description provided for @enterAValidAge.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid age.'**
  String get enterAValidAge;

  /// No description provided for @guardianConsentRequired.
  ///
  /// In en, this message translates to:
  /// **'A parent or guardian\'s consent is required before this person can be added.'**
  String get guardianConsentRequired;

  /// No description provided for @guardianConsentExplainer.
  ///
  /// In en, this message translates to:
  /// **'This person is under 18. Before adding them, confirm a parent or guardian has verified their consent (by phone, in person, or in writing).'**
  String get guardianConsentExplainer;

  /// No description provided for @guardianConsentCheckboxLabel.
  ///
  /// In en, this message translates to:
  /// **'I confirm a parent or guardian has given verified consent.'**
  String get guardianConsentCheckboxLabel;

  /// No description provided for @guardianPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Parent/guardian\'s mobile number'**
  String get guardianPhoneLabel;

  /// No description provided for @guardianCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Code from guardian\'s phone'**
  String get guardianCodeLabel;

  /// No description provided for @guardianVerifiedConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Guardian consent verified.'**
  String get guardianVerifiedConfirmation;

  /// No description provided for @guardianConsentBlocksSubmit.
  ///
  /// In en, this message translates to:
  /// **'Verify your guardian\'s consent above before creating the account.'**
  String get guardianConsentBlocksSubmit;

  /// No description provided for @signInWithMobile.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your mobile number'**
  String get signInWithMobile;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get mobileNumber;

  /// No description provided for @couldNotSendCode.
  ///
  /// In en, this message translates to:
  /// **'Could not send the code.'**
  String get couldNotSendCode;

  /// No description provided for @verificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Verification failed.'**
  String get verificationFailed;

  /// No description provided for @couldNotResendCode.
  ///
  /// In en, this message translates to:
  /// **'Could not resend the code.'**
  String get couldNotResendCode;

  /// No description provided for @couldNotCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Could not create your account.'**
  String get couldNotCreateAccount;

  /// No description provided for @weSentCodeTo.
  ///
  /// In en, this message translates to:
  /// **'We sent a code to {phone}'**
  String weSentCodeTo(String phone);

  /// No description provided for @resendInSeconds.
  ///
  /// In en, this message translates to:
  /// **'Resend in {seconds}s'**
  String resendInSeconds(int seconds);

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @createAccountAction.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccountAction;

  /// No description provided for @supportSent.
  ///
  /// In en, this message translates to:
  /// **'Sent. Someone will reply on the number you gave.'**
  String get supportSent;

  /// No description provided for @supportSubject.
  ///
  /// In en, this message translates to:
  /// **'What is this about?'**
  String get supportSubject;

  /// No description provided for @supportSubjectHint.
  ///
  /// In en, this message translates to:
  /// **'My membership days look wrong'**
  String get supportSubjectHint;

  /// No description provided for @supportMessage.
  ///
  /// In en, this message translates to:
  /// **'Tell us what happened'**
  String get supportMessage;

  /// No description provided for @supportReplyTo.
  ///
  /// In en, this message translates to:
  /// **'Where should we reply?'**
  String get supportReplyTo;

  /// No description provided for @supportUrgent.
  ///
  /// In en, this message translates to:
  /// **'This is stopping my gym from operating'**
  String get supportUrgent;

  /// No description provided for @supportUrgentNote.
  ///
  /// In en, this message translates to:
  /// **'Raises the priority.'**
  String get supportUrgentNote;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'{value} copied'**
  String copiedToClipboard(String value);

  /// No description provided for @orEmailUs.
  ///
  /// In en, this message translates to:
  /// **'Or email {email}'**
  String orEmailUs(String email);

  /// No description provided for @whatYouHaveAsked.
  ///
  /// In en, this message translates to:
  /// **'WHAT YOU HAVE ASKED'**
  String get whatYouHaveAsked;

  /// No description provided for @aFewWordsIsEnough.
  ///
  /// In en, this message translates to:
  /// **'A few words is enough'**
  String get aFewWordsIsEnough;

  /// No description provided for @aSentenceOrTwoHelps.
  ///
  /// In en, this message translates to:
  /// **'A sentence or two helps us fix it faster'**
  String get aSentenceOrTwoHelps;

  /// No description provided for @ticketOpen.
  ///
  /// In en, this message translates to:
  /// **'Waiting for someone to pick it up'**
  String get ticketOpen;

  /// No description provided for @ticketInProgress.
  ///
  /// In en, this message translates to:
  /// **'Someone is looking at it'**
  String get ticketInProgress;

  /// No description provided for @ticketWaitingOnUser.
  ///
  /// In en, this message translates to:
  /// **'Waiting on your reply'**
  String get ticketWaitingOnUser;

  /// No description provided for @ticketResolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get ticketResolved;

  /// No description provided for @ticketClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get ticketClosed;

  /// No description provided for @referralPitch.
  ///
  /// In en, this message translates to:
  /// **'Share a code, and earn when a gym owner subscribes. The referral app is not out yet.'**
  String get referralPitch;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Gymologia · member and staff'**
  String get appTagline;

  /// No description provided for @signOutQuestion.
  ///
  /// In en, this message translates to:
  /// **'Sign out?'**
  String get signOutQuestion;

  /// No description provided for @signOutWarning.
  ///
  /// In en, this message translates to:
  /// **'You will need your phone to sign back in.'**
  String get signOutWarning;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated.'**
  String get profileUpdated;

  /// No description provided for @yourProfile.
  ///
  /// In en, this message translates to:
  /// **'Your profile'**
  String get yourProfile;

  /// No description provided for @emailClearToRemove.
  ///
  /// In en, this message translates to:
  /// **'Optional. Clear it to remove.'**
  String get emailClearToRemove;

  /// No description provided for @phoneIsYourLogin.
  ///
  /// In en, this message translates to:
  /// **'This is how you sign in, so it cannot be changed here yet. Contact support if you need it moved.'**
  String get phoneIsYourLogin;

  /// No description provided for @trialStarted.
  ///
  /// In en, this message translates to:
  /// **'Trial started. Your gym is now listed in search.'**
  String get trialStarted;

  /// No description provided for @invalidCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid code.'**
  String get invalidCode;

  /// No description provided for @paymentNotCompletedYet.
  ///
  /// In en, this message translates to:
  /// **'Payment has not completed yet. Pull to refresh in a moment.'**
  String get paymentNotCompletedYet;

  /// No description provided for @planIsActive.
  ///
  /// In en, this message translates to:
  /// **'{plan} plan is active.'**
  String planIsActive(String plan);

  /// No description provided for @paymentNotCompleted.
  ///
  /// In en, this message translates to:
  /// **'Payment was not completed.'**
  String get paymentNotCompleted;

  /// No description provided for @couldNotOpenPayment.
  ///
  /// In en, this message translates to:
  /// **'Could not open the payment screen.'**
  String get couldNotOpenPayment;

  /// No description provided for @daysFree.
  ///
  /// In en, this message translates to:
  /// **'{days} days free'**
  String daysFree(int days);

  /// No description provided for @trialBlurb.
  ///
  /// In en, this message translates to:
  /// **'Full Pro, including your listing in member search. No card needed, and it does not renew into a paid plan on its own.'**
  String get trialBlurb;

  /// No description provided for @startFreeTrial.
  ///
  /// In en, this message translates to:
  /// **'Start free trial'**
  String get startFreeTrial;

  /// No description provided for @referralCode.
  ///
  /// In en, this message translates to:
  /// **'Referral code'**
  String get referralCode;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @gstNote.
  ///
  /// In en, this message translates to:
  /// **'Prices include GST. A gym is only listed in member search on the Pro plan.'**
  String get gstNote;

  /// No description provided for @planNamed.
  ///
  /// In en, this message translates to:
  /// **'{plan} plan'**
  String planNamed(String plan);

  /// No description provided for @trialBadge.
  ///
  /// In en, this message translates to:
  /// **'TRIAL'**
  String get trialBadge;

  /// No description provided for @expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// No description provided for @daysRemainingPlan.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day remaining} other{{count} days remaining}}'**
  String daysRemainingPlan(int count);

  /// No description provided for @listedInSearch.
  ///
  /// In en, this message translates to:
  /// **'Listed in member search'**
  String get listedInSearch;

  /// No description provided for @notListedUpgrade.
  ///
  /// In en, this message translates to:
  /// **'Not listed in search — upgrade to Pro to appear'**
  String get notListedUpgrade;

  /// No description provided for @trialEndsNote.
  ///
  /// In en, this message translates to:
  /// **'When the trial ends your gym drops out of search until you choose a plan. Nothing is charged automatically.'**
  String get trialEndsNote;

  /// No description provided for @getsYouListed.
  ///
  /// In en, this message translates to:
  /// **'GETS YOU LISTED'**
  String get getsYouListed;

  /// No description provided for @perMonth.
  ///
  /// In en, this message translates to:
  /// **'/month'**
  String get perMonth;

  /// No description provided for @choosePlanNamed.
  ///
  /// In en, this message translates to:
  /// **'Choose {plan}'**
  String choosePlanNamed(String plan);

  /// No description provided for @deleteRoleWarning.
  ///
  /// In en, this message translates to:
  /// **'The role and its permissions go. Nobody is in it, so nobody loses access.'**
  String get deleteRoleWarning;

  /// No description provided for @deletedNamed.
  ///
  /// In en, this message translates to:
  /// **'{name} deleted'**
  String deletedNamed(String name);

  /// No description provided for @needTwoCustomRoles.
  ///
  /// In en, this message translates to:
  /// **'You need two custom roles you can edit before reordering.'**
  String get needTwoCustomRoles;

  /// No description provided for @hierarchySaved.
  ///
  /// In en, this message translates to:
  /// **'Hierarchy saved'**
  String get hierarchySaved;

  /// No description provided for @reorder.
  ///
  /// In en, this message translates to:
  /// **'Reorder'**
  String get reorder;

  /// No description provided for @newRole.
  ///
  /// In en, this message translates to:
  /// **'New role'**
  String get newRole;

  /// No description provided for @rolesIntro.
  ///
  /// In en, this message translates to:
  /// **'Listed most senior first. You can only edit roles below your own, and only hand out permissions you hold yourself.'**
  String get rolesIntro;

  /// No description provided for @defaultBadge.
  ///
  /// In en, this message translates to:
  /// **'DEFAULT'**
  String get defaultBadge;

  /// No description provided for @everyPermission.
  ///
  /// In en, this message translates to:
  /// **'Every permission, including any added later'**
  String get everyPermission;

  /// No description provided for @permissionCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 permission} other{{count} permissions}}'**
  String permissionCount(int count);

  /// No description provided for @nobodyInThisRole.
  ///
  /// In en, this message translates to:
  /// **'Nobody in this role'**
  String get nobodyInThisRole;

  /// No description provided for @peopleCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 person} other{{count} people}}'**
  String peopleCount(int count);

  /// No description provided for @deleteDefaultRolesStay.
  ///
  /// In en, this message translates to:
  /// **'Delete (default roles stay)'**
  String get deleteDefaultRolesStay;

  /// No description provided for @deleteMovePeopleFirst.
  ///
  /// In en, this message translates to:
  /// **'Delete (move people out first)'**
  String get deleteMovePeopleFirst;

  /// No description provided for @giveRoleAName.
  ///
  /// In en, this message translates to:
  /// **'Give the role a name'**
  String get giveRoleAName;

  /// No description provided for @editRole.
  ///
  /// In en, this message translates to:
  /// **'Edit role'**
  String get editRole;

  /// No description provided for @createRole.
  ///
  /// In en, this message translates to:
  /// **'Create role'**
  String get createRole;

  /// No description provided for @roleName.
  ///
  /// In en, this message translates to:
  /// **'Role name'**
  String get roleName;

  /// No description provided for @roleNameHint.
  ///
  /// In en, this message translates to:
  /// **'Front desk, Physio, Night shift'**
  String get roleNameHint;

  /// No description provided for @superRoleNote.
  ///
  /// In en, this message translates to:
  /// **'This role holds every permission, including any added in future. That cannot be narrowed — it is what makes it the role that can always fix things.'**
  String get superRoleNote;

  /// No description provided for @whatThisRoleCanDo.
  ///
  /// In en, this message translates to:
  /// **'What this role can do'**
  String get whatThisRoleCanDo;

  /// No description provided for @greyedOutNote.
  ///
  /// In en, this message translates to:
  /// **'Anything greyed out is something you do not hold yourself, so you cannot pass it on.'**
  String get greyedOutNote;

  /// No description provided for @ownerOnlyPermission.
  ///
  /// In en, this message translates to:
  /// **'Belongs to the gym owner alone'**
  String get ownerOnlyPermission;

  /// No description provided for @youDoNotHoldThis.
  ///
  /// In en, this message translates to:
  /// **'You do not hold this'**
  String get youDoNotHoldThis;

  /// No description provided for @orderTheHierarchy.
  ///
  /// In en, this message translates to:
  /// **'Order the hierarchy'**
  String get orderTheHierarchy;

  /// No description provided for @hierarchyNote.
  ///
  /// In en, this message translates to:
  /// **'Most senior at the top. Default roles keep their place and are not listed.'**
  String get hierarchyNote;

  /// No description provided for @saveOrder.
  ///
  /// In en, this message translates to:
  /// **'Save order'**
  String get saveOrder;

  /// No description provided for @membershipExtendedBy.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Membership extended by 1 month.} other{Membership extended by {count} months.}}'**
  String membershipExtendedBy(int count);

  /// No description provided for @goalUpdated.
  ///
  /// In en, this message translates to:
  /// **'Goal updated.'**
  String get goalUpdated;

  /// No description provided for @thisMember.
  ///
  /// In en, this message translates to:
  /// **'this member'**
  String get thisMember;

  /// No description provided for @removeMemberQuestion.
  ///
  /// In en, this message translates to:
  /// **'Remove member?'**
  String get removeMemberQuestion;

  /// No description provided for @removeMemberWarning.
  ///
  /// In en, this message translates to:
  /// **'{name} loses access to this gym. Their attendance history and measurements are kept.'**
  String removeMemberWarning(String name);

  /// No description provided for @member.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get member;

  /// No description provided for @removeMember.
  ///
  /// In en, this message translates to:
  /// **'Remove member'**
  String get removeMember;

  /// No description provided for @daysLeft.
  ///
  /// In en, this message translates to:
  /// **'Days left'**
  String get daysLeft;

  /// No description provided for @leaveUsed.
  ///
  /// In en, this message translates to:
  /// **'Leave used'**
  String get leaveUsed;

  /// No description provided for @extend.
  ///
  /// In en, this message translates to:
  /// **'Extend'**
  String get extend;

  /// No description provided for @editGoal.
  ///
  /// In en, this message translates to:
  /// **'Edit goal'**
  String get editGoal;

  /// No description provided for @goal.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get goal;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @noneAssigned.
  ///
  /// In en, this message translates to:
  /// **'None assigned'**
  String get noneAssigned;

  /// No description provided for @attendanceHistory.
  ///
  /// In en, this message translates to:
  /// **'Attendance history'**
  String get attendanceHistory;

  /// No description provided for @viewAndCorrectRecords.
  ///
  /// In en, this message translates to:
  /// **'View and correct records'**
  String get viewAndCorrectRecords;

  /// No description provided for @sessionsSoFar.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 session so far} other{{count} sessions so far}}'**
  String sessionsSoFar(int count);

  /// No description provided for @progressIsPrivate.
  ///
  /// In en, this message translates to:
  /// **'Progress is private'**
  String get progressIsPrivate;

  /// No description provided for @monitoringOffNote.
  ///
  /// In en, this message translates to:
  /// **'This member has turned off progress monitoring. That is their choice and no role can override it.'**
  String get monitoringOffNote;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// No description provided for @noMeasurementsYet.
  ///
  /// In en, this message translates to:
  /// **'No measurements recorded yet. The member is prompted for these in their own app once a month.'**
  String get noMeasurementsYet;

  /// No description provided for @holdingAtKg.
  ///
  /// In en, this message translates to:
  /// **'Holding at {kg} kg'**
  String holdingAtKg(String kg);

  /// No description provided for @weightChangeSince.
  ///
  /// In en, this message translates to:
  /// **'{delta} kg since their first measurement'**
  String weightChangeSince(String delta);

  /// No description provided for @extendMembership.
  ///
  /// In en, this message translates to:
  /// **'Extend membership'**
  String get extendMembership;

  /// No description provided for @extendFromTodayNote.
  ///
  /// In en, this message translates to:
  /// **'An expired membership extends from today, not from the date it lapsed.'**
  String get extendFromTodayNote;

  /// No description provided for @monthsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 month} other{{count} months}}'**
  String monthsCount(int count);

  /// No description provided for @extendByMonths.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Extend by 1 month} other{Extend by {count} months}}'**
  String extendByMonths(int count);

  /// No description provided for @whatAreTheyWorkingTowards.
  ///
  /// In en, this message translates to:
  /// **'What are they working towards?'**
  String get whatAreTheyWorkingTowards;

  /// No description provided for @goalDialogHint.
  ///
  /// In en, this message translates to:
  /// **'Bulk up to 80kg, lose weight, rehab…'**
  String get goalDialogHint;

  /// No description provided for @signedUpCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 signed up} other{{count} signed up}}'**
  String signedUpCount(int count);

  /// No description provided for @nobodyYet.
  ///
  /// In en, this message translates to:
  /// **'Nobody yet.'**
  String get nobodyYet;

  /// No description provided for @hostAnEvent.
  ///
  /// In en, this message translates to:
  /// **'Host an event'**
  String get hostAnEvent;

  /// No description provided for @noEventsYet.
  ///
  /// In en, this message translates to:
  /// **'No events yet. Host one and it will show up for your members straight away.'**
  String get noEventsYet;

  /// No description provided for @editEvent.
  ///
  /// In en, this message translates to:
  /// **'Edit event'**
  String get editEvent;

  /// No description provided for @cancelEvent.
  ///
  /// In en, this message translates to:
  /// **'Cancel event'**
  String get cancelEvent;

  /// No description provided for @cancelEventConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel this event?'**
  String get cancelEventConfirmTitle;

  /// No description provided for @cancelEventConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'It will disappear from members\' event feed. Anyone already signed up stays on record, and this cannot be undone from here.'**
  String get cancelEventConfirmBody;

  /// No description provided for @keepEvent.
  ///
  /// In en, this message translates to:
  /// **'Keep event'**
  String get keepEvent;

  /// No description provided for @eventCancelledBadge.
  ///
  /// In en, this message translates to:
  /// **'CANCELLED'**
  String get eventCancelledBadge;

  /// No description provided for @eventUpdated.
  ///
  /// In en, this message translates to:
  /// **'Event updated'**
  String get eventUpdated;

  /// No description provided for @eventCancelledSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Event cancelled'**
  String get eventCancelledSnackbar;

  /// No description provided for @eventTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Summer Deadlift Meet'**
  String get eventTitleHint;

  /// No description provided for @howToTakePart.
  ///
  /// In en, this message translates to:
  /// **'How to take part'**
  String get howToTakePart;

  /// No description provided for @howToTakePartHint.
  ///
  /// In en, this message translates to:
  /// **'Weigh-in at 8am. Bring your own belt.'**
  String get howToTakePartHint;

  /// No description provided for @prizeOptional.
  ///
  /// In en, this message translates to:
  /// **'Prize (optional)'**
  String get prizeOptional;

  /// No description provided for @prizeHint.
  ///
  /// In en, this message translates to:
  /// **'Rs 10,000'**
  String get prizeHint;

  /// No description provided for @membersCanSignUp.
  ///
  /// In en, this message translates to:
  /// **'Members can sign up in the app'**
  String get membersCanSignUp;

  /// No description provided for @membersCanSignUpNote.
  ///
  /// In en, this message translates to:
  /// **'Turn off and they see your requirements instead of a button.'**
  String get membersCanSignUpNote;

  /// No description provided for @listPublicly.
  ///
  /// In en, this message translates to:
  /// **'List publicly'**
  String get listPublicly;

  /// No description provided for @listPubliclyNote.
  ///
  /// In en, this message translates to:
  /// **'Shows in the events feed across the country.'**
  String get listPubliclyNote;

  /// No description provided for @listPubliclyProOnly.
  ///
  /// In en, this message translates to:
  /// **'Pro plan only. Your members will still see it.'**
  String get listPubliclyProOnly;

  /// No description provided for @openToOutsiders.
  ///
  /// In en, this message translates to:
  /// **'Open to people outside your gym'**
  String get openToOutsiders;

  /// No description provided for @publishEvent.
  ///
  /// In en, this message translates to:
  /// **'Publish event'**
  String get publishEvent;

  /// No description provided for @registrationOpen.
  ///
  /// In en, this message translates to:
  /// **'registration open'**
  String get registrationOpen;

  /// No description provided for @registrationClosed.
  ///
  /// In en, this message translates to:
  /// **'registration closed'**
  String get registrationClosed;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get markAllRead;

  /// No description provided for @nothingYet.
  ///
  /// In en, this message translates to:
  /// **'Nothing yet'**
  String get nothingYet;

  /// No description provided for @announcementsAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Announcements from your gym and from Gymologia will appear here.'**
  String get announcementsAppearHere;

  /// No description provided for @searchPeople.
  ///
  /// In en, this message translates to:
  /// **'Search people'**
  String get searchPeople;

  /// No description provided for @nobodyElseHereYet.
  ///
  /// In en, this message translates to:
  /// **'Nobody else here yet.'**
  String get nobodyElseHereYet;

  /// No description provided for @nameTheGroup.
  ///
  /// In en, this message translates to:
  /// **'Name the group'**
  String get nameTheGroup;

  /// No description provided for @groupNameHint.
  ///
  /// In en, this message translates to:
  /// **'Saturday morning crew'**
  String get groupNameHint;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @pickWhoIsInTheGroup.
  ///
  /// In en, this message translates to:
  /// **'Pick who is in the group'**
  String get pickWhoIsInTheGroup;

  /// No description provided for @createGroupWith.
  ///
  /// In en, this message translates to:
  /// **'Create group with {count}'**
  String createGroupWith(int count);

  /// No description provided for @termsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get termsOfUse;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @versionUpdated.
  ///
  /// In en, this message translates to:
  /// **'Version {version} · updated {date}'**
  String versionUpdated(String version, String date);

  /// No description provided for @sessionsAttendedAllTime.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{session attended, all time} other{sessions attended, all time}}'**
  String sessionsAttendedAllTime(int count);

  /// No description provided for @nothingInLast60Days.
  ///
  /// In en, this message translates to:
  /// **'Nothing recorded in the last 60 days.'**
  String get nothingInLast60Days;

  /// No description provided for @correctedReason.
  ///
  /// In en, this message translates to:
  /// **'Corrected: {reason}'**
  String correctedReason(String reason);

  /// No description provided for @noReasonGiven.
  ///
  /// In en, this message translates to:
  /// **'no reason given'**
  String get noReasonGiven;

  /// No description provided for @keptWithRecordAuditNote.
  ///
  /// In en, this message translates to:
  /// **'This is kept with the record and shows in the audit log.'**
  String get keptWithRecordAuditNote;

  /// No description provided for @staffBadge.
  ///
  /// In en, this message translates to:
  /// **'STAFF'**
  String get staffBadge;

  /// No description provided for @draftCrmNote.
  ///
  /// In en, this message translates to:
  /// **'Your gym is a draft. The CRM works, but members cannot find you in search until a plan is active.'**
  String get draftCrmNote;

  /// No description provided for @roleHiddenNote.
  ///
  /// In en, this message translates to:
  /// **'You are {role} here. Anything your role cannot do is hidden rather than shown and refused.'**
  String roleHiddenNote(String role);

  /// No description provided for @engagedOfActive.
  ///
  /// In en, this message translates to:
  /// **'{engaged} of {total} members trained at least once.'**
  String engagedOfActive(int engaged, int total);

  /// No description provided for @announceGoesTo.
  ///
  /// In en, this message translates to:
  /// **'It goes to {audience} right now, and cannot be unsent.'**
  String announceGoesTo(String audience);

  /// No description provided for @audienceEveryMember.
  ///
  /// In en, this message translates to:
  /// **'every member'**
  String get audienceEveryMember;

  /// No description provided for @audienceEveryStaff.
  ///
  /// In en, this message translates to:
  /// **'every staff member'**
  String get audienceEveryStaff;

  /// No description provided for @audienceEveryone.
  ///
  /// In en, this message translates to:
  /// **'everyone at this gym'**
  String get audienceEveryone;

  /// No description provided for @sentToPeople.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Sent to 1 person.} other{Sent to {count} people.}}'**
  String sentToPeople(int count);

  /// No description provided for @recipientCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 recipient} other{{count} recipients}}'**
  String recipientCount(int count);

  /// No description provided for @weTextACodeFirst.
  ///
  /// In en, this message translates to:
  /// **'We text a code to their number first, so you know it is really theirs.'**
  String get weTextACodeFirst;

  /// No description provided for @memberCanUpdateMetrics.
  ///
  /// In en, this message translates to:
  /// **'They can see and update their weight and height in the member app. Their progress is visible to staff unless they turn that off themselves.'**
  String get memberCanUpdateMetrics;

  /// No description provided for @noRolesYouCanAssign.
  ///
  /// In en, this message translates to:
  /// **'There are no roles you can assign. Only roles junior to your own can be given out.'**
  String get noRolesYouCanAssign;

  /// No description provided for @noRolesYouCanAssignToThem.
  ///
  /// In en, this message translates to:
  /// **'There are no roles you can assign to them.'**
  String get noRolesYouCanAssignToThem;

  /// No description provided for @heightCm.
  ///
  /// In en, this message translates to:
  /// **'Height {cm} cm'**
  String heightCm(String cm);

  /// No description provided for @weightOverCheckIns.
  ///
  /// In en, this message translates to:
  /// **'{delta} kg over {count} check-ins'**
  String weightOverCheckIns(String delta, int count);

  /// No description provided for @useDeviceLanguage.
  ///
  /// In en, this message translates to:
  /// **'Use device language'**
  String get useDeviceLanguage;

  /// No description provided for @untranslatedFallbackNote.
  ///
  /// In en, this message translates to:
  /// **'Anything not yet translated is shown in English rather than left blank, so a partly translated language is still usable.'**
  String get untranslatedFallbackNote;

  /// No description provided for @deleteGymWarning.
  ///
  /// In en, this message translates to:
  /// **'All {members} members and {staff} staff lose access. This cannot be undone from the app.'**
  String deleteGymWarning(int members, int staff);

  /// No description provided for @shownAsInSearch.
  ///
  /// In en, this message translates to:
  /// **'Shown as “{name} - {district}” in search.'**
  String shownAsInSearch(String name, String district);

  /// No description provided for @nothingWaitingLeave.
  ///
  /// In en, this message translates to:
  /// **'Nothing waiting. Requests inside your limits are approved automatically and never appear here.'**
  String get nothingWaitingLeave;

  /// No description provided for @quietPeriodsNote.
  ///
  /// In en, this message translates to:
  /// **'Quiet periods are shown as empty bars rather than left out, so a gap in the bars is a real gap.'**
  String get quietPeriodsNote;

  /// No description provided for @rankingExplainer.
  ///
  /// In en, this message translates to:
  /// **'Position is worked out the same way search orders results: rating first, then how many ratings back it up. What you see here is what a member browsing would see.'**
  String get rankingExplainer;

  /// No description provided for @deleteTrainerCategoryWarning.
  ///
  /// In en, this message translates to:
  /// **'Trainers can no longer be put in this category. Anyone already in it keeps their assignment.'**
  String get deleteTrainerCategoryWarning;

  /// No description provided for @youLabel.
  ///
  /// In en, this message translates to:
  /// **'you'**
  String get youLabel;

  /// No description provided for @openEvents.
  ///
  /// In en, this message translates to:
  /// **'OPEN EVENTS'**
  String get openEvents;

  /// No description provided for @nothingHereYetSaySomething.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet. Say something.'**
  String get nothingHereYetSaySomething;

  /// No description provided for @leavePausesMembership.
  ///
  /// In en, this message translates to:
  /// **'Your membership pauses while you are away, so you keep the days you paid for.'**
  String get leavePausesMembership;

  /// No description provided for @notListedUntilPlan.
  ///
  /// In en, this message translates to:
  /// **'Not listed publicly until a plan is active.'**
  String get notListedUntilPlan;

  /// No description provided for @gymsListedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 gym listed} other{{count} gyms listed}}'**
  String gymsListedCount(int count);

  /// No description provided for @checkInGoalNote.
  ///
  /// In en, this message translates to:
  /// **'Your gym uses this to track progress towards your goal.'**
  String get checkInGoalNote;

  /// No description provided for @enterYourGymName.
  ///
  /// In en, this message translates to:
  /// **'Enter your gym name'**
  String get enterYourGymName;

  /// No description provided for @sessionExpiredSignIn.
  ///
  /// In en, this message translates to:
  /// **'Your session expired. Please sign in again.'**
  String get sessionExpiredSignIn;

  /// No description provided for @somethingWentWrongTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get somethingWentWrongTryAgain;

  /// No description provided for @serverTookTooLong.
  ///
  /// In en, this message translates to:
  /// **'The server took too long to respond. Check your connection and try again.'**
  String get serverTookTooLong;

  /// No description provided for @couldNotReachServer.
  ///
  /// In en, this message translates to:
  /// **'Could not reach the server at {host}. Check your internet connection.'**
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

  /// No description provided for @enterValidMobile.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 10-digit Indian mobile number'**
  String get enterValidMobile;

  /// No description provided for @enterValidTenDigitNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 10-digit number'**
  String get enterValidTenDigitNumber;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// No description provided for @nameTooLong.
  ///
  /// In en, this message translates to:
  /// **'That name is too long'**
  String get nameTooLong;

  /// No description provided for @enterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get enterValidEmail;

  /// No description provided for @enterYourAge.
  ///
  /// In en, this message translates to:
  /// **'Enter your age'**
  String get enterYourAge;

  /// No description provided for @mustBeAtLeast13.
  ///
  /// In en, this message translates to:
  /// **'You must be at least 13'**
  String get mustBeAtLeast13;

  /// No description provided for @enterValidAge.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid age'**
  String get enterValidAge;

  /// No description provided for @enterWeightOrHeight.
  ///
  /// In en, this message translates to:
  /// **'Enter a weight or a height.'**
  String get enterWeightOrHeight;

  /// No description provided for @noRatingsYet.
  ///
  /// In en, this message translates to:
  /// **'No ratings yet'**
  String get noRatingsYet;

  /// No description provided for @giveItATitle.
  ///
  /// In en, this message translates to:
  /// **'Give it a title.'**
  String get giveItATitle;

  /// No description provided for @sayWhatYouWantThemToKnow.
  ///
  /// In en, this message translates to:
  /// **'Say what you want them to know.'**
  String get sayWhatYouWantThemToKnow;

  /// No description provided for @sayWhyThisIsChanging.
  ///
  /// In en, this message translates to:
  /// **'Say why this is being changed.'**
  String get sayWhyThisIsChanging;

  /// No description provided for @noMembersYetAddFirst.
  ///
  /// In en, this message translates to:
  /// **'No members yet. Add your first one.'**
  String get noMembersYetAddFirst;

  /// No description provided for @nobodyMatchedSearch.
  ///
  /// In en, this message translates to:
  /// **'Nobody matched that search.'**
  String get nobodyMatchedSearch;

  /// No description provided for @turningUp.
  ///
  /// In en, this message translates to:
  /// **'Turning up'**
  String get turningUp;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get justNow;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String minutesAgo(int count);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String hoursAgo(int count);

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String daysAgo(int count);

  /// No description provided for @monthsAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}mo ago'**
  String monthsAgo(int count);

  /// No description provided for @nowShort.
  ///
  /// In en, this message translates to:
  /// **'now'**
  String get nowShort;

  /// No description provided for @minutesShort.
  ///
  /// In en, this message translates to:
  /// **'{count}m'**
  String minutesShort(int count);

  /// No description provided for @hoursShort.
  ///
  /// In en, this message translates to:
  /// **'{count}h'**
  String hoursShort(int count);

  /// No description provided for @daysShort.
  ///
  /// In en, this message translates to:
  /// **'{count}d'**
  String daysShort(int count);

  /// No description provided for @weeksShort.
  ///
  /// In en, this message translates to:
  /// **'{count}w'**
  String weeksShort(int count);

  /// No description provided for @addedNamed.
  ///
  /// In en, this message translates to:
  /// **'{name} added'**
  String addedNamed(String name);

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @trainerCategoriesIntro.
  ///
  /// In en, this message translates to:
  /// **'Trainers are put in one of these when they are added. A category holding trainers cannot be deleted until they are moved.'**
  String get trainerCategoriesIntro;

  /// No description provided for @trainerCategoriesReadOnly.
  ///
  /// In en, this message translates to:
  /// **'You can see the categories at this gym. Changing them needs the manage-trainers permission.'**
  String get trainerCategoriesReadOnly;

  /// No description provided for @oneTrainerManyMembersShort.
  ///
  /// In en, this message translates to:
  /// **'One trainer, many members'**
  String get oneTrainerManyMembersShort;

  /// No description provided for @oneMemberPerTrainer.
  ///
  /// In en, this message translates to:
  /// **'One member per trainer'**
  String get oneMemberPerTrainer;

  /// No description provided for @noTrainers.
  ///
  /// In en, this message translates to:
  /// **'No trainers'**
  String get noTrainers;

  /// No description provided for @trainerCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 trainer} other{{count} trainers}}'**
  String trainerCount(int count);

  /// No description provided for @deleteMoveTrainersFirst.
  ///
  /// In en, this message translates to:
  /// **'Delete (move trainers first)'**
  String get deleteMoveTrainersFirst;

  /// No description provided for @giveCategoryAName.
  ///
  /// In en, this message translates to:
  /// **'Give the category a name'**
  String get giveCategoryAName;

  /// No description provided for @editCategory.
  ///
  /// In en, this message translates to:
  /// **'Edit category'**
  String get editCategory;

  /// No description provided for @newTrainerCategory.
  ///
  /// In en, this message translates to:
  /// **'New trainer category'**
  String get newTrainerCategory;

  /// No description provided for @generalTrainingNote.
  ///
  /// In en, this message translates to:
  /// **'The usual setting for general training.'**
  String get generalTrainingNote;

  /// No description provided for @personalTrainingNote.
  ///
  /// In en, this message translates to:
  /// **'Personal training: a trainer here takes one member at a time.'**
  String get personalTrainingNote;

  /// No description provided for @addCategory.
  ///
  /// In en, this message translates to:
  /// **'Add category'**
  String get addCategory;

  /// No description provided for @listedPublicly.
  ///
  /// In en, this message translates to:
  /// **'Listed publicly'**
  String get listedPublicly;

  /// No description provided for @yourMembersOnly.
  ///
  /// In en, this message translates to:
  /// **'Your members only'**
  String get yourMembersOnly;

  /// No description provided for @whenDoesItStart.
  ///
  /// In en, this message translates to:
  /// **'When does it start?'**
  String get whenDoesItStart;

  /// No description provided for @chooseStartDateFirst.
  ///
  /// In en, this message translates to:
  /// **'Choose the start date first.'**
  String get chooseStartDateFirst;

  /// No description provided for @lastDayToRegister.
  ///
  /// In en, this message translates to:
  /// **'Last day to register'**
  String get lastDayToRegister;

  /// No description provided for @giveTheEventATitle.
  ///
  /// In en, this message translates to:
  /// **'Give the event a title.'**
  String get giveTheEventATitle;

  /// No description provided for @addADescription.
  ///
  /// In en, this message translates to:
  /// **'Add a description, at least a sentence.'**
  String get addADescription;

  /// No description provided for @sayHowToTakePart.
  ///
  /// In en, this message translates to:
  /// **'Say what someone has to do to take part.'**
  String get sayHowToTakePart;

  /// No description provided for @pickTheDates.
  ///
  /// In en, this message translates to:
  /// **'Pick the dates.'**
  String get pickTheDates;

  /// No description provided for @startsAtWhen.
  ///
  /// In en, this message translates to:
  /// **'Starts {when}'**
  String startsAtWhen(String when);

  /// No description provided for @registerByWhen.
  ///
  /// In en, this message translates to:
  /// **'Register by {when}'**
  String registerByWhen(String when);

  /// No description provided for @selectYourLeaveDates.
  ///
  /// In en, this message translates to:
  /// **'Select your leave dates'**
  String get selectYourLeaveDates;

  /// No description provided for @chooseYourDatesFirst.
  ///
  /// In en, this message translates to:
  /// **'Choose your dates first.'**
  String get chooseYourDatesFirst;

  /// No description provided for @sentForApproval.
  ///
  /// In en, this message translates to:
  /// **'Sent for approval.'**
  String get sentForApproval;

  /// No description provided for @leaveApprovedPaused.
  ///
  /// In en, this message translates to:
  /// **'Leave approved. Your membership is paused for those days.'**
  String get leaveApprovedPaused;

  /// No description provided for @chooseDates.
  ///
  /// In en, this message translates to:
  /// **'Choose dates'**
  String get chooseDates;

  /// No description provided for @leaveDaysLeftCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{You have 1 leave day left.} other{You have {count} leave days left.}}'**
  String leaveDaysLeftCount(int count);

  /// No description provided for @moreThanRemainingDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{That is more than your 1 remaining day, so a manager will need to approve it.} other{That is more than your {count} remaining days, so a manager will need to approve it.}}'**
  String moreThanRemainingDays(int count);

  /// No description provided for @withinYourAllowance.
  ///
  /// In en, this message translates to:
  /// **'Within your allowance — this will be approved straight away.'**
  String get withinYourAllowance;

  /// No description provided for @sendForApproval.
  ///
  /// In en, this message translates to:
  /// **'Send for approval'**
  String get sendForApproval;

  /// No description provided for @enterCodeSentToTheirPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter the code sent to their phone.'**
  String get enterCodeSentToTheirPhone;

  /// No description provided for @numberIsNewNameNeeded.
  ///
  /// In en, this message translates to:
  /// **'This number is new, so a name is needed.'**
  String get numberIsNewNameNeeded;

  /// No description provided for @chooseARole.
  ///
  /// In en, this message translates to:
  /// **'Choose a role.'**
  String get chooseARole;

  /// No description provided for @isATrainer.
  ///
  /// In en, this message translates to:
  /// **'Is a trainer?'**
  String get isATrainer;

  /// No description provided for @chooseATrainerCategory.
  ///
  /// In en, this message translates to:
  /// **'Choose a trainer category.'**
  String get chooseATrainerCategory;

  /// No description provided for @trainerCategory.
  ///
  /// In en, this message translates to:
  /// **'Trainer category'**
  String get trainerCategory;

  /// No description provided for @addAMember.
  ///
  /// In en, this message translates to:
  /// **'Add a member'**
  String get addAMember;

  /// No description provided for @codeSentExistingAccount.
  ///
  /// In en, this message translates to:
  /// **'Code sent. This number already has a Gymologia account.'**
  String get codeSentExistingAccount;

  /// No description provided for @codeSentNewAccount.
  ///
  /// In en, this message translates to:
  /// **'Code sent. This number is new, so we will create an account.'**
  String get codeSentNewAccount;

  /// No description provided for @membershipLength.
  ///
  /// In en, this message translates to:
  /// **'Membership length'**
  String get membershipLength;

  /// No description provided for @leaveDaysAllowed.
  ///
  /// In en, this message translates to:
  /// **'Leave days allowed'**
  String get leaveDaysAllowed;

  /// No description provided for @ownerStaffMode.
  ///
  /// In en, this message translates to:
  /// **'Owner / staff mode'**
  String get ownerStaffMode;

  /// No description provided for @memberMode.
  ///
  /// In en, this message translates to:
  /// **'Member mode'**
  String get memberMode;

  /// No description provided for @managingGymsNote.
  ///
  /// In en, this message translates to:
  /// **'You are managing gyms. Switch back to use Gymologia as a member.'**
  String get managingGymsNote;

  /// No description provided for @openingAGymNote.
  ///
  /// In en, this message translates to:
  /// **'Opening a gym, or working at one? Switch to run your gym\'s CRM — members, staff, attendance and leave.'**
  String get openingAGymNote;

  /// No description provided for @numberIsHowYouSignIn.
  ///
  /// In en, this message translates to:
  /// **'Your number is how you sign in, so it cannot be changed here yet.'**
  String get numberIsHowYouSignIn;

  /// No description provided for @followingYourDevice.
  ///
  /// In en, this message translates to:
  /// **'Following your device'**
  String get followingYourDevice;

  /// No description provided for @yourGym.
  ///
  /// In en, this message translates to:
  /// **'Your gym'**
  String get yourGym;

  /// No description provided for @weeksRunning.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Week running} other{Weeks running}}'**
  String weeksRunning(int count);

  /// No description provided for @noVisitsInLastDays.
  ///
  /// In en, this message translates to:
  /// **'No visits recorded in the last {days} days.'**
  String noVisitsInLastDays(int days);

  /// No description provided for @visitsInLastDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 visit in the last {days} days.} other{{count} visits in the last {days} days.}}'**
  String visitsInLastDays(int count, int days);

  /// No description provided for @couldNotLoadEvents.
  ///
  /// In en, this message translates to:
  /// **'Could not load events'**
  String get couldNotLoadEvents;

  /// No description provided for @noEventsOnRightNow.
  ///
  /// In en, this message translates to:
  /// **'No events on right now'**
  String get noEventsOnRightNow;

  /// No description provided for @eventsAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Events your gym runs show up here, along with anything open to everyone nearby.'**
  String get eventsAppearHere;

  /// No description provided for @atYourGym.
  ///
  /// In en, this message translates to:
  /// **'At your gym'**
  String get atYourGym;

  /// No description provided for @trainerStaffMembersAt.
  ///
  /// In en, this message translates to:
  /// **'Your trainer, staff and members at {gym}'**
  String trainerStaffMembersAt(String gym);

  /// No description provided for @trainerStaffOtherMembers.
  ///
  /// In en, this message translates to:
  /// **'Your trainer, the staff, and other members'**
  String get trainerStaffOtherMembers;

  /// No description provided for @comingNext.
  ///
  /// In en, this message translates to:
  /// **'Coming next'**
  String get comingNext;

  /// No description provided for @progressChartsAgainstGoal.
  ///
  /// In en, this message translates to:
  /// **'Progress charts against your goal'**
  String get progressChartsAgainstGoal;

  /// No description provided for @leaveLeft.
  ///
  /// In en, this message translates to:
  /// **'Leave left'**
  String get leaveLeft;

  /// No description provided for @approvedMembershipPauses.
  ///
  /// In en, this message translates to:
  /// **'{name} approved. Their membership pauses for those days.'**
  String approvedMembershipPauses(String name);

  /// No description provided for @approveInstead.
  ///
  /// In en, this message translates to:
  /// **'Approve instead'**
  String get approveInstead;

  /// No description provided for @declineInstead.
  ///
  /// In en, this message translates to:
  /// **'Decline instead'**
  String get declineInstead;

  /// No description provided for @needsYou.
  ///
  /// In en, this message translates to:
  /// **'Needs you'**
  String get needsYou;

  /// No description provided for @autoApproved.
  ///
  /// In en, this message translates to:
  /// **'Auto-approved'**
  String get autoApproved;

  /// No description provided for @returnedEarly.
  ///
  /// In en, this message translates to:
  /// **'Returned early'**
  String get returnedEarly;

  /// No description provided for @whereYouAre.
  ///
  /// In en, this message translates to:
  /// **'Where you are'**
  String get whereYouAre;

  /// No description provided for @enterTheAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter the address'**
  String get enterTheAddress;

  /// No description provided for @maximumPerMembership.
  ///
  /// In en, this message translates to:
  /// **'Maximum per membership'**
  String get maximumPerMembership;

  /// No description provided for @removeStaffWithAssigned.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{They lose access to this gym, and the 1 member assigned to them will have no trainer until you reassign someone.} other{They lose access to this gym, and the {count} members assigned to them will have no trainer until you reassign someone.}}'**
  String removeStaffWithAssigned(int count);

  /// No description provided for @removeStaffPlain.
  ///
  /// In en, this message translates to:
  /// **'They lose access to this gym. Their attendance history is kept.'**
  String get removeStaffPlain;

  /// No description provided for @couldNotLoadGyms.
  ///
  /// In en, this message translates to:
  /// **'Could not load gyms'**
  String get couldNotLoadGyms;

  /// No description provided for @noGymsListedYet.
  ///
  /// In en, this message translates to:
  /// **'No gyms listed yet'**
  String get noGymsListedYet;

  /// No description provided for @gymsAppearOnPro.
  ///
  /// In en, this message translates to:
  /// **'Gyms appear here once they are on the Pro plan and have chosen to be listed.'**
  String get gymsAppearOnPro;

  /// No description provided for @nothingMatchedTry.
  ///
  /// In en, this message translates to:
  /// **'Nothing matched “{query}”. Try a different city or district.'**
  String nothingMatchedTry(String query);

  /// No description provided for @noRatings.
  ///
  /// In en, this message translates to:
  /// **'No ratings'**
  String get noRatings;

  /// No description provided for @noPerksYet.
  ///
  /// In en, this message translates to:
  /// **'No perks listed yet'**
  String get noPerksYet;

  /// No description provided for @fromRatings.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{from 1 rating} other{from {count} ratings}}'**
  String fromRatings(int count);

  /// No description provided for @onlyProGymHere.
  ///
  /// In en, this message translates to:
  /// **'The only Pro gym here'**
  String get onlyProGymHere;

  /// No description provided for @ofProGyms.
  ///
  /// In en, this message translates to:
  /// **'of {count} Pro gyms'**
  String ofProGyms(int count);

  /// No description provided for @couldNotLoadYourGyms.
  ///
  /// In en, this message translates to:
  /// **'Could not load your gyms'**
  String get couldNotLoadYourGyms;

  /// No description provided for @noGymsYet.
  ///
  /// In en, this message translates to:
  /// **'No gyms yet'**
  String get noGymsYet;

  /// No description provided for @createYourGymBlurb.
  ///
  /// In en, this message translates to:
  /// **'Create your gym to set up members, staff, attendance and leave. If you work at a gym, ask the owner to add you and it will appear here.'**
  String get createYourGymBlurb;

  /// No description provided for @newGroupSelected.
  ///
  /// In en, this message translates to:
  /// **'New group ({count} selected)'**
  String newGroupSelected(int count);

  /// No description provided for @newMessage.
  ///
  /// In en, this message translates to:
  /// **'New message'**
  String get newMessage;

  /// No description provided for @oneToOne.
  ///
  /// In en, this message translates to:
  /// **'One to one'**
  String get oneToOne;

  /// No description provided for @group.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get group;

  /// No description provided for @buildMuscle.
  ///
  /// In en, this message translates to:
  /// **'Build muscle'**
  String get buildMuscle;

  /// No description provided for @loseFat.
  ///
  /// In en, this message translates to:
  /// **'Lose fat'**
  String get loseFat;

  /// No description provided for @getStronger.
  ///
  /// In en, this message translates to:
  /// **'Get stronger'**
  String get getStronger;

  /// No description provided for @officialGroupEmpty.
  ///
  /// In en, this message translates to:
  /// **'Everyone at this gym. Nothing said yet.'**
  String get officialGroupEmpty;

  /// No description provided for @unofficialGroupEmpty.
  ///
  /// In en, this message translates to:
  /// **'Members only. Nothing said yet.'**
  String get unofficialGroupEmpty;

  /// No description provided for @noMessagesYet.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get noMessagesYet;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// No description provided for @declined.
  ///
  /// In en, this message translates to:
  /// **'Declined'**
  String get declined;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @flexibility.
  ///
  /// In en, this message translates to:
  /// **'Flexibility'**
  String get flexibility;

  /// No description provided for @rehab.
  ///
  /// In en, this message translates to:
  /// **'Rehab'**
  String get rehab;

  /// No description provided for @youPrefix.
  ///
  /// In en, this message translates to:
  /// **'You: '**
  String get youPrefix;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @joined.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get joined;

  /// No description provided for @leftCount.
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get leftCount;

  /// No description provided for @net.
  ///
  /// In en, this message translates to:
  /// **'Net'**
  String get net;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearly;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @owner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get owner;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @machineTranslatedExercise.
  ///
  /// In en, this message translates to:
  /// **'These instructions were translated by machine and have not been checked by a coach. If a cue reads oddly, switch to English and compare before you lift.'**
  String get machineTranslatedExercise;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @myGym.
  ///
  /// In en, this message translates to:
  /// **'My gym'**
  String get myGym;

  /// No description provided for @discover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get discover;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// No description provided for @verifyYourNumber.
  ///
  /// In en, this message translates to:
  /// **'Verify your number'**
  String get verifyYourNumber;

  /// No description provided for @codeResent.
  ///
  /// In en, this message translates to:
  /// **'A new code is on its way.'**
  String get codeResent;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @connection.
  ///
  /// In en, this message translates to:
  /// **'Connection'**
  String get connection;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @session.
  ///
  /// In en, this message translates to:
  /// **'Session'**
  String get session;

  /// No description provided for @earnByReferring.
  ///
  /// In en, this message translates to:
  /// **'Earn by referring gyms'**
  String get earnByReferring;

  /// No description provided for @gyms.
  ///
  /// In en, this message translates to:
  /// **'Gyms'**
  String get gyms;

  /// No description provided for @events.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get events;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @findAGym.
  ///
  /// In en, this message translates to:
  /// **'Find a gym'**
  String get findAGym;

  /// No description provided for @searchGyms.
  ///
  /// In en, this message translates to:
  /// **'Search by name or locality'**
  String get searchGyms;

  /// No description provided for @perks.
  ///
  /// In en, this message translates to:
  /// **'Perks'**
  String get perks;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @onLeavePaused.
  ///
  /// In en, this message translates to:
  /// **'On leave — your membership is paused'**
  String get onLeavePaused;

  /// No description provided for @monthlyCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Monthly check-in'**
  String get monthlyCheckIn;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notNow;

  /// No description provided for @trainerNamed.
  ///
  /// In en, this message translates to:
  /// **'Trainer: {name}'**
  String trainerNamed(String name);

  /// No description provided for @goalAtGym.
  ///
  /// In en, this message translates to:
  /// **'YOUR GOAL AT {gym}'**
  String goalAtGym(String gym);

  /// No description provided for @daysRemaining.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Ends today} =1{1 day left} other{{count} days left}}'**
  String daysRemaining(int count);

  /// No description provided for @yourGoal.
  ///
  /// In en, this message translates to:
  /// **'Your goal'**
  String get yourGoal;

  /// No description provided for @trainer.
  ///
  /// In en, this message translates to:
  /// **'Trainer'**
  String get trainer;

  /// No description provided for @requestLeave.
  ///
  /// In en, this message translates to:
  /// **'Request leave'**
  String get requestLeave;

  /// No description provided for @yourProgress.
  ///
  /// In en, this message translates to:
  /// **'Your progress'**
  String get yourProgress;

  /// No description provided for @addMeasurementsPrompt.
  ///
  /// In en, this message translates to:
  /// **'Add your weight and height so your gym can track progress with you.'**
  String get addMeasurementsPrompt;

  /// No description provided for @progressSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Weight over time, and how often you have turned up.'**
  String get progressSubtitle;

  /// No description provided for @attendanceAppearsHere.
  ///
  /// In en, this message translates to:
  /// **'Attendance appears here once you are a member of a gym and staff start marking you in.'**
  String get attendanceAppearsHere;

  /// No description provided for @twoCheckInsDrawALine.
  ///
  /// In en, this message translates to:
  /// **'Two check-ins draw a line. Add your weight each month and this fills in.'**
  String get twoCheckInsDrawALine;

  /// No description provided for @nothingMatchesFilters.
  ///
  /// In en, this message translates to:
  /// **'Nothing matches those filters.'**
  String get nothingMatchesFilters;

  /// No description provided for @howToJoinGym.
  ///
  /// In en, this message translates to:
  /// **'To join, contact the gym directly. They will add you as a member.'**
  String get howToJoinGym;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @yourMeasurements.
  ///
  /// In en, this message translates to:
  /// **'Your measurements'**
  String get yourMeasurements;

  /// No description provided for @checkInDue.
  ///
  /// In en, this message translates to:
  /// **'This month\'s check-in is due'**
  String get checkInDue;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get thisMonth;

  /// No description provided for @perWeek.
  ///
  /// In en, this message translates to:
  /// **'Per week'**
  String get perWeek;

  /// No description provided for @lastEightWeeks.
  ///
  /// In en, this message translates to:
  /// **'Last 8 weeks'**
  String get lastEightWeeks;

  /// No description provided for @exerciseDirectory.
  ///
  /// In en, this message translates to:
  /// **'Exercise directory'**
  String get exerciseDirectory;

  /// No description provided for @exercises.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get exercises;

  /// No description provided for @searchExercises.
  ///
  /// In en, this message translates to:
  /// **'Search exercises'**
  String get searchExercises;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @howToDoIt.
  ///
  /// In en, this message translates to:
  /// **'How to do it'**
  String get howToDoIt;

  /// No description provided for @watchOutFor.
  ///
  /// In en, this message translates to:
  /// **'Watch out for'**
  String get watchOutFor;

  /// No description provided for @whatYouGet.
  ///
  /// In en, this message translates to:
  /// **'What you get'**
  String get whatYouGet;

  /// No description provided for @removeYourEntry.
  ///
  /// In en, this message translates to:
  /// **'Remove your entry?'**
  String get removeYourEntry;

  /// No description provided for @stayIn.
  ///
  /// In en, this message translates to:
  /// **'Stay in'**
  String get stayIn;

  /// No description provided for @removeMe.
  ///
  /// In en, this message translates to:
  /// **'Remove me'**
  String get removeMe;

  /// No description provided for @youAreInTapToWithdraw.
  ///
  /// In en, this message translates to:
  /// **'You are in — tap to withdraw'**
  String get youAreInTapToWithdraw;

  /// No description provided for @participate.
  ///
  /// In en, this message translates to:
  /// **'Participate'**
  String get participate;

  /// No description provided for @takenOffList.
  ///
  /// In en, this message translates to:
  /// **'You will be taken off the list for {event}.'**
  String takenOffList(String event);

  /// No description provided for @contactWithPhone.
  ///
  /// In en, this message translates to:
  /// **'Contact {phone}'**
  String contactWithPhone(String phone);

  /// No description provided for @reasonOptional.
  ///
  /// In en, this message translates to:
  /// **'Reason (optional)'**
  String get reasonOptional;

  /// No description provided for @searchByGymCityDistrict.
  ///
  /// In en, this message translates to:
  /// **'Search by gym, city or district'**
  String get searchByGymCityDistrict;

  /// No description provided for @useMyLocation.
  ///
  /// In en, this message translates to:
  /// **'Use my location to find nearby gyms'**
  String get useMyLocation;

  /// No description provided for @findingNearbyGyms.
  ///
  /// In en, this message translates to:
  /// **'Finding gyms near you…'**
  String get findingNearbyGyms;

  /// No description provided for @locationUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t get your location — showing all gyms instead'**
  String get locationUnavailable;

  /// No description provided for @exerciseDirectorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Strength, cardio and yoga, with step-by-step form cues'**
  String get exerciseDirectorySubtitle;

  /// No description provided for @attendance.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get attendance;

  /// No description provided for @manage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get manage;

  /// No description provided for @choosePlan.
  ///
  /// In en, this message translates to:
  /// **'Choose a plan'**
  String get choosePlan;

  /// No description provided for @seeGrowthOverTime.
  ///
  /// In en, this message translates to:
  /// **'See growth over time'**
  String get seeGrowthOverTime;

  /// No description provided for @lastNDays.
  ///
  /// In en, this message translates to:
  /// **'Last {days} days'**
  String lastNDays(int days);

  /// No description provided for @addMember.
  ///
  /// In en, this message translates to:
  /// **'Add member'**
  String get addMember;

  /// No description provided for @addStaff.
  ///
  /// In en, this message translates to:
  /// **'Add staff'**
  String get addStaff;

  /// No description provided for @searchByNameOrNumber.
  ///
  /// In en, this message translates to:
  /// **'Search by name or number'**
  String get searchByNameOrNumber;

  /// No description provided for @tapCircleToMarkPresent.
  ///
  /// In en, this message translates to:
  /// **'Tap the circle to mark present, the row for details'**
  String get tapCircleToMarkPresent;

  /// No description provided for @markedPresent.
  ///
  /// In en, this message translates to:
  /// **'{name} marked present'**
  String markedPresent(String name);

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @theirName.
  ///
  /// In en, this message translates to:
  /// **'Their name'**
  String get theirName;

  /// No description provided for @theirMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Their mobile number'**
  String get theirMobileNumber;

  /// No description provided for @codeFromTheirPhone.
  ///
  /// In en, this message translates to:
  /// **'Code from their phone'**
  String get codeFromTheirPhone;

  /// No description provided for @whatDoTheyWant.
  ///
  /// In en, this message translates to:
  /// **'What do they want from the gym?'**
  String get whatDoTheyWant;

  /// No description provided for @goalHint.
  ///
  /// In en, this message translates to:
  /// **'Bulk up, lose weight, rehab…'**
  String get goalHint;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @removeFromGym.
  ///
  /// In en, this message translates to:
  /// **'Remove from gym'**
  String get removeFromGym;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @removePerson.
  ///
  /// In en, this message translates to:
  /// **'Remove {name}?'**
  String removePerson(String name);

  /// No description provided for @onLeave.
  ///
  /// In en, this message translates to:
  /// **'On leave'**
  String get onLeave;

  /// No description provided for @tapDayToCorrect.
  ///
  /// In en, this message translates to:
  /// **'Tap a day to correct it'**
  String get tapDayToCorrect;

  /// No description provided for @correctDate.
  ///
  /// In en, this message translates to:
  /// **'Correct {date}'**
  String correctDate(String date);

  /// No description provided for @whyIsThisChanging.
  ///
  /// In en, this message translates to:
  /// **'Why is this changing?'**
  String get whyIsThisChanging;

  /// No description provided for @correctionReasonHint.
  ///
  /// In en, this message translates to:
  /// **'Marked by mistake, machine was down…'**
  String get correctionReasonHint;

  /// No description provided for @saveCorrection.
  ///
  /// In en, this message translates to:
  /// **'Save correction'**
  String get saveCorrection;

  /// No description provided for @recordCorrected.
  ///
  /// In en, this message translates to:
  /// **'Record corrected.'**
  String get recordCorrected;

  /// No description provided for @trainerCategories.
  ///
  /// In en, this message translates to:
  /// **'Trainer categories'**
  String get trainerCategories;

  /// No description provided for @newCategory.
  ///
  /// In en, this message translates to:
  /// **'New category'**
  String get newCategory;

  /// No description provided for @noTrainerCategoriesYet.
  ///
  /// In en, this message translates to:
  /// **'No trainer categories yet.'**
  String get noTrainerCategoriesYet;

  /// No description provided for @oneTrainerManyMembers.
  ///
  /// In en, this message translates to:
  /// **'One trainer can hold many members'**
  String get oneTrainerManyMembers;

  /// No description provided for @categoryNameHint.
  ///
  /// In en, this message translates to:
  /// **'Rehab, Strength, Yoga'**
  String get categoryNameHint;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @keepIt.
  ///
  /// In en, this message translates to:
  /// **'Keep it'**
  String get keepIt;

  /// No description provided for @deleteNamed.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}?'**
  String deleteNamed(String name);

  /// No description provided for @decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// No description provided for @decidedBy.
  ///
  /// In en, this message translates to:
  /// **'Decided by {name}'**
  String decidedBy(String name);

  /// No description provided for @createAGym.
  ///
  /// In en, this message translates to:
  /// **'Create a gym'**
  String get createAGym;

  /// No description provided for @createYourGym.
  ///
  /// In en, this message translates to:
  /// **'Create your gym'**
  String get createYourGym;

  /// No description provided for @gymName.
  ///
  /// In en, this message translates to:
  /// **'Gym name'**
  String get gymName;

  /// No description provided for @gymNameHint.
  ///
  /// In en, this message translates to:
  /// **'Iron Temple Fitness'**
  String get gymNameHint;

  /// No description provided for @descriptionOptional.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get descriptionOptional;

  /// No description provided for @descriptionHint.
  ///
  /// In en, this message translates to:
  /// **'What makes your gym worth joining?'**
  String get descriptionHint;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @district.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get district;

  /// No description provided for @districtNote.
  ///
  /// In en, this message translates to:
  /// **'Your district appears next to your gym name in search, so members can tell you apart.'**
  String get districtNote;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// No description provided for @pinCode.
  ///
  /// In en, this message translates to:
  /// **'PIN code'**
  String get pinCode;

  /// No description provided for @contactNumber.
  ///
  /// In en, this message translates to:
  /// **'Contact number'**
  String get contactNumber;

  /// No description provided for @leavePolicyNote.
  ///
  /// In en, this message translates to:
  /// **'Members can pause their membership for a few days a month. Requests beyond that need approval.'**
  String get leavePolicyNote;

  /// No description provided for @perksLabel.
  ///
  /// In en, this message translates to:
  /// **'Perks, separated by commas'**
  String get perksLabel;

  /// No description provided for @perksHint.
  ///
  /// In en, this message translates to:
  /// **'Steam room, Free parking, Personal training'**
  String get perksHint;

  /// No description provided for @createGym.
  ///
  /// In en, this message translates to:
  /// **'Create gym'**
  String get createGym;

  /// No description provided for @deleteGym.
  ///
  /// In en, this message translates to:
  /// **'Delete gym'**
  String get deleteGym;

  /// No description provided for @gymProfile.
  ///
  /// In en, this message translates to:
  /// **'Gym profile'**
  String get gymProfile;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @leavePolicy.
  ///
  /// In en, this message translates to:
  /// **'Leave policy'**
  String get leavePolicy;

  /// No description provided for @leaveDaysPerMonth.
  ///
  /// In en, this message translates to:
  /// **'Leave days per month'**
  String get leaveDaysPerMonth;

  /// No description provided for @deleteThisGym.
  ///
  /// In en, this message translates to:
  /// **'Delete this gym'**
  String get deleteThisGym;

  /// No description provided for @leaveLimitNote.
  ///
  /// In en, this message translates to:
  /// **'Member requests inside this limit are approved automatically. Anything beyond it needs someone to approve.'**
  String get leaveLimitNote;

  /// No description provided for @draftNote.
  ///
  /// In en, this message translates to:
  /// **'Your gym starts as a draft. It will not appear in search until you complete verification and choose a plan.'**
  String get draftNote;

  /// No description provided for @sendThis.
  ///
  /// In en, this message translates to:
  /// **'Send this?'**
  String get sendThis;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @announcements.
  ///
  /// In en, this message translates to:
  /// **'Announcements'**
  String get announcements;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @announceTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Closed Sunday for maintenance'**
  String get announceTitleHint;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @announceBodyHint.
  ///
  /// In en, this message translates to:
  /// **'We reopen Monday at 6am. Sorry for the short notice.'**
  String get announceBodyHint;

  /// No description provided for @whoSeesIt.
  ///
  /// In en, this message translates to:
  /// **'Who sees it'**
  String get whoSeesIt;

  /// No description provided for @everyone.
  ///
  /// In en, this message translates to:
  /// **'Everyone'**
  String get everyone;

  /// No description provided for @sendAnnouncement.
  ///
  /// In en, this message translates to:
  /// **'Send announcement'**
  String get sendAnnouncement;

  /// No description provided for @sent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get sent;

  /// No description provided for @newGym.
  ///
  /// In en, this message translates to:
  /// **'New gym'**
  String get newGym;

  /// No description provided for @draft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get draft;

  /// No description provided for @nothingToChartYet.
  ///
  /// In en, this message translates to:
  /// **'Nothing to chart yet.'**
  String get nothingToChartYet;

  /// No description provided for @peakValue.
  ///
  /// In en, this message translates to:
  /// **'peak {value}'**
  String peakValue(int value);

  /// No description provided for @searchRanking.
  ///
  /// In en, this message translates to:
  /// **'Search ranking'**
  String get searchRanking;

  /// No description provided for @notInSearch.
  ///
  /// In en, this message translates to:
  /// **'Not in search'**
  String get notInSearch;

  /// No description provided for @members.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get members;

  /// No description provided for @staff.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get staff;

  /// No description provided for @leave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leave;

  /// No description provided for @roles.
  ///
  /// In en, this message translates to:
  /// **'Roles'**
  String get roles;

  /// No description provided for @analytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// No description provided for @growth.
  ///
  /// In en, this message translates to:
  /// **'Growth'**
  String get growth;

  /// No description provided for @ranking.
  ///
  /// In en, this message translates to:
  /// **'Ranking'**
  String get ranking;

  /// No description provided for @plan.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get plan;

  /// No description provided for @announce.
  ///
  /// In en, this message translates to:
  /// **'Announce'**
  String get announce;

  /// No description provided for @trainers.
  ///
  /// In en, this message translates to:
  /// **'Trainers'**
  String get trainers;

  /// No description provided for @present.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get present;

  /// No description provided for @absent.
  ///
  /// In en, this message translates to:
  /// **'Absent'**
  String get absent;

  /// No description provided for @markAttendance.
  ///
  /// In en, this message translates to:
  /// **'Mark attendance'**
  String get markAttendance;

  /// No description provided for @getHelp.
  ///
  /// In en, this message translates to:
  /// **'Get help'**
  String get getHelp;

  /// No description provided for @getHelpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Send us a message and we will get back to you'**
  String get getHelpSubtitle;

  /// No description provided for @termsAndPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Terms & Privacy Policy'**
  String get termsAndPrivacy;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @switchToStaff.
  ///
  /// In en, this message translates to:
  /// **'Switch to owner/staff mode'**
  String get switchToStaff;

  /// No description provided for @switchToMember.
  ///
  /// In en, this message translates to:
  /// **'Switch to member mode'**
  String get switchToMember;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Shown beside a language that has been machine-translated and not yet checked by a native speaker.
  ///
  /// In en, this message translates to:
  /// **'Translation pending review'**
  String get needsReview;

  /// No description provided for @block.
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get block;

  /// No description provided for @unblock.
  ///
  /// In en, this message translates to:
  /// **'Unblock'**
  String get unblock;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// {name} is the person being blocked.
  ///
  /// In en, this message translates to:
  /// **'Block {name}'**
  String blockPerson(String name);

  /// {name} is the person being reported.
  ///
  /// In en, this message translates to:
  /// **'Report {name}'**
  String reportPerson(String name);

  /// Shown before confirming a block. Says plainly that it is silent and reversible.
  ///
  /// In en, this message translates to:
  /// **'They will not be able to message you, and you will not see their messages. They are not told that you blocked them. You can undo this in Settings.'**
  String get blockConfirmBody;

  /// No description provided for @blocked.
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get blocked;

  /// No description provided for @blockedAccounts.
  ///
  /// In en, this message translates to:
  /// **'Blocked accounts'**
  String get blockedAccounts;

  /// No description provided for @noBlockedAccounts.
  ///
  /// In en, this message translates to:
  /// **'You have not blocked anyone.'**
  String get noBlockedAccounts;

  /// No description provided for @safetyAndPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Safety'**
  String get safetyAndPrivacy;

  /// {name} is the person being unblocked.
  ///
  /// In en, this message translates to:
  /// **'Unblock {name}?'**
  String unblockQuestion(String name);

  /// No description provided for @unblockExplainer.
  ///
  /// In en, this message translates to:
  /// **'They will be able to message you again.'**
  String get unblockExplainer;

  /// No description provided for @whyReporting.
  ///
  /// In en, this message translates to:
  /// **'What is wrong?'**
  String get whyReporting;

  /// No description provided for @reportDetails.
  ///
  /// In en, this message translates to:
  /// **'What happened?'**
  String get reportDetails;

  /// Explains why the reporter has to describe the content themselves. Must NOT claim the messages are unreadable by the service -- the server holds the key and ChatService decrypts them; it is the review desk that does not show them.
  ///
  /// In en, this message translates to:
  /// **'Reviewers do not see the message itself. Your description is what they read, so tell us what was said in your own words.'**
  String get reportDetailsHint;

  /// No description provided for @alsoBlockThem.
  ///
  /// In en, this message translates to:
  /// **'Block them as well'**
  String get alsoBlockThem;

  /// Why the report sheet also offers a block.
  ///
  /// In en, this message translates to:
  /// **'A report is read by a person and takes time. Blocking works straight away.'**
  String get alsoBlockThemExplainer;

  /// No description provided for @sendReport.
  ///
  /// In en, this message translates to:
  /// **'Send report'**
  String get sendReport;

  /// No description provided for @reportCategorySpam.
  ///
  /// In en, this message translates to:
  /// **'Spam or unwanted selling'**
  String get reportCategorySpam;

  /// No description provided for @reportCategoryHarassment.
  ///
  /// In en, this message translates to:
  /// **'Harassment or bullying'**
  String get reportCategoryHarassment;

  /// No description provided for @reportCategorySexual.
  ///
  /// In en, this message translates to:
  /// **'Sexual or explicit content'**
  String get reportCategorySexual;

  /// No description provided for @reportCategoryHate.
  ///
  /// In en, this message translates to:
  /// **'Hate speech'**
  String get reportCategoryHate;

  /// No description provided for @reportCategoryViolence.
  ///
  /// In en, this message translates to:
  /// **'Violence or a threat'**
  String get reportCategoryViolence;

  /// No description provided for @reportCategoryScam.
  ///
  /// In en, this message translates to:
  /// **'Scam or fraud'**
  String get reportCategoryScam;

  /// No description provided for @reportCategoryImpersonation.
  ///
  /// In en, this message translates to:
  /// **'Pretending to be someone else'**
  String get reportCategoryImpersonation;

  /// No description provided for @reportCategoryOther.
  ///
  /// In en, this message translates to:
  /// **'Something else'**
  String get reportCategoryOther;

  /// No description provided for @reportSent.
  ///
  /// In en, this message translates to:
  /// **'Thank you. Someone will review this.'**
  String get reportSent;

  /// No description provided for @myReports.
  ///
  /// In en, this message translates to:
  /// **'Reports I have sent'**
  String get myReports;

  /// No description provided for @reportStatusOpen.
  ///
  /// In en, this message translates to:
  /// **'Waiting for review'**
  String get reportStatusOpen;

  /// No description provided for @reportStatusReviewing.
  ///
  /// In en, this message translates to:
  /// **'Being looked at'**
  String get reportStatusReviewing;

  /// No description provided for @reportStatusActioned.
  ///
  /// In en, this message translates to:
  /// **'Action taken'**
  String get reportStatusActioned;

  /// No description provided for @reportStatusDismissed.
  ///
  /// In en, this message translates to:
  /// **'Reviewed, no action'**
  String get reportStatusDismissed;

  /// No description provided for @noReportsSent.
  ///
  /// In en, this message translates to:
  /// **'You have not reported anyone.'**
  String get noReportsSent;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccount;

  /// Shown above the delete button. The 30 days is what makes a decision made in a bad moment recoverable.
  ///
  /// In en, this message translates to:
  /// **'Your account stays usable for 30 days. After that it is deleted and cannot be brought back.'**
  String get deleteAccountIntro;

  /// No description provided for @whatIsDeleted.
  ///
  /// In en, this message translates to:
  /// **'What is deleted'**
  String get whatIsDeleted;

  /// No description provided for @whatIsDeletedList.
  ///
  /// In en, this message translates to:
  /// **'Your name, number, email and age. Your height, weight and progress. Your chat messages. Any ID documents and UPI details.'**
  String get whatIsDeletedList;

  /// No description provided for @whatIsKept.
  ///
  /// In en, this message translates to:
  /// **'What is kept, with you removed from it'**
  String get whatIsKept;

  /// Must stay honest: payment rows really are retained, so this cannot promise that everything vanishes.
  ///
  /// In en, this message translates to:
  /// **'Payment and invoice records, because the law requires us to keep books of account. The record of actions taken in a gym, so disputes can still be settled.'**
  String get whatIsKeptList;

  /// No description provided for @deleteGymsFirst.
  ///
  /// In en, this message translates to:
  /// **'You still own a gym. Delete it first — deleting your account would cut off every member and staff member in it, and they will be told it has closed.'**
  String get deleteGymsFirst;

  /// {amount} is a formatted rupee figure, e.g. ₹150.00.
  ///
  /// In en, this message translates to:
  /// **'You have {amount} in referral earnings you have not withdrawn. Withdraw it in the Gymologia Referral app first, or it will be lost.'**
  String unwithdrawnWarning(String amount);

  /// No description provided for @iUnderstandLoseEarnings.
  ///
  /// In en, this message translates to:
  /// **'I understand I will lose this money'**
  String get iUnderstandLoseEarnings;

  /// {date} is a formatted calendar date.
  ///
  /// In en, this message translates to:
  /// **'Your account will be deleted on {date}.'**
  String deletionScheduled(String date);

  /// No description provided for @keepMyAccount.
  ///
  /// In en, this message translates to:
  /// **'Keep my account'**
  String get keepMyAccount;

  /// No description provided for @deletionCancelled.
  ///
  /// In en, this message translates to:
  /// **'Your account will not be deleted.'**
  String get deletionCancelled;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete my account'**
  String get deleteAccountConfirm;
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
