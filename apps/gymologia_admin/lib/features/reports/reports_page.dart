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
          final reporter = r['reporter'] as Map<String, dynamic>?;
          final open = r['status'] == 'OPEN';
          final details = r['details'] as String? ?? '';

          return Card(
            child: ListTile(
              leading: Icon(
                _targetIcon(r['target'] as String?),
                color: open ? Theme.of(context).colorScheme.error : null,
              ),
              title: Text('${_subject(r)} · '
                  '${_prettyCategory(r['category'] as String?)}'),
              subtitle: Text(
                '${details.isEmpty ? '(no details)' : details}\n'
                'reported by ${reporter?['name'] ?? ''} · ${r['status'] ?? ''}'
                '${_listingHidden(r) ? ' · HIDDEN' : ''}',
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
      'FAKE_LISTING' => 'Fake listing',
      'MISLEADING' => 'Misleading',
      _ => 'Other',
    };

IconData _targetIcon(String? target) => switch (target) {
      'GYM' => Icons.fitness_center,
      'EVENT' => Icons.event,
      _ => Icons.flag,
    };

/// What the report is about: the gym or event for a listing report, the
/// person for a chat report. Older reports have no `target` and are people.
String _subject(Map<String, dynamic> r) {
  final gym = r['gym'] as Map<String, dynamic>?;
  final event = r['event'] as Map<String, dynamic>?;
  final person = r['reportedUser'] as Map<String, dynamic>?;
  return switch (r['target']) {
    'GYM' => 'Gym: ${gym?['name'] ?? '(deleted)'}',
    'EVENT' => 'Event: ${event?['title'] ?? '(deleted)'}',
    _ => '${person?['name'] ?? ''}',
  };
}

bool _listingHidden(Map<String, dynamic> r) => switch (r['target']) {
      'GYM' => (r['gym'] as Map<String, dynamic>?)?['hidden'] == true,
      'EVENT' => (r['event'] as Map<String, dynamic>?)?['hidden'] == true,
      _ => false,
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

  /// True once a listing was hidden or restored, so the list behind the
  /// dialog reloads even if the report itself is left undecided.
  bool _changed = false;

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

  /// Hiding asks for the reason the gym's staff will see; restoring does not.
  Future<void> _setHidden(bool hide) async {
    String? reason;
    if (hide) {
      reason = await showDialog<String>(
        context: context,
        builder: (_) => _HideReasonDialog(
          isEvent: _report?['target'] == 'EVENT',
        ),
      );
      if (reason == null || !mounted) return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });
    final api = context.read<AuthController>().api;
    try {
      await api.setListingHidden(widget.reportId, hidden: hide, reason: reason);
      _changed = true;
      // Reload rather than patch locally: the detail carries the reason the
      // server recorded, which is what gets shown.
      final r = await api.reportDetail(widget.reportId);
      if (mounted) {
        setState(() {
          _report = r;
          _busy = false;
        });
      }
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _error = e.message;
          _busy = false;
        });
      }
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
            onPressed: () => Navigator.of(context).pop(_changed),
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
    final target = r['target'] as String? ?? 'USER';
    final listing = switch (target) {
      'GYM' => r['gym'] as Map<String, dynamic>?,
      'EVENT' => r['event'] as Map<String, dynamic>?,
      _ => null,
    };
    final hidden = listing?['hidden'] == true;
    final details = r['details'] as String? ?? '';

    return AlertDialog(
      title: Text('${_subject(r)} · '
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
              if (target != 'USER')
                // The account a ban would fall on: the gym's owner, or
                // whoever created the event.
                Text(
                  'Answerable: ${reported?['name'] ?? ''} '
                  '(${target == 'GYM' ? 'owner' : 'created the event'})',
                  style: theme.textTheme.bodySmall,
                ),
              const SizedBox(height: 12),

              Text('What the reporter says', style: theme.textTheme.labelLarge),
              const SizedBox(height: 4),
              Text(details.isEmpty
                  ? '(nothing written: the category is the report)'
                  : details),
              const SizedBox(height: 16),

              if (listing != null) ...[
                _ListingPreview(target: target, listing: listing),
                const SizedBox(height: 8),
                if (hidden)
                  Text(
                    'Hidden from the public: ${listing['hiddenReason'] ?? ''}',
                    style: TextStyle(
                      color: theme.colorScheme.error,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                const SizedBox(height: 8),
                if (hidden)
                  OutlinedButton.icon(
                    onPressed: _busy ? null : () => _setHidden(false),
                    icon: const Icon(Icons.visibility),
                    label: Text(
                        target == 'GYM' ? 'Show gym again' : 'Show event again'),
                  )
                else
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: theme.colorScheme.error,
                    ),
                    onPressed: _busy ? null : () => _setHidden(true),
                    icon: const Icon(Icons.visibility_off),
                    label: Text(
                        target == 'GYM' ? 'Hide gym from public' : 'Hide event'),
                  ),
                const SizedBox(height: 16),
              ],

              if (message != null) ...[
                Text('The message', style: theme.textTheme.labelLarge),
                const SizedBox(height: 4),
                // Said outright rather than shown as an empty box, so a
                // reviewer does not think it failed to load. The server's
                // note explains that this desk does not surface bodies --
                // it does not claim they are unreadable anywhere, because
                // they are not.
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
                if (target != 'USER')
                  Text('${context_['otherReportsOfThisListing'] ?? 0} other '
                      'people reported this ${target == 'GYM' ? 'gym' : 'event'}'),
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
          onPressed: _busy ? null : () => Navigator.of(context).pop(_changed),
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

/// Asks for the reason a gym or event is being hidden. The gym's staff see
/// it, on their ranking screen or events list, so it is written for them.
class _HideReasonDialog extends StatefulWidget {
  const _HideReasonDialog({required this.isEvent});
  final bool isEvent;

  @override
  State<_HideReasonDialog> createState() => _HideReasonDialogState();
}

class _HideReasonDialogState extends State<_HideReasonDialog> {
  final _reason = TextEditingController();

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ok = _reason.text.trim().length >= 3;
    return AlertDialog(
      title: Text(widget.isEvent ? 'Hide this event' : 'Hide this gym from public'),
      content: SizedBox(
        width: 420,
        child: TextField(
          controller: _reason,
          autofocus: true,
          maxLength: 300,
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(
            labelText: 'Reason',
            helperText: 'The gym sees this. Keep it factual, e.g. '
                '"Name reported as offensive".',
            helperMaxLines: 2,
            border: OutlineInputBorder(),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: ok
              ? () => Navigator.of(context).pop(_reason.text.trim())
              : null,
          child: const Text('Hide'),
        ),
      ],
    );
  }
}

/// The gym or event as the public saw it, so the reviewer judges the same
/// thing the reporter did.
class _ListingPreview extends StatelessWidget {
  const _ListingPreview({required this.target, required this.listing});

  final String target;
  final Map<String, dynamic> listing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    final images = target == 'GYM'
        ? ((listing['images'] as List?) ?? const []).cast<String>()
        : [if (listing['bannerUrl'] is String) listing['bannerUrl'] as String];

    Widget field(String label, Object? value) {
      final text = value?.toString().trim() ?? '';
      if (text.isEmpty) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text(label, style: muted), Text(text)],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(target == 'GYM' ? 'The gym listing' : 'The event',
              style: theme.textTheme.labelLarge),
          if (images.isNotEmpty) ...[
            const SizedBox(height: 8),
            SizedBox(
              height: 72,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                separatorBuilder: (_, _) => const SizedBox(width: 6),
                itemBuilder: (_, i) => ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    images[i],
                    width: 96,
                    height: 72,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      width: 96,
                      height: 72,
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: const Icon(Icons.broken_image_outlined),
                    ),
                  ),
                ),
              ),
            ),
          ],
          if (target == 'GYM') ...[
            field('Name', listing['name']),
            field('Where', '${listing['district'] ?? ''}, ${listing['state'] ?? ''}'),
            field('Description', listing['description']),
            field('Perks', ((listing['perks'] as List?) ?? const []).join(', ')),
            field('Contact', listing['contactPhone']),
          ] else ...[
            field('Title', listing['title']),
            field('Description', listing['description']),
            field('How to take part', listing['howToParticipate']),
            field('Prize', listing['prize']),
            field('Prize details', listing['prizeDescription']),
          ],
        ],
      ),
    );
  }
}
