/// Where the admin console points, and what it identifies as.
///
/// Same shape as the member app's config, and deliberately so: one
/// --dart-define builds against the EC2 box, a laptop on the LAN, or an
/// emulator loopback.
///
///   flutter run --dart-define=API_BASE_URL=https://api.gymologia.com/api/v1
///   flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:3000/api/v1
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

  /// ADMIN, not MEMBER.
  ///
  /// This is the whole reason a Gymologia staff member cannot sign into
  /// this console with an ordinary account: the backend issues an OTP
  /// challenge scoped to this client and refuses at verification if the
  /// number is not on the admin staff list. A code issued to add somebody
  /// to a gym can never be redeemed for platform access, and vice versa.
  static const String appClient = 'ADMIN';
}
