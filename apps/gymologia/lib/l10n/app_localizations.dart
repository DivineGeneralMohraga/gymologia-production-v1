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

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

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

  /// No description provided for @enterCode.
  ///
  /// In en, this message translates to:
  /// **'Enter the code we sent you'**
  String get enterCode;

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

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get yourName;

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

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

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

  /// No description provided for @noGymsFound.
  ///
  /// In en, this message translates to:
  /// **'No gyms found here yet'**
  String get noGymsFound;

  /// No description provided for @perks.
  ///
  /// In en, this message translates to:
  /// **'Perks'**
  String get perks;

  /// No description provided for @contactGym.
  ///
  /// In en, this message translates to:
  /// **'Contact this gym'**
  String get contactGym;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @yourMembership.
  ///
  /// In en, this message translates to:
  /// **'Your membership'**
  String get yourMembership;

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

  /// No description provided for @addMeasurements.
  ///
  /// In en, this message translates to:
  /// **'Add your weight and height so your gym can track progress with you'**
  String get addMeasurements;

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

  /// No description provided for @weeksRunning.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Week running} other{Weeks running}}'**
  String weeksRunning(int count);

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

  /// No description provided for @exerciseDirectorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Strength, cardio and yoga, with step-by-step form cues'**
  String get exerciseDirectorySubtitle;

  /// No description provided for @steps.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get steps;

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
  /// **'Leave'**
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

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'Nothing new'**
  String get noNotifications;

  /// Shown beside a language that has been machine-translated and not yet checked by a native speaker.
  ///
  /// In en, this message translates to:
  /// **'Translation pending review'**
  String get needsReview;
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
