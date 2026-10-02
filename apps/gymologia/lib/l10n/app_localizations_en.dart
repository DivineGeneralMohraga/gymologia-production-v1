// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Gymologia';

  @override
  String get languageName => 'English';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get languageSubtitle =>
      'Choose the language you read most comfortably';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get tryAgain => 'Try again';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get phoneNumber => 'Phone number';

  @override
  String get enterPhoneNumber => 'Enter your mobile number';

  @override
  String get sendCode => 'Send code';

  @override
  String get verifyCode => 'Verify';

  @override
  String get resendCode => 'Send it again';

  @override
  String get createAccount => 'Create your account';

  @override
  String get emailOptional => 'Email (optional)';

  @override
  String get age => 'Age';

  @override
  String get whyAgeNotBirthday =>
      'We ask for your age, not your date of birth. A date of birth is tied to your bank and government records — an age is all a gym app needs.';

  @override
  String get termsAgreement =>
      'Creating an account means you accept the Terms of Use and Privacy Policy.';

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
  String get signInWithMobile => 'Sign in with your mobile number';

  @override
  String get mobileNumber => 'Mobile number';

  @override
  String get couldNotSendCode => 'Could not send the code.';

  @override
  String get verificationFailed => 'Verification failed.';

  @override
  String get couldNotResendCode => 'Could not resend the code.';

  @override
  String get couldNotCreateAccount => 'Could not create your account.';

  @override
  String weSentCodeTo(String phone) {
    return 'We sent a code to $phone';
  }

  @override
  String resendInSeconds(int seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String get verified => 'Verified';

  @override
  String get createAccountAction => 'Create account';

  @override
  String get supportSent => 'Sent. Someone will reply on the number you gave.';

  @override
  String get supportSubject => 'What is this about?';

  @override
  String get supportSubjectHint => 'My membership days look wrong';

  @override
  String get supportMessage => 'Tell us what happened';

  @override
  String get supportReplyTo => 'Where should we reply?';

  @override
  String get supportUrgent => 'This is stopping my gym from operating';

  @override
  String get supportUrgentNote => 'Raises the priority.';

  @override
  String copiedToClipboard(String value) {
    return '$value copied';
  }

  @override
  String orEmailUs(String email) {
    return 'Or email $email';
  }

  @override
  String get whatYouHaveAsked => 'WHAT YOU HAVE ASKED';

  @override
  String get aFewWordsIsEnough => 'A few words is enough';

  @override
  String get aSentenceOrTwoHelps => 'A sentence or two helps us fix it faster';

  @override
  String get ticketOpen => 'Waiting for someone to pick it up';

  @override
  String get ticketInProgress => 'Someone is looking at it';

  @override
  String get ticketWaitingOnUser => 'Waiting on your reply';

  @override
  String get ticketResolved => 'Resolved';

  @override
  String get ticketClosed => 'Closed';

  @override
  String get referralPitch =>
      'Share a code, and earn when a gym owner subscribes. The referral app is not out yet.';

  @override
  String get appTagline => 'Gymologia · member and staff';

  @override
  String get signOutQuestion => 'Sign out?';

  @override
  String get signOutWarning => 'You will need your phone to sign back in.';

  @override
  String get profileUpdated => 'Profile updated.';

  @override
  String get yourProfile => 'Your profile';

  @override
  String get emailClearToRemove => 'Optional. Clear it to remove.';

  @override
  String get phoneIsYourLogin =>
      'This is how you sign in, so it cannot be changed here yet. Contact support if you need it moved.';

  @override
  String get trialStarted => 'Trial started. Your gym is now listed in search.';

  @override
  String get invalidCode => 'Invalid code.';

  @override
  String get paymentNotCompletedYet =>
      'Payment has not completed yet. Pull to refresh in a moment.';

  @override
  String planIsActive(String plan) {
    return '$plan plan is active.';
  }

  @override
  String get paymentNotCompleted => 'Payment was not completed.';

  @override
  String get couldNotOpenPayment => 'Could not open the payment screen.';

  @override
  String daysFree(int days) {
    return '$days days free';
  }

  @override
  String get trialBlurb =>
      'Full Pro, including your listing in member search. No card needed, and it does not renew into a paid plan on its own.';

  @override
  String get startFreeTrial => 'Start free trial';

  @override
  String get referralCode => 'Referral code';

  @override
  String get optional => 'Optional';

  @override
  String get apply => 'Apply';

  @override
  String get gstNote =>
      'Prices include GST. A gym is only listed in member search on the Pro plan.';

  @override
  String planNamed(String plan) {
    return '$plan plan';
  }

  @override
  String get trialBadge => 'TRIAL';

  @override
  String get expired => 'Expired';

  @override
  String daysRemainingPlan(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days remaining',
      one: '1 day remaining',
    );
    return '$_temp0';
  }

  @override
  String get listedInSearch => 'Listed in member search';

  @override
  String get notListedUpgrade =>
      'Not listed in search — upgrade to Pro to appear';

  @override
  String get trialEndsNote =>
      'When the trial ends your gym drops out of search until you choose a plan. Nothing is charged automatically.';

  @override
  String get getsYouListed => 'GETS YOU LISTED';

  @override
  String get perMonth => '/month';

  @override
  String choosePlanNamed(String plan) {
    return 'Choose $plan';
  }

  @override
  String get deleteRoleWarning =>
      'The role and its permissions go. Nobody is in it, so nobody loses access.';

  @override
  String deletedNamed(String name) {
    return '$name deleted';
  }

  @override
  String get needTwoCustomRoles =>
      'You need two custom roles you can edit before reordering.';

  @override
  String get hierarchySaved => 'Hierarchy saved';

  @override
  String get reorder => 'Reorder';

  @override
  String get newRole => 'New role';

  @override
  String get rolesIntro =>
      'Listed most senior first. You can only edit roles below your own, and only hand out permissions you hold yourself.';

  @override
  String get defaultBadge => 'DEFAULT';

  @override
  String get everyPermission => 'Every permission, including any added later';

  @override
  String permissionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count permissions',
      one: '1 permission',
    );
    return '$_temp0';
  }

  @override
  String get nobodyInThisRole => 'Nobody in this role';

  @override
  String peopleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count people',
      one: '1 person',
    );
    return '$_temp0';
  }

  @override
  String get deleteDefaultRolesStay => 'Delete (default roles stay)';

  @override
  String get deleteMovePeopleFirst => 'Delete (move people out first)';

  @override
  String get giveRoleAName => 'Give the role a name';

  @override
  String get editRole => 'Edit role';

  @override
  String get createRole => 'Create role';

  @override
  String get roleName => 'Role name';

  @override
  String get roleNameHint => 'Front desk, Physio, Night shift';

  @override
  String get superRoleNote =>
      'This role holds every permission, including any added in future. That cannot be narrowed — it is what makes it the role that can always fix things.';

  @override
  String get whatThisRoleCanDo => 'What this role can do';

  @override
  String get greyedOutNote =>
      'Anything greyed out is something you do not hold yourself, so you cannot pass it on.';

  @override
  String get ownerOnlyPermission => 'Belongs to the gym owner alone';

  @override
  String get youDoNotHoldThis => 'You do not hold this';

  @override
  String get orderTheHierarchy => 'Order the hierarchy';

  @override
  String get hierarchyNote =>
      'Most senior at the top. Default roles keep their place and are not listed.';

  @override
  String get saveOrder => 'Save order';

  @override
  String membershipExtendedBy(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Membership extended by $count months.',
      one: 'Membership extended by 1 month.',
    );
    return '$_temp0';
  }

  @override
  String get goalUpdated => 'Goal updated.';

  @override
  String get thisMember => 'this member';

  @override
  String get removeMemberQuestion => 'Remove member?';

  @override
  String removeMemberWarning(String name) {
    return '$name loses access to this gym. Their attendance history and measurements are kept.';
  }

  @override
  String get member => 'Member';

  @override
  String get removeMember => 'Remove member';

  @override
  String get daysLeft => 'Days left';

  @override
  String get leaveUsed => 'Leave used';

  @override
  String get extend => 'Extend';

  @override
  String get editGoal => 'Edit goal';

  @override
  String get goal => 'Goal';

  @override
  String get notSet => 'Not set';

  @override
  String get noneAssigned => 'None assigned';

  @override
  String get attendanceHistory => 'Attendance history';

  @override
  String get viewAndCorrectRecords => 'View and correct records';

  @override
  String sessionsSoFar(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sessions so far',
      one: '1 session so far',
    );
    return '$_temp0';
  }

  @override
  String get progressIsPrivate => 'Progress is private';

  @override
  String get monitoringOffNote =>
      'This member has turned off progress monitoring. That is their choice and no role can override it.';

  @override
  String get progress => 'Progress';

  @override
  String get noMeasurementsYet =>
      'No measurements recorded yet. The member is prompted for these in their own app once a month.';

  @override
  String holdingAtKg(String kg) {
    return 'Holding at $kg kg';
  }

  @override
  String weightChangeSince(String delta) {
    return '$delta kg since their first measurement';
  }

  @override
  String get extendMembership => 'Extend membership';

  @override
  String get extendFromTodayNote =>
      'An expired membership extends from today, not from the date it lapsed.';

  @override
  String monthsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count months',
      one: '1 month',
    );
    return '$_temp0';
  }

  @override
  String extendByMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Extend by $count months',
      one: 'Extend by 1 month',
    );
    return '$_temp0';
  }

  @override
  String get whatAreTheyWorkingTowards => 'What are they working towards?';

  @override
  String get goalDialogHint => 'Bulk up to 80kg, lose weight, rehab…';

  @override
  String signedUpCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count signed up',
      one: '1 signed up',
    );
    return '$_temp0';
  }

  @override
  String get nobodyYet => 'Nobody yet.';

  @override
  String get hostAnEvent => 'Host an event';

  @override
  String get noEventsYet =>
      'No events yet. Host one and it will show up for your members straight away.';

  @override
  String get editEvent => 'Edit event';

  @override
  String get cancelEvent => 'Cancel event';

  @override
  String get cancelEventConfirmTitle => 'Cancel this event?';

  @override
  String get cancelEventConfirmBody =>
      'This permanently deletes the event, including the list of who signed up. This cannot be undone.';

  @override
  String get keepEvent => 'Keep event';

  @override
  String get eventUpdated => 'Event updated';

  @override
  String get eventCancelledSnackbar => 'Event deleted';

  @override
  String get eventTitleHint => 'Summer Deadlift Meet';

  @override
  String get howToTakePart => 'How to take part';

  @override
  String get howToTakePartHint => 'Weigh-in at 8am. Bring your own belt.';

  @override
  String get prizeOptional => 'Prize (optional)';

  @override
  String get prizeHint => 'Rs 10,000';

  @override
  String get membersCanSignUp => 'Members can sign up in the app';

  @override
  String get membersCanSignUpNote =>
      'Turn off and they see your requirements instead of a button.';

  @override
  String get listPublicly => 'List publicly';

  @override
  String get listPubliclyNote => 'Shows in the events feed across the country.';

  @override
  String get listPubliclyProOnly =>
      'Pro plan only. Your members will still see it.';

  @override
  String get openToOutsiders => 'Open to people outside your gym';

  @override
  String get publishEvent => 'Publish event';

  @override
  String get registrationOpen => 'registration open';

  @override
  String get registrationClosed => 'registration closed';

  @override
  String get close => 'Close';

  @override
  String get markAllRead => 'Mark all read';

  @override
  String get nothingYet => 'Nothing yet';

  @override
  String get announcementsAppearHere =>
      'Announcements from your gym and from Gymologia will appear here.';

  @override
  String get searchPeople => 'Search people';

  @override
  String get nobodyElseHereYet => 'Nobody else here yet.';

  @override
  String get nameTheGroup => 'Name the group';

  @override
  String get groupNameHint => 'Saturday morning crew';

  @override
  String get create => 'Create';

  @override
  String get pickWhoIsInTheGroup => 'Pick who is in the group';

  @override
  String createGroupWith(int count) {
    return 'Create group with $count';
  }

  @override
  String get termsOfUse => 'Terms of Use';

  @override
  String get privacy => 'Privacy';

  @override
  String versionUpdated(String version, String date) {
    return 'Version $version · updated $date';
  }

  @override
  String sessionsAttendedAllTime(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'sessions attended, all time',
      one: 'session attended, all time',
    );
    return '$_temp0';
  }

  @override
  String get nothingInLast60Days => 'Nothing recorded in the last 60 days.';

  @override
  String correctedReason(String reason) {
    return 'Corrected: $reason';
  }

  @override
  String get noReasonGiven => 'no reason given';

  @override
  String get keptWithRecordAuditNote =>
      'This is kept with the record and shows in the audit log.';

  @override
  String get staffBadge => 'STAFF';

  @override
  String get draftCrmNote =>
      'Your gym is a draft. The CRM works, but members cannot find you in search until a plan is active.';

  @override
  String roleHiddenNote(String role) {
    return 'You are $role here. Anything your role cannot do is hidden rather than shown and refused.';
  }

  @override
  String engagedOfActive(int engaged, int total) {
    return '$engaged of $total members trained at least once.';
  }

  @override
  String announceGoesTo(String audience) {
    return 'It goes to $audience right now, and cannot be unsent.';
  }

  @override
  String get audienceEveryMember => 'every member';

  @override
  String get audienceEveryStaff => 'every staff member';

  @override
  String get audienceEveryone => 'everyone at this gym';

  @override
  String sentToPeople(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sent to $count people.',
      one: 'Sent to 1 person.',
    );
    return '$_temp0';
  }

  @override
  String recipientCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recipients',
      one: '1 recipient',
    );
    return '$_temp0';
  }

  @override
  String get weTextACodeFirst =>
      'We text a code to their number first, so you know it is really theirs.';

  @override
  String get memberCanUpdateMetrics =>
      'They can see and update their weight and height in the member app. Their progress is visible to staff unless they turn that off themselves.';

  @override
  String get noRolesYouCanAssign =>
      'There are no roles you can assign. Only roles junior to your own can be given out.';

  @override
  String get noRolesYouCanAssignToThem =>
      'There are no roles you can assign to them.';

  @override
  String heightCm(String cm) {
    return 'Height $cm cm';
  }

  @override
  String weightOverCheckIns(String delta, int count) {
    return '$delta kg over $count check-ins';
  }

  @override
  String get useDeviceLanguage => 'Use device language';

  @override
  String get untranslatedFallbackNote =>
      'Anything not yet translated is shown in English rather than left blank, so a partly translated language is still usable.';

  @override
  String deleteGymWarning(int members, int staff) {
    return 'All $members members and $staff staff lose access. This cannot be undone from the app.';
  }

  @override
  String shownAsInSearch(String name, String district) {
    return 'Shown as “$name - $district” in search.';
  }

  @override
  String get nothingWaitingLeave =>
      'Nothing waiting. Requests inside your limits are approved automatically and never appear here.';

  @override
  String get quietPeriodsNote =>
      'Quiet periods are shown as empty bars rather than left out, so a gap in the bars is a real gap.';

  @override
  String get rankingExplainer =>
      'Position is worked out the same way search orders results: rating first, then how many ratings back it up. What you see here is what a member browsing would see.';

  @override
  String get deleteTrainerCategoryWarning =>
      'Trainers can no longer be put in this category. Anyone already in it keeps their assignment.';

  @override
  String get youLabel => 'you';

  @override
  String get openEvents => 'OPEN EVENTS';

  @override
  String get nothingHereYetSaySomething => 'Nothing here yet. Say something.';

  @override
  String get leavePausesMembership =>
      'Your membership pauses while you are away, so you keep the days you paid for.';

  @override
  String get notListedUntilPlan =>
      'Not listed publicly until a plan is active.';

  @override
  String gymsListedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gyms listed',
      one: '1 gym listed',
    );
    return '$_temp0';
  }

  @override
  String get checkInGoalNote =>
      'Your gym uses this to track progress towards your goal.';

  @override
  String get enterYourGymName => 'Enter your gym name';

  @override
  String get sessionExpiredSignIn =>
      'Your session expired. Please sign in again.';

  @override
  String get somethingWentWrongTryAgain =>
      'Something went wrong. Please try again.';

  @override
  String get serverTookTooLong =>
      'The server took too long to respond. Check your connection and try again.';

  @override
  String couldNotReachServer(String host) {
    return 'Could not reach the server at $host. Check your internet connection.';
  }

  @override
  String get certificateNotVerified =>
      'The server certificate could not be verified.';

  @override
  String get networkErrorTryAgain => 'Network error. Please try again.';

  @override
  String get enterValidMobile => 'Enter a valid 10-digit Indian mobile number';

  @override
  String get enterValidTenDigitNumber => 'Enter a valid 10-digit number';

  @override
  String get enterYourName => 'Enter your name';

  @override
  String get nameTooLong => 'That name is too long';

  @override
  String get enterValidEmail => 'Enter a valid email address';

  @override
  String get enterYourAge => 'Enter your age';

  @override
  String get mustBeAtLeast13 => 'You must be at least 13';

  @override
  String get enterValidAge => 'Enter a valid age';

  @override
  String get enterWeightOrHeight => 'Enter a weight or a height.';

  @override
  String get noRatingsYet => 'No ratings yet';

  @override
  String get giveItATitle => 'Give it a title.';

  @override
  String get sayWhatYouWantThemToKnow => 'Say what you want them to know.';

  @override
  String get sayWhyThisIsChanging => 'Say why this is being changed.';

  @override
  String get noMembersYetAddFirst => 'No members yet. Add your first one.';

  @override
  String get nobodyMatchedSearch => 'Nobody matched that search.';

  @override
  String get turningUp => 'Turning up';

  @override
  String get justNow => 'just now';

  @override
  String minutesAgo(int count) {
    return '${count}m ago';
  }

  @override
  String hoursAgo(int count) {
    return '${count}h ago';
  }

  @override
  String daysAgo(int count) {
    return '${count}d ago';
  }

  @override
  String monthsAgo(int count) {
    return '${count}mo ago';
  }

  @override
  String get nowShort => 'now';

  @override
  String minutesShort(int count) {
    return '${count}m';
  }

  @override
  String hoursShort(int count) {
    return '${count}h';
  }

  @override
  String daysShort(int count) {
    return '${count}d';
  }

  @override
  String weeksShort(int count) {
    return '${count}w';
  }

  @override
  String addedNamed(String name) {
    return '$name added';
  }

  @override
  String get saved => 'Saved';

  @override
  String get trainerCategoriesIntro =>
      'Trainers are put in one of these when they are added. A category holding trainers cannot be deleted until they are moved.';

  @override
  String get trainerCategoriesReadOnly =>
      'You can see the categories at this gym. Changing them needs the manage-trainers permission.';

  @override
  String get oneTrainerManyMembersShort => 'One trainer, many members';

  @override
  String get oneMemberPerTrainer => 'One member per trainer';

  @override
  String get noTrainers => 'No trainers';

  @override
  String trainerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count trainers',
      one: '1 trainer',
    );
    return '$_temp0';
  }

  @override
  String get deleteMoveTrainersFirst => 'Delete (move trainers first)';

  @override
  String get giveCategoryAName => 'Give the category a name';

  @override
  String get editCategory => 'Edit category';

  @override
  String get newTrainerCategory => 'New trainer category';

  @override
  String get generalTrainingNote => 'The usual setting for general training.';

  @override
  String get personalTrainingNote =>
      'Personal training: a trainer here takes one member at a time.';

  @override
  String get addCategory => 'Add category';

  @override
  String get listedPublicly => 'Listed publicly';

  @override
  String get yourMembersOnly => 'Your members only';

  @override
  String get whenDoesItStart => 'When does it start?';

  @override
  String get chooseStartDateFirst => 'Choose the start date first.';

  @override
  String get lastDayToRegister => 'Last day to register';

  @override
  String get giveTheEventATitle => 'Give the event a title.';

  @override
  String get addADescription => 'Add a description, at least a sentence.';

  @override
  String get sayHowToTakePart => 'Say what someone has to do to take part.';

  @override
  String get pickTheDates => 'Pick the dates.';

  @override
  String startsAtWhen(String when) {
    return 'Starts $when';
  }

  @override
  String registerByWhen(String when) {
    return 'Register by $when';
  }

  @override
  String get selectYourLeaveDates => 'Select your leave dates';

  @override
  String get chooseYourDatesFirst => 'Choose your dates first.';

  @override
  String get sentForApproval => 'Sent for approval.';

  @override
  String get leaveApprovedPaused =>
      'Leave approved. Your membership is paused for those days.';

  @override
  String get chooseDates => 'Choose dates';

  @override
  String leaveDaysLeftCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'You have $count leave days left.',
      one: 'You have 1 leave day left.',
    );
    return '$_temp0';
  }

  @override
  String moreThanRemainingDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'That is more than your $count remaining days, so a manager will need to approve it.',
      one:
          'That is more than your 1 remaining day, so a manager will need to approve it.',
    );
    return '$_temp0';
  }

  @override
  String get withinYourAllowance =>
      'Within your allowance — this will be approved straight away.';

  @override
  String get sendForApproval => 'Send for approval';

  @override
  String get enterCodeSentToTheirPhone => 'Enter the code sent to their phone.';

  @override
  String get numberIsNewNameNeeded =>
      'This number is new, so a name is needed.';

  @override
  String get chooseARole => 'Choose a role.';

  @override
  String get isATrainer => 'Is a trainer?';

  @override
  String get chooseATrainerCategory => 'Choose a trainer category.';

  @override
  String get trainerCategory => 'Trainer category';

  @override
  String get addAMember => 'Add a member';

  @override
  String get codeSentExistingAccount =>
      'Code sent. This number already has a Gymologia account.';

  @override
  String get codeSentNewAccount =>
      'Code sent. This number is new, so we will create an account.';

  @override
  String get membershipLength => 'Membership length';

  @override
  String get leaveDaysAllowed => 'Leave days allowed';

  @override
  String get ownerStaffMode => 'Owner / staff mode';

  @override
  String get memberMode => 'Member mode';

  @override
  String get managingGymsNote =>
      'You are managing gyms. Switch back to use Gymologia as a member.';

  @override
  String get openingAGymNote =>
      'Opening a gym, or working at one? Switch to run your gym\'s CRM — members, staff, attendance and leave.';

  @override
  String get numberIsHowYouSignIn =>
      'Your number is how you sign in, so it cannot be changed here yet.';

  @override
  String get followingYourDevice => 'Following your device';

  @override
  String get yourGym => 'Your gym';

  @override
  String weeksRunning(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Weeks running',
      one: 'Week running',
    );
    return '$_temp0';
  }

  @override
  String noVisitsInLastDays(int days) {
    return 'No visits recorded in the last $days days.';
  }

  @override
  String visitsInLastDays(int count, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count visits in the last $days days.',
      one: '1 visit in the last $days days.',
    );
    return '$_temp0';
  }

  @override
  String get couldNotLoadEvents => 'Could not load events';

  @override
  String get noEventsOnRightNow => 'No events on right now';

  @override
  String get eventsAppearHere =>
      'Events your gym runs show up here, along with anything open to everyone nearby.';

  @override
  String get atYourGym => 'At your gym';

  @override
  String trainerStaffMembersAt(String gym) {
    return 'Your trainer, staff and members at $gym';
  }

  @override
  String get trainerStaffOtherMembers =>
      'Your trainer, the staff, and other members';

  @override
  String get comingNext => 'Coming next';

  @override
  String get progressChartsAgainstGoal => 'Progress charts against your goal';

  @override
  String get leaveLeft => 'Leave left';

  @override
  String approvedMembershipPauses(String name) {
    return '$name approved. Their membership pauses for those days.';
  }

  @override
  String get approveInstead => 'Approve instead';

  @override
  String get declineInstead => 'Decline instead';

  @override
  String get needsYou => 'Needs you';

  @override
  String get autoApproved => 'Auto-approved';

  @override
  String get returnedEarly => 'Returned early';

  @override
  String get whereYouAre => 'Where you are';

  @override
  String get enterTheAddress => 'Enter the address';

  @override
  String get maximumPerMembership => 'Maximum per membership';

  @override
  String removeStaffWithAssigned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'They lose access to this gym, and the $count members assigned to them will have no trainer until you reassign someone.',
      one:
          'They lose access to this gym, and the 1 member assigned to them will have no trainer until you reassign someone.',
    );
    return '$_temp0';
  }

  @override
  String get removeStaffPlain =>
      'They lose access to this gym. Their attendance history is kept.';

  @override
  String get couldNotLoadGyms => 'Could not load gyms';

  @override
  String get noGymsListedYet => 'No gyms listed yet';

  @override
  String get gymsAppearOnPro =>
      'Gyms appear here once they are on the Pro plan and have chosen to be listed.';

  @override
  String nothingMatchedTry(String query) {
    return 'Nothing matched “$query”. Try a different city or district.';
  }

  @override
  String get noRatings => 'No ratings';

  @override
  String get noPerksYet => 'No perks listed yet';

  @override
  String fromRatings(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'from $count ratings',
      one: 'from 1 rating',
    );
    return '$_temp0';
  }

  @override
  String get onlyProGymHere => 'The only Pro gym here';

  @override
  String ofProGyms(int count) {
    return 'of $count Pro gyms';
  }

  @override
  String get couldNotLoadYourGyms => 'Could not load your gyms';

  @override
  String get noGymsYet => 'No gyms yet';

  @override
  String get createYourGymBlurb =>
      'Create your gym to set up members, staff, attendance and leave. If you work at a gym, ask the owner to add you and it will appear here.';

  @override
  String newGroupSelected(int count) {
    return 'New group ($count selected)';
  }

  @override
  String get newMessage => 'New message';

  @override
  String get oneToOne => 'One to one';

  @override
  String get group => 'Group';

  @override
  String get buildMuscle => 'Build muscle';

  @override
  String get loseFat => 'Lose fat';

  @override
  String get getStronger => 'Get stronger';

  @override
  String get officialGroupEmpty => 'Everyone at this gym. Nothing said yet.';

  @override
  String get unofficialGroupEmpty => 'Members only. Nothing said yet.';

  @override
  String get noMessagesYet => 'No messages yet';

  @override
  String get approved => 'Approved';

  @override
  String get declined => 'Declined';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get flexibility => 'Flexibility';

  @override
  String get rehab => 'Rehab';

  @override
  String get youPrefix => 'You: ';

  @override
  String get active => 'Active';

  @override
  String get joined => 'Joined';

  @override
  String get leftCount => 'Left';

  @override
  String get net => 'Net';

  @override
  String get daily => 'Daily';

  @override
  String get monthly => 'Monthly';

  @override
  String get yearly => 'Yearly';

  @override
  String get add => 'Add';

  @override
  String get update => 'Update';

  @override
  String get required => 'Required';

  @override
  String get contact => 'Contact';

  @override
  String get owner => 'Owner';

  @override
  String get support => 'Support';

  @override
  String get machineTranslatedExercise =>
      'These instructions were translated by machine and have not been checked by a coach. If a cue reads oddly, switch to English and compare before you lift.';

  @override
  String get home => 'Home';

  @override
  String get myGym => 'My gym';

  @override
  String get discover => 'Discover';

  @override
  String get sendOtp => 'Send OTP';

  @override
  String get verifyYourNumber => 'Verify your number';

  @override
  String get codeResent => 'A new code is on its way.';

  @override
  String get name => 'Name';

  @override
  String get email => 'Email';

  @override
  String get connection => 'Connection';

  @override
  String get account => 'Account';

  @override
  String get session => 'Session';

  @override
  String get earnByReferring => 'Earn by referring gyms';

  @override
  String get gyms => 'Gyms';

  @override
  String get events => 'Events';

  @override
  String get chat => 'Chat';

  @override
  String get findAGym => 'Find a gym';

  @override
  String get searchGyms => 'Search by name or locality';

  @override
  String get perks => 'Perks';

  @override
  String get rating => 'Rating';

  @override
  String get onLeavePaused => 'On leave — your membership is paused';

  @override
  String get monthlyCheckIn => 'Monthly check-in';

  @override
  String get notNow => 'Not now';

  @override
  String trainerNamed(String name) {
    return 'Trainer: $name';
  }

  @override
  String goalAtGym(String gym) {
    return 'YOUR GOAL AT $gym';
  }

  @override
  String daysRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days left',
      one: '1 day left',
      zero: 'Ends today',
    );
    return '$_temp0';
  }

  @override
  String get yourGoal => 'Your goal';

  @override
  String get trainer => 'Trainer';

  @override
  String get requestLeave => 'Request leave';

  @override
  String get yourProgress => 'Your progress';

  @override
  String get addMeasurementsPrompt =>
      'Add your weight and height so your gym can track progress with you.';

  @override
  String get progressSubtitle =>
      'Weight over time, and how often you have turned up.';

  @override
  String get attendanceAppearsHere =>
      'Attendance appears here once you are a member of a gym and staff start marking you in.';

  @override
  String get twoCheckInsDrawALine =>
      'Two check-ins draw a line. Add your weight each month and this fills in.';

  @override
  String get nothingMatchesFilters => 'Nothing matches those filters.';

  @override
  String get howToJoinGym =>
      'To join, contact the gym directly. They will add you as a member.';

  @override
  String get weight => 'Weight';

  @override
  String get height => 'Height';

  @override
  String get yourMeasurements => 'Your measurements';

  @override
  String get checkInDue => 'This month\'s check-in is due';

  @override
  String get thisMonth => 'This month';

  @override
  String get perWeek => 'Per week';

  @override
  String get lastEightWeeks => 'Last 8 weeks';

  @override
  String get exerciseDirectory => 'Exercise directory';

  @override
  String get exercises => 'Exercises';

  @override
  String get searchExercises => 'Search exercises';

  @override
  String get clear => 'Clear';

  @override
  String get howToDoIt => 'How to do it';

  @override
  String get watchOutFor => 'Watch out for';

  @override
  String get whatYouGet => 'What you get';

  @override
  String get removeYourEntry => 'Remove your entry?';

  @override
  String get stayIn => 'Stay in';

  @override
  String get removeMe => 'Remove me';

  @override
  String get youAreInTapToWithdraw => 'You are in — tap to withdraw';

  @override
  String get participate => 'Participate';

  @override
  String takenOffList(String event) {
    return 'You will be taken off the list for $event.';
  }

  @override
  String contactWithPhone(String phone) {
    return 'Contact $phone';
  }

  @override
  String get reasonOptional => 'Reason (optional)';

  @override
  String get searchByGymCityDistrict => 'Search by gym, city or district';

  @override
  String get useMyLocation => 'Use my location to find nearby gyms';

  @override
  String get findingNearbyGyms => 'Finding gyms near you…';

  @override
  String get locationUnavailable =>
      'Couldn\'t get your location — showing all gyms instead';

  @override
  String get exerciseDirectorySubtitle =>
      'Strength, cardio and yoga, with step-by-step form cues';

  @override
  String get attendance => 'Attendance';

  @override
  String get manage => 'Manage';

  @override
  String get choosePlan => 'Choose a plan';

  @override
  String get seeGrowthOverTime => 'See growth over time';

  @override
  String lastNDays(int days) {
    return 'Last $days days';
  }

  @override
  String get addMember => 'Add member';

  @override
  String get addStaff => 'Add staff';

  @override
  String get searchByNameOrNumber => 'Search by name or number';

  @override
  String get tapCircleToMarkPresent =>
      'Tap the circle to mark present, the row for details';

  @override
  String markedPresent(String name) {
    return '$name marked present';
  }

  @override
  String get approve => 'Approve';

  @override
  String get role => 'Role';

  @override
  String get theirName => 'Their name';

  @override
  String get theirMobileNumber => 'Their mobile number';

  @override
  String get codeFromTheirPhone => 'Code from their phone';

  @override
  String get whatDoTheyWant => 'What do they want from the gym?';

  @override
  String get goalHint => 'Bulk up, lose weight, rehab…';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get removeFromGym => 'Remove from gym';

  @override
  String get remove => 'Remove';

  @override
  String removePerson(String name) {
    return 'Remove $name?';
  }

  @override
  String get onLeave => 'On leave';

  @override
  String get tapDayToCorrect => 'Tap a day to correct it';

  @override
  String correctDate(String date) {
    return 'Correct $date';
  }

  @override
  String get whyIsThisChanging => 'Why is this changing?';

  @override
  String get correctionReasonHint => 'Marked by mistake, machine was down…';

  @override
  String get saveCorrection => 'Save correction';

  @override
  String get recordCorrected => 'Record corrected.';

  @override
  String get trainerCategories => 'Trainer categories';

  @override
  String get newCategory => 'New category';

  @override
  String get noTrainerCategoriesYet => 'No trainer categories yet.';

  @override
  String get oneTrainerManyMembers => 'One trainer can hold many members';

  @override
  String get categoryNameHint => 'Rehab, Strength, Yoga';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get keepIt => 'Keep it';

  @override
  String deleteNamed(String name) {
    return 'Delete $name?';
  }

  @override
  String get decline => 'Decline';

  @override
  String decidedBy(String name) {
    return 'Decided by $name';
  }

  @override
  String get createAGym => 'Create a gym';

  @override
  String get createYourGym => 'Create your gym';

  @override
  String get gymName => 'Gym name';

  @override
  String get gymNameHint => 'Iron Temple Fitness';

  @override
  String get descriptionOptional => 'Description (optional)';

  @override
  String get descriptionHint => 'What makes your gym worth joining?';

  @override
  String get address => 'Address';

  @override
  String get city => 'City';

  @override
  String get district => 'District';

  @override
  String get districtNote =>
      'Your district appears next to your gym name in search, so members can tell you apart.';

  @override
  String get state => 'State';

  @override
  String get pinCode => 'PIN code';

  @override
  String get contactNumber => 'Contact number';

  @override
  String get leavePolicyNote =>
      'Members can pause their membership for a few days a month. Requests beyond that need approval.';

  @override
  String get perksLabel => 'Perks, separated by commas';

  @override
  String get perksHint => 'Steam room, Free parking, Personal training';

  @override
  String get createGym => 'Create gym';

  @override
  String get deleteGym => 'Delete gym';

  @override
  String get gymProfile => 'Gym profile';

  @override
  String get description => 'Description';

  @override
  String get leavePolicy => 'Leave policy';

  @override
  String get leaveDaysPerMonth => 'Leave days per month';

  @override
  String get deleteThisGym => 'Delete this gym';

  @override
  String get leaveLimitNote =>
      'Member requests inside this limit are approved automatically. Anything beyond it needs someone to approve.';

  @override
  String get draftNote =>
      'Your gym starts as a draft. Choose a plan to start using it. Gyms on the Pro plan also appear in Gymologia search.';

  @override
  String get sendThis => 'Send this?';

  @override
  String get send => 'Send';

  @override
  String get announcements => 'Announcements';

  @override
  String get title => 'Title';

  @override
  String get announceTitleHint => 'Closed Sunday for maintenance';

  @override
  String get message => 'Message';

  @override
  String get announceBodyHint =>
      'We reopen Monday at 6am. Sorry for the short notice.';

  @override
  String get whoSeesIt => 'Who sees it';

  @override
  String get everyone => 'Everyone';

  @override
  String get sendAnnouncement => 'Send announcement';

  @override
  String get sent => 'Sent';

  @override
  String get newGym => 'New gym';

  @override
  String get draft => 'Draft';

  @override
  String get nothingToChartYet => 'Nothing to chart yet.';

  @override
  String peakValue(int value) {
    return 'peak $value';
  }

  @override
  String get searchRanking => 'Search ranking';

  @override
  String get notInSearch => 'Not in search';

  @override
  String get members => 'Members';

  @override
  String get staff => 'Staff';

  @override
  String get leave => 'Leave';

  @override
  String get roles => 'Roles';

  @override
  String get analytics => 'Analytics';

  @override
  String get growth => 'Growth';

  @override
  String get ranking => 'Ranking';

  @override
  String get plan => 'Plan';

  @override
  String get announce => 'Announce';

  @override
  String get trainers => 'Trainers';

  @override
  String get present => 'Present';

  @override
  String get absent => 'Absent';

  @override
  String get markAttendance => 'Mark attendance';

  @override
  String get getHelp => 'Get help';

  @override
  String get getHelpSubtitle => 'Send us a message and we will get back to you';

  @override
  String get termsAndPrivacy => 'Terms & Privacy Policy';

  @override
  String get signOut => 'Sign out';

  @override
  String get switchToStaff => 'Switch to owner/staff mode';

  @override
  String get switchToMember => 'Switch to member mode';

  @override
  String get notifications => 'Notifications';

  @override
  String get needsReview => 'Translation pending review';

  @override
  String get block => 'Block';

  @override
  String get unblock => 'Unblock';

  @override
  String get report => 'Report';

  @override
  String blockPerson(String name) {
    return 'Block $name';
  }

  @override
  String reportPerson(String name) {
    return 'Report $name';
  }

  @override
  String get blockConfirmBody =>
      'They will not be able to message you, and you will not see their messages. They are not told that you blocked them. You can undo this in Settings.';

  @override
  String get blocked => 'Blocked';

  @override
  String get blockedAccounts => 'Blocked accounts';

  @override
  String get noBlockedAccounts => 'You have not blocked anyone.';

  @override
  String get safetyAndPrivacy => 'Safety';

  @override
  String unblockQuestion(String name) {
    return 'Unblock $name?';
  }

  @override
  String get unblockExplainer => 'They will be able to message you again.';

  @override
  String get whyReporting => 'What is wrong?';

  @override
  String get reportDetails => 'What happened?';

  @override
  String get reportDetailsHint =>
      'Reviewers do not see the message itself. Your description is what they read, so tell us what was said in your own words.';

  @override
  String get alsoBlockThem => 'Block them as well';

  @override
  String get alsoBlockThemExplainer =>
      'A report is read by a person and takes time. Blocking works straight away.';

  @override
  String get sendReport => 'Send report';

  @override
  String get reportCategorySpam => 'Spam or unwanted selling';

  @override
  String get reportCategoryHarassment => 'Harassment or bullying';

  @override
  String get reportCategorySexual => 'Sexual or explicit content';

  @override
  String get reportCategoryHate => 'Hate speech';

  @override
  String get reportCategoryViolence => 'Violence or a threat';

  @override
  String get reportCategoryScam => 'Scam or fraud';

  @override
  String get reportCategoryImpersonation => 'Pretending to be someone else';

  @override
  String get reportCategoryOther => 'Something else';

  @override
  String get reportSent => 'Thank you. Someone will review this.';

  @override
  String get myReports => 'Reports I have sent';

  @override
  String get reportStatusOpen => 'Waiting for review';

  @override
  String get reportStatusReviewing => 'Being looked at';

  @override
  String get reportStatusActioned => 'Action taken';

  @override
  String get reportStatusDismissed => 'Reviewed, no action';

  @override
  String get noReportsSent => 'You have not reported anyone.';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get deleteAccountIntro =>
      'Your account stays usable for 30 days. After that it is deleted and cannot be brought back.';

  @override
  String get whatIsDeleted => 'What is deleted';

  @override
  String get whatIsDeletedList =>
      'Your name, number, email and age. Your height, weight and progress. Your chat messages. Any ID documents and UPI details.';

  @override
  String get whatIsKept => 'What is kept, with you removed from it';

  @override
  String get whatIsKeptList =>
      'Payment and invoice records, because the law requires us to keep books of account. The record of actions taken in a gym, so disputes can still be settled.';

  @override
  String get deleteGymsFirst =>
      'You still own a gym. Delete it first — deleting your account would cut off every member and staff member in it, and they will be told it has closed.';

  @override
  String unwithdrawnWarning(String amount) {
    return 'You have $amount in referral earnings you have not withdrawn. Withdraw it in the Gymologia Referral app first, or it will be lost.';
  }

  @override
  String get iUnderstandLoseEarnings => 'I understand I will lose this money';

  @override
  String deletionScheduled(String date) {
    return 'Your account will be deleted on $date.';
  }

  @override
  String get keepMyAccount => 'Keep my account';

  @override
  String get deletionCancelled => 'Your account will not be deleted.';

  @override
  String get deleteAccountConfirm => 'Delete my account';

  @override
  String get about => 'About';

  @override
  String get participated => 'You\'re in';

  @override
  String letsGoName(String name) {
    return 'Let\'s go, $name';
  }

  @override
  String get yourTraining => 'Your training';

  @override
  String get tagline => 'Train. Track. Transform.';

  @override
  String get appearance => 'Appearance';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeLight => 'Light';

  @override
  String get takePhoto => 'Take a photo';

  @override
  String get chooseFromGallery => 'Choose from gallery';

  @override
  String get chooseFile => 'Choose a file';

  @override
  String get chooseFileHint => 'A PDF or an image you already have';

  @override
  String get uploading => 'Uploading…';

  @override
  String fileTooLarge(int mb) {
    return 'That file is too large. The limit is $mb MB.';
  }

  @override
  String get gymPhotos => 'Gym photos';

  @override
  String get gymPhotosHint =>
      'The first photo is the cover members see in search. Tap another photo to make it the cover.';

  @override
  String get addPhoto => 'Add photo';

  @override
  String get coverPhoto => 'Cover';

  @override
  String get removePhoto => 'Remove photo';

  @override
  String maxPhotos(int count) {
    return 'You can add up to $count photos.';
  }

  @override
  String get verification => 'Verification';

  @override
  String get kycIntro =>
      'Verify your gym to appear in the Gymologia gym browser. Our team checks your documents, usually within 2 working days.';

  @override
  String get kycEncryptedNote =>
      'Aadhaar, PAN and GST numbers are stored encrypted. Your documents are private and only our verification team can open them.';

  @override
  String get identity => 'Identity';

  @override
  String get business => 'Business';

  @override
  String get aadhaarNumber => 'Aadhaar number';

  @override
  String get enterValidAadhaar => 'Enter your 12-digit Aadhaar number';

  @override
  String get panNumber => 'PAN';

  @override
  String get enterValidPan => 'Enter a valid PAN, like ABCDE1234F';

  @override
  String get hasGstRegistration => 'My gym is GST registered';

  @override
  String get gstin => 'GSTIN';

  @override
  String get enterValidGstin => 'Enter your 15-character GSTIN';

  @override
  String get businessProof => 'Business proof';

  @override
  String get businessProofHint => 'No GST? Upload one of these instead.';

  @override
  String get proofUdyam => 'Udyam';

  @override
  String get proofElectricityBill => 'Electricity bill';

  @override
  String get proofOther => 'Other';

  @override
  String get premisesQuestion => 'Premises';

  @override
  String get premisesOwned => 'Owned';

  @override
  String get premisesRented => 'Rented';

  @override
  String get landlordNoc => 'Landlord\'s NOC';

  @override
  String get landlordNocHint =>
      'A no-objection letter from the owner of the premises';

  @override
  String get uploadDocument => 'Upload';

  @override
  String get documentUploaded => 'Uploaded';

  @override
  String get replaceDocument => 'Replace';

  @override
  String get documentRequired => 'Please upload this document.';

  @override
  String get submitForVerification => 'Submit for verification';

  @override
  String get kycSubmittedSnackbar => 'Sent for verification';

  @override
  String get whatYouSent => 'What you sent';

  @override
  String get kycUnderReview => 'Under review';

  @override
  String get kycUnderReviewBody =>
      'Our team is checking your documents. You\'ll be notified once it\'s done.';

  @override
  String kycVerifiedOn(String date) {
    return 'Verified on $date. Your gym can now appear in search.';
  }

  @override
  String get kycNeedsChanges => 'Needs changes';

  @override
  String get kycOnlyOwner =>
      'Only the gym\'s registered owner can submit verification documents.';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusRejected => 'Rejected';

  @override
  String get statusNotSubmitted => 'Not sent';

  @override
  String get getVerified => 'Get verified';

  @override
  String get gymLocation => 'Gym location';

  @override
  String get gymLocationHint =>
      'Pin your gym on the map so members nearby can find it.';

  @override
  String get setGymLocation => 'Set on map';

  @override
  String get updateGymLocation => 'Change';

  @override
  String get gymLocationSet => 'Location set';

  @override
  String get gymLocationFailed =>
      'Couldn\'t get your location. Turn on location and try again.';

  @override
  String gymCreatedAddPhotos(String name) {
    return '$name is created. Gyms with photos get more members, so add a few now. You can change them later in Gym profile.';
  }

  @override
  String get finish => 'Done';

  @override
  String get skipForNow => 'Skip for now';

  @override
  String get gymLocationNotSet => 'Not set yet';

  @override
  String get moveMapHint =>
      'Move the map so the pin sits on your gym\'s entrance.';

  @override
  String get confirmLocation => 'Confirm location';

  @override
  String get myLocation => 'My location';
}
