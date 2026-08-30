import 'api_client.dart';
import 'models.dart';

/// Everything the two modes call, in one place.
///
/// Split by audience rather than by HTTP verb: the member-side calls need
/// no gym scope, the staff-side ones all hang off a gym id.
class GymApi {
  GymApi(this._client);

  final ApiClient _client;

  List<Map<String, dynamic>> _list(Map<String, dynamic> raw) {
    final data = raw['data'];
    if (data is List) return data.cast<Map<String, dynamic>>();
    return const [];
  }

  // ── Member side ────────────────────────────────────────────────────

  Future<List<GymListing>> searchGyms({
    String? query,
    String? state,
    String? district,
    double? latitude,
    double? longitude,
  }) async {
    final raw = await _client.get('/gyms/search', auth: false, query: {
      if (query != null && query.isNotEmpty) 'query': query,
      if (state != null && state.isNotEmpty) 'state': state,
      if (district != null && district.isNotEmpty) 'district': district,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
    });
    return _list(raw).map(GymListing.fromJson).toList();
  }

  Future<Map<String, dynamic>> publicGym(String gymId) =>
      _client.get('/gyms/$gymId/public', auth: false);

  Future<List<MyMembership>> myMemberships() async {
    final raw = await _client.get('/me/memberships');
    return _list(raw).map(MyMembership.fromJson).toList();
  }

  Future<MetricsSnapshot> myMetrics() async =>
      MetricsSnapshot.fromJson(await _client.get('/me/metrics'));

  Future<MetricsSnapshot> recordMetric({double? weightKg, double? heightCm}) async =>
      MetricsSnapshot.fromJson(await _client.post('/me/metrics', body: {
        if (weightKg != null) 'weightKg': weightKg,
        if (heightCm != null) 'heightCm': heightCm,
      }));

  Future<void> setMonitoring(String membershipId, bool allow) =>
      _client.patch('/me/memberships/$membershipId/monitoring', body: {'allow': allow});

  Future<void> requestLeave({
    required String gymId,
    required DateTime from,
    required DateTime to,
    String? reason,
  }) =>
      _client.post('/gyms/$gymId/leave/request', body: {
        'subjectType': 'MEMBER',
        'fromDate': _ymd(from),
        'toDate': _ymd(to),
        if (reason != null && reason.isNotEmpty) 'reason': reason,
      });

  // ── Staff side ─────────────────────────────────────────────────────

  Future<List<GymSummary>> myGyms() async {
    final raw = await _client.get('/gyms/mine');
    return _list(raw).map(GymSummary.fromJson).toList();
  }

  Future<GymDetail> gym(String gymId) async =>
      GymDetail.fromJson(await _client.get('/gyms/$gymId'));

  Future<GymDetail> createGym(Map<String, dynamic> body) async =>
      GymDetail.fromJson(await _client.post('/gyms', body: body));

  Future<GymDetail> updateGym(String gymId, Map<String, dynamic> body) async =>
      GymDetail.fromJson(await _client.patch('/gyms/$gymId', body: body));

  Future<List<Map<String, dynamic>>> roles(String gymId) async {
    final raw = await _client.get('/gyms/$gymId/roles');
    return _list(raw);
  }

  // Members
  Future<({List<MemberRow> items, int total})> members(
    String gymId, {
    String? query,
    String? status,
  }) async {
    final raw = await _client.get('/gyms/$gymId/members', query: {
      if (query != null && query.isNotEmpty) 'query': query,
      if (status != null) 'status': status,
    });
    final items = ((raw['items'] as List?) ?? const [])
        .cast<Map<String, dynamic>>()
        .map(MemberRow.fromJson)
        .toList();
    return (items: items, total: (raw['total'] as int?) ?? items.length);
  }

  Future<PersonLookup> lookupMember(String gymId, String phone) async =>
      PersonLookup.fromJson(
        await _client.post('/gyms/$gymId/members/lookup', body: {'phone': phone}),
      );

  Future<Map<String, dynamic>> addMember(String gymId, Map<String, dynamic> body) =>
      _client.post('/gyms/$gymId/members', body: body);

  Future<Map<String, dynamic>> member(String gymId, String membershipId) =>
      _client.get('/gyms/$gymId/members/$membershipId');

  Future<Map<String, dynamic>> memberProgress(String gymId, String membershipId) =>
      _client.get('/gyms/$gymId/members/$membershipId/progress');

  Future<Map<String, dynamic>> updateMember(
    String gymId,
    String membershipId,
    Map<String, dynamic> body,
  ) =>
      _client.patch('/gyms/$gymId/members/$membershipId', body: body);

  Future<void> removeMember(String gymId, String membershipId) =>
      _client.delete('/gyms/$gymId/members/$membershipId');

  Future<Map<String, dynamic>> extendMembership(
    String gymId,
    String membershipId,
    int months,
  ) =>
      _client.post('/gyms/$gymId/members/$membershipId/extend',
          body: {'months': months});

  // Staff
  Future<List<StaffRow>> staff(String gymId) async {
    final raw = await _client.get('/gyms/$gymId/staff');
    return _list(raw).map(StaffRow.fromJson).toList();
  }

  Future<PersonLookup> lookupStaff(String gymId, String phone) async =>
      PersonLookup.fromJson(
        await _client.post('/gyms/$gymId/staff/lookup', body: {'phone': phone}),
      );

  Future<Map<String, dynamic>> addStaff(String gymId, Map<String, dynamic> body) =>
      _client.post('/gyms/$gymId/staff', body: body);

  Future<Map<String, dynamic>> updateStaff(
    String gymId,
    String staffMemberId,
    Map<String, dynamic> body,
  ) =>
      _client.patch('/gyms/$gymId/staff/$staffMemberId', body: body);

  Future<void> removeStaff(String gymId, String staffMemberId) =>
      _client.delete('/gyms/$gymId/staff/$staffMemberId');

  Future<List<Map<String, dynamic>>> trainers(String gymId, {String? categoryId}) async {
    final raw = await _client.get('/gyms/$gymId/staff/trainers', query: {
      if (categoryId != null) 'categoryId': categoryId,
    });
    return _list(raw);
  }

  // Attendance
  Future<Map<String, dynamic>> markAttendance({
    required String gymId,
    required String subjectType,
    required String subjectId,
    String? status,
  }) =>
      _client.post('/gyms/$gymId/attendance', body: {
        'subjectType': subjectType,
        'subjectId': subjectId,
        if (status != null) 'status': status,
      });

  Future<List<Map<String, dynamic>>> attendance(
    String gymId, {
    required String subjectType,
    DateTime? from,
    DateTime? to,
  }) async {
    final raw = await _client.get('/gyms/$gymId/attendance', query: {
      'subjectType': subjectType,
      if (from != null) 'from': _ymd(from),
      if (to != null) 'to': _ymd(to),
    });
    return _list(raw);
  }

  /// One person's attendance history, for the check-attendance screen.
  Future<Map<String, dynamic>> attendanceForSubject(
    String gymId, {
    required String subjectType,
    required String userId,
    int days = 60,
  }) =>
      _client.get('/gyms/$gymId/attendance/subject/$subjectType/$userId',
          query: {'days': days});

  /// Correcting a record. The reason is mandatory server-side.
  Future<Map<String, dynamic>> editAttendance(
    String gymId,
    String recordId, {
    required String status,
    required String reason,
  }) =>
      _client.patch('/gyms/$gymId/attendance/$recordId',
          body: {'status': status, 'reason': reason});

  Future<GymAnalytics> analytics(String gymId, {int days = 30}) async =>
      GymAnalytics.fromJson(
        await _client.get('/gyms/$gymId/attendance/analytics',
            query: {'days': days}),
      );

  // Leave
  Future<List<LeaveRow>> leave(
    String gymId, {
    String subjectType = 'MEMBER',
    String? status,
  }) async {
    final raw = await _client.get('/gyms/$gymId/leave', query: {
      'subjectType': subjectType,
      if (status != null) 'status': status,
    });
    return _list(raw).map(LeaveRow.fromJson).toList();
  }

  Future<void> deleteGym(String gymId) => _client.delete('/gyms/$gymId');

  // ── Subscription ───────────────────────────────────────────────────

  Future<Map<String, dynamic>> subscription(String gymId) =>
      _client.get('/gyms/$gymId/subscription');

  Future<Map<String, dynamic>> subscriptionQuote(
    String gymId, {
    String? referralCode,
  }) =>
      _client.get('/gyms/$gymId/subscription/quote', query: {
        if (referralCode != null && referralCode.isNotEmpty)
          'referralCode': referralCode,
      });

  Future<Map<String, dynamic>> startTrial(String gymId) =>
      _client.post('/gyms/$gymId/subscription/trial');

  Future<Map<String, dynamic>> checkout(
    String gymId, {
    required String plan,
    String? referralCode,
  }) =>
      _client.post('/gyms/$gymId/subscription/checkout', body: {
        'plan': plan,
        if (referralCode != null && referralCode.isNotEmpty)
          'referralCode': referralCode,
      });

  /// Confirms with the server, which asks Cashfree directly rather than
  /// trusting whatever the payment sheet reported.
  Future<Map<String, dynamic>> verifySubscription(
    String gymId,
    String subscriptionId,
  ) =>
      _client.post('/gyms/$gymId/subscription/$subscriptionId/verify');

  // ── Events ─────────────────────────────────────────────────────────

  /// The member feed, split into events from gyms you belong to and
  /// everything listed nationally.
  Future<({List<Map<String, dynamic>> mine, List<Map<String, dynamic>> global})>
      eventsFeed({String? state, String? district}) async {
    final raw = await _client.get('/events', query: {
      if (state != null && state.isNotEmpty) 'state': state,
      if (district != null && district.isNotEmpty) 'district': district,
    });
    return (
      mine: ((raw['myGyms'] as List?) ?? const []).cast<Map<String, dynamic>>(),
      global: ((raw['global'] as List?) ?? const []).cast<Map<String, dynamic>>(),
    );
  }

  Future<Map<String, dynamic>> participate(String eventId) =>
      _client.post('/events/$eventId/participate');

  Future<Map<String, dynamic>> withdrawFromEvent(String eventId) =>
      _client.delete('/events/$eventId/participate');

  Future<List<Map<String, dynamic>>> gymEvents(String gymId) async {
    final raw = await _client.get('/gyms/$gymId/events');
    return _list(raw);
  }

  Future<Map<String, dynamic>> hostEvent(
    String gymId,
    Map<String, dynamic> body,
  ) =>
      _client.post('/gyms/$gymId/events', body: body);

  Future<Map<String, dynamic>> eventParticipants(String gymId, String eventId) =>
      _client.get('/gyms/$gymId/events/$eventId/participants');

  // ── Notifications ──────────────────────────────────────────────────

  Future<Map<String, dynamic>> notifications() =>
      _client.get('/me/notifications');

  Future<int> unreadNotifications() async {
    final raw = await _client.get('/me/notifications/unread');
    return (raw['unread'] as int?) ?? 0;
  }

  Future<void> markNotificationRead(String recipientId) =>
      _client.patch('/me/notifications/$recipientId/read');

  Future<void> markAllNotificationsRead() =>
      _client.patch('/me/notifications/read-all');

  Future<List<Map<String, dynamic>>> notificationsSentBy(String gymId) async {
    final raw = await _client.get('/gyms/$gymId/notifications');
    return _list(raw);
  }

  Future<Map<String, dynamic>> sendNotification(
    String gymId, {
    required String title,
    required String body,
    String audience = 'GYM_EVERYONE',
  }) =>
      _client.post('/gyms/$gymId/notifications', body: {
        'title': title,
        'body': body,
        'audience': audience,
      });

  Future<void> decideLeave(
    String gymId,
    String leaveId, {
    required bool approve,
    String? note,
  }) =>
      _client.post('/gyms/$gymId/leave/$leaveId/decision', body: {
        'status': approve ? 'APPROVED' : 'DECLINED',
        if (note != null && note.isNotEmpty) 'note': note,
      });
}

String _ymd(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';
