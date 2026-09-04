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
  String get loading => 'Loading';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get signIn => 'Sign in';

  @override
  String get phoneNumber => 'Phone number';

  @override
  String get enterPhoneNumber => 'Enter your mobile number';

  @override
  String get sendCode => 'Send code';

  @override
  String get verifyCode => 'Verify';

  @override
  String get enterCode => 'Enter the code we sent you';

  @override
  String get resendCode => 'Send it again';

  @override
  String get createAccount => 'Create your account';

  @override
  String get yourName => 'Your name';

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
  String get profile => 'Profile';

  @override
  String get findAGym => 'Find a gym';

  @override
  String get searchGyms => 'Search by name or locality';

  @override
  String get noGymsFound => 'No gyms found here yet';

  @override
  String get perks => 'Perks';

  @override
  String get contactGym => 'Contact this gym';

  @override
  String get rating => 'Rating';

  @override
  String get yourMembership => 'Your membership';

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
  String get addMeasurements =>
      'Add your weight and height so your gym can track progress with you';

  @override
  String get checkInDue => 'This month\'s check-in is due';

  @override
  String get thisMonth => 'This month';

  @override
  String get perWeek => 'Per week';

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
  String get exerciseDirectorySubtitle =>
      'Strength, cardio and yoga, with step-by-step form cues';

  @override
  String get steps => 'Steps';

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
  String get onLeave => 'Leave';

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
      'Your gym starts as a draft. It will not appear in search until you complete verification and choose a plan.';

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
  String get noNotifications => 'Nothing new';

  @override
  String get needsReview => 'Translation pending review';
}
