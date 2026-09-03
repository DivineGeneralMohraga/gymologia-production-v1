import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../core/api/api_client.dart';
import '../../core/api/gym_api.dart';
import '../../core/api/models.dart';
import '../auth/auth_controller.dart';
import 'create_gym_page.dart';
import 'crm_dashboard_page.dart';

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
    final theme = Theme.of(context);
    final gyms = _gyms;

    if (_error != null) {
      return _Center(
        icon: Icons.cloud_off,
        title: 'Could not load your gyms',
        body: _error!,
        action: FilledButton.tonal(
          onPressed: _load,
          child: Text(AppLocalizations.of(context).tryAgain),
        ),
      );
    }

    if (gyms == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (gyms.isEmpty) {
      return _Center(
        icon: Icons.add_business_outlined,
        title: 'No gyms yet',
        body: 'Create your gym to set up members, staff, attendance and leave. '
            'If you work at a gym, ask the owner to add you and it will appear here.',
        action: FilledButton.icon(
          onPressed: _create,
          icon: const Icon(Icons.add),
          label: Text(AppLocalizations.of(context).createAGym),
        ),
      );
    }

    return Stack(
      children: [
        ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          itemCount: gyms.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, i) {
            final gym = gyms[i];
            return Card(
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CrmDashboardPage(gymId: gym.id),
                    ),
                  );
                  await _load();
                },
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              gym.displayName,
                              style: theme.textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ),
                          if (gym.isDraft)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.tertiaryContainer,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(AppLocalizations.of(context).draft.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.6,
                                    color:
                                        theme.colorScheme.onTertiaryContainer,
                                  )),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${gym.isOwner ? 'Owner' : gym.myRoleName ?? 'Staff'}'
                        '${gym.plan == null ? '' : ' · ${gym.plan} plan'}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          _Stat(label: 'Members', value: '${gym.memberCount}'),
                          const SizedBox(width: 26),
                          _Stat(label: 'Staff', value: '${gym.staffCount}'),
                          const SizedBox(width: 26),
                          _Stat(
                            label: 'Rating',
                            value: gym.ratingCount == 0
                                ? '—'
                                : gym.rating.toStringAsFixed(1),
                          ),
                        ],
                      ),
                      if (gym.isDraft) ...[
                        const SizedBox(height: 12),
                        Text(
                          'Not listed publicly until a plan is active.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton.extended(
            onPressed: _create,
            icon: const Icon(Icons.add),
            label: Text(AppLocalizations.of(context).newGym),
          ),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold)),
        Text(label.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              letterSpacing: 0.7,
              color: theme.colorScheme.onSurfaceVariant,
            )),
      ],
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
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
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
            if (action != null) ...[const SizedBox(height: 24), action!],
          ],
        ),
      ),
    );
  }
}
