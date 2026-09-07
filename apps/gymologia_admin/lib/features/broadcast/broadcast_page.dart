import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/api/api_client.dart';
import '../auth/auth_controller.dart';

/// Platform-wide announcements.
///
/// The audience is sized BEFORE the button is offered, and the send carries
/// that number back. If the real audience has changed in between, the
/// server refuses rather than quietly messaging a different set of people
/// than the one that was agreed to — so this screen never sends without
/// having shown a count first.
///
/// A gym's own announcement is a separate path on the server, not a flag on
/// this one, so a wrong parameter here cannot turn a message to one gym
/// into a message to everybody.
class BroadcastPage extends StatefulWidget {
  const BroadcastPage({super.key});

  @override
  State<BroadcastPage> createState() => _BroadcastPageState();
}

class _BroadcastPageState extends State<BroadcastPage> {
  static const audiences = <String, String>{
    'ALL_MEMBERS': 'Members',
    'ALL_OWNERS': 'Gym owners',
    'ALL_STAFF': 'Gym staff',
    'ALL_REFERRERS': 'Referrers',
    'EVERYONE': 'Everyone',
  };

  final _title = TextEditingController();
  final _body = TextEditingController();

  String _audience = 'ALL_MEMBERS';
  int? _size;
  bool _sizing = false;
  bool _sending = false;
  String? _error;
  List<dynamic>? _history;

  @override
  void initState() {
    super.initState();
    _size0();
    _loadHistory();
  }

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  Future<void> _size0() async {
    setState(() {
      _sizing = true;
      _size = null;
      _error = null;
    });
    try {
      final n = await context.read<AuthController>().api.audienceSize(_audience);
      if (mounted) setState(() => _size = n);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _sizing = false);
    }
  }

  Future<void> _loadHistory() async {
    try {
      final h = await context.read<AuthController>().api.broadcastHistory();
      if (mounted) setState(() => _history = h);
    } on ApiException {
      // The composer still works without the history; nothing to shout about.
    }
  }

  Future<void> _send() async {
    final size = _size;
    if (size == null) return;
    if (_title.text.trim().isEmpty || _body.text.trim().isEmpty) {
      setState(() => _error = 'A title and a message, please.');
      return;
    }

    // Captured before the dialog: `context.read` after an await is reading
    // a BuildContext that may belong to a widget already gone.
    final api = context.read<AuthController>().api;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Send to everyone in this audience?'),
        content: Text(
          'This reaches $size ${size == 1 ? 'person' : 'people'} '
          '(${audiences[_audience]}). It cannot be unsent.',
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text('Send to $size')),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() {
      _sending = true;
      _error = null;
    });
    try {
      await api.broadcast(
            title: _title.text.trim(),
            body: _body.text.trim(),
            audience: _audience,
            // The count that was shown is the count that goes out. A stale
            // one is refused by the server rather than silently sent.
            expectedRecipients: size,
          );
      if (!mounted) return;
      _title.clear();
      _body.clear();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Sent to $size.')));
      _loadHistory();
      _size0();
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ready = _size != null && !_sizing && !_sending;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('New announcement',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  initialValue: _audience,
                  decoration: const InputDecoration(
                      labelText: 'Audience', border: OutlineInputBorder()),
                  items: [
                    for (final e in audiences.entries)
                      DropdownMenuItem(value: e.key, child: Text(e.value)),
                  ],
                  onChanged: _sending
                      ? null
                      : (v) {
                          if (v == null) return;
                          setState(() => _audience = v);
                          _size0();
                        },
                ),
                const SizedBox(height: 8),
                Text(
                  _sizing
                      ? 'Counting…'
                      : _size == null
                          ? 'Audience size unknown — cannot send.'
                          : 'Reaches $_size ${_size == 1 ? 'person' : 'people'}.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _title,
                  enabled: !_sending,
                  decoration: const InputDecoration(
                      labelText: 'Title', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _body,
                  enabled: !_sending,
                  minLines: 3,
                  maxLines: 6,
                  decoration: const InputDecoration(
                      labelText: 'Message', border: OutlineInputBorder()),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 10),
                  Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
                ],
                const SizedBox(height: 14),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.icon(
                    // Deliberately disabled until a count exists: the server
                    // will not accept a send without one, and a button that
                    // fails on press is worse than a button that waits.
                    onPressed: ready ? _send : null,
                    icon: _sending
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.campaign_outlined),
                    label: Text(_size == null ? 'Send' : 'Send to $_size'),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text('Already announced',
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        if (_history == null)
          const Center(child: Padding(
              padding: EdgeInsets.all(16), child: CircularProgressIndicator()))
        else if (_history!.isEmpty)
          const Text('Nothing has been sent yet.')
        else
          for (final n in _history!.cast<Map<String, dynamic>>())
            Card(
              child: ListTile(
                title: Text('${n['title'] ?? ''}'),
                subtitle: Text(
                  '${n['audience'] ?? ''}  ·  '
                  'reached ${n['sentTo'] ?? n['recipientCount'] ?? '?'}',
                ),
              ),
            ),
      ],
    );
  }
}
