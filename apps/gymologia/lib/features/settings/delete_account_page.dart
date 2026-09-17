import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../core/api/api_client.dart';
import '../../core/api/gym_api.dart';
import '../auth/auth_controller.dart';

/// Deleting your account.
///
/// Required by Google Play of any app that lets people sign up, and the
/// version of it that satisfies a reviewer is not the version that serves a
/// person. Three things this screen does that a bare confirm dialog would
/// not:
///
/// * It asks the server what deletion would actually cost BEFORE drawing the
///   button. Somebody who owns a gym, or has money they have not withdrawn,
///   finds out first rather than being refused afterwards.
/// * It says what survives. Payment rows are kept because the law requires
///   books of account, and a screen implying everything vanishes would be
///   promising something the code does not do.
/// * It shows the thirty-day date and a way back. The decision is often made
///   in a bad moment, and the way back is the whole point of the delay.
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
  bool _acknowledgedEarnings = false;

  GymApi get _api => GymApi(context.read<AuthController>().client);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final preview = await _api.deletionPreview();
      if (!mounted) return;
      setState(() {
        _preview = preview;
        final when = preview['alreadyScheduledFor'];
        _scheduledFor = when is String ? DateTime.tryParse(when)?.toLocal() : null;
        _error = null;
      });
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    }
  }

  Future<void> _request() async {
    setState(() => _busy = true);
    try {
      final result = await _api.requestDeletion();
      if (!mounted) return;
      final when = result['scheduledFor'];
      setState(() {
        _scheduledFor = when is String ? DateTime.tryParse(when)?.toLocal() : null;
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

  Future<void> _cancel() async {
    final t = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      await _api.cancelDeletion();
      if (!mounted) return;
      setState(() {
        _scheduledFor = null;
        _busy = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t.deletionCancelled)));
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = e.message;
      });
    }
  }

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
    if (agreed == true) await _request();
  }

  String _rupees(int paise) => '₹${(paise / 100).toStringAsFixed(2)}';

  String _date(DateTime d) => '${d.day}/${d.month}/${d.year}';

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final preview = _preview;

    return Scaffold(
      appBar: AppBar(title: Text(t.deleteAccount)),
      body: _error != null && preview == null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Text(_error!, textAlign: TextAlign.center),
              ),
            )
          : preview == null
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
                  children: [
                    if (_scheduledFor != null) ...[
                      // Already asked. The only thing this screen owes them
                      // now is the date and a way out of it.
                      _Card(
                        tone: _Tone.warning,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t.deletionScheduled(_date(_scheduledFor!)),
                              style: theme.textTheme.titleSmall,
                            ),
                            const SizedBox(height: 8),
                            Text(t.deleteAccountIntro),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _busy ? null : _cancel,
                          child: Text(t.keepMyAccount),
                        ),
                      ),
                    ] else ...[
                      Text(t.deleteAccountIntro,
                          style: theme.textTheme.bodyLarge),
                      const SizedBox(height: 20),

                      ..._blockers(t, theme),
                      ..._earningsWarning(t, theme, preview),

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
                            // The honest half. Saying only what disappears
                            // would be a promise the server does not keep.
                            Text(t.whatIsKept,
                                style: theme.textTheme.titleSmall),
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
                          onPressed: _canDelete(preview) && !_busy
                              ? _confirm
                              : null,
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
                      Text(
                        _error!,
                        style: TextStyle(color: theme.colorScheme.error),
                      ),
                    ],
                  ],
                ),
    );
  }

  /// Owning a gym stops it outright; unacknowledged earnings stop it until
  /// the box is ticked.
  bool _canDelete(Map<String, dynamic> preview) {
    final blockers = preview['blockers'];
    if (blockers is List && blockers.isNotEmpty) return false;
    return _acknowledgedEarnings || _unwithdrawnPaise(preview) == 0;
  }

  int _unwithdrawnPaise(Map<String, dynamic> preview) {
    final lose = preview['willLose'];
    if (lose is! Map) return 0;
    final paise = lose['unwithdrawnPaise'];
    return paise is int ? paise : 0;
  }

  List<Widget> _blockers(AppLocalizations t, ThemeData theme) {
    final blockers = _preview?['blockers'];
    if (blockers is! List || blockers.isEmpty) return const [];
    return [
      _Card(
        tone: _Tone.error,
        child: Text(t.deleteGymsFirst),
      ),
      const SizedBox(height: 12),
    ];
  }

  List<Widget> _earningsWarning(
    AppLocalizations t,
    ThemeData theme,
    Map<String, dynamic> preview,
  ) {
    final paise = _unwithdrawnPaise(preview);
    if (paise == 0) return const [];
    return [
      _Card(
        tone: _Tone.warning,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.unwithdrawnWarning(_rupees(paise))),
            // A tick, not a line of small print. Deletion is never refused
            // over this -- payouts are not working yet, and refusing would
            // make the account impossible to delete, which is the exact
            // thing Play requires. So the money is named and acknowledged
            // instead of quietly taken.
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              value: _acknowledgedEarnings,
              onChanged: (v) =>
                  setState(() => _acknowledgedEarnings = v ?? false),
              title: Text(t.iUnderstandLoseEarnings),
            ),
          ],
        ),
      ),
      const SizedBox(height: 12),
    ];
  }
}

enum _Tone { plain, warning, error }

class _Card extends StatelessWidget {
  const _Card({required this.child, this.tone = _Tone.plain});

  final Widget child;
  final _Tone tone;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final background = switch (tone) {
      _Tone.plain => scheme.surfaceContainerHighest,
      _Tone.warning => scheme.tertiaryContainer,
      _Tone.error => scheme.errorContainer,
    };
    final foreground = switch (tone) {
      _Tone.plain => scheme.onSurface,
      _Tone.warning => scheme.onTertiaryContainer,
      _Tone.error => scheme.onErrorContainer,
    };

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
