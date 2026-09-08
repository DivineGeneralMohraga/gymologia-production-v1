import '../config/app_config.dart';
import 'api_client.dart';

/// Every call the console makes.
///
/// One class rather than one per screen: the admin surface is small and
/// entirely flat, and splitting nineteen endpoints across six files would
/// hide how small it is.
///
/// Everything here is already built and tested on the server — 51 checks in
/// admin-e2e and kyc-review-e2e. Nothing in this file is new API surface;
/// it is the client that was missing.
class AdminApi {
  AdminApi(this._client);

  final ApiClient _client;

  // ── Session ────────────────────────────────────────────────────────

  /// Ask for a code. `appClient: ADMIN` is what scopes the challenge, so a
  /// code issued here cannot be redeemed as a gym signup and vice versa.
  Future<Map<String, dynamic>> requestOtp(String phone) => _client.post(
        '/auth/otp/request',
        body: {'phone': phone, 'appClient': AppConfig.appClient},
        auth: false,
      );

  Future<Map<String, dynamic>> verifyOtp({
    required String challengeId,
    required String phone,
    required String code,
  }) =>
      _client.post(
        '/auth/otp/verify',
        body: {
          'challengeId': challengeId,
          'phone': phone,
          'code': code,
          'appClient': AppConfig.appClient,
        },
        auth: false,
      );

  Future<Map<String, dynamic>> me() => _client.get('/admin/me');

  Future<void> logout() async {
    await _client.post('/auth/logout');
  }

  // ── Dashboard ──────────────────────────────────────────────────────

  Future<Map<String, dynamic>> dashboard() => _client.get('/admin/dashboard');

  // ── Verification desk ──────────────────────────────────────────────

  /// One page of the verification queue, and how many are waiting overall.
  ///
  /// The total is returned rather than dropped because the screen has to be
  /// able to say "25 of 27". The first version of this threw it away and
  /// returned only the rows, so a reviewer with a backlog longer than one
  /// page could not tell there was one, let alone reach it.
  Future<({List<dynamic> items, int total})> kycQueue({
    int take = 25,
    int skip = 0,
  }) async {
    final res = await _client.get('/admin/kyc', query: {
      'take': take,
      'skip': skip,
    });
    return (
      items: _list(res),
      total: (res['total'] as num?)?.toInt() ?? 0,
    );
  }

  Future<Map<String, dynamic>> kycDetail(String gymId) =>
      _client.get('/admin/kyc/$gymId');

  Future<Map<String, dynamic>> kycDecide({
    required String gymId,
    required bool approve,
    String? reason,
  }) =>
      _client.post('/admin/kyc/$gymId/decision', body: {
        'decision': approve ? 'APPROVE' : 'REJECT',
        if (reason != null && reason.isNotEmpty) 'reason': reason,
      });

  // ── Support ────────────────────────────────────────────────────────

  Future<List<dynamic>> tickets({String? status}) async {
    final res = await _client.get('/admin/tickets', query: {
      'status': ?status,
    });
    return _list(res);
  }

  Future<Map<String, dynamic>> claimTicket(String id) =>
      _client.post('/admin/tickets/$id/claim');

  Future<Map<String, dynamic>> resolveTicket(String id, String note) =>
      _client.post('/admin/tickets/$id/resolve', body: {'note': note});

  // ── Announcements ──────────────────────────────────────────────────

  /// How many people an audience reaches, asked BEFORE the send. The server
  /// refuses the send if the real number no longer matches this one.
  Future<int> audienceSize(String audience) async {
    final res = await _client.get('/admin/broadcast/audience',
        query: {'audience': audience});
    return (res['recipients'] as num?)?.toInt() ?? 0;
  }

  Future<List<dynamic>> broadcastHistory() async {
    final res = await _client.get('/admin/broadcast');
    return _list(res);
  }

  Future<Map<String, dynamic>> broadcast({
    required String title,
    required String body,
    required String audience,
    required int expectedRecipients,
  }) =>
      _client.post('/admin/broadcast', body: {
        'title': title,
        'body': body,
        'audience': audience,
        'expectedRecipients': expectedRecipients,
      });

  // ── Internal staff ─────────────────────────────────────────────────

  Future<List<dynamic>> staff() async => _list(await _client.get('/admin/staff'));

  Future<Map<String, dynamic>> staffLookup(String phone) =>
      _client.post('/admin/staff/lookup', body: {'phone': phone});

  Future<Map<String, dynamic>> addStaff({
    required String challengeId,
    required String phone,
    required String code,
    required String name,
    required String role,
    String? email,
  }) =>
      _client.post('/admin/staff', body: {
        'challengeId': challengeId,
        'phone': phone,
        'code': code,
        'name': name,
        'role': role,
        if (email != null && email.isNotEmpty) 'email': email,
      });

  Future<Map<String, dynamic>> updateStaff(
    String staffId, {
    String? role,
    bool? isActive,
  }) =>
      _client.patch('/admin/staff/$staffId', body: {
        'role': ?role,
        'isActive': ?isActive,
      });

  // ── Logs ───────────────────────────────────────────────────────────

  Future<List<dynamic>> auditLog({int take = 50, int offset = 0}) async {
    final res = await _client
        .get('/admin/logs/audit', query: {'take': take, 'offset': offset});
    return _list(res);
  }

  Future<List<dynamic>> securityLog({int take = 50, int offset = 0}) async {
    final res = await _client
        .get('/admin/logs/security', query: {'take': take, 'offset': offset});
    return _list(res);
  }

  // ── Payouts ────────────────────────────────────────────────────────

  /// Withdrawals waiting to be sent, and whether anything can be.
  ///
  /// The whole map, not just the rows: `blockedReason` is the difference
  /// between "nobody has withdrawn" and "everybody has, and none of it can
  /// move", and a screen that dropped it would show the same empty-looking
  /// queue for both.
  Future<Map<String, dynamic>> payoutQueue() => _client.get('/admin/payouts');

  Future<Map<String, dynamic>> runPayout(String payoutId) =>
      _client.post('/admin/payouts/$payoutId/run');

  // ── Blocked addresses ──────────────────────────────────────────────

  Future<List<dynamic>> blocks() async =>
      _list(await _client.get('/admin/security/blocks'));

  Future<void> unblock(String ip) async {
    await _client.delete('/admin/security/blocks/$ip');
  }

  /// The client hands back a map; a list endpoint arrives under `data`.
  ///
  /// Written once here rather than at eight call sites, because the shape
  /// is a property of the transport and not of any particular screen.
  List<dynamic> _list(Map<String, dynamic> res) {
    final data = res['data'];
    if (data is List) return data;
    if (res['items'] is List) return res['items'] as List;
    return const [];
  }
}
