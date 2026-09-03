import 'dart:async';
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/api/auth_api.dart';
import 'auth_controller.dart';
import 'register_screen.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.challenge, required this.phone});

  final OtpChallenge challenge;
  final String phone;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _controller = TextEditingController();
  late OtpChallenge _challenge;
  late int _secondsLeft;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _challenge = widget.challenge;
    _startCountdown(_challenge.resendAfterSeconds);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  /// The backend enforces its own resend cooldown and returns 429 if we
  /// ignore it. Mirroring the countdown here keeps the user from earning a
  /// rate-limit error by tapping.
  void _startCountdown(int seconds) {
    _timer?.cancel();
    setState(() => _secondsLeft = seconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return t.cancel();
      setState(() => _secondsLeft--);
      if (_secondsLeft <= 0) t.cancel();
    });
  }

  Future<void> _verify() async {
    final code = _controller.text.trim();
    if (code.length < 4) return;
    FocusScope.of(context).unfocus();

    final auth = context.read<AuthController>();
    final outcome = await auth.verifyOtp(
      challengeId: _challenge.challengeId,
      phone: widget.phone,
      code: code,
    );

    if (!mounted) return;

    switch (outcome) {
      case null:
        _controller.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(auth.error ?? 'Verification failed.')),
        );
      case NewUserOutcome(:final registrationToken):
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => RegisterScreen(
              registrationToken: registrationToken,
              phone: widget.phone,
            ),
          ),
        );
      case AuthenticatedOutcome():
        // AuthController flipped to signedIn; the root widget swaps to home.
        Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  Future<void> _resend() async {
    final auth = context.read<AuthController>();
    final fresh = await auth.requestOtp(widget.phone);
    if (!mounted) return;
    if (fresh == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.error ?? 'Could not resend the code.')),
      );
      return;
    }
    setState(() => _challenge = fresh);
    _startCountdown(fresh.resendAfterSeconds);
    _controller.clear();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).codeResent)));
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final theme = Theme.of(context);
    final canResend = _secondsLeft <= 0 && !auth.busy;

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).verifyYourNumber)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'We sent a code to ${_challenge.phoneMasked.isEmpty ? widget.phone : _challenge.phoneMasked}',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 28),
                  TextField(
                    controller: _controller,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 6,
                    style: const TextStyle(
                      fontSize: 28,
                      letterSpacing: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      counterText: '',
                      hintText: '••••••',
                    ),
                    onChanged: (v) {
                      if (v.length == 6) _verify();
                    },
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: auth.busy ? null : _verify,
                    child: auth.busy
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(strokeWidth: 2.5),
                          )
                        : Text(AppLocalizations.of(context).verifyCode),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: canResend ? _resend : null,
                    child: Text(
                      canResend
                          ? 'Resend code'
                          : 'Resend in ${_secondsLeft}s',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
