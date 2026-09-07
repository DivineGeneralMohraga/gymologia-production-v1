import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/api/api_client.dart';
import '../../core/config/app_config.dart';
import '../../l10n/app_localizations.dart';
import '../auth/auth_controller.dart';

/// Raise a ticket, and see the ones already raised.
///
/// The reply-to phone number is the one on the account and is not a field:
/// the ticket is filed by an authenticated caller, so asking them to type a
/// number is asking for a typo in the only way support has of reaching
/// them. The email is optional and comes from the profile.
class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final _subject = TextEditingController();
  final _message = TextEditingController();

  List<dynamic>? _tickets;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTickets();
  }

  @override
  void dispose() {
    _subject.dispose();
    _message.dispose();
    super.dispose();
  }

  Future<void> _loadTickets() async {
    try {
      final rows = await context.read<AuthController>().api.myTickets();
      if (mounted) setState(() => _tickets = rows);
    } on ApiException {
      // The form still works without the history behind it.
      if (mounted) setState(() => _tickets = const []);
    }
  }

  Future<void> _send() async {
    final t = AppLocalizations.of(context);
    final subject = _subject.text.trim();
    final message = _message.text.trim();

    // The server's own limits, so a refusal does not arrive after the send.
    if (subject.length < 3) {
      setState(() => _error = t.supportTooShort);
      return;
    }
    if (message.length < 10) {
      setState(() => _error = t.supportTooShort);
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });
    final auth = context.read<AuthController>();
    final messenger = ScaffoldMessenger.of(context);
    try {
      await auth.api.raiseTicket(
        subject: subject,
        message: message,
        contactPhone: auth.phone,
        contactEmail: auth.email,
      );
      if (!mounted) return;
      _subject.clear();
      _message.clear();
      messenger.showSnackBar(SnackBar(content: Text(t.supportSent)));
      _loadTickets();
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tickets = _tickets;

    return Scaffold(
      appBar: AppBar(title: Text(t.supportTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(t.supportBody, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 16),
          TextField(
            controller: _subject,
            enabled: !_busy,
            decoration: InputDecoration(
                labelText: t.supportSubject, border: const OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _message,
            enabled: !_busy,
            minLines: 4,
            maxLines: 8,
            decoration: InputDecoration(
                labelText: t.supportMessage, border: const OutlineInputBorder()),
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
          ],
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _busy ? null : _send,
            child: _busy
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : Text(t.supportSend),
          ),
          const SizedBox(height: 12),
          Text(
            t.supportEmailLine(AppConfig.supportEmail),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (tickets != null && tickets.isNotEmpty) ...[
            const Divider(height: 40),
            for (final ticket in tickets.cast<Map<String, dynamic>>())
              Card(
                child: ListTile(
                  title: Text('${ticket['subject'] ?? ''}'),
                  subtitle: Text('${ticket['status'] ?? ''}'),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
