import 'package:flutter/foundation.dart';

import '../../core/api/admin_api.dart';
import '../../core/api/api_client.dart';
import '../../core/storage/token_store.dart';
import 'capabilities.dart';

/// Who is signed in, and what they may see.
///
/// The roles come from the server and are never inferred here. A screen
/// asks [can] before drawing itself, but that is a convenience for the
/// operator, not a security boundary: every one of these endpoints enforces
/// the same rule again on the server, and customer support is refused the
/// audit log there whether or not this app draws the button.
class AuthController extends ChangeNotifier {
  AuthController({ApiClient? client, TokenStore? tokens})
      : _tokens = tokens ?? TokenStore(),
        client = client ?? ApiClient() {
    api = AdminApi(this.client);
    this.client.onSessionExpired = () {
      _staff = null;
      notifyListeners();
    };
  }

  final ApiClient client;
  final TokenStore _tokens;
  late final AdminApi api;

  Map<String, dynamic>? _staff;
  bool _restoring = true;

  Map<String, dynamic>? get staff => _staff;
  bool get isSignedIn => _staff != null;
  bool get isRestoring => _restoring;

  String get name => (_staff?['name'] as String?) ?? '';
  String get role => (_staff?['role'] as String?) ?? '';

  /// The server's AdminRole values, for the staff editor's role picker.
  static const List<String> roles = adminRoles;

  /// Whether this role reaches a section.
  ///
  /// Delegated to a pure function so it can be tested without a session, a
  /// network, or secure storage. It lived here once, reading private state,
  /// and was wrong before it had ever run -- it invented an ANALYST role
  /// that does not exist and omitted KYC_AGENT that does. Nothing could
  /// have caught that except running it, and nothing could run it.
  bool can(String section) => canReach(section, role, _staff);

  /// Pick up an existing session on launch, so a refresh does not sign
  /// somebody out of a console they were working in.
  Future<void> restore() async {
    _restoring = true;
    notifyListeners();
    try {
      if (await _tokens.readAccess() != null) {
        _staff = await api.me();
      }
    } on ApiException {
      _staff = null;
    } finally {
      _restoring = false;
      notifyListeners();
    }
  }

  Future<String> requestCode(String phone) async {
    final res = await api.requestOtp(phone);
    return (res['challengeId'] as String?) ?? '';
  }

  /// Returns null on success, or a sentence to show.
  Future<String?> verify({
    required String challengeId,
    required String phone,
    required String code,
  }) async {
    final res =
        await api.verifyOtp(challengeId: challengeId, phone: phone, code: code);

    final tokens = res['tokens'];
    if (tokens is! Map || tokens['accessToken'] == null) {
      // A number that is not on the staff list gets here: the code was
      // right, and the account still is not allowed in. Saying so plainly
      // beats a blank screen.
      return 'That number is not on the Gymologia staff list.';
    }

    await _tokens.saveTokens(
      accessToken: tokens['accessToken'] as String,
      refreshToken: (tokens['refreshToken'] as String?) ?? '',
    );
    _staff = await api.me();
    notifyListeners();
    return null;
  }

  Future<void> signOut() async {
    try {
      await api.logout();
    } on ApiException {
      // Signing out locally matters more than telling the server.
    }
    await _tokens.clear();
    _staff = null;
    notifyListeners();
  }
}
