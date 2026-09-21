import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/api/api_client.dart';
import '../../core/api/gym_api.dart';
import '../settings/legal_page.dart';
import '../../core/utils/validators.dart';
import 'auth_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    super.key,
    required this.registrationToken,
    required this.phone,
  });

  final String registrationToken;
  final String phone;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _age = TextEditingController();
  bool _consentGiven = false;
  bool _consentTouched = false;

  // Guardian consent (DPDP Act 2023 s.9) — required before an under-18
  // account can be created. The token that unblocks submission comes only
  // from a real OTP round-trip against the guardian's own number; there is
  // no client-side way to set it.
  final _guardianPhone = TextEditingController();
  final _guardianCode = TextEditingController();
  String? _guardianChallengeId;
  String? _guardianConsentToken;
  bool _guardianRequestBusy = false;
  bool _guardianVerifyBusy = false;
  String? _guardianError;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _age.dispose();
    _guardianPhone.dispose();
    _guardianCode.dispose();
    super.dispose();
  }

  bool get _isMinor {
    final age = int.tryParse(_age.text.trim());
    return age != null && age < 18;
  }

  GymApi get _api => GymApi(context.read<AuthController>().client);

  Future<void> _requestGuardianCode() async {
    final problem = validateIndianMobile(
        AppLocalizations.of(context), _guardianPhone.text.trim());
    if (problem != null) {
      setState(() => _guardianError = problem);
      return;
    }
    setState(() {
      _guardianRequestBusy = true;
      _guardianError = null;
    });
    try {
      final result = await _api.requestGuardianConsent(
        registrationToken: widget.registrationToken,
        guardianPhone: '+91${_guardianPhone.text.trim()}',
      );
      if (!mounted) return;
      setState(() {
        _guardianChallengeId = result['challengeId'] as String;
        // Outside production the server returns the code, same as the
        // staff add-person flow, so testing needs only one handset.
        final devCode = result['devCode'] as String?;
        if (devCode != null) _guardianCode.text = devCode;
      });
    } on ApiException catch (e) {
      if (mounted) setState(() => _guardianError = e.message);
    } finally {
      if (mounted) setState(() => _guardianRequestBusy = false);
    }
  }

  Future<void> _verifyGuardianCode() async {
    if (_guardianCode.text.trim().length < 4) {
      setState(() =>
          _guardianError = AppLocalizations.of(context).enterCodeSentToTheirPhone);
      return;
    }
    setState(() {
      _guardianVerifyBusy = true;
      _guardianError = null;
    });
    try {
      final result = await _api.verifyGuardianConsent(
        registrationToken: widget.registrationToken,
        challengeId: _guardianChallengeId!,
        guardianPhone: '+91${_guardianPhone.text.trim()}',
        code: _guardianCode.text.trim(),
      );
      if (!mounted) return;
      setState(() =>
          _guardianConsentToken = result['guardianConsentToken'] as String);
    } on ApiException catch (e) {
      if (mounted) setState(() => _guardianError = e.message);
    } finally {
      if (mounted) setState(() => _guardianVerifyBusy = false);
    }
  }

  Future<void> _submit() async {
    setState(() => _consentTouched = true);
    if (!_formKey.currentState!.validate()) return;
    if (!_consentGiven) return;
    if (_isMinor && _guardianConsentToken == null) {
      setState(() => _guardianError =
          AppLocalizations.of(context).guardianConsentBlocksSubmit);
      return;
    }
    FocusScope.of(context).unfocus();

    final auth = context.read<AuthController>();
    final ok = await auth.register(
      registrationToken: widget.registrationToken,
      name: _name.text.trim(),
      age: int.parse(_age.text.trim()),
      email: _email.text.trim().isEmpty ? null : _email.text.trim(),
      guardianConsentToken: _isMinor ? _guardianConsentToken : null,
    );

    if (!mounted) return;
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(auth.error ??
                AppLocalizations.of(context).couldNotCreateAccount)),
      );
      return;
    }

    // Record which wording they agreed to. The account exists either way —
    // failing to write the consent row is not a reason to throw away a
    // signup, and the app asks again on next launch if it did not land.
    try {
      await GymApi(auth.client).acceptLegal();
    } on ApiException {
      // Deliberately ignored; /me/legal reports it as outstanding.
    }

    if (!mounted) return;
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
          title: Text(AppLocalizations.of(context).createAccount)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(widget.phone,
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    Text(AppLocalizations.of(context).verified,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: Colors.green.shade600)),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _name,
                      autofocus: true,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).name),
                      validator: (v) =>
                          validateName(AppLocalizations.of(context), v),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).emailOptional,
                      ),
                      validator: (v) => validateOptionalEmail(
                          AppLocalizations.of(context), v),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _age,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).age),
                      validator: (v) =>
                          validateAge(AppLocalizations.of(context), v),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    // DPDP Act s.9 — a minor's account needs a verified
                    // guardian before it can be created at all. Shown as
                    // soon as the age field says so, and it is the only
                    // path to a non-null guardianConsentToken.
                    if (_isMinor) _GuardianConsentBlock(
                      guardianPhone: _guardianPhone,
                      guardianCode: _guardianCode,
                      hasChallenge: _guardianChallengeId != null,
                      verified: _guardianConsentToken != null,
                      requestBusy: _guardianRequestBusy,
                      verifyBusy: _guardianVerifyBusy,
                      error: _guardianError,
                      onSendCode: _requestGuardianCode,
                      onVerify: _verifyGuardianCode,
                    ),
                    // The spec asks for this to be said out loud, and it is
                    // the reason the field is age and not date of birth.
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.lock_outline,
                              size: 18,
                              color: theme.colorScheme.onSurfaceVariant),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              AppLocalizations.of(context).whyAgeNotBirthday,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      AppLocalizations.of(context).termsAgreement,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const LegalPage()),
                      ),
                      child: Text(
                        AppLocalizations.of(context).termsAndPrivacy,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // DPDP Act s.6(1): consent needs a clear affirmative
                    // action, not an implied "by signing up you agree".
                    // Unchecked by default; the button below is inert until
                    // this is ticked.
                    InkWell(
                      onTap: () => setState(() {
                        _consentTouched = true;
                        _consentGiven = !_consentGiven;
                      }),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: _consentGiven,
                              onChanged: (v) => setState(() {
                                _consentTouched = true;
                                _consentGiven = v ?? false;
                              }),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: Text(
                                  AppLocalizations.of(context)
                                      .consentCheckboxLabel,
                                  style: theme.textTheme.bodySmall
                                      ?.copyWith(height: 1.4),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_consentTouched && !_consentGiven)
                      Padding(
                        padding: const EdgeInsets.only(left: 12, top: 2),
                        child: Text(
                          AppLocalizations.of(context).consentRequired,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: theme.colorScheme.error),
                        ),
                      ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: auth.busy ? null : _submit,
                      child: auth.busy
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(strokeWidth: 2.5),
                            )
                          : Text(AppLocalizations.of(context).createAccountAction),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The actual DPDP Act s.9 gate: a real OTP round-trip against the
/// guardian's own number, not a checkbox. Nothing here can produce a
/// verified state except the server confirming the code.
class _GuardianConsentBlock extends StatelessWidget {
  const _GuardianConsentBlock({
    required this.guardianPhone,
    required this.guardianCode,
    required this.hasChallenge,
    required this.verified,
    required this.requestBusy,
    required this.verifyBusy,
    required this.error,
    required this.onSendCode,
    required this.onVerify,
  });

  final TextEditingController guardianPhone;
  final TextEditingController guardianCode;
  final bool hasChallenge;
  final bool verified;
  final bool requestBusy;
  final bool verifyBusy;
  final String? error;
  final VoidCallback onSendCode;
  final VoidCallback onVerify;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: (verified ? Colors.green : theme.colorScheme.error)
            .withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (verified ? Colors.green : theme.colorScheme.error)
              .withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                verified ? Icons.check_circle_outline : Icons.family_restroom,
                size: 18,
                color: verified ? Colors.green.shade700 : theme.colorScheme.error,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  verified ? t.guardianVerifiedConfirmation : t.under18GuardianNotice,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: verified ? Colors.green.shade700 : theme.colorScheme.error,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          if (!verified) ...[
            const SizedBox(height: 12),
            TextField(
              controller: guardianPhone,
              enabled: !hasChallenge,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              decoration: InputDecoration(
                labelText: t.guardianPhoneLabel,
                prefixText: '+91  ',
              ),
            ),
            if (!hasChallenge) ...[
              const SizedBox(height: 10),
              FilledButton.tonal(
                onPressed: requestBusy ? null : onSendCode,
                child: requestBusy
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2.2))
                    : Text(t.sendCode),
              ),
            ] else ...[
              const SizedBox(height: 10),
              TextField(
                controller: guardianCode,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: InputDecoration(
                  labelText: t.guardianCodeLabel,
                  counterText: '',
                ),
              ),
              const SizedBox(height: 10),
              FilledButton.tonal(
                onPressed: verifyBusy ? null : onVerify,
                child: verifyBusy
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2.2))
                    : Text(t.verifyCode),
              ),
            ],
            if (error != null) ...[
              const SizedBox(height: 8),
              Text(error!,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.error)),
            ],
          ],
        ],
      ),
    );
  }
}
