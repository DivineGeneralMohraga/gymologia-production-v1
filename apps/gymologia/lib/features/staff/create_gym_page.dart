import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/api/api_client.dart';
import '../../core/api/gym_api.dart';
import '../../core/utils/validators.dart';
import '../auth/auth_controller.dart';

/// Creating a gym.
///
/// Deliberately short. KYC, plan selection and photos all come later in
/// their own flows — asking for eleven documents before someone can see
/// their own CRM is how a signup gets abandoned. What is here is only what
/// the gym cannot function without.
class CreateGymPage extends StatefulWidget {
  const CreateGymPage({super.key});

  @override
  State<CreateGymPage> createState() => _CreateGymPageState();
}

class _CreateGymPageState extends State<CreateGymPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _description = TextEditingController();
  final _address = TextEditingController();
  final _city = TextEditingController();
  final _district = TextEditingController();
  final _state = TextEditingController();
  final _pincode = TextEditingController();
  final _phone = TextEditingController();
  final _perks = TextEditingController();

  int _leavePerMonth = 4;
  int _leavePerMembership = 30;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    // The owner's own number is the obvious default for the gym's contact.
    final phone = context.read<AuthController>().user?.phone;
    if (phone != null) _phone.text = phone.replaceFirst('+91', '');
  }

  @override
  void dispose() {
    for (final c in [
      _name, _description, _address, _city,
      _district, _state, _pincode, _phone, _perks,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    setState(() {
      _busy = true;
      _error = null;
    });

    final perks = _perks.text
        .split(',')
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();

    try {
      final api = GymApi(context.read<AuthController>().client);
      await api.createGym({
        'name': _name.text.trim(),
        if (_description.text.trim().isNotEmpty)
          'description': _description.text.trim(),
        'addressLine1': _address.text.trim(),
        'city': _city.text.trim(),
        'district': _district.text.trim(),
        'state': _state.text.trim(),
        'pincode': _pincode.text.trim(),
        'contactPhone': '+91${_phone.text.trim()}',
        'maxLeaveDaysPerMonth': _leavePerMonth,
        'maxLeaveDaysPerMembership': _leavePerMembership,
        if (perks.isNotEmpty) 'perks': perks,
      });
      if (mounted) Navigator.of(context).pop(true);
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

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).createYourGym)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          children: [
            TextFormField(
              controller: _name,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).gymName,
                hintText: AppLocalizations.of(context).gymNameHint,
              ),
              validator: (v) =>
                  (v?.trim().length ?? 0) < 2 ? 'Enter your gym name' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _description,
              maxLines: 3,
              maxLength: 400,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).descriptionOptional,
                hintText: AppLocalizations.of(context).descriptionHint,
              ),
            ),

            _Label('Where you are'),
            TextFormField(
              controller: _address,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(labelText: AppLocalizations.of(context).address),
              validator: (v) =>
                  (v?.trim().length ?? 0) < 3 ? 'Enter the address' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _city,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(labelText: AppLocalizations.of(context).city),
                    validator: (v) =>
                        (v?.trim().length ?? 0) < 2 ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: TextFormField(
                    controller: _district,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(labelText: AppLocalizations.of(context).district),
                    validator: (v) =>
                        (v?.trim().length ?? 0) < 2 ? 'Required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              AppLocalizations.of(context).districtNote,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _state,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(labelText: AppLocalizations.of(context).state),
                    validator: (v) =>
                        (v?.trim().length ?? 0) < 2 ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: TextFormField(
                    controller: _pincode,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    decoration: InputDecoration(labelText: AppLocalizations.of(context).pinCode),
                    validator: (v) => RegExp(r'^\d{6}$').hasMatch(v?.trim() ?? '')
                        ? null
                        : '6 digits',
                  ),
                ),
              ],
            ),

            _Label('Contact'),
            TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).contactNumber,
                prefixText: '+91  ',
              ),
              validator: validateIndianMobile,
            ),

            _Label('Leave policy'),
            Text(
              AppLocalizations.of(context).leavePolicyNote,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant, height: 1.4),
            ),
            const SizedBox(height: 12),
            _Stepper(
              label: 'Leave days per month',
              value: _leavePerMonth,
              min: 0,
              max: 31,
              onChanged: (v) => setState(() => _leavePerMonth = v),
            ),
            _Stepper(
              label: 'Maximum per membership',
              value: _leavePerMembership,
              min: 0,
              max: 90,
              onChanged: (v) => setState(() => _leavePerMembership = v),
            ),

            _Label('Perks'),
            TextFormField(
              controller: _perks,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).perksLabel,
                hintText: AppLocalizations.of(context).perksHint,
              ),
            ),

            if (_error != null) ...[
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(_error!, style: theme.textTheme.bodySmall),
              ),
            ],

            const SizedBox(height: 24),
            FilledButton(
              onPressed: _busy ? null : _submit,
              child: _busy
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    )
                  : Text(AppLocalizations.of(context).createGym),
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context).draftNote,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 26, bottom: 12),
      child: Text(
        text.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          letterSpacing: 0.9,
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          IconButton(
            onPressed: value > min ? () => onChanged(value - 1) : null,
            icon: const Icon(Icons.remove_circle_outline),
          ),
          SizedBox(
            width: 32,
            child: Text('$value',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
          IconButton(
            onPressed: value < max ? () => onChanged(value + 1) : null,
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
    );
  }
}
