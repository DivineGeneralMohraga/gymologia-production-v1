/// Where the referral app points, and what it identifies as.
///
/// Same shape as the other two apps, and deliberately so: one --dart-define
/// builds against the EC2 box, a laptop on the LAN, or an emulator
/// loopback.
///
///   flutter run --dart-define=API_BASE_URL=https://api.gymologia.com/api/v1
///   flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000/api/v1
///
/// 10.0.2.2 is how the Android emulator reaches the host machine's
/// localhost; a physical device on the same wifi needs the laptop's LAN IP.
class AppConfig {
  const AppConfig._();

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.gymologia.com/api/v1',
  );

  static String get displayHost => Uri.parse(apiBaseUrl).host;

  static bool get isCleartext => Uri.parse(apiBaseUrl).scheme == 'http';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 20);

  static const String supportEmail = 'support@gymologia.com';

  /// REFERRAL, not MEMBER.
  ///
  /// This is not cosmetic and it is not only for analytics. The backend
  /// enforces one rule against this value that it enforces against no
  /// other: a person who owns a gym on Gymologia is refused at sign-in.
  /// The spec excludes owners from the referral programme and admits their
  /// staff, and this constant is what makes the API able to tell which app
  /// is asking.
  ///
  /// The check is repeated on every referral endpoint rather than trusted
  /// from login alone, because somebody can register a gym after signing
  /// in here.
  static const String appClient = 'REFERRAL';

  /// What one referral is worth, in paise, and what the ₹10 verification
  /// drop costs.
  ///
  /// Shown on the "how it works" card. These are the server's numbers and
  /// the server is the one that applies them -- these two constants are
  /// for explaining the deal, never for computing a balance. Every rupee
  /// figure on a screen comes from the API.
  static const int rewardPaise = 5000;
  static const int verificationFeePaise = 1000;
  static const int discountPercent = 10;
}
