import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/api/api_client.dart';
import '../../core/api/gym_api.dart';
import '../auth/auth_controller.dart';

/// Terms of Use and Privacy Policy.
///
/// Fetched from the server rather than compiled into the app, so a wording
/// change does not have to wait for an app store review.
class LegalPage extends StatefulWidget {
  const LegalPage({super.key, this.initialSlug = 'terms'});

  final String initialSlug;

  @override
  State<LegalPage> createState() => _LegalPageState();
}

class _LegalPageState extends State<LegalPage> {
  late String _slug = widget.initialSlug;
  final Map<String, Map<String, dynamic>> _cache = {};
  String? _error;
  bool _loading = false;

  GymApi get _api => GymApi(context.read<AuthController>().client);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (_cache.containsKey(_slug)) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final doc = await _api.legalDocument(_slug);
      if (mounted) setState(() => _cache[_slug] = doc);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _switchTo(String slug) {
    setState(() => _slug = slug);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final doc = _cache[_slug];

    return Scaffold(
      appBar: AppBar(title: const Text('Terms & Privacy')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'terms', label: Text('Terms of Use')),
                ButtonSegment(value: 'privacy', label: Text('Privacy')),
              ],
              selected: {_slug},
              onSelectionChanged: (selection) => _switchTo(selection.first),
            ),
          ),
          Expanded(
            child: _error != null
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
                            child: const Text('Try again'),
                          ),
                        ],
                      ),
                    ),
                  )
                : doc == null || _loading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
                        children: [
                          Text(doc['title'] as String? ?? '',
                              style: theme.textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 4),
                          Text(
                            'Version ${doc['version']} · updated ${doc['updatedAt']}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ..._render(
                            context,
                            doc['body'] as String? ?? '',
                          ),
                        ],
                      ),
          ),
        ],
      ),
    );
  }

  /// The body is plain text: blank lines separate paragraphs, and a line in
  /// all capitals is a heading. Enough structure to read well without
  /// shipping a Markdown parser for two documents.
  List<Widget> _render(BuildContext context, String body) {
    final theme = Theme.of(context);
    final widgets = <Widget>[];

    for (final block in body.split('\n\n')) {
      final text = block.trim().replaceAll('\n', ' ');
      if (text.isEmpty) continue;

      final isHeading = text == text.toUpperCase() &&
          text.length < 80 &&
          RegExp(r'[A-Z]').hasMatch(text);

      widgets.add(
        Padding(
          padding: EdgeInsets.only(top: isHeading ? 22 : 0, bottom: 12),
          child: Text(
            text,
            style: isHeading
                ? theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    color: theme.colorScheme.primary,
                  )
                : theme.textTheme.bodyMedium?.copyWith(height: 1.55),
          ),
        ),
      );
    }
    return widgets;
  }
}
