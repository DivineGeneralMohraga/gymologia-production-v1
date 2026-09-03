// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appName => 'Gymologia';

  @override
  String get languageName => 'বাংলা';

  @override
  String get settings => 'সেটিংস';

  @override
  String get language => 'ভাষা';

  @override
  String get languageSubtitle =>
      'যে ভাষায় আপনি সবচেয়ে স্বচ্ছন্দে পড়েন সেটি বেছে নিন';

  @override
  String get save => 'সংরক্ষণ';

  @override
  String get cancel => 'বাতিল';

  @override
  String get tryAgain => 'আবার চেষ্টা করুন';

  @override
  String get loading => 'লোড হচ্ছে';

  @override
  String get somethingWentWrong => 'কিছু ভুল হয়েছে';

  @override
  String get signIn => 'সাইন ইন';

  @override
  String get phoneNumber => 'মোবাইল নম্বর';

  @override
  String get enterPhoneNumber => 'আপনার মোবাইল নম্বর দিন';

  @override
  String get sendCode => 'কোড পাঠান';

  @override
  String get verifyCode => 'যাচাই করুন';

  @override
  String get enterCode => 'আমরা যে কোড পাঠিয়েছি সেটি দিন';

  @override
  String get resendCode => 'আবার পাঠান';

  @override
  String get createAccount => 'আপনার অ্যাকাউন্ট তৈরি করুন';

  @override
  String get yourName => 'আপনার নাম';

  @override
  String get emailOptional => 'ইমেল (ঐচ্ছিক)';

  @override
  String get age => 'বয়স';

  @override
  String get whyAgeNotBirthday =>
      'আমরা আপনার বয়স জানতে চাই, জন্মতারিখ নয়। জন্মতারিখ আপনার ব্যাংক ও সরকারি নথির সঙ্গে যুক্ত — জিম অ্যাপের জন্য বয়সই যথেষ্ট।';

  @override
  String get termsAgreement =>
      'অ্যাকাউন্ট তৈরি করার অর্থ আপনি ব্যবহারের শর্তাবলী ও গোপনীয়তা নীতি মেনে নিচ্ছেন।';

  @override
  String get home => 'হোম';

  @override
  String get gyms => 'জিম';

  @override
  String get events => 'ইভেন্ট';

  @override
  String get chat => 'চ্যাট';

  @override
  String get profile => 'প্রোফাইল';

  @override
  String get findAGym => 'জিম খুঁজুন';

  @override
  String get searchGyms => 'নাম বা এলাকা দিয়ে খুঁজুন';

  @override
  String get noGymsFound => 'এখানে এখনও কোনো জিম নেই';

  @override
  String get perks => 'সুবিধা';

  @override
  String get contactGym => 'এই জিমে যোগাযোগ করুন';

  @override
  String get rating => 'রেটিং';

  @override
  String get yourMembership => 'আপনার সদস্যপদ';

  @override
  String daysRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count দিন বাকি',
      one: '১ দিন বাকি',
      zero: 'আজ শেষ',
    );
    return '$_temp0';
  }

  @override
  String get yourGoal => 'আপনার লক্ষ্য';

  @override
  String get trainer => 'ট্রেনার';

  @override
  String get requestLeave => 'ছুটির আবেদন';

  @override
  String get yourProgress => 'আপনার অগ্রগতি';

  @override
  String get weight => 'ওজন';

  @override
  String get height => 'উচ্চতা';

  @override
  String get yourMeasurements => 'আপনার মাপ';

  @override
  String get addMeasurements =>
      'আপনার ওজন ও উচ্চতা দিন যাতে জিম আপনার সঙ্গে অগ্রগতি দেখতে পারে';

  @override
  String get checkInDue => 'এই মাসের চেক-ইন বাকি';

  @override
  String get thisMonth => 'এই মাসে';

  @override
  String get perWeek => 'প্রতি সপ্তাহে';

  @override
  String weeksRunning(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'টানা সপ্তাহ',
      one: 'টানা সপ্তাহ',
    );
    return '$_temp0';
  }

  @override
  String get lastEightWeeks => 'গত ৮ সপ্তাহ';

  @override
  String get exerciseDirectory => 'ব্যায়াম তালিকা';

  @override
  String get exerciseDirectorySubtitle =>
      'শক্তি, কার্ডিও ও যোগ, ধাপে ধাপে নির্দেশনা সহ';

  @override
  String get steps => 'ধাপ';

  @override
  String get attendance => 'উপস্থিতি';

  @override
  String get members => 'সদস্য';

  @override
  String get staff => 'কর্মী';

  @override
  String get leave => 'ছুটি';

  @override
  String get roles => 'ভূমিকা';

  @override
  String get analytics => 'বিশ্লেষণ';

  @override
  String get growth => 'বৃদ্ধি';

  @override
  String get ranking => 'র‍্যাঙ্কিং';

  @override
  String get plan => 'প্ল্যান';

  @override
  String get announce => 'ঘোষণা';

  @override
  String get gymProfile => 'জিম প্রোফাইল';

  @override
  String get trainers => 'ট্রেনার';

  @override
  String get present => 'উপস্থিত';

  @override
  String get absent => 'অনুপস্থিত';

  @override
  String get markAttendance => 'উপস্থিতি দিন';

  @override
  String get getHelp => 'সহায়তা নিন';

  @override
  String get getHelpSubtitle => 'আমাদের বার্তা পাঠান, আমরা যোগাযোগ করব';

  @override
  String get termsAndPrivacy => 'শর্তাবলী ও গোপনীয়তা নীতি';

  @override
  String get signOut => 'সাইন আউট';

  @override
  String get switchToStaff => 'মালিক/কর্মী মোডে যান';

  @override
  String get switchToMember => 'সদস্য মোডে যান';

  @override
  String get notifications => 'বিজ্ঞপ্তি';

  @override
  String get noNotifications => 'নতুন কিছু নেই';

  @override
  String get needsReview => 'অনুবাদ পর্যালোচনার অপেক্ষায়';
}
