/// The two shapes this app checks before sending, and the server checks
/// again after.
///
/// Public and in one file rather than private to the screen, for two
/// reasons. A test that re-typed the pattern would pass whatever the screen
/// actually did, which is the shape of a check that proves nothing. And
/// these are copies of server patterns, so the file they live in is the
/// place to say where the originals are and to be checked against them.
///
/// Originals, both in `backend/src/common/validation`:
///   upi-vpa.ts   `/^[a-z0-9](?:[a-z0-9._-]{0,48}[a-z0-9])?@[a-z0-9]{2,64}$/`
///   india-ids.ts `/^[A-Z]{5}\d{4}[A-Z]$/`
///
/// Copied exactly, not approximated. A client stricter than the server
/// refuses an address that would have worked; a client looser than it
/// produces a 400 the user cannot act on. Both fail silently on the one
/// screen where somebody types where their money goes.
library;

/// The server's VPA pattern, character for character.
final RegExp upiVpaPattern =
    RegExp(r'^[a-z0-9](?:[a-z0-9._-]{0,48}[a-z0-9])?@[a-z0-9]{2,64}$');

/// The server's PAN pattern: five letters, four digits, one letter.
final RegExp panPattern = RegExp(r'^[A-Z]{5}\d{4}[A-Z]$');

/// Normalised the way the server normalises before it validates, so the
/// two are judging the same string rather than two different ones.
String normaliseVpa(String raw) => raw.trim().toLowerCase();

String normalisePan(String raw) => raw.trim().toUpperCase();

/// Collapses runs of whitespace, as the server's Transform does.
String normaliseHolderName(String raw) =>
    raw.trim().replaceAll(RegExp(r'\s+'), ' ');

/// Whether this looks like a UPI address.
///
/// The single-`@` rule is separate from the pattern for the same reason it
/// is separate on the server: `a@b@c` can slip through a looser expression
/// and be stored as an address that can never resolve.
///
/// This says nothing about whether the address is *yours*. `sarthaq@ybl` is
/// a perfectly valid address belonging to somebody else and passes every
/// check here. Nothing in a regex can prevent that -- only the ₹10 name
/// check can -- which is why the payout screen carries a warning that no
/// amount of validation replaces.
bool looksLikeUpiId(String raw) {
  final value = normaliseVpa(raw);
  return upiVpaPattern.hasMatch(value) && '@'.allMatches(value).length == 1;
}

bool looksLikePan(String raw) => panPattern.hasMatch(normalisePan(raw));
