import 'package:flutter/widgets.dart';

import '../../l10n/app_localizations.dart';
import 'api_client.dart';

/// Server error codes this app answers in its own words.
///
/// Two entries, and that is meant to stay a short list. Almost every
/// message from the API is written for the person reading it and showing it
/// verbatim is the right behaviour; a code on every error would become a
/// second, unversioned API that nobody maintains.
///
/// What earns one is a refusal that a person has to *act* on and cannot act
/// on without understanding. A gym owner turned away is not being told
/// about a transient condition -- they are being told the app is not for
/// them, permanently, and that sentence is the only thing they will ever
/// see from Gymologia. A payout in flight is the reason a save silently
/// did nothing on the form where somebody sets where their money goes.
/// Both are English otherwise, to a reader who chose one of ten languages.
class ServerErrorCode {
  const ServerErrorCode._();

  static const referralOwnerExcluded = 'REFERRAL_OWNER_EXCLUDED';
  static const payoutInFlight = 'PAYOUT_IN_FLIGHT';
}

/// What to show for a failed request.
///
/// Matched on the code rather than on the English text. Text matching would
/// break the first time somebody improved the wording, and it could not
/// tell this 403 apart from the suspended-account one that shares its
/// status code and needs a different answer.
String apiErrorText(BuildContext context, ApiException error) {
  final t = AppLocalizations.of(context);
  return switch (error.code) {
    ServerErrorCode.referralOwnerExcluded => t.ownersCannotJoin,
    ServerErrorCode.payoutInFlight => t.payoutInFlight,
    _ => error.message,
  };
}
