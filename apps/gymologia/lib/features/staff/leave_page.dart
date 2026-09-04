import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../core/utils/dates.dart';
import 'package:provider/provider.dart';
import '../../core/api/api_client.dart';
import '../../core/api/gym_api.dart';
import '../../core/api/models.dart';
import '../auth/auth_controller.dart';

/// Leave requests.
///
/// Most requests never reach this screen — anything inside the gym's
/// ceilings is approved on submission. What lands here is the exceptions,
/// which is exactly what a manager should be spending attention on.
class LeavePage extends StatefulWidget {
  const LeavePage({super.key, required this.gym});

  final GymDetail gym;

  @override
  State<LeavePage> createState() => _LeavePageState();
}

class _LeavePageState extends State<LeavePage> {
  List<LeaveRow>? _leave;
  String? _error;
  String _subjectType = 'MEMBER';
  final Set<String> _deciding = {};

  GymApi get _api => GymApi(context.read<AuthController>().client);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _error = null;
      _leave = null;
    });
    try {
      final leave = await _api.leave(widget.gym.id, subjectType: _subjectType);
      if (mounted) setState(() => _leave = leave);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    }
  }

  Future<void> _decide(LeaveRow row, bool approve) async {
    setState(() => _deciding.add(row.id));
    try {
      await _api.decideLeave(widget.gym.id, row.id, approve: approve);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(approve
              ? AppLocalizations.of(context)
                  .approvedMembershipPauses(row.subjectName)
              : '${row.subjectName} declined.'),
        ),
      );
      await _load();
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    } finally {
      if (mounted) setState(() => _deciding.remove(row.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final leave = _leave;
    final canApprove = widget.gym.can(P.approveLeaveMember);

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).leave)),
      body: Column(
        children: [
          if (widget.gym.sees('leaveStaff'))
            Padding(
              padding: const EdgeInsets.all(16),
              child: SegmentedButton<String>(
                segments: [
                  ButtonSegment(
                      value: 'MEMBER',
                      label: Text(AppLocalizations.of(context).members)),
                  ButtonSegment(
                      value: 'STAFF',
                      label: Text(AppLocalizations.of(context).staff)),
                ],
                selected: {_subjectType},
                onSelectionChanged: (v) {
                  setState(() => _subjectType = v.first);
                  _load();
                },
              ),
            ),
          Expanded(
            child: _error != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Text(_error!, textAlign: TextAlign.center),
                    ),
                  )
                : leave == null
                    ? const Center(child: CircularProgressIndicator())
                    : leave.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32),
                              child: Text(
                                AppLocalizations.of(context)
                                    .nothingWaitingLeave,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.all(16),
                            itemCount: leave.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (_, i) => _LeaveCard(
                              row: leave[i],
                              canApprove: canApprove,
                              canReverse: widget.gym.can(P.editLeaveDecision),
                              busy: _deciding.contains(leave[i].id),
                              onDecide: (approve) => _decide(leave[i], approve),
                            ),
                          ),
          ),
        ],
      ),
    );
  }
}

class _LeaveCard extends StatelessWidget {
  const _LeaveCard({
    required this.row,
    required this.canApprove,
    required this.canReverse,
    required this.busy,
    required this.onDecide,
  });

  final LeaveRow row;
  final bool canApprove;

  /// Changing a decision someone else already made needs its own
  /// permission, and the server additionally requires seniority over
  /// whoever decided first.
  final bool canReverse;
  final bool busy;
  final ValueChanged<bool> onDecide;

  bool get _settled =>
      row.status == 'APPROVED' ||
      row.status == 'AUTO_APPROVED' ||
      row.status == 'DECLINED';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(row.subjectName,
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w700)),
                ),
                _StatusChip(status: row.status),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '${row.days} day${row.days == 1 ? '' : 's'}  ·  '
              '${_fmt(row.fromDate, Dates.localeOf(context))} to '
              '${_fmt(row.toDate, Dates.localeOf(context))}',
              style: theme.textTheme.bodyMedium,
            ),
            if (row.reason != null && row.reason!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(row.reason!,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
            if (row.decidedByName != null) ...[
              const SizedBox(height: 6),
              Text(AppLocalizations.of(context).decidedBy(row.decidedByName!),
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
            if (row.isPending && canApprove) ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  FilledButton(
                    onPressed: busy ? null : () => onDecide(true),
                    child: Text(AppLocalizations.of(context).approve),
                  ),
                  const SizedBox(width: 10),
                  OutlinedButton(
                    onPressed: busy ? null : () => onDecide(false),
                    child: Text(AppLocalizations.of(context).decline),
                  ),
                ],
              ),
            ] else if (_settled && canApprove && canReverse) ...[
              const SizedBox(height: 12),
              // The opposite of whatever was decided. Offering both would
              // invite re-confirming a decision that already stands.
              OutlinedButton.icon(
                onPressed: busy
                    ? null
                    : () => onDecide(row.status == 'DECLINED'),
                icon: const Icon(Icons.undo, size: 16),
                label: Text(row.status == 'DECLINED'
                    ? AppLocalizations.of(context).approveInstead
                    : AppLocalizations.of(context).declineInstead),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context);
    final (label, color) = switch (status) {
      'PENDING' => (t.needsYou, theme.colorScheme.tertiary),
      'APPROVED' => (t.approved, Colors.green),
      'AUTO_APPROVED' => (t.autoApproved, Colors.green),
      'DECLINED' => (t.declined, theme.colorScheme.error),
      'CLOSED_EARLY' => (t.returnedEarly, theme.colorScheme.onSurfaceVariant),
      'CANCELLED' => (t.cancelled, theme.colorScheme.onSurfaceVariant),
      _ => (status, theme.colorScheme.onSurfaceVariant),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.w700, color: color)),
    );
  }
}

String _fmt(DateTime d, String locale) => Dates.dayMonth(d, locale);
