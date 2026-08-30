import 'package:flutter/material.dart';
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
    final theme = Theme.of(context);
    final latest = _metrics?.latest;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
      children: [
        for (final membership in widget.memberships) ...[
          _MembershipCard(
            membership: membership,
            onRequestLeave: () => _openLeave(membership),
          ),
          const SizedBox(height: 16),
        ],

        // ── Body metrics ───────────────────────────────────────────
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text('Your measurements',
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600)),
                    ),
                    TextButton(
                      onPressed: _openCheckIn,
                      child: Text(latest == null ? 'Add' : 'Update'),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                if (latest == null)
                  Text(
                    'Add your weight and height so your gym can track progress with you.',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  )
                else
                  Row(
                    children: [
                      _Metric(
                        label: 'Weight',
                        value: latest.weightKg == null
                            ? '—'
                            : '${latest.weightKg!.toStringAsFixed(1)} kg',
                      ),
                      const SizedBox(width: 28),
                      _Metric(
                        label: 'Height',
                        value: latest.heightCm == null
                            ? '—'
                            : '${latest.heightCm!.toStringAsFixed(0)} cm',
                      ),
                    ],
                  ),
                if (_metrics?.checkInDue == true) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.tertiaryContainer
                          .withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.event_repeat, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text('This month’s check-in is due.',
                              style: theme.textTheme.bodySmall),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),
        Card(
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Icon(Icons.insights_outlined,
                  color: theme.colorScheme.onPrimaryContainer, size: 20),
            ),
            title: const Text('Your progress',
                style: TextStyle(fontWeight: FontWeight.w700)),
            subtitle: const Text(
                'Weight over time, and how often you have turned up.'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ProgressPage(memberships: widget.memberships),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),
        for (final membership in widget.memberships)
          Card(
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Icon(Icons.forum_outlined,
                    color: theme.colorScheme.onPrimaryContainer, size: 20),
              ),
              title: const Text('Chat',
                  style: TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Text(
                widget.memberships.length > 1
                    ? 'Your trainer, staff and members at ${membership.gymName}'
                    : 'Your trainer, the staff, and other members',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ConversationsPage(
                    gymId: membership.gymId,
                    gymName: membership.gymName,
                  ),
                ),
              ),
            ),
          ),

        const SizedBox(height: 16),
        Card(
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Icon(Icons.menu_book_outlined,
                  color: theme.colorScheme.onPrimaryContainer, size: 20),
            ),
            title: const Text('Exercise directory',
                style: TextStyle(fontWeight: FontWeight.w700)),
            subtitle: const Text(
                'Strength, cardio and yoga, with step-by-step form cues.'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ExerciseDirectoryPage(
                  // Start on whatever this member said they wanted.
                  initialGoal: _goalFilter(widget.memberships),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),
        _NotBuiltCard(
          title: 'Coming next',
          items: const ['Progress charts against your goal'],
        ),
      ],
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
    final theme = Theme.of(context);
    final days = membership.daysRemaining;
    final expiringSoon = days <= 7;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (membership.gymImageUrl != null)
            Image.network(
              membership.gymImageUrl!,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(membership.gymName,
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold)),
                if (membership.onLeave) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.pause_circle_outline,
                          size: 16, color: theme.colorScheme.tertiary),
                      const SizedBox(width: 6),
                      Text('On leave — your membership is paused',
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: theme.colorScheme.tertiary)),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                Row(
                  children: [
                    _Metric(
                      label: 'Days left',
                      value: days < 0 ? 'Expired' : '$days',
                      emphasis: expiringSoon,
                    ),
                    const SizedBox(width: 28),
                    _Metric(
                      label: 'Leave left',
                      value: '${membership.leaveDaysLeft} of ${membership.maxLeaveDays}',
                    ),
                  ],
                ),
                if (membership.goal != null && membership.goal!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text('YOUR GOAL',
                      style: theme.textTheme.labelSmall?.copyWith(
                        letterSpacing: 0.8,
                        color: theme.colorScheme.onSurfaceVariant,
                      )),
                  const SizedBox(height: 2),
                  Text(membership.goal!, style: theme.textTheme.bodyLarge),
                ],
                if (membership.trainerName != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.person_outline, size: 16),
                      const SizedBox(width: 6),
                      Text('Trainer: ${membership.trainerName}',
                          style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: onRequestLeave,
                      icon: const Icon(Icons.beach_access_outlined, size: 18),
                      label: const Text('Request leave'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value, this.emphasis = false});

  final String label;
  final String value;
  final bool emphasis;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              letterSpacing: 0.8,
              color: theme.colorScheme.onSurfaceVariant,
            )),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: emphasis ? theme.colorScheme.error : null,
          ),
        ),
      ],
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
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            for (final item in items)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.circle_outlined,
                        size: 13, color: theme.colorScheme.outline),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(item,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          )),
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
