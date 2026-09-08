// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Gujarati (`gu`).
class AppLocalizationsGu extends AppLocalizations {
  AppLocalizationsGu([String locale = 'gu']) : super(locale);

  @override
  String get appTitle => 'Gymologia Referral';

  @override
  String get tryAgain => 'ફરી પ્રયાસ કરો';

  @override
  String get cancel => 'રદ કરો';

  @override
  String get save => 'સેવ કરો';

  @override
  String get add => 'ઉમેરો';

  @override
  String get change => 'બદલો';

  @override
  String get genericError => 'કંઈક ખોટું થયું. કૃપા કરી ફરી પ્રયાસ કરો.';

  @override
  String cleartextWarning(String host) {
    return '$host સાથે સુરક્ષા વગર (plain http) જોડાયેલું છે';
  }

  @override
  String get signInSubtitle =>
      'કોડ શેર કરો. કોઈ જીમ સબ્સ્ક્રિપ્શન લે ત્યારે તમને કમાણી થાય.';

  @override
  String get phoneLabel => 'મોબાઇલ નંબર';

  @override
  String get phoneHint => '10 અંકનો મોબાઇલ નંબર';

  @override
  String get sendCode => 'કોડ મોકલો';

  @override
  String codeSentTo(String phone) {
    return '$phone પર કોડ મોકલ્યો';
  }

  @override
  String get verify => 'ચકાસો';

  @override
  String resendIn(int seconds) {
    return '$seconds સેકન્ડ પછી તમે બીજો કોડ માંગી શકો છો';
  }

  @override
  String get resend => 'બીજો કોડ મોકલો';

  @override
  String get changeNumber => 'બીજો નંબર વાપરો';

  @override
  String get enterTenDigits => 'તમારો 10 અંકનો મોબાઇલ નંબર દાખલ કરો.';

  @override
  String get enterTheCode => 'અમે મોકલેલો કોડ દાખલ કરો.';

  @override
  String get ownersCannotJoin =>
      'જીમ માલિકો રેફરલ એપ વાપરી શકતા નથી. જીમ સ્ટાફ અને બાકી બધા વાપરી શકે છે.';

  @override
  String get createAccountTitle => 'તમારું ખાતું બનાવો';

  @override
  String get nameLabel => 'નામ';

  @override
  String get emailLabel => 'ઈમેલ (વૈકલ્પિક)';

  @override
  String get ageLabel => 'ઉંમર';

  @override
  String get ageWhy =>
      'અમે માત્ર ઉંમર પૂછીએ છીએ, જન્મતારીખ ક્યારેય નહીં. જન્મતારીખ તમારી બેંક અને સરકારી દસ્તાવેજોની ચાવી છે; ઉંમર નથી.';

  @override
  String get ageRange => '13 થી 100 વચ્ચેની ઉંમર દાખલ કરો.';

  @override
  String get nameRequired => 'કૃપા કરી તમારું નામ દાખલ કરો.';

  @override
  String get createAccount => 'ખાતું બનાવો';

  @override
  String get tabCode => 'તમારો કોડ';

  @override
  String get tabEarnings => 'કમાણી';

  @override
  String get tabPayout => 'ચુકવણી';

  @override
  String get tabSettings => 'સેટિંગ્સ';

  @override
  String get yourCodeTitle => 'તમારો રેફરલ કોડ';

  @override
  String get shareCode => 'શેર કરો';

  @override
  String get copyCode => 'કૉપિ કરો';

  @override
  String get copied => 'કૉપિ થઈ ગયું.';

  @override
  String get shareUnavailable =>
      'અહીં શેર કરી શકાતું નથી. સંદેશ કૉપિ કરી દીધો છે.';

  @override
  String get howItWorksTitle => 'આ કેવી રીતે કામ કરે છે';

  @override
  String get howItWorksStep1 => 'જીમ ચલાવતા કોઈને તમારો કોડ મોકલો.';

  @override
  String howItWorksStep2(int percent) {
    return 'સબ્સ્ક્રિપ્શન લેતી વખતે તેમને કોઈ પણ Gymologia પ્લાન પર $percent% છૂટ મળશે.';
  }

  @override
  String howItWorksStep3(String amount) {
    return 'આ કોડથી સબ્સ્ક્રિપ્શન લેનારા દરેક જીમ માટે તમને $amount મળશે.';
  }

  @override
  String howItWorksStep4(String amount) {
    return 'તમારું UPI ID ખરેખર તમારું જ છે તે ચકાસવા પહેલી ચુકવણીમાંથી એક વાર $amount કાપવામાં આવે છે.';
  }

  @override
  String get notForOwners => 'તમારા પોતાના જીમમાંથી તમે કમાણી કરી શકતા નથી.';

  @override
  String get earnedTotal => 'અત્યાર સુધી કમાયા';

  @override
  String get heldPending => 'રોકી રાખેલા';

  @override
  String get paidOut => 'ચૂકવેલા';

  @override
  String get taxWithheld => 'કાપેલો કર';

  @override
  String get neverUsed => 'હજી સુધી કોઈએ તમારો કોડ વાપર્યો નથી.';

  @override
  String timesUsed(int count) {
    return '$count વાર વપરાયો.';
  }

  @override
  String get usedOnce => 'એક વાર વપરાયો.';

  @override
  String awaitingClearance(int count) {
    return '$count હજી ક્લિયર થઈ રહ્યા છે.';
  }

  @override
  String get earningsTitle => 'તમારા કોડે શું કમાયું';

  @override
  String get earningsEmpty =>
      'હજી કંઈ નહીં. જીમ ચલાવતા કોઈની સાથે તમારો કોડ શેર કરો.';

  @override
  String earningsCapped(int count) {
    return 'સૌથી તાજેતરના $count બતાવી રહ્યા છીએ.';
  }

  @override
  String get statusPending => 'ક્લિયર થઈ રહ્યું છે';

  @override
  String get statusEligible => 'ચુકવણી માટે તૈયાર';

  @override
  String get statusPaid => 'ચૂકવાયું';

  @override
  String get statusReversed => 'પાછું લેવાયું';

  @override
  String get statusPendingWhy =>
      'જીમની રિફંડ મુદત પૂરી થાય ત્યાં સુધી રોકી રાખ્યું છે.';

  @override
  String get statusEligibleWhy =>
      'ક્લિયર થઈ ગયું. ચુકવણી શરૂ થવાની રાહ જોવાય છે.';

  @override
  String get statusPaidWhy => 'તમારા UPI ID પર મોકલી દીધું.';

  @override
  String get statusReversedWhy =>
      'જીમની ચુકવણી પાછી થઈ, તેથી આ ઇનામ પણ પાછું લેવાયું.';

  @override
  String get payoutTitle => 'તમારા પૈસા ક્યાં જાય છે';

  @override
  String get withdrawTitle => 'પૈસા ઉપાડો';

  @override
  String get withdrawAvailable => 'ઉપાડવા માટે તૈયાર';

  @override
  String get withdrawFee => 'એક વખતની UPI ચકાસણી';

  @override
  String get withdrawArrives => 'તમને મળશે';

  @override
  String withdrawButton(String amount) {
    return '$amount ઉપાડો';
  }

  @override
  String withdrawConfirm(String amount, String upi) {
    return '$upi પર $amount મોકલવા?';
  }

  @override
  String get withdrawConfirmBody =>
      'આ પાછું લઈ શકાશે નહીં. મોકલતાં પહેલાં સરનામું બરાબર છે કે નહીં તપાસો.';

  @override
  String get withdrawRequested => 'વિનંતી થઈ. પૈસા રસ્તામાં છે.';

  @override
  String withdrawFeeWhy(String amount) {
    return 'સરનામું ખરેખર તમારું જ છે તે ચકાસવા એક વાર $amount કાપવામાં આવે છે. તે પછી કંઈ કપાતું નથી.';
  }

  @override
  String get withdrawNoTax => 'આટલી રકમ પર કોઈ કર કાપવામાં આવતો નથી.';

  @override
  String get withdrawHistoryTitle => 'ઉપાડ';

  @override
  String get withdrawNone => 'તમે હજી કંઈ ઉપાડ્યું નથી.';

  @override
  String get withdrawStatusQueued => 'કતારમાં';

  @override
  String get withdrawStatusProcessing => 'મોકલી રહ્યા છીએ';

  @override
  String get withdrawStatusSuccess => 'મોકલ્યું';

  @override
  String get withdrawStatusFailed => 'નિષ્ફળ';

  @override
  String get withdrawStatusReversed => 'પાછું આવ્યું';

  @override
  String withdrawUtr(String utr) {
    return 'સંદર્ભ $utr';
  }

  @override
  String get payoutsNotLive =>
      'ચુકવણી હજી શરૂ થઈ નથી. ત્યાં સુધી કમાણી ગણાય છે અને રોકી રખાય છે.';

  @override
  String get stillNeededTitle => 'હજી જરૂરી';

  @override
  String get payoutInFlight =>
      'એક ચુકવણી રસ્તામાં છે. તે પતી જાય પછી આ બદલી શકાશે.';

  @override
  String get upiSectionTitle => 'UPI ID';

  @override
  String get upiIdLabel => 'UPI ID';

  @override
  String get upiIdHint => 'name@bank';

  @override
  String get holderNameLabel => 'ખાતા પરનું નામ';

  @override
  String get upiNotSet => 'સેટ કરેલું નથી';

  @override
  String get upiVerifiedYes => 'ચકાસાયેલું';

  @override
  String get upiVerifiedNo => 'હજી ચકાસાયું નથી';

  @override
  String get upiTypoWarning =>
      'આને અક્ષરે અક્ષરે તપાસો. UPI ID માં કોઈ સ્પેલ-ચેક હોતું નથી: એક અક્ષરની ભૂલ બીજા કોઈનું તદ્દન સાચું સરનામું બની જાય છે, અને ત્યાં મોકલેલા પૈસા પાછા આવતા નથી.';

  @override
  String get upiChangedClearsVerification =>
      'આ બદલવાથી ચકાસણી રદ થાય છે. પહેલી ચુકવણી પહેલાં સરનામું ફરી ચકાસાશે.';

  @override
  String get holderNameWhy =>
      '₹10 ની ચકાસણીમાં તે ખાતા માટે તમારી બેંક પાસે નોંધાયેલું નામ પાછું આવે છે. સરખાવવા માટે નામ ન હોય તો ચકાસણી માત્ર એટલું જ સાબિત કરે છે કે સરનામું છે — તે તમારું છે એ નહીં.';

  @override
  String get saved => 'સેવ થઈ ગયું.';

  @override
  String get invalidUpi =>
      'આ UPI ID જેવું લાગતું નથી. તે name@bank જેવું હોવું જોઈએ.';

  @override
  String get holderNameRequired => 'બેંક ખાતા પરનું નામ દાખલ કરો.';

  @override
  String get panSectionTitle => 'PAN';

  @override
  String get panLabel => 'PAN';

  @override
  String get panHint => 'ABCDE1234F';

  @override
  String get panNotSet => 'સેટ કરેલું નથી';

  @override
  String get panWhy =>
      'કર કાપવો પડે એટલી તમારી કમાણી થાય તે પહેલાં આ જોઈએ. શરૂ કરવા માટે જરૂરી નથી.';

  @override
  String get panStatusPending => 'મળ્યું, હજી તપાસ્યું નથી';

  @override
  String get panStatusVerified => 'ચકાસાયેલું';

  @override
  String get panStatusRejected => 'સ્વીકારાયું નથી. નંબર તપાસીને ફરી મોકલો.';

  @override
  String get invalidPan =>
      'આ PAN જેવું લાગતું નથી. તે ABCDE1234F જેવું હોવું જોઈએ.';

  @override
  String get settingsTitle => 'સેટિંગ્સ';

  @override
  String get profileTitle => 'તમારી પ્રોફાઇલ';

  @override
  String get languageTitle => 'ભાષા';

  @override
  String get languageSubtitle => 'તમે સૌથી સહેલાઈથી વાંચી શકો તે ભાષા પસંદ કરો';

  @override
  String get useDeviceLanguage => 'ડિવાઇસની ભાષા વાપરો';

  @override
  String get needsReview => 'અનુવાદની સમીક્ષા બાકી છે';

  @override
  String get untranslatedFallbackNote =>
      'જે હજી અનુવાદિત નથી તે ખાલી રાખવાને બદલે અંગ્રેજીમાં બતાવાય છે, જેથી આંશિક રીતે અનુવાદિત ભાષા પણ વાપરી શકાય.';

  @override
  String get legalTitle => 'શરતો અને ગોપનીયતા';

  @override
  String get legalUnavailable => 'આ અત્યારે લોડ થઈ શક્યું નહીં.';

  @override
  String get supportTitle => 'મદદ જોઈએ છે?';

  @override
  String get supportBody => 'શું થયું તે અમને જણાવો, અમે તમારો સંપર્ક કરીશું.';

  @override
  String get supportSubject => 'વિષય';

  @override
  String get supportMessage => 'શું થયું?';

  @override
  String get supportSend => 'મોકલો';

  @override
  String get supportSent => 'મોકલી દીધું. અમે તમારો સંપર્ક કરીશું.';

  @override
  String supportEmailLine(String email) {
    return 'અથવા $email પર લખો.';
  }

  @override
  String get supportTooShort =>
      'એક-બે વાક્ય લખો, જેથી અમને ખબર પડે કે શું જોવાનું છે.';

  @override
  String get signOut => 'સાઇન આઉટ';

  @override
  String get signOutConfirm => 'આ ડિવાઇસ પર સાઇન આઉટ કરવું છે?';

  @override
  String get aboutTitle => 'વિશે';

  @override
  String get sessionExpiredSignIn =>
      'તમારું સત્ર પૂરું થયું. કૃપા કરી ફરી સાઇન ઇન કરો.';

  @override
  String get serverTookTooLong =>
      'સર્વરે જવાબ આપવામાં બહુ સમય લીધો. તમારું કનેક્શન તપાસીને ફરી પ્રયાસ કરો.';

  @override
  String couldNotReachServer(String host) {
    return '$host સુધી પહોંચી શકાયું નહીં. તમારું ઇન્ટરનેટ કનેક્શન તપાસો.';
  }

  @override
  String get certificateNotVerified => 'સર્વરનું પ્રમાણપત્ર ચકાસી શકાયું નહીં.';

  @override
  String get networkErrorTryAgain => 'નેટવર્ક ભૂલ. કૃપા કરી ફરી પ્રયાસ કરો.';

  @override
  String get footerLine => 'Gymologia Referral';

  @override
  String get footerSupport => 'support@gymologia.com';
}
