import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/api/api_client.dart';
import '../../core/api/gym_api.dart';
import '../../core/api/models.dart';
import '../auth/auth_controller.dart';

/// Editing the gym: what members see, and the leave policy.
///
/// Perks are replace-in-full rather than a patch protocol — the client
/// sends the list it wants and that becomes the list, which is far easier
/// to reason about than tracking adds and removes.
class GymProfileEditPage extends StatefulWidget {
  const GymProfileEditPage({super.key, required this.gym});

  final GymDetail gym;

  @override
  State<GymProfileEditPage> createState() => _GymProfileEditPageState();
}

class _GymProfileEditPageState extends State<GymProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.gym.name);
  late final _description =
      TextEditingController(text: widget.gym.description ?? '');
  late final _phone = TextEditingController(
    text: (widget.gym.contactPhone ?? '').replaceFirst('+91', ''),
  );
  late final _perks = TextEditingController(text: widget.gym.perks.join(', '));
  late int _leavePerMonth = widget.gym.maxLeaveDaysPerMonth;

  bool _busy = false;
  String? _error;

  GymApi get _api => GymApi(context.read<AuthController>().client);

  @override
  void dispose() {
    for (final c in [_name, _description, _phone, _perks]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
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
      await _api.updateGym(widget.gym.id, {
        'name': _name.text.trim(),
        'description': _description.text.trim(),
        'contactPhone': '+91${_phone.text.trim()}',
        'maxLeaveDaysPerMonth': _leavePerMonth,
        'perks': perks,
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

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context).deleteNamed(widget.gym.name)),
        content: Text(AppLocalizations.of(context).deleteGymWarning(
            widget.gym.memberCount, widget.gym.staffCount)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(AppLocalizations.of(context).cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(AppLocalizations.of(context).deleteGym),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _busy = true);
    try {
      await _api.deleteGym(widget.gym.id);
      if (!mounted) return;
      // Pop twice: this page and the CRM dashboard behind it, since the gym
      // it was showing no longer exists.
      Navigator.of(context).pop(true);
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

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).gymProfile)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          children: [
            TextFormField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(labelText: AppLocalizations.of(context).gymName),
              validator: (v) =>
                  (v?.trim().length ?? 0) < 2
                      ? AppLocalizations.of(context).enterYourGymName
                      : null,
            ),
            const SizedBox(height: 6),
            Text(
              AppLocalizations.of(context).shownAsInSearch(
                  _name.text.trim().isEmpty
                      ? widget.gym.name
                      : _name.text.trim(),
                  widget.gym.district),
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 18),
            TextFormField(
              controller: _description,
              maxLines: 4,
              maxLength: 400,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).description,
                hintText: AppLocalizations.of(context).descriptionHint,
              ),
            ),
            const SizedBox(height: 10),
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
              validator: (v) => RegExp(r'^[6-9]\d{9}$').hasMatch(v?.trim() ?? '')
                  ? null
                  : AppLocalizations.of(context).enterValidTenDigitNumber,
            ),
            const SizedBox(height: 18),
            TextFormField(
              controller: _perks,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).perksLabel,
                hintText: AppLocalizations.of(context).perksHint,
              ),
            ),

            const SizedBox(height: 26),
            Text(AppLocalizations.of(context).leavePolicy.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  letterSpacing: 0.9,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                )),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context).leaveLimitNote,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                    child: Text(
                        AppLocalizations.of(context).leaveDaysPerMonth)),
                IconButton(
                  onPressed: _leavePerMonth > 0
                      ? () => setState(() => _leavePerMonth--)
                      : null,
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                SizedBox(
                  width: 32,
                  child: Text('$_leavePerMonth',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                ),
                IconButton(
                  onPressed: _leavePerMonth < 31
                      ? () => setState(() => _leavePerMonth++)
                      : null,
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
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
              onPressed: _busy ? null : _save,
              child: _busy
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.5))
                  : Text(AppLocalizations.of(context).saveChanges),
            ),

            // Deleting follows gym ownership, not a role — no permission
            // grants it, so only the registered owner sees this at all.
            if (widget.gym.can(P.deleteGym)) ...[
              const SizedBox(height: 36),
              const Divider(),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: _busy ? null : _delete,
                icon: Icon(Icons.delete_outline,
                    size: 18, color: theme.colorScheme.error),
                label: Text(AppLocalizations.of(context).deleteThisGym,
                    style: TextStyle(color: theme.colorScheme.error)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
