// Input rules, kept as pure functions.
//
// These mirror what the backend enforces, so the phone catches bad input
// before a request goes out — but the server never trusts that, and
// re-validates everything on arrival.

/// Indian mobile numbers are ten digits and never start below 6.
/// Returns null when valid, or the message to show under the field.
String? validateIndianMobile(String? raw) {
  final value = raw?.trim() ?? '';
  if (value.isEmpty) return 'Enter your mobile number';
  if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
    return 'Enter a valid 10-digit Indian mobile number';
  }
  return null;
}

String? validateName(String? raw) {
  final value = raw?.trim() ?? '';
  if (value.length < 2) return 'Enter your name';
  if (value.length > 120) return 'That name is too long';
  return null;
}

/// Email is optional throughout the app; an empty value is valid.
String? validateOptionalEmail(String? raw) {
  final value = raw?.trim() ?? '';
  if (value.isEmpty) return null;
  return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)
      ? null
      : 'Enter a valid email address';
}

/// Age, not date of birth — a deliberate privacy choice, so the lower
/// bound is a product rule rather than a formatting one.
String? validateAge(String? raw) {
  final age = int.tryParse(raw?.trim() ?? '');
  if (age == null) return 'Enter your age';
  if (age < 13) return 'You must be at least 13';
  if (age > 100) return 'Enter a valid age';
  return null;
}
