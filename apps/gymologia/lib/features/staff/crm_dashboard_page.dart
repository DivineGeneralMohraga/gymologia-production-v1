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
import 'kyc_page.dart';
import '../chat/conversations_page.dart';
import '../../theme.dart';
import '../../ui/kit.dart';

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

/// Whether gym verification (KYC) is offered in the app. Off while the
/// server does not require it for listing.
const _kycEnabled = false;

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
    final t = AppLocalizations.of(context);
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
            Text(gym.name.toUpperCase()),
            Text(
              '${gym.district} · ${gym.roleName}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
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
                          child: Text(AppLocalizations.of(context)
                              .choosePlan
                              .toUpperCase()),
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
            SectionLabel(AppLocalizations.of(context).manage),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.45,
              children: [
                if (gym.sees('addMember') ||
                    gym.sees('manageMembers') ||
                    gym.sees('attendanceMember'))
                  _Tile(
                    icon: Icons.groups_rounded,
                    label: t.members,
                    detail: '${gym.memberCount}',
                    onTap: () => _open(MembersPage(gym: gym)),
                  ),
                if (gym.sees('addStaff') ||
                    gym.sees('manageStaff') ||
                    gym.sees('attendanceStaff'))
                  _Tile(
                    icon: Icons.badge_rounded,
                    label: t.staff,
                    detail: '${gym.staffCount}',
                    onTap: () => _open(StaffPage(gym: gym)),
                  ),
                if (gym.sees('leaveMember') || gym.sees('leaveStaff'))
                  _Tile(
                    icon: Icons.beach_access_rounded,
                    label: t.leave,
                    onTap: () => _open(LeavePage(gym: gym)),
                  ),
                if (gym.can(P.editGymProfile))
                  _Tile(
                    icon: Icons.storefront_rounded,
                    label: AppLocalizations.of(context).gymProfile,
                    onTap: () => _open(GymProfileEditPage(gym: gym)),
                  ),
                // Verification (KYC) is paused by product decision as of
                // 2026-10-01 -- the server lists Pro gyms without it (see
                // backend listing-rules.ts). The page is kept; flip this
                // and REQUIRE_KYC_FOR_LISTING together to bring it back.
                if (_kycEnabled && (gym.isGymOwner || gym.can(P.manageSubscription)))
                  _Tile(
                    icon: Icons.verified_user_rounded,
                    label: t.verification,
                    onTap: () => _open(KycPage(gym: gym)),
                  ),
                if (gym.can(P.manageSubscription))
                  _Tile(
                    icon: Icons.workspace_premium_rounded,
                    label: t.plan,
                    detail: gym.plan,
                    onTap: () => _open(PlanPage(gym: gym)),
                  ),
                if (gym.sees('manageTrainers'))
                  _Tile(
                    icon: Icons.fitness_center_rounded,
                    label: t.trainers,
                    onTap: () => _open(TrainerCategoriesPage(gym: gym)),
                  ),
                if (gym.can(P.viewAnalytics))
                  _Tile(
                    icon: Icons.show_chart_rounded,
                    label: t.growth,
                    onTap: () => _open(GrowthPage(gym: gym)),
                  ),
                if (gym.can(P.viewRanking))
                  _Tile(
                    icon: Icons.leaderboard_rounded,
                    label: t.ranking,
                    onTap: () => _open(RankingPage(gym: gym)),
                  ),
                if (gym.sees('manageRoles'))
                  _Tile(
                    icon: Icons.admin_panel_settings_rounded,
                    label: t.roles,
                    onTap: () => _open(RolesPage(gym: gym)),
                  ),
                if (gym.sees('events'))
                  _Tile(
                    icon: Icons.local_fire_department_rounded,
                    label: t.events,
                    onTap: () => _open(EventsManagePage(gym: gym)),
                  ),
                _Tile(
                  icon: Icons.forum_rounded,
                  label: t.chat,
                  onTap: () => _open(ConversationsPage(
                    gymId: gym.id,
                    gymName: gym.displayName,
                  )),
                ),
                if (gym.can(P.sendNotifications))
                  _Tile(
                    icon: Icons.campaign_rounded,
                    label: t.announce,
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
    final scheme = Theme.of(context).colorScheme;
    final isDark = scheme.brightness == Brightness.dark;
    return Material(
      color: scheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: context.gym.cardBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: isDark ? volt : ink,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(icon, size: 22, color: isDark ? ink : volt),
                  ),
                  const Spacer(),
                  if (detail != null)
                    BigNumber(value: detail!, size: 28),
                ],
              ),
              Text(
                label.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: displayFont,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: scheme.onSurface,
                ),
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
    final t = AppLocalizations.of(context);
    final a = analytics;
    // Below half the membership showing up is the number a gym owner
    // most needs to notice.
    final lowTurnout = a.engagementRate < 50 && a.activeMembers > 0;

    return HeroPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bolt_rounded, size: 16, color: volt),
              const SizedBox(width: 6),
              Eyebrow(t.lastNDays(a.windowDays), color: volt),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _Figure(label: t.active, value: '${a.activeMembers}'),
              _Figure(label: t.joined, value: '+${a.joinedInWindow}'),
              _Figure(
                label: t.turningUp,
                value: '${a.engagementRate}%',
                color: lowTurnout ? const Color(0xFFFF6B35) : volt,
              ),
            ],
          ),
          if (a.activeMembers > 0) ...[
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (a.engagementRate / 100).clamp(0.0, 1.0),
                minHeight: 8,
                color: lowTurnout ? const Color(0xFFFF6B35) : volt,
                backgroundColor: Colors.white.withValues(alpha: 0.12),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              t.engagedOfActive(a.engagedMembers, a.activeMembers),
              style: TextStyle(
                fontSize: 13,
                color: const Color(0xFFF5F5F2).withValues(alpha: 0.7),
              ),
            ),
          ],
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: onSeeGrowth,
              iconAlignment: IconAlignment.end,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                foregroundColor: volt,
              ),
              icon: const Icon(Icons.arrow_forward_rounded, size: 18),
              label: Text(t.seeGrowthOverTime.toUpperCase()),
            ),
          ),
        ],
      ),
    );
  }
}

class _Figure extends StatelessWidget {
  const _Figure({required this.label, required this.value, this.color});

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BigNumber(value: value, size: 40, color: color),
          const SizedBox(height: 2),
          Eyebrow(label,
              color: const Color(0xFFF5F5F2).withValues(alpha: 0.7)),
        ],
      ),
    );
  }
}
