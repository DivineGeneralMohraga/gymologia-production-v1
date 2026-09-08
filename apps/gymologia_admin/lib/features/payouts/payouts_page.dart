import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/api/api_client.dart';
import '../auth/auth_controller.dart';

/// The payout desk.
///
/// The only screen in this console where pressing a button causes money to
/// leave, which is why sending is one payout at a time with a confirmation
/// naming the amount and the masked address, and why there is no
/// "send everything" control. A queue that can be emptied in one tap is a
/// queue that will be emptied by accident.
///
/// The reason nothing can be sent, when that is the case, is shown at the
/// top rather than left to be inferred from a list of held money. A backlog
/// with no explanation reads as a bug; a backlog with "the Verification
/// credentials are not set" reads as a task.
class PayoutsPage extends StatefulWidget {
  const PayoutsPage({super.key});

  @override
  State<PayoutsPage> createState() => _PayoutsPageState();
}

class _PayoutsPageState extends State<PayoutsPage> {
  Map<String, dynamic>? _queue;
  String? _error;
  String? _running;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final q = await context.read<AuthController>().api.payoutQueue();
      if (mounted) setState(() => _queue = q);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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

    final blocked = _queue!['blockedReason'] as String?;
    final items = (_queue!['items'] as List?) ?? const [];

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          if (blocked != null)
            Card(
              color: theme.colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.pause_circle_outline,
                        color: theme.colorScheme.onErrorContainer),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nothing can be sent',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onErrorContainer,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            blocked,
                            style: TextStyle(
                                color: theme.colorScheme.onErrorContainer),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Withdrawals stay queued. Nobody loses money; '
                            'it just waits.',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onErrorContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (blocked != null) const SizedBox(height: 12),
          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Text('Nothing waiting to be sent.',
                  textAlign: TextAlign.center),
            )
          else
            for (final row in items.cast<Map<String, dynamic>>())
              _PayoutRow(
                row: row,
                busy: _running == row['id'],
                // Disabled rather than offered-then-refused. The server
                // refuses regardless; this saves somebody the confusion.
                onRun: blocked == null ? () => _run(row) : null,
              ),
          const SizedBox(height: 24),
          Text(
            'Sent one at a time, on purpose. A queue that empties in one tap '
            'is a queue that empties by accident.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Future<void> _run(Map<String, dynamic> row) async {
    final api = context.read<AuthController>().api;
    final messenger = ScaffoldMessenger.of(context);
    final amount = _rupees(row['netPaise']);
    final masked = '${row['upiIdMasked'] ?? 'an unknown address'}';

    final go = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Send $amount to $masked?'),
        content: Text(
          'This moves real money and cannot be undone.\n\n'
          'Referral code ${row['referralCode']}, holder '
          '${row['upiHolderName'] ?? 'unknown'}, address '
          '${row['upiVerified'] == true ? 'verified' : 'NOT VERIFIED'}.',
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text('Send $amount')),
        ],
      ),
    );
    if (go != true || !mounted) return;

    setState(() => _running = row['id'] as String?);
    try {
      final res = await api.runPayout(row['id'] as String);
      // The server's own outcome and detail, verbatim. It knows whether it
      // refused, sent, or left something with Cashfree; paraphrasing that
      // on a screen about money would only lose information.
      messenger.showSnackBar(SnackBar(
        content: Text('${res['outcome']} — ${res['detail']}'),
      ));
    } on ApiException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _running = null);
      await _load();
    }
  }

  static String _rupees(Object? paise) {
    final p = paise is num ? paise.toInt() : 0;
    return NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: p % 100 == 0 ? 0 : 2,
    ).format(p / 100);
  }
}

class _PayoutRow extends StatelessWidget {
  const _PayoutRow({required this.row, required this.busy, this.onRun});

  final Map<String, dynamic> row;
  final bool busy;
  final VoidCallback? onRun;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final verified = row['upiVerified'] == true;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_PayoutsPageState._rupees(row['netPaise'])} to '
                    '${row['upiIdMasked'] ?? '—'}',
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${row['upiHolderName'] ?? '—'}  ·  '
                    'code ${row['referralCode']}  ·  ${row['status']}',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                  if (!verified) ...[
                    const SizedBox(height: 4),
                    Row(children: [
                      Icon(Icons.warning_amber_outlined,
                          size: 14, color: theme.colorScheme.error),
                      const SizedBox(width: 4),
                      // The single most important fact on this row. An
                      // unverified address is one letter away from being
                      // somebody else's, and the transfer does not come back.
                      Text('Address never verified',
                          style: TextStyle(
                              fontSize: 12, color: theme.colorScheme.error)),
                    ]),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            busy
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : OutlinedButton(
                    onPressed: onRun,
                    child: const Text('Send'),
                  ),
          ],
        ),
      ),
    );
  }
}
