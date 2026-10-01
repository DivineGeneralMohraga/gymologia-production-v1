import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/api/api_client.dart';
import '../../core/api/gym_api.dart';
import '../../core/api/models.dart';
import '../../core/utils/validators.dart';
import '../../theme.dart';
import '../../ui/kit.dart';
import '../auth/auth_controller.dart';
import 'gym_setup_widgets.dart';

/// Creating a gym.
///
/// Deliberately short: what the gym cannot function without, plus its
/// location so members nearby can find it. Then a second step on the same
/// screen offers photos -- optional, skippable, and easier to act on right
/// after creating the gym than to discover later in Gym profile. Plan
/// selection comes after, on the gym itself.
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
  GymLocation? _location;
  bool _busy = false;
  String? _error;

  /// Set once the gym exists; the screen then becomes the photo step.
  GymDetail? _created;
  GymPhotosController? _photos;
  bool _savingPhotos = false;

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
    _photos?.dispose();
    super.dispose();
  }

  void _redraw() {
    if (mounted) setState(() {});
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
      final created = await api.createGym({
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
        if (_location != null) ...{
          'latitude': _location!.latitude,
          'longitude': _location!.longitude,
        },
      });
      if (!mounted) return;
      setState(() {
        _created = created;
        _photos = GymPhotosController(gymId: created.id)..addListener(_redraw);
        _busy = false;
      });
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _error = e.message;
          _busy = false;
        });
      }
    }
  }

  /// Leaves the photo step. Saves the photos if any were added; the gym
  /// exists either way, so a failed save still lets the owner out.
  Future<void> _finish() async {
    final photos = _photos!;
    if (photos.busy || _savingPhotos) return;
    if (photos.changed && photos.images.isNotEmpty) {
      setState(() => _savingPhotos = true);
      try {
        await GymApi(context.read<AuthController>().client)
            .updateGym(_created!.id, {'imageUrls': photos.images});
      } on ApiException catch (e) {
        if (mounted) {
          setState(() => _savingPhotos = false);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.message)));
        }
        return;
      }
    }
    if (mounted) Navigator.of(context).pop(true);
  }

  Widget _photoStep(BuildContext context) {
    final t = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final photos = _photos!;
    final hasPhotos = photos.images.isNotEmpty;

    // Back finishes rather than returning to the form: the gym already
    // exists, and the form would only offer to create it a second time.
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _finish();
      },
      child: Scaffold(
        appBar: AppBar(title: Text(t.addPhoto.toUpperCase())),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
          children: [
            HeroPanel(
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: volt,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.check_rounded, color: ink, size: 30),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      t.gymCreatedAddPhotos(_created!.name),
                      style: const TextStyle(height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            SectionLabel(t.gymPhotos),
            GymPhotosEditor(controller: photos),
            const SizedBox(height: 6),
            Text(
              t.gymPhotosHint,
              style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: photos.busy || _savingPhotos ? null : _finish,
              child: _savingPhotos
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    )
                  : Text((hasPhotos ? t.finish : t.skipForNow).toUpperCase()),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (_created != null) return _photoStep(context);

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
                  (v?.trim().length ?? 0) < 2
                      ? AppLocalizations.of(context).enterYourGymName
                      : null,
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

            _Label(AppLocalizations.of(context).whereYouAre),
            TextFormField(
              controller: _address,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(labelText: AppLocalizations.of(context).address),
              validator: (v) =>
                  (v?.trim().length ?? 0) < 3
                      ? AppLocalizations.of(context).enterTheAddress
                      : null,
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
                        (v?.trim().length ?? 0) < 2
                            ? AppLocalizations.of(context).required
                            : null,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: TextFormField(
                    controller: _district,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(labelText: AppLocalizations.of(context).district),
                    validator: (v) =>
                        (v?.trim().length ?? 0) < 2
                            ? AppLocalizations.of(context).required
                            : null,
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
                        (v?.trim().length ?? 0) < 2
                            ? AppLocalizations.of(context).required
                            : null,
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

            _Label(AppLocalizations.of(context).gymLocation),
            GymLocationField(
              value: _location,
              onChanged: (v) => setState(() => _location = v),
            ),

            _Label(AppLocalizations.of(context).contact),
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
              validator: (v) =>
                  validateIndianMobile(AppLocalizations.of(context), v),
            ),

            _Label(AppLocalizations.of(context).leavePolicy),
            Text(
              AppLocalizations.of(context).leavePolicyNote,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant, height: 1.4),
            ),
            const SizedBox(height: 12),
            _Stepper(
              label: AppLocalizations.of(context).leaveDaysPerMonth,
              value: _leavePerMonth,
              min: 0,
              max: 31,
              onChanged: (v) => setState(() => _leavePerMonth = v),
            ),
            _Stepper(
              label: AppLocalizations.of(context).maximumPerMembership,
              value: _leavePerMembership,
              min: 0,
              max: 90,
              onChanged: (v) => setState(() => _leavePerMembership = v),
            ),

            _Label(AppLocalizations.of(context).perks),
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
