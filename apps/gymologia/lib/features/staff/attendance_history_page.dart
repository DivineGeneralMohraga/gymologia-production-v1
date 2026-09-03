import 'package:flutter/material.dart';
import '../../core/utils/dates.dart';
import 'package:provider/provider.dart';
import '../../core/api/api_client.dart';
import '../../core/api/gym_api.dart';
import '../../core/api/models.dart';
import '../auth/auth_controller.dart';

/// One person's attendance, with the ability to correct a record.
///
/// Corrections demand a reason. The server enforces that, and so does this
/// screen — an attendance change with no explanation is indistinguishable
/// from tampering when someone reads the audit log six months later.
class AttendanceHistoryPage extends StatefulWidget {
  const AttendanceHistoryPage({
    super.key,
    required this.gym,
    required this.subjectType,
    required this.userId,
    required this.name,
  });

  final GymDetail gym;
  final String subjectType;
  final String userId;
  final String name;

  @override
  State<AttendanceHistoryPage> createState() => _AttendanceHistoryPageState();
}

class _AttendanceHistoryPageState extends State<AttendanceHistoryPage> {
  List<Map<String, dynamic>>? _records;
  int _totalPresent = 0;
  String? _error;

  GymApi get _api => GymApi(context.read<AuthController>().client);

  bool get _canEdit => widget.subjectType == 'MEMBER'
      ? widget.gym.can(P.editAttendanceMember)
      : widget.gym.can(P.editAttendanceStaff);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final result = await _api.attendanceForSubject(
        widget.gym.id,
        subjectType: widget.subjectType,
        userId: widget.userId,
      );
      if (!mounted) return;
      setState(() {
        _records = ((result['records'] as List?) ?? const [])
            .cast<Map<String, dynamic>>();
        _totalPresent = (result['totalPresent'] as int?) ?? 0;
      });
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    }
  }

  Future<void> _correct(Map<String, dynamic> record) async {
    final result = await showModalBottomSheet<({String status, String reason})>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _CorrectionSheet(
        current: record['status'] as String? ?? 'PRESENT',
        date: record['date'] as String?,
      ),
    );
    if (result == null) return;

    try {
      await _api.editAttendance(
        widget.gym.id,
        record['id'] as String,
        status: result.status,
        reason: result.reason,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Record corrected.')),
      );
      await _load();
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final records = _records;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.name, style: const TextStyle(fontSize: 17)),
            Text('Attendance',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: theme.colorScheme.onSurfaceVariant,
                )),
          ],
        ),
      ),
      body: _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Text(_error!, textAlign: TextAlign.center),
              ),
            )
          : records == null
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                      child: Row(
                        children: [
                          Text('$_totalPresent',
                              style: theme.textTheme.headlineMedium
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'session${_totalPresent == 1 ? '' : 's'} attended, all time',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_canEdit)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                        child: Row(
                          children: [
                            Icon(Icons.touch_app_outlined,
                                size: 15,
                                color: theme.colorScheme.onSurfaceVariant),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text('Tap a day to correct it',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    Expanded(
                      child: records.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(32),
                                child: Text(
                                  'Nothing recorded in the last 60 days.',
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.only(bottom: 32),
                              itemCount: records.length,
                              separatorBuilder: (_, __) =>
                                  const Divider(height: 1),
                              itemBuilder: (_, i) {
                                final r = records[i];
                                final status =
                                    r['status'] as String? ?? 'PRESENT';
                                final editedAt = r['editedAt'];

                                return ListTile(
                                  onTap: _canEdit ? () => _correct(r) : null,
                                  leading: _StatusDot(status: status),
                                  title: Text(_fullDate(r['date'] as String?, Dates.localeOf(context))),
                                  subtitle: editedAt == null
                                      ? null
                                      : Text(
                                          'Corrected: ${r['editReason'] ?? 'no reason given'}',
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                            color: theme.colorScheme.tertiary,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                  trailing: Text(
                                    _label(status),
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: _color(context, status),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
    );
  }
}

String _label(String status) => switch (status) {
      'PRESENT' => 'Present',
      'ABSENT' => 'Absent',
      'ON_LEAVE' => 'On leave',
      _ => status,
    };

Color _color(BuildContext context, String status) => switch (status) {
      'PRESENT' => Colors.green,
      'ABSENT' => Theme.of(context).colorScheme.error,
      _ => Theme.of(context).colorScheme.onSurfaceVariant,
    };

class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final color = _color(context, status);
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(
        switch (status) {
          'PRESENT' => Icons.check,
          'ABSENT' => Icons.close,
          _ => Icons.pause,
        },
        size: 18,
        color: color,
      ),
    );
  }
}

class _CorrectionSheet extends StatefulWidget {
  const _CorrectionSheet({required this.current, required this.date});

  final String current;
  final String? date;

  @override
  State<_CorrectionSheet> createState() => _CorrectionSheetState();
}

class _CorrectionSheetState extends State<_CorrectionSheet> {
  late String _status = widget.current;
  final _reason = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  void _submit() {
    if (_reason.text.trim().length < 3) {
      setState(() => _error = 'Say why this is being changed.');
      return;
    }
    Navigator.of(context)
        .pop((status: _status, reason: _reason.text.trim()));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24, 20, 24, MediaQuery.of(context).viewInsets.bottom + 28,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('Correct ${_fullDate(widget.date, Dates.localeOf(context))}',
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 18),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'PRESENT', label: Text('Present')),
              ButtonSegment(value: 'ABSENT', label: Text('Absent')),
              ButtonSegment(value: 'ON_LEAVE', label: Text('Leave')),
            ],
            selected: {_status},
            onSelectionChanged: (v) => setState(() => _status = v.first),
          ),
          const SizedBox(height: 18),
          TextField(
            controller: _reason,
            autofocus: true,
            maxLength: 200,
            decoration: const InputDecoration(
              labelText: 'Why is this changing?',
              hintText: 'Marked by mistake, machine was down…',
              counterText: '',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'This is kept with the record and shows in the audit log.',
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          if (_error != null) ...[
            const SizedBox(height: 10),
            Text(_error!,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.error)),
          ],
          const SizedBox(height: 20),
          FilledButton(onPressed: _submit, child: const Text('Save correction')),
        ],
      ),
    );
  }
}

/// Weekday, day and month in the reader's language. The five separate
/// ['Jan', 'Feb', ...] tables this app used to carry are all gone: intl
/// already knows the names for every locale that ships.
String _fullDate(String? iso, String locale) =>
    Dates.isoWeekdayDayMonth(iso, locale);
