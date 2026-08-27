import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:gymologia/core/utils/validators.dart';
import 'package:gymologia/features/auth/auth_controller.dart';
import 'package:gymologia/features/auth/phone_screen.dart';

/// Holds the tree on the login screen without touching secure storage or
/// the network, which a real AuthController would do on construction.
class _SignedOutAuth extends AuthController {
  @override
  AuthStatus get status => AuthStatus.signedOut;

  @override
  bool get busy => false;
}

Widget _wrap(Widget child) => ChangeNotifierProvider<AuthController>.value(
      value: _SignedOutAuth(),
      child: MaterialApp(home: child),
    );

void main() {
  group('phone validation', () {
    test('rejects an empty number', () {
      expect(validateIndianMobile(''), 'Enter your mobile number');
      expect(validateIndianMobile(null), 'Enter your mobile number');
      expect(validateIndianMobile('   '), 'Enter your mobile number');
    });

    test('rejects numbers that do not start 6-9', () {
      for (final prefix in ['1', '2', '3', '4', '5', '0']) {
        expect(
          validateIndianMobile('${prefix}234567890'),
          'Enter a valid 10-digit Indian mobile number',
          reason: 'leading $prefix should be rejected',
        );
      }
    });

    test('rejects the wrong number of digits', () {
      expect(validateIndianMobile('98765432'), isNotNull);
      expect(validateIndianMobile('987654321'), isNotNull);
      expect(validateIndianMobile('98765432101'), isNotNull);
    });

    test('accepts every valid leading digit', () {
      for (final prefix in ['6', '7', '8', '9']) {
        expect(validateIndianMobile('${prefix}876543210'), isNull);
      }
    });

    test('tolerates surrounding whitespace', () {
      expect(validateIndianMobile('  9876543210  '), isNull);
    });
  });

  group('age validation', () {
    test('is required and numeric', () {
      expect(validateAge(''), 'Enter your age');
      expect(validateAge('abc'), 'Enter your age');
    });

    test('enforces the 13 lower bound', () {
      expect(validateAge('12'), 'You must be at least 13');
      expect(validateAge('13'), isNull);
    });

    test('rejects implausible ages', () {
      expect(validateAge('101'), 'Enter a valid age');
      expect(validateAge('100'), isNull);
    });
  });

  group('email validation', () {
    test('is optional', () {
      expect(validateOptionalEmail(''), isNull);
      expect(validateOptionalEmail(null), isNull);
    });

    test('rejects malformed addresses when one is given', () {
      expect(validateOptionalEmail('nope'), isNotNull);
      expect(validateOptionalEmail('a@b'), isNotNull);
      expect(validateOptionalEmail('a b@c.com'), isNotNull);
    });

    test('accepts a well-formed address', () {
      expect(validateOptionalEmail('sarthak@example.com'), isNull);
    });
  });

  group('login screen', () {
    testWidgets('shows the phone field and the +91 prefix', (tester) async {
      await tester.pumpWidget(_wrap(const PhoneScreen()));

      expect(find.text('Gymologia'), findsOneWidget);
      expect(find.text('Send OTP'), findsOneWidget);
      expect(find.text('+91  '), findsOneWidget);
    });

    testWidgets('blocks submission of an empty number', (tester) async {
      await tester.pumpWidget(_wrap(const PhoneScreen()));

      await tester.tap(find.text('Send OTP'));
      await tester.pump();

      expect(find.text('Enter your mobile number'), findsOneWidget);
    });

    testWidgets('blocks submission of an invalid number', (tester) async {
      await tester.pumpWidget(_wrap(const PhoneScreen()));

      await tester.enterText(find.byType(TextFormField), '1234567890');
      await tester.tap(find.text('Send OTP'));
      await tester.pump();

      expect(
        find.text('Enter a valid 10-digit Indian mobile number'),
        findsOneWidget,
      );
    });
  });
}
