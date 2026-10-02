import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../core/api/api_client.dart';
import '../../core/api/uploads.dart';
import '../../core/media/media_picker.dart';
import '../../l10n/app_localizations.dart';
import '../../theme.dart';
import '../../ui/kit.dart';
import '../auth/auth_controller.dart';
import 'gym_location_picker.dart';

// ── Photos ───────────────────────────────────────────────────────────────

/// A gym's photo list while it is being edited: what is there, what is
/// still uploading, and whether anything changed. Shared by the profile
/// editor and the photo step right after a gym is created, so both upload
/// the same way.
class GymPhotosController extends ChangeNotifier {
  GymPhotosController({required this.gymId, List<String> initial = const []})
      : images = [...initial];

  final String gymId;

  /// Replace-in-full on save; the first is the cover in search.
  final List<String> images;
  int uploading = 0;
  bool changed = false;

  static const maxPhotos = 10;

  bool get canAdd => images.length + uploading < maxPhotos;
  bool get busy => uploading > 0;

  Future<void> add(BuildContext context) async {
    final t = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    void toast(String m) => messenger.showSnackBar(SnackBar(content: Text(m)));

    if (!canAdd) {
      toast(t.maxPhotos(maxPhotos));
      return;
    }
    final client = context.read<AuthController>().client;
    final picked = await pickPhoto(context);
    if (picked == null) return;

    uploading++;
    notifyListeners();
    try {
      final url = await Uploader(client).upload(
        gymId: gymId,
        kind: UploadKind.gymImage,
        bytes: picked.bytes,
        contentType: picked.contentType,
      );
      images.add(url);
      changed = true;
    } on UploadTooLarge catch (e) {
      toast(t.fileTooLarge(e.maxMb));
    } on ApiException catch (e) {
      toast(e.message);
    } finally {
      uploading--;
      notifyListeners();
    }
  }

  void remove(int i) {
    images.removeAt(i);
    changed = true;
    notifyListeners();
  }

  void makeCover(int i) {
    images.insert(0, images.removeAt(i));
    changed = true;
    notifyListeners();
  }
}

/// The photos as a grid: tap one to make it the cover, the cross to drop
/// it, the last tile to add another.
class GymPhotosEditor extends StatelessWidget {
  const GymPhotosEditor({super.key, required this.controller});
  final GymPhotosController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final t = AppLocalizations.of(context);
        final scheme = Theme.of(context).colorScheme;
        final images = controller.images;

        Widget tile(Widget child) => ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: AspectRatio(aspectRatio: 1, child: child),
            );

        return GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          children: [
            for (var i = 0; i < images.length; i++)
              tile(Stack(
                fit: StackFit.expand,
                children: [
                  GestureDetector(
                    onTap: i == 0 ? null : () => controller.makeCover(i),
                    child: Image.network(
                      images[i],
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => ColoredBox(
                        color: scheme.surfaceContainerHighest,
                        child: Icon(Icons.broken_image_rounded,
                            color: scheme.onSurfaceVariant),
                      ),
                    ),
                  ),
                  if (i == 0)
                    Positioned(left: 6, bottom: 6, child: Pill.volt(t.coverPhoto)),
                  Positioned(
                    right: 4,
                    top: 4,
                    child: Material(
                      color: Colors.black.withValues(alpha: 0.6),
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => controller.remove(i),
                        child: Tooltip(
                          message: t.removePhoto,
                          child: const Padding(
                            padding: EdgeInsets.all(5),
                            child: Icon(Icons.close_rounded,
                                size: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
            for (var i = 0; i < controller.uploading; i++)
              tile(ColoredBox(
                color: scheme.surfaceContainerHigh,
                child: const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2.6),
                  ),
                ),
              )),
            if (controller.canAdd)
              tile(Material(
                color: scheme.surfaceContainerHigh,
                child: InkWell(
                  onTap: () => controller.add(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo_rounded,
                          size: 28, color: context.gym.accentText),
                      const SizedBox(height: 6),
                      Text(
                        t.addPhoto.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: displayFont,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: context.gym.accentText,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          ],
        );
      },
    );
  }
}

// ── Location ─────────────────────────────────────────────────────────────

/// A point on the map, in decimal degrees.
typedef GymLocation = ({double latitude, double longitude});

/// Where the gym is. Set on a map (the picker can also jump to the phone's
/// own position), and it is what lets the gym browser rank this gym for
/// members nearby -- a gym without one sorts below every gym that has one.
/// Whoever can open this field can save it: the gym profile editor is
/// behind EDIT_GYM_PROFILE, and the server re-checks that on save.
class GymLocationField extends StatelessWidget {
  const GymLocationField({super.key, required this.value, required this.onChanged});

  final GymLocation? value;
  final ValueChanged<GymLocation> onChanged;

  Future<void> _pick(BuildContext context) async {
    final picked = await Navigator.of(context).push<GymLocation>(
      MaterialPageRoute(builder: (_) => GymLocationPickerPage(initial: value)),
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final value = this.value;
    final set = value != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (set) ...[
          // A small, still map of the pin. Tapping it opens the picker.
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 150,
              child: Stack(
                children: [
                  FlutterMap(
                    key: ValueKey(value),
                    options: MapOptions(
                      initialCenter: LatLng(value.latitude, value.longitude),
                      initialZoom: 16,
                      interactionOptions:
                          const InteractionOptions(flags: InteractiveFlag.none),
                    ),
                    children: [
                      ...osmLayers(attribution: false),
                      MarkerLayer(markers: [
                        Marker(
                          point: LatLng(value.latitude, value.longitude),
                          width: 44,
                          height: 44,
                          alignment: Alignment.topCenter,
                          child: Icon(
                            Icons.location_on_rounded,
                            size: 44,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? volt
                                : ink,
                            shadows: const [
                              Shadow(blurRadius: 6, color: Colors.black54),
                            ],
                          ),
                        ),
                      ]),
                    ],
                  ),
                  Positioned.fill(
                    child: Material(
                      type: MaterialType.transparency,
                      child: InkWell(onTap: () => _pick(context)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
        ActionTile(
          icon: set ? Icons.location_on_rounded : Icons.add_location_alt_rounded,
          accent: set,
          title: set ? t.gymLocationSet : t.gymLocationNotSet,
          subtitle: set
              ? '${value.latitude.toStringAsFixed(5)}, ${value.longitude.toStringAsFixed(5)}'
              : t.gymLocationHint,
          trailing: Text(
            (set ? t.updateGymLocation : t.setGymLocation).toUpperCase(),
            textAlign: TextAlign.end,
            style: TextStyle(
              fontFamily: displayFont,
              fontWeight: FontWeight.w800,
              color: context.gym.accentText,
            ),
          ),
          onTap: () => _pick(context),
        ),
      ],
    );
  }
}
