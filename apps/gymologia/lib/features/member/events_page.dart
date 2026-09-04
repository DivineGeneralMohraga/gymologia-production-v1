import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../core/utils/dates.dart';
import 'package:provider/provider.dart';
import '../../core/api/api_client.dart';
import '../../core/api/gym_api.dart';
import '../auth/auth_controller.dart';

/// The events feed.
///
/// Ordered as the spec asks: everything from gyms you belong to comes
/// first, then a divider, then everything listed nationally. A gym on the
/// Basic plan is not listed publicly, but its own members still see its
/// events — which is why the first section exists at all.
class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  List<Map<String, dynamic>>? _mine;
  List<Map<String, dynamic>>? _global;
  String? _error;
  final Set<String> _working = {};

  GymApi get _api => GymApi(context.read<AuthController>().client);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final feed = await _api.eventsFeed();
      if (!mounted) return;
      setState(() {
        _mine = feed.mine;
        _global = feed.global;
      });
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    }
  }

  Future<void> _toggle(Map<String, dynamic> event) async {
    final id = event['id'] as String;
    final registered = event['registered'] == true;

    if (registered) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(AppLocalizations.of(context).removeYourEntry),
          content: Text(AppLocalizations.of(context).takenOffList(event['title'] as String)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(AppLocalizations.of(context).stayIn),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(AppLocalizations.of(context).removeMe),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
    }

    setState(() => _working.add(id));
    try {
      if (registered) {
        await _api.withdrawFromEvent(id);
      } else {
        await _api.participate(id);
      }
      await _load();
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    } finally {
      if (mounted) setState(() => _working.remove(id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mine = _mine;
    final global = _global;

    if (_error != null) {
      return _Message(
        icon: Icons.cloud_off,
        title: 'Could not load events',
        body: _error!,
        action: FilledButton.tonal(onPressed: _load, child: Text(AppLocalizations.of(context).tryAgain)),
      );
    }

    if (mine == null || global == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (mine.isEmpty && global.isEmpty) {
      return _Message(
        icon: Icons.event_outlined,
        title: 'No events on right now',
        body: 'Events your gym runs show up here, along with anything open '
            'to everyone nearby.',
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
      children: [
        if (mine.isNotEmpty) ...[
          _SectionLabel('At your gym'),
          for (final event in mine)
            _EventCard(
              event: event,
              busy: _working.contains(event['id']),
              onToggle: () => _toggle(event),
            ),
          const SizedBox(height: 28),
        ],
        if (global.isNotEmpty) ...[
          Row(
            children: [
              Expanded(child: Divider(color: theme.colorScheme.outlineVariant)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  AppLocalizations.of(context).openEvents.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Expanded(child: Divider(color: theme.colorScheme.outlineVariant)),
            ],
          ),
          const SizedBox(height: 16),
          for (final event in global)
            _EventCard(
              event: event,
              busy: _working.contains(event['id']),
              onToggle: () => _toggle(event),
            ),
        ],
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          letterSpacing: 0.9,
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({
    required this.event,
    required this.busy,
    required this.onToggle,
  });

  final Map<String, dynamic> event;
  final bool busy;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final registered = event['registered'] == true;
    final canParticipate = event['canParticipate'] == true;
    final blocked = event['blockedReason'] as String?;
    final gym = (event['gym'] as Map<String, dynamic>?) ?? const {};
    final banner = event['bannerUrl'] as String?;

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (banner != null)
            Image.network(
              banner,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event['displayName'] as String? ?? event['title'] as String? ?? '',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  gym['displayName'] as String? ?? '',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 12),
                _Row(
                  icon: Icons.calendar_today_outlined,
                  text: _dateRange(event['startsAt'], event['endsAt'], Dates.localeOf(context)),
                ),
                _Row(
                  icon: Icons.how_to_reg_outlined,
                  text: 'Register by ${_shortDate(event['registrationLastDate'], Dates.localeOf(context))}',
                ),
                if ((event['prize'] as String?)?.isNotEmpty ?? false)
                  _Row(
                    icon: Icons.emoji_events_outlined,
                    text: event['prize'] as String,
                  ),
                const SizedBox(height: 12),
                Text(
                  event['description'] as String? ?? '',
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.45),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 14),
                if (canParticipate)
                  SizedBox(
                    width: double.infinity,
                    child: registered
                        ? OutlinedButton.icon(
                            onPressed: busy ? null : onToggle,
                            icon: const Icon(Icons.check_circle, size: 18),
                            label: Text(AppLocalizations.of(context).youAreInTapToWithdraw),
                          )
                        : FilledButton(
                            onPressed: busy ? null : onToggle,
                            child: busy
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2.4),
                                  )
                                : Text(AppLocalizations.of(context).participate),
                          ),
                  )
                else
                  // The spec is specific: when sign-ups are not taken through
                  // the app, the requirements are shown emphasised rather
                  // than as a button that would not work.
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.tertiaryContainer
                          .withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          blocked ?? 'How to take part',
                          style: theme.textTheme.labelSmall?.copyWith(
                            letterSpacing: 0.7,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onTertiaryContainer,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          event['howToParticipate'] as String? ?? '',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Icon(icon, size: 15, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: theme.textTheme.bodySmall)),
        ],
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({
    required this.icon,
    required this.title,
    required this.body,
    this.action,
  });

  final IconData icon;
  final String title;
  final String body;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 46, color: theme.colorScheme.outline),
            const SizedBox(height: 18),
            Text(title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            Text(body,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.5,
                )),
            if (action != null) ...[const SizedBox(height: 22), action!],
          ],
        ),
      ),
    );
  }
}

String _shortDate(dynamic iso, String locale) =>
    Dates.isoDayMonth(iso is String ? iso : null, locale);

String _dateRange(dynamic startIso, dynamic endIso, String locale) {
  final start = startIso is String ? DateTime.tryParse(startIso) : null;
  final end = endIso is String ? DateTime.tryParse(endIso) : null;
  if (start == null) return '';

  final startText = Dates.dayMonth(start, locale);
  if (end == null ||
      (start.year == end.year &&
          start.month == end.month &&
          start.day == end.day)) {
    // A single-day event reads better with its time than with a range.
    return '$startText at ${Dates.time(start, locale)}';
  }
  return '$startText to ${Dates.dayMonth(end, locale)}';
}
