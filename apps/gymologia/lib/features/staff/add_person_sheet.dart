import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/api/api_client.dart';
import '../../core/api/gym_api.dart';
import '../../core/api/models.dart';
import '../../core/utils/validators.dart';
import '../auth/auth_controller.dart';

enum AddMode { member, staff }

/// Adding a member or a staff member, in two steps.
///
/// Step one sends a code to their number. Step two takes the code plus the
/// details. That ordering is the point: until the code is verified the
/// server tells us only whether an account exists, never a name — so this
/// screen cannot be used to look up a stranger by phone number.
class AddPersonSheet extends StatefulWidget {
  const AddPersonSheet({super.key, required this.gym, required this.mode});

  final GymDetail gym;
  final AddMode mode;

  @override
  State<AddPersonSheet> createState() => _AddPersonSheetState();
}

class _AddPersonSheetState extends State<AddPersonSheet> {
  final _phone = TextEditingController();
  final _code = TextEditingController();
  final _name = TextEditingController();

  PersonLookup? _lookup;
  bool _busy = false;
  String? _error;

  // Member fields
  int _planMonths = 3;
  int _maxLeaveDays = 4;
  final _goal = TextEditingController();

  // Staff fields
  List<Map<String, dynamic>> _roles = const [];
  String? _roleId;

  bool get _isMember => widget.mode == AddMode.member;
  GymApi get _api => GymApi(context.read<AuthController>().client);

  @override
  void dispose() {
    for (final c in [_phone, _code, _name, _goal]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _sendCode() async {
    final problem = validateIndianMobile(_phone.text.trim());
    if (problem != null) {
      setState(() => _error = problem);
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      final phone = '+91${_phone.text.trim()}';
      final lookup = _isMember
          ? await _api.lookupMember(widget.gym.id, phone)
          : await _api.lookupStaff(widget.gym.id, phone);

      if (!mounted) return;
      setState(() {
        _lookup = lookup;
        _busy = false;
        // Outside production the server returns the code, so testing does
        // not need a second handset.
        if (lookup.devCode != null) _code.text = lookup.devCode!;
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

  Future<void> _submit() async {
    final lookup = _lookup!;
    if (_code.text.trim().length < 4) {
      setState(() => _error = 'Enter the code sent to their phone.');
      return;
    }
    if (!lookup.exists && _name.text.trim().length < 2) {
      setState(() => _error = 'This number is new, so a name is needed.');
      return;
    }
    if (!_isMember && _roleId == null) {
      setState(() => _error = 'Choose a role.');
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });

    final body = <String, dynamic>{
      'challengeId': lookup.challengeId,
      'phone': lookup.phone,
      'code': _code.text.trim(),
      if (_name.text.trim().isNotEmpty) 'name': _name.text.trim(),
    };

    if (_isMember) {
      body.addAll({
        'planMonths': _planMonths,
        'maxLeaveDays': _maxLeaveDays,
        if (_goal.text.trim().isNotEmpty) 'goal': _goal.text.trim(),
      });
    } else {
      body['roleId'] = _roleId;
    }

    try {
      if (_isMember) {
        await _api.addMember(widget.gym.id, body);
      } else {
        await _api.addStaff(widget.gym.id, body);
      }
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
    final lookup = _lookup;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        24, 20, 24, MediaQuery.of(context).viewInsets.bottom + 28,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(_isMember ? 'Add a member' : 'Add staff',
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(
              'We text a code to their number first, so you know it is really theirs.',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _phone,
              enabled: lookup == null,
              autofocus: true,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              decoration: const InputDecoration(
                labelText: 'Their mobile number',
                prefixText: '+91  ',
              ),
            ),

            if (lookup == null) ...[
              const SizedBox(height: 18),
              FilledButton(
                onPressed: _busy ? null : _sendCode,
                child: _busy
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(strokeWidth: 2.5))
                    : const Text('Send code'),
              ),
            ] else ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer
                      .withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.sms_outlined, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        lookup.exists
                            ? 'Code sent. This number already has a Gymologia account.'
                            : 'Code sent. This number is new, so we will create an account.',
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _code,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: const InputDecoration(
                  labelText: 'Code from their phone',
                  counterText: '',
                ),
              ),
              if (!lookup.exists) ...[
                const SizedBox(height: 10),
                TextField(
                  controller: _name,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(labelText: 'Their name'),
                ),
              ],

              if (_isMember) ...[
                const SizedBox(height: 18),
                _Counter(
                  label: 'Membership length',
                  value: _planMonths,
                  suffix: _planMonths == 1 ? 'month' : 'months',
                  min: 1,
                  max: 24,
                  onChanged: (v) => setState(() => _planMonths = v),
                ),
                _Counter(
                  label: 'Leave days allowed',
                  value: _maxLeaveDays,
                  suffix: 'days',
                  min: 0,
                  max: widget.gym.maxLeaveDaysPerMonth * 12,
                  onChanged: (v) => setState(() => _maxLeaveDays = v),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _goal,
                  decoration: const InputDecoration(
                    labelText: 'What do they want from the gym?',
                    hintText: 'Bulk up, lose weight, rehab…',
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'They can see and update their weight and height in the member '
                  'app. Their progress is visible to staff unless they turn that '
                  'off themselves.',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ] else ...[
                const SizedBox(height: 16),
                _RolePicker(
                  gymId: widget.gym.id,
                  api: _api,
                  roleId: _roleId,
                  onLoaded: (roles) => setState(() => _roles = roles),
                  roles: _roles,
                  onChanged: (id) => setState(() => _roleId = id),
                ),
              ],

              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.colorScheme.error)),
              ],

              const SizedBox(height: 18),
              FilledButton(
                onPressed: _busy ? null : _submit,
                child: _busy
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(strokeWidth: 2.5))
                    : Text(_isMember ? 'Add member' : 'Add staff'),
              ),
            ],

            if (_error != null && lookup == null) ...[
              const SizedBox(height: 12),
              Text(_error!,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.error)),
            ],
          ],
        ),
      ),
    );
  }
}

class _Counter extends StatelessWidget {
  const _Counter({
    required this.label,
    required this.value,
    required this.suffix,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final int value;
  final String suffix;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        IconButton(
          onPressed: value > min ? () => onChanged(value - 1) : null,
          icon: const Icon(Icons.remove_circle_outline),
        ),
        SizedBox(
          width: 74,
          child: Text('$value $suffix',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w700)),
        ),
        IconButton(
          onPressed: value < max ? () => onChanged(value + 1) : null,
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }
}

/// Assignable roles for this gym.
///
/// The server marks each role with whether the caller outranks it, so the
/// picker only ever offers roles the write would accept — a manager never
/// sees "Owner" in the list and then gets refused.
class _RolePicker extends StatefulWidget {
  const _RolePicker({
    required this.gymId,
    required this.api,
    required this.roles,
    required this.roleId,
    required this.onLoaded,
    required this.onChanged,
  });

  final String gymId;
  final GymApi api;
  final List<Map<String, dynamic>> roles;
  final String? roleId;
  final ValueChanged<List<Map<String, dynamic>>> onLoaded;
  final ValueChanged<String?> onChanged;

  @override
  State<_RolePicker> createState() => _RolePickerState();
}

class _RolePickerState extends State<_RolePicker> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    if (widget.roles.isEmpty) {
      _load();
    } else {
      _loading = false;
    }
  }

  Future<void> _load() async {
    try {
      final all = await widget.api.roles(widget.gymId);
      final assignable =
          all.where((r) => r['assignable'] == true).toList();
      if (mounted) {
        widget.onLoaded(assignable);
        setState(() => _loading = false);
      }
    } on ApiException {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Center(
          child: SizedBox(
            height: 20, width: 20,
            child: CircularProgressIndicator(strokeWidth: 2.2),
          ),
        ),
      );
    }

    if (widget.roles.isEmpty) {
      return Text(
        'There are no roles you can assign. Only roles junior to your own '
        'can be given out.',
        style: theme.textTheme.bodySmall
            ?.copyWith(color: theme.colorScheme.error),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ROLE',
            style: theme.textTheme.labelSmall?.copyWith(
              letterSpacing: 0.8,
              color: theme.colorScheme.onSurfaceVariant,
            )),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final role in widget.roles)
              ChoiceChip(
                label: Text(role['name'] as String? ?? ''),
                selected: widget.roleId == role['id'],
                onSelected: (_) => widget.onChanged(role['id'] as String?),
              ),
          ],
        ),
      ],
    );
  }
}
