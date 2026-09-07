import 'package:flutter/material.dart';

import '../../core/config/app_config.dart';
import '../../l10n/app_localizations.dart';

/// The header mark, the cleartext warning, and the footer.
///
/// All three live together because they are the parts that appear on every
/// screen and have to agree with each other. The spec asks for a header and
/// a footer at every end of every app; keeping them in one file is what
/// stops one screen quietly growing its own.
class GymologiaMark extends StatelessWidget {
  const GymologiaMark({super.key, this.size = 32});

  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: BorderRadius.circular(size * 0.28),
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.redeem_outlined,
        size: size * 0.58,
        color: scheme.onPrimary,
      ),
    );
  }
}

/// The plain-http warning.
///
/// This is not a nicety and it is not a debug affordance. While the API has
/// no certificate, everything this app sends travels in the clear on
/// whatever network the phone is on — the OTP code, the session token, and
/// on this app in particular the UPI ID somebody's money is going to. Any
/// build that can reach the server over http says so on every screen, and
/// the banner disappears by itself the moment the base URL is https.
class CleartextBanner extends StatelessWidget {
  const CleartextBanner({super.key});

  @override
  Widget build(BuildContext context) {
    if (!AppConfig.isCleartext) return const SizedBox.shrink();
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      color: scheme.errorContainer,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      child: Text(
        AppLocalizations.of(context).cleartextWarning(AppConfig.displayHost),
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 11, color: scheme.onErrorContainer),
      ),
    );
  }
}

/// The footer, on every screen that has a bottom.
class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(height: 1),
          const SizedBox(height: 8),
          Text(
            '${t.footerLine}  ·  ${t.footerSupport}',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
