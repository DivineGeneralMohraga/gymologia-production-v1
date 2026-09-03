import 'package:flutter/material.dart';
import '../../core/utils/dates.dart';
import 'package:provider/provider.dart';
import '../../core/api/api_client.dart';
import '../../core/api/gym_api.dart';
import '../../core/api/models.dart';
import '../auth/auth_controller.dart';
import 'attendance_history_page.dart';

/// One member, from the staff side: who they are, what they are working
/// towards, whether they are actually turning up, and the few things staff
/// can change.
///
/// Progress is fetched separately from the member record because it can be
/// refused on its own — a member who has revoked monitoring still has a
/// membership staff need to manage, they just cannot see the body metrics.
class MemberDetailPage extends StatefulWidget {
  const MemberDetailPage({
    super.key,
    required this.gym,
    required this.membershipId,
  });

  final GymDetail gym;
  final String membershipId;

  @override
  State<MemberDetailPage> createState() => _MemberDetailPageState();
}

class _MemberDetailPageState extends State<MemberDetailPage> {
  Map<String, dynamic>? _member;
  Map<String, dynamic>? _progress;
  String? _progressRefusal;
  String? _error;
  bool _busy = false;

  GymApi get _api => GymApi(context.read<AuthController>().client);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final member = await _api.member(widget.gym.id, widget.membershipId);
      if (!mounted) return;
      setState(() => _member = member);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
      return;
    }

    if (!widget.gym.can(P.viewProgress)) return;

    try {
      final progress =
          await _api.memberProgress(widget.gym.id, widget.membershipId);
      if (mounted) setState(() => _progress = progress);
    } on ApiException catch (e) {
      // 403 here means the member turned monitoring off, which is a normal
      // state to be in and worth showing rather than swallowing.
      if (mounted) setState(() => _progressRefusal = e.message);
    }
  }

  Future<void> _run(Future<void> Function() action, String done) async {
    setState(() => _busy = true);
    try {
      await action();
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(done)));
      await _load();
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _extend() async {
    final months = await showModalBottomSheet<int>(
      context: context,
      builder: (_) => const _ExtendSheet(),
    );
    if (months == null) return;
    await _run(
      () => _api
          .extendMembership(widget.gym.id, widget.membershipId, months)
          .then((_) {}),
      'Membership extended by $months month${months == 1 ? '' : 's'}.',
    );
  }

  Future<void> _editGoal() async {
    final current = _member?['goal'] as String? ?? '';
    final updated = await showDialog<String>(
      context: context,
      builder: (_) => _GoalDialog(initial: current),
    );
    if (updated == null) return;
    await _run(
      () => _api
          .updateMember(widget.gym.id, widget.membershipId, {'goal': updated})
          .then((_) {}),
      'Goal updated.',
    );
  }

  Future<void> _remove() async {
    final name = _nameOf(_member) ?? 'this member';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove member?'),
        content: Text(
          '$name loses access to this gym. Their attendance history and '
          'measurements are kept.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _busy = true);
    try {
      await _api.removeMember(widget.gym.id, widget.membershipId);
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } on ApiException catch (e) {
      if (mounted) {
        setState(() => _busy = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  String? _nameOf(Map<String, dynamic>? member) =>
      (member?['user'] as Map<String, dynamic>?)?['name'] as String?;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final member = _member;

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Text(_error!, textAlign: TextAlign.center),
          ),
        ),
      );
    }
    if (member == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final user = (member['user'] as Map<String, dynamic>?) ?? const {};
    final trainer = member['trainer'] as Map<String, dynamic>?;
    final days = (member['daysRemaining'] as int?) ?? 0;
    final goal = member['goal'] as String?;
    final canManage = widget.gym.can(P.manageMember);

    return Scaffold(
      appBar: AppBar(
        title: Text(user['name'] as String? ?? 'Member'),
        actions: [
          if (widget.gym.can(P.removeMember))
            IconButton(
              tooltip: 'Remove member',
              icon: Icon(Icons.person_remove_outlined,
                  color: theme.colorScheme.error),
              onPressed: _busy ? null : _remove,
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user['phone'] as String? ?? '',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      )),
                  if (user['email'] != null)
                    Text(user['email'] as String,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        )),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _Figure(
                        label: 'Days left',
                        value: days < 0 ? 'Expired' : '$days',
                        alarming: days <= 7,
                      ),
                      const SizedBox(width: 26),
                      _Figure(
                        label: 'Leave used',
                        value: '${member['leaveDaysUsed'] ?? 0}'
                            ' / ${member['maxLeaveDays'] ?? 0}',
                      ),
                    ],
                  ),
                  if (canManage) ...[
                    const SizedBox(height: 18),
                    Wrap(
                      spacing: 10,
                      runSpacing: 8,
                      children: [
                        FilledButton.tonalIcon(
                          onPressed: _busy ? null : _extend,
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Extend'),
                        ),
                        OutlinedButton.icon(
                          onPressed: _busy ? null : _editGoal,
                          icon: const Icon(Icons.flag_outlined, size: 18),
                          label: const Text('Edit goal'),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),
          _InfoTile(
            icon: Icons.flag_outlined,
            label: 'Goal',
            value: (goal == null || goal.isEmpty) ? 'Not set' : goal,
          ),
          _InfoTile(
            icon: Icons.person_outline,
            label: 'Trainer',
            value: trainer?['name'] as String? ?? 'None assigned',
          ),

          if (widget.gym.can(P.viewAttendanceMember)) ...[
            const SizedBox(height: 6),
            Card(
              child: ListTile(
                leading: const Icon(Icons.fact_check_outlined),
                title: const Text('Attendance history'),
                subtitle: Text(_progress == null
                    ? 'View and correct records'
                    : '${_progress!['totalSessionsAttended'] ?? 0} sessions so far'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AttendanceHistoryPage(
                      gym: widget.gym,
                      subjectType: 'MEMBER',
                      userId: user['id'] as String,
                      name: user['name'] as String? ?? 'Member',
                    ),
                  ),
                ),
              ),
            ),
          ],

          const SizedBox(height: 14),
          _ProgressSection(
            progress: _progress,
            refusal: _progressRefusal,
            canView: widget.gym.can(P.viewProgress),
          ),
        ],
      ),
    );
  }
}

class _ProgressSection extends StatelessWidget {
  const _ProgressSection({
    required this.progress,
    required this.refusal,
    required this.canView,
  });

  final Map<String, dynamic>? progress;
  final String? refusal;
  final bool canView;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!canView) return const SizedBox.shrink();

    if (refusal != null) {
      return Card(
        elevation: 0,
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.visibility_off_outlined,
                  size: 20, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Progress is private',
                        style: theme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(
                      'This member has turned off progress monitoring. That is '
                      'their choice and no role can override it.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (progress == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: SizedBox(
            height: 20, width: 20,
            child: CircularProgressIndicator(strokeWidth: 2.2),
          ),
        ),
      );
    }

    final metrics = ((progress!['metrics'] as List?) ?? const [])
        .cast<Map<String, dynamic>>();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Progress',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            if (metrics.isEmpty)
              Text(
                'No measurements recorded yet. The member is prompted for these '
                'in their own app once a month.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              )
            else ...[
              _WeightTrend(metrics: metrics),
              const SizedBox(height: 14),
              for (final m in metrics.take(6))
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 96,
                        child: Text(
                          _shortDate(m['recordedAt'] as String?, Dates.localeOf(context)),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      Text(
                        [
                          if (m['weightKg'] != null) '${m['weightKg']} kg',
                          if (m['heightCm'] != null) '${m['heightCm']} cm',
                        ].join('  ·  '),
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

/// The one number a trainer actually wants: which way the weight is going
/// since the member joined, and by how much.
class _WeightTrend extends StatelessWidget {
  const _WeightTrend({required this.metrics});
  final List<Map<String, dynamic>> metrics;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final weights = metrics
        .where((m) => m['weightKg'] != null)
        .map((m) => (m['weightKg'] as num).toDouble())
        .toList();

    if (weights.length < 2) return const SizedBox.shrink();

    // Metrics arrive newest-first.
    final latest = weights.first;
    final earliest = weights.last;
    final delta = latest - earliest;
    final rising = delta > 0;

    return Row(
      children: [
        Icon(
          delta.abs() < 0.05
              ? Icons.trending_flat
              : rising
                  ? Icons.trending_up
                  : Icons.trending_down,
          size: 20,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Text(
          delta.abs() < 0.05
              ? 'Holding at ${latest.toStringAsFixed(1)} kg'
              : '${rising ? '+' : ''}${delta.toStringAsFixed(1)} kg '
                  'since their first measurement',
          style: theme.textTheme.bodyMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _ExtendSheet extends StatefulWidget {
  const _ExtendSheet();

  @override
  State<_ExtendSheet> createState() => _ExtendSheetState();
}

class _ExtendSheetState extends State<_ExtendSheet> {
  int _months = 1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Extend membership',
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(
            'An expired membership extends from today, not from the date it '
            'lapsed.',
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            children: [
              for (final m in [1, 3, 6, 12])
                ChoiceChip(
                  label: Text('$m month${m == 1 ? '' : 's'}'),
                  selected: _months == m,
                  onSelected: (_) => setState(() => _months = m),
                ),
            ],
          ),
          const SizedBox(height: 22),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(_months),
            child: Text('Extend by $_months month${_months == 1 ? '' : 's'}'),
          ),
        ],
      ),
    );
  }
}

class _GoalDialog extends StatefulWidget {
  const _GoalDialog({required this.initial});
  final String initial;

  @override
  State<_GoalDialog> createState() => _GoalDialogState();
}

class _GoalDialogState extends State<_GoalDialog> {
  late final _controller = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('What are they working towards?'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        maxLength: 300,
        decoration: const InputDecoration(
          hintText: 'Bulk up to 80kg, lose weight, rehab…',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_controller.text.trim()),
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _Figure extends StatelessWidget {
  const _Figure({
    required this.label,
    required this.value,
    this.alarming = false,
  });

  final String label;
  final String value;
  final bool alarming;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: alarming ? theme.colorScheme.error : null,
            )),
        Text(label.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              letterSpacing: 0.7,
              color: theme.colorScheme.onSurfaceVariant,
            )),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: Icon(icon, size: 20),
      title: Text(label.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            letterSpacing: 0.7,
            color: theme.colorScheme.onSurfaceVariant,
          )),
      subtitle: Text(value, style: theme.textTheme.bodyLarge),
    );
  }
}

String _shortDate(String? iso, String locale) => Dates.isoFull(iso, locale);
