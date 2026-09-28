import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:gymologia/core/utils/validators.dart';
import 'package:gymologia/features/auth/auth_controller.dart';
import 'package:gymologia/features/auth/phone_screen.dart';
import 'package:gymologia/l10n/app_localizations.dart';
import 'package:gymologia/l10n/app_localizations_en.dart';

/// The validators take the translations rather than looking them up, so a
/// test has to supply them. English, because the assertions below are
/// about which rule fired, not about the wording.
final AppLocalizations t = AppLocalizationsEn();

/// Holds the tree on the login screen without touching secure storage or
/// the network, which a real AuthController would do on construction.
class _SignedOutAuth extends AuthController {
  @override
  AuthStatus get status => AuthStatus.signedOut;

  @override
  bool get busy => false;
}

/// The screen reads its copy from the localisations, so the delegates have
/// to be installed or `AppLocalizations.of` finds nothing and every widget
/// test fails inside the build rather than on its assertion. Pinned to
/// English so the expectations below are stable whatever the host locale.
Widget _wrap(Widget child) => ChangeNotifierProvider<AuthController>.value(
      value: _SignedOutAuth(),
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: child,
      ),
    );

void main() {
  group('phone validation', () {
    test('rejects an empty number', () {
      expect(validateIndianMobile(t, ''), t.enterPhoneNumber);
      expect(validateIndianMobile(t, null), t.enterPhoneNumber);
      expect(validateIndianMobile(t, '   '), t.enterPhoneNumber);
    });

    test('rejects numbers that do not start 6-9', () {
      for (final prefix in ['1', '2', '3', '4', '5', '0']) {
        expect(
          validateIndianMobile(t, '${prefix}234567890'),
          t.enterValidMobile,
          reason: 'leading $prefix should be rejected',
        );
      }
    });

    test('rejects the wrong number of digits', () {
      expect(validateIndianMobile(t, '98765432'), isNotNull);
      expect(validateIndianMobile(t, '987654321'), isNotNull);
      expect(validateIndianMobile(t, '98765432101'), isNotNull);
    });

    test('accepts every valid leading digit', () {
      for (final prefix in ['6', '7', '8', '9']) {
        expect(validateIndianMobile(t, '${prefix}876543210'), isNull);
      }
    });

    test('tolerates surrounding whitespace', () {
      expect(validateIndianMobile(t, '  9876543210  '), isNull);
    });
  });

  group('age validation', () {
    test('is required and numeric', () {
      expect(validateAge(t, ''), t.enterYourAge);
      expect(validateAge(t, 'abc'), t.enterYourAge);
    });

    test('enforces the 13 lower bound', () {
      expect(validateAge(t, '12'), t.mustBeAtLeast13);
      expect(validateAge(t, '13'), isNull);
    });

    test('rejects implausible ages', () {
      expect(validateAge(t, '101'), t.enterValidAge);
      expect(validateAge(t, '100'), isNull);
    });
  });

  group('email validation', () {
    test('is optional', () {
      expect(validateOptionalEmail(t, ''), isNull);
      expect(validateOptionalEmail(t, null), isNull);
    });

    test('rejects malformed addresses when one is given', () {
      expect(validateOptionalEmail(t, 'nope'), isNotNull);
      expect(validateOptionalEmail(t, 'a@b'), isNotNull);
      expect(validateOptionalEmail(t, 'a b@c.com'), isNotNull);
    });

    test('accepts a well-formed address', () {
      expect(validateOptionalEmail(t, 'sarthak@example.com'), isNull);
    });
  });

  group('login screen', () {
    testWidgets('shows the phone field and the +91 prefix', (tester) async {
      await tester.pumpWidget(_wrap(const PhoneScreen()));

      // The redesign sets the name and the button in capitals.
      expect(find.text(t.appName.toUpperCase()), findsOneWidget);
      expect(find.text(t.sendOtp.toUpperCase()), findsOneWidget);
      expect(find.text('+91'), findsOneWidget);
    });

    testWidgets('blocks submission of an empty number', (tester) async {
      await tester.pumpWidget(_wrap(const PhoneScreen()));

      await tester.tap(find.text(t.sendOtp.toUpperCase()));
      await tester.pump();

      expect(find.text(t.enterPhoneNumber), findsOneWidget);
    });

    testWidgets('blocks submission of an invalid number', (tester) async {
      await tester.pumpWidget(_wrap(const PhoneScreen()));

      await tester.enterText(find.byType(TextFormField), '1234567890');
      await tester.tap(find.text(t.sendOtp.toUpperCase()));
      await tester.pump();

      expect(find.text(t.enterValidMobile), findsOneWidget);
    });
  });
}
