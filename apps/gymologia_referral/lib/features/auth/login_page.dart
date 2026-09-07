import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/api/api_client.dart';
import '../../core/api/error_text.dart';
import '../../core/config/app_config.dart';
import '../../l10n/app_localizations.dart';
import '../shell/branding.dart';
import 'auth_controller.dart';

/// Phone, then code, then — only for a number with no account — a name.
///
/// One screen with three states rather than three routes, because the back
/// button has to mean "I typed the wrong number", and a Navigator stack
/// makes that a pop that leaves a live OTP challenge behind it.
///
/// Whether a gym owner may sign in is decided by the server, not here.
/// This app cannot know whether the person holding it owns a gym — they may
/// have registered one on the other app an hour ago — so it asks. What it
/// does add is the language: the refusal arrives with a code, and this app
/// has that one sentence in all ten.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

enum _Step { phone, code, register }

class _LoginPageState extends State<LoginPage> {
  final _phone = TextEditingController();
  final _code = TextEditingController();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _age = TextEditingController();

  _Step _step = _Step.phone;
  String? _challengeId;
  String? _registrationToken;
  String? _error;
  bool _busy = false;

  /// Seconds until another code may be asked for. The server rate-limits
  /// this regardless; the countdown is so the button is not offered in a
  /// state where pressing it produces a refusal.
  int _cooldown = 0;
  Timer? _ticker;

  @override
  void dispose() {
    _ticker?.cancel();
    _phone.dispose();
    _code.dispose();
    _name.dispose();
    _email.dispose();
    _age.dispose();
    super.dispose();
  }

  String get _digits => _phone.text.replaceAll(RegExp(r'\D'), '');
  String get _e164 => '+91$_digits';

  void _startCooldown() {
    _ticker?.cancel();
    setState(() => _cooldown = 30);
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return timer.cancel();
      setState(() => _cooldown -= 1);
      if (_cooldown <= 0) timer.cancel();
    });
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await action();
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = apiErrorText(context, e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _sendCode() {
    final t = AppLocalizations.of(context);
    if (_digits.length != 10) {
      setState(() => _error = t.enterTenDigits);
      return Future.value();
    }
    return _run(() async {
      final id = await context.read<AuthController>().requestCode(_e164);
      if (!mounted) return;
      setState(() {
        _challengeId = id;
        _step = _Step.code;
      });
      _startCooldown();
    });
  }

  Future<void> _verify() {
    final t = AppLocalizations.of(context);
    if (_code.text.trim().isEmpty) {
      setState(() => _error = t.enterTheCode);
      return Future.value();
    }
    return _run(() async {
      final outcome = await context.read<AuthController>().verify(
            challengeId: _challengeId!,
            phone: _e164,
            code: _code.text.trim(),
          );
      if (!mounted) return;
      if (outcome.isNewUser) {
        setState(() {
          _registrationToken = outcome.registrationToken;
          _step = _Step.register;
        });
      }
      // Signing in needs no navigation: the root listens to the controller
      // and swaps the tree.
    });
  }

  Future<void> _register() {
    final t = AppLocalizations.of(context);
    final age = int.tryParse(_age.text.trim());
    if (_name.text.trim().isEmpty) {
      setState(() => _error = t.nameRequired);
      return Future.value();
    }
    if (age == null || age < 13 || age > 100) {
      setState(() => _error = t.ageRange);
      return Future.value();
    }
    final locale = Localizations.localeOf(context).languageCode;
    return _run(() => context.read<AuthController>().register(
          registrationToken: _registrationToken!,
          name: _name.text.trim(),
          age: age,
          email: _email.text.trim(),
          locale: locale,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (AppConfig.isCleartext) const CleartextBanner(),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const GymologiaMark(size: 56),
                        const SizedBox(height: 18),
                        Text(
                          t.appTitle,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          t.signInSubtitle,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 28),
                        ..._fields(t),
                        if (_error != null) ...[
                          const SizedBox(height: 14),
                          Text(
                            _error!,
                            style: TextStyle(color: theme.colorScheme.error),
                          ),
                        ],
                        const SizedBox(height: 20),
                        FilledButton(
                          onPressed: _busy ? null : _primaryAction,
                          child: _busy
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2),
                                )
                              : Text(_primaryLabel(t)),
                        ),
                        if (_step != _Step.phone) ...[
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: _busy ? null : _startOver,
                            child: Text(t.changeNumber),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const AppFooter(),
          ],
        ),
      ),
    );
  }

  void _startOver() {
    _ticker?.cancel();
    setState(() {
      _step = _Step.phone;
      _challengeId = null;
      _registrationToken = null;
      _code.clear();
      _error = null;
      _cooldown = 0;
    });
  }

  VoidCallback? get _primaryAction => switch (_step) {
        _Step.phone => _sendCode,
        _Step.code => _verify,
        _Step.register => _register,
      };

  String _primaryLabel(AppLocalizations t) => switch (_step) {
        _Step.phone => t.sendCode,
        _Step.code => t.verify,
        _Step.register => t.createAccount,
      };

  List<Widget> _fields(AppLocalizations t) => switch (_step) {
        _Step.phone => [
            TextField(
              controller: _phone,
              enabled: !_busy,
              autofocus: true,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              decoration: InputDecoration(
                labelText: t.phoneLabel,
                hintText: t.phoneHint,
                prefixText: '+91 ',
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (_) => _sendCode(),
            ),
          ],
        _Step.code => [
            Text(
              t.codeSentTo(_e164),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _code,
              enabled: !_busy,
              autofocus: true,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(8),
              ],
              decoration: const InputDecoration(border: OutlineInputBorder()),
              onSubmitted: (_) => _verify(),
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.center,
              child: _cooldown > 0
                  ? Text(
                      t.resendIn(_cooldown),
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                  : TextButton(
                      onPressed: _busy ? null : _sendCode,
                      child: Text(t.resend),
                    ),
            ),
          ],
        _Step.register => [
            Text(
              t.createAccountTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _name,
              enabled: !_busy,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: t.nameLabel,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _email,
              enabled: !_busy,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: t.emailLabel,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _age,
              enabled: !_busy,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
              decoration: InputDecoration(
                labelText: t.ageLabel,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              t.ageWhy,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
      };
}
