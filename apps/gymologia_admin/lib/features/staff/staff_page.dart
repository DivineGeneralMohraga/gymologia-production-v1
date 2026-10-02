import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/api/api_client.dart';
import '../auth/auth_controller.dart';

/// Who works at Gymologia, and what they may do.
///
/// Adding someone is OTP-verified, like adding gym staff — but on a
/// separate purpose, so a code issued to add somebody to a gym can never be
/// redeemed for platform access.
///
/// Two refusals come from the server and are worth knowing before you try:
/// nobody edits their own record, and the last active owner cannot be
/// demoted or switched off. Without that second rule the console locks
/// everyone out with no way back short of the database.
class StaffPage extends StatefulWidget {
  const StaffPage({super.key});

  @override
  State<StaffPage> createState() => _StaffPageState();
}

class _StaffPageState extends State<StaffPage> {
  List<dynamic>? _staff;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final s = await context.read<AuthController>().api.staff();
      if (mounted) setState(() => _staff = s);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final me = context.watch<AuthController>();

    return Scaffold(
      body: _body(me),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.person_add_alt),
        label: const Text('Add staff'),
      ),
    );
  }

  Widget _body(AuthController me) {
    if (_error != null) {
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(_error!),
          const SizedBox(height: 12),
          FilledButton(onPressed: _load, child: const Text('Try again')),
        ]),
      );
    }
    if (_staff == null) return const Center(child: CircularProgressIndicator());
    if (_staff!.isEmpty) return const Center(child: Text('No staff yet.'));

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 88),
        itemCount: _staff!.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (_, i) {
          final s = _staff![i] as Map<String, dynamic>;
          final active = s['status'] == 'ACTIVE';
          final isMe = s['id'] == me.staff?['adminId'];

          return Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Text('${s['name'] ?? '?'}'.characters.first.toUpperCase()),
              ),
              title: Text('${s['name'] ?? ''}${isMe ? '  (you)' : ''}'),
              subtitle: Text(
                '${s['role'] ?? ''}  ·  ${s['phoneMasked'] ?? s['phone'] ?? ''}'
                '${active ? '' : '  ·  disabled'}',
              ),
              trailing: isMe
                  // Nobody edits their own record. Saying so beats offering
                  // a control the server will refuse.
                  ? const Tooltip(
                      message: 'You cannot change your own record',
                      child: Icon(Icons.lock_outline, size: 18),
                    )
                  : PopupMenuButton<String>(
                      onSelected: (v) => _update(s, v),
                      itemBuilder: (_) => [
                        for (final r in AuthController.roles)
                          PopupMenuItem(value: 'role:$r', child: Text('Make $r')),
                        const PopupMenuDivider(),
                        PopupMenuItem(
                          value: active ? 'off' : 'on',
                          child: Text(active ? 'Disable' : 'Enable'),
                        ),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _update(Map<String, dynamic> s, String action) async {
    final api = context.read<AuthController>().api;
    try {
      if (action.startsWith('role:')) {
        await api.updateStaff(s['id'] as String, role: action.substring(5));
      } else {
        await api.updateStaff(
          s['id'] as String,
          status: action == 'on' ? 'ACTIVE' : 'REMOVED',
        );
      }
      _load();
    } on ApiException catch (e) {
      if (mounted) {
        // The server's refusal is the useful message here -- "the last
        // active owner cannot be demoted" explains itself.
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  Future<void> _add() async {
    final added = await showDialog<bool>(
      context: context,
      builder: (_) => const _AddStaffDialog(),
    );
    if (added == true) _load();
  }
}

class _AddStaffDialog extends StatefulWidget {
  const _AddStaffDialog();

  @override
  State<_AddStaffDialog> createState() => _AddStaffDialogState();
}

class _AddStaffDialogState extends State<_AddStaffDialog> {
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _code = TextEditingController();

  String _role = 'CUSTOMER_SUPPORT';
  String? _challengeId;
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _phone.dispose();
    _email.dispose();
    _code.dispose();
    super.dispose();
  }

  String get _e164 => '+91${_phone.text.replaceAll(RegExp(r'\D'), '')}';

  Future<void> _lookup() async {
    if (_phone.text.replaceAll(RegExp(r'\D'), '').length != 10) {
      setState(() => _error = 'Enter the 10-digit number.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final res = await context.read<AuthController>().api.staffLookup(_e164);
      setState(() {
        _challengeId = res['challengeId'] as String?;
      });
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _create() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await context.read<AuthController>().api.addStaff(
            challengeId: _challengeId!,
            phone: _e164,
            code: _code.text.trim(),
            role: _role,
            workEmail: _email.text.trim(),
          );
      if (mounted) Navigator.of(context).pop(true);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final verifying = _challengeId != null;

    return AlertDialog(
      title: const Text('Add internal staff'),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _phone,
                enabled: !verifying && !_busy,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                decoration: const InputDecoration(
                  labelText: 'Phone number',
                  prefixText: '+91 ',
                  border: OutlineInputBorder(),
                ),
              ),
              if (verifying) ...[
                const SizedBox(height: 10),
                TextField(
                  controller: _code,
                  enabled: !_busy,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Code sent to that number',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _email,
                  enabled: !_busy,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      labelText: 'Work email (optional)',
                      helperText: 'Their name is taken from their app account.',
                      border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: _role,
                  decoration: const InputDecoration(
                      labelText: 'Role', border: OutlineInputBorder()),
                  items: [
                    for (final r in AuthController.roles)
                      DropdownMenuItem(value: r, child: Text(r)),
                  ],
                  onChanged: _busy ? null : (v) => setState(() => _role = v ?? _role),
                ),
              ],
              if (_error != null) ...[
                const SizedBox(height: 10),
                Text(_error!,
                    style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _busy ? null : () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _busy ? null : (verifying ? _create : _lookup),
          child: Text(verifying ? 'Add' : 'Send code'),
        ),
      ],
    );
  }
}
