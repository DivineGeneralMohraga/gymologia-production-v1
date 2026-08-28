import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum AppMode { member, staff }

/// Which face of the app the person is currently using.
///
/// One account, two modes — not two apps. Everyone starts in member mode,
/// as the spec says; the switch lives in settings and is remembered, so a
/// gym owner who lives in the CRM does not land on the gym browser every
/// morning.
///
/// The mode is purely presentational. It changes which screens render, and
/// nothing else: the server grants access from staff records and roles, so
/// flipping this on a device buys no permissions whatsoever.
class AppModeController extends ChangeNotifier {
  AppModeController([FlutterSecureStorage? storage])
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
            );

  static const _key = 'app_mode';

  final FlutterSecureStorage _storage;

  AppMode _mode = AppMode.member;
  bool _restored = false;

  AppMode get mode => _mode;
  bool get isStaff => _mode == AppMode.staff;
  bool get restored => _restored;

  Future<void> restore() async {
    try {
      final saved = await _storage.read(key: _key);
      if (saved == AppMode.staff.name) _mode = AppMode.staff;
    } catch (_) {
      // A storage failure just means we start in member mode, which is
      // the correct default anyway.
    }
    _restored = true;
    notifyListeners();
  }

  Future<void> switchTo(AppMode mode) async {
    if (_mode == mode) return;
    _mode = mode;
    notifyListeners();
    try {
      await _storage.write(key: _key, value: mode.name);
    } catch (_) {
      // Not worth surfacing: the switch worked, it just will not persist.
    }
  }

  Future<void> toggle() =>
      switchTo(_mode == AppMode.member ? AppMode.staff : AppMode.member);
}
