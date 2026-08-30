import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/api/api_client.dart';
import '../../core/api/gym_api.dart';
import '../../core/api/models.dart';
import '../auth/auth_controller.dart';

/// Announcements: what has been sent, and the form to send another.
///
/// Recipients are counted when the announcement goes out, so the history
/// reads as a record of what actually happened rather than what the
/// audience would look like today.
class AnnouncePage extends StatefulWidget {
  const AnnouncePage({super.key, required this.gym});

  final GymDetail gym;

  @override
  State<AnnouncePage> createState() => _AnnouncePageState();
}

class _AnnouncePageState extends State<AnnouncePage> {
  final _title = TextEditingController();
  final _body = TextEditingController();
  String _audience = 'GYM_EVERYONE';
  bool _busy = false;
  String? _error;
  List<Map<String, dynamic>>? _sent;

  GymApi get _api => GymApi(context.read<AuthController>().client);

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final raw = await _api.notificationsSentBy(widget.gym.id);
      if (mounted) setState(() => _sent = raw);
    } on ApiException {
      // The history is secondary; the form still works without it.
    }
  }

  Future<void> _send() async {
    if (_title.text.trim().length < 3) {
      setState(() => _error = 'Give it a title.');
      return;
    }
    if (_body.text.trim().length < 3) {
      setState(() => _error = 'Say what you want them to know.');
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Send this?'),
        content: Text(
          'It goes to ${switch (_audience) {
            'GYM_MEMBERS' => 'every member',
            'GYM_STAFF' => 'every staff member',
            _ => 'everyone at this gym',
          }} right now, and cannot be unsent.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Send'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      final result = await _api.sendNotification(
        widget.gym.id,
        title: _title.text.trim(),
        body: _body.text.trim(),
        audience: _audience,
      );
      if (!mounted) return;
      _title.clear();
      _body.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sent to ${result['sentTo']} people.')),
      );
      setState(() => _busy = false);
      await _load();
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
    final sent = _sent;

    return Scaffold(
      appBar: AppBar(title: const Text('Announcements')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        children: [
          TextField(
            controller: _title,
            textCapitalization: TextCapitalization.sentences,
            maxLength: 150,
            decoration: const InputDecoration(
              labelText: 'Title',
              hintText: 'Closed Sunday for maintenance',
              counterText: '',
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _body,
            maxLines: 4,
            maxLength: 2000,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Message',
              hintText: 'We reopen Monday at 6am. Sorry for the short notice.',
            ),
          ),
          const SizedBox(height: 10),
          Text('WHO SEES IT',
              style: theme.textTheme.labelSmall?.copyWith(
                letterSpacing: 0.8,
                color: theme.colorScheme.onSurfaceVariant,
              )),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'GYM_EVERYONE', label: Text('Everyone')),
              ButtonSegment(value: 'GYM_MEMBERS', label: Text('Members')),
              ButtonSegment(value: 'GYM_STAFF', label: Text('Staff')),
            ],
            selected: {_audience},
            onSelectionChanged: (v) => setState(() => _audience = v.first),
          ),

          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.error)),
          ],

          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: _busy ? null : _send,
            icon: const Icon(Icons.send, size: 18),
            label: _busy
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2.4))
                : const Text('Send announcement'),
          ),

          if (sent != null && sent.isNotEmpty) ...[
            const SizedBox(height: 34),
            Text('SENT',
                style: theme.textTheme.labelSmall?.copyWith(
                  letterSpacing: 0.9,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                )),
            const SizedBox(height: 8),
            for (final n in sent)
              Card(
                elevation: 0,
                color: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.35),
                child: ListTile(
                  title: Text(n['title'] as String? ?? '',
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(
                    '${n['sentTo'] ?? 0} recipient'
                    '${n['sentTo'] == 1 ? '' : 's'}  ·  ${_ago(n['sentAt'])}',
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

String _ago(dynamic iso) {
  final d = iso is String ? DateTime.tryParse(iso) : null;
  if (d == null) return '';
  final diff = DateTime.now().difference(d);
  if (diff.inHours < 1) return '${diff.inMinutes}m ago';
  if (diff.inDays < 1) return '${diff.inHours}h ago';
  return '${diff.inDays}d ago';
}
