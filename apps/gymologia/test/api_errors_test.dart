import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gymologia/core/api/api_client.dart';

/// Answers every request with one fixed status and body, so the client's
/// error translation can be checked without a server.
class _FixedAdapter implements HttpClientAdapter {
  _FixedAdapter(this.status, this.body);

  final int status;
  final Object? body;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return ResponseBody.fromString(
      body == null ? '' : jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

ApiClient _clientAnswering(int status, Object? body) {
  final dio = Dio()..httpClientAdapter = _FixedAdapter(status, body);
  return ApiClient(dio: dio);
}

Future<ApiException> _errorFrom(ApiClient client) async {
  try {
    await client.post('/auth/otp/request', body: const {}, auth: false);
  } on ApiException catch (e) {
    return e;
  }
  fail('expected an ApiException');
}

void main() {
  // On 2026-10-03 MSG91 blocked the server and every login showed "Network
  // error" while the server was answering 502 "Could not send the
  // verification code". A 5xx is the server talking; say what it said.
  test('a 502 shows the server message, not "Network error"', () async {
    final e = await _errorFrom(_clientAnswering(502, {
      'statusCode': 502,
      'message': 'Could not send the verification code. Please try again.',
      'reference': 'ref-1',
    }));
    expect(e.message, 'Could not send the verification code. Please try again.');
    expect(e.statusCode, 502);
    expect(e.reference, 'ref-1');
    expect(e.isNetwork, isFalse);
  });

  test('a 500 with no readable body falls back to "something went wrong"',
      () async {
    final e = await _errorFrom(_clientAnswering(500, null));
    expect(e.message, const ApiStrings().somethingWentWrong);
    expect(e.statusCode, 500);
  });

  test('a 4xx still shows the server message', () async {
    final e = await _errorFrom(_clientAnswering(400, {
      'statusCode': 400,
      'message': 'Please enter your own mobile number.',
    }));
    expect(e.message, 'Please enter your own mobile number.');
    expect(e.statusCode, 400);
  });
}
