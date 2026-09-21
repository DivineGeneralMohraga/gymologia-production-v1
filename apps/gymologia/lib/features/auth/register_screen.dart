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

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _age.dispose();
    super.dispose();
  }

  bool get _isMinor {
    final age = int.tryParse(_age.text.trim());
    return age != null && age < 18;
  }

  Future<void> _submit() async {
    setState(() => _consentTouched = true);
    if (!_formKey.currentState!.validate()) return;
    if (!_consentGiven) return;
    FocusScope.of(context).unfocus();

    final auth = context.read<AuthController>();
    final ok = await auth.register(
      registrationToken: widget.registrationToken,
      name: _name.text.trim(),
      age: int.parse(_age.text.trim()),
      email: _email.text.trim().isEmpty ? null : _email.text.trim(),
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
                    // guardian before it is fully active. Shown as soon as
                    // the age field says so; support follows up post sign-up.
                    if (_isMinor) ...[
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.errorContainer
                              .withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.family_restroom,
                                size: 18,
                                color: theme.colorScheme.onErrorContainer),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                AppLocalizations.of(context)
                                    .under18GuardianNotice,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onErrorContainer,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
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
