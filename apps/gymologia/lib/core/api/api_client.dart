import 'dart:async';
import 'package:dio/dio.dart';
import '../config/app_config.dart';
import '../storage/token_store.dart';

/// Something the user can be shown. Network failures are translated here
/// rather than at each call site, so no screen ever renders a raw Dio
/// exception at somebody.
class ApiException implements Exception {
  ApiException(this.message, {this.statusCode, this.reference});

  final String message;
  final int? statusCode;

  /// The backend attaches a reference id to every error. Quoting it to
  /// support ties a user's report to the exact log line.
  final String? reference;

  bool get isNetwork => statusCode == null;

  @override
  String toString() => message;
}

/// The one HTTP client.
///
/// Attaches the bearer token, and on a 401 refreshes once and replays the
/// request. Concurrent 401s share a single refresh — otherwise five
/// parallel calls would fire five rotations, and because the backend
/// rotates refresh tokens, four of them would be rejected as replay and
/// kill the session.
class ApiClient {
  ApiClient({TokenStore? tokenStore, Dio? dio})
      : _tokens = tokenStore ?? TokenStore(),
        _dio = dio ?? Dio() {
    _dio.options
      ..baseUrl = AppConfig.apiBaseUrl
      ..connectTimeout = AppConfig.connectTimeout
      ..receiveTimeout = AppConfig.receiveTimeout
      ..headers['Content-Type'] = 'application/json'
      // Anything 4xx is handled as a response, not thrown, so the
      // interceptor can inspect it before deciding what to do.
      ..validateStatus = (status) => status != null && status < 500;

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (options.extra['skipAuth'] != true) {
            final token = await _tokens.readAccess();
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
          // The exercise directory is translated server-side and picks the
          // language off this header. Without it the interface would be in
          // Tamil and the exercise steps in English.
          final language = localeCode;
          if (language != null) {
            options.headers['Accept-Language'] = language;
          }
          handler.next(options);
        },
      ),
    );
  }

  final Dio _dio;
  final TokenStore _tokens;

  /// The language the interface is currently in, set by the app when the
  /// locale is known or changed. Null until then, in which case the server
  /// falls back to English.
  String? localeCode;

  /// Set when the session cannot be recovered, so the app can drop to the
  /// login screen from wherever it is.
  void Function()? onSessionExpired;

  Future<void>? _refreshInFlight;

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? query,
    bool auth = true,
  }) =>
      _send(() => _dio.get(
            path,
            queryParameters: query,
            options: Options(extra: {'skipAuth': !auth}),
          ));

  Future<Map<String, dynamic>> post(
    String path, {
    Object? body,
    bool auth = true,
  }) =>
      _send(() => _dio.post(
            path,
            data: body,
            options: Options(extra: {'skipAuth': !auth}),
          ));

  Future<Map<String, dynamic>> patch(
    String path, {
    Object? body,
    bool auth = true,
  }) =>
      _send(() => _dio.patch(
            path,
            data: body,
            options: Options(extra: {'skipAuth': !auth}),
          ));

  Future<Map<String, dynamic>> put(
    String path, {
    Object? body,
    bool auth = true,
  }) =>
      _send(() => _dio.put(
            path,
            data: body,
            options: Options(extra: {'skipAuth': !auth}),
          ));

  Future<Map<String, dynamic>> delete(
    String path, {
    Object? body,
    bool auth = true,
  }) =>
      _send(() => _dio.delete(
            path,
            data: body,
            options: Options(extra: {'skipAuth': !auth}),
          ));

  Future<Map<String, dynamic>> _send(
    Future<Response<dynamic>> Function() call, {
    bool allowRetry = true,
  }) async {
    late Response<dynamic> response;
    try {
      response = await call();
    } on DioException catch (e) {
      throw _fromDio(e);
    }

    if (response.statusCode == 401 && allowRetry) {
      final recovered = await _refresh();
      if (recovered) {
        return _send(call, allowRetry: false);
      }
      onSessionExpired?.call();
      throw ApiException('Your session expired. Please sign in again.',
          statusCode: 401);
    }

    final status = response.statusCode ?? 0;
    if (status >= 400) {
      throw _fromResponse(response);
    }

    final data = response.data;
    if (data is Map<String, dynamic>) return data;
    if (data == null || (data is String && data.isEmpty)) return const {};
    return {'data': data};
  }

  /// Returns true when a fresh access token is in hand.
  Future<bool> _refresh() {
    // Everyone who arrives while a refresh is running waits for that one.
    final existing = _refreshInFlight;
    if (existing != null) {
      return existing.then((_) async => await _tokens.readAccess() != null);
    }

    final completer = Completer<void>();
    _refreshInFlight = completer.future;

    return () async {
      try {
        final refreshToken = await _tokens.readRefresh();
        if (refreshToken == null) return false;

        final response = await _dio.post(
          '/auth/refresh',
          data: {'refreshToken': refreshToken},
          options: Options(extra: {'skipAuth': true}),
        );

        if (response.statusCode != 200 || response.data is! Map) {
          await _tokens.clear();
          return false;
        }

        final data = response.data as Map<String, dynamic>;
        await _tokens.saveTokens(
          accessToken: data['accessToken'] as String,
          refreshToken: data['refreshToken'] as String,
        );
        return true;
      } catch (_) {
        await _tokens.clear();
        return false;
      } finally {
        completer.complete();
        _refreshInFlight = null;
      }
    }();
  }

  ApiException _fromResponse(Response<dynamic> response) {
    final data = response.data;
    String message = 'Something went wrong. Please try again.';
    String? reference;

    if (data is Map<String, dynamic>) {
      reference = data['reference'] as String?;
      final raw = data['message'];
      if (raw is String && raw.isNotEmpty) {
        message = raw;
      } else if (raw is List && raw.isNotEmpty) {
        // class-validator returns a list of field errors.
        message = raw.map((e) => e.toString()).join('\n');
      }
    }

    return ApiException(
      message,
      statusCode: response.statusCode,
      reference: reference,
    );
  }

  ApiException _fromDio(DioException e) {
    final message = switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout =>
        'The server took too long to respond. Check your connection and try again.',
      DioExceptionType.connectionError =>
        'Could not reach the server at ${AppConfig.displayHost}. '
            'Check your internet connection.',
      DioExceptionType.badCertificate =>
        'The server certificate could not be verified.',
      _ => 'Network error. Please try again.',
    };
    return ApiException(message);
  }

  /// Unauthenticated reachability probe, used by the diagnostics screen.
  Future<Duration> ping() async {
    final started = DateTime.now();
    await get('/health', auth: false);
    return DateTime.now().difference(started);
  }
}
