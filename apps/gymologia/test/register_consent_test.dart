import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:gymologia/features/auth/auth_controller.dart';
import 'package:gymologia/features/auth/register_screen.dart';
import 'package:gymologia/l10n/app_localizations.dart';
import 'package:gymologia/l10n/app_localizations_en.dart';

/// DPDP Act 2023 at the sign-up screen: s.6 consent must be a clear
/// affirmative act (an unticked box, not "by signing up you agree"), and s.9
/// an under-18 account cannot be created without a verified guardian.
///
/// The server enforces both independently -- these tests pin the screen's own
/// behaviour, so that a refactor cannot quietly turn the checkbox back into
/// decoration or let the guardian block stop gating the button.
final AppLocalizations t = AppLocalizationsEn();

class _RecordingAuth extends AuthController {
  int registerCalls = 0;
  int? lastAge;
  String? lastGuardianToken;

  @override
  AuthStatus get status => AuthStatus.signedOut;

  @override
  bool get busy => false;

  @override
  Future<bool> register({
    required String registrationToken,
    required String name,
    required int age,
    String? email,
    String? guardianConsentToken,
  }) async {
    registerCalls++;
    lastAge = age;
    lastGuardianToken = guardianConsentToken;
    return false; // stay on the screen; we only care that it was attempted
  }
}

Future<_RecordingAuth> _open(WidgetTester tester) async {
  tester.view.physicalSize = const Size(900, 2600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final auth = _RecordingAuth();
  await tester.pumpWidget(
    ChangeNotifierProvider<AuthController>.value(
      value: auth,
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const RegisterScreen(
          registrationToken: 'token',
          phone: '+919876543210',
        ),
      ),
    ),
  );
  return auth;
}

Future<void> _fill(WidgetTester tester, {required String age}) async {
  final fields = find.byType(TextFormField);
  await tester.enterText(fields.at(0), 'Test User');
  await tester.enterText(fields.at(2), age);
  await tester.pump();
}

Future<void> _tapCreate(WidgetTester tester) async {
  await tester.tap(find.widgetWithText(FilledButton, t.createAccountAction));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
}

void main() {
  testWidgets('the consent checkbox starts unticked', (tester) async {
    await _open(tester);
    expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isFalse);
  });

  testWidgets('an adult who has not ticked consent cannot create an account',
      (tester) async {
    final auth = await _open(tester);
    await _fill(tester, age: '30');
    await _tapCreate(tester);

    expect(auth.registerCalls, 0, reason: 'account created without consent');
    expect(find.text(t.consentRequired), findsOneWidget);
  });

  testWidgets('an adult who ticks consent registers, with no guardian token',
      (tester) async {
    final auth = await _open(tester);
    await _fill(tester, age: '30');
    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    await _tapCreate(tester);

    expect(auth.registerCalls, 1);
    expect(auth.lastAge, 30);
    expect(auth.lastGuardianToken, isNull);
  });

  testWidgets('the guardian block appears only for an under-18 age',
      (tester) async {
    await _open(tester);
    expect(find.text(t.guardianPhoneLabel), findsNothing);

    await _fill(tester, age: '15');
    expect(find.text(t.guardianPhoneLabel), findsOneWidget);
    expect(find.text(t.under18GuardianNotice), findsOneWidget);

    await _fill(tester, age: '18');
    expect(find.text(t.guardianPhoneLabel), findsNothing);
  });

  testWidgets(
      'a minor with consent ticked still cannot register until the guardian '
      'is verified', (tester) async {
    final auth = await _open(tester);
    await _fill(tester, age: '15');
    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    await _tapCreate(tester);

    expect(auth.registerCalls, 0,
        reason: 'minor account attempted without a verified guardian');
    expect(find.text(t.guardianConsentBlocksSubmit), findsOneWidget);
  });
}
