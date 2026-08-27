import '../config/app_config.dart';
import 'api_client.dart';

class OtpChallenge {
  OtpChallenge({
    required this.challengeId,
    required this.phoneMasked,
    required this.resendAfterSeconds,
  });

  factory OtpChallenge.fromJson(Map<String, dynamic> json) => OtpChallenge(
        challengeId: json['challengeId'] as String,
        phoneMasked: json['phoneMasked'] as String? ?? '',
        resendAfterSeconds: json['resendAfterSeconds'] as int? ?? 30,
      );

  final String challengeId;
  final String phoneMasked;
  final int resendAfterSeconds;
}

class AppUser {
  AppUser({
    required this.id,
    required this.phone,
    required this.name,
    this.email,
    this.age,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json['id'] as String,
        phone: json['phone'] as String,
        name: json['name'] as String,
        email: json['email'] as String?,
        age: json['age'] as int?,
      );

  final String id;
  final String phone;
  final String name;
  final String? email;
  final int? age;
}

/// What came back from verifying a code: either the number is known and we
/// have a session, or it is new and we hold a short-lived token that lets
/// the signup form prove the number was verified.
sealed class VerifyOutcome {
  const VerifyOutcome();
}

class AuthenticatedOutcome extends VerifyOutcome {
  const AuthenticatedOutcome(this.user);
  final AppUser user;
}

class NewUserOutcome extends VerifyOutcome {
  const NewUserOutcome(this.registrationToken);
  final String registrationToken;
}

/// Thin, typed wrapper over the /auth routes.
class AuthApi {
  AuthApi(this._client, this._onTokens);

  final ApiClient _client;
  final Future<void> Function(String access, String refresh) _onTokens;

  Future<OtpChallenge> requestOtp(String phone) async {
    final json = await _client.post(
      '/auth/otp/request',
      auth: false,
      body: {'phone': phone, 'appClient': AppConfig.appClient},
    );
    return OtpChallenge.fromJson(json);
  }

  Future<VerifyOutcome> verifyOtp({
    required String challengeId,
    required String phone,
    required String code,
    required String deviceId,
  }) async {
    final json = await _client.post(
      '/auth/otp/verify',
      auth: false,
      body: {
        'challengeId': challengeId,
        'phone': phone,
        'code': code,
        'appClient': AppConfig.appClient,
        'deviceId': deviceId,
      },
    );

    if (json['status'] == 'NEW_USER') {
      return NewUserOutcome(json['registrationToken'] as String);
    }

    final tokens = json['tokens'] as Map<String, dynamic>;
    await _onTokens(
      tokens['accessToken'] as String,
      tokens['refreshToken'] as String,
    );
    return AuthenticatedOutcome(
      AppUser.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Future<AppUser> register({
    required String registrationToken,
    required String name,
    required int age,
    String? email,
    required String deviceId,
  }) async {
    final json = await _client.post(
      '/auth/register',
      auth: false,
      body: {
        'registrationToken': registrationToken,
        'name': name,
        'age': age,
        if (email != null && email.isNotEmpty) 'email': email,
        'deviceId': deviceId,
      },
    );

    final tokens = json['tokens'] as Map<String, dynamic>;
    await _onTokens(
      tokens['accessToken'] as String,
      tokens['refreshToken'] as String,
    );
    return AppUser.fromJson(json['user'] as Map<String, dynamic>);
  }

  Future<AppUser> me() async {
    final json = await _client.get('/auth/me');
    return AppUser.fromJson(json);
  }

  Future<void> logout() => _client.post('/auth/logout');
}
