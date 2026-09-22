import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../core/api/api_client.dart';
import '../../core/api/gym_api.dart';
import '../../core/api/models.dart';
import '../auth/auth_controller.dart';
import 'gym_profile_page.dart';

/// The gym browser.
///
/// Location is not requested here. The spec allows for someone declining
/// it, and the honest version of that is a locality search that works just
/// as well — so until the location plugin is wired up, everyone gets the
/// text path rather than a permission prompt that leads nowhere.
class GymBrowserPage extends StatefulWidget {
  const GymBrowserPage({super.key});

  @override
  State<GymBrowserPage> createState() => _GymBrowserPageState();
}

class _GymBrowserPageState extends State<GymBrowserPage> {
  final _search = TextEditingController();
  List<GymListing> _results = const [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final api = GymApi(context.read<AuthController>().client);
      final results = await api.searchGyms(query: _search.text.trim());
      if (!mounted) return;
      setState(() {
        _results = results;
        _loading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            controller: _search,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _load(),
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context).searchByGymCityDistrict,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _search.text.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _search.clear();
                        _load();
                      },
                    ),
            ),
          ),
        ),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? _Message(
                  icon: Icons.cloud_off,
                  title: AppLocalizations.of(context).couldNotLoadGyms,
                  body: _error!,
                  action: FilledButton.tonal(
                    onPressed: _load,
                    child: Text(AppLocalizations.of(context).tryAgain),
                  ),
                )
              : _results.isEmpty
              ? _Message(
                  icon: Icons.storefront_outlined,
                  title: AppLocalizations.of(context).noGymsListedYet,
                  body: _search.text.isEmpty
                      ? AppLocalizations.of(context).gymsAppearOnPro
                      : AppLocalizations.of(
                          context,
                        ).nothingMatchedTry(_search.text.trim()),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                  itemCount: _results.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) => _GymCard(
                    listing: _results[i],
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => GymProfilePage(gymId: _results[i].id),
                      ),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

class _GymCard extends StatelessWidget {
  const _GymCard({required this.listing, required this.onTap});

  final GymListing listing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 96,
              child: listing.imageUrl == null
                  ? Container(
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: Icon(
                        Icons.fitness_center,
                        color: theme.colorScheme.outline,
                      ),
                    )
                  : Image.network(
                      listing.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.fitness_center,
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      listing.displayName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 14,
                      runSpacing: 4,
                      children: [
                        if (listing.ratingCount > 0)
                          _Chip(
                            icon: Icons.star_rounded,
                            label:
                                '${listing.rating.toStringAsFixed(1)} (${listing.ratingCount})',
                          )
                        else
                          _Chip(
                            icon: Icons.star_border_rounded,
                            label: AppLocalizations.of(context).noRatings,
                          ),
                        _Chip(
                          icon: Icons.card_giftcard_outlined,
                          label:
                              '${listing.perkCount} perk${listing.perkCount == 1 ? '' : 's'}',
                        ),
                        if (listing.distanceKm != null)
                          _Chip(
                            icon: Icons.near_me_outlined,
                            label: '${listing.distanceKm} km',
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
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
            Icon(icon, size: 44, color: theme.colorScheme.outline),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              body,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (action != null) ...[const SizedBox(height: 20), action!],
          ],
        ),
      ),
    );
  }
}
