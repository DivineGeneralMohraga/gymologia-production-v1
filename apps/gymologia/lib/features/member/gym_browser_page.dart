import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../core/api/api_client.dart';
import '../../core/api/gym_api.dart';
import '../../core/api/models.dart';
import '../../core/location/location_service.dart';
import '../auth/auth_controller.dart';
import 'gym_profile_page.dart';
import '../../theme.dart';
import '../../ui/kit.dart';

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
    final t = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  t.findAGym.toUpperCase(),
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            controller: _search,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _load(),
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: t.searchByGymCityDistrict,
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _search.text.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.close_rounded),
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
                      Text(t.findingNearbyGyms),
                    ],
                  )
                : _showLocationPrompt
                ? SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _useMyLocation,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: context.gym.accentText,
                        side: BorderSide(
                            color: context.gym.accentText, width: 1.4),
                      ),
                      icon: const Icon(Icons.near_me_rounded, size: 18),
                      label: Text(t.useMyLocation.toUpperCase()),
                    ),
                  )
                : Text(
                    _locationNotice!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
          ),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? _Message(
                  icon: Icons.cloud_off_rounded,
                  title: t.couldNotLoadGyms,
                  body: _error!,
                  action: SizedBox(
                    width: 200,
                    child: FilledButton(
                      onPressed: _load,
                      child: Text(t.tryAgain.toUpperCase()),
                    ),
                  ),
                )
              : _results.isEmpty
              ? _Message(
                  icon: Icons.storefront_rounded,
                  title: t.noGymsListedYet,
                  body: _search.text.isEmpty
                      ? t.gymsAppearOnPro
                      : t.nothingMatchedTry(_search.text.trim()),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                  itemCount: _results.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
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

/// A gym as a poster: the photo edge to edge, the name in heavy condensed
/// caps across the bottom of it, and the numbers that matter as pills.
class _GymCard extends StatelessWidget {
  const _GymCard({required this.listing, required this.onTap});

  final GymListing listing;
  final VoidCallback onTap;

  /// The backend joins name and district as one string ("Gym Name -
  /// District"). Splitting it back apart gives the name the poster
  /// headline and puts the place under it.
  (String, String?) get _nameAndLocation {
    final parts = listing.displayName.split(' - ');
    if (parts.length < 2) return (listing.displayName, null);
    return (parts.first, parts.sublist(1).join(' - '));
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final (name, location) = _nameAndLocation;
    final hasRating = listing.ratingCount > 0;
    const onPhoto = Color(0xFFF5F5F2);

    return Material(
      color: ink,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: AspectRatio(
          aspectRatio: 16 / 11,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (listing.imageUrl != null)
                Image.network(
                  listing.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const _GymHeroPlaceholder(),
                )
              else
                const _GymHeroPlaceholder(),
              // Scrim: clear at the top, near-black under the name, so
              // white type reads over any photo.
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.0, 0.35, 1.0],
                    colors: [
                      Colors.black.withValues(alpha: 0.25),
                      Colors.black.withValues(alpha: 0.0),
                      Colors.black.withValues(alpha: 0.92),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                right: 12,
                child: Row(
                  children: [
                    _GlassPill(
                      icon: Icons.card_giftcard_rounded,
                      iconColor: volt,
                      label: listing.perkCount == 0
                          ? t.noPerksYet
                          : '${listing.perkCount} perk${listing.perkCount == 1 ? '' : 's'}',
                    ),
                    const Spacer(),
                    _GlassPill(
                      icon: hasRating
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      iconColor: hasRating
                          ? const Color(0xFFFFC53D)
                          : onPhoto.withValues(alpha: 0.6),
                      label: hasRating
                          ? '${listing.rating.toStringAsFixed(1)}  (${listing.ratingCount})'
                          : t.noRatings,
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name.toUpperCase(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: displayFont,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        height: 0.95,
                        letterSpacing: 0.3,
                        color: onPhoto,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (location != null) ...[
                          const Icon(Icons.location_on_rounded,
                              size: 15, color: volt),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: onPhoto.withValues(alpha: 0.85),
                              ),
                            ),
                          ),
                        ] else
                          const Spacer(),
                        if (listing.distanceKm != null)
                          Pill.volt('${listing.distanceKm} km',
                              icon: Icons.near_me_rounded),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// No photo yet: graphite with a volt dumbbell, so it still looks like it
/// belongs in the same feed as the photos.
class _GymHeroPlaceholder extends StatelessWidget {
  const _GymHeroPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF26262C), Color(0xFF0B0B0C)],
        ),
      ),
      alignment: const Alignment(0.55, -0.3),
      child: Transform.rotate(
        angle: -0.5,
        child: Icon(
          Icons.fitness_center_rounded,
          size: 110,
          color: volt.withValues(alpha: 0.16),
        ),
      ),
    );
  }
}

/// Dark translucent pill that reads over any photo.
class _GlassPill extends StatelessWidget {
  const _GlassPill({
    required this.icon,
    required this.iconColor,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: iconColor),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFFF5F5F2),
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
