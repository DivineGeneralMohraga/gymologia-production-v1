import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../core/location/location_service.dart';
import '../../l10n/app_localizations.dart';
import '../../theme.dart';
import 'gym_setup_widgets.dart';

/// OpenStreetMap tiles: no API key, no billing. The user agent is required
/// by OSM's tile policy, so requests are identifiable as this app's.
const _tileUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
const _userAgent = 'com.gandagrouptechnologies.gymologia.member';

/// Roughly the middle of India, for when nothing better is known.
const _india = LatLng(22.5, 79.0);

/// The map tile layer and attribution, shared by the picker and the small
/// preview so both look the same and both credit OpenStreetMap.
List<Widget> osmLayers({bool attribution = true}) => [
      TileLayer(urlTemplate: _tileUrl, userAgentPackageName: _userAgent),
      if (attribution)
        const RichAttributionWidget(
          attributions: [TextSourceAttribution('OpenStreetMap contributors')],
        ),
    ];

/// Full-screen map for placing the gym. The pin stays in the middle and the
/// map moves under it -- easier to place precisely with a thumb than
/// dragging a small marker. Returns the chosen point, or null if cancelled.
class GymLocationPickerPage extends StatefulWidget {
  const GymLocationPickerPage({super.key, this.initial});
  final GymLocation? initial;

  @override
  State<GymLocationPickerPage> createState() => _GymLocationPickerPageState();
}

class _GymLocationPickerPageState extends State<GymLocationPickerPage> {
  final _map = MapController();
  late LatLng _center = widget.initial == null
      ? _india
      : LatLng(widget.initial!.latitude, widget.initial!.longitude);
  bool _locating = false;

  @override
  void initState() {
    super.initState();
    // With nothing set yet, start where the owner is standing -- but only
    // if location is already allowed. Asking unprompted on open would be a
    // permission dialog before they have done anything.
    if (widget.initial == null) _jumpToDeviceIfAllowed();
  }

  @override
  void dispose() {
    _map.dispose();
    super.dispose();
  }

  Future<void> _jumpToDeviceIfAllowed() async {
    final service = LocationService();
    if (await service.readiness() != LocationReadiness.granted) return;
    final position = await service.fetchSilently();
    if (position == null || !mounted) return;
    _map.move(LatLng(position.latitude, position.longitude), 17);
  }

  Future<void> _locate() async {
    final t = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _locating = true);
    final position = await LocationService().requestAndFetch(
      accuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 20),
    );
    if (!mounted) return;
    setState(() => _locating = false);
    if (position == null) {
      messenger.showSnackBar(SnackBar(content: Text(t.gymLocationFailed)));
      return;
    }
    _map.move(LatLng(position.latitude, position.longitude), 18);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(t.gymLocation.toUpperCase())),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _map,
            options: MapOptions(
              initialCenter: _center,
              initialZoom: widget.initial == null ? 5 : 17,
              minZoom: 4,
              maxZoom: 19,
              // A gym pin has no use for a rotated map, and an accidental
              // two-finger twist makes street names hard to read.
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
              onPositionChanged: (camera, _) =>
                  setState(() => _center = camera.center),
            ),
            children: osmLayers(),
          ),

          // The pin, with its tip on the exact centre of the map.
          IgnorePointer(
            child: Center(
              child: Transform.translate(
                offset: const Offset(0, -24),
                child: Icon(
                  Icons.location_on_rounded,
                  size: 52,
                  color: scheme.brightness == Brightness.dark ? volt : ink,
                  shadows: const [Shadow(blurRadius: 8, color: Colors.black54)],
                ),
              ),
            ),
          ),

          Positioned(
            top: 12,
            left: 16,
            right: 16,
            child: Material(
              color: scheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(14),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  children: [
                    Icon(Icons.pan_tool_alt_rounded,
                        size: 18, color: context.gym.accentText),
                    const SizedBox(width: 10),
                    Expanded(child: Text(t.moveMapHint)),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            right: 16,
            bottom: 128,
            child: FloatingActionButton(
              heroTag: 'gym-location-locate',
              tooltip: t.myLocation,
              onPressed: _locating ? null : _locate,
              child: _locating
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.4),
                    )
                  : const Icon(Icons.my_location_rounded),
            ),
          ),

          Positioned(
            left: 16,
            right: 16,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: scheme.surface.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${_center.latitude.toStringAsFixed(5)}, '
                        '${_center.longitude.toStringAsFixed(5)}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFeatures: [FontFeature.tabularFigures()],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    FilledButton.icon(
                      onPressed: () => Navigator.of(context).pop<GymLocation>((
                        latitude: _center.latitude,
                        longitude: _center.longitude,
                      )),
                      icon: const Icon(Icons.check_rounded),
                      label: Text(t.confirmLocation.toUpperCase()),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
