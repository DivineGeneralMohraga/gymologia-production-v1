import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/money.dart';
import '../../l10n/app_localizations.dart';
import '../referral/referral_controller.dart';

/// One row per reward, newest first.
///
/// The point of this screen is that a total is not something a person can
/// check. Somebody who handed their code to three gym owners and is shown
/// ₹100 has no way, from a number, to work out which of the three did not
/// count. Each row names the gym and says where the money has got to.
///
/// A reversed reward stays in the list. A refunded subscription takes the
/// reward back, and a reward that silently disappears is how a support
/// ticket gets written.
class EarningsPage extends StatelessWidget {
  const EarningsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final referral = context.watch<ReferralController>();
    final rows = referral.earnings;

    if (rows == null) {
      if (referral.loading) {
        return const Center(child: CircularProgressIndicator());
      }
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(referral.failureText(context, t.genericError), textAlign: TextAlign.center),
              const SizedBox(height: 14),
              FilledButton(
                onPressed: () => referral.load(),
                child: Text(t.tryAgain),
              ),
            ],
          ),
        ),
      );
    }

    if (rows.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => referral.load(quiet: true),
        child: ListView(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.22),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                t.earningsEmpty,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => referral.load(quiet: true),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
        itemCount: rows.length + (referral.earningsCapped ? 1 : 0),
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          if (i == rows.length) {
            // Said rather than inferred from a list that stops: the API
            // caps the page, and somebody with more rewards than that
            // should be told the screen is not showing all of them.
            return Padding(
              padding: const EdgeInsets.fromLTRB(8, 14, 8, 0),
              child: Text(
                t.earningsCapped(rows.length),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            );
          }
          return _RewardRow(row: (rows[i] as Map).cast<String, dynamic>());
        },
      ),
    );
  }
}

class _RewardRow extends StatelessWidget {
  const _RewardRow({required this.row});

  final Map<String, dynamic> row;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final status = '${row['status'] ?? ''}';
    final reversed = status == 'REVERSED';

    final label = switch (status) {
      'PENDING' => t.statusPending,
      'ELIGIBLE' => t.statusEligible,
      'PAID' => t.statusPaid,
      'REVERSED' => t.statusReversed,
      _ => status,
    };
    final why = switch (status) {
      'PENDING' => t.statusPendingWhy,
      'ELIGIBLE' => t.statusEligibleWhy,
      'PAID' => t.statusPaidWhy,
      'REVERSED' => t.statusReversedWhy,
      _ => '',
    };

    final paise = row['rewardPaise'];
    final amount = Money.format(paise is num ? paise.toInt() : 0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    '${row['gymName'] ?? ''}',
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  amount,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    // Struck through rather than hidden or shown in red:
                    // the row is a fact that happened and then unhappened,
                    // and that reads at a glance.
                    decoration: reversed ? TextDecoration.lineThrough : null,
                    color: reversed ? theme.colorScheme.onSurfaceVariant : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                _Chip(label: label, muted: reversed),
                const SizedBox(width: 8),
                Text(
                  _when(context, row['createdAt']),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            if (why.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                why,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// The date, in the reader's own language.
  ///
  /// Parsed as UTC and shown local, which is what the server sends. A bare
  /// `DateTime.parse` on a value without a zone would be read as local and
  /// silently shift the date near midnight.
  static String _when(BuildContext context, Object? iso) {
    if (iso is! String || iso.isEmpty) return '';
    final parsed = DateTime.tryParse(iso);
    if (parsed == null) return '';
    final locale = Localizations.localeOf(context).toLanguageTag();
    return DateFormat.yMMMd(locale).format(parsed.toLocal());
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.muted});

  final String label;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: muted ? scheme.surfaceContainerHighest : scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: muted ? scheme.onSurfaceVariant : scheme.onSecondaryContainer,
        ),
      ),
    );
  }
}
