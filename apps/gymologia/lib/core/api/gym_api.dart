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

  /// Joins and departures bucketed by day, month or year. Buckets are cut on
  /// Indian local time server-side, so "August" means the owner's August.
  Future<Map<String, dynamic>> growth(
    String gymId, {
    String unit = 'month',
    int periods = 12,
  }) =>
      _client.get('/gyms/$gymId/attendance/analytics/growth',
          query: {'unit': unit, 'periods': periods});

  /// The member's own attendance. Needs no gym scope and no permission —
  /// every other attendance route is staff-facing.
  Future<List<Map<String, dynamic>>> myAttendance({int days = 90}) async {
    final raw = await _client.get('/me/attendance', query: {'days': days});
    return _list(raw);
  }

  // Roles
  Future<Map<String, dynamic>> permissionCatalogue(String gymId) =>
      _client.get('/gyms/$gymId/roles/permissions');

  Future<Map<String, dynamic>> role(String gymId, String roleId) =>
      _client.get('/gyms/$gymId/roles/$roleId');

  Future<Map<String, dynamic>> createRole(
    String gymId, {
    required String name,
    required List<String> permissions,
    int? level,
  }) =>
      _client.post('/gyms/$gymId/roles', body: {
        'name': name,
        'permissions': permissions,
        if (level != null) 'level': level,
      });

  Future<Map<String, dynamic>> updateRole(
    String gymId,
    String roleId, {
    String? name,
    List<String>? permissions,
  }) =>
      _client.patch('/gyms/$gymId/roles/$roleId', body: {
        if (name != null) 'name': name,
        if (permissions != null) 'permissions': permissions,
      });

  Future<void> deleteRole(String gymId, String roleId) =>
      _client.delete('/gyms/$gymId/roles/$roleId');

  /// Most senior first. Only custom roles junior to you may be moved.
  Future<List<Map<String, dynamic>>> reorderRoles(
    String gymId,
    List<String> roleIds,
  ) async {
    final raw = await _client
        .put('/gyms/$gymId/roles/hierarchy', body: {'roleIds': roleIds});
    final rows = raw['roles'];
    return rows is List
        ? rows.cast<Map<String, dynamic>>()
        : const <Map<String, dynamic>>[];
  }

  // Trainer categories
  Future<List<Map<String, dynamic>>> trainerCategories(String gymId) async {
    final raw = await _client.get('/gyms/$gymId/trainer-categories');
    return _list(raw);
  }

  Future<List<Map<String, dynamic>>> createTrainerCategory(
    String gymId, {
    required String name,
    required bool allowsMultipleMembers,
  }) async {
    final raw = await _client.post('/gyms/$gymId/trainer-categories', body: {
      'name': name,
      'allowsMultipleMembers': allowsMultipleMembers,
    });
    return _list(raw);
  }

  /// Returns the fresh list plus a note when narrowing a category leaves
  /// trainers holding more members than the new rule allows.
  Future<({List<Map<String, dynamic>> categories, String? note})>
      updateTrainerCategory(
    String gymId,
    String categoryId, {
    String? name,
    bool? allowsMultipleMembers,
  }) async {
    final raw = await _client.patch(
      '/gyms/$gymId/trainer-categories/$categoryId',
      body: {
        if (name != null) 'name': name,
        if (allowsMultipleMembers != null)
          'allowsMultipleMembers': allowsMultipleMembers,
      },
    );
    // This one endpoint answers with an object, not an array, so the
    // client's array-wrapping does not apply and the list is read directly.
    final categories = raw['categories'];
    return (
      categories: categories is List
          ? categories.cast<Map<String, dynamic>>()
          : const <Map<String, dynamic>>[],
      note: raw['note'] as String?,
    );
  }

  Future<List<Map<String, dynamic>>> deleteTrainerCategory(
    String gymId,
    String categoryId,
  ) async {
    final raw =
        await _client.delete('/gyms/$gymId/trainer-categories/$categoryId');
    return _list(raw);
  }

  Future<List<Map<String, dynamic>>> reorderTrainerCategories(
    String gymId,
    List<String> categoryIds,
  ) async {
    final raw = await _client.put('/gyms/$gymId/trainer-categories/order',
        body: {'categoryIds': categoryIds});
    return _list(raw);
  }

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

  /// Public server configuration, including which Cashfree environment
  /// this backend is pointed at.
  // Legal
  /// Terms and Privacy come from the server so wording can change without an
  /// app store release. Public — a store reviewer must be able to read them.
  Future<Map<String, dynamic>> legalDocument(String slug) =>
      _client.get('/legal/$slug', auth: false);

  Future<Map<String, dynamic>> legalStatus() => _client.get('/me/legal');

  Future<Map<String, dynamic>> acceptLegal() =>
      _client.post('/me/legal/accept');

  Future<Map<String, dynamic>> serverConfig() =>
      _client.get('/auth/config', auth: false);

  // ── Chat ───────────────────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> conversations(String gymId) async {
    final raw = await _client.get('/gyms/$gymId/chat/conversations');
    return _list(raw);
  }

  /// Everyone at the gym, each carrying whether you may message them.
  Future<List<Map<String, dynamic>>> chatDirectory(String gymId) async {
    final raw = await _client.get('/gyms/$gymId/chat/directory');
    return _list(raw);
  }

  Future<Map<String, dynamic>> openDirect(String gymId, String userId) =>
      _client.post('/gyms/$gymId/chat/direct', body: {'userId': userId});

  Future<Map<String, dynamic>> createGroup(
    String gymId, {
    required String name,
    required List<String> userIds,
  }) =>
      _client.post('/gyms/$gymId/chat/groups',
          body: {'name': name, 'userIds': userIds});

  Future<List<Map<String, dynamic>>> messages(
    String gymId,
    String conversationId,
  ) async {
    final raw = await _client
        .get('/gyms/$gymId/chat/conversations/$conversationId/messages');
    return _list(raw);
  }

  Future<Map<String, dynamic>> sendMessage(
    String gymId,
    String conversationId,
    String body,
  ) =>
      _client.post('/gyms/$gymId/chat/conversations/$conversationId/messages',
          body: {'body': body});

  // ── Profile and support ────────────────────────────────────────────

  Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? email,
    int? age,
  }) =>
      _client.patch('/me/profile', body: {
        if (name != null) 'name': name,
        // Sent even when empty: that is how the server is told to clear it.
        if (email != null) 'email': email,
        if (age != null) 'age': age,
      });

  Future<Map<String, dynamic>> createTicket({
    required String subject,
    required String message,
    required String contactPhone,
    bool urgent = false,
  }) =>
      _client.post('/me/support', body: {
        'subject': subject,
        'message': message,
        'contactPhone': contactPhone,
        'urgent': urgent,
      });

  Future<List<Map<String, dynamic>>> myTickets() async {
    final raw = await _client.get('/me/support');
    return _list(raw);
  }

  // ── Exercise directory ─────────────────────────────────────────────

  /// Reference content, so these are readable without a session.
  Future<List<Map<String, dynamic>>> exercises({
    String? goal,
    String? muscle,
    String? discipline,
    String? query,
  }) async {
    final raw = await _client.get('/exercises', auth: false, query: {
      if (goal != null) 'goal': goal,
      if (muscle != null) 'muscle': muscle,
      if (discipline != null) 'discipline': discipline,
      if (query != null && query.isNotEmpty) 'query': query,
    });
    return _list(raw);
  }

  Future<Map<String, dynamic>> exerciseFilters() =>
      _client.get('/exercises/filters', auth: false);

  Future<Map<String, dynamic>> exercise(String slug) =>
      _client.get('/exercises/$slug', auth: false);

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
