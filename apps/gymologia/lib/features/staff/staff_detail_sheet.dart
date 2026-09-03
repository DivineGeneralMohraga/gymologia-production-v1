import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../core/api/api_client.dart';
import '../../core/api/gym_api.dart';
import '../../core/api/models.dart';
import '../auth/auth_controller.dart';

/// Editing one staff member: their role, whether they are a trainer, and
/// removing them.
///
/// Only roles junior to the viewer's own are offered, so a manager cannot
/// promote someone to owner-equivalent and then discover the write was
/// refused. Removal reassigns that trainer's members server-side, which is
/// worth saying out loud before the confirm.
class StaffDetailSheet extends StatefulWidget {
  const StaffDetailSheet({super.key, required this.gym, required this.staff});

  final GymDetail gym;
  final StaffRow staff;

  @override
  State<StaffDetailSheet> createState() => _StaffDetailSheetState();
}

class _StaffDetailSheetState extends State<StaffDetailSheet> {
  List<Map<String, dynamic>>? _roles;
  String? _roleId;
  bool _busy = false;
  String? _error;

  GymApi get _api => GymApi(context.read<AuthController>().client);

  @override
  void initState() {
    super.initState();
    _loadRoles();
  }

  Future<void> _loadRoles() async {
    try {
      final roles = await _api.roles(widget.gym.id);
      if (!mounted) return;
      setState(() {
        _roles = roles.where((r) => r['assignable'] == true).toList();
        // Pre-select their current role when it is one we may assign.
        final current = roles.firstWhere(
          (r) => r['name'] == widget.staff.roleName,
          orElse: () => const {},
        );
        if (current['assignable'] == true) _roleId = current['id'] as String?;
      });
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    }
  }

  Future<void> _save() async {
    if (_roleId == null) {
      setState(() => _error = 'Choose a role.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await _api.updateStaff(widget.gym.id, widget.staff.id, {'roleId': _roleId});
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

  Future<void> _remove() async {
    final assigned = widget.staff.assignedMemberCount;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context).removePerson(widget.staff.name)),
        content: Text(
          assigned > 0
              ? 'They lose access to this gym, and the $assigned member'
                  '${assigned == 1 ? '' : 's'} assigned to them will have no '
                  'trainer until you reassign someone.'
              : 'They lose access to this gym. Their attendance history is kept.',
        ),
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
            child: Text(AppLocalizations.of(context).remove),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _busy = true);
    try {
      await _api.removeStaff(widget.gym.id, widget.staff.id);
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
    final staff = widget.staff;
    final roles = _roles;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        24, 20, 24, MediaQuery.of(context).viewInsets.bottom + 28,
      ),
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
          Text(staff.name,
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
          Text(staff.phone,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),

          if (staff.isTrainer) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.sports_gymnastics, size: 16),
                const SizedBox(width: 8),
                Text(
                  '${staff.trainerCategoryName ?? 'Trainer'} · '
                  '${staff.assignedMemberCount} member'
                  '${staff.assignedMemberCount == 1 ? '' : 's'}',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ],

          const SizedBox(height: 22),
          Text(AppLocalizations.of(context).role.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                letterSpacing: 0.8,
                color: theme.colorScheme.onSurfaceVariant,
              )),
          const SizedBox(height: 8),

          if (roles == null)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: SizedBox(
                  height: 20, width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2.2),
                ),
              ),
            )
          else if (roles.isEmpty)
            Text(
              'There are no roles you can assign to them.',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final role in roles)
                  ChoiceChip(
                    label: Text(role['name'] as String? ?? ''),
                    selected: _roleId == role['id'],
                    onSelected: (_) =>
                        setState(() => _roleId = role['id'] as String?),
                  ),
              ],
            ),

          if (_error != null) ...[
            const SizedBox(height: 14),
            Text(_error!,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.error)),
          ],

          const SizedBox(height: 22),
          if (widget.gym.can(P.manageStaff))
            FilledButton(
              onPressed: _busy || roles == null || roles.isEmpty ? null : _save,
              child: _busy
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.5))
                  : Text(AppLocalizations.of(context).saveChanges),
            ),
          if (widget.gym.can(P.removeStaff)) ...[
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: _busy ? null : _remove,
              icon: Icon(Icons.person_remove_outlined,
                  size: 18, color: theme.colorScheme.error),
              label: Text(AppLocalizations.of(context).removeFromGym,
                  style: TextStyle(color: theme.colorScheme.error)),
            ),
          ],
        ],
      ),
    );
  }
}
