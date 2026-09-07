import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/api/api_client.dart';
import '../../l10n/app_localizations.dart';
import '../auth/auth_controller.dart';

/// The Terms and the Privacy Policy, served by the API.
///
/// Fetched rather than bundled, so a change of wording does not need an app
/// release — and so the version somebody is shown is the version the server
/// records them as having accepted. A copy compiled into the app would
/// drift from the one the acceptance is recorded against, which is the one
/// thing this screen must not do.
class LegalPage extends StatefulWidget {
  const LegalPage({super.key});

  @override
  State<LegalPage> createState() => _LegalPageState();
}

class _LegalPageState extends State<LegalPage> {
  List<dynamic>? _documents;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final res = await context.read<AuthController>().api.legalIndex();
      if (mounted) {
        setState(() => _documents = (res['documents'] as List?) ?? const []);
      }
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(t.legalTitle)),
      body: switch ((_documents, _error)) {
        (null, final String e) => Center(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(e, textAlign: TextAlign.center),
                const SizedBox(height: 14),
                FilledButton(onPressed: _load, child: Text(t.tryAgain)),
              ]),
            ),
          ),
        (null, _) => const Center(child: CircularProgressIndicator()),
        (final List<dynamic> docs, _) => ListView(
            children: [
              for (final doc in docs.cast<Map<String, dynamic>>())
                ListTile(
                  leading: const Icon(Icons.article_outlined),
                  title: Text('${doc['title'] ?? doc['slug']}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => _DocumentPage(slug: '${doc['slug']}'),
                    ),
                  ),
                ),
            ],
          ),
      },
    );
  }
}

class _DocumentPage extends StatefulWidget {
  const _DocumentPage({required this.slug});

  final String slug;

  @override
  State<_DocumentPage> createState() => _DocumentPageState();
}

class _DocumentPageState extends State<_DocumentPage> {
  Map<String, dynamic>? _doc;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final doc =
          await context.read<AuthController>().api.legalDocument(widget.slug);
      if (mounted) setState(() => _doc = doc);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final doc = _doc;

    return Scaffold(
      appBar: AppBar(title: Text('${doc?['title'] ?? t.legalTitle}')),
      body: doc == null
          ? Center(
              child: _error == null
                  ? const CircularProgressIndicator()
                  : Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Text(t.legalUnavailable, textAlign: TextAlign.center),
                        const SizedBox(height: 14),
                        FilledButton(
                            onPressed: _load, child: Text(t.tryAgain)),
                      ]),
                    ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              children: [
                SelectableText(
                  '${doc['body'] ?? ''}',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                Text(
                  '${doc['updatedAt'] ?? ''}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
    );
  }
}
