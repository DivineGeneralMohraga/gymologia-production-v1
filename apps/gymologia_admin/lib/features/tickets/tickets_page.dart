import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/api/api_client.dart';
import '../auth/auth_controller.dart';

/// The support queue.
///
/// Urgent first, then oldest — sorting purely by age buries the gym that
/// cannot operate under a week of routine questions. Phone numbers arrive
/// masked from the server, so this screen is not a way to copy every number
/// on the platform.
class TicketsPage extends StatefulWidget {
  const TicketsPage({super.key});

  @override
  State<TicketsPage> createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  List<dynamic>? _tickets;
  String? _error;
  String _filter = 'OPEN';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final t = await context
          .read<AuthController>()
          .api
          .tickets(status: _filter == 'ALL' ? null : _filter);
      if (mounted) setState(() => _tickets = t);
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
              ButtonSegment(value: 'OPEN', label: Text('Open')),
              ButtonSegment(value: 'RESOLVED', label: Text('Resolved')),
              ButtonSegment(value: 'ALL', label: Text('All')),
            ],
            selected: {_filter},
            onSelectionChanged: (s) {
              setState(() {
                _filter = s.first;
                _tickets = null;
              });
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
    if (_tickets == null) return const Center(child: CircularProgressIndicator());
    if (_tickets!.isEmpty) return const Center(child: Text('Nothing here.'));

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: _tickets!.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (_, i) {
          final t = _tickets![i] as Map<String, dynamic>;
          final urgent = t['priority'] == 'URGENT';
          return Card(
            child: ListTile(
              leading: Icon(
                urgent ? Icons.priority_high : Icons.support_agent,
                color: urgent ? Theme.of(context).colorScheme.error : null,
              ),
              title: Text('${t['subject'] ?? 'Support request'}'),
              subtitle: Text(
                '${t['phoneMasked'] ?? ''}  ·  ${t['status'] ?? ''}'
                '${t['claimedBy'] != null ? '  ·  with ${t['claimedBy']}' : ''}',
              ),
              onTap: () => _open(t),
            ),
          );
        },
      ),
    );
  }

  Future<void> _open(Map<String, dynamic> t) async {
    final changed = await showDialog<bool>(
      context: context,
      builder: (_) => _TicketDialog(ticket: t),
    );
    if (changed == true) _load();
  }
}

class _TicketDialog extends StatefulWidget {
  const _TicketDialog({required this.ticket});
  final Map<String, dynamic> ticket;

  @override
  State<_TicketDialog> createState() => _TicketDialogState();
}

class _TicketDialogState extends State<_TicketDialog> {
  final _note = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await action();
      if (mounted) Navigator.of(context).pop(true);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.ticket;
    final api = context.read<AuthController>().api;
    final id = t['id'] as String;
    final resolved = t['status'] == 'RESOLVED';

    return AlertDialog(
      title: Text('${t['subject'] ?? 'Support request'}'),
      content: SizedBox(
        width: 460,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${t['phoneMasked'] ?? ''}   ${t['status'] ?? ''}'),
              const SizedBox(height: 10),
              Text('${t['message'] ?? ''}'),
              if (!resolved) ...[
                const SizedBox(height: 16),
                TextField(
                  controller: _note,
                  minLines: 2,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Resolution note',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
              if (_error != null) ...[
                const SizedBox(height: 8),
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
          child: const Text('Close'),
        ),
        if (!resolved && t['claimedBy'] == null)
          TextButton(
            onPressed: _busy ? null : () => _run(() => api.claimTicket(id)),
            child: const Text('Claim'),
          ),
        if (!resolved)
          FilledButton(
            onPressed: _busy
                ? null
                : () => _run(() => api.resolveTicket(id, _note.text.trim())),
            child: const Text('Resolve'),
          ),
      ],
    );
  }
}
