import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/config/app_config.dart';
import '../auth/auth_controller.dart';
import '../broadcast/broadcast_page.dart';
import '../dashboard/dashboard_page.dart';
import '../kyc/kyc_page.dart';
import '../payouts/payouts_page.dart';
import '../logs/logs_page.dart';
import '../staff/staff_page.dart';
import '../tickets/tickets_page.dart';

/// The console frame.
///
/// A rail on a wide window and a drawer on a narrow one, because this is
/// used on a laptop most of the time and on a phone when something is on
/// fire at the weekend.
///
/// Sections the signed-in role cannot reach are not drawn. That is for
/// tidiness, not for safety: the server refuses them regardless, and
/// customer support is turned away from the audit log there whether or not
/// this app offers the button.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();

    final sections = <_Section>[
      const _Section('dashboard', 'Dashboard', Icons.insights_outlined,
          Icons.insights, DashboardPage()),
      if (auth.can('kyc'))
        const _Section('kyc', 'Verification', Icons.verified_outlined,
            Icons.verified, KycPage()),
      if (auth.can('tickets'))
        const _Section('tickets', 'Support', Icons.support_agent_outlined,
            Icons.support_agent, TicketsPage()),
      if (auth.can('broadcast'))
        const _Section('broadcast', 'Announce', Icons.campaign_outlined,
            Icons.campaign, BroadcastPage()),
      if (auth.can('payouts'))
        const _Section('payouts', 'Payouts', Icons.payments_outlined,
            Icons.payments, PayoutsPage()),
      if (auth.can('staff'))
        const _Section('staff', 'Staff', Icons.badge_outlined, Icons.badge,
            StaffPage()),
      if (auth.can('logs'))
        const _Section('logs', 'Logs', Icons.receipt_long_outlined,
            Icons.receipt_long, LogsPage()),
    ];

    final index = _index.clamp(0, sections.length - 1);
    final wide = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      appBar: AppBar(
        title: Text('Gymologia HQ · ${sections[index].label}'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Center(
              child: Text(
                '${auth.name}  ·  ${_pretty(auth.role)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout),
            onPressed: () => auth.signOut(),
          ),
        ],
        bottom: AppConfig.isCleartext
            ? PreferredSize(
                preferredSize: const Size.fromHeight(22),
                child: Container(
                  width: double.infinity,
                  color: Theme.of(context).colorScheme.errorContainer,
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Text(
                    'Connected to ${AppConfig.displayHost} over plain http',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              )
            : null,
      ),
      drawer: wide
          ? null
          : Drawer(
              child: SafeArea(
                child: ListView(
                  children: [
                    for (var i = 0; i < sections.length; i++)
                      ListTile(
                        leading: Icon(sections[i].icon),
                        title: Text(sections[i].label),
                        selected: i == index,
                        onTap: () {
                          setState(() => _index = i);
                          Navigator.of(context).pop();
                        },
                      ),
                  ],
                ),
              ),
            ),
      body: Row(
        children: [
          if (wide)
            NavigationRail(
              extended: MediaQuery.of(context).size.width >= 1200,
              selectedIndex: index,
              onDestinationSelected: (i) => setState(() => _index = i),
              destinations: [
                for (final s in sections)
                  NavigationRailDestination(
                    icon: Icon(s.icon),
                    selectedIcon: Icon(s.selectedIcon),
                    label: Text(s.label),
                  ),
              ],
            ),
          if (wide) const VerticalDivider(width: 1),
          Expanded(child: sections[index].page),
        ],
      ),
    );
  }

  String _pretty(String role) =>
      role.replaceAll('_', ' ').toLowerCase().replaceRange(0, 1, role.isEmpty ? '' : role[0]);
}

class _Section {
  const _Section(this.key, this.label, this.icon, this.selectedIcon, this.page);
  final String key;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final Widget page;
}
