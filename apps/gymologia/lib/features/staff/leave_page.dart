import 'package:flutter/material.dart';
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
              ? '${row.subjectName} approved. Their membership pauses for those days.'
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
      appBar: AppBar(title: const Text('Leave')),
      body: Column(
        children: [
          if (widget.gym.sees('leaveStaff'))
            Padding(
              padding: const EdgeInsets.all(16),
              child: SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'MEMBER', label: Text('Members')),
                  ButtonSegment(value: 'STAFF', label: Text('Staff')),
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
                                'Nothing waiting. Requests inside your limits are '
                                'approved automatically and never appear here.',
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
    required this.busy,
    required this.onDecide,
  });

  final LeaveRow row;
  final bool canApprove;
  final bool busy;
  final ValueChanged<bool> onDecide;

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
              '${_fmt(row.fromDate)} to ${_fmt(row.toDate)}',
              style: theme.textTheme.bodyMedium,
            ),
            if (row.reason != null && row.reason!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(row.reason!,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
            if (row.isPending && canApprove) ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  FilledButton(
                    onPressed: busy ? null : () => onDecide(true),
                    child: const Text('Approve'),
                  ),
                  const SizedBox(width: 10),
                  OutlinedButton(
                    onPressed: busy ? null : () => onDecide(false),
                    child: const Text('Decline'),
                  ),
                ],
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
    final (label, color) = switch (status) {
      'PENDING' => ('Needs you', theme.colorScheme.tertiary),
      'APPROVED' => ('Approved', Colors.green),
      'AUTO_APPROVED' => ('Auto-approved', Colors.green),
      'DECLINED' => ('Declined', theme.colorScheme.error),
      'CLOSED_EARLY' => ('Returned early', theme.colorScheme.onSurfaceVariant),
      'CANCELLED' => ('Cancelled', theme.colorScheme.onSurfaceVariant),
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

String _fmt(DateTime d) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return '${d.day} ${months[d.month - 1]}';
}
