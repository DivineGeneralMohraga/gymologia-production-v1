import 'package:flutter/foundation.dart';

import '../../core/api/api_client.dart';
import '../../core/api/referral_api.dart';
import '../../core/storage/token_store.dart';

enum AuthStatus { unknown, signedOut, signedIn }

/// Who is signed in.
///
/// The gym-owner exclusion is NOT decided here. This app cannot know
/// whether the person holding it owns a gym -- they might have registered
/// one an hour ago on the other app -- so it asks, and the server answers
/// with a 403 that carries a sentence written for the person reading it.
/// Guessing locally would mean two copies of the rule, and the copy in the
/// client is the one that goes stale.
class AuthController extends ChangeNotifier {
  AuthController({ApiClient? client, TokenStore? tokens})
      : _tokens = tokens ?? TokenStore(),
        client = client ?? ApiClient() {
    api = ReferralApi(this.client);
    this.client.onSessionExpired = () {
      _user = null;
      _status = AuthStatus.signedOut;
      notifyListeners();
    };
  }

  final ApiClient client;
  final TokenStore _tokens;
  late final ReferralApi api;

  Map<String, dynamic>? _user;
  AuthStatus _status = AuthStatus.unknown;

  Map<String, dynamic>? get user => _user;
  AuthStatus get status => _status;
  String get name => (_user?['name'] as String?) ?? '';
  String get phone => (_user?['phone'] as String?) ?? '';
  String? get email => _user?['email'] as String?;

  /// Pick up an existing session on launch. Without this the app shows the
  /// phone field for a moment to somebody who is already signed in.
  Future<void> restore() async {
    try {
      if (await _tokens.readAccess() != null) {
        _user = await api.me();
        _status = AuthStatus.signedIn;
      } else {
        _status = AuthStatus.signedOut;
      }
    } on ApiException {
      _status = AuthStatus.signedOut;
    }
    notifyListeners();
  }

  Future<String> requestCode(String phone) async {
    final res = await api.requestOtp(phone);
    return (res['challengeId'] as String?) ?? '';
  }

  /// Either signs in, or hands back a registration token for a number that
  /// has no account yet. Both are successes; only the caller can tell which
  /// screen comes next.
  Future<VerifyOutcome> verify({
    required String challengeId,
    required String phone,
    required String code,
  }) async {
    final res = await api.verifyOtp(
      challengeId: challengeId,
      phone: phone,
      code: code,
      deviceId: await _tokens.deviceId(),
    );

    if (res['status'] == 'NEW_USER') {
      return VerifyOutcome.newUser(res['registrationToken'] as String? ?? '');
    }
    await _adopt(res);
    return const VerifyOutcome.signedIn();
  }

  Future<void> register({
    required String registrationToken,
    required String name,
    required int age,
    String? email,
    String? locale,
  }) async {
    final res = await api.register(
      registrationToken: registrationToken,
      name: name,
      age: age,
      email: email,
      deviceId: await _tokens.deviceId(),
      locale: locale,
    );
    await _adopt(res);
  }

  Future<void> signOut() async {
    try {
      await api.logout();
    } on ApiException {
      // Ending the session on this device matters more than telling the
      // server about it. The refresh token is discarded either way, so the
      // session cannot be resumed from here.
    }
    await _tokens.clear();
    _user = null;
    _status = AuthStatus.signedOut;
    notifyListeners();
  }

  /// Keep a locally edited profile in step without a round trip.
  void updateLocalProfile({String? name, String? email}) {
    if (_user == null) return;
    if (name != null) _user!['name'] = name;
    if (email != null) _user!['email'] = email;
    notifyListeners();
  }

  Future<void> _adopt(Map<String, dynamic> res) async {
    final tokens = res['tokens'];
    if (tokens is! Map || tokens['accessToken'] == null) {
      throw ApiException('Sign-in did not return a session.');
    }
    await _tokens.saveTokens(
      accessToken: tokens['accessToken'] as String,
      refreshToken: (tokens['refreshToken'] as String?) ?? '',
    );
    _user = (res['user'] as Map?)?.cast<String, dynamic>() ?? await api.me();
    _status = AuthStatus.signedIn;
    notifyListeners();
  }
}

/// What came back from a correct code: a session, or an invitation to make
/// an account.
class VerifyOutcome {
  const VerifyOutcome.signedIn()
      : isNewUser = false,
        registrationToken = null;
  const VerifyOutcome.newUser(String token)
      : isNewUser = true,
        registrationToken = token;

  final bool isNewUser;
  final String? registrationToken;
}
