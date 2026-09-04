import '../../l10n/app_localizations.dart';

// Input rules, kept as pure functions.
//
// Each takes the translations rather than looking them up, so the rule
// stays a plain function and the caller -- which has the context -- decides
// what language the answer comes back in.
//
// These mirror what the backend enforces, so the phone catches bad input
// before a request goes out — but the server never trusts that, and
// re-validates everything on arrival.

/// Indian mobile numbers are ten digits and never start below 6.
/// Returns null when valid, or the message to show under the field.
String? validateIndianMobile(AppLocalizations t, String? raw) {
  final value = raw?.trim() ?? '';
  if (value.isEmpty) return t.enterPhoneNumber;
  if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
    return t.enterValidMobile;
  }
  return null;
}

String? validateName(AppLocalizations t, String? raw) {
  final value = raw?.trim() ?? '';
  if (value.length < 2) return t.enterYourName;
  if (value.length > 120) return t.nameTooLong;
  return null;
}

/// Email is optional throughout the app; an empty value is valid.
String? validateOptionalEmail(AppLocalizations t, String? raw) {
  final value = raw?.trim() ?? '';
  if (value.isEmpty) return null;
  return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)
      ? null
      : t.enterValidEmail;
}

/// Age, not date of birth — a deliberate privacy choice, so the lower
/// bound is a product rule rather than a formatting one.
String? validateAge(AppLocalizations t, String? raw) {
  final age = int.tryParse(raw?.trim() ?? '');
  if (age == null) return t.enterYourAge;
  if (age < 13) return t.mustBeAtLeast13;
  if (age > 100) return t.enterValidAge;
  return null;
}
