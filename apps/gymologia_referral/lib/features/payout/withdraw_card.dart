import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/api/error_text.dart';
import '../../core/money.dart';
import '../../l10n/app_localizations.dart';
import '../referral/referral_controller.dart';

/// Taking the money out.
///
/// Every figure here comes from the server on the same response — the
/// gross, the one-time check, and what actually arrives. Nothing is
/// computed on the phone. A deduction worked out locally would eventually
/// disagree with the amount actually sent, and the person holding the
/// phone would be right to believe the phone.
///
/// The button is disabled with the reason shown rather than offered and
/// then refused. The server orders those reasons so the most useful leads:
/// straight after a withdrawal, "one is already on its way" beats
/// "nothing is available", which is technically also true and reads like
/// the money vanished.
class WithdrawCard extends StatefulWidget {
  const WithdrawCard({super.key});

  @override
  State<WithdrawCard> createState() => _WithdrawCardState();
}

class _WithdrawCardState extends State<WithdrawCard> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final referral = context.watch<ReferralController>();
    final w = referral.withdrawable;

    int paise(String key) {
      final v = w[key];
      return v is num ? v.toInt() : 0;
    }

    final gross = paise('grossPaise');
    final fee = paise('verifyFeePaise');
    final net = paise('netPaise');
    final blocked = referral.withdrawBlockedBy;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.withdrawTitle,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _line(t.withdrawAvailable, Money.format(gross), strong: true),
            if (fee > 0) _line(t.withdrawFee, '− ${Money.format(fee)}'),
            const Divider(height: 20),
            _line(t.withdrawArrives, Money.format(net), strong: true),
            if (fee > 0) ...[
              const SizedBox(height: 8),
              Text(
                t.withdrawFeeWhy(Money.format(fee)),
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
            const SizedBox(height: 6),
            Text(
              t.withdrawNoTax,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            if (blocked != null) ...[
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline,
                      size: 16, color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(width: 8),
                  // The server's sentence, verbatim. It knows which of
                  // several true reasons matters most right now.
                  Expanded(
                    child: Text(blocked,
                        style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant)),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed:
                    (referral.canWithdraw && !_busy) ? () => _withdraw(net) : null,
                icon: _busy
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.account_balance_wallet_outlined, size: 18),
                label: Text(t.withdrawButton(Money.format(net))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _withdraw(int net) async {
    final t = AppLocalizations.of(context);
    final referral = context.read<ReferralController>();
    final messenger = ScaffoldMessenger.of(context);
    final masked = '${referral.payout['upiIdMasked'] ?? ''}';

    // Confirmed against the masked address, not just the amount. This is
    // the last moment anybody looks at where the money is going, and a UPI
    // address has no checksum -- one wrong letter is somebody else's
    // perfectly valid account and the transfer does not come back.
    final go = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.withdrawConfirm(Money.format(net), masked)),
        content: Text(t.withdrawConfirmBody),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(t.cancel)),
          FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(t.withdrawButton(Money.format(net)))),
        ],
      ),
    );
    if (go != true || !mounted) return;

    setState(() => _busy = true);
    final failure = await referral.withdraw();
    // Guarded here rather than in the controller: this is the layer that
    // has a `mounted` to check.
    if (!mounted) return;
    setState(() => _busy = false);
    messenger.showSnackBar(
      SnackBar(
        content: Text(failure == null
            ? t.withdrawRequested
            : apiErrorText(context, failure)),
      ),
    );
  }

  Widget _line(String label, String value, {bool strong = false}) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          Text(
            value,
            style: (strong
                    ? theme.textTheme.titleMedium
                    : theme.textTheme.bodyMedium)
                ?.copyWith(fontWeight: strong ? FontWeight.bold : null),
          ),
        ],
      ),
    );
  }
}

/// What has been asked for, and what happened to it.
class WithdrawHistory extends StatelessWidget {
  const WithdrawHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final rows = context.watch<ReferralController>().withdrawals;

    if (rows == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(t.withdrawHistoryTitle,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        if (rows.isEmpty)
          Text(t.withdrawNone,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant))
        else
          for (final row in rows.cast<Map<String, dynamic>>())
            Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(Money.format(
                    (row['netPaise'] as num?)?.toInt() ?? 0)),
                subtitle: Text(_subtitle(t, row)),
                isThreeLine: row['utr'] != null,
              ),
            ),
      ],
    );
  }

  static String _subtitle(AppLocalizations t, Map<String, dynamic> row) {
    final status = switch ('${row['status']}') {
      'QUEUED' => t.withdrawStatusQueued,
      'PROCESSING' => t.withdrawStatusProcessing,
      'SUCCESS' => t.withdrawStatusSuccess,
      'FAILED' => t.withdrawStatusFailed,
      'REVERSED' => t.withdrawStatusReversed,
      _ => '${row['status']}',
    };
    final parts = <String>[status];
    // The UTR, not our transfer id: it is the reference the referrer's own
    // bank will recognise if they ever have to chase the money.
    if (row['utr'] != null) parts.add(t.withdrawUtr('${row['utr']}'));
    if (row['failureReason'] != null) parts.add('${row['failureReason']}');
    return parts.join('  ·  ');
  }
}
