import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../core/api/api_client.dart';
import '../../core/api/gym_api.dart';
import '../../core/api/models.dart';
import '../../core/location/location_service.dart';
import '../auth/auth_controller.dart';
import 'gym_profile_page.dart';

/// The gym browser.
///
/// Location is optional at every step. Someone who has already granted it
/// gets nearby gyms with no prompt at all; someone who has not sees a
/// button rather than a surprise permission dialog; and anyone who denies
/// it, or whose device has location off, gets exactly the same name/
/// district search everyone had before this existed.
class GymBrowserPage extends StatefulWidget {
  const GymBrowserPage({super.key});

  @override
  State<GymBrowserPage> createState() => _GymBrowserPageState();
}

class _GymBrowserPageState extends State<GymBrowserPage> {
  final _search = TextEditingController();
  final _location = LocationService();
  List<GymListing> _results = const [];
  bool _loading = true;
  bool _locating = false;
  String? _error;
  String? _locationNotice;

  /// Only shown once permission is neither granted nor unavailable --
  /// asking again after a denial would just be the OS dialog re-appearing
  /// unprompted, which reads as nagging rather than a feature.
  bool _showLocationPrompt = false;

  double? _latitude;
  double? _longitude;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    final readiness = await _location.readiness();
    if (!mounted) return;
    switch (readiness) {
      case LocationReadiness.granted:
        _locating = true;
        final position = await _location.fetchSilently();
        if (!mounted) return;
        if (position != null) {
          _latitude = position.latitude;
          _longitude = position.longitude;
        }
        _locating = false;
        break;
      case LocationReadiness.undetermined:
        _showLocationPrompt = true;
        break;
      case LocationReadiness.unavailable:
        break;
    }
    await _load();
  }

  Future<void> _useMyLocation() async {
    setState(() {
      _showLocationPrompt = false;
      _locating = true;
    });
    final position = await _location.requestAndFetch();
    if (!mounted) return;
    setState(() {
      _locating = false;
      if (position != null) {
        _latitude = position.latitude;
        _longitude = position.longitude;
      } else {
        _locationNotice = AppLocalizations.of(context).locationUnavailable;
      }
    });
    await _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final api = GymApi(context.read<AuthController>().client);
      final results = await api.searchGyms(
        query: _search.text.trim(),
        latitude: _latitude,
        longitude: _longitude,
      );
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
    } catch (e) {
      // Anything that isn't an ApiException was previously left
      // uncaught here -- silently stranding _loading at true forever,
      // with nothing on screen to say why. Surfacing it, even as a raw
      // exception string, beats a permanently blank page.
      if (!mounted) return;
      setState(() {
        _error = 'Unexpected error: $e';
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
        if (_showLocationPrompt || _locating || _locationNotice != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: _locating
                ? Row(
                    children: [
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      const SizedBox(width: 10),
                      Text(AppLocalizations.of(context).findingNearbyGyms),
                    ],
                  )
                : _showLocationPrompt
                ? OutlinedButton.icon(
                    onPressed: _useMyLocation,
                    icon: const Icon(Icons.near_me_outlined, size: 18),
                    label: Text(AppLocalizations.of(context).useMyLocation),
                  )
                : Text(
                    _locationNotice!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
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

  /// The backend joins name and district as one string ("Gym Name -
  /// District"). Splitting it back apart buys a proper two-line
  /// hierarchy -- bold name, muted location with a pin -- instead of
  /// one long run-on title.
  (String, String?) get _nameAndLocation {
    final parts = listing.displayName.split(' - ');
    if (parts.length < 2) return (listing.displayName, null);
    return (parts.first, parts.sublist(1).join(' - '));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final (name, location) = _nameAndLocation;
    final hasRating = listing.ratingCount > 0;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shadowColor: scheme.shadow.withValues(alpha: 0.25),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (listing.imageUrl != null)
                    Image.network(
                      listing.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          _GymHeroPlaceholder(scheme: scheme),
                    )
                  else
                    _GymHeroPlaceholder(scheme: scheme),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: _FloatingPill(
                      icon: hasRating
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      iconColor: hasRating
                          ? const Color(0xFFFFC107)
                          : scheme.outline,
                      label: hasRating
                          ? '${listing.rating.toStringAsFixed(1)} (${listing.ratingCount})'
                          : AppLocalizations.of(context).noRatings,
                    ),
                  ),
                  if (listing.distanceKm != null)
                    Positioned(
                      bottom: 12,
                      left: 12,
                      child: _FloatingPill(
                        icon: Icons.near_me_rounded,
                        iconColor: scheme.primary,
                        label: '${listing.distanceKm} km',
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                      height: 1.15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (location != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 15,
                          color: scheme.outline,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            location,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.card_giftcard_rounded,
                        size: 16,
                        color: scheme.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        listing.perkCount == 0
                            ? AppLocalizations.of(context).noPerksYet
                            : '${listing.perkCount} perk${listing.perkCount == 1 ? '' : 's'}',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: scheme.primary,
                          fontWeight: FontWeight.w600,
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
    );
  }
}

/// The gym's own brand mark, softly watermarked, standing in for a photo
/// nobody has uploaded yet -- a gradient in the app's own colour family
/// reads as "this gym" far better than a flat grey box ever did.
class _GymHeroPlaceholder extends StatelessWidget {
  const _GymHeroPlaceholder({required this.scheme});

  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [scheme.primary, scheme.primaryContainer],
        ),
      ),
      child: Center(
        child: Transform.rotate(
          angle: -0.35,
          child: Icon(
            Icons.fitness_center_rounded,
            size: 64,
            color: scheme.onPrimary.withValues(alpha: 0.28),
          ),
        ),
      ),
    );
  }
}

/// A small frosted-looking pill overlaid on the hero image -- rating,
/// distance, whatever needs to read clearly over a photo of any colour.
class _FloatingPill extends StatelessWidget {
  const _FloatingPill({
    required this.icon,
    required this.iconColor,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: iconColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
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
