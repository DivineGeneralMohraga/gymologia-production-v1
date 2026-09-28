import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../core/api/api_client.dart';
import '../../core/api/gym_api.dart';
import '../../core/api/models.dart';
import '../auth/auth_controller.dart';
import 'check_in_sheet.dart';
import 'leave_request_sheet.dart';
import 'exercise_directory_page.dart';
import 'progress_page.dart';
import '../chat/conversations_page.dart';
import '../../theme.dart';
import '../../ui/kit.dart';

/// A member's home: where they train, how long is left, and the monthly
/// weight and height check-in.
class MemberHomePage extends StatefulWidget {
  const MemberHomePage({
    super.key,
    required this.memberships,
    required this.onChanged,
  });

  final List<MyMembership> memberships;
  final Future<void> Function() onChanged;

  @override
  State<MemberHomePage> createState() => _MemberHomePageState();
}

class _MemberHomePageState extends State<MemberHomePage> {
  MetricsSnapshot? _metrics;
  bool _promptShown = false;

  GymApi get _api => GymApi(context.read<AuthController>().client);

  @override
  void initState() {
    super.initState();
    _loadMetrics();
  }

  Future<void> _loadMetrics() async {
    try {
      final metrics = await _api.myMetrics();
      if (!mounted) return;
      setState(() => _metrics = metrics);

      // The spec asks for this on first open after joining, then monthly.
      // Showing it once per app launch is enough — nagging on every rebuild
      // would make the app unusable.
      if (metrics.checkInDue && !_promptShown) {
        _promptShown = true;
        WidgetsBinding.instance.addPostFrameCallback((_) => _openCheckIn());
      }
    } on ApiException {
      // The dashboard is still useful without metrics.
    }
  }

  Future<void> _openCheckIn() async {
    final updated = await showModalBottomSheet<MetricsSnapshot>(
      context: context,
      isScrollControlled: true,
      builder: (_) => CheckInSheet(api: _api, latest: _metrics?.latest),
    );
    if (updated != null && mounted) setState(() => _metrics = updated);
  }

  Future<void> _openLeave(MyMembership membership) async {
    final requested = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => LeaveRequestSheet(api: _api, membership: membership),
    );
    if (requested == true) await widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final latest = _metrics?.latest;
    final user = context.watch<AuthController>().user;
    final firstName = (user?.name ?? '').trim().split(RegExp(r'\s+')).first;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 40),
      children: [
        if (firstName.isNotEmpty) ...[
          Text(
            t.letsGoName(firstName).toUpperCase(),
            style: Theme.of(context)
                .textTheme
                .displaySmall
                ?.copyWith(fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 16),
        ],
        for (final membership in widget.memberships) ...[
          _MembershipCard(
            membership: membership,
            onRequestLeave: () => _openLeave(membership),
          ),
          const SizedBox(height: 22),
        ],

        // ── Body metrics ───────────────────────────────────────────
        SectionLabel(
          t.yourMeasurements,
          trailing: TextButton.icon(
            onPressed: _openCheckIn,
            icon: Icon(latest == null ? Icons.add_rounded : Icons.edit_rounded,
                size: 18),
            label: Text((latest == null ? t.add : t.update).toUpperCase()),
          ),
        ),
        if (_metrics?.checkInDue == true) ...[
          _CheckInDueBanner(onTap: _openCheckIn),
          const SizedBox(height: 12),
        ],
        if (latest == null)
          ActionTile(
            icon: Icons.monitor_weight_rounded,
            title: t.add,
            subtitle: t.addMeasurementsPrompt,
            accent: true,
            onTap: _openCheckIn,
          )
        else
          Row(
            children: [
              Expanded(
                child: StatTile(
                  label: t.weight,
                  icon: Icons.monitor_weight_rounded,
                  value: latest.weightKg == null
                      ? '—'
                      : latest.weightKg!.toStringAsFixed(1),
                  unit: latest.weightKg == null ? null : 'kg',
                  onTap: _openCheckIn,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatTile(
                  label: t.height,
                  icon: Icons.height_rounded,
                  value: latest.heightCm == null
                      ? '—'
                      : latest.heightCm!.toStringAsFixed(0),
                  unit: latest.heightCm == null ? null : 'cm',
                  onTap: _openCheckIn,
                ),
              ),
            ],
          ),

        const SizedBox(height: 22),
        SectionLabel(t.yourTraining),
        ActionTile(
          icon: Icons.insights_rounded,
          title: t.yourProgress,
          subtitle: t.progressSubtitle,
          accent: true,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ProgressPage(memberships: widget.memberships),
            ),
          ),
        ),
        const SizedBox(height: 10),
        ActionTile(
          icon: Icons.menu_book_rounded,
          title: t.exerciseDirectory,
          subtitle: t.exerciseDirectorySubtitle,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ExerciseDirectoryPage(
                // Start on whatever this member said they wanted.
                initialGoal: _goalFilter(widget.memberships),
              ),
            ),
          ),
        ),
        for (final membership in widget.memberships) ...[
          const SizedBox(height: 10),
          ActionTile(
            icon: Icons.forum_rounded,
            title: t.chat,
            subtitle: widget.memberships.length > 1
                ? t.trainerStaffMembersAt(membership.gymName)
                : t.trainerStaffOtherMembers,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ConversationsPage(
                  gymId: membership.gymId,
                  gymName: membership.gymName,
                ),
              ),
            ),
          ),
        ],

        const SizedBox(height: 22),
        _NotBuiltCard(
          title: t.comingNext,
          items: [t.progressChartsAgainstGoal],
        ),
      ],
    );
  }
}

/// Flame-coloured nudge when the monthly weigh-in is due.
class _CheckInDueBanner extends StatelessWidget {
  const _CheckInDueBanner({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.tertiaryContainer,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Icon(Icons.local_fire_department_rounded,
                  color: scheme.tertiary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  AppLocalizations.of(context).checkInDue,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: scheme.onTertiaryContainer,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_rounded,
                  size: 18, color: scheme.onTertiaryContainer),
            ],
          ),
        ),
      ),
    );
  }
}

/// Maps what the member told staff into a directory filter. Deliberately
/// loose: "want to reduce belly fat" should still land on fat loss.
String? _goalFilter(List<MyMembership> memberships) {
  final goal = memberships
      .map((m) => m.goal)
      .firstWhere((g) => g != null && g.isNotEmpty, orElse: () => null)
      ?.toLowerCase();
  if (goal == null) return null;

  if (goal.contains('lose') || goal.contains('fat') || goal.contains('weight')) {
    return 'FAT_LOSS';
  }
  if (goal.contains('bulk') || goal.contains('muscle') || goal.contains('mass')) {
    return 'MUSCLE_GAIN';
  }
  if (goal.contains('strong') || goal.contains('strength')) return 'STRENGTH';
  if (goal.contains('flex') || goal.contains('yoga')) return 'FLEXIBILITY';
  if (goal.contains('rehab') || goal.contains('injur')) return 'REHAB';
  return null;
}

class _MembershipCard extends StatelessWidget {
  const _MembershipCard({required this.membership, required this.onRequestLeave});

  final MyMembership membership;
  final VoidCallback onRequestLeave;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final days = membership.daysRemaining;
    final expiringSoon = days <= 7;
    final flame = context.gym.flame;

    return HeroPanel(
      image: membership.gymImageUrl,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.fitness_center_rounded, size: 16, color: volt),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  membership.gymName.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: displayFont,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              if (membership.onLeave)
                Pill(t.onLeavePaused,
                    icon: Icons.pause_rounded,
                    background: flame,
                    foreground: ink),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              BigNumber(
                value: days < 0 ? t.expired : '$days',
                size: days < 0 ? 44 : 76,
                color: expiringSoon ? flame : volt,
              ),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Eyebrow(t.daysLeft,
                    color: const Color(0xFFF5F5F2).withValues(alpha: 0.75)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Pill(
                '${t.leaveLeft}: ${membership.leaveDaysLeft}/${membership.maxLeaveDays}',
                icon: Icons.beach_access_rounded,
                background: Colors.white.withValues(alpha: 0.12),
                foreground: const Color(0xFFF5F5F2),
              ),
              if (membership.trainerName != null)
                Pill(
                  membership.trainerName!,
                  icon: Icons.sports_rounded,
                  background: Colors.white.withValues(alpha: 0.12),
                  foreground: const Color(0xFFF5F5F2),
                ),
            ],
          ),
          if (membership.goal != null && membership.goal!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Eyebrow(t.yourGoal, color: volt),
            const SizedBox(height: 3),
            Text(
              membership.goal!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
          ],
          const SizedBox(height: 18),
          OutlinedButton.icon(
            onPressed: onRequestLeave,
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFF5F5F2),
              side: BorderSide(
                  color: Colors.white.withValues(alpha: 0.35), width: 1.4),
            ),
            icon: const Icon(Icons.beach_access_rounded, size: 18),
            label: Text(t.requestLeave.toUpperCase()),
          ),
        ],
      ),
    );
  }
}

/// Says plainly what is not here yet, rather than showing a dead tab.
class _NotBuiltCard extends StatelessWidget {
  const _NotBuiltCard({required this.title, required this.items});

  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.outline, style: BorderStyle.solid),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Eyebrow(title),
          const SizedBox(height: 8),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.hourglass_top_rounded,
                      size: 15, color: scheme.onSurfaceVariant),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(item,
                        style: TextStyle(
                          fontSize: 13,
                          color: scheme.onSurfaceVariant,
                        )),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
