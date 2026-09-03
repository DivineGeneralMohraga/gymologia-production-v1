import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../l10n/app_localizations.dart';

/// The language the app is read in.
///
/// Null means "follow the device", which is the right default: someone whose
/// phone is already in Tamil should not have to find a setting to be read to
/// in Tamil. The setting exists for the case where the two differ — a shared
/// handset, or a phone set up by somebody else.
class LocaleController extends ChangeNotifier {
  LocaleController({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const _key = 'app_locale';

  final FlutterSecureStorage _storage;

  Locale? _locale;
  bool _restored = false;

  /// Null while following the device.
  Locale? get locale => _locale;
  bool get restored => _restored;

  /// The languages with translation files, in the order the picker shows
  /// them. English first, then the rest by speaker population.
  static const supported = AppLocalizations.supportedLocales;

  /// What to send as Accept-Language so the server returns exercise content
  /// in the same language the interface is in. Falls back to the device's
  /// language when no choice has been made.
  String headerValue(Locale deviceLocale) =>
      (_locale ?? deviceLocale).languageCode;

  Future<void> restore() async {
    try {
      final saved = await _storage.read(key: _key);
      if (saved != null && saved.isNotEmpty) {
        _locale = Locale(saved);
      }
    } catch (_) {
      // A locked keystore is not a reason to fail to start; the device
      // language is a perfectly good answer.
    }
    _restored = true;
    notifyListeners();
  }

  Future<void> set(Locale? locale) async {
    _locale = locale;
    notifyListeners();
    try {
      if (locale == null) {
        await _storage.delete(key: _key);
      } else {
        await _storage.write(key: _key, value: locale.languageCode);
      }
    } catch (_) {
      // The choice still applies for this run even if it cannot be saved.
    }
  }
}
