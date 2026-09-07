import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Session tokens at rest.
///
/// Keychain on iOS, EncryptedSharedPreferences on Android — never plain
/// SharedPreferences, which is world-readable on a rooted device and gets
/// swept into cloud backups.
class TokenStore {
  TokenStore([FlutterSecureStorage? storage])
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock,
              ),
            );

  final FlutterSecureStorage _storage;

  static const _kAccess = 'access_token';
  static const _kRefresh = 'refresh_token';
  static const _kDeviceId = 'device_id';

  Future<String?> readAccess() => _storage.read(key: _kAccess);
  Future<String?> readRefresh() => _storage.read(key: _kRefresh);

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _kAccess, value: accessToken);
    await _storage.write(key: _kRefresh, value: refreshToken);
  }

  Future<void> clear() async {
    await _storage.delete(key: _kAccess);
    await _storage.delete(key: _kRefresh);
  }

  /// A stable per-install id, so the backend can name sessions in a
  /// "signed in on these devices" list. Generated once and kept.
  Future<String> deviceId() async {
    final existing = await _storage.read(key: _kDeviceId);
    if (existing != null) return existing;
    final generated = DateTime.now().microsecondsSinceEpoch.toRadixString(36);
    await _storage.write(key: _kDeviceId, value: generated);
    return generated;
  }
}
