import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/api/api_client.dart';
import '../../core/api/gym_api.dart';
import '../../core/config/app_config.dart';
import '../../core/utils/validators.dart';
import '../auth/auth_controller.dart';

/// The support form.
///
/// The request is stored as a ticket rather than only sent as an email, so
/// it cannot vanish into an inbox nobody reads on a Sunday. Past requests
/// are listed underneath, because the most common follow-up is "did my
/// message go through".
class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final _formKey = GlobalKey<FormState>();
  final _subject = TextEditingController();
  final _message = TextEditingController();
  late final TextEditingController _phone;
  bool _urgent = false;
  bool _busy = false;
  String? _error;
  List<Map<String, dynamic>>? _tickets;

  GymApi get _api => GymApi(context.read<AuthController>().client);

  @override
  void initState() {
    super.initState();
    final phone = context.read<AuthController>().user?.phone ?? '';
    _phone = TextEditingController(text: phone.replaceFirst('+91', ''));
    _loadTickets();
  }

  @override
  void dispose() {
    _subject.dispose();
    _message.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _loadTickets() async {
    try {
      final tickets = await _api.myTickets();
      if (mounted) setState(() => _tickets = tickets);
    } on ApiException {
      // The form still works without the history.
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      await _api.createTicket(
        subject: _subject.text.trim(),
        message: _message.text.trim(),
        contactPhone: '+91${_phone.text.trim()}',
        urgent: _urgent,
      );
      if (!mounted) return;
      _subject.clear();
      _message.clear();
      setState(() {
        _urgent = false;
        _busy = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).supportSent)),
      );
      await _loadTickets();
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
    final t = AppLocalizations.of(context);
    final tickets = _tickets;

    return Scaffold(
      appBar: AppBar(title: Text(t.getHelp)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          children: [
            TextFormField(
              controller: _subject,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: t.supportSubject,
                hintText: t.supportSubjectHint,
              ),
              validator: (v) =>
                  (v?.trim().length ?? 0) < 3 ? t.aFewWordsIsEnough : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _message,
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: t.supportMessage,
                alignLabelWithHint: true,
              ),
              validator: (v) =>
                  (v?.trim().length ?? 0) < 10 ? t.aSentenceOrTwoHelps : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              decoration: InputDecoration(
                labelText: t.supportReplyTo,
                prefixText: '+91  ',
              ),
              validator: validateIndianMobile,
            ),
            const SizedBox(height: 6),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: _urgent,
              onChanged: (v) => setState(() => _urgent = v ?? false),
              title: Text(t.supportUrgent),
              subtitle: Text(t.supportUrgentNote),
              controlAffinity: ListTileControlAffinity.leading,
            ),

            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.error)),
            ],

            const SizedBox(height: 16),
            FilledButton(
              onPressed: _busy ? null : _submit,
              child: _busy
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.5))
                  : Text(t.send),
            ),
            const SizedBox(height: 10),
            Center(
              child: TextButton.icon(
                onPressed: () async {
                  await Clipboard.setData(
                      const ClipboardData(text: AppConfig.supportEmail));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(AppLocalizations.of(context)
                              .copiedToClipboard(AppConfig.supportEmail))),
                    );
                  }
                },
                icon: const Icon(Icons.mail_outline, size: 16),
                label: Text(t.orEmailUs(AppConfig.supportEmail)),
              ),
            ),

            if (tickets != null && tickets.isNotEmpty) ...[
              const SizedBox(height: 30),
              Text(t.whatYouHaveAsked.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    letterSpacing: 0.9,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.primary,
                  )),
              const SizedBox(height: 10),
              for (final ticket in tickets)
                Card(
                  elevation: 0,
                  color: theme.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.35),
                  child: ListTile(
                    title: Text(ticket['subject'] as String? ?? '',
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(
                      ticket['resolutionNote'] as String? ??
                          _statusLabel(
                              t, ticket['status'] as String? ?? 'OPEN'),
                    ),
                    trailing: Icon(
                      ticket['status'] == 'RESOLVED' ||
                              ticket['status'] == 'CLOSED'
                          ? Icons.check_circle_outline
                          : Icons.schedule,
                      size: 18,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

String _statusLabel(AppLocalizations t, String status) => switch (status) {
      'OPEN' => t.ticketOpen,
      'IN_PROGRESS' => t.ticketInProgress,
      'WAITING_ON_USER' => t.ticketWaitingOnUser,
      'RESOLVED' => t.ticketResolved,
      'CLOSED' => t.ticketClosed,
      _ => status,
    };
