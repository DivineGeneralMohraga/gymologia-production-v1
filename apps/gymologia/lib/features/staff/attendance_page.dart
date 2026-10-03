import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/api/api_client.dart';
import '../../core/api/gym_api.dart';
import '../../core/api/models.dart';
import '../../l10n/app_localizations.dart';
import '../../theme.dart';
import '../../ui/kit.dart';
import '../auth/auth_controller.dart';

/// The front-desk attendance screen: everyone who can be marked today, one
/// tap each.
///
/// Members and staff are separate lists because they are separate
/// permissions; a trainer sees only Members. Staff lists only people the
/// viewer outranks, and never roles that do not take attendance (Owner and
/// Manager by default) -- the server refuses those anyway.
///
/// Marking someone who is already marked differently is an edit. Edits need
/// the edit permission and a reason, exactly as the server enforces, so the
/// screen asks for the reason up front instead of failing after the tap.
class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key, required this.gym});

  final GymDetail gym;

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

enum _Who { members, staff }

enum _Filter { all, unmarked, present, absent }

/// One markable person and their record for the chosen day, if any.
class _Person {
  _Person({required this.id, required this.userId, required this.name, required this.detail});
  final String id; // membershipId or staffMemberId: what the mark call takes
  final String userId; // what attendance records are keyed by
  final String name;
  final String detail;
}

class _AttendancePageState extends State<AttendancePage> {
  final _search = TextEditingController();
  late _Who _who;
  DateTime _day = DateTime.now();
  _Filter _filter = _Filter.all;

  List<_Person>? _people;
  Map<String, Map<String, dynamic>> _records = {};
  bool _recordsHidden = false;
  final Set<String> _busy = {};
  String? _error;

  GymApi get _api => GymApi(context.read<AuthController>().client);
  GymDetail get _gym => widget.gym;

  bool get _canMembers => _gym.can(P.markAttendanceMember) || _gym.can(P.viewAttendanceMember);
  bool get _canStaff => _gym.can(P.markAttendanceStaff) || _gym.can(P.viewAttendanceStaff);
  bool get _canMark => _who == _Who.members ? _gym.can(P.markAttendanceMember) : _gym.can(P.markAttendanceStaff);
  bool get _canEdit => _who == _Who.members ? _gym.can(P.editAttendanceMember) : _gym.can(P.editAttendanceStaff);
  bool get _canView => _who == _Who.members ? _gym.can(P.viewAttendanceMember) : _gym.can(P.viewAttendanceStaff);
  String get _subjectType => _who == _Who.members ? 'MEMBER' : 'STAFF';
  bool get _isToday => DateUtils.isSameDay(_day, DateTime.now());

  @override
  void initState() {
    super.initState();
    _who = _canMembers ? _Who.members : _Who.staff;
    _load();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _error = null;
      _people = null;
    });
    try {
      final people = _who == _Who.members ? await _loadMembers() : await _loadStaff();
      var records = <String, Map<String, dynamic>>{};
      var hidden = false;
      if (_canView) {
        final rows = await _api.attendance(_gym.id, subjectType: _subjectType, from: _day, to: _day);
        records = {for (final r in rows) '${r['subjectId']}': r};
      } else {
        hidden = true;
      }
      if (!mounted) return;
      setState(() {
        _people = people..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        _records = records;
        _recordsHidden = hidden;
      });
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    }
  }

  /// Every current member, page by page: the member list endpoint returns
  /// at most 200 at a time.
  Future<List<_Person>> _loadMembers() async {
    final all = <_Person>[];
    var offset = 0;
    while (true) {
      final page = await _api.members(_gym.id, limit: 200, offset: offset);
      for (final m in page.items) {
        if (m.expired || m.status == 'REMOVED') continue;
        all.add(_Person(
          id: m.membershipId,
          userId: m.userId,
          name: m.name,
          detail: m.trainerName ?? '${m.daysRemaining}d',
        ));
      }
      offset += page.items.length;
      if (page.items.isEmpty || offset >= page.total) break;
    }
    return all;
  }

  Future<List<_Person>> _loadStaff() async {
    final rows = await _api.staff(_gym.id);
    return [
      for (final s in rows)
        if (!s.isSelf && s.canManage && !s.exemptFromAttendance)
          _Person(id: s.id, userId: s.userId, name: s.name, detail: s.roleName),
    ];
  }

  Future<void> _pickDay() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _day,
      firstDate: now.subtract(const Duration(days: 60)),
      lastDate: now,
    );
    if (picked != null && !DateUtils.isSameDay(picked, _day)) {
      setState(() => _day = picked);
      await _load();
    }
  }

  Future<void> _set(_Person p, String status) async {
    final t = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final existing = _records[p.userId];
    final current = existing?['status'] as String?;
    if (current == status) return;

    String? reason;
    if (current != null) {
      if (!_canEdit) {
        messenger.showSnackBar(SnackBar(content: Text(t.attendanceNeedsEditPermission(_label(t, current)))));
        return;
      }
      reason = await _askReason(p, status);
      if (reason == null) return;
    }

    setState(() => _busy.add(p.userId));
    try {
      final Map<String, dynamic> saved;
      if (existing != null) {
        saved = await _api.editAttendance(_gym.id, '${existing['id']}', status: status, reason: reason!);
      } else {
        saved = await _api.markAttendance(
          gymId: _gym.id,
          subjectType: _subjectType,
          subjectId: p.id,
          status: status,
          date: _isToday ? null : _day,
        );
      }
      if (!mounted) return;
      setState(() {
        _records[p.userId] = {...?existing, ...saved, 'status': status};
        _busy.remove(p.userId);
      });
      messenger.showSnackBar(SnackBar(
        content: Text(existing != null
            ? t.attendanceChanged
            : status == 'PRESENT'
                ? t.markedPresent(p.name)
                : t.markedAbsent(p.name)),
        duration: const Duration(milliseconds: 1400),
      ));
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _busy.remove(p.userId));
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<String?> _askReason(_Person p, String status) async {
    final t = AppLocalizations.of(context);
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: Text(t.attendanceChangeTitle(p.name, _label(t, status))),
          content: TextField(
            controller: controller,
            autofocus: true,
            maxLength: 300,
            onChanged: (_) => setLocal(() {}),
            decoration: InputDecoration(
              labelText: t.attendanceChangeReason,
              hintText: t.attendanceChangeReasonHint,
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text(t.cancel)),
            FilledButton(
              onPressed: controller.text.trim().length < 3 ? null : () => Navigator.pop(ctx, controller.text.trim()),
              child: Text(t.save),
            ),
          ],
        ),
      ),
    );
    controller.dispose();
    return result;
  }

  String _label(AppLocalizations t, String status) => switch (status) {
        'PRESENT' => t.present,
        'ABSENT' => t.absent,
        'ON_LEAVE' => t.onLeave,
        _ => status,
      };

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final people = _people;

    final q = _search.text.trim().toLowerCase();
    final visible = people == null
        ? <_Person>[]
        : people.where((p) {
            if (q.isNotEmpty && !p.name.toLowerCase().contains(q)) return false;
            final s = _records[p.userId]?['status'];
            return switch (_filter) {
              _Filter.all => true,
              _Filter.unmarked => s == null,
              _Filter.present => s == 'PRESENT',
              _Filter.absent => s == 'ABSENT' || s == 'ON_LEAVE',
            };
          }).toList();
    // The ones still to do come first; that is who the desk is looking for.
    visible.sort((a, b) {
      final am = _records.containsKey(a.userId) ? 1 : 0;
      final bm = _records.containsKey(b.userId) ? 1 : 0;
      return am != bm ? am - bm : a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });

    final total = people?.length ?? 0;
    final present = _records.values.where((r) => r['status'] == 'PRESENT').length;
    final absent = _records.values.where((r) => r['status'] != 'PRESENT').length;
    final unmarked = (total - present - absent).clamp(0, total);

    return Scaffold(
      appBar: AppBar(title: Text(t.attendance.toUpperCase())),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            if (_canMembers && _canStaff) ...[
              SegmentedButton<_Who>(
                segments: [
                  ButtonSegment(value: _Who.members, label: Text(t.members), icon: const Icon(Icons.groups_rounded)),
                  ButtonSegment(value: _Who.staff, label: Text(t.staff), icon: const Icon(Icons.badge_rounded)),
                ],
                selected: {_who},
                onSelectionChanged: (s) {
                  setState(() => _who = s.first);
                  _load();
                },
              ),
              const SizedBox(height: 14),
            ],
            Row(
              children: [
                ActionChip(
                  avatar: const Icon(Icons.calendar_today_rounded, size: 18),
                  label: Text(_isToday ? t.attendanceToday : MaterialLocalizations.of(context).formatMediumDate(_day)),
                  onPressed: _pickDay,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _search,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: t.searchByNameOrNumber,
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (!_recordsHidden && people != null)
              Row(
                children: [
                  Expanded(child: _Count(label: t.present, value: present, accent: true)),
                  const SizedBox(width: 10),
                  Expanded(child: _Count(label: t.absent, value: absent)),
                  const SizedBox(width: 10),
                  Expanded(child: _Count(label: t.notMarked, value: unmarked)),
                ],
              ),
            if (_recordsHidden)
              Text(t.attendanceCantView, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: 12),
            if (!_recordsHidden)
              Wrap(
                spacing: 8,
                children: [
                  for (final (f, label) in [
                    (_Filter.all, t.attendanceFilterAll),
                    (_Filter.unmarked, t.notMarked),
                    (_Filter.present, t.present),
                    (_Filter.absent, t.absent),
                  ])
                    ChoiceChip(label: Text(label), selected: _filter == f, onSelected: (_) => setState(() => _filter = f)),
                ],
              ),
            const SizedBox(height: 8),
            if (_error != null)
              EmptyState(
                icon: Icons.cloud_off_rounded,
                title: _error!,
                action: FilledButton.tonal(onPressed: _load, child: Text(t.tryAgain)),
              )
            else if (people == null)
              const Padding(padding: EdgeInsets.all(40), child: Center(child: CircularProgressIndicator()))
            else if (visible.isEmpty)
              EmptyState(icon: Icons.how_to_reg_rounded, title: t.attendanceNobody, message: t.attendanceNobodyHint)
            else
              for (final p in visible)
                _Row(
                  person: p,
                  status: _records[p.userId]?['status'] as String?,
                  busy: _busy.contains(p.userId),
                  canMark: _canMark,
                  label: (s) => _label(t, s),
                  onPresent: () => _set(p, 'PRESENT'),
                  onAbsent: () => _set(p, 'ABSENT'),
                ),
          ],
        ),
      ),
    );
  }
}

class _Count extends StatelessWidget {
  const _Count({required this.label, required this.value, this.accent = false});
  final String label;
  final int value;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.gym.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$value',
            style: TextStyle(
              fontFamily: displayFont,
              fontSize: 34,
              fontWeight: FontWeight.w900,
              height: 1,
              color: accent ? context.gym.accentText : scheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Eyebrow(label),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.person,
    required this.status,
    required this.busy,
    required this.canMark,
    required this.label,
    required this.onPresent,
    required this.onAbsent,
  });

  final _Person person;
  final String? status;
  final bool busy;
  final bool canMark;
  final String Function(String) label;
  final VoidCallback onPresent;
  final VoidCallback onAbsent;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final present = status == 'PRESENT';

    Widget trailing;
    if (busy) {
      trailing = const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.4));
    } else if (status != null) {
      trailing = present
          ? Pill.volt(label(status!), icon: Icons.check_rounded)
          : Pill(label(status!), background: scheme.errorContainer, foreground: scheme.onErrorContainer);
    } else if (canMark) {
      // Neutral until tapped: volt only ever means "marked present".
      trailing = OutlinedButton.icon(
        onPressed: onPresent,
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 40),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          foregroundColor: scheme.onSurface,
          side: BorderSide(color: scheme.outline),
        ),
        icon: const Icon(Icons.check_rounded, size: 18),
        label: Text(t.present.toUpperCase()),
      );
    } else {
      trailing = Pill(t.notMarked);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: present ? context.gym.accentText.withValues(alpha: .5) : context.gym.cardBorder),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 6, 10),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: present ? volt : scheme.surfaceContainerHighest,
                foregroundColor: present ? ink : scheme.onSurface,
                child: Text(person.name.isEmpty ? '?' : person.name.characters.first.toUpperCase()),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(person.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text(person.detail, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              trailing,
              if (canMark)
                PopupMenuButton<String>(
                  tooltip: t.attendance,
                  onSelected: (v) => v == 'PRESENT' ? onPresent() : onAbsent(),
                  itemBuilder: (_) => [
                    if (status != 'PRESENT') PopupMenuItem(value: 'PRESENT', child: Text(t.present)),
                    if (status != 'ABSENT') PopupMenuItem(value: 'ABSENT', child: Text(t.markAbsent)),
                  ],
                )
              else
                const SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }
}
