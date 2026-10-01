// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Gujarati (`gu`).
class AppLocalizationsGu extends AppLocalizations {
  AppLocalizationsGu([String locale = 'gu']) : super(locale);

  @override
  String get appName => 'Gymologia';

  @override
  String get languageName => 'ગુજરાતી';

  @override
  String get settings => 'સેટિંગ્સ';

  @override
  String get language => 'ભાષા';

  @override
  String get languageSubtitle => 'તમને સૌથી અનુકૂળ લાગે તે ભાષા પસંદ કરો';

  @override
  String get save => 'સાચવો';

  @override
  String get cancel => 'રદ કરો';

  @override
  String get tryAgain => 'ફરી પ્રયાસ કરો';

  @override
  String get somethingWentWrong => 'કંઈક ખોટું થયું';

  @override
  String get phoneNumber => 'મોબાઇલ નંબર';

  @override
  String get enterPhoneNumber => 'તમારો મોબાઇલ નંબર દાખલ કરો';

  @override
  String get sendCode => 'કોડ મોકલો';

  @override
  String get verifyCode => 'ચકાસો';

  @override
  String get resendCode => 'ફરી મોકલો';

  @override
  String get createAccount => 'તમારું ખાતું બનાવો';

  @override
  String get emailOptional => 'ઇમેઇલ (વૈકલ્પિક)';

  @override
  String get age => 'ઉંમર';

  @override
  String get whyAgeNotBirthday =>
      'અમે તમારી ઉંમર પૂછીએ છીએ, જન્મતારીખ નહીં. જન્મતારીખ તમારી બેંક અને સરકારી દસ્તાવેજો સાથે જોડાયેલી હોય છે — જિમ એપ માટે ઉંમર પૂરતી છે.';

  @override
  String get termsAgreement =>
      'ખાતું બનાવવાનો અર્થ છે કે તમે ઉપયોગની શરતો અને ગોપનીયતા નીતિ સ્વીકારો છો.';

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
  String get signInWithMobile => 'તમારા મોબાઇલ નંબરથી સાઇન ઇન કરો';

  @override
  String get mobileNumber => 'મોબાઇલ નંબર';

  @override
  String get couldNotSendCode => 'કોડ મોકલી શકાયો નથી.';

  @override
  String get verificationFailed => 'ચકાસણી નિષ્ફળ ગઈ.';

  @override
  String get couldNotResendCode => 'કોડ ફરી મોકલી શકાયો નથી.';

  @override
  String get couldNotCreateAccount => 'તમારું ખાતું બનાવી શકાયું નથી.';

  @override
  String weSentCodeTo(String phone) {
    return 'અમે $phone પર કોડ મોકલ્યો છે';
  }

  @override
  String resendInSeconds(int seconds) {
    return '$seconds સેકન્ડમાં ફરી મોકલો';
  }

  @override
  String get verified => 'ચકાસાયેલ';

  @override
  String get createAccountAction => 'ખાતું બનાવો';

  @override
  String get supportSent => 'મોકલાયું. તમે આપેલા નંબર પર જવાબ આવશે.';

  @override
  String get supportSubject => 'આ શેના વિશે છે?';

  @override
  String get supportSubjectHint => 'મારા સભ્યપદના દિવસો ખોટા દેખાય છે';

  @override
  String get supportMessage => 'શું થયું તે જણાવો';

  @override
  String get supportReplyTo => 'અમે ક્યાં જવાબ આપીએ?';

  @override
  String get supportUrgent => 'આના કારણે મારું જિમ ચાલી શકતું નથી';

  @override
  String get supportUrgentNote => 'પ્રાથમિકતા વધારે છે.';

  @override
  String copiedToClipboard(String value) {
    return '$value કૉપિ થયું';
  }

  @override
  String orEmailUs(String email) {
    return 'અથવા $email પર ઇમેઇલ કરો';
  }

  @override
  String get whatYouHaveAsked => 'તમે શું પૂછ્યું છે';

  @override
  String get aFewWordsIsEnough => 'થોડા શબ્દો પૂરતા છે';

  @override
  String get aSentenceOrTwoHelps => 'એક-બે વાક્ય લખશો તો ઝડપથી ઉકેલાશે';

  @override
  String get ticketOpen => 'કોઈ હાથ પર લે તેની રાહ જોવાય છે';

  @override
  String get ticketInProgress => 'કોઈ આ જોઈ રહ્યું છે';

  @override
  String get ticketWaitingOnUser => 'તમારા જવાબની રાહ જોવાય છે';

  @override
  String get ticketResolved => 'ઉકેલાયું';

  @override
  String get ticketClosed => 'બંધ';

  @override
  String get referralPitch =>
      'કોડ શેર કરો, અને કોઈ જિમ માલિક સબસ્ક્રિપ્શન લે ત્યારે કમાઓ. રેફરલ ઍપ હજી આવી નથી.';

  @override
  String get appTagline => 'જિમોલોજિયા · સભ્યો અને સ્ટાફ';

  @override
  String get signOutQuestion => 'સાઇન આઉટ કરવું છે?';

  @override
  String get signOutWarning => 'ફરી સાઇન ઇન કરવા તમારો ફોન જોઈશે.';

  @override
  String get profileUpdated => 'પ્રોફાઇલ અપડેટ થઈ.';

  @override
  String get yourProfile => 'તમારી પ્રોફાઇલ';

  @override
  String get emailClearToRemove => 'વૈકલ્પિક. કાઢી નાખવા ખાલી કરો.';

  @override
  String get phoneIsYourLogin =>
      'આનાથી જ તમે સાઇન ઇન કરો છો, તેથી અહીં હમણાં બદલી શકાતું નથી. બદલવું હોય તો સપોર્ટનો સંપર્ક કરો.';

  @override
  String get trialStarted => 'ટ્રાયલ શરૂ થયું. તમારું જિમ હવે શોધમાં દેખાય છે.';

  @override
  String get invalidCode => 'કોડ માન્ય નથી.';

  @override
  String get paymentNotCompletedYet =>
      'ચુકવણી હજી પૂરી થઈ નથી. થોડી વારે ખેંચીને રિફ્રેશ કરો.';

  @override
  String planIsActive(String plan) {
    return '$plan પ્લાન ચાલુ છે.';
  }

  @override
  String get paymentNotCompleted => 'ચુકવણી પૂરી થઈ નથી.';

  @override
  String get couldNotOpenPayment => 'ચુકવણી સ્ક્રીન ખોલી શકાઈ નથી.';

  @override
  String daysFree(int days) {
    return '$days દિવસ મફત';
  }

  @override
  String get trialBlurb =>
      'સંપૂર્ણ પ્રો, સભ્ય શોધમાં તમારી યાદી સહિત. કાર્ડની જરૂર નથી, અને તે જાતે ચૂકવણીવાળા પ્લાનમાં બદલાતું નથી.';

  @override
  String get startFreeTrial => 'મફત ટ્રાયલ શરૂ કરો';

  @override
  String get referralCode => 'રેફરલ કોડ';

  @override
  String get optional => 'વૈકલ્પિક';

  @override
  String get apply => 'લાગુ કરો';

  @override
  String get gstNote =>
      'ભાવમાં જીએસટી સામેલ છે. પ્રો પ્લાન પર જ જિમ સભ્ય શોધમાં દેખાય છે.';

  @override
  String planNamed(String plan) {
    return '$plan પ્લાન';
  }

  @override
  String get trialBadge => 'ટ્રાયલ';

  @override
  String get expired => 'મુદત પૂરી';

  @override
  String daysRemainingPlan(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count દિવસ બાકી',
    );
    return '$_temp0';
  }

  @override
  String get listedInSearch => 'સભ્ય શોધમાં યાદીબદ્ધ';

  @override
  String get notListedUpgrade => 'શોધમાં નથી — દેખાવા માટે પ્રો પર અપગ્રેડ કરો';

  @override
  String get trialEndsNote =>
      'ટ્રાયલ પૂરું થયા પછી તમે પ્લાન ન પસંદ કરો ત્યાં સુધી જિમ શોધમાંથી નીકળી જાય છે. જાતે કંઈ વસૂલાતું નથી.';

  @override
  String get getsYouListed => 'શોધમાં દેખાડે છે';

  @override
  String get perMonth => '/મહિનો';

  @override
  String choosePlanNamed(String plan) {
    return '$plan પસંદ કરો';
  }

  @override
  String get deleteRoleWarning =>
      'ભૂમિકા અને તેની પરવાનગીઓ જશે. તેમાં કોઈ નથી, તેથી કોઈની પહોંચ જશે નહીં.';

  @override
  String deletedNamed(String name) {
    return '$name કાઢી નાખ્યું';
  }

  @override
  String get needTwoCustomRoles =>
      'ક્રમ બદલતાં પહેલાં તમે સંપાદિત કરી શકો તેવી બે કસ્ટમ ભૂમિકાઓ જોઈએ.';

  @override
  String get hierarchySaved => 'ક્રમ સાચવ્યો';

  @override
  String get reorder => 'ક્રમ બદલો';

  @override
  String get newRole => 'નવી ભૂમિકા';

  @override
  String get rolesIntro =>
      'સૌથી વરિષ્ઠ પહેલાં. તમે ફક્ત તમારી નીચેની ભૂમિકાઓ સંપાદિત કરી શકો છો, અને ફક્ત તમારી પાસે હોય તે પરવાનગીઓ આપી શકો છો.';

  @override
  String get defaultBadge => 'ડિફોલ્ટ';

  @override
  String get everyPermission => 'દરેક પરવાનગી, પછીથી ઉમેરાય તે સહિત';

  @override
  String permissionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count પરવાનગીઓ',
    );
    return '$_temp0';
  }

  @override
  String get nobodyInThisRole => 'આ ભૂમિકામાં કોઈ નથી';

  @override
  String peopleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count લોકો',
    );
    return '$_temp0';
  }

  @override
  String get deleteDefaultRolesStay => 'કાઢો (ડિફોલ્ટ ભૂમિકાઓ રહે છે)';

  @override
  String get deleteMovePeopleFirst => 'કાઢો (પહેલાં લોકોને ખસેડો)';

  @override
  String get giveRoleAName => 'ભૂમિકાને નામ આપો';

  @override
  String get editRole => 'ભૂમિકા સંપાદિત કરો';

  @override
  String get createRole => 'ભૂમિકા બનાવો';

  @override
  String get roleName => 'ભૂમિકાનું નામ';

  @override
  String get roleNameHint => 'રિસેપ્શન, ફિઝિયો, નાઇટ શિફ્ટ';

  @override
  String get superRoleNote =>
      'આ ભૂમિકા પાસે દરેક પરવાનગી છે, ભવિષ્યમાં ઉમેરાય તે સહિત. તેને સાંકડી કરી શકાતી નથી — એટલે જ તે હંમેશા વસ્તુઓ સુધારી શકે છે.';

  @override
  String get whatThisRoleCanDo => 'આ ભૂમિકા શું કરી શકે છે';

  @override
  String get greyedOutNote =>
      'જે ઝાંખું દેખાય છે તે તમારી પાસે નથી, તેથી તમે તે આપી શકતા નથી.';

  @override
  String get ownerOnlyPermission => 'આ ફક્ત જિમ માલિકની છે';

  @override
  String get youDoNotHoldThis => 'આ તમારી પાસે નથી';

  @override
  String get orderTheHierarchy => 'ક્રમ ગોઠવો';

  @override
  String get hierarchyNote =>
      'સૌથી વરિષ્ઠ ઉપર. ડિફોલ્ટ ભૂમિકાઓ પોતાની જગ્યાએ રહે છે અને અહીં દેખાતી નથી.';

  @override
  String get saveOrder => 'ક્રમ સાચવો';

  @override
  String membershipExtendedBy(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'સભ્યપદ $count મહિના વધાર્યું.',
    );
    return '$_temp0';
  }

  @override
  String get goalUpdated => 'ધ્યેય અપડેટ થયું.';

  @override
  String get thisMember => 'આ સભ્ય';

  @override
  String get removeMemberQuestion => 'સભ્ય કાઢવો છે?';

  @override
  String removeMemberWarning(String name) {
    return '$name આ જિમમાં પ્રવેશ ગુમાવશે. તેમનો હાજરી રેકોર્ડ અને માપ રખાય છે.';
  }

  @override
  String get member => 'સભ્ય';

  @override
  String get removeMember => 'સભ્ય કાઢો';

  @override
  String get daysLeft => 'બાકી દિવસ';

  @override
  String get leaveUsed => 'વપરાયેલી રજા';

  @override
  String get extend => 'વધારો';

  @override
  String get editGoal => 'ધ્યેય સંપાદિત કરો';

  @override
  String get goal => 'ધ્યેય';

  @override
  String get notSet => 'સેટ નથી';

  @override
  String get noneAssigned => 'કોઈ સોંપાયું નથી';

  @override
  String get attendanceHistory => 'હાજરી ઇતિહાસ';

  @override
  String get viewAndCorrectRecords => 'રેકોર્ડ જુઓ અને સુધારો';

  @override
  String sessionsSoFar(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'અત્યાર સુધી $count સત્રો',
    );
    return '$_temp0';
  }

  @override
  String get progressIsPrivate => 'પ્રગતિ ખાનગી છે';

  @override
  String get monitoringOffNote =>
      'આ સભ્યે પ્રગતિ દેખરેખ બંધ કરી છે. એ તેમનો નિર્ણય છે અને કોઈ ભૂમિકા તેને બદલી શકતી નથી.';

  @override
  String get progress => 'પ્રગતિ';

  @override
  String get noMeasurementsYet =>
      'હજી કોઈ માપ નોંધાયા નથી. સભ્યને તેમની ઍપમાં મહિનામાં એકવાર પૂછવામાં આવે છે.';

  @override
  String holdingAtKg(String kg) {
    return '$kg કિલો પર સ્થિર';
  }

  @override
  String weightChangeSince(String delta) {
    return 'પ્રથમ માપ પછી $delta કિલો';
  }

  @override
  String get extendMembership => 'સભ્યપદ વધારો';

  @override
  String get extendFromTodayNote =>
      'મુદત પૂરી થયેલું સભ્યપદ આજથી વધે છે, જે તારીખે પૂરું થયું તેનાથી નહીં.';

  @override
  String monthsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count મહિના',
    );
    return '$_temp0';
  }

  @override
  String extendByMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count મહિના વધારો',
    );
    return '$_temp0';
  }

  @override
  String get whatAreTheyWorkingTowards => 'તેઓ કયા ધ્યેય પર કામ કરે છે?';

  @override
  String get goalDialogHint => '80 કિલો સુધી બલ્ક, વજન ઘટાડો, રિહેબ…';

  @override
  String signedUpCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count લોકોએ નામ નોંધાવ્યું',
    );
    return '$_temp0';
  }

  @override
  String get nobodyYet => 'હજી કોઈ નથી.';

  @override
  String get hostAnEvent => 'ઇવેન્ટ યોજો';

  @override
  String get noEventsYet =>
      'હજી કોઈ ઇવેન્ટ નથી. એક યોજો, તે તમારા સભ્યોને તરત દેખાશે.';

  @override
  String get editEvent => 'ઇવેન્ટ સંપાદિત કરો';

  @override
  String get cancelEvent => 'ઇવેન્ટ રદ કરો';

  @override
  String get cancelEventConfirmTitle => 'શું આ ઇવેન્ટ રદ કરવી છે?';

  @override
  String get cancelEventConfirmBody =>
      'આ ઇવેન્ટને કાયમ માટે ડિલીટ કરશે, નોંધાયેલા લોકોની યાદી સહિત. આ પાછું લઈ શકાશે નહીં.';

  @override
  String get keepEvent => 'ઇવેન્ટ રાખો';

  @override
  String get eventUpdated => 'ઇવેન્ટ અપડેટ થઈ';

  @override
  String get eventCancelledSnackbar => 'ઇવેન્ટ ડિલીટ થઈ';

  @override
  String get eventTitleHint => 'સમર ડેડલિફ્ટ મીટ';

  @override
  String get howToTakePart => 'કેવી રીતે ભાગ લેવો';

  @override
  String get howToTakePartHint => 'સવારે 8 વાગ્યે વજન. પોતાનો બેલ્ટ લાવો.';

  @override
  String get prizeOptional => 'ઇનામ (વૈકલ્પિક)';

  @override
  String get prizeHint => '₹10,000';

  @override
  String get membersCanSignUp => 'સભ્યો ઍપમાં નામ નોંધાવી શકે છે';

  @override
  String get membersCanSignUpNote =>
      'બંધ કરશો તો બટનને બદલે તમારી શરતો દેખાશે.';

  @override
  String get listPublicly => 'જાહેરમાં દેખાડો';

  @override
  String get listPubliclyNote => 'આખા દેશની ઇવેન્ટ ફીડમાં દેખાય છે.';

  @override
  String get listPubliclyProOnly =>
      'ફક્ત પ્રો પ્લાનમાં. તમારા સભ્યો તો જોશે જ.';

  @override
  String get openToOutsiders => 'તમારા જિમ બહારના લોકો માટે પણ ખુલ્લું';

  @override
  String get publishEvent => 'ઇવેન્ટ પ્રકાશિત કરો';

  @override
  String get registrationOpen => 'નોંધણી ખુલ્લી';

  @override
  String get registrationClosed => 'નોંધણી બંધ';

  @override
  String get close => 'બંધ કરો';

  @override
  String get markAllRead => 'બધું વાંચેલું ગણો';

  @override
  String get nothingYet => 'હજી કંઈ નથી';

  @override
  String get announcementsAppearHere =>
      'તમારા જિમ અને જિમોલોજિયાની જાહેરાતો અહીં દેખાશે.';

  @override
  String get searchPeople => 'લોકો શોધો';

  @override
  String get nobodyElseHereYet => 'અહીં હજી બીજું કોઈ નથી.';

  @override
  String get nameTheGroup => 'જૂથને નામ આપો';

  @override
  String get groupNameHint => 'શનિવાર સવારનું જૂથ';

  @override
  String get create => 'બનાવો';

  @override
  String get pickWhoIsInTheGroup => 'જૂથમાં કોણ છે તે પસંદ કરો';

  @override
  String createGroupWith(int count) {
    return '$count લોકો સાથે જૂથ બનાવો';
  }

  @override
  String get termsOfUse => 'ઉપયોગની શરતો';

  @override
  String get privacy => 'ગોપનીયતા';

  @override
  String versionUpdated(String version, String date) {
    return 'આવૃત્તિ $version · અપડેટ $date';
  }

  @override
  String sessionsAttendedAllTime(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'સત્રો, કુલ',
    );
    return '$_temp0';
  }

  @override
  String get nothingInLast60Days => 'છેલ્લા 60 દિવસમાં કંઈ નોંધાયું નથી.';

  @override
  String correctedReason(String reason) {
    return 'સુધાર્યું: $reason';
  }

  @override
  String get noReasonGiven => 'કારણ અપાયું નથી';

  @override
  String get keptWithRecordAuditNote =>
      'આ રેકોર્ડ સાથે રખાય છે અને ઓડિટ લોગમાં દેખાય છે.';

  @override
  String get staffBadge => 'સ્ટાફ';

  @override
  String get draftCrmNote =>
      'તમારું જિમ ડ્રાફ્ટ છે. CRM ચાલે છે, પણ પ્લાન સક્રિય ન થાય ત્યાં સુધી સભ્યો તમને શોધમાં નહીં મળે.';

  @override
  String roleHiddenNote(String role) {
    return 'અહીં તમે $role છો. તમારી ભૂમિકા જે ન કરી શકે તે બતાવીને ના પાડવાને બદલે છુપાવાય છે.';
  }

  @override
  String engagedOfActive(int engaged, int total) {
    return '$total માંથી $engaged સભ્યોએ ઓછામાં ઓછું એકવાર કસરત કરી.';
  }

  @override
  String announceGoesTo(String audience) {
    return 'આ હમણાં જ $audience જશે, અને પાછું લઈ શકાશે નહીં.';
  }

  @override
  String get audienceEveryMember => 'દરેક સભ્ય';

  @override
  String get audienceEveryStaff => 'દરેક સ્ટાફ સભ્ય';

  @override
  String get audienceEveryone => 'આ જિમના બધા';

  @override
  String sentToPeople(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count લોકોને મોકલ્યું.',
    );
    return '$_temp0';
  }

  @override
  String recipientCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count પ્રાપ્તકર્તા',
    );
    return '$_temp0';
  }

  @override
  String get weTextACodeFirst =>
      'અમે પહેલાં તેમના નંબર પર કોડ મોકલીએ છીએ, જેથી ખાતરી થાય કે નંબર ખરેખર તેમનો છે.';

  @override
  String get memberCanUpdateMetrics =>
      'તેઓ સભ્ય ઍપમાં પોતાનું વજન અને ઊંચાઈ જોઈ અને બદલી શકે છે. તેઓ જાતે બંધ ન કરે ત્યાં સુધી તેમની પ્રગતિ સ્ટાફને દેખાય છે.';

  @override
  String get noRolesYouCanAssign =>
      'તમે આપી શકો તેવી ભૂમિકાઓ નથી. ફક્ત તમારી નીચેની ભૂમિકાઓ જ આપી શકાય.';

  @override
  String get noRolesYouCanAssignToThem => 'તમે તેમને આપી શકો તેવી ભૂમિકાઓ નથી.';

  @override
  String heightCm(String cm) {
    return 'ઊંચાઈ $cm સેમી';
  }

  @override
  String weightOverCheckIns(String delta, int count) {
    return '$count તપાસમાં $delta કિલો';
  }

  @override
  String get useDeviceLanguage => 'ડિવાઇસની ભાષા વાપરો';

  @override
  String get untranslatedFallbackNote =>
      'જે હજી અનુવાદિત નથી તે ખાલી રાખવાને બદલે અંગ્રેજીમાં દેખાય છે, જેથી અંશતઃ અનુવાદિત ભાષા પણ વાપરી શકાય.';

  @override
  String deleteGymWarning(int members, int staff) {
    return 'બધા $members સભ્યો અને $staff સ્ટાફ પ્રવેશ ગુમાવશે. આ ઍપમાંથી પાછું કરી શકાતું નથી.';
  }

  @override
  String shownAsInSearch(String name, String district) {
    return 'શોધમાં “$name - $district” તરીકે દેખાશે.';
  }

  @override
  String get nothingWaitingLeave =>
      'કંઈ બાકી નથી. તમારી મર્યાદામાંની વિનંતીઓ આપોઆપ મંજૂર થાય છે અને અહીં દેખાતી નથી.';

  @override
  String get quietPeriodsNote =>
      'શાંત સમયગાળા છોડી દેવાને બદલે ખાલી બાર તરીકે દેખાડાય છે, તેથી બારમાં ખાલી જગ્યા ખરી ખાલી જગ્યા છે.';

  @override
  String get rankingExplainer =>
      'શોધ પરિણામોને જે રીતે ક્રમમાં ગોઠવે છે તે જ રીતે સ્થાન નક્કી થાય છે: પહેલાં રેટિંગ, પછી કેટલા રેટિંગ તેને ટેકો આપે છે. અહીં જે દેખાય છે તે જ સભ્યને પણ દેખાશે.';

  @override
  String get deleteTrainerCategoryWarning =>
      'હવે આ શ્રેણીમાં ટ્રેનર મૂકી શકાશે નહીં. જે પહેલેથી છે તેમની સોંપણી રહેશે.';

  @override
  String get youLabel => 'તમે';

  @override
  String get openEvents => 'ખુલ્લા ઇવેન્ટ';

  @override
  String get nothingHereYetSaySomething => 'અહીં હજી કંઈ નથી. કંઈક કહો.';

  @override
  String get leavePausesMembership =>
      'તમે ન હો ત્યારે સભ્યપદ થંભે છે, તેથી તમે ચૂકવેલા દિવસો બચે છે.';

  @override
  String get notListedUntilPlan =>
      'પ્લાન સક્રિય ન થાય ત્યાં સુધી જાહેરમાં દેખાશે નહીં.';

  @override
  String gymsListedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count જિમ યાદીમાં',
    );
    return '$_temp0';
  }

  @override
  String get checkInGoalNote =>
      'તમારા ધ્યેય તરફની પ્રગતિ જોવા તમારું જિમ આનો ઉપયોગ કરે છે.';

  @override
  String get enterYourGymName => 'તમારા જિમનું નામ લખો';

  @override
  String get sessionExpiredSignIn => 'તમારું સત્ર પૂરું થયું. ફરી સાઇન ઇન કરો.';

  @override
  String get somethingWentWrongTryAgain => 'કંઈક ખોટું થયું. ફરી પ્રયાસ કરો.';

  @override
  String get serverTookTooLong =>
      'સર્વરે જવાબ આપવામાં બહુ સમય લીધો. તમારું કનેક્શન તપાસીને ફરી પ્રયાસ કરો.';

  @override
  String couldNotReachServer(String host) {
    return '$host પરના સર્વર સુધી પહોંચી શકાયું નથી. તમારું ઇન્ટરનેટ કનેક્શન તપાસો.';
  }

  @override
  String get certificateNotVerified => 'સર્વરનું પ્રમાણપત્ર ચકાસી શકાયું નથી.';

  @override
  String get networkErrorTryAgain => 'નેટવર્ક ભૂલ. ફરી પ્રયાસ કરો.';

  @override
  String get enterValidMobile => '10 અંકનો સાચો ભારતીય મોબાઇલ નંબર લખો';

  @override
  String get enterValidTenDigitNumber => '10 અંકનો સાચો નંબર લખો';

  @override
  String get enterYourName => 'તમારું નામ લખો';

  @override
  String get nameTooLong => 'એ નામ બહુ લાંબું છે';

  @override
  String get enterValidEmail => 'સાચું ઇમેઇલ સરનામું લખો';

  @override
  String get enterYourAge => 'તમારી ઉંમર લખો';

  @override
  String get mustBeAtLeast13 => 'તમારી ઉંમર ઓછામાં ઓછી 13 હોવી જોઈએ';

  @override
  String get enterValidAge => 'સાચી ઉંમર લખો';

  @override
  String get enterWeightOrHeight => 'વજન અથવા ઊંચાઈ લખો.';

  @override
  String get noRatingsYet => 'હજી કોઈ રેટિંગ નથી';

  @override
  String get giveItATitle => 'એક શીર્ષક આપો.';

  @override
  String get sayWhatYouWantThemToKnow => 'તેમને શું જણાવવું છે તે લખો.';

  @override
  String get sayWhyThisIsChanging => 'આ કેમ બદલાય છે તે લખો.';

  @override
  String get noMembersYetAddFirst => 'હજી કોઈ સભ્ય નથી. પહેલા સભ્યને ઉમેરો.';

  @override
  String get nobodyMatchedSearch => 'એ શોધમાં કોઈ મળ્યું નથી.';

  @override
  String get turningUp => 'હાજરી';

  @override
  String get justNow => 'હમણાં જ';

  @override
  String minutesAgo(int count) {
    return '$count મિનિટ પહેલાં';
  }

  @override
  String hoursAgo(int count) {
    return '$count કલાક પહેલાં';
  }

  @override
  String daysAgo(int count) {
    return '$count દિવસ પહેલાં';
  }

  @override
  String monthsAgo(int count) {
    return '$count મહિના પહેલાં';
  }

  @override
  String get nowShort => 'હમણાં';

  @override
  String minutesShort(int count) {
    return '$count મિ';
  }

  @override
  String hoursShort(int count) {
    return '$count ક';
  }

  @override
  String daysShort(int count) {
    return '$count દિ';
  }

  @override
  String weeksShort(int count) {
    return '$count અ';
  }

  @override
  String addedNamed(String name) {
    return '$name ઉમેરાયું';
  }

  @override
  String get saved => 'સાચવ્યું';

  @override
  String get trainerCategoriesIntro =>
      'ટ્રેનર ઉમેરતી વખતે તેમને આમાંની એકમાં મૂકાય છે. જે શ્રેણીમાં ટ્રેનર હોય તે તેમને ખસેડ્યા વિના કાઢી શકાતી નથી.';

  @override
  String get trainerCategoriesReadOnly =>
      'તમે આ જિમની શ્રેણીઓ જોઈ શકો છો. બદલવા માટે ટ્રેનર-વ્યવસ્થાપનની પરવાનગી જોઈએ.';

  @override
  String get oneTrainerManyMembersShort => 'એક ટ્રેનર, ઘણા સભ્યો';

  @override
  String get oneMemberPerTrainer => 'દરેક ટ્રેનર માટે એક સભ્ય';

  @override
  String get noTrainers => 'કોઈ ટ્રેનર નથી';

  @override
  String trainerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ટ્રેનર',
    );
    return '$_temp0';
  }

  @override
  String get deleteMoveTrainersFirst => 'કાઢો (પહેલાં ટ્રેનર ખસેડો)';

  @override
  String get giveCategoryAName => 'શ્રેણીને નામ આપો';

  @override
  String get editCategory => 'શ્રેણી સંપાદિત કરો';

  @override
  String get newTrainerCategory => 'નવી ટ્રેનર શ્રેણી';

  @override
  String get generalTrainingNote => 'સામાન્ય તાલીમ માટે આ જ સામાન્ય સેટિંગ છે.';

  @override
  String get personalTrainingNote =>
      'વ્યક્તિગત તાલીમ: અહીંનો ટ્રેનર એક સમયે એક જ સભ્ય લે છે.';

  @override
  String get addCategory => 'શ્રેણી ઉમેરો';

  @override
  String get listedPublicly => 'જાહેરમાં યાદીબદ્ધ';

  @override
  String get yourMembersOnly => 'ફક્ત તમારા સભ્યો';

  @override
  String get whenDoesItStart => 'આ ક્યારે શરૂ થાય છે?';

  @override
  String get chooseStartDateFirst => 'પહેલાં શરૂઆતની તારીખ પસંદ કરો.';

  @override
  String get lastDayToRegister => 'નોંધણીનો છેલ્લો દિવસ';

  @override
  String get giveTheEventATitle => 'ઇવેન્ટને શીર્ષક આપો.';

  @override
  String get addADescription => 'એક વર્ણન ઉમેરો, ઓછામાં ઓછું એક વાક્ય.';

  @override
  String get sayHowToTakePart => 'ભાગ લેવા શું કરવું પડશે તે લખો.';

  @override
  String get pickTheDates => 'તારીખો પસંદ કરો.';

  @override
  String startsAtWhen(String when) {
    return '$when શરૂ';
  }

  @override
  String registerByWhen(String when) {
    return '$when સુધીમાં નોંધણી કરો';
  }

  @override
  String get selectYourLeaveDates => 'તમારી રજાની તારીખો પસંદ કરો';

  @override
  String get chooseYourDatesFirst => 'પહેલાં તમારી તારીખો પસંદ કરો.';

  @override
  String get sentForApproval => 'મંજૂરી માટે મોકલ્યું.';

  @override
  String get leaveApprovedPaused =>
      'રજા મંજૂર. એ દિવસો માટે તમારું સભ્યપદ થંભશે.';

  @override
  String get chooseDates => 'તારીખો પસંદ કરો';

  @override
  String leaveDaysLeftCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'તમારી પાસે $count રજાના દિવસ બાકી છે.',
    );
    return '$_temp0';
  }

  @override
  String moreThanRemainingDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'આ તમારા બાકી $count દિવસ કરતાં વધુ છે, તેથી મેનેજરે મંજૂરી આપવી પડશે.',
    );
    return '$_temp0';
  }

  @override
  String get withinYourAllowance => 'તમારી મર્યાદામાં — આ તરત મંજૂર થશે.';

  @override
  String get sendForApproval => 'મંજૂરી માટે મોકલો';

  @override
  String get enterCodeSentToTheirPhone => 'તેમના ફોન પર મોકલેલો કોડ લખો.';

  @override
  String get numberIsNewNameNeeded => 'આ નંબર નવો છે, તેથી નામ જોઈએ.';

  @override
  String get chooseARole => 'એક ભૂમિકા પસંદ કરો.';

  @override
  String get isATrainer => 'Is a trainer?';

  @override
  String get chooseATrainerCategory => 'Choose a trainer category.';

  @override
  String get trainerCategory => 'Trainer category';

  @override
  String get addAMember => 'એક સભ્ય ઉમેરો';

  @override
  String get codeSentExistingAccount =>
      'કોડ મોકલ્યો. આ નંબર પર પહેલેથી જિમોલોજિયા ખાતું છે.';

  @override
  String get codeSentNewAccount =>
      'કોડ મોકલ્યો. આ નંબર નવો છે, તેથી અમે ખાતું બનાવીશું.';

  @override
  String get membershipLength => 'સભ્યપદની મુદત';

  @override
  String get leaveDaysAllowed => 'મંજૂર રજાના દિવસો';

  @override
  String get ownerStaffMode => 'માલિક / સ્ટાફ મોડ';

  @override
  String get memberMode => 'સભ્ય મોડ';

  @override
  String get managingGymsNote =>
      'તમે જિમ સંભાળી રહ્યા છો. સભ્ય તરીકે જિમોલોજિયા વાપરવા પાછા સ્વિચ કરો.';

  @override
  String get openingAGymNote =>
      'જિમ ખોલી રહ્યા છો, કે કોઈમાં કામ કરો છો? તમારા જિમનું CRM ચલાવવા સ્વિચ કરો — સભ્યો, સ્ટાફ, હાજરી અને રજા.';

  @override
  String get numberIsHowYouSignIn =>
      'તમે તમારા નંબરથી જ સાઇન ઇન કરો છો, તેથી અહીં હમણાં બદલી શકાતું નથી.';

  @override
  String get followingYourDevice => 'તમારા ડિવાઇસ પ્રમાણે';

  @override
  String get yourGym => 'તમારું જિમ';

  @override
  String weeksRunning(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'સળંગ અઠવાડિયા',
      one: 'સળંગ અઠવાડિયું',
    );
    return '$_temp0';
  }

  @override
  String noVisitsInLastDays(int days) {
    return 'છેલ્લા $days દિવસમાં કોઈ મુલાકાત નોંધાઈ નથી.';
  }

  @override
  String visitsInLastDays(int count, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'છેલ્લા $days દિવસમાં $count મુલાકાત.',
    );
    return '$_temp0';
  }

  @override
  String get couldNotLoadEvents => 'ઇવેન્ટ લોડ થઈ શક્યા નથી';

  @override
  String get noEventsOnRightNow => 'અત્યારે કોઈ ઇવેન્ટ નથી';

  @override
  String get eventsAppearHere =>
      'તમારા જિમના ઇવેન્ટ અહીં દેખાય છે, સાથે નજીકના બધા માટે ખુલ્લા ઇવેન્ટ પણ.';

  @override
  String get atYourGym => 'તમારા જિમમાં';

  @override
  String trainerStaffMembersAt(String gym) {
    return '$gym માં તમારા ટ્રેનર, સ્ટાફ અને સભ્યો';
  }

  @override
  String get trainerStaffOtherMembers => 'તમારા ટ્રેનર, સ્ટાફ અને અન્ય સભ્યો';

  @override
  String get comingNext => 'હવે પછી આવશે';

  @override
  String get progressChartsAgainstGoal => 'તમારા ધ્યેય સામે પ્રગતિ ચાર્ટ';

  @override
  String get leaveLeft => 'બાકી રજા';

  @override
  String approvedMembershipPauses(String name) {
    return '$name મંજૂર. એ દિવસો માટે તેમનું સભ્યપદ થંભશે.';
  }

  @override
  String get approveInstead => 'તેના બદલે મંજૂર કરો';

  @override
  String get declineInstead => 'તેના બદલે નકારો';

  @override
  String get needsYou => 'તમારી જરૂર છે';

  @override
  String get autoApproved => 'આપોઆપ મંજૂર';

  @override
  String get returnedEarly => 'વહેલા પાછા આવ્યા';

  @override
  String get whereYouAre => 'તમે ક્યાં છો';

  @override
  String get enterTheAddress => 'સરનામું લખો';

  @override
  String get maximumPerMembership => 'પ્રતિ સભ્યપદ મહત્તમ';

  @override
  String removeStaffWithAssigned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'તેઓ આ જિમમાં પ્રવેશ ગુમાવશે, અને તેમને સોંપાયેલા $count સભ્યોને તમે બીજા કોઈને સોંપો ત્યાં સુધી ટ્રેનર નહીં હોય.',
    );
    return '$_temp0';
  }

  @override
  String get removeStaffPlain =>
      'તેઓ આ જિમમાં પ્રવેશ ગુમાવશે. તેમનો હાજરી રેકોર્ડ રખાય છે.';

  @override
  String get couldNotLoadGyms => 'જિમ લોડ થઈ શક્યાં નથી';

  @override
  String get noGymsListedYet => 'હજી કોઈ જિમ યાદીમાં નથી';

  @override
  String get gymsAppearOnPro =>
      'જિમ પ્રો પ્લાન પર હોય અને યાદીબદ્ધ થવાનું પસંદ કરે ત્યારે અહીં દેખાય છે.';

  @override
  String nothingMatchedTry(String query) {
    return '“$query” સાથે કંઈ મળ્યું નથી. બીજું શહેર કે જિલ્લો અજમાવો.';
  }

  @override
  String get noRatings => 'કોઈ રેટિંગ નથી';

  @override
  String get noPerksYet => 'હજુ સુધી કોઈ સુવિધા સૂચિબદ્ધ નથી';

  @override
  String fromRatings(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count રેટિંગમાંથી',
    );
    return '$_temp0';
  }

  @override
  String get onlyProGymHere => 'અહીંનું એકમાત્ર પ્રો જિમ';

  @override
  String ofProGyms(int count) {
    return '$count પ્રો જિમમાંથી';
  }

  @override
  String get couldNotLoadYourGyms => 'તમારાં જિમ લોડ થઈ શક્યાં નથી';

  @override
  String get noGymsYet => 'હજી કોઈ જિમ નથી';

  @override
  String get createYourGymBlurb =>
      'સભ્યો, સ્ટાફ, હાજરી અને રજા ગોઠવવા તમારું જિમ બનાવો. તમે કોઈ જિમમાં કામ કરતા હો તો માલિકને ઉમેરવા કહો, તે અહીં દેખાશે.';

  @override
  String newGroupSelected(int count) {
    return 'નવું જૂથ ($count પસંદ)';
  }

  @override
  String get newMessage => 'નવો સંદેશ';

  @override
  String get oneToOne => 'એક સામે એક';

  @override
  String get group => 'જૂથ';

  @override
  String get buildMuscle => 'સ્નાયુ બનાવો';

  @override
  String get loseFat => 'ચરબી ઘટાડો';

  @override
  String get getStronger => 'તાકાત વધારો';

  @override
  String get officialGroupEmpty => 'આ જિમના બધા. હજી કંઈ કહેવાયું નથી.';

  @override
  String get unofficialGroupEmpty => 'ફક્ત સભ્યો. હજી કંઈ કહેવાયું નથી.';

  @override
  String get noMessagesYet => 'હજી કોઈ સંદેશ નથી';

  @override
  String get approved => 'મંજૂર';

  @override
  String get declined => 'નકારાયું';

  @override
  String get cancelled => 'રદ';

  @override
  String get flexibility => 'લવચીકતા';

  @override
  String get rehab => 'રિહેબ';

  @override
  String get youPrefix => 'તમે: ';

  @override
  String get active => 'સક્રિય';

  @override
  String get joined => 'જોડાયા';

  @override
  String get leftCount => 'છોડ્યું';

  @override
  String get net => 'ચોખ્ખું';

  @override
  String get daily => 'દૈનિક';

  @override
  String get monthly => 'માસિક';

  @override
  String get yearly => 'વાર્ષિક';

  @override
  String get add => 'ઉમેરો';

  @override
  String get update => 'અપડેટ કરો';

  @override
  String get required => 'જરૂરી';

  @override
  String get contact => 'સંપર્ક';

  @override
  String get owner => 'માલિક';

  @override
  String get support => 'સપોર્ટ';

  @override
  String get machineTranslatedExercise =>
      'આ સૂચનાઓ મશીનથી અનુવાદિત છે અને કોઈ કોચે તપાસી નથી. કંઈ વિચિત્ર લાગે તો વજન ઉપાડતાં પહેલાં અંગ્રેજીમાં બદલીને સરખાવો.';

  @override
  String get home => 'હોમ';

  @override
  String get myGym => 'મારું જિમ';

  @override
  String get discover => 'શોધો';

  @override
  String get sendOtp => 'OTP મોકલો';

  @override
  String get verifyYourNumber => 'તમારો નંબર ચકાસો';

  @override
  String get codeResent => 'નવો કોડ મોકલાઈ રહ્યો છે.';

  @override
  String get name => 'નામ';

  @override
  String get email => 'ઇમેઇલ';

  @override
  String get connection => 'કનેક્શન';

  @override
  String get account => 'ખાતું';

  @override
  String get session => 'સત્ર';

  @override
  String get earnByReferring => 'રેફર કરીને કમાઓ';

  @override
  String get gyms => 'જિમ';

  @override
  String get events => 'કાર્યક્રમો';

  @override
  String get chat => 'ચેટ';

  @override
  String get findAGym => 'જિમ શોધો';

  @override
  String get searchGyms => 'નામ અથવા વિસ્તારથી શોધો';

  @override
  String get perks => 'સુવિધાઓ';

  @override
  String get rating => 'રેટિંગ';

  @override
  String get onLeavePaused => 'રજા પર — તમારું સભ્યપદ થંભાવ્યું છે';

  @override
  String get monthlyCheckIn => 'માસિક નોંધ';

  @override
  String get notNow => 'અત્યારે નહીં';

  @override
  String trainerNamed(String name) {
    return 'ટ્રેનર: $name';
  }

  @override
  String goalAtGym(String gym) {
    return '$gym માં તમારું લક્ષ્ય';
  }

  @override
  String daysRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count દિવસ બાકી',
      one: '1 દિવસ બાકી',
      zero: 'આજે પૂરું થાય છે',
    );
    return '$_temp0';
  }

  @override
  String get yourGoal => 'તમારું લક્ષ્ય';

  @override
  String get trainer => 'ટ્રેનર';

  @override
  String get requestLeave => 'રજાની વિનંતી';

  @override
  String get yourProgress => 'તમારી પ્રગતિ';

  @override
  String get addMeasurementsPrompt =>
      'તમારું વજન અને ઊંચાઈ ઉમેરો જેથી જિમ તમારી સાથે પ્રગતિ જોઈ શકે.';

  @override
  String get progressSubtitle => 'સમય સાથે વજન, અને તમે કેટલી વાર આવ્યા.';

  @override
  String get attendanceAppearsHere =>
      'તમે કોઈ જિમના સભ્ય બનો અને સ્ટાફ હાજરી નોંધવા લાગે પછી આ અહીં દેખાશે.';

  @override
  String get twoCheckInsDrawALine =>
      'બે નોંધથી રેખા બને છે. દર મહિને વજન ઉમેરો, આ ભરાતું જશે.';

  @override
  String get nothingMatchesFilters => 'આ ફિલ્ટર સાથે કંઈ મેળ ખાતું નથી.';

  @override
  String get howToJoinGym =>
      'જોડાવા માટે સીધો જિમનો સંપર્ક કરો. તેઓ તમને સભ્ય તરીકે ઉમેરશે.';

  @override
  String get weight => 'વજન';

  @override
  String get height => 'ઊંચાઈ';

  @override
  String get yourMeasurements => 'તમારા માપ';

  @override
  String get checkInDue => 'આ મહિનાની નોંધ બાકી છે';

  @override
  String get thisMonth => 'આ મહિને';

  @override
  String get perWeek => 'દર અઠવાડિયે';

  @override
  String get lastEightWeeks => 'છેલ્લા 8 અઠવાડિયા';

  @override
  String get exerciseDirectory => 'કસરત યાદી';

  @override
  String get exercises => 'કસરતો';

  @override
  String get searchExercises => 'કસરત શોધો';

  @override
  String get clear => 'સાફ કરો';

  @override
  String get howToDoIt => 'કેવી રીતે કરવું';

  @override
  String get watchOutFor => 'ધ્યાન રાખો';

  @override
  String get whatYouGet => 'તમને શું મળે છે';

  @override
  String get removeYourEntry => 'તમારી નોંધ કાઢવી?';

  @override
  String get stayIn => 'રહો';

  @override
  String get removeMe => 'મને કાઢો';

  @override
  String get youAreInTapToWithdraw => 'તમે જોડાયા છો — નીકળવા ટૅપ કરો';

  @override
  String get participate => 'ભાગ લો';

  @override
  String takenOffList(String event) {
    return '$event ની યાદીમાંથી તમારું નામ કાઢી નાખવામાં આવશે.';
  }

  @override
  String contactWithPhone(String phone) {
    return 'સંપર્ક $phone';
  }

  @override
  String get reasonOptional => 'કારણ (વૈકલ્પિક)';

  @override
  String get searchByGymCityDistrict => 'જિમ, શહેર કે જિલ્લાથી શોધો';

  @override
  String get useMyLocation => 'નજીકના જિમ શોધવા માટે મારું લોકેશન વાપરો';

  @override
  String get findingNearbyGyms => 'તમારી નજીકના જિમ શોધાઈ રહ્યા છે…';

  @override
  String get locationUnavailable =>
      'તમારું લોકેશન મળી શક્યું નહીં — બધા જિમ બતાવવામાં આવી રહ્યા છે';

  @override
  String get exerciseDirectorySubtitle =>
      'તાકાત, કાર્ડિયો અને યોગ, દરેક પગલાની સૂચના સાથે';

  @override
  String get attendance => 'હાજરી';

  @override
  String get manage => 'વ્યવસ્થાપન';

  @override
  String get choosePlan => 'પ્લાન પસંદ કરો';

  @override
  String get seeGrowthOverTime => 'સમય સાથે વૃદ્ધિ જુઓ';

  @override
  String lastNDays(int days) {
    return 'છેલ્લા $days દિવસ';
  }

  @override
  String get addMember => 'સભ્ય ઉમેરો';

  @override
  String get addStaff => 'સ્ટાફ ઉમેરો';

  @override
  String get searchByNameOrNumber => 'નામ કે નંબરથી શોધો';

  @override
  String get tapCircleToMarkPresent =>
      'હાજરી માટે વર્તુળ પર ટૅપ કરો, વિગતો માટે પંક્તિ પર';

  @override
  String markedPresent(String name) {
    return '$name હાજર નોંધ્યું';
  }

  @override
  String get approve => 'મંજૂર કરો';

  @override
  String get role => 'ભૂમિકા';

  @override
  String get theirName => 'તેમનું નામ';

  @override
  String get theirMobileNumber => 'તેમનો મોબાઇલ નંબર';

  @override
  String get codeFromTheirPhone => 'તેમના ફોનનો કોડ';

  @override
  String get whatDoTheyWant => 'તેમને જિમ પાસેથી શું જોઈએ છે?';

  @override
  String get goalHint => 'વજન વધારવું, ઘટાડવું, રિહેબ…';

  @override
  String get saveChanges => 'ફેરફાર સાચવો';

  @override
  String get removeFromGym => 'જિમમાંથી કાઢો';

  @override
  String get remove => 'કાઢો';

  @override
  String removePerson(String name) {
    return '$name ને કાઢવું?';
  }

  @override
  String get onLeave => 'રજા પર';

  @override
  String get tapDayToCorrect => 'સુધારવા દિવસ પર ટૅપ કરો';

  @override
  String correctDate(String date) {
    return '$date સુધારો';
  }

  @override
  String get whyIsThisChanging => 'આ કેમ બદલાય છે?';

  @override
  String get correctionReasonHint => 'ભૂલથી નોંધ્યું, મશીન બંધ હતું…';

  @override
  String get saveCorrection => 'સુધારો સાચવો';

  @override
  String get recordCorrected => 'રેકોર્ડ સુધર્યો.';

  @override
  String get trainerCategories => 'ટ્રેનર શ્રેણીઓ';

  @override
  String get newCategory => 'નવી શ્રેણી';

  @override
  String get noTrainerCategoriesYet => 'હજી કોઈ ટ્રેનર શ્રેણી નથી.';

  @override
  String get oneTrainerManyMembers => 'એક ટ્રેનર ઘણા સભ્યો રાખી શકે';

  @override
  String get categoryNameHint => 'રિહેબ, સ્ટ્રેંગ્થ, યોગ';

  @override
  String get edit => 'સંપાદિત કરો';

  @override
  String get delete => 'કાઢી નાખો';

  @override
  String get keepIt => 'રહેવા દો';

  @override
  String deleteNamed(String name) {
    return '$name કાઢી નાખવું?';
  }

  @override
  String get decline => 'નકારો';

  @override
  String decidedBy(String name) {
    return '$name દ્વારા નક્કી';
  }

  @override
  String get createAGym => 'જિમ બનાવો';

  @override
  String get createYourGym => 'તમારું જિમ બનાવો';

  @override
  String get gymName => 'જિમનું નામ';

  @override
  String get gymNameHint => 'આયર્ન ટેમ્પલ ફિટનેસ';

  @override
  String get descriptionOptional => 'વર્ણન (વૈકલ્પિક)';

  @override
  String get descriptionHint => 'તમારા જિમમાં જોડાવા જેવું શું છે?';

  @override
  String get address => 'સરનામું';

  @override
  String get city => 'શહેર';

  @override
  String get district => 'જિલ્લો';

  @override
  String get districtNote =>
      'શોધમાં તમારા જિમના નામ પાસે જિલ્લો દેખાય છે, જેથી સભ્યો ઓળખી શકે.';

  @override
  String get state => 'રાજ્ય';

  @override
  String get pinCode => 'પિન કોડ';

  @override
  String get contactNumber => 'સંપર્ક નંબર';

  @override
  String get leavePolicyNote =>
      'સભ્યો મહિનામાં થોડા દિવસ સભ્યપદ થંભાવી શકે. તેથી વધુ માટે મંજૂરી જોઈએ.';

  @override
  String get perksLabel => 'સુવિધાઓ, અલ્પવિરામથી અલગ';

  @override
  String get perksHint => 'સ્ટીમ રૂમ, મફત પાર્કિંગ, પર્સનલ ટ્રેનિંગ';

  @override
  String get createGym => 'જિમ બનાવો';

  @override
  String get deleteGym => 'જિમ કાઢી નાખો';

  @override
  String get gymProfile => 'જિમ પ્રોફાઇલ';

  @override
  String get description => 'વર્ણન';

  @override
  String get leavePolicy => 'રજા નીતિ';

  @override
  String get leaveDaysPerMonth => 'મહિને રજાના દિવસો';

  @override
  String get deleteThisGym => 'આ જિમ કાઢી નાખો';

  @override
  String get leaveLimitNote =>
      'આ મર્યાદામાં સભ્યોની વિનંતીઓ આપોઆપ મંજૂર થાય છે. તેથી વધુ માટે કોઈની મંજૂરી જોઈએ.';

  @override
  String get draftNote =>
      'તમારું જીમ ડ્રાફ્ટ તરીકે શરૂ થાય છે. તેનો ઉપયોગ શરૂ કરવા પ્લાન પસંદ કરો. Pro પ્લાનવાળા જીમ Gymologia સર્ચમાં પણ દેખાય છે.';

  @override
  String get sendThis => 'આ મોકલવું?';

  @override
  String get send => 'મોકલો';

  @override
  String get announcements => 'જાહેરાતો';

  @override
  String get title => 'શીર્ષક';

  @override
  String get announceTitleHint => 'જાળવણી માટે રવિવારે બંધ';

  @override
  String get message => 'સંદેશ';

  @override
  String get announceBodyHint =>
      'અમે સોમવારે સવારે 6 વાગ્યે ફરી ખોલીશું. ટૂંકી સૂચના બદલ માફ કરશો.';

  @override
  String get whoSeesIt => 'કોણ જોશે';

  @override
  String get everyone => 'બધા';

  @override
  String get sendAnnouncement => 'જાહેરાત મોકલો';

  @override
  String get sent => 'મોકલ્યું';

  @override
  String get newGym => 'નવું જિમ';

  @override
  String get draft => 'ડ્રાફ્ટ';

  @override
  String get nothingToChartYet => 'હજી બતાવવા જેવું કંઈ નથી.';

  @override
  String peakValue(int value) {
    return 'શિખર $value';
  }

  @override
  String get searchRanking => 'શોધ ક્રમાંક';

  @override
  String get notInSearch => 'શોધમાં નથી';

  @override
  String get members => 'સભ્યો';

  @override
  String get staff => 'સ્ટાફ';

  @override
  String get leave => 'રજા';

  @override
  String get roles => 'ભૂમિકાઓ';

  @override
  String get analytics => 'વિશ્લેષણ';

  @override
  String get growth => 'વૃદ્ધિ';

  @override
  String get ranking => 'ક્રમાંક';

  @override
  String get plan => 'પ્લાન';

  @override
  String get announce => 'જાહેરાત';

  @override
  String get trainers => 'ટ્રેનરો';

  @override
  String get present => 'હાજર';

  @override
  String get absent => 'ગેરહાજર';

  @override
  String get markAttendance => 'હાજરી નોંધો';

  @override
  String get getHelp => 'મદદ મેળવો';

  @override
  String get getHelpSubtitle => 'અમને સંદેશ મોકલો, અમે સંપર્ક કરીશું';

  @override
  String get termsAndPrivacy => 'શરતો અને ગોપનીયતા';

  @override
  String get signOut => 'સાઇન આઉટ';

  @override
  String get switchToStaff => 'માલિક/સ્ટાફ મોડમાં જાઓ';

  @override
  String get switchToMember => 'સભ્ય મોડમાં જાઓ';

  @override
  String get notifications => 'સૂચનાઓ';

  @override
  String get needsReview => 'અનુવાદ સમીક્ષા બાકી';

  @override
  String get block => 'બ્લોક કરો';

  @override
  String get unblock => 'અનબ્લોક કરો';

  @override
  String get report => 'રિપોર્ટ કરો';

  @override
  String blockPerson(String name) {
    return '$name ને બ્લોક કરો';
  }

  @override
  String reportPerson(String name) {
    return '$name વિશે રિપોર્ટ કરો';
  }

  @override
  String get blockConfirmBody =>
      'તેઓ તમને સંદેશ મોકલી શકશે નહીં, અને તમને તેમના સંદેશા દેખાશે નહીં. તમે તેમને બ્લોક કર્યા છે તે તેમને જણાવવામાં આવશે નહીં. તમે આ સેટિંગ્સમાં પાછું લઈ શકો છો.';

  @override
  String get blocked => 'બ્લોક કર્યું';

  @override
  String get blockedAccounts => 'બ્લોક કરેલા ખાતા';

  @override
  String get noBlockedAccounts => 'તમે કોઈને બ્લોક કર્યું નથી.';

  @override
  String get safetyAndPrivacy => 'સલામતી';

  @override
  String unblockQuestion(String name) {
    return '$name ને અનબ્લોક કરવા?';
  }

  @override
  String get unblockExplainer => 'તેઓ ફરીથી તમને સંદેશ મોકલી શકશે.';

  @override
  String get whyReporting => 'શું સમસ્યા છે?';

  @override
  String get reportDetails => 'શું થયું?';

  @override
  String get reportDetailsHint =>
      'સમીક્ષકો સંદેશ જાતે જોતા નથી. તેઓ તમારું વર્ણન જ વાંચે છે, તેથી શું કહેવાયું તે તમારા શબ્દોમાં જણાવો.';

  @override
  String get alsoBlockThem => 'તેમને બ્લોક પણ કરો';

  @override
  String get alsoBlockThemExplainer =>
      'રિપોર્ટ એક વ્યક્તિ વાંચે છે અને તેમાં સમય લાગે છે. બ્લોક કરવું તરત જ કામ કરે છે.';

  @override
  String get sendReport => 'રિપોર્ટ મોકલો';

  @override
  String get reportCategorySpam => 'સ્પામ અથવા અનિચ્છનીય વેચાણ';

  @override
  String get reportCategoryHarassment => 'હેરાનગતિ અથવા ધમકાવવું';

  @override
  String get reportCategorySexual => 'જાતીય અથવા અશ્લીલ સામગ્રી';

  @override
  String get reportCategoryHate => 'દ્વેષપૂર્ણ ભાષણ';

  @override
  String get reportCategoryViolence => 'હિંસા અથવા ધમકી';

  @override
  String get reportCategoryScam => 'છેતરપિંડી અથવા કૌભાંડ';

  @override
  String get reportCategoryImpersonation => 'બીજા કોઈનો ઢોંગ કરવો';

  @override
  String get reportCategoryOther => 'બીજું કંઈક';

  @override
  String get reportSent => 'આભાર. કોઈ આની સમીક્ષા કરશે.';

  @override
  String get myReports => 'મેં મોકલેલા રિપોર્ટ';

  @override
  String get reportStatusOpen => 'સમીક્ષાની રાહમાં';

  @override
  String get reportStatusReviewing => 'જોવામાં આવી રહ્યું છે';

  @override
  String get reportStatusActioned => 'કાર્યવાહી કરવામાં આવી';

  @override
  String get reportStatusDismissed => 'સમીક્ષા થઈ, કાર્યવાહી નહીં';

  @override
  String get noReportsSent => 'તમે કોઈની રિપોર્ટ કરી નથી.';

  @override
  String get deleteAccount => 'ખાતું કાઢી નાખો';

  @override
  String get deleteAccountIntro =>
      'તમારું ખાતું ૩૦ દિવસ સુધી વાપરી શકાશે. ત્યાર બાદ તે કાઢી નખાશે અને પાછું મળશે નહીં.';

  @override
  String get whatIsDeleted => 'શું કાઢી નખાશે';

  @override
  String get whatIsDeletedList =>
      'તમારું નામ, નંબર, ઇમેલ અને ઉંમર. તમારી ઊંચાઈ, વજન અને પ્રગતિ. તમારા ચેટ સંદેશા. કોઈપણ ઓળખ દસ્તાવેજો અને UPI વિગતો.';

  @override
  String get whatIsKept => 'શું રાખવામાં આવશે, તમારી ઓળખ કાઢીને';

  @override
  String get whatIsKeptList =>
      'ચુકવણી અને બિલના રેકોર્ડ, કારણ કે કાયદો હિસાબી ચોપડા રાખવાનું કહે છે. જિમમાં લેવાયેલાં પગલાંનો રેકોર્ડ, જેથી વિવાદ ઉકેલી શકાય.';

  @override
  String get deleteGymsFirst =>
      'તમારી પાસે હજુ એક જિમ છે. પહેલાં તે કાઢી નાખો — તમારું ખાતું કાઢવાથી તેના દરેક સભ્ય અને સ્ટાફની પહોંચ બંધ થઈ જશે, અને તેમને જણાવવામાં આવશે કે તે બંધ થઈ ગયું છે.';

  @override
  String unwithdrawnWarning(String amount) {
    return 'તમારી $amount રેફરલ કમાણી હજુ ઉપાડી નથી. પહેલાં Gymologia Referral એપમાં ઉપાડી લો, નહીં તો તે ગુમાવશો.';
  }

  @override
  String get iUnderstandLoseEarnings => 'હું સમજું છું કે આ પૈસા ગુમાવીશ';

  @override
  String deletionScheduled(String date) {
    return 'તમારું ખાતું $date ના રોજ કાઢી નખાશે.';
  }

  @override
  String get keepMyAccount => 'મારું ખાતું રાખો';

  @override
  String get deletionCancelled => 'તમારું ખાતું કાઢવામાં આવશે નહીં.';

  @override
  String get deleteAccountConfirm => 'મારું ખાતું કાઢી નાખો';

  @override
  String get about => 'પરિચય';

  @override
  String get participated => 'તમે જોડાયા';

  @override
  String letsGoName(String name) {
    return 'ચાલો, $name';
  }

  @override
  String get yourTraining => 'તમારી તાલીમ';

  @override
  String get tagline => 'ટ્રેન કરો. ટ્રેક કરો. બદલાઓ.';

  @override
  String get appearance => 'દેખાવ';

  @override
  String get themeDark => 'ડાર્ક';

  @override
  String get themeLight => 'લાઇટ';

  @override
  String get takePhoto => 'ફોટો લો';

  @override
  String get chooseFromGallery => 'ગેલેરીમાંથી પસંદ કરો';

  @override
  String get chooseFile => 'ફાઇલ પસંદ કરો';

  @override
  String get chooseFileHint => 'તમારી પાસેની PDF અથવા છબી';

  @override
  String get uploading => 'અપલોડ થઈ રહ્યું છે…';

  @override
  String fileTooLarge(int mb) {
    return 'આ ફાઇલ ખૂબ મોટી છે. મર્યાદા $mb MB છે.';
  }

  @override
  String get gymPhotos => 'જીમના ફોટા';

  @override
  String get gymPhotosHint =>
      'પહેલો ફોટો કવર છે, જે સભ્યો સર્ચમાં જુએ છે. બીજા ફોટાને કવર બનાવવા તેના પર ટેપ કરો.';

  @override
  String get addPhoto => 'ફોટો ઉમેરો';

  @override
  String get coverPhoto => 'કવર';

  @override
  String get removePhoto => 'ફોટો દૂર કરો';

  @override
  String maxPhotos(int count) {
    return 'તમે વધુમાં વધુ $count ફોટા ઉમેરી શકો છો.';
  }

  @override
  String get verification => 'ચકાસણી';

  @override
  String get kycIntro =>
      'Gymologia જીમ બ્રાઉઝરમાં દેખાવા માટે તમારું જીમ ચકાસો. અમારી ટીમ સામાન્ય રીતે 2 કામકાજના દિવસમાં દસ્તાવેજો તપાસે છે.';

  @override
  String get kycEncryptedNote =>
      'આધાર, PAN અને GST નંબર એન્ક્રિપ્ટ કરીને રાખવામાં આવે છે. તમારા દસ્તાવેજો ખાનગી છે, ફક્ત અમારી ચકાસણી ટીમ તેમને ખોલી શકે છે.';

  @override
  String get identity => 'ઓળખ';

  @override
  String get business => 'વ્યવસાય';

  @override
  String get aadhaarNumber => 'આધાર નંબર';

  @override
  String get enterValidAadhaar => 'તમારો 12 અંકનો આધાર નંબર દાખલ કરો';

  @override
  String get panNumber => 'PAN';

  @override
  String get enterValidPan => 'માન્ય PAN દાખલ કરો, જેમ કે ABCDE1234F';

  @override
  String get hasGstRegistration => 'મારું જીમ GST માં નોંધાયેલ છે';

  @override
  String get gstin => 'GSTIN';

  @override
  String get enterValidGstin => 'તમારો 15 અક્ષરનો GSTIN દાખલ કરો';

  @override
  String get businessProof => 'વ્યવસાયનો પુરાવો';

  @override
  String get businessProofHint => 'GST નથી? આમાંથી કોઈ એક અપલોડ કરો.';

  @override
  String get proofUdyam => 'ઉદ્યમ';

  @override
  String get proofElectricityBill => 'વીજળી બિલ';

  @override
  String get proofOther => 'અન્ય';

  @override
  String get premisesQuestion => 'જગ્યા';

  @override
  String get premisesOwned => 'પોતાનું';

  @override
  String get premisesRented => 'ભાડાનું';

  @override
  String get landlordNoc => 'મકાનમાલિકની NOC';

  @override
  String get landlordNocHint => 'જગ્યાના માલિકનો વાંધો નહીં પત્ર';

  @override
  String get uploadDocument => 'અપલોડ';

  @override
  String get documentUploaded => 'અપલોડ થયું';

  @override
  String get replaceDocument => 'બદલો';

  @override
  String get documentRequired => 'કૃપા કરીને આ દસ્તાવેજ અપલોડ કરો.';

  @override
  String get submitForVerification => 'ચકાસણી માટે મોકલો';

  @override
  String get kycSubmittedSnackbar => 'ચકાસણી માટે મોકલ્યું';

  @override
  String get whatYouSent => 'તમે શું મોકલ્યું';

  @override
  String get kycUnderReview => 'તપાસ ચાલુ છે';

  @override
  String get kycUnderReviewBody =>
      'અમારી ટીમ તમારા દસ્તાવેજો તપાસી રહી છે. પૂર્ણ થતાં જ તમને જાણ કરવામાં આવશે.';

  @override
  String kycVerifiedOn(String date) {
    return '$date ના રોજ ચકાસાયું. તમારું જીમ હવે સર્ચમાં દેખાઈ શકે છે.';
  }

  @override
  String get kycNeedsChanges => 'ફેરફાર જરૂરી';

  @override
  String get kycOnlyOwner =>
      'ફક્ત જીમના નોંધાયેલા માલિક જ ચકાસણી દસ્તાવેજો મોકલી શકે છે.';

  @override
  String get statusPending => 'બાકી';

  @override
  String get statusRejected => 'નકારાયું';

  @override
  String get statusNotSubmitted => 'મોકલ્યું નથી';

  @override
  String get getVerified => 'ચકાસણી કરાવો';

  @override
  String get gymLocation => 'જીમનું સ્થાન';

  @override
  String get gymLocationHint =>
      'તમારા જીમની અંદર ઊભા રહીને ટેપ કરો, જેથી નજીકના સભ્યો તમને શોધી શકે.';

  @override
  String get setGymLocation => 'સ્થાન લો';

  @override
  String get updateGymLocation => 'અપડેટ';

  @override
  String get gymLocationSet => 'સ્થાન સેટ છે';

  @override
  String get gymLocationFailed =>
      'તમારું સ્થાન મળ્યું નહીં. લોકેશન ચાલુ કરીને ફરી પ્રયાસ કરો.';

  @override
  String gymCreatedAddPhotos(String name) {
    return '$name બની ગયું. ફોટાવાળા જીમને વધુ સભ્યો મળે છે, તેથી હમણાં થોડા ઉમેરો. પછી જીમ પ્રોફાઇલમાં બદલી શકો છો.';
  }

  @override
  String get finish => 'થઈ ગયું';

  @override
  String get skipForNow => 'હમણાં છોડો';

  @override
  String get gymLocationNotSet => 'હજી સેટ નથી';
}
