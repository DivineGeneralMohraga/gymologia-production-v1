import 'package:geolocator/geolocator.dart';

/// Whether asking for a location fix is even worth attempting right now,
/// without triggering the OS permission dialog.
enum LocationReadiness {
  /// Already granted -- safe to fetch a position with no prompt.
  granted,

  /// Never asked, or asked and dismissed without a permanent "don't ask
  /// again". Requesting now will show the OS dialog.
  undetermined,

  /// Denied permanently, or the device's location service itself is off.
  /// Requesting again would either no-op or need a settings-page detour,
  /// so callers should fall back to text search instead of asking.
  unavailable,
}

/// Nearby-gym ranking is entirely optional: every failure mode here
/// resolves to "fall back to the existing name/district search" rather
/// than surfacing an error, since a person who never touched a location
/// prompt should see the same gym browser as one who denied it.
class LocationService {
  Future<LocationReadiness> readiness() async {
    // A platform error here must not escape: the gym browser awaits this
    // before its first load, and a throw would leave it spinning forever.
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return LocationReadiness.unavailable;
      }
      final permission = await Geolocator.checkPermission();
      switch (permission) {
        case LocationPermission.always:
        case LocationPermission.whileInUse:
          return LocationReadiness.granted;
        case LocationPermission.denied:
          return LocationReadiness.undetermined;
        case LocationPermission.deniedForever:
        case LocationPermission.unableToDetermine:
          return LocationReadiness.unavailable;
      }
    } catch (_) {
      return LocationReadiness.unavailable;
    }
  }

  /// Shows the OS permission dialog if needed, then returns a fix.
  /// Returns null on any denial, disabled service, or platform error --
  /// callers treat null exactly like "user never asked".
  Future<Position?> requestAndFetch() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return null;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 8),
        ),
      );
    } catch (_) {
      return null;
    }
  }

  /// A fix without prompting -- only ever called when [readiness] already
  /// said `granted`.
  Future<Position?> fetchSilently() async {
    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 8),
        ),
      );
    } catch (_) {
      return null;
    }
  }
}
