import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../../core/api/api_client.dart';
import '../../core/api/uploads.dart';
import '../../core/location/location_service.dart';
import '../../core/media/media_picker.dart';
import '../../l10n/app_localizations.dart';
import '../../theme.dart';
import '../../ui/kit.dart';
import '../auth/auth_controller.dart';

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

/// Where the gym is, taken from the owner's phone while they stand in it.
/// It is what lets the gym browser rank this gym for members nearby; a gym
/// without one sorts below every gym that has one.
class GymLocationField extends StatefulWidget {
  const GymLocationField({super.key, required this.value, required this.onChanged});

  final GymLocation? value;
  final ValueChanged<GymLocation> onChanged;

  @override
  State<GymLocationField> createState() => _GymLocationFieldState();
}

class _GymLocationFieldState extends State<GymLocationField> {
  bool _busy = false;

  Future<void> _locate() async {
    final t = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    // High accuracy and a longer wait than the member-side search: this
    // pin is fixed for every member who will ever look for the gym.
    final position = await LocationService().requestAndFetch(
      accuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 20),
    );
    if (!mounted) return;
    setState(() => _busy = false);
    if (position == null) {
      messenger.showSnackBar(SnackBar(content: Text(t.gymLocationFailed)));
      return;
    }
    widget.onChanged((latitude: position.latitude, longitude: position.longitude));
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final value = widget.value;
    final set = value != null;

    return ActionTile(
      icon: set ? Icons.location_on_rounded : Icons.add_location_alt_rounded,
      accent: set,
      title: set ? t.gymLocationSet : t.gymLocationNotSet,
      subtitle: set
          ? '${value.latitude.toStringAsFixed(5)}, ${value.longitude.toStringAsFixed(5)}'
          : t.gymLocationHint,
      trailing: _busy
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2.4),
            )
          : Text(
              (set ? t.updateGymLocation : t.setGymLocation).toUpperCase(),
              textAlign: TextAlign.end,
              style: TextStyle(
                fontFamily: displayFont,
                fontWeight: FontWeight.w800,
                color: context.gym.accentText,
              ),
            ),
      onTap: _busy ? null : _locate,
    );
  }
}
