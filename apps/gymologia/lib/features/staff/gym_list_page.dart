import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../core/api/api_client.dart';
import '../../core/api/gym_api.dart';
import '../../core/api/models.dart';
import '../auth/auth_controller.dart';
import 'create_gym_page.dart';
import 'crm_dashboard_page.dart';
import '../../theme.dart';
import '../../ui/kit.dart';

/// The staff app's first screen: gyms you own or work at.
///
/// A brand new account has none, so the empty state is the create flow
/// rather than a blank list — that is the only thing to do here.
class GymListPage extends StatefulWidget {
  const GymListPage({super.key});

  @override
  State<GymListPage> createState() => _GymListPageState();
}

class _GymListPageState extends State<GymListPage> {
  List<GymSummary>? _gyms;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final api = GymApi(context.read<AuthController>().client);
      final gyms = await api.myGyms();
      if (mounted) setState(() => _gyms = gyms);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    }
  }

  Future<void> _create() async {
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const CreateGymPage()),
    );
    if (created == true) await _load();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final gyms = _gyms;

    if (_error != null) {
      return _Center(
        icon: Icons.cloud_off_rounded,
        title: t.couldNotLoadYourGyms,
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

    if (gyms == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (gyms.isEmpty) {
      return _Center(
        icon: Icons.add_business_rounded,
        title: t.noGymsYet,
        body: t.createYourGymBlurb,
        action: FilledButton.icon(
          onPressed: _create,
          icon: const Icon(Icons.add_rounded),
          label: Text(t.createAGym.toUpperCase()),
        ),
      );
    }

    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 110),
          children: [
            Text(
              t.gyms.toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .displaySmall
                  ?.copyWith(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            for (final gym in gyms) ...[
              _GymTile(
                gym: gym,
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CrmDashboardPage(gymId: gym.id),
                    ),
                  );
                  await _load();
                },
              ),
              const SizedBox(height: 14),
            ],
          ],
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton.extended(
            onPressed: _create,
            icon: const Icon(Icons.add_rounded),
            label: Text(t.newGym.toUpperCase()),
          ),
        ),
      ],
    );
  }
}

/// One gym: photo strip with the name, then members / staff / rating.
class _GymTile extends StatelessWidget {
  const _GymTile({required this.gym, required this.onTap});
  final GymSummary gym;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final plan = gym.plan?.toUpperCase();
    final role = gym.isOwner ? t.owner : gym.myRoleName ?? t.staff;

    final Widget planPill = gym.isDraft
        ? Pill(t.draft, background: context.gym.flame, foreground: ink)
        : plan == 'PRO'
            ? Pill.volt('PRO', icon: Icons.bolt_rounded)
            : Pill(plan ?? '—',
                background: Colors.white.withValues(alpha: 0.16),
                foreground: const Color(0xFFF5F5F2));

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 118,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (gym.imageUrl != null)
                    Image.network(
                      gym.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const ColoredBox(color: Color(0xFF1E1E23)),
                    )
                  else
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF26262C), ink],
                        ),
                      ),
                    ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.15),
                          Colors.black.withValues(alpha: 0.88),
                        ],
                      ),
                    ),
                  ),
                  Positioned(top: 12, right: 12, child: planPill),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          gym.displayName.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: displayFont,
                            fontSize: 27,
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.italic,
                            height: 1.0,
                            color: Color(0xFFF5F5F2),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              gym.isOwner
                                  ? Icons.workspace_premium_rounded
                                  : Icons.badge_rounded,
                              size: 14,
                              color: volt,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              role,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFF5F5F2)
                                    .withValues(alpha: 0.85),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    _Stat(label: t.members, value: '${gym.memberCount}'),
                    VerticalDivider(color: scheme.outlineVariant, width: 1),
                    _Stat(label: t.staff, value: '${gym.staffCount}'),
                    VerticalDivider(color: scheme.outlineVariant, width: 1),
                    _Stat(
                      label: t.rating,
                      value: gym.ratingCount == 0
                          ? '—'
                          : gym.rating.toStringAsFixed(1),
                    ),
                  ],
                ),
              ),
            ),
            if (gym.isDraft)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                child: Text(
                  t.notListedUntilPlan,
                  style: TextStyle(
                    fontSize: 13,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          BigNumber(value: value, size: 30),
          const SizedBox(height: 2),
          Eyebrow(label),
        ],
      ),
    );
  }
}

class _Center extends StatelessWidget {
  const _Center({
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
    return Center(
      child: SingleChildScrollView(
        child: EmptyState(
          icon: icon,
          title: title,
          message: body,
          action: action,
        ),
      ),
    );
  }
}
