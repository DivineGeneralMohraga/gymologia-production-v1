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
  String get loading => 'લોડ થઈ રહ્યું છે';

  @override
  String get somethingWentWrong => 'કંઈક ખોટું થયું';

  @override
  String get signIn => 'સાઇન ઇન';

  @override
  String get phoneNumber => 'મોબાઇલ નંબર';

  @override
  String get enterPhoneNumber => 'તમારો મોબાઇલ નંબર દાખલ કરો';

  @override
  String get sendCode => 'કોડ મોકલો';

  @override
  String get verifyCode => 'ચકાસો';

  @override
  String get enterCode => 'અમે મોકલેલો કોડ દાખલ કરો';

  @override
  String get resendCode => 'ફરી મોકલો';

  @override
  String get createAccount => 'તમારું ખાતું બનાવો';

  @override
  String get yourName => 'તમારું નામ';

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
  String get profile => 'પ્રોફાઇલ';

  @override
  String get findAGym => 'જિમ શોધો';

  @override
  String get searchGyms => 'નામ અથવા વિસ્તારથી શોધો';

  @override
  String get noGymsFound => 'અહીં હજી કોઈ જિમ નથી';

  @override
  String get perks => 'સુવિધાઓ';

  @override
  String get contactGym => 'આ જિમનો સંપર્ક કરો';

  @override
  String get rating => 'રેટિંગ';

  @override
  String get yourMembership => 'તમારું સભ્યપદ';

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
  String get addMeasurements =>
      'તમારું વજન અને ઊંચાઈ ઉમેરો જેથી જિમ તમારી સાથે પ્રગતિ જોઈ શકે';

  @override
  String get checkInDue => 'આ મહિનાની નોંધ બાકી છે';

  @override
  String get thisMonth => 'આ મહિને';

  @override
  String get perWeek => 'દર અઠવાડિયે';

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
  String get exerciseDirectorySubtitle =>
      'તાકાત, કાર્ડિયો અને યોગ, દરેક પગલાની સૂચના સાથે';

  @override
  String get steps => 'પગલાં';

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
  String get onLeave => 'રજા';

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
      'તમારું જિમ ડ્રાફ્ટ તરીકે શરૂ થાય છે. ચકાસણી પૂરી કરીને પ્લાન ન લો ત્યાં સુધી શોધમાં નહીં દેખાય.';

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
  String get noNotifications => 'નવું કંઈ નથી';

  @override
  String get needsReview => 'અનુવાદ સમીક્ષા બાકી';
}
