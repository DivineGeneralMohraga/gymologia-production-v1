/// Where the app points, and what it is allowed to do there.
///
/// The base URL is a compile-time constant supplied with --dart-define, so
/// one codebase builds against the EC2 box, a laptop on the LAN, or an
/// emulator loopback without editing a single line:
///
///   flutter run --dart-define=API_BASE_URL=http://13.232.161.2:3000/api/v1
///   flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000/api/v1
///
/// 10.0.2.2 is how the Android emulator reaches the host machine's
/// localhost; a physical device on the same wifi needs the laptop's LAN IP.
class AppConfig {
  const AppConfig._();

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://13.232.161.2:3000/api/v1',
  );

  /// Shown on the diagnostics screen so a tester can confirm at a glance
  /// which backend the build in their hand is actually talking to.
  static String get displayHost => Uri.parse(apiBaseUrl).host;

  static bool get isCleartext => Uri.parse(apiBaseUrl).scheme == 'http';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 20);

  static const String supportEmail = 'support@gymologia.com';

  /// Which client this build identifies as. The backend uses it to enforce
  /// per-app rules — the referral app rejects gym owners, for instance.
  static const String appClient = 'MEMBER';
}
