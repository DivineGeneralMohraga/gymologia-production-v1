import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/config/app_config.dart';
import '../../l10n/app_localizations.dart';
import '../code/code_page.dart';
import '../earnings/earnings_page.dart';
import '../payout/payout_page.dart';
import '../referral/referral_controller.dart';
import '../settings/settings_page.dart';
import 'branding.dart';

/// The frame: header, four tabs, footer.
///
/// The tabs are kept alive across switches with an IndexedStack rather than
/// rebuilt, so moving between them does not refetch — the account is loaded
/// once, here, and the tabs read it.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    // After the first frame: the controller notifies listeners as it loads,
    // and notifying during build is an error.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<ReferralController>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    final titles = [t.yourCodeTitle, t.earningsTitle, t.payoutTitle, t.settingsTitle];
    final destinations = [
      NavigationDestination(
          icon: const Icon(Icons.qr_code_2_outlined),
          selectedIcon: const Icon(Icons.qr_code_2),
          label: t.tabCode),
      NavigationDestination(
          icon: const Icon(Icons.payments_outlined),
          selectedIcon: const Icon(Icons.payments),
          label: t.tabEarnings),
      NavigationDestination(
          icon: const Icon(Icons.account_balance_outlined),
          selectedIcon: const Icon(Icons.account_balance),
          label: t.tabPayout),
      NavigationDestination(
          icon: const Icon(Icons.settings_outlined),
          selectedIcon: const Icon(Icons.settings),
          label: t.tabSettings),
    ];

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 12,
        title: Row(
          children: [
            const GymologiaMark(size: 28),
            const SizedBox(width: 10),
            Expanded(
              child: Text(titles[_index], overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
        // Null rather than a strip that renders nothing: a
        // PreferredSize still reserves its height, so an https
        // build would carry a 22px gap under the header for a
        // warning that is not there.
        bottom: AppConfig.isCleartext ? const _CleartextStrip() : null,
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: IndexedStack(
                index: _index,
                children: const [
                  CodePage(),
                  EarningsPage(),
                  PayoutPage(),
                  SettingsPage(),
                ],
              ),
            ),
            const AppFooter(),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: destinations,
      ),
    );
  }
}

/// The cleartext warning, sized so the AppBar can host it.
class _CleartextStrip extends StatelessWidget implements PreferredSizeWidget {
  const _CleartextStrip();

  @override
  Size get preferredSize => const Size.fromHeight(22);

  @override
  Widget build(BuildContext context) => const CleartextBanner();
}
