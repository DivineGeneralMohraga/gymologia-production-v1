import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/api/api_client.dart';
import '../../core/config/app_config.dart';
import 'auth_controller.dart';

/// Phone and OTP, the same as every other Gymologia app.
///
/// One account per phone number across all four clients, as the spec asks —
/// what differs is that this one sends `appClient: ADMIN`, and the server
/// refuses at verification unless the number is on the internal staff list.
/// Somebody with a perfectly good member account gets a polite refusal
/// rather than a console.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phone = TextEditingController();
  final _code = TextEditingController();

  String? _challengeId;
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _phone.dispose();
    _code.dispose();
    super.dispose();
  }

  String get _e164 {
    final digits = _phone.text.replaceAll(RegExp(r'\D'), '');
    return '+91$digits';
  }

  Future<void> _sendCode() async {
    final digits = _phone.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 10) {
      setState(() => _error = 'Enter the 10-digit number.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final id = await context.read<AuthController>().requestCode(_e164);
      setState(() => _challengeId = id);
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _verify() async {
    if (_code.text.trim().length < 4) {
      setState(() => _error = 'Enter the code you were sent.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final problem = await context.read<AuthController>().verify(
            challengeId: _challengeId!,
            phone: _e164,
            code: _code.text.trim(),
          );
      if (problem != null && mounted) setState(() => _error = problem);
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onCode = _challengeId != null;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Gymologia HQ',
                    style: theme.textTheme.headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                  'Internal console. Staff accounts only.',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 28),

                TextField(
                  controller: _phone,
                  enabled: !onCode && !_busy,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Phone number',
                    prefixText: '+91 ',
                    border: OutlineInputBorder(),
                  ),
                ),

                if (onCode) ...[
                  const SizedBox(height: 12),
                  TextField(
                    controller: _code,
                    enabled: !_busy,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(8),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Verification code',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _verify(),
                  ),
                ],

                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
                ],

                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _busy ? null : (onCode ? _verify : _sendCode),
                  child: _busy
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(onCode ? 'Sign in' : 'Send code'),
                ),

                if (onCode)
                  TextButton(
                    onPressed: _busy
                        ? null
                        : () => setState(() {
                              _challengeId = null;
                              _code.clear();
                              _error = null;
                            }),
                    child: const Text('Use a different number'),
                  ),

                const SizedBox(height: 24),
                // Which backend this build is pointed at. On a console that
                // can approve verifications and message every user on the
                // platform, "which environment am I in" should never be a
                // guess.
                Text(
                  AppConfig.displayHost +
                      (AppConfig.isCleartext ? '  ·  insecure http' : ''),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppConfig.isCleartext
                        ? theme.colorScheme.error
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
