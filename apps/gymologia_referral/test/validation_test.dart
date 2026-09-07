import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:gymologia_referral/core/validation.dart';

/// The client's copies of two server patterns.
///
/// Imported from the app rather than re-typed here. A test that spells the
/// pattern out again passes whatever the app actually does, which is the
/// shape of a check that proves nothing -- and the first version of this
/// file did exactly that.
///
/// The last group goes further and reads the server's own source, because
/// two copies of a rule drift and the copy in the client is the one that
/// goes wrong.
void main() {
  group('UPI addresses', () {
    test('ordinary handles are accepted', () {
      expect(looksLikeUpiId('sarthak@okhdfcbank'), isTrue);
      expect(looksLikeUpiId('9876543210@ybl'), isTrue);
      expect(looksLikeUpiId('first.last@oksbi'), isTrue);
      expect(looksLikeUpiId('a_b-c.d@paytm'), isTrue);
    });

    test('case and surrounding space do not decide the answer', () {
      // The server lower-cases and trims before validating, so a client
      // judging the raw string would reject what the server accepts.
      expect(looksLikeUpiId('  Sarthak@OKHDFCBANK '), isTrue);
    });

    test('a two-character handle is accepted', () {
      // The case the server pattern got wrong once: `{1,48}` in the middle
      // group let one- and three-character handles through while failing
      // two-character ones. Not a boundary anybody tries by hand.
      expect(looksLikeUpiId('a@axl'), isTrue);
      expect(looksLikeUpiId('ab@axl'), isTrue);
      expect(looksLikeUpiId('abc@axl'), isTrue);
    });

    test('a second @ is refused', () {
      // Well-formed to a looser pattern, and impossible to route.
      expect(looksLikeUpiId('a@b@ybl'), isFalse);
    });

    test('missing parts are refused', () {
      expect(looksLikeUpiId('sarthak'), isFalse);
      expect(looksLikeUpiId('@ybl'), isFalse);
      expect(looksLikeUpiId('sarthak@'), isFalse);
      expect(looksLikeUpiId('sarthak@y'), isFalse,
          reason: 'a bank handle is two characters or more');
    });

    test('a handle cannot start or end with punctuation', () {
      expect(looksLikeUpiId('.sarthak@ybl'), isFalse);
      expect(looksLikeUpiId('sarthak.@ybl'), isFalse);
    });

    test('a one-letter typo is accepted, and that is the point', () {
      // `sarthaq` is a perfectly valid address belonging to somebody else.
      // No pattern can catch it, which is why the payout screen carries a
      // warning and why the ten-rupee name check exists at all. Asserting
      // this is refused would be asserting a comfort that does not exist.
      expect(looksLikeUpiId('sarthaq@okhdfcbank'), isTrue);
    });
  });

  group('PAN', () {
    test('the documented shape is accepted', () {
      expect(looksLikePan('ABCDE1234F'), isTrue);
      expect(looksLikePan('abcde1234f'), isTrue, reason: 'upper-cased first');
      expect(looksLikePan('  ABCDE1234F  '), isTrue);
    });

    test('anything else is refused', () {
      expect(looksLikePan('ABCD1234F'), isFalse, reason: 'four letters');
      expect(looksLikePan('ABCDE123F'), isFalse, reason: 'three digits');
      expect(looksLikePan('ABCDE12345'), isFalse, reason: 'no closing letter');
      expect(looksLikePan('ABCDE1234FG'), isFalse, reason: 'too long');
      expect(looksLikePan(''), isFalse);
    });
  });

  group('and they still match the server', () {
    // Both files sit in the same repository, so the drift can be caught
    // here rather than by a user whose UPI ID this app refuses and the API
    // would have taken.
    final root = Directory.current.parent.parent;
    final upiSource =
        File('${root.path}/backend/src/common/validation/upi-vpa.ts');
    final idSource =
        File('${root.path}/backend/src/common/validation/india-ids.ts');

    test('the server source is where this test thinks it is', () {
      // Without this, a moved or renamed file turns both checks below into
      // silent skips and the drift guard quietly stops guarding.
      expect(upiSource.existsSync(), isTrue,
          reason: 'looked in ${upiSource.path}');
      expect(idSource.existsSync(), isTrue,
          reason: 'looked in ${idSource.path}');
    });

    test('the VPA pattern is the server\'s, character for character', () {
      final match =
          RegExp(r'const VPA = /(.+)/;').firstMatch(upiSource.readAsStringSync());
      expect(match, isNotNull, reason: 'could not find the VPA literal');
      expect(upiVpaPattern.pattern, match!.group(1));
    });

    test('so is the PAN pattern', () {
      final match = RegExp(r'/\^\[A-Z\]\{5\}.+?\[A-Z\]\$/')
          .firstMatch(idSource.readAsStringSync());
      expect(match, isNotNull, reason: 'could not find the PAN literal');
      // The literal carries its slashes; the Dart pattern does not.
      final literal = match![0]!;
      expect(panPattern.pattern, literal.substring(1, literal.length - 1));
    });
  });
}
