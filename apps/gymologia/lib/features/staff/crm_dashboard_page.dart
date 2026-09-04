import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../core/api/api_client.dart';
import '../../core/api/gym_api.dart';
import '../../core/api/models.dart';
import '../auth/auth_controller.dart';
import 'members_page.dart';
import 'leave_page.dart';
import 'staff_page.dart';
import 'gym_profile_edit_page.dart';
import 'plan_page.dart';
import 'events_manage_page.dart';
import 'announce_page.dart';
import 'trainer_categories_page.dart';
import 'roles_page.dart';
import 'growth_page.dart';
import 'ranking_page.dart';
import '../chat/conversations_page.dart';

/// The CRM home for one gym.
///
/// Every tile is gated on a permission the server reported for this user.
/// A trainer sees attendance and nothing else; an owner sees everything.
/// The server re-checks each action anyway — this only decides what is
/// worth showing, so nobody taps into a wall.
class CrmDashboardPage extends StatefulWidget {
  const CrmDashboardPage({super.key, required this.gymId});

  final String gymId;

  @override
  State<CrmDashboardPage> createState() => _CrmDashboardPageState();
}

class _CrmDashboardPageState extends State<CrmDashboardPage> {
  GymDetail? _gym;
  GymAnalytics? _analytics;
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
      final gym = await _api.gym(widget.gymId);
      if (!mounted) return;
      setState(() => _gym = gym);

      if (gym.can(P.viewAnalytics)) {
        final analytics = await _api.analytics(widget.gymId);
        if (mounted) setState(() => _analytics = analytics);
      }
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    }
  }

  void _open(Widget page) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => page))
        .then((_) => _load());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gym = _gym;

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_error!, textAlign: TextAlign.center),
                const SizedBox(height: 18),
                FilledButton.tonal(
                    onPressed: _load, child: Text(AppLocalizations.of(context).tryAgain)),
              ],
            ),
          ),
        ),
      );
    }

    if (gym == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(gym.name, style: const TextStyle(fontSize: 17)),
            Text(
              '${gym.district} · ${gym.roleName}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
          children: [
            if (gym.status == 'DRAFT')
              Card(
                elevation: 0,
                color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.5),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.info_outline, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              AppLocalizations.of(context).draftCrmNote,
                            ),
                          ),
                        ],
                      ),
                      if (gym.can(P.manageSubscription)) ...[
                        const SizedBox(height: 12),
                        FilledButton(
                          onPressed: () => _open(PlanPage(gym: gym)),
                          child: Text(AppLocalizations.of(context).choosePlan),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

            if (_analytics != null) ...[
              const SizedBox(height: 8),
              _AnalyticsCard(
                analytics: _analytics!,
                onSeeGrowth: () => _open(GrowthPage(gym: gym)),
              ),
            ],

            const SizedBox(height: 16),
            Text(AppLocalizations.of(context).manage.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  letterSpacing: 0.9,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                )),
            const SizedBox(height: 10),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.35,
              children: [
                if (gym.sees('addMember') ||
                    gym.sees('manageMembers') ||
                    gym.sees('attendanceMember'))
                  _Tile(
                    icon: Icons.groups_outlined,
                    label: 'Members',
                    detail: '${gym.memberCount}',
                    onTap: () => _open(MembersPage(gym: gym)),
                  ),
                if (gym.sees('addStaff') ||
                    gym.sees('manageStaff') ||
                    gym.sees('attendanceStaff'))
                  _Tile(
                    icon: Icons.badge_outlined,
                    label: 'Staff',
                    detail: '${gym.staffCount}',
                    onTap: () => _open(StaffPage(gym: gym)),
                  ),
                if (gym.sees('leaveMember') || gym.sees('leaveStaff'))
                  _Tile(
                    icon: Icons.beach_access_outlined,
                    label: 'Leave',
                    onTap: () => _open(LeavePage(gym: gym)),
                  ),
                if (gym.can(P.editGymProfile))
                  _Tile(
                    icon: Icons.storefront_outlined,
                    label: 'Gym profile',
                    onTap: () => _open(GymProfileEditPage(gym: gym)),
                  ),
                if (gym.can(P.manageSubscription))
                  _Tile(
                    icon: Icons.workspace_premium_outlined,
                    label: 'Plan',
                    detail: gym.plan,
                    onTap: () => _open(PlanPage(gym: gym)),
                  ),
                if (gym.sees('manageTrainers'))
                  _Tile(
                    icon: Icons.fitness_center_outlined,
                    label: 'Trainers',
                    onTap: () => _open(TrainerCategoriesPage(gym: gym)),
                  ),
                if (gym.can(P.viewAnalytics))
                  _Tile(
                    icon: Icons.show_chart,
                    label: 'Growth',
                    onTap: () => _open(GrowthPage(gym: gym)),
                  ),
                if (gym.can(P.viewRanking))
                  _Tile(
                    icon: Icons.leaderboard_outlined,
                    label: 'Ranking',
                    onTap: () => _open(RankingPage(gym: gym)),
                  ),
                if (gym.sees('manageRoles'))
                  _Tile(
                    icon: Icons.admin_panel_settings_outlined,
                    label: 'Roles',
                    onTap: () => _open(RolesPage(gym: gym)),
                  ),
                if (gym.sees('events'))
                  _Tile(
                    icon: Icons.event_outlined,
                    label: 'Events',
                    onTap: () => _open(EventsManagePage(gym: gym)),
                  ),
                _Tile(
                  icon: Icons.forum_outlined,
                  label: 'Chat',
                  onTap: () => _open(ConversationsPage(
                    gymId: gym.id,
                    gymName: gym.displayName,
                  )),
                ),
                if (gym.can(P.sendNotifications))
                  _Tile(
                    icon: Icons.campaign_outlined,
                    label: 'Announce',
                    onTap: () => _open(AnnouncePage(gym: gym)),
                  ),
              ],
            ),

            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context).roleHiddenNote(gym.roleName),
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.detail,
  });

  final IconData icon;
  final String label;
  final String? detail;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: theme.colorScheme.primary),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (detail != null)
                    Text(detail!,
                        style: theme.textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold)),
                  Text(label,
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnalyticsCard extends StatelessWidget {
  const _AnalyticsCard({required this.analytics, required this.onSeeGrowth});
  final GymAnalytics analytics;
  final VoidCallback onSeeGrowth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final a = analytics;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context).lastNDays(a.windowDays),
                style: theme.textTheme.labelSmall?.copyWith(
                  letterSpacing: 0.8,
                  color: theme.colorScheme.onSurfaceVariant,
                )),
            const SizedBox(height: 12),
            Row(
              children: [
                _Figure(label: 'Active', value: '${a.activeMembers}'),
                const SizedBox(width: 24),
                _Figure(label: 'Joined', value: '${a.joinedInWindow}'),
                const SizedBox(width: 24),
                _Figure(
                  label: 'Turning up',
                  value: '${a.engagementRate}%',
                  // Below half the membership showing up is the number a
                  // gym owner most needs to notice.
                  emphasis: a.engagementRate < 50 && a.activeMembers > 0,
                ),
              ],
            ),
            if (a.activeMembers > 0) ...[
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)
                    .engagedOfActive(a.engagedMembers, a.activeMembers),
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: onSeeGrowth,
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: Text(AppLocalizations.of(context).seeGrowthOverTime),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Figure extends StatelessWidget {
  const _Figure({
    required this.label,
    required this.value,
    this.emphasis = false,
  });

  final String label;
  final String value;
  final bool emphasis;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: emphasis ? theme.colorScheme.error : null,
            )),
        Text(label.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              letterSpacing: 0.7,
              color: theme.colorScheme.onSurfaceVariant,
            )),
      ],
    );
  }
}
