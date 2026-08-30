import 'package:flutter/material.dart';
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

  List<_Tab> _tabsFor(AppMode mode) {
    if (mode == AppMode.staff) {
      return const [
        _Tab('Gyms', Icons.fitness_center_outlined, Icons.fitness_center),
        _Tab('Events', Icons.event_outlined, Icons.event),
        _Tab('Settings', Icons.settings_outlined, Icons.settings),
      ];
    }
    // Member mode. The first tab differs depending on whether they belong
    // to a gym, which is why the label is not a constant.
    return [
      _hasMembership
          ? const _Tab('My gym', Icons.home_outlined, Icons.home)
          : const _Tab('Find a gym', Icons.search_outlined, Icons.search),
      if (_hasMembership)
        const _Tab('Discover', Icons.search_outlined, Icons.search),
      const _Tab('Events', Icons.event_outlined, Icons.event),
      const _Tab('Settings', Icons.settings_outlined, Icons.settings),
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
    final tabs = _tabsFor(mode);
    final index = _index.clamp(0, tabs.length - 1);

    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: Row(
          children: [
            const _Wordmark(),
            if (mode == AppMode.staff) ...[
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'STAFF',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Notifications',
            icon: Badge(
              isLabelVisible: _unread > 0,
              label: Text(_unread > 99 ? '99+' : '$_unread'),
              child: const Icon(Icons.notifications_none),
            ),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const NotificationsPage()),
              );
              await _load();
            },
          ),
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings_outlined),
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
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          for (final tab in tabs)
            NavigationDestination(
              icon: Icon(tab.icon),
              selectedIcon: Icon(tab.selectedIcon),
              label: tab.label,
            ),
        ],
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

/// The mark: a barbell plate silhouette beside the name. Drawn rather than
/// shipped as an asset so it takes the theme's colours in both brightnesses.
class _Wordmark extends StatelessWidget {
  const _Wordmark();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: scheme.primary,
            borderRadius: BorderRadius.circular(7),
          ),
          alignment: Alignment.center,
          child: Icon(Icons.fitness_center, size: 15, color: scheme.onPrimary),
        ),
        const SizedBox(width: 9),
        const Text(
          'Gymologia',
          style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: -0.3),
        ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off,
                size: 40, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 14),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 18),
            FilledButton.tonal(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}
