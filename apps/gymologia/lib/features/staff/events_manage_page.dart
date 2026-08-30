import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/api/api_client.dart';
import '../../core/api/gym_api.dart';
import '../../core/api/models.dart';
import '../auth/auth_controller.dart';

/// Events this gym hosts, and the form to add one.
class EventsManagePage extends StatefulWidget {
  const EventsManagePage({super.key, required this.gym});

  final GymDetail gym;

  @override
  State<EventsManagePage> createState() => _EventsManagePageState();
}

class _EventsManagePageState extends State<EventsManagePage> {
  List<Map<String, dynamic>>? _events;
  String? _error;

  GymApi get _api => GymApi(context.read<AuthController>().client);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final events = await _api.gymEvents(widget.gym.id);
      if (mounted) setState(() => _events = events);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    }
  }

  Future<void> _host() async {
    final created = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _HostEventSheet(gym: widget.gym, api: _api),
    );
    if (created == true) await _load();
  }

  Future<void> _showParticipants(Map<String, dynamic> event) async {
    try {
      final data =
          await _api.eventParticipants(widget.gym.id, event['id'] as String);
      final people =
          ((data['participants'] as List?) ?? const []).cast<Map<String, dynamic>>();

      if (!mounted) return;
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (ctx) => DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          builder: (_, controller) => ListView(
            controller: controller,
            padding: const EdgeInsets.all(20),
            children: [
              Text('${people.length} signed up',
                  style: Theme.of(ctx)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              if (people.isEmpty)
                Text('Nobody yet.',
                    style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(ctx).colorScheme.onSurfaceVariant,
                        ))
              else
                for (final p in people)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      child: Text((p['name'] as String? ?? '?')
                          .characters
                          .first
                          .toUpperCase()),
                    ),
                    title: Text(p['name'] as String? ?? ''),
                    subtitle: Text(p['phone'] as String? ?? ''),
                  ),
            ],
          ),
        ),
      );
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
    final events = _events;

    return Scaffold(
      appBar: AppBar(title: const Text('Events')),
      floatingActionButton: widget.gym.can(P.hostEvents)
          ? FloatingActionButton.extended(
              onPressed: _host,
              icon: const Icon(Icons.add),
              label: const Text('Host an event'),
            )
          : null,
      body: _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Text(_error!, textAlign: TextAlign.center),
              ),
            )
          : events == null
              ? const Center(child: CircularProgressIndicator())
              : events.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text(
                          'No events yet. Host one and it will show up for your '
                          'members straight away.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            height: 1.5,
                          ),
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                        itemCount: events.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (_, i) {
                          final e = events[i];
                          final open = e['registrationOpen'] == true;
                          return Card(
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              title: Text(e['title'] as String? ?? '',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 6),
                                  Text(
                                    '${e['participantCount'] ?? 0} signed up  ·  '
                                    '${open ? 'registration open' : 'registration closed'}',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        e['publicListing'] == true
                                            ? Icons.public
                                            : Icons.lock_outline,
                                        size: 13,
                                        color: theme.colorScheme.onSurfaceVariant,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        e['publicListing'] == true
                                            ? 'Listed publicly'
                                            : 'Your members only',
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color:
                                              theme.colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () => _showParticipants(e),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}

class _HostEventSheet extends StatefulWidget {
  const _HostEventSheet({required this.gym, required this.api});

  final GymDetail gym;
  final GymApi api;

  @override
  State<_HostEventSheet> createState() => _HostEventSheetState();
}

class _HostEventSheetState extends State<_HostEventSheet> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _howTo = TextEditingController();
  final _prize = TextEditingController();

  DateTime? _startsAt;
  DateTime? _registrationLastDate;
  bool _membersCanParticipate = true;
  bool _publicListing = true;
  bool _allowNonMembers = false;
  bool _busy = false;
  String? _error;

  bool get _isPro => widget.gym.plan == 'PRO';

  @override
  void dispose() {
    for (final c in [_title, _description, _howTo, _prize]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickStart() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 730)),
      initialDate: _startsAt ?? now.add(const Duration(days: 14)),
      helpText: 'When does it start?',
    );
    if (date == null) return;
    if (!mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );
    if (!mounted) return;

    setState(() {
      _startsAt = DateTime(
        date.year, date.month, date.day,
        time?.hour ?? 9, time?.minute ?? 0,
      );
      // Registration closing the day before is the sane default, and the
      // server refuses anything after the start anyway.
      _registrationLastDate ??= date.subtract(const Duration(days: 1));
    });
  }

  Future<void> _pickRegistrationClose() async {
    final start = _startsAt;
    if (start == null) {
      setState(() => _error = 'Choose the start date first.');
      return;
    }
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: start,
      initialDate: _registrationLastDate ?? start.subtract(const Duration(days: 1)),
      helpText: 'Last day to register',
    );
    if (date != null) setState(() => _registrationLastDate = date);
  }

  Future<void> _submit() async {
    if (_title.text.trim().length < 3) {
      setState(() => _error = 'Give the event a title.');
      return;
    }
    if (_description.text.trim().length < 10) {
      setState(() => _error = 'Add a description, at least a sentence.');
      return;
    }
    if (_howTo.text.trim().length < 5) {
      setState(() => _error = 'Say what someone has to do to take part.');
      return;
    }
    if (_startsAt == null || _registrationLastDate == null) {
      setState(() => _error = 'Pick the dates.');
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      final result = await widget.api.hostEvent(widget.gym.id, {
        'title': _title.text.trim(),
        'description': _description.text.trim(),
        'howToParticipate': _howTo.text.trim(),
        if (_prize.text.trim().isNotEmpty) 'prize': _prize.text.trim(),
        'registrationLastDate': _ymd(_registrationLastDate!),
        'startsAt': _startsAt!.toUtc().toIso8601String(),
        // A single-session event: ends the same day.
        'endsAt': _startsAt!
            .add(const Duration(hours: 8))
            .toUtc()
            .toIso8601String(),
        'membersCanParticipate': _membersCanParticipate,
        'publicListing': _publicListing,
        'allowNonMembers': _allowNonMembers,
      });

      if (!mounted) return;
      final note = result['listingNote'] as String?;
      Navigator.of(context).pop(true);
      if (note != null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(note), duration: const Duration(seconds: 6)));
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        24, 20, 24, MediaQuery.of(context).viewInsets.bottom + 28,
      ),
      child: SingleChildScrollView(
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
            Text('Host an event',
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 18),

            TextField(
              controller: _title,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Summer Deadlift Meet',
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _description,
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _howTo,
              maxLines: 2,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'How to take part',
                hintText: 'Weigh-in at 8am. Bring your own belt.',
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _prize,
              decoration: const InputDecoration(
                labelText: 'Prize (optional)',
                hintText: 'Rs 10,000',
              ),
            ),

            const SizedBox(height: 18),
            OutlinedButton.icon(
              onPressed: _pickStart,
              icon: const Icon(Icons.calendar_today_outlined, size: 18),
              label: Text(_startsAt == null
                  ? 'When does it start?'
                  : 'Starts ${_pretty(_startsAt!)}'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _pickRegistrationClose,
              icon: const Icon(Icons.how_to_reg_outlined, size: 18),
              label: Text(_registrationLastDate == null
                  ? 'Last day to register'
                  : 'Register by ${_pretty(_registrationLastDate!, time: false)}'),
            ),

            const SizedBox(height: 12),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _membersCanParticipate,
              onChanged: (v) => setState(() => _membersCanParticipate = v),
              title: const Text('Members can sign up in the app'),
              subtitle: const Text(
                  'Turn off and they see your requirements instead of a button.'),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _publicListing && _isPro,
              onChanged: _isPro
                  ? (v) => setState(() {
                        _publicListing = v;
                        if (!v) _allowNonMembers = false;
                      })
                  : null,
              title: const Text('List publicly'),
              subtitle: Text(_isPro
                  ? 'Shows in the events feed across the country.'
                  : 'Pro plan only. Your members will still see it.'),
            ),
            if (_publicListing && _isPro)
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: _allowNonMembers,
                onChanged: (v) => setState(() => _allowNonMembers = v),
                title: const Text('Open to people outside your gym'),
              ),

            if (_error != null) ...[
              const SizedBox(height: 12),
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
                      child: CircularProgressIndicator(strokeWidth: 2.5))
                  : const Text('Publish event'),
            ),
          ],
        ),
      ),
    );
  }
}

const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

String _pretty(DateTime d, {bool time = true}) {
  final date = '${d.day} ${_months[d.month - 1]}';
  if (!time) return date;
  final h = d.hour.toString().padLeft(2, '0');
  final m = d.minute.toString().padLeft(2, '0');
  return '$date at $h:$m';
}

String _ymd(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';
