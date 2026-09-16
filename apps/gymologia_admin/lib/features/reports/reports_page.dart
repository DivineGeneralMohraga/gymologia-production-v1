import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/api/api_client.dart';
import '../auth/auth_controller.dart';

/// The report queue.
///
/// This screen is the other half of the report button in the member app.
/// Without somebody working it, reporting is a form that asks a person
/// being harassed to describe what happened and then does nothing — which
/// is worse than having no button, because it spends their trust as well
/// as their time.
///
/// Open first, then oldest, matching the server's ordering: a desk that
/// works newest-first leaves the earliest complaint permanently at the
/// bottom.
class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  List<dynamic>? _reports;
  int _total = 0;
  String? _error;
  String _filter = 'OPEN';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final result = await context
          .read<AuthController>()
          .api
          .reports(status: _filter == 'ALL' ? null : _filter);
      if (mounted) {
        setState(() {
          _reports = result.items;
          _total = result.total;
        });
      }
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: Row(
            children: [
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'OPEN', label: Text('Open')),
                  ButtonSegment(value: 'REVIEWING', label: Text('In review')),
                  ButtonSegment(value: 'ALL', label: Text('All')),
                ],
                selected: {_filter},
                onSelectionChanged: (s) {
                  setState(() {
                    _filter = s.first;
                    _reports = null;
                  });
                  _load();
                },
              ),
              const Spacer(),
              if (_reports != null)
                Text('$_total', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
        Expanded(child: _body()),
      ],
    );
  }

  Widget _body() {
    if (_error != null) {
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(_error!),
          const SizedBox(height: 12),
          FilledButton(onPressed: _load, child: const Text('Try again')),
        ]),
      );
    }
    if (_reports == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_reports!.isEmpty) {
      return const Center(child: Text('Nothing waiting.'));
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: _reports!.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (_, i) {
          final r = _reports![i] as Map<String, dynamic>;
          final reported = r['reportedUser'] as Map<String, dynamic>?;
          final reporter = r['reporter'] as Map<String, dynamic>?;
          final open = r['status'] == 'OPEN';

          return Card(
            child: ListTile(
              leading: Icon(
                Icons.flag,
                color: open ? Theme.of(context).colorScheme.error : null,
              ),
              title: Text('${reported?['name'] ?? ''} · '
                  '${_prettyCategory(r['category'] as String?)}'),
              subtitle: Text(
                '${r['details'] ?? ''}\n'
                'reported by ${reporter?['name'] ?? ''} · ${r['status'] ?? ''}',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              isThreeLine: true,
              onTap: () => _open(r['id'] as String),
            ),
          );
        },
      ),
    );
  }

  Future<void> _open(String id) async {
    final changed = await showDialog<bool>(
      context: context,
      builder: (_) => _ReportDialog(reportId: id),
    );
    if (changed == true) _load();
  }
}

String _prettyCategory(String? raw) => switch (raw) {
      'HARASSMENT' => 'Harassment',
      'SPAM' => 'Spam',
      'SEXUAL_CONTENT' => 'Sexual content',
      'HATE_SPEECH' => 'Hate speech',
      'VIOLENCE_OR_THREAT' => 'Violence or threat',
      'SCAM_OR_FRAUD' => 'Scam or fraud',
      'IMPERSONATION' => 'Impersonation',
      _ => 'Other',
    };

class _ReportDialog extends StatefulWidget {
  const _ReportDialog({required this.reportId});
  final String reportId;

  @override
  State<_ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<_ReportDialog> {
  final _note = TextEditingController();
  Map<String, dynamic>? _report;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final r =
          await context.read<AuthController>().api.reportDetail(widget.reportId);
      if (mounted) setState(() => _report = r);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    }
  }

  Future<void> _resolve(String status) async {
    final note = _note.text.trim();
    if (note.length < 3) {
      // Required even for a dismissal. The next person to look at this
      // account needs to know it was examined and what was concluded --
      // "no action" and "nobody got to it" are different facts.
      setState(() => _error = 'Say what was decided, even if it is no action.');
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await context.read<AuthController>().api.resolveReport(
            widget.reportId,
            status: status,
            actionTaken: note,
          );
      if (mounted) Navigator.of(context).pop(true);
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
    final r = _report;

    if (r == null) {
      return AlertDialog(
        content: SizedBox(
          width: 460,
          height: 120,
          child: Center(
            child: _error != null
                ? Text(_error!)
                : const CircularProgressIndicator(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Close'),
          ),
        ],
      );
    }

    final reported = r['reportedUser'] as Map<String, dynamic>?;
    final reporter = r['reporter'] as Map<String, dynamic>?;
    final context_ = r['context'] as Map<String, dynamic>?;
    final message = r['message'] as Map<String, dynamic>?;
    final decided = r['status'] == 'ACTIONED' || r['status'] == 'DISMISSED';

    return AlertDialog(
      title: Text('${reported?['name'] ?? ''} · '
          '${_prettyCategory(r['category'] as String?)}'),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Reported by ${reporter?['name'] ?? ''}',
                  style: theme.textTheme.bodySmall),
              const SizedBox(height: 12),

              Text('What the reporter says', style: theme.textTheme.labelLarge),
              const SizedBox(height: 4),
              Text('${r['details'] ?? ''}'),
              const SizedBox(height: 16),

              if (message != null) ...[
                Text('The message', style: theme.textTheme.labelLarge),
                const SizedBox(height: 4),
                // Said outright rather than shown as an empty box. A
                // reviewer who thinks the body failed to load will go
                // looking for a way to see it, and there is none.
                Text(
                  '${message['bodyNote'] ?? ''}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (message['deleted'] == true)
                  Text('The sender has since deleted it.',
                      style: theme.textTheme.bodySmall),
                const SizedBox(height: 16),
              ],

              if (context_ != null) ...[
                Text('History', style: theme.textTheme.labelLarge),
                const SizedBox(height: 4),
                // The numbers that turn one person's word against another
                // into a decision that can be defended. The block count
                // carries the most weight: blocking is silent and costs the
                // blocker nothing to make, so nobody does it to be
                // vexatious.
                Text('${context_['priorReportsAgainstThisAccount'] ?? 0} other '
                    'report(s) about this account'),
                Text('${context_['peopleWhoHaveBlockedThisAccount'] ?? 0} '
                    'person/people have blocked them'),
                Text('${context_['reportsFiledByThisReporter'] ?? 0} other '
                    'report(s) filed by this reporter'),
                const SizedBox(height: 16),
              ],

              if (decided) ...[
                Text('Decision', style: theme.textTheme.labelLarge),
                const SizedBox(height: 4),
                Text('${r['status']} · ${r['actionTaken'] ?? ''}'),
                if (r['reviewedBy'] != null)
                  Text('by ${r['reviewedBy']}',
                      style: theme.textTheme.bodySmall),
              ] else
                TextField(
                  controller: _note,
                  minLines: 2,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'What was done',
                    helperText:
                        'Required, including for a dismissal — the next '
                        'reviewer needs to know it was looked at.',
                    border: OutlineInputBorder(),
                  ),
                ),

              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _busy ? null : () => Navigator.of(context).pop(false),
          child: const Text('Close'),
        ),
        if (!decided) ...[
          TextButton(
            onPressed: _busy ? null : () => _resolve('REVIEWING'),
            child: const Text('Picking this up'),
          ),
          TextButton(
            onPressed: _busy ? null : () => _resolve('DISMISSED'),
            child: const Text('No action'),
          ),
          FilledButton(
            onPressed: _busy ? null : () => _resolve('ACTIONED'),
            child: const Text('Action taken'),
          ),
        ],
      ],
    );
  }
}
