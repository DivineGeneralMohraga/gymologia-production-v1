import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/api/api_client.dart';
import '../auth/auth_controller.dart';

/// The audit and security logs, and the addresses currently refused.
///
/// Admin-only: customer support deliberately cannot open these, on the
/// server as well as here. Names in the audit log are resolved separately
/// rather than joined, so a line still reads after the gym or account it
/// describes has been deleted.
class LogsPage extends StatefulWidget {
  const LogsPage({super.key});

  @override
  State<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  String _tab = 'audit';
  List<dynamic>? _rows;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _error = null;
      _rows = null;
    });
    final api = context.read<AuthController>().api;
    try {
      final rows = switch (_tab) {
        'security' => await api.securityLog(),
        'blocks' => await api.blocks(),
        _ => await api.auditLog(),
      };
      if (mounted) setState(() => _rows = rows);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'audit', label: Text('Audit')),
              ButtonSegment(value: 'security', label: Text('Security')),
              ButtonSegment(value: 'blocks', label: Text('Blocked IPs')),
            ],
            selected: {_tab},
            onSelectionChanged: (s) {
              setState(() => _tab = s.first);
              _load();
            },
          ),
        ),
        Expanded(child: _body()),
      ],
    );
  }

  Widget _body() {
    if (_error != null) {
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(_error!),
          const SizedBox(height: 12),
          FilledButton(onPressed: _load, child: const Text('Try again')),
        ]),
      );
    }
    if (_rows == null) return const Center(child: CircularProgressIndicator());
    if (_rows!.isEmpty) {
      return Center(
        child: Text(_tab == 'blocks'
            ? 'No address is currently refused.'
            : 'Nothing recorded yet.'),
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: _rows!.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (_, i) {
          final r = _rows![i] as Map<String, dynamic>;
          if (_tab == 'blocks') return _blockTile(r);
          if (_tab == 'security') return _securityTile(r);
          return _auditTile(r);
        },
      ),
    );
  }

  Widget _auditTile(Map<String, dynamic> r) => ListTile(
        dense: true,
        title: Text('${r['action'] ?? ''}'),
        subtitle: Text(
          '${r['actorName'] ?? r['actorId'] ?? 'system'}'
          '${r['gymName'] != null ? '  ·  ${r['gymName']}' : ''}'
          '  ·  ${_when(r['createdAt'])}',
        ),
      );

  Widget _securityTile(Map<String, dynamic> r) {
    final severity = '${r['severity'] ?? ''}';
    final high = severity == 'HIGH' || severity == 'CRITICAL';
    return ListTile(
      dense: true,
      leading: Icon(
        high ? Icons.gpp_maybe : Icons.shield_outlined,
        color: high ? Theme.of(context).colorScheme.error : null,
      ),
      title: Text('${r['type'] ?? ''}'),
      subtitle: Text(
        '${r['ip'] ?? '—'}  ·  $severity  ·  ${_when(r['createdAt'])}'
        '${r['route'] != null ? '\n${r['route']}' : ''}',
      ),
      isThreeLine: r['route'] != null,
    );
  }

  Widget _blockTile(Map<String, dynamic> r) => ListTile(
        dense: true,
        leading: const Icon(Icons.block),
        title: Text('${r['ip'] ?? ''}'),
        subtitle: Text('Refused for another ${r['expiresInSeconds'] ?? '?'}s'),
        // An automatic decision about a real person that nobody can inspect
        // or reverse is the wrong kind of automatic. Carrier NAT means one
        // address can carry a whole town.
        trailing: TextButton(
          onPressed: () => _unblock('${r['ip']}'),
          child: const Text('Lift'),
        ),
      );

  Future<void> _unblock(String ip) async {
    try {
      await context.read<AuthController>().api.unblock(ip);
      _load();
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  String _when(Object? iso) {
    if (iso is! String) return '';
    final t = DateTime.tryParse(iso);
    if (t == null) return '';
    final local = t.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(local.day)}/${two(local.month)} ${two(local.hour)}:${two(local.minute)}';
  }
}
