import 'package:flutter/material.dart';
import '../../core/utils/dates.dart';
import '../../l10n/app_localizations.dart';
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
      setState(() => _error = AppLocalizations.of(context).giveItATitle);
      return;
    }
    if (_body.text.trim().length < 3) {
      setState(() =>
          _error = AppLocalizations.of(context).sayWhatYouWantThemToKnow);
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context).sendThis),
        content: Text(
          AppLocalizations.of(context).announceGoesTo(switch (_audience) {
            'GYM_MEMBERS' => AppLocalizations.of(context).audienceEveryMember,
            'GYM_STAFF' => AppLocalizations.of(context).audienceEveryStaff,
            _ => AppLocalizations.of(context).audienceEveryone,
          }),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(AppLocalizations.of(context).cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(AppLocalizations.of(context).send),
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
        SnackBar(
            content: Text(AppLocalizations.of(context)
                .sentToPeople((result['sentTo'] as int?) ?? 0))),
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
      appBar: AppBar(title: Text(AppLocalizations.of(context).announcements)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        children: [
          TextField(
            controller: _title,
            textCapitalization: TextCapitalization.sentences,
            maxLength: 150,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context).title,
              hintText: AppLocalizations.of(context).announceTitleHint,
              counterText: '',
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _body,
            maxLines: 4,
            maxLength: 2000,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context).message,
              hintText: AppLocalizations.of(context).announceBodyHint,
            ),
          ),
          const SizedBox(height: 10),
          Text(AppLocalizations.of(context).whoSeesIt.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                letterSpacing: 0.8,
                color: theme.colorScheme.onSurfaceVariant,
              )),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: [
              ButtonSegment(value: 'GYM_EVERYONE', label: Text(AppLocalizations.of(context).everyone)),
              ButtonSegment(value: 'GYM_MEMBERS', label: Text(AppLocalizations.of(context).members)),
              ButtonSegment(value: 'GYM_STAFF', label: Text(AppLocalizations.of(context).staff)),
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
                : Text(AppLocalizations.of(context).sendAnnouncement),
          ),

          if (sent != null && sent.isNotEmpty) ...[
            const SizedBox(height: 34),
            Text(AppLocalizations.of(context).sent.toUpperCase(),
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
                    '${AppLocalizations.of(context).recipientCount((n['sentTo'] as int?) ?? 0)}'
                    '  ·  '
                    '${Dates.ago(AppLocalizations.of(context), n['sentAt'] as String?)}',
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}


