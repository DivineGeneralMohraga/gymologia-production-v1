import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/api/api_client.dart';
import '../../core/config/app_config.dart';
import '../auth/auth_controller.dart';
import '../../theme.dart';

/// Connectivity check, reachable from the login screen.
///
/// This exists because "the app does not work" and "the server is not
/// running" look identical from the outside. One tap here separates them,
/// and prints the exact command to rebuild against a different backend.
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
            _Row(label: 'API base URL', value: AppConfig.apiBaseUrl),
            _Row(label: 'Host', value: AppConfig.displayHost),
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
            const SizedBox(height: 32),
            Text('Point this build somewhere else',
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(
              'The base URL is fixed at build time. Rebuild with one of these:',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 12),
            const _Command(
              label: 'AWS server',
              command:
                  'flutter run --dart-define=API_BASE_URL=https://api.gymologia.com/api/v1',
            ),
            const _Command(
              label: 'Android emulator → your laptop',
              command:
                  'flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000/api/v1',
            ),
            const _Command(
              label: 'Physical phone → your laptop on the same wifi',
              command:
                  'flutter run --dart-define=API_BASE_URL=http://<LAPTOP-LAN-IP>:3000/api/v1',
            ),
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

class _Command extends StatelessWidget {
  const _Command({required this.label, required this.command});
  final String label;
  final String command;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: theme.textTheme.labelMedium
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          const SizedBox(height: 4),
          InkWell(
            onTap: () {
              Clipboard.setData(ClipboardData(text: command));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Command copied')),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                command,
                style: const TextStyle(
                    fontFamily: 'monospace', fontSize: 12, height: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
