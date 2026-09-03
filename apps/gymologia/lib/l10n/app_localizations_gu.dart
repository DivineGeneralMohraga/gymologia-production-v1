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
  String get findAGymTab => 'જિમ શોધો';

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
  String get exerciseDirectorySubtitle =>
      'તાકાત, કાર્ડિયો અને યોગ, દરેક પગલાની સૂચના સાથે';

  @override
  String get steps => 'પગલાં';

  @override
  String get attendance => 'હાજરી';

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
