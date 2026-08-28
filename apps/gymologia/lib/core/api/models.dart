// Wire types for the CRM and member endpoints.
//
// Deliberately hand-written rather than generated: the API returns a
// shaped view per screen, not raw tables, so these mirror what a screen
// actually needs. Every parser tolerates a missing field, because a
// backend deploy should never crash the app in someone's hand.

int _int(dynamic v, [int fallback = 0]) =>
    v is int ? v : (v is num ? v.toInt() : fallback);

double _double(dynamic v, [double fallback = 0]) =>
    v is num ? v.toDouble() : fallback;

DateTime? _date(dynamic v) =>
    v is String && v.isNotEmpty ? DateTime.tryParse(v) : null;

/// A gym as it appears in the staff app's gym list.
class GymSummary {
  GymSummary({
    required this.id,
    required this.name,
    required this.displayName,
    required this.district,
    required this.status,
    required this.memberCount,
    required this.staffCount,
    required this.rating,
    required this.ratingCount,
    required this.isOwner,
    this.imageUrl,
    this.plan,
    this.myRoleName,
  });

  factory GymSummary.fromJson(Map<String, dynamic> j) => GymSummary(
        id: j['id'] as String,
        name: j['name'] as String? ?? '',
        displayName: j['displayName'] as String? ?? j['name'] as String? ?? '',
        district: j['district'] as String? ?? '',
        status: j['status'] as String? ?? 'DRAFT',
        memberCount: _int(j['memberCount']),
        staffCount: _int(j['staffCount']),
        rating: _double(j['rating']),
        ratingCount: _int(j['ratingCount']),
        isOwner: j['isOwner'] == true,
        imageUrl: j['imageUrl'] as String?,
        plan: j['plan'] as String?,
        myRoleName: (j['myRole'] as Map<String, dynamic>?)?['name'] as String?,
      );

  final String id;
  final String name;
  final String displayName;
  final String district;
  final String status;
  final int memberCount;
  final int staffCount;
  final double rating;
  final int ratingCount;
  final bool isOwner;
  final String? imageUrl;
  final String? plan;
  final String? myRoleName;

  bool get isDraft => status == 'DRAFT';
}

/// A gym plus the caller's permissions within it.
class GymDetail {
  GymDetail({
    required this.id,
    required this.name,
    required this.displayName,
    required this.district,
    required this.status,
    required this.memberCount,
    required this.staffCount,
    required this.permissions,
    required this.visibleScreens,
    required this.isGymOwner,
    required this.roleName,
    required this.maxLeaveDaysPerMonth,
    this.description,
    this.plan,
    this.contactPhone,
    this.perks = const [],
    this.images = const [],
  });

  factory GymDetail.fromJson(Map<String, dynamic> j) {
    final access = (j['access'] as Map<String, dynamic>?) ?? const {};
    final plan = j['plan'] as Map<String, dynamic>?;
    return GymDetail(
      id: j['id'] as String,
      name: j['name'] as String? ?? '',
      displayName: j['displayName'] as String? ?? '',
      district: j['district'] as String? ?? '',
      status: j['status'] as String? ?? 'DRAFT',
      description: j['description'] as String?,
      memberCount: _int(j['memberCount']),
      staffCount: _int(j['staffCount']),
      contactPhone: j['contactPhone'] as String?,
      maxLeaveDaysPerMonth: _int(j['maxLeaveDaysPerMonth'], 4),
      perks: ((j['perks'] as List?) ?? const []).map((e) => '$e').toList(),
      images: ((j['images'] as List?) ?? const []).map((e) => '$e').toList(),
      plan: plan?['plan'] as String?,
      permissions:
          ((access['permissions'] as List?) ?? const []).map((e) => '$e').toSet(),
      visibleScreens:
          ((access['visibleScreens'] as List?) ?? const []).map((e) => '$e').toSet(),
      isGymOwner: access['isGymOwner'] == true,
      roleName: (access['role'] as Map<String, dynamic>?)?['name'] as String? ?? '',
    );
  }

  final String id;
  final String name;
  final String displayName;
  final String district;
  final String status;
  final String? description;
  final int memberCount;
  final int staffCount;
  final String? contactPhone;
  final int maxLeaveDaysPerMonth;
  final List<String> perks;
  final List<String> images;
  final String? plan;
  final bool isGymOwner;
  final String roleName;

  /// The permission names this user holds here. The UI hides what is not
  /// in this set; the server re-checks every action regardless.
  final Set<String> permissions;
  final Set<String> visibleScreens;

  bool can(String permission) => permissions.contains(permission);
  bool sees(String screen) => visibleScreens.contains(screen);
}

/// A listed gym in the member-side browser.
class GymListing {
  GymListing({
    required this.id,
    required this.displayName,
    required this.district,
    required this.rating,
    required this.ratingCount,
    required this.perkCount,
    this.imageUrl,
    this.distanceKm,
  });

  factory GymListing.fromJson(Map<String, dynamic> j) => GymListing(
        id: j['id'] as String,
        displayName: j['displayName'] as String? ?? '',
        district: j['district'] as String? ?? '',
        rating: _double(j['rating']),
        ratingCount: _int(j['ratingCount']),
        perkCount: _int(j['perkCount']),
        imageUrl: j['imageUrl'] as String?,
        distanceKm: j['distanceKm'] == null ? null : _double(j['distanceKm']),
      );

  final String id;
  final String displayName;
  final String district;
  final double rating;
  final int ratingCount;
  final int perkCount;
  final String? imageUrl;
  final double? distanceKm;
}

/// The member's own membership, from /me/memberships.
class MyMembership {
  MyMembership({
    required this.membershipId,
    required this.gymId,
    required this.gymName,
    required this.status,
    required this.daysRemaining,
    required this.maxLeaveDays,
    required this.leaveDaysUsed,
    required this.allowProgressMonitoring,
    this.endsAt,
    this.goal,
    this.trainerName,
    this.gymImageUrl,
    this.gymContactPhone,
  });

  factory MyMembership.fromJson(Map<String, dynamic> j) {
    final gym = (j['gym'] as Map<String, dynamic>?) ?? const {};
    return MyMembership(
      membershipId: j['membershipId'] as String,
      gymId: gym['id'] as String? ?? '',
      gymName: gym['displayName'] as String? ?? '',
      gymImageUrl: gym['imageUrl'] as String?,
      gymContactPhone: gym['contactPhone'] as String?,
      status: j['status'] as String? ?? 'ACTIVE',
      endsAt: _date(j['endsAt']),
      daysRemaining: _int(j['daysRemaining']),
      goal: j['goal'] as String?,
      trainerName: j['trainerName'] as String?,
      maxLeaveDays: _int(j['maxLeaveDays']),
      leaveDaysUsed: _int(j['leaveDaysUsed']),
      allowProgressMonitoring: j['allowProgressMonitoring'] != false,
    );
  }

  final String membershipId;
  final String gymId;
  final String gymName;
  final String? gymImageUrl;
  final String? gymContactPhone;
  final String status;
  final DateTime? endsAt;
  final int daysRemaining;
  final String? goal;
  final String? trainerName;
  final int maxLeaveDays;
  final int leaveDaysUsed;
  final bool allowProgressMonitoring;

  bool get onLeave => status == 'ON_LEAVE';
  int get leaveDaysLeft => (maxLeaveDays - leaveDaysUsed).clamp(0, maxLeaveDays);
}

/// One weight/height entry.
class BodyMetric {
  BodyMetric({required this.recordedAt, this.weightKg, this.heightCm});

  factory BodyMetric.fromJson(Map<String, dynamic> j) => BodyMetric(
        recordedAt: _date(j['recordedAt']) ?? DateTime.now(),
        weightKg: j['weightKg'] == null ? null : _double(j['weightKg']),
        heightCm: j['heightCm'] == null ? null : _double(j['heightCm']),
      );

  final DateTime recordedAt;
  final double? weightKg;
  final double? heightCm;
}

class MetricsSnapshot {
  MetricsSnapshot({
    required this.checkInDue,
    required this.history,
    this.latest,
  });

  factory MetricsSnapshot.fromJson(Map<String, dynamic> j) => MetricsSnapshot(
        checkInDue: j['checkInDue'] == true,
        latest: j['latest'] == null
            ? null
            : BodyMetric.fromJson(j['latest'] as Map<String, dynamic>),
        history: ((j['history'] as List?) ?? const [])
            .map((e) => BodyMetric.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  final bool checkInDue;
  final BodyMetric? latest;
  final List<BodyMetric> history;
}

/// A member as staff see them in the member list.
class MemberRow {
  MemberRow({
    required this.membershipId,
    required this.userId,
    required this.name,
    required this.phone,
    required this.status,
    required this.daysRemaining,
    this.goal,
    this.trainerName,
  });

  factory MemberRow.fromJson(Map<String, dynamic> j) {
    final user = (j['user'] as Map<String, dynamic>?) ?? const {};
    final trainer = j['trainer'] as Map<String, dynamic>?;
    return MemberRow(
      membershipId: j['membershipId'] as String,
      userId: user['id'] as String? ?? '',
      name: user['name'] as String? ?? '',
      phone: user['phone'] as String? ?? '',
      status: j['status'] as String? ?? 'ACTIVE',
      daysRemaining: _int(j['daysRemaining']),
      goal: j['goal'] as String?,
      trainerName: trainer?['name'] as String?,
    );
  }

  final String membershipId;
  final String userId;
  final String name;
  final String phone;
  final String status;
  final int daysRemaining;
  final String? goal;
  final String? trainerName;

  bool get expiringSoon => daysRemaining <= 7 && daysRemaining >= 0;
  bool get expired => daysRemaining < 0;
}

/// A staff member in the staff list.
class StaffRow {
  StaffRow({
    required this.id,
    required this.userId,
    required this.name,
    required this.phone,
    required this.roleName,
    required this.roleLevel,
    required this.isTrainer,
    required this.canManage,
    required this.isSelf,
    this.trainerCategoryName,
    this.assignedMemberCount = 0,
  });

  factory StaffRow.fromJson(Map<String, dynamic> j) {
    final user = (j['user'] as Map<String, dynamic>?) ?? const {};
    final role = (j['role'] as Map<String, dynamic>?) ?? const {};
    final cat = j['trainerCategory'] as Map<String, dynamic>?;
    return StaffRow(
      id: j['id'] as String,
      userId: user['id'] as String? ?? '',
      name: user['name'] as String? ?? '',
      phone: user['phone'] as String? ?? '',
      roleName: role['name'] as String? ?? '',
      roleLevel: _int(role['level'], 999),
      isTrainer: j['isTrainer'] == true,
      canManage: j['canManage'] == true,
      isSelf: j['isSelf'] == true,
      trainerCategoryName: cat?['name'] as String?,
      assignedMemberCount: _int(j['assignedMemberCount']),
    );
  }

  final String id;
  final String userId;
  final String name;
  final String phone;
  final String roleName;
  final int roleLevel;
  final bool isTrainer;
  final bool canManage;
  final bool isSelf;
  final String? trainerCategoryName;
  final int assignedMemberCount;
}

/// A leave request, staff-side.
class LeaveRow {
  LeaveRow({
    required this.id,
    required this.subjectName,
    required this.subjectType,
    required this.status,
    required this.days,
    required this.fromDate,
    required this.toDate,
    this.reason,
    this.decidedByName,
  });

  factory LeaveRow.fromJson(Map<String, dynamic> j) {
    final subject = (j['subject'] as Map<String, dynamic>?) ?? const {};
    final decider = j['decidedBy'] as Map<String, dynamic>?;
    return LeaveRow(
      id: j['id'] as String,
      subjectName: subject['name'] as String? ?? '',
      subjectType: j['subjectType'] as String? ?? 'MEMBER',
      status: j['status'] as String? ?? 'PENDING',
      days: _int(j['days']),
      fromDate: _date(j['fromDate']) ?? DateTime.now(),
      toDate: _date(j['toDate']) ?? DateTime.now(),
      reason: j['reason'] as String?,
      decidedByName: decider?['name'] as String?,
    );
  }

  final String id;
  final String subjectName;
  final String subjectType;
  final String status;
  final int days;
  final DateTime fromDate;
  final DateTime toDate;
  final String? reason;
  final String? decidedByName;

  bool get isPending => status == 'PENDING';
}

/// The lookup step when adding someone by phone.
class PersonLookup {
  PersonLookup({
    required this.challengeId,
    required this.phone,
    required this.phoneMasked,
    required this.exists,
    this.devCode,
  });

  factory PersonLookup.fromJson(Map<String, dynamic> j) => PersonLookup(
        challengeId: j['challengeId'] as String,
        phone: j['phone'] as String? ?? '',
        phoneMasked: j['phoneMasked'] as String? ?? '',
        exists: j['exists'] == true,
        devCode: j['devCode'] as String?,
      );

  final String challengeId;
  final String phone;
  final String phoneMasked;

  /// True when the number already has a Gymologia account. The form uses
  /// this to decide whether to ask for a name — details themselves only
  /// arrive after the code is verified.
  final bool exists;

  /// Present outside production only, so testing does not need a handset.
  final String? devCode;
}

/// Gym analytics for the dashboard.
class GymAnalytics {
  GymAnalytics({
    required this.activeMembers,
    required this.joinedInWindow,
    required this.engagedMembers,
    required this.engagementRate,
    required this.windowDays,
    required this.dailyPresent,
  });

  factory GymAnalytics.fromJson(Map<String, dynamic> j) => GymAnalytics(
        activeMembers: _int(j['activeMembers']),
        joinedInWindow: _int(j['joinedInWindow']),
        engagedMembers: _int(j['engagedMembers']),
        engagementRate: _int(j['engagementRate']),
        windowDays: _int(j['windowDays'], 30),
        dailyPresent: ((j['dailyPresent'] as List?) ?? const [])
            .map((e) => DailyCount.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  final int activeMembers;
  final int joinedInWindow;
  final int engagedMembers;
  final int engagementRate;
  final int windowDays;
  final List<DailyCount> dailyPresent;
}

class DailyCount {
  DailyCount({required this.date, required this.count});

  factory DailyCount.fromJson(Map<String, dynamic> j) => DailyCount(
        date: _date(j['date']) ?? DateTime.now(),
        count: _int(j['count']),
      );

  final DateTime date;
  final int count;
}

/// Permission names, matching the backend enum. Kept as constants so a
/// typo is a compile error rather than a screen that silently never shows.
class P {
  const P._();
  static const markAttendanceMember = 'MARK_ATTENDANCE_MEMBER';
  static const markAttendanceStaff = 'MARK_ATTENDANCE_STAFF';
  static const editAttendanceMember = 'EDIT_ATTENDANCE_MEMBER';
  static const viewAttendanceMember = 'VIEW_ATTENDANCE_MEMBER';
  static const viewLeaveMember = 'VIEW_LEAVE_MEMBER';
  static const approveLeaveMember = 'APPROVE_LEAVE_MEMBER';
  static const addMember = 'ADD_MEMBER';
  static const manageMember = 'MANAGE_MEMBER';
  static const removeMember = 'REMOVE_MEMBER';
  static const addStaff = 'ADD_STAFF';
  static const manageStaff = 'MANAGE_STAFF';
  static const removeStaff = 'REMOVE_STAFF';
  static const addRoles = 'ADD_ROLES';
  static const editPermissions = 'EDIT_PERMISSIONS';
  static const manageTrainers = 'MANAGE_TRAINERS';
  static const hostEvents = 'HOST_EVENTS';
  static const viewProgress = 'VIEW_PROGRESS';
  static const viewAnalytics = 'VIEW_ANALYTICS';
  static const editGymProfile = 'EDIT_GYM_PROFILE';
  static const manageSubscription = 'MANAGE_SUBSCRIPTION';
  static const deleteGym = 'DELETE_GYM';
  static const sendNotifications = 'SEND_NOTIFICATIONS';
}
