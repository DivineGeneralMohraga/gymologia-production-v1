import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/api/api_client.dart';
import '../auth/auth_controller.dart';

/// The verification desk.
///
/// A reviewer never sees a full Aadhaar, PAN or GSTIN — only the last four
/// digits — and that is not an obstacle to the job. Whether a number is
/// genuine is a question for the issuing registry; what a human is for is
/// the part a registry cannot answer: does this landlord's letter name this
/// address, is the electricity bill in the same name as the PAN.
///
/// Document links are signed per request and expire in minutes, so a link
/// pasted into a chat is already dead by the time anyone opens it.
class KycPage extends StatefulWidget {
  const KycPage({super.key});

  @override
  State<KycPage> createState() => _KycPageState();
}

class _KycPageState extends State<KycPage> {
  List<dynamic>? _queue;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final q = await context.read<AuthController>().api.kycQueue();
      if (mounted) setState(() => _queue = q);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(onPressed: _load, child: const Text('Try again')),
          ]),
        ),
      );
    }
    if (_queue == null) return const Center(child: CircularProgressIndicator());
    if (_queue!.isEmpty) {
      return const Center(child: Text('Nothing waiting for review.'));
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: _queue!.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (_, i) {
          final row = _queue![i] as Map<String, dynamic>;
          return Card(
            child: ListTile(
              // The gym is a nested object, not a gymName string. Read off
              // the response rather than off what read naturally here.
              title: Text(_gymName(row)),
              subtitle: Text(
                '${_where(row)}\n'
                'Aadhaar ••••${row['aadhaarLast4'] ?? '????'}   '
                'PAN ••••${row['panLast4'] ?? '????'}   '
                '${row['premises'] ?? ''}',
              ),
              isThreeLine: true,
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _open(row['gymId'] as String?),
            ),
          );
        },
      ),
    );
  }

  static String _gymName(Map<String, dynamic> row) {
    final gym = row['gym'];
    if (gym is Map && gym['name'] != null) return '${gym['name']}';
    return 'Gym';
  }

  static String _where(Map<String, dynamic> row) {
    final gym = row['gym'];
    if (gym is! Map) return '';
    return [gym['city'], gym['district'], gym['state']]
        .where((p) => p != null && '$p'.isNotEmpty)
        .join(', ');
  }

  Future<void> _open(String? gymId) async {
    if (gymId == null) return;
    final api = context.read<AuthController>().api;
    Map<String, dynamic> detail;
    try {
      detail = await api.kycDetail(gymId);
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
      return;
    }
    if (!mounted) return;

    final decided = await showDialog<bool>(
      context: context,
      builder: (ctx) => _DecisionDialog(detail: detail, gymId: gymId),
    );
    if (decided == true) _load();
  }
}

class _DecisionDialog extends StatefulWidget {
  const _DecisionDialog({required this.detail, required this.gymId});
  final Map<String, dynamic> detail;
  final String gymId;

  @override
  State<_DecisionDialog> createState() => _DecisionDialogState();
}

class _DecisionDialogState extends State<_DecisionDialog> {
  final _reason = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  Future<void> _decide(bool approve) async {
    // A rejection needs a reason of at least ten characters, because the
    // owner is shown it and has to be able to act on it. "Rejected" on its
    // own leaves them resubmitting the same documents.
    if (!approve && _reason.text.trim().length < 10) {
      setState(() => _error =
          'Say why, in enough words that the owner can fix it.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await context.read<AuthController>().api.kycDecide(
            gymId: widget.gymId,
            approve: approve,
            reason: approve ? null : _reason.text.trim(),
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
    final d = widget.detail;
    final docs = <String, String?>{
      'Aadhaar': d['aadhaarUrl'] as String?,
      'PAN': d['panUrl'] as String?,
      'GST': d['gstUrl'] as String?,
      'Other proof': d['altProofUrl'] as String?,
      'Landlord NOC': d['nocUrl'] as String?,
    };

    return AlertDialog(
      title: Text(d['gym'] is Map && (d['gym'] as Map)['name'] != null
          ? '${(d['gym'] as Map)['name']}'
          : 'Verification'),
      content: SizedBox(
        width: 460,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _row('Aadhaar', '••••${d['aadhaarLast4'] ?? '????'}'),
              _row('PAN', '••••${d['panLast4'] ?? '????'}'),
              if (d['gstinLast4'] != null)
                _row('GSTIN', '••••${d['gstinLast4']}'),
              _row('Premises', '${d['premises'] ?? '—'}'),
              const SizedBox(height: 8),
              const Text(
                'Only the last four digits are ever shown. The registry '
                'decides whether a number is real; you decide whether the '
                'documents describe this gym.',
                style: TextStyle(fontSize: 12),
              ),
              const Divider(height: 24),
              for (final e in docs.entries)
                if (e.value != null)
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.description_outlined),
                    title: Text(e.key),
                    subtitle: const Text('Link expires in minutes'),
                  ),
              const SizedBox(height: 8),
              TextField(
                controller: _reason,
                minLines: 2,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Reason (required to reject)',
                  border: OutlineInputBorder(),
                ),
              ),
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
        TextButton(
          onPressed: _busy ? null : () => _decide(false),
          child: const Text('Reject'),
        ),
        FilledButton(
          onPressed: _busy ? null : () => _decide(true),
          child: const Text('Approve'),
        ),
      ],
    );
  }

  Widget _row(String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(children: [
          SizedBox(width: 110, child: Text(k)),
          Expanded(
              child: Text(v, style: const TextStyle(fontWeight: FontWeight.w600))),
        ]),
      );
}
