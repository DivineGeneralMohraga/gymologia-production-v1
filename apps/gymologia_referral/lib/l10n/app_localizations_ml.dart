// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malayalam (`ml`).
class AppLocalizationsMl extends AppLocalizations {
  AppLocalizationsMl([String locale = 'ml']) : super(locale);

  @override
  String get appTitle => 'Gymologia Referral';

  @override
  String get tryAgain => 'വീണ്ടും ശ്രമിക്കുക';

  @override
  String get cancel => 'റദ്ദാക്കുക';

  @override
  String get save => 'സേവ് ചെയ്യുക';

  @override
  String get add => 'ചേർക്കുക';

  @override
  String get change => 'മാറ്റുക';

  @override
  String get genericError => 'എന്തോ പിഴവ് സംഭവിച്ചു. വീണ്ടും ശ്രമിക്കുക.';

  @override
  String cleartextWarning(String host) {
    return '$host ലേക്ക് സുരക്ഷയില്ലാതെ (plain http) കണക്റ്റ് ചെയ്തിരിക്കുന്നു';
  }

  @override
  String get signInSubtitle =>
      'കോഡ് പങ്കിടുക. ഒരു ജിം സബ്‌സ്‌ക്രിപ്ഷൻ എടുക്കുമ്പോൾ നിങ്ങൾക്ക് വരുമാനം.';

  @override
  String get phoneLabel => 'മൊബൈൽ നമ്പർ';

  @override
  String get phoneHint => '10 അക്ക മൊബൈൽ നമ്പർ';

  @override
  String get sendCode => 'കോഡ് അയയ്ക്കുക';

  @override
  String codeSentTo(String phone) {
    return '$phone ലേക്ക് കോഡ് അയച്ചു';
  }

  @override
  String get verify => 'പരിശോധിക്കുക';

  @override
  String resendIn(int seconds) {
    return '$seconds സെക്കൻഡിനു ശേഷം മറ്റൊരു കോഡ് ചോദിക്കാം';
  }

  @override
  String get resend => 'മറ്റൊരു കോഡ് അയയ്ക്കുക';

  @override
  String get changeNumber => 'മറ്റൊരു നമ്പർ ഉപയോഗിക്കുക';

  @override
  String get enterTenDigits => 'നിങ്ങളുടെ 10 അക്ക മൊബൈൽ നമ്പർ നൽകുക.';

  @override
  String get enterTheCode => 'ഞങ്ങൾ അയച്ച കോഡ് നൽകുക.';

  @override
  String get ownersCannotJoin =>
      'ജിം ഉടമകൾക്ക് ഈ റഫറൽ ആപ്പ് ഉപയോഗിക്കാനാവില്ല. ജിം ജീവനക്കാർക്കും മറ്റെല്ലാവർക്കും കഴിയും.';

  @override
  String get createAccountTitle => 'നിങ്ങളുടെ അക്കൗണ്ട് ഉണ്ടാക്കുക';

  @override
  String get nameLabel => 'പേര്';

  @override
  String get emailLabel => 'ഇമെയിൽ (നിർബന്ധമല്ല)';

  @override
  String get ageLabel => 'വയസ്സ്';

  @override
  String get ageWhy =>
      'ഞങ്ങൾ വയസ്സ് മാത്രമേ ചോദിക്കൂ, ജനനത്തീയതി ഒരിക്കലും ഇല്ല. ജനനത്തീയതി നിങ്ങളുടെ ബാങ്ക്, സർക്കാർ രേഖകളിലേക്കുള്ള താക്കോലാണ്; വയസ്സ് അല്ല.';

  @override
  String get ageRange => '13 നും 100 നും ഇടയിലുള്ള വയസ്സ് നൽകുക.';

  @override
  String get nameRequired => 'ദയവായി നിങ്ങളുടെ പേര് നൽകുക.';

  @override
  String get createAccount => 'അക്കൗണ്ട് ഉണ്ടാക്കുക';

  @override
  String get tabCode => 'നിങ്ങളുടെ കോഡ്';

  @override
  String get tabEarnings => 'വരുമാനം';

  @override
  String get tabPayout => 'പണമടയ്ക്കൽ';

  @override
  String get tabSettings => 'ക്രമീകരണങ്ങൾ';

  @override
  String get yourCodeTitle => 'നിങ്ങളുടെ റഫറൽ കോഡ്';

  @override
  String get shareCode => 'പങ്കിടുക';

  @override
  String get copyCode => 'പകർത്തുക';

  @override
  String get copied => 'പകർത്തി.';

  @override
  String get shareUnavailable =>
      'ഇവിടെ പങ്കിടാൻ കഴിയില്ല. സന്ദേശം പകർത്തിവച്ചിട്ടുണ്ട്.';

  @override
  String get howItWorksTitle => 'ഇത് എങ്ങനെ പ്രവർത്തിക്കുന്നു';

  @override
  String get howItWorksStep1 =>
      'ജിം നടത്തുന്ന ഒരാൾക്ക് നിങ്ങളുടെ കോഡ് അയയ്ക്കുക.';

  @override
  String howItWorksStep2(int percent) {
    return 'സബ്‌സ്‌ക്രിപ്ഷൻ എടുക്കുമ്പോൾ ഏത് Gymologia പ്ലാനിലും അവർക്ക് $percent% കിഴിവ് ലഭിക്കും.';
  }

  @override
  String howItWorksStep3(String amount) {
    return 'ഈ കോഡ് ഉപയോഗിച്ച് സബ്‌സ്‌ക്രിപ്ഷൻ എടുക്കുന്ന ഓരോ ജിമ്മിനും നിങ്ങൾക്ക് $amount ലഭിക്കും.';
  }

  @override
  String howItWorksStep4(String amount) {
    return 'നിങ്ങളുടെ UPI ID ശരിക്കും നിങ്ങളുടേതാണോ എന്ന് പരിശോധിക്കാൻ ആദ്യ പണമടയ്ക്കലിൽ നിന്ന് ഒരിക്കൽ $amount ഈടാക്കും.';
  }

  @override
  String get notForOwners =>
      'സ്വന്തം ജിമ്മിൽ നിന്ന് നിങ്ങൾക്ക് സമ്പാദിക്കാനാവില്ല.';

  @override
  String get earnedTotal => 'ഇതുവരെ നേടിയത്';

  @override
  String get heldPending => 'പിടിച്ചുവച്ചത്';

  @override
  String get paidOut => 'നൽകിയത്';

  @override
  String get taxWithheld => 'പിടിച്ച നികുതി';

  @override
  String get neverUsed => 'ഇതുവരെ ആരും നിങ്ങളുടെ കോഡ് ഉപയോഗിച്ചിട്ടില്ല.';

  @override
  String timesUsed(int count) {
    return '$count തവണ ഉപയോഗിച്ചു.';
  }

  @override
  String get usedOnce => 'ഒരു തവണ ഉപയോഗിച്ചു.';

  @override
  String awaitingClearance(int count) {
    return '$count എണ്ണം ഇപ്പോഴും ക്ലിയർ ആകുന്നു.';
  }

  @override
  String get earningsTitle => 'നിങ്ങളുടെ കോഡ് നേടിയത്';

  @override
  String get earningsEmpty =>
      'ഇതുവരെ ഒന്നുമില്ല. ജിം നടത്തുന്ന ഒരാളുമായി നിങ്ങളുടെ കോഡ് പങ്കിടുക.';

  @override
  String earningsCapped(int count) {
    return 'ഏറ്റവും പുതിയ $count എണ്ണം കാണിക്കുന്നു.';
  }

  @override
  String get statusPending => 'ക്ലിയർ ആകുന്നു';

  @override
  String get statusEligible => 'നൽകാൻ തയ്യാർ';

  @override
  String get statusPaid => 'നൽകി';

  @override
  String get statusReversed => 'തിരിച്ചെടുത്തു';

  @override
  String get statusPendingWhy =>
      'ജിമ്മിന്റെ റീഫണ്ട് കാലാവധി തീരുന്നതുവരെ പിടിച്ചുവച്ചിരിക്കുന്നു.';

  @override
  String get statusEligibleWhy =>
      'ക്ലിയർ ആയി. പണമടയ്ക്കൽ ആരംഭിക്കുന്നതിനായി കാത്തിരിക്കുന്നു.';

  @override
  String get statusPaidWhy => 'നിങ്ങളുടെ UPI ID ലേക്ക് അയച്ചു.';

  @override
  String get statusReversedWhy =>
      'ജിമ്മിന്റെ പണം തിരികെ നൽകിയതിനാൽ ഈ പ്രതിഫലവും തിരിച്ചെടുത്തു.';

  @override
  String get payoutTitle => 'നിങ്ങളുടെ പണം എവിടെ പോകുന്നു';

  @override
  String get payoutsNotLive =>
      'പണമടയ്ക്കൽ ഇതുവരെ ആരംഭിച്ചിട്ടില്ല. അതുവരെ വരുമാനം കണക്കാക്കി പിടിച്ചുവയ്ക്കുന്നു.';

  @override
  String get stillNeededTitle => 'ഇനിയും വേണ്ടത്';

  @override
  String get payoutInFlight =>
      'ഒരു പണമടയ്ക്കൽ വഴിയിലാണ്. അത് തീർന്നാൽ ഇവ മാറ്റാം.';

  @override
  String get upiSectionTitle => 'UPI ID';

  @override
  String get upiIdLabel => 'UPI ID';

  @override
  String get upiIdHint => 'name@bank';

  @override
  String get holderNameLabel => 'അക്കൗണ്ടിലെ പേര്';

  @override
  String get upiNotSet => 'സജ്ജമാക്കിയിട്ടില്ല';

  @override
  String get upiVerifiedYes => 'പരിശോധിച്ചു';

  @override
  String get upiVerifiedNo => 'ഇതുവരെ പരിശോധിച്ചിട്ടില്ല';

  @override
  String get upiTypoWarning =>
      'ഇത് അക്ഷരം അക്ഷരമായി പരിശോധിക്കുക. UPI ID ക്ക് സ്പെൽ-ചെക്ക് ഇല്ല: ഒരക്ഷരത്തിന്റെ പിഴവ് മറ്റൊരാളുടെ തികച്ചും ശരിയായ വിലാസമായി മാറും, അവിടേക്ക് അയച്ച പണം തിരികെ വരില്ല.';

  @override
  String get upiChangedClearsVerification =>
      'ഇത് മാറ്റിയാൽ പരിശോധന റദ്ദാകും. ആദ്യ പണമടയ്ക്കലിന് മുൻപ് വിലാസം വീണ്ടും പരിശോധിക്കും.';

  @override
  String get holderNameWhy =>
      '₹10 ന്റെ പരിശോധനയിൽ ആ അക്കൗണ്ടിന് നിങ്ങളുടെ ബാങ്കിൽ രജിസ്റ്റർ ചെയ്ത പേര് തിരികെ വരും. താരതമ്യം ചെയ്യാൻ ഒരു പേരില്ലെങ്കിൽ, വിലാസം ഉണ്ടെന്ന് മാത്രമേ അത് തെളിയിക്കൂ — അത് നിങ്ങളുടേതാണെന്ന് അല്ല.';

  @override
  String get saved => 'സേവ് ചെയ്തു.';

  @override
  String get invalidUpi =>
      'ഇത് UPI ID പോലെ തോന്നുന്നില്ല. ഇത് name@bank പോലെ ആയിരിക്കണം.';

  @override
  String get holderNameRequired => 'ബാങ്ക് അക്കൗണ്ടിലെ പേര് നൽകുക.';

  @override
  String get panSectionTitle => 'PAN';

  @override
  String get panLabel => 'PAN';

  @override
  String get panHint => 'ABCDE1234F';

  @override
  String get panNotSet => 'സജ്ജമാക്കിയിട്ടില്ല';

  @override
  String get panWhy =>
      'നികുതി പിടിക്കേണ്ട നിലയിലേക്ക് നിങ്ങളുടെ വരുമാനം എത്തുന്നതിന് മുൻപ് ഇത് വേണം. തുടങ്ങാൻ ആവശ്യമില്ല.';

  @override
  String get panStatusPending => 'ലഭിച്ചു, ഇതുവരെ പരിശോധിച്ചിട്ടില്ല';

  @override
  String get panStatusVerified => 'പരിശോധിച്ചു';

  @override
  String get panStatusRejected =>
      'സ്വീകരിച്ചില്ല. നമ്പർ പരിശോധിച്ച് വീണ്ടും അയയ്ക്കുക.';

  @override
  String get invalidPan =>
      'ഇത് PAN പോലെ തോന്നുന്നില്ല. ഇത് ABCDE1234F പോലെ ആയിരിക്കണം.';

  @override
  String get settingsTitle => 'ക്രമീകരണങ്ങൾ';

  @override
  String get profileTitle => 'നിങ്ങളുടെ പ്രൊഫൈൽ';

  @override
  String get languageTitle => 'ഭാഷ';

  @override
  String get languageSubtitle =>
      'നിങ്ങൾ ഏറ്റവും സുഖമായി വായിക്കുന്ന ഭാഷ തിരഞ്ഞെടുക്കുക';

  @override
  String get useDeviceLanguage => 'ഉപകരണത്തിന്റെ ഭാഷ ഉപയോഗിക്കുക';

  @override
  String get needsReview => 'വിവർത്തനം പരിശോധിക്കാനുണ്ട്';

  @override
  String get untranslatedFallbackNote =>
      'ഇതുവരെ വിവർത്തനം ചെയ്യാത്തവ ശൂന്യമാക്കാതെ ഇംഗ്ലീഷിൽ കാണിക്കുന്നു, അതിനാൽ ഭാഗികമായി വിവർത്തനം ചെയ്ത ഭാഷയും ഉപയോഗിക്കാം.';

  @override
  String get legalTitle => 'നിബന്ധനകളും സ്വകാര്യതയും';

  @override
  String get legalUnavailable => 'ഇത് ഇപ്പോൾ ലോഡ് ചെയ്യാനായില്ല.';

  @override
  String get supportTitle => 'സഹായം വേണോ?';

  @override
  String get supportBody =>
      'എന്ത് സംഭവിച്ചെന്ന് പറയൂ, ഞങ്ങൾ നിങ്ങളെ ബന്ധപ്പെടും.';

  @override
  String get supportSubject => 'വിഷയം';

  @override
  String get supportMessage => 'എന്ത് സംഭവിച്ചു?';

  @override
  String get supportSend => 'അയയ്ക്കുക';

  @override
  String get supportSent => 'അയച്ചു. ഞങ്ങൾ നിങ്ങളെ ബന്ധപ്പെടും.';

  @override
  String supportEmailLine(String email) {
    return 'അല്ലെങ്കിൽ $email ലേക്ക് എഴുതുക.';
  }

  @override
  String get supportTooShort =>
      'ഒന്നോ രണ്ടോ വാക്യം എഴുതുക, എന്താണ് നോക്കേണ്ടതെന്ന് ഞങ്ങൾക്ക് മനസ്സിലാകും.';

  @override
  String get signOut => 'സൈൻ ഔട്ട്';

  @override
  String get signOutConfirm => 'ഈ ഉപകരണത്തിൽ സൈൻ ഔട്ട് ചെയ്യണോ?';

  @override
  String get aboutTitle => 'കുറിച്ച്';

  @override
  String get sessionExpiredSignIn =>
      'നിങ്ങളുടെ സെഷൻ അവസാനിച്ചു. വീണ്ടും സൈൻ ഇൻ ചെയ്യുക.';

  @override
  String get serverTookTooLong =>
      'സെർവർ മറുപടി നൽകാൻ വളരെ സമയമെടുത്തു. കണക്ഷൻ പരിശോധിച്ച് വീണ്ടും ശ്രമിക്കുക.';

  @override
  String couldNotReachServer(String host) {
    return '$host ൽ എത്താനായില്ല. നിങ്ങളുടെ ഇന്റർനെറ്റ് കണക്ഷൻ പരിശോധിക്കുക.';
  }

  @override
  String get certificateNotVerified =>
      'സെർവർ സർട്ടിഫിക്കറ്റ് പരിശോധിക്കാനായില്ല.';

  @override
  String get networkErrorTryAgain => 'നെറ്റ്‌വർക്ക് പിഴവ്. വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get footerLine => 'Gymologia Referral';

  @override
  String get footerSupport => 'support@gymologia.com';
}
