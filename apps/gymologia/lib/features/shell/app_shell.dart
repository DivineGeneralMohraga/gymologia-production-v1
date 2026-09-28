import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../core/api/gym_api.dart';
import '../../core/api/models.dart';
import '../auth/auth_controller.dart';
import '../member/member_home_page.dart';
import '../member/gym_browser_page.dart';
import '../member/events_page.dart';
import '../settings/settings_page.dart';
import '../staff/gym_list_page.dart';
import '../notifications/notifications_page.dart';
import 'app_mode.dart';
import '../../theme.dart';
import '../../ui/kit.dart';

/// The frame both modes live in: a header with the mark and the
/// notification and settings actions, and a footer whose tabs change with
/// the mode.
///
/// Tab sets follow the spec. A member with no membership anywhere gets the
/// gym browser as their first page; once they belong to a gym, the browser
/// moves to the second slot and the membership dashboard takes first
/// place. That is decided from the data, not a setting.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;
  bool _loading = true;
  List<MyMembership> _memberships = const [];
  int _unread = 0;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final api = GymApi(context.read<AuthController>().client);
      final memberships = await api.myMemberships();
      // The badge is a nicety; a failure to read it should not blank the
      // whole shell, so it is fetched separately and defaulted to zero.
      int unread = 0;
      try {
        unread = await api.unreadNotifications();
      } catch (_) {}

      if (!mounted) return;
      setState(() {
        _memberships = memberships;
        _unread = unread;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = '$e';
        _loading = false;
      });
    }
  }

  bool get _hasMembership => _memberships.isNotEmpty;

  /// Labels come from the localisations rather than being constants, so the
  /// bar follows the language the app is being read in.
  List<_Tab> _tabsFor(AppMode mode, AppLocalizations t) {
    if (mode == AppMode.staff) {
      return [
        _Tab(t.gyms, Icons.fitness_center_rounded, Icons.fitness_center_rounded),
        _Tab(t.events, Icons.local_fire_department_outlined, Icons.local_fire_department_rounded),
        _Tab(t.settings, Icons.person_outline_rounded, Icons.person_rounded),
      ];
    }
    // Member mode. The first tab differs depending on whether they belong
    // to a gym.
    return [
      _hasMembership
          ? _Tab(t.myGym, Icons.bolt_outlined, Icons.bolt_rounded)
          : _Tab(t.findAGym, Icons.explore_outlined, Icons.explore_rounded),
      if (_hasMembership)
        _Tab(t.discover, Icons.explore_outlined, Icons.explore_rounded),
      _Tab(t.events, Icons.local_fire_department_outlined, Icons.local_fire_department_rounded),
      _Tab(t.settings, Icons.person_outline_rounded, Icons.person_rounded),
    ];
  }

  Widget _bodyFor(AppMode mode, int index) {
    if (mode == AppMode.staff) {
      return switch (index) {
        0 => const GymListPage(),
        1 => const EventsPage(),
        _ => const SettingsPage(),
      };
    }

    if (!_hasMembership) {
      return switch (index) {
        0 => const GymBrowserPage(),
        1 => const EventsPage(),
        _ => const SettingsPage(),
      };
    }

    return switch (index) {
      0 => MemberHomePage(memberships: _memberships, onChanged: _load),
      1 => const GymBrowserPage(),
      2 => const EventsPage(),
      _ => const SettingsPage(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final modeController = context.watch<AppModeController>();
    final mode = modeController.mode;
    final tabs = _tabsFor(mode, AppLocalizations.of(context));
    final index = _index.clamp(0, tabs.length - 1);

    if (_loading) {
      return const Scaffold(body: Center(child: BrandMark(size: 64)));
    }

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: Row(
          children: [
            Wordmark(name: AppLocalizations.of(context).appName),
            if (mode == AppMode.staff) ...[
              const SizedBox(width: 10),
              Pill(
                AppLocalizations.of(context).staffBadge,
                background: Theme.of(context).colorScheme.tertiary,
                foreground: Theme.of(context).colorScheme.onTertiary,
              ),
            ],
          ],
        ),
        actions: [
          IconButton(
            tooltip: AppLocalizations.of(context).notifications,
            icon: Badge(
              isLabelVisible: _unread > 0,
              label: Text(_unread > 99 ? '99+' : '$_unread'),
              child: const Icon(Icons.notifications_none_rounded, size: 26),
            ),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const NotificationsPage()),
              );
              await _load();
            },
          ),
          IconButton(
            tooltip: AppLocalizations.of(context).settings,
            icon: const Icon(Icons.tune_rounded, size: 25),
            onPressed: () => setState(() => _index = tabs.length - 1),
          ),
        ],
      ),
      body: _error != null
          ? _ErrorState(message: _error!, onRetry: _load)
          : RefreshIndicator(
              onRefresh: _load,
              child: _bodyFor(mode, index),
            ),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: context.gym.cardBorder)),
        ),
        child: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: [
            for (final tab in tabs)
              NavigationDestination(
                icon: Icon(tab.icon),
                selectedIcon: Icon(tab.selectedIcon),
                label: tab.label.toUpperCase(),
              ),
          ],
        ),
      ),
    );
  }
}

class _Tab {
  const _Tab(this.label, this.icon, this.selectedIcon);
  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: EmptyState(
          icon: Icons.cloud_off_rounded,
          title: AppLocalizations.of(context).somethingWentWrongTryAgain,
          message: message,
          action: SizedBox(
            width: 200,
            child: FilledButton(
              onPressed: onRetry,
              child: Text(AppLocalizations.of(context).tryAgain.toUpperCase()),
            ),
          ),
        ),
      ),
    );
  }
}
