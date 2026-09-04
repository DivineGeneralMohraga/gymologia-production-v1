import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/api/api_client.dart';
import '../../core/api/gym_api.dart';
import '../../core/utils/validators.dart';
import '../auth/auth_controller.dart';

/// Editing your own name, email and age.
///
/// The phone number is shown but locked. It is the login identity, and
/// changing it safely needs an OTP on the new number before anything
/// moves — showing an editable field for a flow that does not exist yet
/// would be a lie.
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _age;

  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthController>().user;
    _name = TextEditingController(text: user?.name ?? '');
    _email = TextEditingController(text: user?.email ?? '');
    _age = TextEditingController(text: user?.age?.toString() ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _age.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    setState(() {
      _busy = true;
      _error = null;
    });

    final auth = context.read<AuthController>();
    try {
      await GymApi(auth.client).updateProfile(
        name: _name.text.trim(),
        // An empty string clears it, which the server understands.
        email: _email.text.trim(),
        age: int.tryParse(_age.text.trim()),
      );
      // Pull the canonical version back rather than trusting local state.
      await auth.refreshUser();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).profileUpdated)),
      );
      Navigator.of(context).pop(true);
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _error = e.message;
          _busy = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = context.watch<AuthController>().user;

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).yourProfile)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          children: [
            TextFormField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).name),
              validator: validateName,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).email,
                helperText: AppLocalizations.of(context).emailClearToRemove,
              ),
              validator: validateOptionalEmail,
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
              validator: validateAge,
            ),

            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.lock_outline,
                      size: 18, color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user?.phone ?? '',
                            style: theme.textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text(
                          AppLocalizations.of(context).phoneIsYourLogin,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            if (_error != null) ...[
              const SizedBox(height: 16),
              Text(_error!,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.error)),
            ],

            const SizedBox(height: 24),
            FilledButton(
              onPressed: _busy ? null : _save,
              child: _busy
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.5))
                  : Text(AppLocalizations.of(context).save),
            ),
          ],
        ),
      ),
    );
  }
}
