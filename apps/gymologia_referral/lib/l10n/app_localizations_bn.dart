// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'Gymologia Referral';

  @override
  String get tryAgain => 'আবার চেষ্টা করুন';

  @override
  String get cancel => 'বাতিল';

  @override
  String get save => 'সেভ করুন';

  @override
  String get add => 'যোগ করুন';

  @override
  String get change => 'পরিবর্তন করুন';

  @override
  String get genericError => 'কিছু একটা সমস্যা হয়েছে। আবার চেষ্টা করুন।';

  @override
  String cleartextWarning(String host) {
    return '$host-এর সঙ্গে সুরক্ষা ছাড়াই (plain http) যুক্ত';
  }

  @override
  String get signInSubtitle =>
      'কোড শেয়ার করুন। কোনো জিম সাবস্ক্রিপশন নিলে আপনি আয় করবেন।';

  @override
  String get phoneLabel => 'মোবাইল নম্বর';

  @override
  String get phoneHint => '১০ সংখ্যার মোবাইল নম্বর';

  @override
  String get sendCode => 'কোড পাঠান';

  @override
  String codeSentTo(String phone) {
    return '$phone-এ কোড পাঠানো হয়েছে';
  }

  @override
  String get verify => 'যাচাই করুন';

  @override
  String resendIn(int seconds) {
    return '$seconds সেকেন্ড পরে আরেকটি কোড চাইতে পারবেন';
  }

  @override
  String get resend => 'আরেকটি কোড পাঠান';

  @override
  String get changeNumber => 'অন্য নম্বর ব্যবহার করুন';

  @override
  String get enterTenDigits => 'আপনার ১০ সংখ্যার মোবাইল নম্বর দিন।';

  @override
  String get enterTheCode => 'আমরা যে কোড পাঠিয়েছি সেটি দিন।';

  @override
  String get ownersCannotJoin =>
      'জিমের মালিকরা রেফারেল অ্যাপ ব্যবহার করতে পারেন না। জিমের কর্মী ও বাকি সবাই পারেন।';

  @override
  String get createAccountTitle => 'আপনার অ্যাকাউন্ট তৈরি করুন';

  @override
  String get nameLabel => 'নাম';

  @override
  String get emailLabel => 'ইমেল (ঐচ্ছিক)';

  @override
  String get ageLabel => 'বয়স';

  @override
  String get ageWhy =>
      'আমরা শুধু বয়স জিজ্ঞাসা করি, জন্মতারিখ কখনও নয়। জন্মতারিখ আপনার ব্যাঙ্ক ও সরকারি নথির চাবি; বয়স নয়।';

  @override
  String get ageRange => '১৩ থেকে ১০০-এর মধ্যে বয়স দিন।';

  @override
  String get nameRequired => 'অনুগ্রহ করে আপনার নাম দিন।';

  @override
  String get createAccount => 'অ্যাকাউন্ট তৈরি করুন';

  @override
  String get tabCode => 'আপনার কোড';

  @override
  String get tabEarnings => 'আয়';

  @override
  String get tabPayout => 'পেমেন্ট';

  @override
  String get tabSettings => 'সেটিংস';

  @override
  String get yourCodeTitle => 'আপনার রেফারেল কোড';

  @override
  String get shareCode => 'শেয়ার করুন';

  @override
  String get copyCode => 'কপি করুন';

  @override
  String get copied => 'কপি হয়েছে।';

  @override
  String get shareUnavailable =>
      'এখানে শেয়ার করা যাচ্ছে না। বার্তাটি কপি করে দেওয়া হয়েছে।';

  @override
  String get howItWorksTitle => 'এটি যেভাবে কাজ করে';

  @override
  String get howItWorksStep1 => 'যিনি জিম চালান তাঁকে আপনার কোড পাঠান।';

  @override
  String howItWorksStep2(int percent) {
    return 'সাবস্ক্রিপশন নেওয়ার সময় তিনি যেকোনো Gymologia প্ল্যানে $percent% ছাড় পাবেন।';
  }

  @override
  String howItWorksStep3(String amount) {
    return 'এই কোড দিয়ে সাবস্ক্রিপশন নেওয়া প্রতিটি জিমের জন্য আপনি $amount পাবেন।';
  }

  @override
  String howItWorksStep4(String amount) {
    return 'আপনার UPI ID সত্যিই আপনার কি না তা যাচাই করতে প্রথম পেমেন্ট থেকে একবার $amount কেটে নেওয়া হয়।';
  }

  @override
  String get notForOwners => 'নিজের জিম থেকে আপনি আয় করতে পারবেন না।';

  @override
  String get earnedTotal => 'এ পর্যন্ত আয়';

  @override
  String get heldPending => 'আটকে রাখা';

  @override
  String get paidOut => 'পরিশোধ করা হয়েছে';

  @override
  String get taxWithheld => 'কেটে নেওয়া কর';

  @override
  String get neverUsed => 'এখনও কেউ আপনার কোড ব্যবহার করেননি।';

  @override
  String timesUsed(int count) {
    return '$count বার ব্যবহৃত হয়েছে।';
  }

  @override
  String get usedOnce => 'একবার ব্যবহৃত হয়েছে।';

  @override
  String awaitingClearance(int count) {
    return '$countটি এখনও ক্লিয়ার হচ্ছে।';
  }

  @override
  String get earningsTitle => 'আপনার কোড যা আয় করেছে';

  @override
  String get earningsEmpty =>
      'এখনও কিছু নয়। যিনি জিম চালান তাঁর সঙ্গে আপনার কোড শেয়ার করুন।';

  @override
  String earningsCapped(int count) {
    return 'সবচেয়ে সাম্প্রতিক $countটি দেখানো হচ্ছে।';
  }

  @override
  String get statusPending => 'ক্লিয়ার হচ্ছে';

  @override
  String get statusEligible => 'পেমেন্টের জন্য প্রস্তুত';

  @override
  String get statusPaid => 'পরিশোধিত';

  @override
  String get statusReversed => 'ফেরত নেওয়া হয়েছে';

  @override
  String get statusPendingWhy =>
      'জিমের রিফান্ডের সময়সীমা শেষ না হওয়া পর্যন্ত আটকে রাখা হয়েছে।';

  @override
  String get statusEligibleWhy =>
      'ক্লিয়ার হয়েছে। পেমেন্ট চালু হওয়ার অপেক্ষায়।';

  @override
  String get statusPaidWhy => 'আপনার UPI ID-তে পাঠানো হয়েছে।';

  @override
  String get statusReversedWhy =>
      'জিমের পেমেন্ট ফেরত গেছে, তাই এই পুরস্কারও ফিরিয়ে নেওয়া হয়েছে।';

  @override
  String get payoutTitle => 'আপনার টাকা কোথায় যাবে';

  @override
  String get withdrawTitle => 'টাকা তুলুন';

  @override
  String get withdrawAvailable => 'তোলার জন্য প্রস্তুত';

  @override
  String get withdrawFee => 'একবারের UPI যাচাই';

  @override
  String get withdrawArrives => 'আপনি পাবেন';

  @override
  String withdrawButton(String amount) {
    return '$amount তুলুন';
  }

  @override
  String withdrawConfirm(String amount, String upi) {
    return '$upi-এ $amount পাঠাবেন?';
  }

  @override
  String get withdrawConfirmBody =>
      'এটি ফেরানো যাবে না। পাঠানোর আগে ঠিকানাটি ভাল করে দেখে নিন।';

  @override
  String get withdrawRequested => 'অনুরোধ করা হয়েছে। টাকা পথে আছে।';

  @override
  String withdrawFeeWhy(String amount) {
    return 'ঠিকানাটি সত্যিই আপনার কি না তা যাচাই করতে একবার $amount কেটে নেওয়া হয়। এরপর আর কিছু কাটা হয় না।';
  }

  @override
  String get withdrawNoTax => 'এই পরিমাণে কোনো কর কাটা হয় না।';

  @override
  String get withdrawHistoryTitle => 'উত্তোলন';

  @override
  String get withdrawNone => 'আপনি এখনও কিছু তোলেননি।';

  @override
  String get withdrawStatusQueued => 'সারিতে';

  @override
  String get withdrawStatusProcessing => 'পাঠানো হচ্ছে';

  @override
  String get withdrawStatusSuccess => 'পাঠানো হয়েছে';

  @override
  String get withdrawStatusFailed => 'ব্যর্থ';

  @override
  String get withdrawStatusReversed => 'ফেরত এসেছে';

  @override
  String withdrawUtr(String utr) {
    return 'রেফারেন্স $utr';
  }

  @override
  String get payoutsNotLive =>
      'পেমেন্ট এখনও চালু হয়নি। ততক্ষণ পর্যন্ত আয় গোনা হচ্ছে এবং আটকে রাখা হচ্ছে।';

  @override
  String get stillNeededTitle => 'এখনও প্রয়োজন';

  @override
  String get payoutInFlight =>
      'একটি পেমেন্ট পথে আছে। সেটি নিষ্পত্তি হলে এগুলি বদলানো যাবে।';

  @override
  String get upiSectionTitle => 'UPI ID';

  @override
  String get upiIdLabel => 'UPI ID';

  @override
  String get upiIdHint => 'name@bank';

  @override
  String get holderNameLabel => 'অ্যাকাউন্টে লেখা নাম';

  @override
  String get upiNotSet => 'সেট করা নেই';

  @override
  String get upiVerifiedYes => 'যাচাই হয়েছে';

  @override
  String get upiVerifiedNo => 'এখনও যাচাই হয়নি';

  @override
  String get upiTypoWarning =>
      'এটি অক্ষর ধরে ধরে দেখে নিন। UPI ID-তে কোনো বানান পরীক্ষা হয় না: এক অক্ষরের ভুল অন্য কারও একেবারে বৈধ ঠিকানা হয়ে যায়, আর সেখানে পাঠানো টাকা আর ফেরত আসে না।';

  @override
  String get upiChangedClearsVerification =>
      'এটি বদলালে যাচাই মুছে যায়। প্রথম পেমেন্টের আগে ঠিকানাটি আবার যাচাই করা হবে।';

  @override
  String get holderNameWhy =>
      '₹10-এর যাচাইয়ে আপনার ব্যাঙ্কে ওই অ্যাকাউন্টের জন্য নথিভুক্ত নাম ফিরে আসে। মেলানোর জন্য নাম না থাকলে যাচাই শুধু প্রমাণ করে ঠিকানাটি আছে — এটি যে আপনার, তা নয়।';

  @override
  String get saved => 'সেভ হয়েছে।';

  @override
  String get invalidUpi =>
      'এটি UPI ID-র মতো দেখাচ্ছে না। এটি name@bank-এর মতো হওয়া উচিত।';

  @override
  String get holderNameRequired => 'ব্যাঙ্ক অ্যাকাউন্টে লেখা নাম দিন।';

  @override
  String get panSectionTitle => 'PAN';

  @override
  String get panLabel => 'PAN';

  @override
  String get panHint => 'ABCDE1234F';

  @override
  String get panNotSet => 'সেট করা নেই';

  @override
  String get panWhy =>
      'আপনার আয় যেখানে কর কাটা বাধ্যতামূলক হয়ে ওঠে, তার আগে এটি লাগবে। শুরু করার জন্য দরকার নেই।';

  @override
  String get panStatusPending => 'পাওয়া গেছে, এখনও যাচাই হয়নি';

  @override
  String get panStatusVerified => 'যাচাই হয়েছে';

  @override
  String get panStatusRejected => 'গৃহীত হয়নি। নম্বরটি দেখে আবার পাঠান।';

  @override
  String get invalidPan =>
      'এটি PAN-এর মতো দেখাচ্ছে না। এটি ABCDE1234F-এর মতো হওয়া উচিত।';

  @override
  String get settingsTitle => 'সেটিংস';

  @override
  String get profileTitle => 'আপনার প্রোফাইল';

  @override
  String get languageTitle => 'ভাষা';

  @override
  String get languageSubtitle =>
      'যে ভাষা আপনি সবচেয়ে স্বচ্ছন্দে পড়েন সেটি বেছে নিন';

  @override
  String get useDeviceLanguage => 'ডিভাইসের ভাষা ব্যবহার করুন';

  @override
  String get needsReview => 'অনুবাদ পর্যালোচনার অপেক্ষায়';

  @override
  String get untranslatedFallbackNote =>
      'যা এখনও অনুবাদ হয়নি তা ফাঁকা না রেখে ইংরেজিতে দেখানো হয়, যাতে আংশিক অনুবাদ হওয়া ভাষাও ব্যবহারযোগ্য থাকে।';

  @override
  String get legalTitle => 'শর্তাবলি ও গোপনীয়তা';

  @override
  String get legalUnavailable => 'এই মুহূর্তে এটি লোড করা যায়নি।';

  @override
  String get supportTitle => 'সাহায্য দরকার?';

  @override
  String get supportBody =>
      'কী হয়েছে আমাদের জানান, আমরা আপনার সঙ্গে যোগাযোগ করব।';

  @override
  String get supportSubject => 'বিষয়';

  @override
  String get supportMessage => 'কী হয়েছে?';

  @override
  String get supportSend => 'পাঠান';

  @override
  String get supportSent => 'পাঠানো হয়েছে। আমরা আপনার সঙ্গে যোগাযোগ করব।';

  @override
  String supportEmailLine(String email) {
    return 'অথবা $email-এ লিখুন।';
  }

  @override
  String get supportTooShort =>
      'এক-দুই বাক্য লিখুন, যাতে আমরা বুঝতে পারি কী দেখতে হবে।';

  @override
  String get signOut => 'সাইন আউট';

  @override
  String get signOutConfirm => 'এই ডিভাইসে সাইন আউট করবেন?';

  @override
  String get aboutTitle => 'সম্পর্কে';

  @override
  String get sessionExpiredSignIn =>
      'আপনার সেশন শেষ হয়েছে। আবার সাইন ইন করুন।';

  @override
  String get serverTookTooLong =>
      'সার্ভার উত্তর দিতে অনেক সময় নিয়েছে। সংযোগ দেখে আবার চেষ্টা করুন।';

  @override
  String couldNotReachServer(String host) {
    return '$host-এ পৌঁছানো যায়নি। আপনার ইন্টারনেট সংযোগ দেখুন।';
  }

  @override
  String get certificateNotVerified =>
      'সার্ভারের সার্টিফিকেট যাচাই করা যায়নি।';

  @override
  String get networkErrorTryAgain => 'নেটওয়ার্ক সমস্যা। আবার চেষ্টা করুন।';

  @override
  String get footerLine => 'Gymologia Referral';

  @override
  String get footerSupport => 'support@gymologia.com';
}
