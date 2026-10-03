import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../core/utils/dates.dart';
import 'package:provider/provider.dart';
import '../../core/api/api_client.dart';
import '../../core/api/gym_api.dart';
import '../auth/auth_controller.dart';
import '../safety/safety_actions.dart';
import '../../theme.dart';
import '../../ui/kit.dart';

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
    final t = AppLocalizations.of(context);
    final mine = _mine;
    final global = _global;

    if (_error != null) {
      return _Message(
        icon: Icons.cloud_off_rounded,
        title: t.couldNotLoadEvents,
        body: _error!,
        action: SizedBox(
          width: 200,
          child: FilledButton(
            onPressed: _load,
            child: Text(t.tryAgain.toUpperCase()),
          ),
        ),
      );
    }

    if (mine == null || global == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (mine.isEmpty && global.isEmpty) {
      return _Message(
        icon: Icons.local_fire_department_rounded,
        title: t.noEventsOnRightNow,
        body: t.eventsAppearHere,
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 40),
      children: [
        Text(
          t.events.toUpperCase(),
          style: Theme.of(context)
              .textTheme
              .displaySmall
              ?.copyWith(fontStyle: FontStyle.italic),
        ),
        const SizedBox(height: 14),
        if (mine.isNotEmpty) ...[
          SectionLabel(t.atYourGym),
          for (final event in mine)
            _EventCard(
              event: event,
              busy: _working.contains(event['id']),
              onToggle: () => _toggle(event),
              onReport: () => showListingReportSheet(
                context,
                api: _api,
                kind: ReportedListing.event,
                id: event['id'] as String,
              ),
            ),
          const SizedBox(height: 14),
        ],
        if (global.isNotEmpty) ...[
          SectionLabel(t.openEvents),
          for (final event in global)
            _EventCard(
              event: event,
              busy: _working.contains(event['id']),
              onToggle: () => _toggle(event),
              onReport: () => showListingReportSheet(
                context,
                api: _api,
                kind: ReportedListing.event,
                id: event['id'] as String,
              ),
            ),
        ],
      ],
    );
  }
}

/// An event as a ticket: banner with a date stub and the title over it,
/// then where, when, the prize, and the one action.
class _EventCard extends StatelessWidget {
  const _EventCard({
    required this.event,
    required this.busy,
    required this.onToggle,
    required this.onReport,
  });

  final Map<String, dynamic> event;
  final bool busy;
  final VoidCallback onToggle;
  final VoidCallback onReport;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final locale = Dates.localeOf(context);
    final registered = event['registered'] == true;
    final canParticipate = event['canParticipate'] == true;
    final blocked = event['blockedReason'] as String?;
    final gym = (event['gym'] as Map<String, dynamic>?) ?? const {};
    final banner = event['bannerUrl'] as String?;
    final start = event['startsAt'] is String
        ? DateTime.tryParse(event['startsAt'] as String)?.toLocal()
        : null;
    final prize = event['prize'] as String?;
    const onPhoto = Color(0xFFF5F5F2);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 2 / 1,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (banner != null)
                    Image.network(
                      banner,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const _BannerPlaceholder(),
                    )
                  else
                    const _BannerPlaceholder(),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.3, 1.0],
                        colors: [
                          Colors.black.withValues(alpha: 0.0),
                          Colors.black.withValues(alpha: 0.9),
                        ],
                      ),
                    ),
                  ),
                  if (start != null)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: _DateStub(date: start, locale: locale),
                    ),
                  if (registered)
                    Positioned(
                      top: 12,
                      right: 52,
                      child: Pill.volt(t.participated,
                          icon: Icons.check_rounded),
                    ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, color: onPhoto),
                      onSelected: (_) => onReport(),
                      itemBuilder: (_) => [
                        PopupMenuItem(
                          value: 'report',
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.flag_outlined),
                            title: Text(t.reportEvent),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 12,
                    child: Text(
                      (event['title'] as String? ?? '').toUpperCase(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: displayFont,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        height: 0.95,
                        color: onPhoto,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Row(
                    icon: Icons.fitness_center_rounded,
                    text: gym['displayName'] as String? ?? '',
                    strong: true,
                  ),
                  _Row(
                    icon: Icons.schedule_rounded,
                    text: _dateRange(
                        event['startsAt'], event['endsAt'], locale),
                  ),
                  _Row(
                    icon: Icons.how_to_reg_rounded,
                    text: t.registerByWhen(
                        _shortDate(event['registrationLastDate'], locale)),
                  ),
                  if (prize?.isNotEmpty ?? false) ...[
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: scheme.tertiaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.emoji_events_rounded,
                              size: 20, color: scheme.onTertiaryContainer),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              prize!,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: scheme.onTertiaryContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if ((event['description'] as String?)?.isNotEmpty ??
                      false) ...[
                    const SizedBox(height: 12),
                    Text(
                      event['description'] as String,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.45,
                        color: scheme.onSurfaceVariant,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 14),
                  if (canParticipate)
                    SizedBox(
                      width: double.infinity,
                      child: registered
                          ? OutlinedButton.icon(
                              onPressed: busy ? null : onToggle,
                              icon: const Icon(Icons.check_circle_rounded,
                                  size: 18),
                              label: Text(
                                  t.youAreInTapToWithdraw.toUpperCase()),
                            )
                          : FilledButton.icon(
                              onPressed: busy ? null : onToggle,
                              icon: busy
                                  ? const SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2.4),
                                    )
                                  : const Icon(Icons.bolt_rounded),
                              label: Text(t.participate.toUpperCase()),
                            ),
                    )
                  else
                    // The spec is specific: when sign-ups are not taken
                    // through the app, the requirements are shown
                    // emphasised rather than as a button that would not
                    // work.
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(12),
                        border: Border(
                          left: BorderSide(
                              color: context.gym.accentText, width: 4),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Eyebrow(blocked ?? t.howToTakePart,
                              color: context.gym.accentText),
                          const SizedBox(height: 6),
                          Text(
                            event['howToParticipate'] as String? ?? '',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
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
      ),
    );
  }
}

/// Day and month on a volt stub, like the tear-off end of a ticket.
class _DateStub extends StatelessWidget {
  const _DateStub({required this.date, required this.locale});
  final DateTime date;
  final String locale;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: volt,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${date.day}',
            style: const TextStyle(
              fontFamily: displayFont,
              fontSize: 26,
              fontWeight: FontWeight.w900,
              height: 1.0,
              color: ink,
            ),
          ),
          Text(
            Dates.month(date, locale).toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.clip,
            style: const TextStyle(
              fontFamily: displayFont,
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              color: ink,
            ),
          ),
        ],
      ),
    );
  }
}

class _BannerPlaceholder extends StatelessWidget {
  const _BannerPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3F1B0B), ink],
        ),
      ),
      alignment: const Alignment(0.7, -0.2),
      child: Icon(
        Icons.local_fire_department_rounded,
        size: 110,
        color: const Color(0xFFFF6B35).withValues(alpha: 0.35),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.icon, required this.text, this.strong = false});
  final IconData icon;
  final String text;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon,
              size: 16,
              color: strong
                  ? context.gym.accentText
                  : theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: strong ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
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
    // A ListView, not a Column, so pull-to-refresh still works when empty.
    return ListView(
      children: [
        EmptyState(icon: icon, title: title, message: body, action: action),
      ],
    );
  }
}

String _shortDate(dynamic iso, String locale) {
  final date = iso is String ? DateTime.tryParse(iso)?.toLocal() : null;
  return date == null ? '' : Dates.dayMonth(date, locale);
}

String _dateRange(dynamic startIso, dynamic endIso, String locale) {
  // toLocal: the API sends UTC, and a 6 pm IST event must not read 12:30.
  final start =
      startIso is String ? DateTime.tryParse(startIso)?.toLocal() : null;
  final end = endIso is String ? DateTime.tryParse(endIso)?.toLocal() : null;
  if (start == null) return '';

  final startText = Dates.dayMonth(start, locale);
  if (end == null ||
      (start.year == end.year &&
          start.month == end.month &&
          start.day == end.day)) {
    // A single-day event reads better with its time than with a range.
    return '$startText · ${Dates.time(start, locale)}';
  }
  return '$startText – ${Dates.dayMonth(end, locale)}';
}
