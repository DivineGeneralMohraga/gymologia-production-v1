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
  String get gymProfile => 'જિમ પ્રોફાઇલ';

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
