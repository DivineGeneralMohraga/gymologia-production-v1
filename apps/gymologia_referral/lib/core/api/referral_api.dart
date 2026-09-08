import 'api_client.dart';
import '../config/app_config.dart';

/// Every endpoint this app talks to, in one place.
///
/// There is deliberately no method here that the referral app does not
/// need. The account these tokens belong to can reach gym endpoints,
/// chat, attendance and the rest -- it is the same Gymologia account -- and
/// the way to keep this app to its job is for the surface it knows about to
/// be exactly its job.
class ReferralApi {
  ReferralApi(this._client);

  final ApiClient _client;

  // -- sign in ---------------------------------------------------------

  /// Ask for a code. `appClient` is REFERRAL, which is what makes the
  /// server apply the gym-owner exclusion to this challenge.
  Future<Map<String, dynamic>> requestOtp(String phone) => _client.post(
        '/auth/otp/request',
        auth: false,
        body: {'phone': phone, 'appClient': AppConfig.appClient},
      );

  Future<Map<String, dynamic>> verifyOtp({
    required String challengeId,
    required String phone,
    required String code,
    String? deviceId,
  }) =>
      _client.post(
        '/auth/otp/verify',
        auth: false,
        body: {
          'challengeId': challengeId,
          'phone': phone,
          'code': code,
          'appClient': AppConfig.appClient,
          'deviceId': ?deviceId,
        },
      );

  /// Finish signing up. The registration token carries the phone number and
  /// the client it was issued for, so neither is sent again -- and neither
  /// can be swapped for another.
  Future<Map<String, dynamic>> register({
    required String registrationToken,
    required String name,
    required int age,
    String? email,
    String? deviceId,
    String? locale,
  }) =>
      _client.post(
        '/auth/register',
        auth: false,
        body: {
          'registrationToken': registrationToken,
          'name': name,
          'age': age,
          if (email != null && email.isNotEmpty) 'email': email,
          'deviceId': ?deviceId,
          'locale': ?locale,
        },
      );

  Future<Map<String, dynamic>> me() => _client.get('/auth/me');

  Future<void> logout() async {
    await _client.post('/auth/logout');
  }

  // -- the referral account --------------------------------------------

  /// Code, totals, payout state, and the share sentence in the language
  /// this app is currently being read in.
  Future<Map<String, dynamic>> referral() => _client.get('/me/referral');

  Future<Map<String, dynamic>> earnings({int limit = 50}) =>
      _client.get('/me/referral/earnings', query: {'limit': limit});

  Future<Map<String, dynamic>> setPayoutMethod({
    required String upiId,
    required String holderName,
  }) =>
      _client.put(
        '/me/referral/payout-method',
        body: {'upiId': upiId, 'holderName': holderName},
      );

  Future<Map<String, dynamic>> setPan(String pan) =>
      _client.put('/me/referral/pan', body: {'pan': pan});

  /// Ask for the cleared rewards to be sent.
  ///
  /// No body: what is withdrawn is everything that has cleared, and the
  /// amount is the server's to decide. A client that named a figure could
  /// name one the server disagrees with, and the disagreement would be
  /// about money.
  Future<Map<String, dynamic>> withdraw() =>
      _client.post('/me/referral/withdraw');

  Future<List<dynamic>> withdrawals() async =>
      _list(await _client.get('/me/referral/withdrawals'));

  // -- account and support ---------------------------------------------

  Future<Map<String, dynamic>> updateProfile({String? name, String? email}) =>
      _client.patch('/me/profile', body: {
        'name': ?name,
        'email': ?email,
      });

  Future<Map<String, dynamic>> raiseTicket({
    required String subject,
    required String message,
    required String contactPhone,
    String? contactEmail,
  }) =>
      _client.post('/me/support', body: {
        'subject': subject,
        'message': message,
        'contactPhone': contactPhone,
        if (contactEmail != null && contactEmail.isNotEmpty)
          'contactEmail': contactEmail,
      });

  Future<List<dynamic>> myTickets() async =>
      _list(await _client.get('/me/support'));

  // -- legal ------------------------------------------------------------

  Future<Map<String, dynamic>> legalIndex() =>
      _client.get('/legal', auth: false);

  Future<Map<String, dynamic>> legalDocument(String slug) =>
      _client.get('/legal/$slug', auth: false);

  Future<Map<String, dynamic>> legalStatus() => _client.get('/me/legal');

  Future<Map<String, dynamic>> acceptLegal() =>
      _client.post('/me/legal/accept');

  /// The client hands back a map; a list endpoint arrives under `data`.
  ///
  /// A property of the transport rather than of any one screen, so it is
  /// written once here.
  List<dynamic> _list(Map<String, dynamic> res) {
    final data = res['data'];
    if (data is List) return data;
    if (res['items'] is List) return res['items'] as List;
    return const [];
  }
}
