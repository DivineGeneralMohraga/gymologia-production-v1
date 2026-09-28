import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/config/app_config.dart';
import '../../core/utils/validators.dart';
import '../diagnostics/diagnostics_screen.dart';
import 'auth_controller.dart';
import 'otp_screen.dart';
import '../../theme.dart';
import '../../ui/kit.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final auth = context.read<AuthController>();
    final phone = '+91${_controller.text.trim()}';
    final challenge = await auth.requestOtp(phone);

    if (!mounted) return;
    if (challenge == null) {
      final message =
          auth.error ?? AppLocalizations.of(context).couldNotSendCode;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => OtpScreen(challenge: challenge, phone: phone),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final auth = context.watch<AuthController>();
    final theme = Theme.of(context);
    final topInset = MediaQuery.paddingOf(context).top;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Poster ────────────────────────────────────────────
            // Dark in both modes: it is the first thing anyone sees.
            Container(
              height: 330 + topInset,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1D2608), ink],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -40,
                    top: topInset + 10,
                    child: Transform.rotate(
                      angle: -0.55,
                      child: Icon(
                        Icons.fitness_center_rounded,
                        size: 230,
                        color: volt.withValues(alpha: 0.10),
                      ),
                    ),
                  ),
                  Positioned(
                    left: -80,
                    bottom: -120,
                    child: Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(colors: [
                          volt.withValues(alpha: 0.22),
                          volt.withValues(alpha: 0.0),
                        ]),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 24,
                    right: 24,
                    bottom: 28,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const BrandMark(size: 54),
                        const SizedBox(height: 18),
                        Text(
                          t.appName.toUpperCase(),
                          style: const TextStyle(
                            fontFamily: displayFont,
                            fontSize: 60,
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.italic,
                            height: 0.9,
                            letterSpacing: 0.5,
                            color: Color(0xFFF5F5F2),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          t.tagline.toUpperCase(),
                          style: const TextStyle(
                            fontFamily: displayFont,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2.0,
                            color: volt,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Form ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          t.signInWithMobile,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 18),
                        TextFormField(
                          controller: _controller,
                          autofocus: true,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.done,
                          style: const TextStyle(
                            fontFamily: displayFont,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding:
                                  const EdgeInsets.only(left: 18, right: 10),
                              child: Text(
                                '+91',
                                style: TextStyle(
                                  fontFamily: displayFont,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: context.gym.accentText,
                                ),
                              ),
                            ),
                            prefixIconConstraints:
                                const BoxConstraints(minWidth: 0, minHeight: 0),
                            labelText: t.mobileNumber,
                            hintText: '98765 43210',
                          ),
                          validator: (v) => validateIndianMobile(t, v),
                          onFieldSubmitted: (_) => _submit(),
                        ),
                        const SizedBox(height: 18),
                        FilledButton.icon(
                          onPressed: auth.busy ? null : _submit,
                          iconAlignment: IconAlignment.end,
                          icon: auth.busy
                              ? const SizedBox.shrink()
                              : const Icon(Icons.arrow_forward_rounded),
                          label: auth.busy
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2.5),
                                )
                              : Text(t.sendOtp.toUpperCase()),
                        ),
                        const SizedBox(height: 24),
                        // Visible on every build, not just debug: when a
                        // tester says "it does not work", the first useful
                        // question is which server they are hitting.
                        _ServerChip(host: AppConfig.apiBaseUrl),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServerChip extends StatelessWidget {
  const _ServerChip({required this.host});
  final String host;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: TextButton.icon(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const DiagnosticsScreen()),
        ),
        icon: const Icon(Icons.dns_outlined, size: 16),
        label: Text(
          host,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
