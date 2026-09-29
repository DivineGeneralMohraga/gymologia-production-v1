import 'dart:typed_data';

import 'package:dio/dio.dart';

import 'api_client.dart';

/// What a file is for. Decides the bucket, who may upload it, and whether
/// it is ever publicly readable -- KYC documents never are.
class UploadKind {
  const UploadKind._();
  static const gymImage = 'GYM_IMAGE';
  static const eventBanner = 'EVENT_BANNER';
  static const kycDocument = 'KYC_DOCUMENT';
}

/// The file was bigger than the bucket accepts. Raised before a byte is
/// sent, so nobody waits a minute to be told no.
class UploadTooLarge implements Exception {
  UploadTooLarge(this.maxBytes);
  final int maxBytes;
  int get maxMb => (maxBytes / (1024 * 1024)).round();
}

/// Uploads one file in two steps: the API hands out a single-use signed
/// URL scoped to this gym's folder, and the bytes go straight to storage.
/// The API never carries the file itself, so a large photo does not tie
/// up the server, and the returned URL is the one to send back with the
/// form it belongs to.
class Uploader {
  Uploader(this._client);
  final ApiClient _client;

  /// A separate client: the signed URL carries its own token, and sending
  /// our bearer token to storage would be sending it somewhere it is not
  /// needed.
  static final Dio _storage = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 20),
    sendTimeout: const Duration(seconds: 90),
    receiveTimeout: const Duration(seconds: 30),
  ));

  Future<String> upload({
    required String gymId,
    required String kind,
    required Uint8List bytes,
    required String contentType,
  }) async {
    final signed = await _client.post(
      '/gyms/$gymId/uploads/sign',
      body: {'kind': kind, 'contentType': contentType},
    );

    final maxBytes = signed['maxBytes'];
    if (maxBytes is int && bytes.length > maxBytes) {
      throw UploadTooLarge(maxBytes);
    }

    final Response<dynamic> res;
    try {
      res = await _storage.put<dynamic>(
        signed['uploadUrl'] as String,
        data: Stream.fromIterable([bytes]),
        options: Options(
          headers: {
            Headers.contentTypeHeader: contentType,
            Headers.contentLengthHeader: bytes.length,
            // A fresh random path every time, so this never overwrites.
            'x-upsert': 'false',
          },
          validateStatus: (_) => true,
        ),
      );
    } on DioException {
      throw ApiException(_client.strings.networkError);
    }

    final status = res.statusCode ?? 0;
    if (status < 200 || status >= 300) {
      throw ApiException(_client.strings.somethingWentWrong,
          statusCode: status);
    }
    return signed['assetUrl'] as String;
  }

  /// The type storage will be told, from the file's name. Null for
  /// anything the buckets would refuse anyway.
  static String? contentTypeFor(String fileName) {
    final ext = fileName.toLowerCase().split('.').last;
    return switch (ext) {
      'jpg' || 'jpeg' => 'image/jpeg',
      'png' => 'image/png',
      'webp' => 'image/webp',
      'pdf' => 'application/pdf',
      _ => null,
    };
  }
}
