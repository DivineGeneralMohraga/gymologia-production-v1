import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../core/api/api_client.dart';
import '../../core/api/gym_api.dart';
import '../auth/auth_controller.dart';

/// DPDP Act 2023 Section 12(a) — the Data Principal's right to see the
/// personal data held about them. Fetches the full export and shows it as
/// readable JSON with a copy-to-clipboard action, so a person can save or
/// forward it without the app needing a file-sharing dependency.
class DataExportPage extends StatefulWidget {
  const DataExportPage({super.key});

  @override
  State<DataExportPage> createState() => _DataExportPageState();
}

class _DataExportPageState extends State<DataExportPage> {
  Map<String, dynamic>? _data;
  String? _error;
  bool _loading = true;

  GymApi get _api => GymApi(context.read<AuthController>().client);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await _api.exportMyData();
      if (mounted) setState(() => _data = data);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String get _pretty =>
      const JsonEncoder.withIndent('  ').convert(_data ?? {});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.downloadMyData),
        actions: [
          if (_data != null)
            IconButton(
              icon: const Icon(Icons.copy_outlined),
              tooltip: t.copyToClipboard,
              onPressed: () {
                Clipboard.setData(ClipboardData(text: _pretty));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(t.copiedToClipboard(t.yourData))),
                );
              },
            ),
        ],
      ),
      body: _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_error!, textAlign: TextAlign.center),
                    const SizedBox(height: 18),
                    FilledButton.tonal(
                      onPressed: _load,
                      child: Text(t.tryAgain),
                    ),
                  ],
                ),
              ),
            )
          : _loading || _data == null
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      t.downloadMyDataHint,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SelectableText(
                        _pretty,
                        style: const TextStyle(
                            fontFamily: 'monospace', fontSize: 12, height: 1.5),
                      ),
                    ),
                  ],
                ),
    );
  }
}
