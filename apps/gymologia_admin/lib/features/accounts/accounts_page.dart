import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/api/api_client.dart';
import '../auth/auth_controller.dart';

/// Find an app account by its number, and ban or unban it.
///
/// A ban signs the person out of every device at once and refuses every
/// login after that. Their gyms, memberships and messages stay as they are,
/// so lifting the ban puts everything back.
///
/// Support can look; MANAGER and up can act. Each ban and unban needs a
/// reason, which goes to the audit log with the name of whoever did it.
/// Nobody can ban themselves, and only an owner can ban someone on the
/// internal team -- the server enforces all of this regardless.
class AccountsPage extends StatefulWidget {
  const AccountsPage({super.key});

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  final _phone = TextEditingController();
  Map<String, dynamic>? _account;
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  String get _digits => _phone.text.replaceAll(RegExp(r'\D'), '');

  Future<void> _find() async {
    FocusScope.of(context).unfocus();
    if (_digits.length != 10) {
      setState(() => _error = 'Enter the 10-digit number.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
      _account = null;
    });
    try {
      final a =
          await context.read<AuthController>().api.findAccount('+91$_digits');
      if (mounted) setState(() => _account = a);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _change({required bool ban}) async {
    final a = _account!;
    final reason = await showDialog<String>(
      context: context,
      builder: (_) => _ReasonDialog(ban: ban, name: '${a['name'] ?? ''}'),
    );
    if (reason == null || !mounted) return;

    setState(() => _busy = true);
    final api = context.read<AuthController>().api;
    try {
      final updated = ban
          ? await api.banAccount(a['id'] as String, reason)
          : await api.unbanAccount(a['id'] as String, reason);
      if (!mounted) return;
      setState(() => _account = updated);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(ban
            ? '${a['name']} is banned and signed out everywhere.'
            : '${a['name']} can sign in again.'),
      ));
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canBan = context.watch<AuthController>().can('banAccounts');

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                controller: _phone,
                enabled: !_busy,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                onSubmitted: (_) => _find(),
                decoration: const InputDecoration(
                  labelText: 'Phone number',
                  prefixText: '+91 ',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              height: 56,
              child: FilledButton.icon(
                onPressed: _busy ? null : _find,
                icon: const Icon(Icons.search),
                label: const Text('Find'),
              ),
            ),
          ],
        ),
        if (_error != null) ...[
          const SizedBox(height: 16),
          Text(_error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error)),
        ],
        if (_busy && _account == null) ...[
          const SizedBox(height: 32),
          const Center(child: CircularProgressIndicator()),
        ],
        if (_account != null) ...[
          const SizedBox(height: 16),
          _AccountCard(
            account: _account!,
            busy: _busy,
            canBan: canBan,
            onBan: () => _change(ban: true),
            onUnban: () => _change(ban: false),
          ),
        ],
      ],
    );
  }
}

class _AccountCard extends StatelessWidget {
  const _AccountCard({
    required this.account,
    required this.busy,
    required this.canBan,
    required this.onBan,
    required this.onUnban,
  });

  final Map<String, dynamic> account;
  final bool busy;
  final bool canBan;
  final VoidCallback onBan;
  final VoidCallback onUnban;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final banned = account['status'] == 'SUSPENDED';
    final ban = account['ban'] as Map<String, dynamic>?;
    final isTeam = account['isAdminStaff'] == true;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  child: Text('${account['name'] ?? '?'}'
                      .characters
                      .first
                      .toUpperCase()),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${account['name'] ?? ''}',
                          style: Theme.of(context).textTheme.titleMedium),
                      Text('${account['phone'] ?? ''}'),
                    ],
                  ),
                ),
                Chip(
                  label: Text(banned ? 'BANNED' : 'ACTIVE'),
                  backgroundColor:
                      banned ? scheme.errorContainer : scheme.secondaryContainer,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 4,
              children: [
                Text('Joined ${_date(account['createdAt'])}'),
                Text('Last login ${_date(account['lastLoginAt'])}'),
                Text('Owns ${account['gymsOwned'] ?? 0} gym(s)'),
                Text('Member of ${account['memberships'] ?? 0}'),
                Text('Staff at ${account['staffRoles'] ?? 0}'),
                if (isTeam) const Text('On the internal team'),
              ],
            ),
            if (banned && ban != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: scheme.errorContainer.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Banned ${_date(ban['at'])}'
                  '${ban['by'] != null ? ' by ${ban['by']}' : ''}\n'
                  'Reason: ${ban['reason'] ?? '-'}',
                ),
              ),
            ],
            if (canBan) ...[
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: banned
                    ? FilledButton.tonalIcon(
                        onPressed: busy ? null : onUnban,
                        icon: const Icon(Icons.lock_open),
                        label: const Text('Lift ban'),
                      )
                    : FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: scheme.error,
                          foregroundColor: scheme.onError,
                        ),
                        onPressed: busy ? null : onBan,
                        icon: const Icon(Icons.block),
                        label: const Text('Ban account'),
                      ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  static String _date(Object? iso) {
    final d = iso is String ? DateTime.tryParse(iso)?.toLocal() : null;
    if (d == null) return 'never';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }
}

class _ReasonDialog extends StatefulWidget {
  const _ReasonDialog({required this.ban, required this.name});
  final bool ban;
  final String name;

  @override
  State<_ReasonDialog> createState() => _ReasonDialogState();
}

class _ReasonDialogState extends State<_ReasonDialog> {
  final _reason = TextEditingController();

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  bool get _valid => _reason.text.trim().length >= 5;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.ban ? 'Ban ${widget.name}?' : 'Lift the ban?'),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.ban
                ? 'They are signed out of every device now and cannot sign in '
                    'again until the ban is lifted. Their gyms and data stay.'
                : 'They will be able to sign in again.'),
            const SizedBox(height: 12),
            TextField(
              controller: _reason,
              autofocus: true,
              maxLength: 300,
              maxLines: 3,
              minLines: 1,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: 'Reason (saved in the audit log)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed:
              _valid ? () => Navigator.of(context).pop(_reason.text.trim()) : null,
          child: Text(widget.ban ? 'Ban' : 'Lift ban'),
        ),
      ],
    );
  }
}
