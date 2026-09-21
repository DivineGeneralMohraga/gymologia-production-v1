import 'package:flutter/foundation.dart';
import '../../core/api/api_client.dart';
import '../../core/api/auth_api.dart';
import '../../core/storage/token_store.dart';

enum AuthStatus { unknown, signedOut, signedIn }

/// Owns the session for the whole app.
///
/// `unknown` is the startup state, held while a stored token is checked
/// against the server, so the app does not flash the login screen at
/// someone who is already signed in.
class AuthController extends ChangeNotifier {
  AuthController({ApiClient? client, TokenStore? store})
      : _store = store ?? TokenStore() {
    _client = client ?? ApiClient(tokenStore: _store);
    _client.onSessionExpired = _handleExpiry;
    _api = AuthApi(_client, _store.saveTokens.let());
  }

  late final ApiClient _client;
  late final AuthApi _api;
  final TokenStore _store;

  AuthStatus _status = AuthStatus.unknown;
  AppUser? _user;
  String? _error;
  bool _busy = false;

  AuthStatus get status => _status;
  AppUser? get user => _user;
  String? get error => _error;
  bool get busy => _busy;
  ApiClient get client => _client;

  /// Called once at startup. A stored token is only trusted after the
  /// server confirms it — the alternative is a home screen that renders
  /// and then throws 401s at every widget on it.
  Future<void> restoreSession() async {
    final token = await _store.readAccess();
    if (token == null) {
      _set(status: AuthStatus.signedOut);
      return;
    }
    try {
      _user = await _api.me();
      _set(status: AuthStatus.signedIn);
    } on ApiException {
      await _store.clear();
      _set(status: AuthStatus.signedOut);
    }
  }

  Future<OtpChallenge?> requestOtp(String phone) =>
      _guard(() => _api.requestOtp(phone));

  Future<VerifyOutcome?> verifyOtp({
    required String challengeId,
    required String phone,
    required String code,
  }) =>
      _guard(() async {
        final deviceId = await _store.deviceId();
        final outcome = await _api.verifyOtp(
          challengeId: challengeId,
          phone: phone,
          code: code,
          deviceId: deviceId,
        );
        if (outcome is AuthenticatedOutcome) {
          _user = outcome.user;
          _status = AuthStatus.signedIn;
        }
        return outcome;
      });

  Future<bool> register({
    required String registrationToken,
    required String name,
    required int age,
    String? email,
    String? guardianConsentToken,
  }) async {
    final result = await _guard(() async {
      final deviceId = await _store.deviceId();
      return _api.register(
        registrationToken: registrationToken,
        name: name,
        age: age,
        email: email,
        deviceId: deviceId,
        guardianConsentToken: guardianConsentToken,
      );
    });
    if (result == null) return false;
    _user = result;
    _set(status: AuthStatus.signedIn);
    return true;
  }

  /// Re-reads the signed-in user from the server. Called after a profile
  /// edit so the rest of the app sees the canonical version rather than
  /// whatever the form happened to send.
  Future<void> refreshUser() async {
    try {
      _user = await _api.me();
      notifyListeners();
    } on ApiException {
      // The edit still succeeded; the local copy just stays stale until
      // the next launch.
    }
  }

  Future<void> signOut() async {
    try {
      await _api.logout();
    } on ApiException {
      // Signing out locally matters more than telling the server about it.
    }
    await _store.clear();
    _user = null;
    _set(status: AuthStatus.signedOut);
  }

  void clearError() {
    if (_error == null) return;
    _error = null;
    notifyListeners();
  }

  void _handleExpiry() {
    _user = null;
    _set(status: AuthStatus.signedOut);
  }

  /// Runs a call with the busy flag and error capture every screen expects.
  Future<T?> _guard<T>(Future<T> Function() action) async {
    _busy = true;
    _error = null;
    notifyListeners();
    try {
      return await action();
    } on ApiException catch (e) {
      _error = e.reference == null
          ? e.message
          : '${e.message}\n\nReference: ${e.reference}';
      return null;
    } finally {
      _busy = false;
      notifyListeners();
    }
  }

  void _set({required AuthStatus status}) {
    _status = status;
    notifyListeners();
  }
}

extension _SaveTokensAdapter on Future<void> Function({
  required String accessToken,
  required String refreshToken,
}) {
  /// Adapts TokenStore.saveTokens (named args) to the positional callback
  /// AuthApi expects.
  Future<void> Function(String, String) let() =>
      (access, refresh) => this(accessToken: access, refreshToken: refresh);
}
