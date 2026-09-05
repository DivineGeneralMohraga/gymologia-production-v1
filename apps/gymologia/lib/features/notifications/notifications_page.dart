import 'package:flutter/material.dart';
import '../../core/utils/dates.dart';
import '../../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../core/api/api_client.dart';
import '../../core/api/gym_api.dart';
import '../auth/auth_controller.dart';

/// The two messages Gymologia sends every new account, keyed by the deep
/// link the server puts on them.
///
/// A gym's announcement is written by a person and stored as they typed it,
/// so it arrives in whatever language they wrote. These two are written by
/// us, once, for everybody — so the server stores English and the real
/// identifier is the link. Matching on it here lets the same stored row
/// arrive in the reader's own language, using the copy that already exists
/// for the same two prompts on the settings screen.
///
/// Returns null for anything else, and the caller falls back to the stored
/// text — which is also what happens if these links ever change: an older
/// message in somebody's inbox still reads correctly, in English.
({String title, String body})? _localisedOnboarding(
  AppLocalizations t,
  Object? deepLink,
) {
  switch (deepLink) {
    case 'gymologia://settings/mode':
      return (title: t.switchToStaff, body: t.openingAGymNote);
    case 'gymologia://referral':
      return (title: t.earnByReferring, body: t.referralPitch);
    default:
      return null;
  }
}

/// Announcements from the gyms someone belongs to, and from Gymologia.
///
/// Opening one marks it read, which is the behaviour people expect from an
/// inbox; there is no separate "mark read" the reader has to remember.
class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<Map<String, dynamic>>? _items;
  int _unread = 0;
  String? _error;

  GymApi get _api => GymApi(context.read<AuthController>().client);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final data = await _api.notifications();
      if (!mounted) return;
      setState(() {
        _items = ((data['items'] as List?) ?? const [])
            .cast<Map<String, dynamic>>();
        _unread = (data['unread'] as int?) ?? 0;
      });
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    }
  }

  Future<void> _open(Map<String, dynamic> item) async {
    if (item['read'] != true) {
      try {
        await _api.markNotificationRead(item['id'] as String);
      } on ApiException {
        // Reading it still worked; the badge will catch up on refresh.
      }
    }

    if (!mounted) return;
    final own = _localisedOnboarding(AppLocalizations.of(context), item['deepLink']);
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(own?.title ?? item['title'] as String? ?? ''),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item['from'] as String? ?? '',
                style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                      color: Theme.of(ctx).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 12),
              Text(own?.body ?? item['body'] as String? ?? '',
                  style: const TextStyle(height: 1.5)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(AppLocalizations.of(ctx).close),
          ),
        ],
      ),
    );
    await _load();
  }

  Future<void> _readAll() async {
    try {
      await _api.markAllNotificationsRead();
      await _load();
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context);
    final items = _items;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.notifications),
        actions: [
          if (_unread > 0)
            TextButton(
              onPressed: _readAll,
              child: Text(t.markAllRead),
            ),
        ],
      ),
      body: _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_error!, textAlign: TextAlign.center),
                    const SizedBox(height: 18),
                    FilledButton.tonal(
                        onPressed: _load, child: Text(t.tryAgain)),
                  ],
                ),
              ),
            )
          : items == null
              ? const Center(child: CircularProgressIndicator())
              : items.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.notifications_none,
                                size: 46, color: theme.colorScheme.outline),
                            const SizedBox(height: 18),
                            Text(t.nothingYet,
                                style: theme.textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            Text(
                              t.announcementsAppearHere,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView.separated(
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (_, i) {
                          final item = items[i];
                          final read = item['read'] == true;
                          final own = _localisedOnboarding(t, item['deepLink']);
                          return ListTile(
                            onTap: () => _open(item),
                            leading: Container(
                              width: 10,
                              height: 10,
                              margin: const EdgeInsets.only(top: 6),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: read
                                    ? Colors.transparent
                                    : theme.colorScheme.primary,
                              ),
                            ),
                            title: Text(
                              own?.title ?? item['title'] as String? ?? '',
                              style: TextStyle(
                                fontWeight:
                                    read ? FontWeight.w400 : FontWeight.w700,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 2),
                                Text(
                                  own?.body ?? item['body'] as String? ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${item['from']}'
                                  '  ·  '
                                  '${Dates.ago(t, item['sentAt'] as String?)}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                            isThreeLine: true,
                          );
                        },
                      ),
                    ),
    );
  }
}


