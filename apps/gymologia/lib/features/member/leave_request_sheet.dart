import 'package:flutter/material.dart';
import '../../core/api/api_client.dart';
import '../../core/api/gym_api.dart';
import '../../core/api/models.dart';

/// Asking for leave, member side.
///
/// The sheet says up front whether the request will be approved on the
/// spot or go to a manager, because that is the only thing the member
/// actually wants to know — and it is knowable from the allowance they
/// have left, without asking the server first.
class LeaveRequestSheet extends StatefulWidget {
  const LeaveRequestSheet({
    super.key,
    required this.api,
    required this.membership,
  });

  final GymApi api;
  final MyMembership membership;

  @override
  State<LeaveRequestSheet> createState() => _LeaveRequestSheetState();
}

class _LeaveRequestSheetState extends State<LeaveRequestSheet> {
  DateTimeRange? _range;
  final _reason = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  int get _days => _range == null
      ? 0
      : _range!.end.difference(_range!.start).inDays + 1;

  bool get _needsApproval => _days > widget.membership.leaveDaysLeft;

  Future<void> _pickDates() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 365)),
      initialDateRange: _range,
      helpText: 'Select your leave dates',
    );
    if (picked != null) setState(() => _range = picked);
  }

  Future<void> _submit() async {
    if (_range == null) {
      setState(() => _error = 'Choose your dates first.');
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      await widget.api.requestLeave(
        gymId: widget.membership.gymId,
        from: _range!.start,
        to: _range!.end,
        reason: _reason.text.trim(),
      );
      if (!mounted) return;
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_needsApproval
              ? 'Sent for approval.'
              : 'Leave approved. Your membership is paused for those days.'),
        ),
      );
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _error = e.message;
          _busy = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final m = widget.membership;

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
          Text('Request leave',
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(
            'Your membership pauses while you are away, so you keep the days you paid for.',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 18),
          OutlinedButton.icon(
            onPressed: _pickDates,
            icon: const Icon(Icons.calendar_today_outlined, size: 18),
            label: Text(
              _range == null
                  ? 'Choose dates'
                  : '${_fmt(_range!.start)} to ${_fmt(_range!.end)}  ·  $_days day${_days == 1 ? '' : 's'}',
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: (_needsApproval
                      ? theme.colorScheme.tertiaryContainer
                      : theme.colorScheme.secondaryContainer)
                  .withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  _needsApproval ? Icons.schedule : Icons.check_circle_outline,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _range == null
                        ? 'You have ${m.leaveDaysLeft} leave day${m.leaveDaysLeft == 1 ? '' : 's'} left.'
                        : _needsApproval
                            ? 'That is more than your ${m.leaveDaysLeft} remaining day'
                                '${m.leaveDaysLeft == 1 ? '' : 's'}, so a manager will need to approve it.'
                            : 'Within your allowance — this will be approved straight away.',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _reason,
            maxLength: 200,
            decoration: const InputDecoration(
              labelText: 'Reason (optional)',
              counterText: '',
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 10),
            Text(_error!,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.error)),
          ],
          const SizedBox(height: 18),
          FilledButton(
            onPressed: _busy ? null : _submit,
            child: _busy
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  )
                : Text(_needsApproval ? 'Send for approval' : 'Request leave'),
          ),
        ],
      ),
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
