// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malayalam (`ml`).
class AppLocalizationsMl extends AppLocalizations {
  AppLocalizationsMl([String locale = 'ml']) : super(locale);

  @override
  String get appName => 'Gymologia';

  @override
  String get languageName => 'മലയാളം';

  @override
  String get settings => 'ക്രമീകരണങ്ങൾ';

  @override
  String get language => 'ഭാഷ';

  @override
  String get languageSubtitle =>
      'നിങ്ങൾക്ക് സൗകര്യപ്രദമായി വായിക്കാവുന്ന ഭാഷ തിരഞ്ഞെടുക്കുക';

  @override
  String get save => 'സേവ് ചെയ്യുക';

  @override
  String get cancel => 'റദ്ദാക്കുക';

  @override
  String get tryAgain => 'വീണ്ടും ശ്രമിക്കുക';

  @override
  String get somethingWentWrong => 'എന്തോ കുഴപ്പം സംഭവിച്ചു';

  @override
  String get phoneNumber => 'മൊബൈൽ നമ്പർ';

  @override
  String get enterPhoneNumber => 'നിങ്ങളുടെ മൊബൈൽ നമ്പർ നൽകുക';

  @override
  String get sendCode => 'കോഡ് അയയ്ക്കുക';

  @override
  String get verifyCode => 'സ്ഥിരീകരിക്കുക';

  @override
  String get resendCode => 'വീണ്ടും അയയ്ക്കുക';

  @override
  String get createAccount => 'നിങ്ങളുടെ അക്കൗണ്ട് ഉണ്ടാക്കുക';

  @override
  String get emailOptional => 'ഇമെയിൽ (ഐച്ഛികം)';

  @override
  String get age => 'വയസ്സ്';

  @override
  String get whyAgeNotBirthday =>
      'ഞങ്ങൾ നിങ്ങളുടെ വയസ്സാണ് ചോദിക്കുന്നത്, ജനനത്തീയതിയല്ല. ജനനത്തീയതി നിങ്ങളുടെ ബാങ്ക്, സർക്കാർ രേഖകളുമായി ബന്ധപ്പെട്ടതാണ് — ജിം ആപ്പിന് വയസ്സ് മതി.';

  @override
  String get termsAgreement =>
      'അക്കൗണ്ട് ഉണ്ടാക്കുന്നത് ഉപയോഗ നിബന്ധനകളും സ്വകാര്യതാ നയവും അംഗീകരിക്കുന്നു എന്നാണ്.';

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
  String get signInWithMobile =>
      'നിങ്ങളുടെ മൊബൈൽ നമ്പർ ഉപയോഗിച്ച് സൈൻ ഇൻ ചെയ്യുക';

  @override
  String get mobileNumber => 'മൊബൈൽ നമ്പർ';

  @override
  String get couldNotSendCode => 'കോഡ് അയയ്ക്കാൻ കഴിഞ്ഞില്ല.';

  @override
  String get verificationFailed => 'പരിശോധന പരാജയപ്പെട്ടു.';

  @override
  String get couldNotResendCode => 'കോഡ് വീണ്ടും അയയ്ക്കാൻ കഴിഞ്ഞില്ല.';

  @override
  String get couldNotCreateAccount =>
      'നിങ്ങളുടെ അക്കൗണ്ട് ഉണ്ടാക്കാൻ കഴിഞ്ഞില്ല.';

  @override
  String weSentCodeTo(String phone) {
    return '$phone എന്ന നമ്പറിലേക്ക് കോഡ് അയച്ചു';
  }

  @override
  String resendInSeconds(int seconds) {
    return '$seconds സെക്കൻഡിൽ വീണ്ടും അയയ്ക്കുക';
  }

  @override
  String get verified => 'പരിശോധിച്ചു';

  @override
  String get createAccountAction => 'അക്കൗണ്ട് ഉണ്ടാക്കുക';

  @override
  String get supportSent => 'അയച്ചു. നിങ്ങൾ നൽകിയ നമ്പറിൽ മറുപടി വരും.';

  @override
  String get supportSubject => 'ഇത് എന്തിനെക്കുറിച്ചാണ്?';

  @override
  String get supportSubjectHint => 'എന്റെ അംഗത്വ ദിവസങ്ങൾ തെറ്റായി കാണുന്നു';

  @override
  String get supportMessage => 'എന്താണ് സംഭവിച്ചതെന്ന് പറയൂ';

  @override
  String get supportReplyTo => 'ഞങ്ങൾ എവിടെ മറുപടി നൽകണം?';

  @override
  String get supportUrgent => 'ഇതുകാരണം എന്റെ ജിം പ്രവർത്തിക്കാൻ കഴിയുന്നില്ല';

  @override
  String get supportUrgentNote => 'മുൻഗണന കൂട്ടുന്നു.';

  @override
  String copiedToClipboard(String value) {
    return '$value പകർത്തി';
  }

  @override
  String orEmailUs(String email) {
    return 'അല്ലെങ്കിൽ $email എന്ന വിലാസത്തിൽ ഇമെയിൽ ചെയ്യുക';
  }

  @override
  String get whatYouHaveAsked => 'നിങ്ങൾ ചോദിച്ചത്';

  @override
  String get aFewWordsIsEnough => 'കുറച്ച് വാക്കുകൾ മതി';

  @override
  String get aSentenceOrTwoHelps =>
      'ഒന്നോ രണ്ടോ വാചകം എഴുതിയാൽ വേഗം പരിഹരിക്കാം';

  @override
  String get ticketOpen => 'ആരെങ്കിലും ഏറ്റെടുക്കാൻ കാത്തിരിക്കുന്നു';

  @override
  String get ticketInProgress => 'ആരോ ഇത് നോക്കുന്നു';

  @override
  String get ticketWaitingOnUser => 'നിങ്ങളുടെ മറുപടിക്കായി കാത്തിരിക്കുന്നു';

  @override
  String get ticketResolved => 'പരിഹരിച്ചു';

  @override
  String get ticketClosed => 'അടച്ചു';

  @override
  String get referralPitch =>
      'കോഡ് പങ്കിടുക, ഒരു ജിം ഉടമ സബ്‌സ്‌ക്രിപ്ഷൻ എടുക്കുമ്പോൾ സമ്പാദിക്കുക. റഫറൽ ആപ്പ് ഇനിയും വന്നിട്ടില്ല.';

  @override
  String get appTagline => 'ജിമോളജിയ · അംഗങ്ങളും ജീവനക്കാരും';

  @override
  String get signOutQuestion => 'സൈൻ ഔട്ട് ചെയ്യണോ?';

  @override
  String get signOutWarning => 'വീണ്ടും സൈൻ ഇൻ ചെയ്യാൻ നിങ്ങളുടെ ഫോൺ വേണം.';

  @override
  String get profileUpdated => 'പ്രൊഫൈൽ പുതുക്കി.';

  @override
  String get yourProfile => 'നിങ്ങളുടെ പ്രൊഫൈൽ';

  @override
  String get emailClearToRemove => 'ഐച്ഛികം. നീക്കാൻ ഒഴിവാക്കുക.';

  @override
  String get phoneIsYourLogin =>
      'ഇതുപയോഗിച്ചാണ് നിങ്ങൾ സൈൻ ഇൻ ചെയ്യുന്നത്, അതിനാൽ ഇവിടെ ഇപ്പോൾ മാറ്റാനാകില്ല. മാറ്റണമെങ്കിൽ പിന്തുണയുമായി ബന്ധപ്പെടുക.';

  @override
  String get trialStarted =>
      'ട്രയൽ ആരംഭിച്ചു. നിങ്ങളുടെ ജിം ഇപ്പോൾ തിരയലിൽ കാണാം.';

  @override
  String get invalidCode => 'കോഡ് സാധുവല്ല.';

  @override
  String get paymentNotCompletedYet =>
      'പണമടയ്ക്കൽ ഇനിയും പൂർത്തിയായിട്ടില്ല. അല്പസമയത്തിനു ശേഷം വലിച്ചു പുതുക്കുക.';

  @override
  String planIsActive(String plan) {
    return '$plan പ്ലാൻ സജീവമാണ്.';
  }

  @override
  String get paymentNotCompleted => 'പണമടയ്ക്കൽ പൂർത്തിയായില്ല.';

  @override
  String get couldNotOpenPayment => 'പണമടയ്ക്കൽ സ്ക്രീൻ തുറക്കാൻ കഴിഞ്ഞില്ല.';

  @override
  String daysFree(int days) {
    return '$days ദിവസം സൗജന്യം';
  }

  @override
  String get trialBlurb =>
      'പൂർണ്ണ പ്രോ, അംഗ തിരയലിലെ നിങ്ങളുടെ ലിസ്റ്റിംഗ് ഉൾപ്പെടെ. കാർഡ് വേണ്ട, ഇത് സ്വയം പണമടച്ചുള്ള പ്ലാനായി മാറില്ല.';

  @override
  String get startFreeTrial => 'സൗജന്യ ട്രയൽ തുടങ്ങുക';

  @override
  String get referralCode => 'റഫറൽ കോഡ്';

  @override
  String get optional => 'ഐച്ഛികം';

  @override
  String get apply => 'ബാധകമാക്കുക';

  @override
  String get gstNote =>
      'വിലയിൽ ജിഎസ്ടി ഉൾപ്പെടും. പ്രോ പ്ലാനിൽ മാത്രമേ ജിം അംഗ തിരയലിൽ വരൂ.';

  @override
  String planNamed(String plan) {
    return '$plan പ്ലാൻ';
  }

  @override
  String get trialBadge => 'ട്രയൽ';

  @override
  String get expired => 'കാലാവധി കഴിഞ്ഞു';

  @override
  String daysRemainingPlan(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ദിവസം ബാക്കി',
    );
    return '$_temp0';
  }

  @override
  String get listedInSearch => 'അംഗ തിരയലിൽ ലിസ്റ്റ് ചെയ്തു';

  @override
  String get notListedUpgrade => 'തിരയലിൽ ഇല്ല — കാണാൻ പ്രോയിലേക്ക് മാറുക';

  @override
  String get trialEndsNote =>
      'ട്രയൽ കഴിഞ്ഞാൽ നിങ്ങൾ പ്ലാൻ തിരഞ്ഞെടുക്കുന്നത് വരെ ജിം തിരയലിൽ നിന്ന് പുറത്താകും. സ്വയമേവ ഒന്നും ഈടാക്കില്ല.';

  @override
  String get getsYouListed => 'തിരയലിൽ ഇടം നൽകുന്നു';

  @override
  String get perMonth => '/മാസം';

  @override
  String choosePlanNamed(String plan) {
    return '$plan തിരഞ്ഞെടുക്കുക';
  }

  @override
  String get deleteRoleWarning =>
      'റോളും അതിന്റെ അനുമതികളും പോകും. ഇതിൽ ആരുമില്ല, അതിനാൽ ആർക്കും ആക്സസ് നഷ്ടപ്പെടില്ല.';

  @override
  String deletedNamed(String name) {
    return '$name നീക്കി';
  }

  @override
  String get needTwoCustomRoles =>
      'ക്രമം മാറ്റും മുൻപ് നിങ്ങൾക്ക് തിരുത്താവുന്ന രണ്ട് ഇഷ്ട റോളുകൾ വേണം.';

  @override
  String get hierarchySaved => 'ശ്രേണി സംരക്ഷിച്ചു';

  @override
  String get reorder => 'ക്രമം മാറ്റുക';

  @override
  String get newRole => 'പുതിയ റോൾ';

  @override
  String get rolesIntro =>
      'ഏറ്റവും മുതിർന്നത് ആദ്യം. നിങ്ങളുടേതിന് താഴെയുള്ള റോളുകൾ മാത്രമേ തിരുത്താനാകൂ, നിങ്ങൾക്കുള്ള അനുമതികൾ മാത്രമേ നൽകാനാകൂ.';

  @override
  String get defaultBadge => 'സ്ഥിരം';

  @override
  String get everyPermission =>
      'എല്ലാ അനുമതികളും, പിന്നീട് ചേർക്കുന്നവ ഉൾപ്പെടെ';

  @override
  String permissionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count അനുമതികൾ',
    );
    return '$_temp0';
  }

  @override
  String get nobodyInThisRole => 'ഈ റോളിൽ ആരുമില്ല';

  @override
  String peopleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count പേർ',
    );
    return '$_temp0';
  }

  @override
  String get deleteDefaultRolesStay => 'നീക്കുക (സ്ഥിര റോളുകൾ നിലനിൽക്കും)';

  @override
  String get deleteMovePeopleFirst => 'നീക്കുക (ആദ്യം ആളുകളെ മാറ്റുക)';

  @override
  String get giveRoleAName => 'റോളിന് ഒരു പേര് നൽകുക';

  @override
  String get editRole => 'റോൾ തിരുത്തുക';

  @override
  String get createRole => 'റോൾ ഉണ്ടാക്കുക';

  @override
  String get roleName => 'റോളിന്റെ പേര്';

  @override
  String get roleNameHint => 'റിസപ്ഷൻ, ഫിസിയോ, നൈറ്റ് ഷിഫ്റ്റ്';

  @override
  String get superRoleNote =>
      'ഈ റോളിന് എല്ലാ അനുമതികളുമുണ്ട്, ഭാവിയിൽ ചേർക്കുന്നവയും. ഇത് കുറയ്ക്കാനാകില്ല — എപ്പോഴും കാര്യങ്ങൾ ശരിയാക്കാൻ കഴിയുന്ന റോൾ ഇതാണ്.';

  @override
  String get whatThisRoleCanDo => 'ഈ റോളിന് എന്തു ചെയ്യാം';

  @override
  String get greyedOutNote =>
      'മങ്ങിയവ നിങ്ങൾക്കില്ലാത്തവയാണ്, അതിനാൽ അവ കൈമാറാനാകില്ല.';

  @override
  String get ownerOnlyPermission => 'ഇത് ജിം ഉടമയ്ക്ക് മാത്രം';

  @override
  String get youDoNotHoldThis => 'ഇത് നിങ്ങൾക്കില്ല';

  @override
  String get orderTheHierarchy => 'ശ്രേണി ക്രമപ്പെടുത്തുക';

  @override
  String get hierarchyNote =>
      'ഏറ്റവും മുതിർന്നത് മുകളിൽ. സ്ഥിര റോളുകൾ അവയുടെ സ്ഥാനത്ത് തുടരും, ഇവിടെ കാണില്ല.';

  @override
  String get saveOrder => 'ക്രമം സംരക്ഷിക്കുക';

  @override
  String membershipExtendedBy(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'അംഗത്വം $count മാസം നീട്ടി.',
    );
    return '$_temp0';
  }

  @override
  String get goalUpdated => 'ലക്ഷ്യം പുതുക്കി.';

  @override
  String get thisMember => 'ഈ അംഗം';

  @override
  String get removeMemberQuestion => 'അംഗത്തെ നീക്കണോ?';

  @override
  String removeMemberWarning(String name) {
    return '$name ഈ ജിമ്മിലേക്കുള്ള പ്രവേശനം നഷ്ടപ്പെടും. അവരുടെ ഹാജർ രേഖയും അളവുകളും സൂക്ഷിക്കും.';
  }

  @override
  String get member => 'അംഗം';

  @override
  String get removeMember => 'അംഗത്തെ നീക്കുക';

  @override
  String get daysLeft => 'ബാക്കി ദിവസം';

  @override
  String get leaveUsed => 'എടുത്ത അവധി';

  @override
  String get extend => 'നീട്ടുക';

  @override
  String get editGoal => 'ലക്ഷ്യം തിരുത്തുക';

  @override
  String get goal => 'ലക്ഷ്യം';

  @override
  String get notSet => 'സജ്ജമാക്കിയിട്ടില്ല';

  @override
  String get noneAssigned => 'ആരെയും നിയോഗിച്ചിട്ടില്ല';

  @override
  String get attendanceHistory => 'ഹാജർ ചരിത്രം';

  @override
  String get viewAndCorrectRecords => 'രേഖകൾ കണ്ട് തിരുത്തുക';

  @override
  String sessionsSoFar(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ഇതുവരെ $count സെഷനുകൾ',
    );
    return '$_temp0';
  }

  @override
  String get progressIsPrivate => 'പുരോഗതി സ്വകാര്യമാണ്';

  @override
  String get monitoringOffNote =>
      'ഈ അംഗം പുരോഗതി നിരീക്ഷണം ഓഫാക്കിയിരിക്കുന്നു. അത് അവരുടെ തീരുമാനമാണ്, ഒരു റോളിനും അത് മറികടക്കാനാകില്ല.';

  @override
  String get progress => 'പുരോഗതി';

  @override
  String get noMeasurementsYet =>
      'ഇതുവരെ അളവുകൾ രേഖപ്പെടുത്തിയിട്ടില്ല. അംഗത്തോട് അവരുടെ ആപ്പിൽ മാസത്തിലൊരിക്കൽ ചോദിക്കും.';

  @override
  String holdingAtKg(String kg) {
    return '$kg കിലോയിൽ സ്ഥിരം';
  }

  @override
  String weightChangeSince(String delta) {
    return 'ആദ്യ അളവിനുശേഷം $delta കിലോ';
  }

  @override
  String get extendMembership => 'അംഗത്വം നീട്ടുക';

  @override
  String get extendFromTodayNote =>
      'കാലാവധി കഴിഞ്ഞ അംഗത്വം ഇന്നു മുതൽ നീളും, കഴിഞ്ഞ തീയതി മുതൽ അല്ല.';

  @override
  String monthsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count മാസം',
    );
    return '$_temp0';
  }

  @override
  String extendByMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count മാസം നീട്ടുക',
    );
    return '$_temp0';
  }

  @override
  String get whatAreTheyWorkingTowards =>
      'അവർ ഏത് ലക്ഷ്യത്തിനായി പ്രവർത്തിക്കുന്നു?';

  @override
  String get goalDialogHint => '80 കിലോ വരെ ബൾക്ക്, ഭാരം കുറയ്ക്കൽ, റീഹാബ്…';

  @override
  String signedUpCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count പേർ പേര് നൽകി',
    );
    return '$_temp0';
  }

  @override
  String get nobodyYet => 'ഇതുവരെ ആരുമില്ല.';

  @override
  String get hostAnEvent => 'ഒരു ഇവന്റ് നടത്തുക';

  @override
  String get noEventsYet =>
      'ഇതുവരെ ഇവന്റുകളില്ല. ഒന്ന് നടത്തൂ, അത് നിങ്ങളുടെ അംഗങ്ങൾക്ക് ഉടൻ കാണാം.';

  @override
  String get editEvent => 'ഇവന്റ് എഡിറ്റ് ചെയ്യുക';

  @override
  String get cancelEvent => 'ഇവന്റ് റദ്ദാക്കുക';

  @override
  String get cancelEventConfirmTitle => 'ഈ ഇവന്റ് റദ്ദാക്കണോ?';

  @override
  String get cancelEventConfirmBody =>
      'ഇത് ഇവന്റ് ശാശ്വതമായി ഇല്ലാതാക്കും, രജിസ്റ്റർ ചെയ്തവരുടെ ലിസ്റ്റ് ഉൾപ്പെടെ. ഇത് പഴയപടിയാക്കാൻ കഴിയില്ല.';

  @override
  String get keepEvent => 'ഇവന്റ് നിലനിർത്തുക';

  @override
  String get eventUpdated => 'ഇവന്റ് അപ്ഡേറ്റ് ചെയ്തു';

  @override
  String get eventCancelledSnackbar => 'ഇവന്റ് ഇല്ലാതാക്കി';

  @override
  String get eventTitleHint => 'സമ്മർ ഡെഡ്‌ലിഫ്റ്റ് മീറ്റ്';

  @override
  String get howToTakePart => 'എങ്ങനെ പങ്കെടുക്കാം';

  @override
  String get howToTakePartHint =>
      'രാവിലെ 8 മണിക്ക് തൂക്കം. സ്വന്തം ബെൽറ്റ് കൊണ്ടുവരിക.';

  @override
  String get prizeOptional => 'സമ്മാനം (ഐച്ഛികം)';

  @override
  String get prizeHint => '₹10,000';

  @override
  String get membersCanSignUp => 'അംഗങ്ങൾക്ക് ആപ്പിൽ പേര് നൽകാം';

  @override
  String get membersCanSignUpNote =>
      'ഓഫാക്കിയാൽ ബട്ടണിനു പകരം നിങ്ങളുടെ വ്യവസ്ഥകൾ കാണും.';

  @override
  String get listPublicly => 'പൊതുവായി കാണിക്കുക';

  @override
  String get listPubliclyNote => 'രാജ്യമെമ്പാടുമുള്ള ഇവന്റ് ഫീഡിൽ കാണാം.';

  @override
  String get listPubliclyProOnly =>
      'പ്രോ പ്ലാനിൽ മാത്രം. നിങ്ങളുടെ അംഗങ്ങൾ ഇത് കാണും.';

  @override
  String get openToOutsiders => 'നിങ്ങളുടെ ജിമ്മിന് പുറത്തുള്ളവർക്കും തുറന്നത്';

  @override
  String get publishEvent => 'ഇവന്റ് പ്രസിദ്ധീകരിക്കുക';

  @override
  String get registrationOpen => 'രജിസ്ട്രേഷൻ തുറന്നിരിക്കുന്നു';

  @override
  String get registrationClosed => 'രജിസ്ട്രേഷൻ അടച്ചു';

  @override
  String get close => 'അടയ്ക്കുക';

  @override
  String get markAllRead => 'എല്ലാം വായിച്ചതായി അടയാളപ്പെടുത്തുക';

  @override
  String get nothingYet => 'ഇതുവരെ ഒന്നുമില്ല';

  @override
  String get announcementsAppearHere =>
      'നിങ്ങളുടെ ജിമ്മിൽ നിന്നും ജിമോളജിയയിൽ നിന്നുമുള്ള അറിയിപ്പുകൾ ഇവിടെ വരും.';

  @override
  String get searchPeople => 'ആളുകളെ തിരയുക';

  @override
  String get nobodyElseHereYet => 'ഇവിടെ ഇതുവരെ മറ്റാരുമില്ല.';

  @override
  String get nameTheGroup => 'ഗ്രൂപ്പിന് പേര് നൽകുക';

  @override
  String get groupNameHint => 'ശനിയാഴ്ച രാവിലത്തെ സംഘം';

  @override
  String get create => 'ഉണ്ടാക്കുക';

  @override
  String get pickWhoIsInTheGroup => 'ഗ്രൂപ്പിൽ ആരൊക്കെ എന്ന് തിരഞ്ഞെടുക്കുക';

  @override
  String createGroupWith(int count) {
    return '$count പേരുമായി ഗ്രൂപ്പ് ഉണ്ടാക്കുക';
  }

  @override
  String get termsOfUse => 'ഉപയോഗ നിബന്ധനകൾ';

  @override
  String get privacy => 'സ്വകാര്യത';

  @override
  String versionUpdated(String version, String date) {
    return 'പതിപ്പ് $version · പുതുക്കിയത് $date';
  }

  @override
  String sessionsAttendedAllTime(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'സെഷനുകൾ, ആകെ',
    );
    return '$_temp0';
  }

  @override
  String get nothingInLast60Days =>
      'കഴിഞ്ഞ 60 ദിവസത്തിൽ ഒന്നും രേഖപ്പെടുത്തിയിട്ടില്ല.';

  @override
  String correctedReason(String reason) {
    return 'തിരുത്തി: $reason';
  }

  @override
  String get noReasonGiven => 'കാരണം നൽകിയിട്ടില്ല';

  @override
  String get keptWithRecordAuditNote =>
      'ഇത് രേഖയോടൊപ്പം സൂക്ഷിക്കും, ഓഡിറ്റ് ലോഗിലും കാണാം.';

  @override
  String get staffBadge => 'ജീവനക്കാർ';

  @override
  String get draftCrmNote =>
      'നിങ്ങളുടെ ജിം കരടാണ്. CRM പ്രവർത്തിക്കും, പക്ഷേ പ്ലാൻ സജീവമാകും വരെ അംഗങ്ങൾക്ക് തിരയലിൽ നിങ്ങളെ കാണാനാകില്ല.';

  @override
  String roleHiddenNote(String role) {
    return 'ഇവിടെ നിങ്ങൾ $role ആണ്. നിങ്ങളുടെ റോളിന് ചെയ്യാനാകാത്തവ കാണിച്ച് നിരസിക്കുന്നതിനു പകരം മറയ്ക്കുന്നു.';
  }

  @override
  String engagedOfActive(int engaged, int total) {
    return '$total അംഗങ്ങളിൽ $engaged പേർ ഒരിക്കലെങ്കിലും പരിശീലിച്ചു.';
  }

  @override
  String announceGoesTo(String audience) {
    return 'ഇത് ഉടൻ $audience എത്തും, തിരിച്ചെടുക്കാനാകില്ല.';
  }

  @override
  String get audienceEveryMember => 'എല്ലാ അംഗങ്ങളും';

  @override
  String get audienceEveryStaff => 'എല്ലാ ജീവനക്കാരും';

  @override
  String get audienceEveryone => 'ഈ ജിമ്മിലെ എല്ലാവരും';

  @override
  String sentToPeople(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count പേർക്ക് അയച്ചു.',
    );
    return '$_temp0';
  }

  @override
  String recipientCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count സ്വീകർത്താക്കൾ',
    );
    return '$_temp0';
  }

  @override
  String get weTextACodeFirst =>
      'ആദ്യം അവരുടെ നമ്പറിലേക്ക് ഒരു കോഡ് അയയ്ക്കും, അത് ശരിക്കും അവരുടേതാണെന്ന് ഉറപ്പാക്കാൻ.';

  @override
  String get memberCanUpdateMetrics =>
      'അവർക്ക് അംഗ ആപ്പിൽ ഭാരവും ഉയരവും കാണാനും മാറ്റാനും കഴിയും. അവർ സ്വയം ഓഫാക്കാത്തിടത്തോളം പുരോഗതി ജീവനക്കാർക്ക് കാണാം.';

  @override
  String get noRolesYouCanAssign =>
      'നിങ്ങൾക്ക് നൽകാവുന്ന റോളുകളില്ല. നിങ്ങളുടേതിന് താഴെയുള്ളവ മാത്രമേ നൽകാനാകൂ.';

  @override
  String get noRolesYouCanAssignToThem => 'അവർക്ക് നൽകാവുന്ന റോളുകളില്ല.';

  @override
  String heightCm(String cm) {
    return 'ഉയരം $cm സെ.മീ';
  }

  @override
  String weightOverCheckIns(String delta, int count) {
    return '$count പരിശോധനകളിൽ $delta കിലോ';
  }

  @override
  String get useDeviceLanguage => 'ഉപകരണ ഭാഷ ഉപയോഗിക്കുക';

  @override
  String get untranslatedFallbackNote =>
      'ഇനിയും വിവർത്തനം ചെയ്യാത്തവ ശൂന്യമായി വിടാതെ ഇംഗ്ലീഷിൽ കാണിക്കും, അതിനാൽ ഭാഗികമായി വിവർത്തനം ചെയ്ത ഭാഷയും ഉപയോഗിക്കാം.';

  @override
  String deleteGymWarning(int members, int staff) {
    return 'എല്ലാ $members അംഗങ്ങൾക്കും $staff ജീവനക്കാർക്കും പ്രവേശനം നഷ്ടപ്പെടും. ഇത് ആപ്പിൽ നിന്ന് പിൻവലിക്കാനാകില്ല.';
  }

  @override
  String shownAsInSearch(String name, String district) {
    return 'തിരയലിൽ “$name - $district” എന്ന് കാണും.';
  }

  @override
  String get nothingWaitingLeave =>
      'കാത്തിരിക്കുന്നതൊന്നുമില്ല. നിങ്ങളുടെ പരിധിക്കുള്ളിലെ അപേക്ഷകൾ സ്വയമേവ അംഗീകരിക്കപ്പെടും, ഇവിടെ വരില്ല.';

  @override
  String get quietPeriodsNote =>
      'ശാന്തമായ കാലങ്ങൾ ഒഴിവാക്കാതെ ശൂന്യ ബാറുകളായി കാണിക്കും, അതിനാൽ ബാറുകളിലെ വിടവ് യഥാർത്ഥ വിടവാണ്.';

  @override
  String get rankingExplainer =>
      'തിരയൽ ഫലങ്ങൾ ക്രമീകരിക്കുന്ന അതേ രീതിയിലാണ് സ്ഥാനം കണക്കാക്കുന്നത്: ആദ്യം റേറ്റിംഗ്, പിന്നെ എത്ര റേറ്റിംഗുകൾ അതിനെ പിന്തുണയ്ക്കുന്നു. ഇവിടെ കാണുന്നത് തന്നെയാണ് അംഗവും കാണുക.';

  @override
  String get deleteTrainerCategoryWarning =>
      'ഇനി ഈ വിഭാഗത്തിൽ പരിശീലകരെ ചേർക്കാനാകില്ല. ഇപ്പോൾ ഉള്ളവരുടെ നിയോഗം തുടരും.';

  @override
  String get youLabel => 'നിങ്ങൾ';

  @override
  String get openEvents => 'തുറന്ന ഇവന്റുകൾ';

  @override
  String get nothingHereYetSaySomething =>
      'ഇവിടെ ഇതുവരെ ഒന്നുമില്ല. എന്തെങ്കിലും പറയൂ.';

  @override
  String get leavePausesMembership =>
      'നിങ്ങൾ ഇല്ലാത്തപ്പോൾ അംഗത്വം താൽക്കാലികമായി നിർത്തും, അതിനാൽ പണമടച്ച ദിവസങ്ങൾ നിലനിൽക്കും.';

  @override
  String get notListedUntilPlan => 'പ്ലാൻ സജീവമാകും വരെ പൊതുവായി കാണില്ല.';

  @override
  String gymsListedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ജിമ്മുകൾ ലിസ്റ്റിൽ',
    );
    return '$_temp0';
  }

  @override
  String get checkInGoalNote =>
      'നിങ്ങളുടെ ലക്ഷ്യത്തിലേക്കുള്ള പുരോഗതി അറിയാൻ ജിം ഇത് ഉപയോഗിക്കുന്നു.';

  @override
  String get enterYourGymName => 'നിങ്ങളുടെ ജിമ്മിന്റെ പേര് നൽകുക';

  @override
  String get sessionExpiredSignIn =>
      'നിങ്ങളുടെ സെഷൻ കഴിഞ്ഞു. വീണ്ടും സൈൻ ഇൻ ചെയ്യുക.';

  @override
  String get somethingWentWrongTryAgain => 'എന്തോ പിഴച്ചു. വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get serverTookTooLong =>
      'സെർവർ മറുപടി നൽകാൻ വളരെ സമയമെടുത്തു. കണക്ഷൻ പരിശോധിച്ച് വീണ്ടും ശ്രമിക്കുക.';

  @override
  String couldNotReachServer(String host) {
    return '$host എന്ന സെർവറിലേക്ക് എത്താനായില്ല. നിങ്ങളുടെ ഇന്റർനെറ്റ് കണക്ഷൻ പരിശോധിക്കുക.';
  }

  @override
  String get certificateNotVerified =>
      'സെർവർ സർട്ടിഫിക്കറ്റ് പരിശോധിക്കാനായില്ല.';

  @override
  String get networkErrorTryAgain => 'നെറ്റ്‌വർക്ക് പിശക്. വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get enterValidMobile => '10 അക്ക ശരിയായ ഇന്ത്യൻ മൊബൈൽ നമ്പർ നൽകുക';

  @override
  String get enterValidTenDigitNumber => '10 അക്ക ശരിയായ നമ്പർ നൽകുക';

  @override
  String get enterYourName => 'നിങ്ങളുടെ പേര് നൽകുക';

  @override
  String get nameTooLong => 'ആ പേര് വളരെ നീളമുള്ളതാണ്';

  @override
  String get enterValidEmail => 'ശരിയായ ഇമെയിൽ വിലാസം നൽകുക';

  @override
  String get enterYourAge => 'നിങ്ങളുടെ പ്രായം നൽകുക';

  @override
  String get mustBeAtLeast13 => 'നിങ്ങളുടെ പ്രായം കുറഞ്ഞത് 13 വേണം';

  @override
  String get enterValidAge => 'ശരിയായ പ്രായം നൽകുക';

  @override
  String get enterWeightOrHeight => 'ഭാരമോ ഉയരമോ നൽകുക.';

  @override
  String get noRatingsYet => 'ഇതുവരെ റേറ്റിംഗുകളില്ല';

  @override
  String get giveItATitle => 'ഒരു തലക്കെട്ട് നൽകുക.';

  @override
  String get sayWhatYouWantThemToKnow => 'അവരെ എന്ത് അറിയിക്കണമെന്ന് എഴുതുക.';

  @override
  String get sayWhyThisIsChanging => 'ഇത് എന്തിനാണ് മാറ്റുന്നതെന്ന് എഴുതുക.';

  @override
  String get noMembersYetAddFirst =>
      'ഇതുവരെ അംഗങ്ങളില്ല. ആദ്യത്തെയാളെ ചേർക്കുക.';

  @override
  String get nobodyMatchedSearch => 'ആ തിരയലിൽ ആരും കണ്ടെത്തിയില്ല.';

  @override
  String get turningUp => 'വരവ്';

  @override
  String get justNow => 'ഇപ്പോൾ';

  @override
  String minutesAgo(int count) {
    return '$count മിനിറ്റ് മുൻപ്';
  }

  @override
  String hoursAgo(int count) {
    return '$count മണിക്കൂർ മുൻപ്';
  }

  @override
  String daysAgo(int count) {
    return '$count ദിവസം മുൻപ്';
  }

  @override
  String monthsAgo(int count) {
    return '$count മാസം മുൻപ്';
  }

  @override
  String get nowShort => 'ഇപ്പോൾ';

  @override
  String minutesShort(int count) {
    return '$count മി';
  }

  @override
  String hoursShort(int count) {
    return '$count മ';
  }

  @override
  String daysShort(int count) {
    return '$count ദി';
  }

  @override
  String weeksShort(int count) {
    return '$count ആ';
  }

  @override
  String addedNamed(String name) {
    return '$name ചേർത്തു';
  }

  @override
  String get saved => 'സംരക്ഷിച്ചു';

  @override
  String get trainerCategoriesIntro =>
      'പരിശീലകരെ ചേർക്കുമ്പോൾ ഇവയിലൊന്നിൽ ഉൾപ്പെടുത്തും. പരിശീലകരുള്ള വിഭാഗം അവരെ മാറ്റുന്നത് വരെ ഇല്ലാതാക്കാനാകില്ല.';

  @override
  String get trainerCategoriesReadOnly =>
      'ഈ ജിമ്മിലെ വിഭാഗങ്ങൾ നിങ്ങൾക്ക് കാണാം. മാറ്റാൻ പരിശീലക-നിർവഹണ അനുമതി വേണം.';

  @override
  String get oneTrainerManyMembersShort => 'ഒരു പരിശീലകൻ, പല അംഗങ്ങൾ';

  @override
  String get oneMemberPerTrainer => 'ഓരോ പരിശീലകനും ഒരു അംഗം';

  @override
  String get noTrainers => 'പരിശീലകരില്ല';

  @override
  String trainerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count പരിശീലകർ',
    );
    return '$_temp0';
  }

  @override
  String get deleteMoveTrainersFirst => 'നീക്കുക (ആദ്യം പരിശീലകരെ മാറ്റുക)';

  @override
  String get giveCategoryAName => 'വിഭാഗത്തിന് ഒരു പേര് നൽകുക';

  @override
  String get editCategory => 'വിഭാഗം തിരുത്തുക';

  @override
  String get newTrainerCategory => 'പുതിയ പരിശീലക വിഭാഗം';

  @override
  String get generalTrainingNote => 'പൊതു പരിശീലനത്തിനുള്ള സാധാരണ ക്രമീകരണം.';

  @override
  String get personalTrainingNote =>
      'വ്യക്തിഗത പരിശീലനം: ഇവിടത്തെ പരിശീലകൻ ഒരു സമയത്ത് ഒരു അംഗത്തെ മാത്രം എടുക്കും.';

  @override
  String get addCategory => 'വിഭാഗം ചേർക്കുക';

  @override
  String get listedPublicly => 'പൊതുവായി ലിസ്റ്റ് ചെയ്തു';

  @override
  String get yourMembersOnly => 'നിങ്ങളുടെ അംഗങ്ങൾക്ക് മാത്രം';

  @override
  String get whenDoesItStart => 'ഇത് എപ്പോൾ തുടങ്ങും?';

  @override
  String get chooseStartDateFirst => 'ആദ്യം ആരംഭ തീയതി തിരഞ്ഞെടുക്കുക.';

  @override
  String get lastDayToRegister => 'രജിസ്റ്റർ ചെയ്യാനുള്ള അവസാന ദിവസം';

  @override
  String get giveTheEventATitle => 'ഇവന്റിന് ഒരു തലക്കെട്ട് നൽകുക.';

  @override
  String get addADescription => 'ഒരു വിവരണം ചേർക്കുക, ചുരുങ്ങിയത് ഒരു വാചകം.';

  @override
  String get sayHowToTakePart => 'പങ്കെടുക്കാൻ എന്ത് ചെയ്യണമെന്ന് എഴുതുക.';

  @override
  String get pickTheDates => 'തീയതികൾ തിരഞ്ഞെടുക്കുക.';

  @override
  String startsAtWhen(String when) {
    return '$when തുടങ്ങും';
  }

  @override
  String registerByWhen(String when) {
    return '$when ന് മുൻപ് രജിസ്റ്റർ ചെയ്യുക';
  }

  @override
  String get selectYourLeaveDates => 'നിങ്ങളുടെ അവധി തീയതികൾ തിരഞ്ഞെടുക്കുക';

  @override
  String get chooseYourDatesFirst => 'ആദ്യം നിങ്ങളുടെ തീയതികൾ തിരഞ്ഞെടുക്കുക.';

  @override
  String get sentForApproval => 'അംഗീകാരത്തിനായി അയച്ചു.';

  @override
  String get leaveApprovedPaused =>
      'അവധി അംഗീകരിച്ചു. ആ ദിവസങ്ങളിൽ അംഗത്വം താൽക്കാലികമായി നിർത്തും.';

  @override
  String get chooseDates => 'തീയതികൾ തിരഞ്ഞെടുക്കുക';

  @override
  String leaveDaysLeftCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'നിങ്ങൾക്ക് $count അവധി ദിവസങ്ങൾ ബാക്കിയുണ്ട്.',
    );
    return '$_temp0';
  }

  @override
  String moreThanRemainingDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'ഇത് നിങ്ങളുടെ ബാക്കിയുള്ള $count ദിവസത്തിലും കൂടുതലാണ്, അതിനാൽ ഒരു മാനേജർ അംഗീകരിക്കണം.',
    );
    return '$_temp0';
  }

  @override
  String get withinYourAllowance =>
      'നിങ്ങളുടെ പരിധിക്കുള്ളിൽ — ഇത് ഉടൻ അംഗീകരിക്കപ്പെടും.';

  @override
  String get sendForApproval => 'അംഗീകാരത്തിനായി അയയ്ക്കുക';

  @override
  String get enterCodeSentToTheirPhone => 'അവരുടെ ഫോണിലേക്ക് അയച്ച കോഡ് നൽകുക.';

  @override
  String get numberIsNewNameNeeded =>
      'ഈ നമ്പർ പുതിയതാണ്, അതിനാൽ ഒരു പേര് വേണം.';

  @override
  String get chooseARole => 'ഒരു റോൾ തിരഞ്ഞെടുക്കുക.';

  @override
  String get isATrainer => 'Is a trainer?';

  @override
  String get chooseATrainerCategory => 'Choose a trainer category.';

  @override
  String get trainerCategory => 'Trainer category';

  @override
  String get addAMember => 'ഒരു അംഗത്തെ ചേർക്കുക';

  @override
  String get codeSentExistingAccount =>
      'കോഡ് അയച്ചു. ഈ നമ്പറിന് ഇതിനകം ജിമോളജിയ അക്കൗണ്ട് ഉണ്ട്.';

  @override
  String get codeSentNewAccount =>
      'കോഡ് അയച്ചു. ഈ നമ്പർ പുതിയതാണ്, അതിനാൽ ഞങ്ങൾ അക്കൗണ്ട് ഉണ്ടാക്കും.';

  @override
  String get membershipLength => 'അംഗത്വ കാലാവധി';

  @override
  String get leaveDaysAllowed => 'അനുവദിച്ച അവധി ദിവസങ്ങൾ';

  @override
  String get ownerStaffMode => 'ഉടമ / ജീവനക്കാർ മോഡ്';

  @override
  String get memberMode => 'അംഗ മോഡ്';

  @override
  String get managingGymsNote =>
      'നിങ്ങൾ ജിമ്മുകൾ കൈകാര്യം ചെയ്യുന്നു. അംഗമായി ജിമോളജിയ ഉപയോഗിക്കാൻ തിരികെ മാറുക.';

  @override
  String get openingAGymNote =>
      'ജിം തുറക്കുകയാണോ, അതോ ഒന്നിൽ ജോലി ചെയ്യുന്നോ? നിങ്ങളുടെ ജിമ്മിന്റെ CRM നടത്താൻ മാറുക — അംഗങ്ങൾ, ജീവനക്കാർ, ഹാജർ, അവധി.';

  @override
  String get numberIsHowYouSignIn =>
      'നിങ്ങളുടെ നമ്പർ ഉപയോഗിച്ചാണ് സൈൻ ഇൻ ചെയ്യുന്നത്, അതിനാൽ ഇവിടെ ഇപ്പോൾ മാറ്റാനാകില്ല.';

  @override
  String get followingYourDevice => 'നിങ്ങളുടെ ഉപകരണം അനുസരിച്ച്';

  @override
  String get yourGym => 'നിങ്ങളുടെ ജിം';

  @override
  String weeksRunning(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'തുടർച്ചയായ ആഴ്ചകൾ',
      one: 'തുടർച്ചയായ ആഴ്ച',
    );
    return '$_temp0';
  }

  @override
  String noVisitsInLastDays(int days) {
    return 'കഴിഞ്ഞ $days ദിവസത്തിൽ വരവ് രേഖപ്പെടുത്തിയിട്ടില്ല.';
  }

  @override
  String visitsInLastDays(int count, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'കഴിഞ്ഞ $days ദിവസത്തിൽ $count വരവുകൾ.',
    );
    return '$_temp0';
  }

  @override
  String get couldNotLoadEvents => 'ഇവന്റുകൾ ലോഡ് ചെയ്യാനായില്ല';

  @override
  String get noEventsOnRightNow => 'ഇപ്പോൾ ഇവന്റുകളൊന്നുമില്ല';

  @override
  String get eventsAppearHere =>
      'നിങ്ങളുടെ ജിം നടത്തുന്ന ഇവന്റുകൾ ഇവിടെ കാണാം, അടുത്ത് എല്ലാവർക്കും തുറന്നവയും.';

  @override
  String get atYourGym => 'നിങ്ങളുടെ ജിമ്മിൽ';

  @override
  String trainerStaffMembersAt(String gym) {
    return '$gym ലെ നിങ്ങളുടെ പരിശീലകൻ, ജീവനക്കാർ, അംഗങ്ങൾ';
  }

  @override
  String get trainerStaffOtherMembers =>
      'നിങ്ങളുടെ പരിശീലകൻ, ജീവനക്കാർ, മറ്റ് അംഗങ്ങൾ';

  @override
  String get comingNext => 'അടുത്തതായി';

  @override
  String get progressChartsAgainstGoal =>
      'നിങ്ങളുടെ ലക്ഷ്യത്തിനെതിരായ പുരോഗതി ചാർട്ടുകൾ';

  @override
  String get leaveLeft => 'ബാക്കി അവധി';

  @override
  String approvedMembershipPauses(String name) {
    return '$name അംഗീകരിച്ചു. ആ ദിവസങ്ങളിൽ അവരുടെ അംഗത്വം നിർത്തും.';
  }

  @override
  String get approveInstead => 'പകരം അംഗീകരിക്കുക';

  @override
  String get declineInstead => 'പകരം നിരസിക്കുക';

  @override
  String get needsYou => 'നിങ്ങളെ വേണം';

  @override
  String get autoApproved => 'സ്വയമേവ അംഗീകരിച്ചു';

  @override
  String get returnedEarly => 'നേരത്തെ മടങ്ങി';

  @override
  String get whereYouAre => 'നിങ്ങൾ എവിടെയാണ്';

  @override
  String get enterTheAddress => 'വിലാസം നൽകുക';

  @override
  String get maximumPerMembership => 'ഓരോ അംഗത്വത്തിനും പരമാവധി';

  @override
  String removeStaffWithAssigned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'അവർക്ക് ഈ ജിമ്മിലേക്കുള്ള പ്രവേശനം നഷ്ടപ്പെടും, അവർക്ക് നിയോഗിച്ച $count അംഗങ്ങൾക്ക് നിങ്ങൾ മറ്റൊരാളെ നിയോഗിക്കുന്നത് വരെ പരിശീലകൻ ഉണ്ടാകില്ല.',
    );
    return '$_temp0';
  }

  @override
  String get removeStaffPlain =>
      'അവർക്ക് ഈ ജിമ്മിലേക്കുള്ള പ്രവേശനം നഷ്ടപ്പെടും. അവരുടെ ഹാജർ രേഖ സൂക്ഷിക്കും.';

  @override
  String get couldNotLoadGyms => 'ജിമ്മുകൾ ലോഡ് ചെയ്യാനായില്ല';

  @override
  String get noGymsListedYet => 'ഇതുവരെ ജിമ്മുകൾ ലിസ്റ്റ് ചെയ്തിട്ടില്ല';

  @override
  String get gymsAppearOnPro =>
      'പ്രോ പ്ലാനിലുള്ളതും ലിസ്റ്റ് ചെയ്യാൻ തിരഞ്ഞെടുത്തതുമായ ജിമ്മുകൾ ഇവിടെ വരും.';

  @override
  String nothingMatchedTry(String query) {
    return '“$query” ന് ഒന്നും കണ്ടെത്തിയില്ല. മറ്റൊരു നഗരമോ ജില്ലയോ പരീക്ഷിക്കുക.';
  }

  @override
  String get noRatings => 'റേറ്റിംഗുകളില്ല';

  @override
  String get noPerksYet => 'ഇതുവരെ ആനുകൂല്യങ്ങളൊന്നും ലിസ്റ്റ് ചെയ്തിട്ടില്ല';

  @override
  String fromRatings(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count റേറ്റിംഗുകളിൽ നിന്ന്',
    );
    return '$_temp0';
  }

  @override
  String get onlyProGymHere => 'ഇവിടത്തെ ഏക പ്രോ ജിം';

  @override
  String ofProGyms(int count) {
    return '$count പ്രോ ജിമ്മുകളിൽ';
  }

  @override
  String get couldNotLoadYourGyms => 'നിങ്ങളുടെ ജിമ്മുകൾ ലോഡ് ചെയ്യാനായില്ല';

  @override
  String get noGymsYet => 'ഇതുവരെ ജിമ്മുകളില്ല';

  @override
  String get createYourGymBlurb =>
      'അംഗങ്ങൾ, ജീവനക്കാർ, ഹാജർ, അവധി ക്രമീകരിക്കാൻ നിങ്ങളുടെ ജിം ഉണ്ടാക്കുക. ഒരു ജിമ്മിൽ ജോലി ചെയ്യുന്നെങ്കിൽ ഉടമയോട് ചേർക്കാൻ പറയുക, അത് ഇവിടെ വരും.';

  @override
  String newGroupSelected(int count) {
    return 'പുതിയ ഗ്രൂപ്പ് ($count തിരഞ്ഞെടുത്തു)';
  }

  @override
  String get newMessage => 'പുതിയ സന്ദേശം';

  @override
  String get oneToOne => 'ഒന്നിനൊന്ന്';

  @override
  String get group => 'ഗ്രൂപ്പ്';

  @override
  String get buildMuscle => 'പേശി വളർത്തുക';

  @override
  String get loseFat => 'കൊഴുപ്പ് കുറയ്ക്കുക';

  @override
  String get getStronger => 'ശക്തി കൂട്ടുക';

  @override
  String get officialGroupEmpty =>
      'ഈ ജിമ്മിലെ എല്ലാവരും. ഇതുവരെ ഒന്നും പറഞ്ഞിട്ടില്ല.';

  @override
  String get unofficialGroupEmpty =>
      'അംഗങ്ങൾ മാത്രം. ഇതുവരെ ഒന്നും പറഞ്ഞിട്ടില്ല.';

  @override
  String get noMessagesYet => 'ഇതുവരെ സന്ദേശങ്ങളില്ല';

  @override
  String get approved => 'അംഗീകരിച്ചു';

  @override
  String get declined => 'നിരസിച്ചു';

  @override
  String get cancelled => 'റദ്ദാക്കി';

  @override
  String get flexibility => 'വഴക്കം';

  @override
  String get rehab => 'റീഹാബ്';

  @override
  String get youPrefix => 'നിങ്ങൾ: ';

  @override
  String get active => 'സജീവം';

  @override
  String get joined => 'ചേർന്നു';

  @override
  String get leftCount => 'വിട്ടു';

  @override
  String get net => 'അറ്റം';

  @override
  String get daily => 'ദിവസേന';

  @override
  String get monthly => 'പ്രതിമാസം';

  @override
  String get yearly => 'വാർഷികം';

  @override
  String get add => 'ചേർക്കുക';

  @override
  String get update => 'പുതുക്കുക';

  @override
  String get required => 'നിർബന്ധം';

  @override
  String get contact => 'ബന്ധപ്പെടാൻ';

  @override
  String get owner => 'ഉടമ';

  @override
  String get support => 'പിന്തുണ';

  @override
  String get machineTranslatedExercise =>
      'ഈ നിർദ്ദേശങ്ങൾ യന്ത്രം വിവർത്തനം ചെയ്തതാണ്, ഒരു പരിശീലകനും പരിശോധിച്ചിട്ടില്ല. എന്തെങ്കിലും വിചിത്രമായി തോന്നിയാൽ ഭാരം ഉയർത്തും മുൻപ് ഇംഗ്ലീഷിലേക്ക് മാറി ഒത്തുനോക്കുക.';

  @override
  String get home => 'ഹോം';

  @override
  String get myGym => 'എന്റെ ജിം';

  @override
  String get discover => 'കണ്ടെത്തുക';

  @override
  String get sendOtp => 'OTP അയയ്ക്കുക';

  @override
  String get verifyYourNumber => 'നിങ്ങളുടെ നമ്പർ സ്ഥിരീകരിക്കുക';

  @override
  String get codeResent => 'പുതിയ കോഡ് അയയ്ക്കുന്നു.';

  @override
  String get name => 'പേര്';

  @override
  String get email => 'ഇമെയിൽ';

  @override
  String get connection => 'കണക്ഷൻ';

  @override
  String get account => 'അക്കൗണ്ട്';

  @override
  String get session => 'സെഷൻ';

  @override
  String get earnByReferring => 'റഫർ ചെയ്ത് സമ്പാദിക്കുക';

  @override
  String get gyms => 'ജിമ്മുകൾ';

  @override
  String get events => 'ഇവന്റുകൾ';

  @override
  String get chat => 'ചാറ്റ്';

  @override
  String get findAGym => 'ജിം കണ്ടെത്തുക';

  @override
  String get searchGyms => 'പേരോ പ്രദേശമോ ഉപയോഗിച്ച് തിരയുക';

  @override
  String get perks => 'സൗകര്യങ്ങൾ';

  @override
  String get rating => 'റേറ്റിംഗ്';

  @override
  String get onLeavePaused => 'അവധിയിൽ — നിങ്ങളുടെ അംഗത്വം നിർത്തിവച്ചു';

  @override
  String get monthlyCheckIn => 'മാസ ചെക്ക്-ഇൻ';

  @override
  String get notNow => 'ഇപ്പോൾ വേണ്ട';

  @override
  String trainerNamed(String name) {
    return 'പരിശീലകൻ: $name';
  }

  @override
  String goalAtGym(String gym) {
    return '$gym-ൽ നിങ്ങളുടെ ലക്ഷ്യം';
  }

  @override
  String daysRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ദിവസം ബാക്കി',
      one: '1 ദിവസം ബാക്കി',
      zero: 'ഇന്ന് അവസാനിക്കുന്നു',
    );
    return '$_temp0';
  }

  @override
  String get yourGoal => 'നിങ്ങളുടെ ലക്ഷ്യം';

  @override
  String get trainer => 'പരിശീലകൻ';

  @override
  String get requestLeave => 'അവധി അപേക്ഷ';

  @override
  String get yourProgress => 'നിങ്ങളുടെ പുരോഗതി';

  @override
  String get addMeasurementsPrompt =>
      'നിങ്ങളുടെ ഭാരവും ഉയരവും ചേർക്കുക, അപ്പോൾ ജിമ്മിന് നിങ്ങളുടെ പുരോഗതി കാണാം.';

  @override
  String get progressSubtitle =>
      'കാലക്രമേണ ഭാരം, നിങ്ങൾ എത്ര തവണ വന്നു എന്നതും.';

  @override
  String get attendanceAppearsHere =>
      'നിങ്ങൾ ഒരു ജിമ്മിലെ അംഗമായി ജീവനക്കാർ ഹാജർ രേഖപ്പെടുത്താൻ തുടങ്ങിയാൽ ഇത് ഇവിടെ കാണാം.';

  @override
  String get twoCheckInsDrawALine =>
      'രണ്ട് രേഖപ്പെടുത്തലുകൾ ഒരു വര വരയ്ക്കും. എല്ലാ മാസവും ഭാരം ചേർത്താൽ ഇത് നിറയും.';

  @override
  String get nothingMatchesFilters =>
      'ഈ ഫിൽട്ടറുകൾക്ക് ഒന്നും യോജിക്കുന്നില്ല.';

  @override
  String get howToJoinGym =>
      'ചേരാൻ ജിമ്മുമായി നേരിട്ട് ബന്ധപ്പെടുക. അവർ നിങ്ങളെ അംഗമായി ചേർക്കും.';

  @override
  String get weight => 'ഭാരം';

  @override
  String get height => 'ഉയരം';

  @override
  String get yourMeasurements => 'നിങ്ങളുടെ അളവുകൾ';

  @override
  String get checkInDue => 'ഈ മാസത്തെ ചെക്ക്-ഇൻ ബാക്കിയുണ്ട്';

  @override
  String get thisMonth => 'ഈ മാസം';

  @override
  String get perWeek => 'ആഴ്ചയിൽ';

  @override
  String get lastEightWeeks => 'കഴിഞ്ഞ 8 ആഴ്ച';

  @override
  String get exerciseDirectory => 'വ്യായാമ പട്ടിക';

  @override
  String get exercises => 'വ്യായാമങ്ങൾ';

  @override
  String get searchExercises => 'വ്യായാമങ്ങൾ തിരയുക';

  @override
  String get clear => 'മായ്ക്കുക';

  @override
  String get howToDoIt => 'എങ്ങനെ ചെയ്യാം';

  @override
  String get watchOutFor => 'ശ്രദ്ധിക്കുക';

  @override
  String get whatYouGet => 'നിങ്ങൾക്ക് ലഭിക്കുന്നത്';

  @override
  String get removeYourEntry => 'നിങ്ങളുടെ പേര് നീക്കണോ?';

  @override
  String get stayIn => 'തുടരുക';

  @override
  String get removeMe => 'എന്നെ നീക്കുക';

  @override
  String get youAreInTapToWithdraw =>
      'നിങ്ങൾ ചേർന്നിട്ടുണ്ട് — പിന്മാറാൻ ടാപ്പ് ചെയ്യുക';

  @override
  String get participate => 'പങ്കെടുക്കുക';

  @override
  String takenOffList(String event) {
    return '$event പട്ടികയിൽ നിന്ന് നിങ്ങളുടെ പേര് നീക്കും.';
  }

  @override
  String contactWithPhone(String phone) {
    return 'ബന്ധപ്പെടുക $phone';
  }

  @override
  String get reasonOptional => 'കാരണം (ഐച്ഛികം)';

  @override
  String get searchByGymCityDistrict =>
      'ജിം, നഗരം അല്ലെങ്കിൽ ജില്ല ഉപയോഗിച്ച് തിരയുക';

  @override
  String get useMyLocation =>
      'അടുത്തുള്ള ജിമ്മുകൾ കണ്ടെത്താൻ എന്റെ ലൊക്കേഷൻ ഉപയോഗിക്കുക';

  @override
  String get findingNearbyGyms =>
      'നിങ്ങളുടെ അടുത്തുള്ള ജിമ്മുകൾ കണ്ടെത്തുന്നു…';

  @override
  String get locationUnavailable =>
      'നിങ്ങളുടെ ലൊക്കേഷൻ ലഭിച്ചില്ല — എല്ലാ ജിമ്മുകളും കാണിക്കുന്നു';

  @override
  String get exerciseDirectorySubtitle =>
      'കരുത്ത്, കാർഡിയോ, യോഗ — ഓരോ ഘട്ടത്തിന്റെയും നിർദ്ദേശങ്ങളോടെ';

  @override
  String get attendance => 'ഹാജർ';

  @override
  String get manage => 'നിർവഹണം';

  @override
  String get choosePlan => 'പ്ലാൻ തിരഞ്ഞെടുക്കുക';

  @override
  String get seeGrowthOverTime => 'കാലക്രമേണ വളർച്ച കാണുക';

  @override
  String lastNDays(int days) {
    return 'കഴിഞ്ഞ $days ദിവസം';
  }

  @override
  String get addMember => 'അംഗത്തെ ചേർക്കുക';

  @override
  String get addStaff => 'ജീവനക്കാരനെ ചേർക്കുക';

  @override
  String get searchByNameOrNumber => 'പേരോ നമ്പറോ ഉപയോഗിച്ച് തിരയുക';

  @override
  String get tapCircleToMarkPresent =>
      'ഹാജരിന് വൃത്തത്തിൽ ടാപ്പ് ചെയ്യുക, വിവരങ്ങൾക്ക് വരിയിൽ';

  @override
  String markedPresent(String name) {
    return '$name ഹാജരായി രേഖപ്പെടുത്തി';
  }

  @override
  String get approve => 'അംഗീകരിക്കുക';

  @override
  String get role => 'റോൾ';

  @override
  String get theirName => 'അവരുടെ പേര്';

  @override
  String get theirMobileNumber => 'അവരുടെ മൊബൈൽ നമ്പർ';

  @override
  String get codeFromTheirPhone => 'അവരുടെ ഫോണിലെ കോഡ്';

  @override
  String get whatDoTheyWant => 'അവർക്ക് ജിമ്മിൽ നിന്ന് എന്താണ് വേണ്ടത്?';

  @override
  String get goalHint => 'ഭാരം കൂട്ടൽ, കുറയ്ക്കൽ, റീഹാബ്…';

  @override
  String get saveChanges => 'മാറ്റങ്ങൾ സേവ് ചെയ്യുക';

  @override
  String get removeFromGym => 'ജിമ്മിൽ നിന്ന് നീക്കുക';

  @override
  String get remove => 'നീക്കുക';

  @override
  String removePerson(String name) {
    return '$name നീക്കണോ?';
  }

  @override
  String get onLeave => 'അവധിയിൽ';

  @override
  String get tapDayToCorrect => 'തിരുത്താൻ ഒരു ദിവസത്തിൽ ടാപ്പ് ചെയ്യുക';

  @override
  String correctDate(String date) {
    return '$date തിരുത്തുക';
  }

  @override
  String get whyIsThisChanging => 'ഇത് എന്തുകൊണ്ട് മാറുന്നു?';

  @override
  String get correctionReasonHint =>
      'തെറ്റായി രേഖപ്പെടുത്തി, യന്ത്രം പ്രവർത്തിച്ചില്ല…';

  @override
  String get saveCorrection => 'തിരുത്തൽ സേവ് ചെയ്യുക';

  @override
  String get recordCorrected => 'രേഖ തിരുത്തി.';

  @override
  String get trainerCategories => 'പരിശീലക വിഭാഗങ്ങൾ';

  @override
  String get newCategory => 'പുതിയ വിഭാഗം';

  @override
  String get noTrainerCategoriesYet => 'ഇതുവരെ പരിശീലക വിഭാഗങ്ങളില്ല.';

  @override
  String get oneTrainerManyMembers => 'ഒരു പരിശീലകന് പല അംഗങ്ങളെ എടുക്കാം';

  @override
  String get categoryNameHint => 'റീഹാബ്, സ്ട്രെങ്ത്, യോഗ';

  @override
  String get edit => 'തിരുത്തുക';

  @override
  String get delete => 'ഇല്ലാതാക്കുക';

  @override
  String get keepIt => 'നിലനിർത്തുക';

  @override
  String deleteNamed(String name) {
    return '$name ഇല്ലാതാക്കണോ?';
  }

  @override
  String get decline => 'നിരസിക്കുക';

  @override
  String decidedBy(String name) {
    return '$name തീരുമാനിച്ചു';
  }

  @override
  String get createAGym => 'ജിം ഉണ്ടാക്കുക';

  @override
  String get createYourGym => 'നിങ്ങളുടെ ജിം ഉണ്ടാക്കുക';

  @override
  String get gymName => 'ജിമ്മിന്റെ പേര്';

  @override
  String get gymNameHint => 'അയൺ ടെമ്പിൾ ഫിറ്റ്നസ്';

  @override
  String get descriptionOptional => 'വിവരണം (ഐച്ഛികം)';

  @override
  String get descriptionHint => 'നിങ്ങളുടെ ജിമ്മിൽ ചേരാൻ എന്താണ് പ്രത്യേകത?';

  @override
  String get address => 'വിലാസം';

  @override
  String get city => 'നഗരം';

  @override
  String get district => 'ജില്ല';

  @override
  String get districtNote =>
      'തിരയലിൽ ജിമ്മിന്റെ പേരിനൊപ്പം ജില്ല കാണിക്കും, അതിനാൽ അംഗങ്ങൾക്ക് തിരിച്ചറിയാം.';

  @override
  String get state => 'സംസ്ഥാനം';

  @override
  String get pinCode => 'പിൻ കോഡ്';

  @override
  String get contactNumber => 'ബന്ധപ്പെടാനുള്ള നമ്പർ';

  @override
  String get leavePolicyNote =>
      'അംഗങ്ങൾക്ക് മാസത്തിൽ ചില ദിവസം അംഗത്വം നിർത്താം. അതിലധികമായാൽ അനുമതി വേണം.';

  @override
  String get perksLabel => 'സൗകര്യങ്ങൾ, കോമ കൊണ്ട് വേർതിരിക്കുക';

  @override
  String get perksHint => 'സ്റ്റീം റൂം, സൗജന്യ പാർക്കിംഗ്, പേഴ്സണൽ ട്രെയിനിംഗ്';

  @override
  String get createGym => 'ജിം ഉണ്ടാക്കുക';

  @override
  String get deleteGym => 'ജിം ഇല്ലാതാക്കുക';

  @override
  String get gymProfile => 'ജിം പ്രൊഫൈൽ';

  @override
  String get description => 'വിവരണം';

  @override
  String get leavePolicy => 'അവധി നയം';

  @override
  String get leaveDaysPerMonth => 'മാസത്തിൽ അവധി ദിവസങ്ങൾ';

  @override
  String get deleteThisGym => 'ഈ ജിം ഇല്ലാതാക്കുക';

  @override
  String get leaveLimitNote =>
      'ഈ പരിധിക്കുള്ളിലെ അംഗങ്ങളുടെ അപേക്ഷകൾ സ്വയമേവ അംഗീകരിക്കപ്പെടും. അതിലധികമായാൽ ആരുടെയെങ്കിലും അനുമതി വേണം.';

  @override
  String get draftNote =>
      'നിങ്ങളുടെ ജിം കരടായി തുടങ്ങുന്നു. പരിശോധന പൂർത്തിയാക്കി പ്ലാൻ എടുക്കുന്നത് വരെ തിരയലിൽ വരില്ല.';

  @override
  String get sendThis => 'ഇത് അയയ്ക്കണോ?';

  @override
  String get send => 'അയയ്ക്കുക';

  @override
  String get announcements => 'അറിയിപ്പുകൾ';

  @override
  String get title => 'തലക്കെട്ട്';

  @override
  String get announceTitleHint => 'അറ്റകുറ്റപ്പണിക്കായി ഞായറാഴ്ച അടച്ചിരിക്കും';

  @override
  String get message => 'സന്ദേശം';

  @override
  String get announceBodyHint =>
      'തിങ്കളാഴ്ച രാവിലെ 6 മണിക്ക് വീണ്ടും തുറക്കും. ചുരുങ്ങിയ അറിയിപ്പിന് ക്ഷമിക്കണം.';

  @override
  String get whoSeesIt => 'ആരു കാണും';

  @override
  String get everyone => 'എല്ലാവരും';

  @override
  String get sendAnnouncement => 'അറിയിപ്പ് അയയ്ക്കുക';

  @override
  String get sent => 'അയച്ചു';

  @override
  String get newGym => 'പുതിയ ജിം';

  @override
  String get draft => 'കരട്';

  @override
  String get nothingToChartYet => 'ഇതുവരെ കാണിക്കാൻ ഒന്നുമില്ല.';

  @override
  String peakValue(int value) {
    return 'ഉച്ചസ്ഥായി $value';
  }

  @override
  String get searchRanking => 'തിരയൽ റാങ്കിംഗ്';

  @override
  String get notInSearch => 'തിരയലിൽ ഇല്ല';

  @override
  String get members => 'അംഗങ്ങൾ';

  @override
  String get staff => 'ജീവനക്കാർ';

  @override
  String get leave => 'അവധി';

  @override
  String get roles => 'റോളുകൾ';

  @override
  String get analytics => 'വിശകലനം';

  @override
  String get growth => 'വളർച്ച';

  @override
  String get ranking => 'റാങ്കിംഗ്';

  @override
  String get plan => 'പ്ലാൻ';

  @override
  String get announce => 'അറിയിപ്പ്';

  @override
  String get trainers => 'പരിശീലകർ';

  @override
  String get present => 'ഹാജർ';

  @override
  String get absent => 'ഹാജരല്ല';

  @override
  String get markAttendance => 'ഹാജർ രേഖപ്പെടുത്തുക';

  @override
  String get getHelp => 'സഹായം തേടുക';

  @override
  String get getHelpSubtitle =>
      'ഞങ്ങൾക്ക് സന്ദേശം അയയ്ക്കുക, ഞങ്ങൾ ബന്ധപ്പെടും';

  @override
  String get termsAndPrivacy => 'നിബന്ധനകളും സ്വകാര്യതയും';

  @override
  String get signOut => 'സൈൻ ഔട്ട്';

  @override
  String get switchToStaff => 'ഉടമ/ജീവനക്കാർ മോഡിലേക്ക് മാറുക';

  @override
  String get switchToMember => 'അംഗ മോഡിലേക്ക് മാറുക';

  @override
  String get notifications => 'അറിയിപ്പുകൾ';

  @override
  String get needsReview => 'വിവർത്തനം പരിശോധിക്കാനുണ്ട്';

  @override
  String get block => 'ബ്ലോക്ക് ചെയ്യുക';

  @override
  String get unblock => 'അൺബ്ലോക്ക് ചെയ്യുക';

  @override
  String get report => 'റിപ്പോർട്ട് ചെയ്യുക';

  @override
  String blockPerson(String name) {
    return '$name നെ ബ്ലോക്ക് ചെയ്യുക';
  }

  @override
  String reportPerson(String name) {
    return '$name നെക്കുറിച്ച് റിപ്പോർട്ട് ചെയ്യുക';
  }

  @override
  String get blockConfirmBody =>
      'അവർക്ക് നിങ്ങൾക്ക് സന്ദേശം അയയ്ക്കാനാവില്ല, അവരുടെ സന്ദേശങ്ങൾ നിങ്ങൾ കാണുകയുമില്ല. നിങ്ങൾ ബ്ലോക്ക് ചെയ്തതായി അവരോട് പറയില്ല. ക്രമീകരണങ്ങളിൽ ഇത് മാറ്റാം.';

  @override
  String get blocked => 'ബ്ലോക്ക് ചെയ്തു';

  @override
  String get blockedAccounts => 'ബ്ലോക്ക് ചെയ്ത അക്കൗണ്ടുകൾ';

  @override
  String get noBlockedAccounts => 'നിങ്ങൾ ആരെയും ബ്ലോക്ക് ചെയ്തിട്ടില്ല.';

  @override
  String get safetyAndPrivacy => 'സുരക്ഷ';

  @override
  String unblockQuestion(String name) {
    return '$name നെ അൺബ്ലോക്ക് ചെയ്യണോ?';
  }

  @override
  String get unblockExplainer =>
      'അവർക്ക് വീണ്ടും നിങ്ങൾക്ക് സന്ദേശം അയയ്ക്കാനാകും.';

  @override
  String get whyReporting => 'എന്താണ് പ്രശ്നം?';

  @override
  String get reportDetails => 'എന്താണ് സംഭവിച്ചത്?';

  @override
  String get reportDetailsHint =>
      'അവലോകകർ സന്ദേശം നേരിട്ട് കാണുന്നില്ല. അവർ വായിക്കുന്നത് നിങ്ങളുടെ വിവരണമാണ്, അതിനാൽ എന്താണ് പറഞ്ഞതെന്ന് നിങ്ങളുടെ വാക്കുകളിൽ പറയുക.';

  @override
  String get alsoBlockThem => 'അവരെ ബ്ലോക്ക് കൂടി ചെയ്യുക';

  @override
  String get alsoBlockThemExplainer =>
      'റിപ്പോർട്ട് ഒരാൾ വായിക്കും, അതിന് സമയമെടുക്കും. ബ്ലോക്ക് ചെയ്യുന്നത് ഉടനടി പ്രവർത്തിക്കും.';

  @override
  String get sendReport => 'റിപ്പോർട്ട് അയയ്ക്കുക';

  @override
  String get reportCategorySpam => 'സ്പാം അല്ലെങ്കിൽ അനാവശ്യ വിൽപ്പന';

  @override
  String get reportCategoryHarassment => 'ഉപദ്രവം അല്ലെങ്കിൽ ഭീഷണിപ്പെടുത്തൽ';

  @override
  String get reportCategorySexual => 'ലൈംഗികമോ അശ്ലീലമോ ആയ ഉള്ളടക്കം';

  @override
  String get reportCategoryHate => 'വിദ്വേഷ പ്രസംഗം';

  @override
  String get reportCategoryViolence => 'അക്രമം അല്ലെങ്കിൽ ഭീഷണി';

  @override
  String get reportCategoryScam => 'തട്ടിപ്പ് അല്ലെങ്കിൽ വഞ്ചന';

  @override
  String get reportCategoryImpersonation => 'മറ്റൊരാളായി ഭാവിക്കൽ';

  @override
  String get reportCategoryOther => 'മറ്റെന്തെങ്കിലും';

  @override
  String get reportSent => 'നന്ദി. ആരെങ്കിലും ഇത് പരിശോധിക്കും.';

  @override
  String get myReports => 'ഞാൻ അയച്ച റിപ്പോർട്ടുകൾ';

  @override
  String get reportStatusOpen => 'പരിശോധനയ്ക്കായി കാത്തിരിക്കുന്നു';

  @override
  String get reportStatusReviewing => 'പരിശോധിക്കുന്നു';

  @override
  String get reportStatusActioned => 'നടപടി സ്വീകരിച്ചു';

  @override
  String get reportStatusDismissed => 'പരിശോധിച്ചു, നടപടിയില്ല';

  @override
  String get noReportsSent =>
      'നിങ്ങൾ ആരെക്കുറിച്ചും റിപ്പോർട്ട് ചെയ്തിട്ടില്ല.';

  @override
  String get deleteAccount => 'അക്കൗണ്ട് ഇല്ലാതാക്കുക';

  @override
  String get deleteAccountIntro =>
      'നിങ്ങളുടെ അക്കൗണ്ട് 30 ദിവസം ഉപയോഗിക്കാം. അതിനുശേഷം അത് ഇല്ലാതാക്കും, തിരികെ ലഭിക്കില്ല.';

  @override
  String get whatIsDeleted => 'എന്തൊക്കെ ഇല്ലാതാകും';

  @override
  String get whatIsDeletedList =>
      'നിങ്ങളുടെ പേര്, നമ്പർ, ഇമെയിൽ, പ്രായം. ഉയരം, ഭാരം, പുരോഗതി. നിങ്ങളുടെ ചാറ്റ് സന്ദേശങ്ങൾ. തിരിച്ചറിയൽ രേഖകളും UPI വിവരങ്ങളും.';

  @override
  String get whatIsKept => 'എന്തൊക്കെ സൂക്ഷിക്കും, നിങ്ങളെ ഒഴിവാക്കി';

  @override
  String get whatIsKeptList =>
      'പേയ്‌മെന്റ്, ഇൻവോയ്‌സ് രേഖകൾ, കണക്കുപുസ്തകം സൂക്ഷിക്കാൻ നിയമം ആവശ്യപ്പെടുന്നതിനാൽ. ജിമ്മിൽ നടന്ന നടപടികളുടെ രേഖ, തർക്കങ്ങൾ തീർക്കാൻ.';

  @override
  String get deleteGymsFirst =>
      'നിങ്ങൾക്ക് ഇപ്പോഴും ഒരു ജിം ഉണ്ട്. ആദ്യം അത് ഇല്ലാതാക്കുക — നിങ്ങളുടെ അക്കൗണ്ട് ഇല്ലാതാക്കിയാൽ അതിലെ എല്ലാ അംഗങ്ങൾക്കും ജീവനക്കാർക്കും പ്രവേശനം നഷ്ടമാകും, ഇത് അടച്ചുപൂട്ടിയെന്ന് അവരെ അറിയിക്കും.';

  @override
  String unwithdrawnWarning(String amount) {
    return 'നിങ്ങൾ പിൻവലിക്കാത്ത $amount റഫറൽ വരുമാനം ഉണ്ട്. ആദ്യം Gymologia Referral ആപ്പിൽ പിൻവലിക്കുക, അല്ലെങ്കിൽ അത് നഷ്ടപ്പെടും.';
  }

  @override
  String get iUnderstandLoseEarnings =>
      'ഈ പണം നഷ്ടപ്പെടുമെന്ന് ഞാൻ മനസ്സിലാക്കുന്നു';

  @override
  String deletionScheduled(String date) {
    return 'നിങ്ങളുടെ അക്കൗണ്ട് $date-ന് ഇല്ലാതാക്കും.';
  }

  @override
  String get keepMyAccount => 'എന്റെ അക്കൗണ്ട് നിലനിർത്തുക';

  @override
  String get deletionCancelled => 'നിങ്ങളുടെ അക്കൗണ്ട് ഇല്ലാതാക്കില്ല.';

  @override
  String get deleteAccountConfirm => 'എന്റെ അക്കൗണ്ട് ഇല്ലാതാക്കുക';

  @override
  String get about => 'വിവരണം';

  @override
  String get participated => 'നിങ്ങൾ ചേർന്നു';

  @override
  String letsGoName(String name) {
    return 'വരൂ, $name';
  }

  @override
  String get yourTraining => 'നിങ്ങളുടെ പരിശീലനം';

  @override
  String get tagline => 'പരിശീലിക്കൂ. ട്രാക്ക് ചെയ്യൂ. മാറൂ.';

  @override
  String get appearance => 'രൂപഭാവം';

  @override
  String get themeDark => 'ഡാർക്ക്';

  @override
  String get themeLight => 'ലൈറ്റ്';
}
