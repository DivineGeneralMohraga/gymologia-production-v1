import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../core/api/api_client.dart';
import '../../core/api/gym_api.dart';
import '../auth/auth_controller.dart';

/// The way back.
///
/// A block is made in the middle of something and never announced, which
/// means there is no other thread to find it in later. Without this screen
/// a block would be permanent in practice — you could not see who you had
/// blocked, let alone undo it.
///
/// Reports are listed underneath for a different reason: a report that
/// vanishes without trace reads as ignored, and somebody who thinks
/// nothing happened is somebody who will not report the next thing.
class BlockedAccountsPage extends StatefulWidget {
  const BlockedAccountsPage({super.key});

  @override
  State<BlockedAccountsPage> createState() => _BlockedAccountsPageState();
}

class _BlockedAccountsPageState extends State<BlockedAccountsPage> {
  List<Map<String, dynamic>>? _blocks;
  List<Map<String, dynamic>>? _reports;
  String? _error;

  GymApi get _api => GymApi(context.read<AuthController>().client);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      // Together: two independent reads, and waiting for them in sequence
      // shows a spinner for twice as long for no reason.
      final results = await Future.wait([_api.myBlocks(), _api.myReports()]);
      if (!mounted) return;
      setState(() {
        _blocks = results[0];
        _reports = results[1];
        _error = null;
      });
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    }
  }

  Future<void> _unblock(Map<String, dynamic> person) async {
    final t = AppLocalizations.of(context);
    final name = person['name'] as String? ?? '';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(t.unblockQuestion(name)),
        content: Text(t.unblockExplainer),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(t.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(t.unblock),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await _api.unblockUser(person['userId'] as String);
      if (!mounted) return;
      // Removed here rather than reloaded, so the row disappears the
      // instant it is confirmed on a slow connection.
      setState(() => _blocks = [..._blocks!]..remove(person));
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  String _statusLabel(AppLocalizations t, String? status) => switch (status) {
        'REVIEWING' => t.reportStatusReviewing,
        'ACTIONED' => t.reportStatusActioned,
        'DISMISSED' => t.reportStatusDismissed,
        _ => t.reportStatusOpen,
      };

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final blocks = _blocks;
    final reports = _reports;

    return Scaffold(
      appBar: AppBar(title: Text(t.safetyAndPrivacy)),
      body: _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Text(_error!, textAlign: TextAlign.center),
              ),
            )
          : blocks == null
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 24),
                    children: [
                      _SectionLabel(t.blockedAccounts),
                      if (blocks.isEmpty)
                        _Empty(t.noBlockedAccounts)
                      else
                        for (final person in blocks)
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  theme.colorScheme.surfaceContainerHighest,
                              child: Text(
                                ((person['name'] as String?) ?? '?')
                                    .characters
                                    .first
                                    .toUpperCase(),
                              ),
                            ),
                            title: Text(person['name'] as String? ?? ''),
                            subtitle: person['reason'] == null
                                ? null
                                : Text(person['reason'] as String),
                            trailing: TextButton(
                              onPressed: () => _unblock(person),
                              child: Text(t.unblock),
                            ),
                          ),

                      _SectionLabel(t.myReports),
                      if (reports == null || reports.isEmpty)
                        _Empty(t.noReportsSent)
                      else
                        for (final report in reports)
                          ListTile(
                            leading: const Icon(Icons.flag_outlined),
                            title: Text(report['about'] as String? ?? ''),
                            subtitle: Text(
                              _statusLabel(t, report['status'] as String?),
                            ),
                          ),
                    ],
                  ),
                ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Text(
        label.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
      child: Text(
        message,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
