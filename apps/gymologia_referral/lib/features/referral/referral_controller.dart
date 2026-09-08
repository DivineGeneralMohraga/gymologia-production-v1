import 'package:flutter/widgets.dart';

import '../../core/api/api_client.dart';
import '../../core/api/error_text.dart';
import '../../core/api/referral_api.dart';

/// The referral account, held once for the whole app.
///
/// Three of the four tabs read the same document — the code screen wants
/// the code and the totals, the payout screen wants the payout block, and
/// the earnings screen wants the totals to sit above its list. Fetching it
/// per tab would mean three requests on every switch and, worse, three
/// answers that can disagree: saving a UPI ID on one tab would leave the
/// others showing the old one until something happened to refresh them.
class ReferralController extends ChangeNotifier {
  ReferralController(this._api);

  final ReferralApi _api;

  Map<String, dynamic>? _account;
  List<dynamic>? _earnings;
  bool _earningsCapped = false;

  ApiException? _failure;
  bool _loading = false;

  Map<String, dynamic>? get account => _account;
  List<dynamic>? get earnings => _earnings;
  bool get earningsCapped => _earningsCapped;
  /// The last failure, kept whole rather than reduced to its message --
  /// the screens need the code to decide which language to say it in.
  ApiException? get failure => _failure;
  bool get loading => _loading;

  String get code => (_account?['code'] as String?) ?? '';
  String get shareText => (_account?['shareText'] as String?) ?? '';

  Map<String, dynamic> get payout =>
      (_account?['payout'] as Map?)?.cast<String, dynamic>() ?? const {};

  Map<String, dynamic> get totals =>
      (_account?['earnings'] as Map?)?.cast<String, dynamic>() ?? const {};

  /// What can be taken out now, and what would actually arrive.
  ///
  /// Straight off the same response as the totals, and never recomputed
  /// here. The deduction is the server's arithmetic; a second copy on the
  /// phone would eventually disagree with the amount actually sent, and the
  /// person holding the phone would be right to believe the phone.
  Map<String, dynamic> get withdrawable =>
      (_account?['withdrawable'] as Map?)?.cast<String, dynamic>() ?? const {};

  bool get canWithdraw => withdrawable['canWithdraw'] == true;

  /// Why not, in the server's words. First entry only: the server orders
  /// these so the most useful one leads.
  String? get withdrawBlockedBy {
    final list = (withdrawable['blockedBy'] as List?)?.cast<String>();
    return (list == null || list.isEmpty) ? null : list.first;
  }

  List<dynamic>? get withdrawals => _withdrawals;
  List<dynamic>? _withdrawals;

  int get timesRedeemed => _int(_account?['timesRedeemed']);
  int get awaitingClearance => _int(_account?['awaitingClearance']);

  /// The sentences the server says are still outstanding, in its words.
  ///
  /// Not re-derived from `upiIdMasked` and `panStatus` here. The server
  /// decides what is missing — it is the one that will refuse a payout —
  /// and a second opinion computed on the phone is a second opinion that
  /// can be wrong.
  List<String> get stillNeeded =>
      (payout['youStillNeedTo'] as List?)?.cast<String>() ?? const [];

  Future<void> load({bool quiet = false}) async {
    if (!quiet) {
      _loading = true;
      _failure = null;
      notifyListeners();
    }
    // Two calls, and deliberately not one try block around both.
    //
    // The account is what the code screen and the payout screen are made
    // of; the reward list is only the earnings tab. Sharing a catch meant a
    // transient failure on the second call threw away a first call that had
    // already succeeded, and blanked the code screen to show an error about
    // a list it does not display. The account is kept the moment it
    // arrives.
    try {
      _account = await _api.referral();
      _failure = null;
    } on ApiException catch (e) {
      // The previous account is left alone rather than cleared: a refresh
      // that fails should leave the numbers that were on screen where they
      // were and say so, not blank a page that was right a second ago.
      _failure = e;
      _loading = false;
      notifyListeners();
      return;
    }

    try {
      final earnings = await _api.earnings();
      _earnings = (earnings['items'] as List?) ?? const [];
      _earningsCapped = earnings['hasMore'] == true;
      // Its own try below, for the same reason the account and the rewards
      // are separate: a failure here should not blank a screen that has
      // already loaded correctly.
    } on ApiException catch (e) {
      // Recorded, so the earnings tab can explain itself, while the code
      // and payout screens carry on with the account that did load.
      _failure = e;
    } finally {
      _loading = false;
      notifyListeners();
    }

    // Third, and swallowing its own failure: the withdrawal history is the
    // least important thing on any of these screens, and it must not be
    // able to spoil two that have already loaded.
    await loadWithdrawals();
  }

  /// What to show when the last load failed.
  ///
  /// Asked of the controller rather than recomputed on each of the three
  /// tabs that can show it. The first version of this was six lines
  /// appended to all three files by a patch script -- three copies of a
  /// rule, in an app whose every other comment argues against exactly that.
  ///
  /// [fallback] is the caller's already-translated generic message, so this
  /// file needs no BuildContext of its own beyond the one it passes on.
  String failureText(BuildContext context, String fallback) {
    final f = _failure;
    return f == null ? fallback : apiErrorText(context, f);
  }

  /// Ask for the money, then reload so every screen agrees.
  ///
  /// Returns null on success, or the failure itself for the caller to
  /// phrase. Deliberately not a String: turning it into one needs a
  /// BuildContext, and a controller holding a context across an await is
  /// holding one that may belong to a widget already gone. The widget has
  /// a `mounted` check; this does not.
  ///
  /// The reload is not optional. A withdrawal changes the balance, the
  /// blocked reasons and the history at once, and leaving any of them stale
  /// on a screen about money is how somebody withdraws twice.
  Future<ApiException?> withdraw() async {
    try {
      await _api.withdraw();
      await load(quiet: true);
      await loadWithdrawals();
      return null;
    } on ApiException catch (e) {
      return e;
    }
  }

  Future<void> loadWithdrawals() async {
    try {
      _withdrawals = await _api.withdrawals();
      notifyListeners();
    } on ApiException {
      // The rest of the screen is still usable without the history.
    }
  }

  /// Forget everything on sign-out.
  ///
  /// This controller outlives the sign-in screen -- it is held above the
  /// tree so the tabs can share it -- so without this, signing out and
  /// signing in as somebody else shows the previous person's code and
  /// balance until the first fetch returns. On a screen whose whole
  /// content is somebody's money, a stale frame is not a cosmetic problem.
  void forget() {
    if (_account == null &&
        _earnings == null &&
        _withdrawals == null &&
        _failure == null) {
      return;
    }
    _account = null;
    _earnings = null;
    _withdrawals = null;
    _earningsCapped = false;
    _failure = null;
    notifyListeners();
  }

  /// Take the payout block the server just returned rather than refetching.
  ///
  /// The PUT answers with the same view `/me/referral` would, so a second
  /// round trip would only be a chance for the two to disagree.
  void adoptPayout(Map<String, dynamic> updated) {
    if (_account == null) return;
    _account!['payout'] = updated;
    notifyListeners();
  }

  static int _int(Object? v) => (v is num) ? v.toInt() : 0;
}
