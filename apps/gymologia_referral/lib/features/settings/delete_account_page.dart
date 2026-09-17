import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/api/api_client.dart';
import '../../core/money.dart';
import '../../l10n/app_localizations.dart';
import '../auth/auth_controller.dart';

/// Deleting your account, from the referral app.
///
/// Play requires this of any app offering account creation, and this one lets
/// anybody in the world sign up, so it applies here as squarely as it does to
/// the member app.
///
/// The case that matters here is money. These are the people with balances,
/// and right now nobody can withdraw at all -- payouts wait on Cashfree
/// Verification. So refusing to delete while a balance exists, which was the
/// first instinct, would leave exactly these accounts permanently
/// undeletable. Instead the amount is named, acknowledged with a tick, and
/// recorded on the deletion row so a later claim can be honoured.
class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  Map<String, dynamic>? _preview;
  DateTime? _scheduledFor;
  String? _error;
  bool _busy = false;
  bool _acknowledged = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final preview =
          await context.read<AuthController>().api.deletionPreview();
      if (!mounted) return;
      setState(() {
        _preview = preview;
        final when = preview['alreadyScheduledFor'];
        _scheduledFor =
            when is String ? DateTime.tryParse(when)?.toLocal() : null;
        _error = null;
      });
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    }
  }

  Future<void> _run(Future<Map<String, dynamic>> Function() call) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final result = await call();
      if (!mounted) return;
      final when = result['scheduledFor'];
      setState(() {
        _scheduledFor =
            when is String ? DateTime.tryParse(when)?.toLocal() : null;
        _busy = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = e.message;
      });
    }
  }

  int get _unwithdrawnPaise {
    final lose = _preview?['willLose'];
    if (lose is! Map) return 0;
    final paise = lose['unwithdrawnPaise'];
    return paise is int ? paise : 0;
  }

  bool get _canDelete => _acknowledged || _unwithdrawnPaise == 0;

  String _date(DateTime d) => '${d.day}/${d.month}/${d.year}';

  Future<void> _confirm() async {
    final t = AppLocalizations.of(context);
    final agreed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(t.deleteAccountConfirm),
        content: Text(t.deleteAccountIntro),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(t.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(dialogContext).colorScheme.error,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(t.deleteAccount),
          ),
        ],
      ),
    );
    if (agreed != true || !mounted) return;
    await _run(() => context.read<AuthController>().api.requestDeletion());
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final preview = _preview;

    return Scaffold(
      appBar: AppBar(title: Text(t.deleteAccount)),
      body: preview == null
          ? Center(
              child: _error != null
                  ? Padding(
                      padding: const EdgeInsets.all(28),
                      child: Text(_error!, textAlign: TextAlign.center),
                    )
                  : const CircularProgressIndicator(),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
              children: [
                if (_scheduledFor != null) ...[
                  _Card(
                    tone: _Tone.warning,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t.deletionScheduled(_date(_scheduledFor!)),
                            style: theme.textTheme.titleSmall),
                        const SizedBox(height: 8),
                        Text(t.deleteAccountIntro),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _busy
                          ? null
                          : () async {
                              // Both grabbed before the await. Reaching back
                              // through `context` afterwards is the lint's
                              // whole point: by then the screen may be gone.
                              final api = context.read<AuthController>().api;
                              final messenger = ScaffoldMessenger.of(context);
                              await _run(api.cancelDeletion);
                              if (!mounted) return;
                              messenger.showSnackBar(
                                SnackBar(content: Text(t.deletionCancelled)),
                              );
                            },
                      child: Text(t.keepMyAccount),
                    ),
                  ),
                ] else ...[
                  Text(t.deleteAccountIntro, style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 20),

                  if (_unwithdrawnPaise > 0) ...[
                    _Card(
                      tone: _Tone.warning,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Formatted through Money like every other amount
                          // in this app, so the figure somebody is agreeing
                          // to lose is shown the same way as the figure they
                          // were told they had earned.
                          Text(t.unwithdrawnWarning(
                              Money.format(_unwithdrawnPaise))),
                          CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            controlAffinity: ListTileControlAffinity.leading,
                            value: _acknowledged,
                            onChanged: (v) =>
                                setState(() => _acknowledged = v ?? false),
                            title: Text(t.iUnderstandLoseEarnings),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  _Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t.whatIsDeleted,
                            style: theme.textTheme.titleSmall),
                        const SizedBox(height: 6),
                        Text(t.whatIsDeletedList),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t.whatIsKept, style: theme.textTheme.titleSmall),
                        const SizedBox(height: 6),
                        Text(t.whatIsKeptList),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: theme.colorScheme.error,
                      ),
                      onPressed: _canDelete && !_busy ? _confirm : null,
                      child: _busy
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2.2),
                            )
                          : Text(t.deleteAccountConfirm),
                    ),
                  ),
                ],

                if (_error != null) ...[
                  const SizedBox(height: 16),
                  Text(_error!,
                      style: TextStyle(color: theme.colorScheme.error)),
                ],
              ],
            ),
    );
  }
}

enum _Tone { plain, warning }

class _Card extends StatelessWidget {
  const _Card({required this.child, this.tone = _Tone.plain});

  final Widget child;
  final _Tone tone;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final background = tone == _Tone.warning
        ? scheme.tertiaryContainer
        : scheme.surfaceContainerHighest;
    final foreground = tone == _Tone.warning
        ? scheme.onTertiaryContainer
        : scheme.onSurface;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DefaultTextStyle.merge(
        style: TextStyle(color: foreground),
        child: child,
      ),
    );
  }
}
