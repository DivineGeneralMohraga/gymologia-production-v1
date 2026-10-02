import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/api/api_client.dart';
import '../../core/config/app_config.dart';
import '../auth/auth_controller.dart';
import '../../theme.dart';

/// Connectivity check, reachable from Settings.
///
/// This exists because "the app does not work" and "the server is not
/// running" look identical from the outside. One tap here separates them.
/// It deliberately does not print the server's address.
class DiagnosticsScreen extends StatefulWidget {
  const DiagnosticsScreen({super.key});

  @override
  State<DiagnosticsScreen> createState() => _DiagnosticsScreenState();
}

class _DiagnosticsScreenState extends State<DiagnosticsScreen> {
  bool _running = false;
  String? _result;
  bool _ok = false;

  Future<void> _test() async {
    setState(() {
      _running = true;
      _result = null;
    });

    final client = context.read<AuthController>().client;
    try {
      final elapsed = await client.ping();
      setState(() {
        _ok = true;
        _result = 'Reachable — responded in ${elapsed.inMilliseconds} ms.';
      });
    } on ApiException catch (e) {
      setState(() {
        _ok = false;
        _result = e.message;
      });
    } finally {
      if (mounted) setState(() => _running = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Connection')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _Row(
              label: 'Transport',
              value: AppConfig.isCleartext
                  ? 'HTTP (cleartext)'
                  : 'HTTPS (encrypted)',
            ),
            _Row(label: 'Client', value: AppConfig.appClient),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _running ? null : _test,
              icon: _running
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    )
                  : const Icon(Icons.wifi_tethering),
              label: Text(_running ? 'Testing…' : 'Test connection'),
            ),
            if (_result != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: (_ok ? context.gym.success : theme.colorScheme.error)
                      .withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      _ok ? Icons.check_circle_outline : Icons.error_outline,
                      color: _ok ? context.gym.success : theme.colorScheme.error,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(_result!,
                          style: theme.textTheme.bodyMedium),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ),
          Expanded(
            child: SelectableText(value,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
