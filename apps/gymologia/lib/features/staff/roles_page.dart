import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../core/api/api_client.dart';
import '../../core/api/gym_api.dart';
import '../../core/api/models.dart';
import '../auth/auth_controller.dart';

/// The roles a gym runs on, and what each one can do.
///
/// Two rules shape this screen. You can only touch a role junior to your
/// own, and you can only hand out permissions you hold yourself — so the
/// editor greys out what you cannot grant rather than offering it and
/// refusing on save.
class RolesPage extends StatefulWidget {
  const RolesPage({super.key, required this.gym});

  final GymDetail gym;

  @override
  State<RolesPage> createState() => _RolesPageState();
}

class _RolesPageState extends State<RolesPage> {
  List<Map<String, dynamic>>? _roles;
  String? _error;
  bool _busy = false;

  GymApi get _api => GymApi(context.read<AuthController>().client);

  bool get _canCreate => widget.gym.can(P.addRoles);
  bool get _canReorder => widget.gym.can(P.editRoleHierarchy);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final rows = await _api.roles(widget.gym.id);
      if (mounted) setState(() => _roles = rows);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    }
  }

  void _say(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _openEditor({Map<String, dynamic>? role}) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => RoleEditorPage(
          gym: widget.gym,
          roleId: role?['id'] as String?,
        ),
      ),
    );
    if (saved == true) await _load();
  }

  Future<void> _delete(Map<String, dynamic> role) async {
    final name = role['name'] as String;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppLocalizations.of(context).deleteNamed(name)),
        content: Text(AppLocalizations.of(context).deleteRoleWarning),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(AppLocalizations.of(context).keepIt),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(AppLocalizations.of(context).delete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _busy = true);
    try {
      await _api.deleteRole(widget.gym.id, role['id'] as String);
      if (mounted) _say(AppLocalizations.of(context).deletedNamed(name));
      await _load();
    } on ApiException catch (e) {
      if (mounted) _say(e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  /// Only the custom roles junior to this user can move, so those are the
  /// only ones the reorder sheet offers.
  Future<void> _reorder() async {
    final movable = (_roles ?? [])
        .where((r) =>
            (r['isSystem'] as bool? ?? false) == false &&
            (r['editable'] as bool? ?? false))
        .toList();

    if (movable.length < 2) {
      _say(AppLocalizations.of(context).needTwoCustomRoles);
      return;
    }

    final ordered = await showModalBottomSheet<List<Map<String, dynamic>>>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _ReorderSheet(roles: movable),
    );
    if (ordered == null) return;

    setState(() => _busy = true);
    try {
      await _api.reorderRoles(
        widget.gym.id,
        [for (final r in ordered) r['id'] as String],
      );
      if (mounted) _say(AppLocalizations.of(context).hierarchySaved);
      await _load();
    } on ApiException catch (e) {
      if (mounted) _say(e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context);
    final roles = _roles;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.roles),
        actions: [
          if (_canReorder)
            IconButton(
              tooltip: t.reorder,
              icon: const Icon(Icons.swap_vert),
              onPressed: _busy ? null : _reorder,
            ),
        ],
      ),
      floatingActionButton: _canCreate
          ? FloatingActionButton.extended(
              onPressed: _busy ? null : () => _openEditor(),
              icon: const Icon(Icons.add),
              label: Text(t.newRole),
            )
          : null,
      body: _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_error!, textAlign: TextAlign.center),
                    const SizedBox(height: 18),
                    FilledButton.tonal(
                        onPressed: _load, child: Text(t.tryAgain)),
                  ],
                ),
              ),
            )
          : roles == null
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                    children: [
                      Text(
                        t.rolesIntro,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),
                      for (final role in roles)
                        _RoleTile(
                          role: role,
                          busy: _busy,
                          onEdit: () => _openEditor(role: role),
                          onDelete: () => _delete(role),
                        ),
                    ],
                  ),
                ),
    );
  }
}

class _RoleTile extends StatelessWidget {
  const _RoleTile({
    required this.role,
    required this.busy,
    required this.onEdit,
    required this.onDelete,
  });

  final Map<String, dynamic> role;
  final bool busy;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context);
    final isSuper = role['isSuper'] as bool? ?? false;
    final isSystem = role['isSystem'] as bool? ?? false;
    final editable = (role['editable'] as bool? ?? false) && !busy;
    final deletable = role['deletable'] as bool? ?? false;
    final staffCount = role['staffCount'] as int? ?? 0;
    final permissionCount = role['permissionCount'] as int? ?? 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(role['name'] as String,
                            style: theme.textTheme.titleMedium),
                      ),
                      if (isSystem) ...[
                        const SizedBox(width: 8),
                        _Badge(
                          label: t.defaultBadge.toUpperCase(),
                          colour: theme.colorScheme.outline,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isSuper
                        ? t.everyPermission
                        : t.permissionCount(permissionCount),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    staffCount == 0
                        ? t.nobodyInThisRole
                        : t.peopleCount(staffCount),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (editable)
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') onEdit();
                  if (value == 'delete') onDelete();
                },
                itemBuilder: (_) => [
                  PopupMenuItem(value: 'edit', child: Text(t.edit)),
                  PopupMenuItem(
                    value: 'delete',
                    // Disabled with the reason attached, rather than absent
                    // and unexplained.
                    enabled: deletable,
                    child: Text(
                      deletable
                          ? t.delete
                          : isSystem
                              ? t.deleteDefaultRolesStay
                              : t.deleteMovePeopleFirst,
                      style: TextStyle(
                        color: deletable
                            ? theme.colorScheme.error
                            : theme.disabledColor,
                      ),
                    ),
                  ),
                ],
              )
            else
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Icon(Icons.lock_outline,
                    size: 18, color: theme.colorScheme.outline),
              ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.colour});

  final String label;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: colour),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9,
          letterSpacing: 0.7,
          fontWeight: FontWeight.w700,
          color: colour,
        ),
      ),
    );
  }
}

/// Creating a role and editing one are the same screen: the same fields,
/// the same rules, and the same catalogue.
class RoleEditorPage extends StatefulWidget {
  const RoleEditorPage({super.key, required this.gym, this.roleId});

  final GymDetail gym;
  final String? roleId;

  @override
  State<RoleEditorPage> createState() => _RoleEditorPageState();
}

class _RoleEditorPageState extends State<RoleEditorPage> {
  final _name = TextEditingController();
  final Set<String> _selected = {};
  List<Map<String, dynamic>> _groups = const [];
  bool _loading = true;
  bool _saving = false;
  bool _isSuper = false;
  String? _error;

  GymApi get _api => GymApi(context.read<AuthController>().client);

  bool get _editing => widget.roleId != null;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final catalogue = await _api.permissionCatalogue(widget.gym.id);
      final raw = catalogue['groups'];
      final groups =
          raw is List ? raw.cast<Map<String, dynamic>>() : <Map<String, dynamic>>[];

      if (_editing) {
        final role = await _api.role(widget.gym.id, widget.roleId!);
        _name.text = role['name'] as String? ?? '';
        _isSuper = role['isSuper'] as bool? ?? false;
        final held = role['permissions'];
        if (held is List) _selected.addAll(held.cast<String>());
      }

      if (mounted) {
        setState(() {
          _groups = groups;
          _loading = false;
        });
      }
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _error = e.message;
          _loading = false;
        });
      }
    }
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    if (name.length < 2) {
      _say(AppLocalizations.of(context).giveRoleAName);
      return;
    }

    setState(() => _saving = true);
    try {
      if (_editing) {
        await _api.updateRole(
          widget.gym.id,
          widget.roleId!,
          name: name,
          // A super role holds everything implicitly and cannot be narrowed,
          // so do not send a permission set it would have to reject.
          permissions: _isSuper ? null : _selected.toList(),
        );
      } else {
        await _api.createRole(
          widget.gym.id,
          name: name,
          permissions: _selected.toList(),
        );
      }
      if (mounted) Navigator.of(context).pop(true);
    } on ApiException catch (e) {
      if (mounted) {
        _say(e.message);
        setState(() => _saving = false);
      }
    }
  }

  void _say(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(_editing ? t.editRole : t.newRole)),
      bottomNavigationBar: _loading || _error != null
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: FilledButton(
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2.5),
                        )
                      : Text(_editing ? t.save : t.createRole),
                ),
              ),
            ),
      body: _error != null
          ? Center(child: Padding(padding: const EdgeInsets.all(28), child: Text(_error!)))
          : _loading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  children: [
                    TextField(
                      controller: _name,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText: t.roleName,
                        hintText: t.roleNameHint,
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (_isSuper)
                      Card(
                        color: theme.colorScheme.tertiaryContainer
                            .withValues(alpha: 0.5),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(t.superRoleNote),
                        ),
                      )
                    else ...[
                      Text(
                        t.whatThisRoleCanDo,
                        style: theme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        t.greyedOutNote,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 12),
                      for (final group in _groups)
                        _PermissionGroup(
                          title: group['title'] as String? ?? '',
                          permissions: _permissionsOf(group),
                          selected: _selected,
                          onChanged: (permission, on) => setState(() {
                            if (on) {
                              _selected.add(permission);
                            } else {
                              _selected.remove(permission);
                            }
                          }),
                        ),
                    ],
                  ],
                ),
    );
  }

  List<Map<String, dynamic>> _permissionsOf(Map<String, dynamic> group) {
    final raw = group['permissions'];
    return raw is List ? raw.cast<Map<String, dynamic>>() : const [];
  }
}

class _PermissionGroup extends StatelessWidget {
  const _PermissionGroup({
    required this.title,
    required this.permissions,
    required this.selected,
    required this.onChanged,
  });

  final String title;
  final List<Map<String, dynamic>> permissions;
  final Set<String> selected;
  final void Function(String permission, bool on) onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  letterSpacing: 0.9,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                )),
            for (final entry in permissions)
              _PermissionRow(
                entry: entry,
                on: selected.contains(entry['permission']),
                onChanged: onChanged,
              ),
          ],
        ),
      ),
    );
  }
}

class _PermissionRow extends StatelessWidget {
  const _PermissionRow({
    required this.entry,
    required this.on,
    required this.onChanged,
  });

  final Map<String, dynamic> entry;
  final bool on;
  final void Function(String permission, bool on) onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context);
    final permission = entry['permission'] as String;
    final grantable = entry['grantable'] as bool? ?? false;
    final never = entry['neverGrantable'] as bool? ?? false;

    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      value: on,
      onChanged: grantable ? (v) => onChanged(permission, v ?? false) : null,
      title: Text(
        entry['label'] as String? ?? permission,
        style: TextStyle(
          color: grantable ? null : theme.disabledColor,
        ),
      ),
      subtitle: never
          ? Text(t.ownerOnlyPermission,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant))
          : grantable
              ? null
              : Text(t.youDoNotHoldThis,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
    );
  }
}

/// Drag to re-rank. Only the roles the caller may move are in the list, so
/// there is nothing here that the server would refuse.
class _ReorderSheet extends StatefulWidget {
  const _ReorderSheet({required this.roles});

  final List<Map<String, dynamic>> roles;

  @override
  State<_ReorderSheet> createState() => _ReorderSheetState();
}

class _ReorderSheetState extends State<_ReorderSheet> {
  late final List<Map<String, dynamic>> _order = [...widget.roles];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.orderTheHierarchy, style: theme.textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
            t.hierarchyNote,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 12),
          Flexible(
            child: ReorderableListView(
              shrinkWrap: true,
              onReorderItem: (from, to) => setState(() {
                _order.insert(to, _order.removeAt(from));
              }),
              children: [
                for (final role in _order)
                  ListTile(
                    key: ValueKey(role['id']),
                    leading: const Icon(Icons.drag_handle),
                    title: Text(role['name'] as String),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.of(context).pop(_order),
              child: Text(t.saveOrder),
            ),
          ),
        ],
      ),
    );
  }
}
