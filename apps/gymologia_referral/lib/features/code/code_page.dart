import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/config/app_config.dart';
import '../../core/money.dart';
import '../../l10n/app_localizations.dart';
import '../referral/referral_controller.dart';

/// The code, the share button, and what the code has earned so far.
///
/// The sentence that gets shared is the server's, in the language the app
/// is being read in — not assembled here. It is the one string in the
/// product whose reader is somebody else, and building it on the phone
/// would mean ten copies of it drifting from the ten on the server.
class CodePage extends StatelessWidget {
  const CodePage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final referral = context.watch<ReferralController>();

    if (referral.account == null) {
      if (referral.loading) {
        return const Center(child: CircularProgressIndicator());
      }
      return _Failed(message: referral.failureText(context, t.genericError));
    }

    return RefreshIndicator(
      onRefresh: () => referral.load(quiet: true),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
              child: Column(
                children: [
                  Text(
                    t.yourCodeTitle,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SelectableText(
                    referral.code,
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => _copy(context, referral),
                        icon: const Icon(Icons.copy_all_outlined, size: 18),
                        label: Text(t.copyCode),
                      ),
                      const SizedBox(width: 12),
                      FilledButton.icon(
                        onPressed: () => _share(context, referral),
                        icon: const Icon(Icons.ios_share, size: 18),
                        label: Text(t.shareCode),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _Totals(referral: referral),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.howItWorksTitle,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _Step(1, t.howItWorksStep1),
                  _Step(2, t.howItWorksStep2(AppConfig.discountPercent)),
                  _Step(3, t.howItWorksStep3(Money.format(AppConfig.rewardPaise))),
                  _Step(
                      4,
                      t.howItWorksStep4(
                          Money.format(AppConfig.verificationFeePaise))),
                  const SizedBox(height: 10),
                  Text(
                    t.notForOwners,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _copy(BuildContext context, ReferralController referral) async {
    final t = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    await Clipboard.setData(ClipboardData(text: referral.shareText));
    messenger.showSnackBar(SnackBar(content: Text(t.copied)));
  }

  Future<void> _share(BuildContext context, ReferralController referral) async {
    final t = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await SharePlus.instance.share(ShareParams(text: referral.shareText));
    } catch (_) {
      // No share sheet on this platform, or the user's launcher refused it.
      // The message is the point, so it goes to the clipboard instead of
      // being lost to an error the person cannot act on.
      await Clipboard.setData(ClipboardData(text: referral.shareText));
      messenger.showSnackBar(SnackBar(content: Text(t.shareUnavailable)));
    }
  }
}

class _Step extends StatelessWidget {
  const _Step(this.number, this.text);

  final int number;
  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 22,
            width: 22,
            decoration: BoxDecoration(
              color: scheme.secondaryContainer,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '$number',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: scheme.onSecondaryContainer,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

/// Earned, held, paid, withheld — all four straight off the server.
class _Totals extends StatelessWidget {
  const _Totals({required this.referral});

  final ReferralController referral;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final totals = referral.totals;

    int paise(String key) {
      final v = totals[key];
      return v is num ? v.toInt() : 0;
    }

    final used = referral.timesRedeemed;
    final usage = used == 0
        ? t.neverUsed
        : used == 1
            ? t.usedOnce
            : t.timesUsed(used);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(usage, style: theme.textTheme.titleSmall),
            if (referral.awaitingClearance > 0) ...[
              const SizedBox(height: 4),
              Text(
                t.awaitingClearance(referral.awaitingClearance),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const Divider(height: 24),
            _Amount(label: t.earnedTotal, paise: paise('totalEarnedPaise'), strong: true),
            _Amount(label: t.heldPending, paise: paise('pendingPaise')),
            _Amount(label: t.paidOut, paise: paise('totalPaidPaise')),
            if (paise('totalTdsPaise') > 0)
              _Amount(label: t.taxWithheld, paise: paise('totalTdsPaise')),
          ],
        ),
      ),
    );
  }
}

class _Amount extends StatelessWidget {
  const _Amount({required this.label, required this.paise, this.strong = false});

  final String label;
  final int paise;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          Text(
            Money.format(paise),
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

class _Failed extends StatelessWidget {
  const _Failed({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 14),
            FilledButton(
              onPressed: () => context.read<ReferralController>().load(),
              child: Text(t.tryAgain),
            ),
          ],
        ),
      ),
    );
  }
}
