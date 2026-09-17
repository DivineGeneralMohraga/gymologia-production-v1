import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gymologia/features/safety/safety_actions.dart';
import 'package:gymologia/l10n/app_localizations.dart';
import 'package:gymologia/l10n/app_localizations_en.dart';

final AppLocalizations t = AppLocalizationsEn();

/// Every locale the app ships, so the checks below can be run against all
/// of them rather than only the one the assertions were written in.
const _locales = [
  'en', 'hi', 'bn', 'ta', 'te', 'mr', 'ml', 'kn', 'gu', 'pa',
];

Widget _wrap(Widget child) => MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    );

void main() {
  group('report categories', () {
    test('match the server enum exactly', () {
      // The app sends these strings straight into a Prisma enum. A typo
      // survives every build and every review, and surfaces as a 400 to
      // somebody halfway through reporting harassment.
      final schema = File('../../backend/prisma/schema.prisma');

      // Asserted rather than skipped. A test that quietly passes when it
      // cannot find what it is checking is the most dangerous kind: it
      // reports green forever while checking nothing.
      expect(
        schema.existsSync(),
        isTrue,
        reason: 'schema.prisma not found at ${schema.absolute.path} — this '
            'test cannot verify anything without it',
      );

      final source = schema.readAsStringSync();
      final block = RegExp(r'enum ReportCategory \{([^}]*)\}').firstMatch(source);
      expect(block, isNotNull, reason: 'no ReportCategory enum in schema.prisma');

      final serverValues = block!
          .group(1)!
          .split('\n')
          .map((line) => line.trim())
          .where((line) => line.isNotEmpty && !line.startsWith('//'))
          .toSet();

      expect(
        reportCategoryValues.toSet(),
        equals(serverValues),
        reason: 'the picker and the server disagree about the categories',
      );
    });

    test('are offered without duplicates', () {
      expect(reportCategoryValues.toSet().length, reportCategoryValues.length);
    });

    test('lead with harassment', () {
      // Not decoration: it is what most reports are, and a first item that
      // is usually right is what makes the form quick to finish.
      expect(reportCategoryValues.first, 'HARASSMENT');
    });

    test('every value has wording in every language', () {
      for (final locale in _locales) {
        final strings = lookupAppLocalizations(Locale(locale));
        for (final value in reportCategoryValues) {
          final label = reportCategoryLabel(strings, value);
          expect(label.trim(), isNotEmpty,
              reason: '$value has no label in $locale');
          // A label equal to the enum name means the switch fell through
          // to a raw value being shown to somebody.
          expect(label, isNot(value), reason: '$value is unlabelled in $locale');
        }
      }
    });

    test('OTHER is the fallback, not a gap', () {
      // The switch ends in `_ =>`, so an unknown value must land somewhere
      // readable rather than throwing inside a build.
      expect(reportCategoryLabel(t, 'NOT_A_REAL_CATEGORY'),
          t.reportCategoryOther);
    });
  });

  group('the block confirmation', () {
    testWidgets('says it is silent and reversible before anything happens',
        (tester) async {
      // The three things somebody weighs in the moment: they cannot reach
      // me, they will not know, and I can undo it. Losing any one of them
      // in a copy edit changes whether a person blocks at all.
      final copy = t.blockConfirmBody.toLowerCase();
      expect(copy, contains('not be able to message you'));
      expect(copy, contains('not told'));
      expect(copy, contains('settings'));

      await tester.pumpWidget(_wrap(
        Builder(
          builder: (context) => TextButton(
            onPressed: () => showDialog<bool>(
              context: context,
              builder: (_) => AlertDialog(content: Text(t.blockConfirmBody)),
            ),
            child: const Text('open'),
          ),
        ),
      ));

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.text(t.blockConfirmBody), findsOneWidget);
    });
  });

  group('the report copy', () {
    test('explains why the reporter must describe the content', () {
      // "See the message" is not a report anybody can act on, because the
      // review desk does not surface bodies. Said before they type, not as
      // an error afterwards.
      final hint = t.reportDetailsHint.toLowerCase();
      expect(hint, contains('reviewers'));
      expect(hint, contains('your own words'));
    });

    test('does not claim the service cannot read messages', () {
      // It can. Message bodies are encrypted at rest with a key the server
      // holds, and ChatService decrypts them on every read of a
      // conversation; what is true is that this desk does not show them.
      //
      // The first version of this copy said "we cannot read them" in all
      // ten languages, and the test above REQUIRED it to -- so the false
      // claim was pinned in place by the thing meant to catch it. Hence
      // this, which fails if it ever comes back.
      for (final locale in _locales) {
        final hint =
            lookupAppLocalizations(Locale(locale)).reportDetailsHint;
        for (final claim in ['cannot read', "can't read", 'unable to read']) {
          expect(hint.toLowerCase(), isNot(contains(claim)),
              reason: 'the unreadability claim is back in $locale');
        }
      }
    });

    test('does not let a report be mistaken for a block', () {
      final copy = t.alsoBlockThemExplainer.toLowerCase();
      expect(copy, contains('time'));
      expect(copy, contains('straight away'));
    });
  });

  group('deleting your account', () {
    test('says plainly that the account survives the grace period', () {
      // The thirty days is the only thing between a decision made in a bad
      // moment and a permanent loss. If a copy edit drops it, the screen
      // still reads fine and the safety net is gone.
      final intro = t.deleteAccountIntro.toLowerCase();
      expect(intro, contains('30 days'));
      expect(intro, contains('cannot be brought back'));
    });

    test('is honest that payment records are kept', () {
      // Play requires deletion; the law requires books of account. Both are
      // true at once, and a screen that promises everything vanishes is
      // making a promise the server does not keep.
      final kept = t.whatIsKeptList.toLowerCase();
      expect(kept, contains('books of account'));
      expect(t.whatIsKept.toLowerCase(), contains('removed from it'));
    });

    test('names what actually goes', () {
      final gone = t.whatIsDeletedList.toLowerCase();
      for (final item in ['name', 'email', 'weight', 'chat', 'upi']) {
        expect(gone, contains(item), reason: '$item is not listed as deleted');
      }
    });

    test('the amount and date placeholders survive translation', () {
      // A translation that drops {amount} leaves somebody agreeing to lose
      // an unnamed sum, which is the one number on the screen that matters.
      for (final locale in _locales) {
        final strings = lookupAppLocalizations(Locale(locale));
        final money = strings.unwithdrawnWarning('₹150.00');
        expect(money, contains('₹150.00'), reason: 'amount lost in $locale');
        expect(money, isNot(contains('{')), reason: 'braces in $locale');

        final when = strings.deletionScheduled('17/10/2026');
        expect(when, contains('17/10/2026'), reason: 'date lost in $locale');
        expect(when, isNot(contains('{')), reason: 'braces in $locale');
      }
    });

    test('every deletion string is translated in every language', () {
      final english = AppLocalizationsEn();
      final pick = <String, String Function(AppLocalizations)>{
        'deleteAccount': (s) => s.deleteAccount,
        'deleteAccountIntro': (s) => s.deleteAccountIntro,
        'whatIsDeleted': (s) => s.whatIsDeleted,
        'whatIsDeletedList': (s) => s.whatIsDeletedList,
        'whatIsKept': (s) => s.whatIsKept,
        'whatIsKeptList': (s) => s.whatIsKeptList,
        'deleteGymsFirst': (s) => s.deleteGymsFirst,
        'iUnderstandLoseEarnings': (s) => s.iUnderstandLoseEarnings,
        'keepMyAccount': (s) => s.keepMyAccount,
        'deletionCancelled': (s) => s.deletionCancelled,
        'deleteAccountConfirm': (s) => s.deleteAccountConfirm,
      };

      for (final locale in _locales.where((l) => l != 'en')) {
        final strings = lookupAppLocalizations(Locale(locale));
        pick.forEach((key, get) {
          expect(get(strings).trim(), isNotEmpty,
              reason: '$key is empty in $locale');
          expect(get(strings), isNot(get(english)),
              reason: '$key fell back to English in $locale');
        });
      }
    });
  });

  group('translations', () {
    test('every safety string is present in every language', () {
      // Missing keys fall back to English, which is fine for a settings
      // label and wrong here: somebody trying to get away from a person
      // who frightens them should not be the one reading a language they
      // may not know.
      String Function(AppLocalizations) pick(String which) => switch (which) {
            'block' => (s) => s.block,
            'unblock' => (s) => s.unblock,
            'report' => (s) => s.report,
            'blocked' => (s) => s.blocked,
            'blockedAccounts' => (s) => s.blockedAccounts,
            'noBlockedAccounts' => (s) => s.noBlockedAccounts,
            'safetyAndPrivacy' => (s) => s.safetyAndPrivacy,
            'blockConfirmBody' => (s) => s.blockConfirmBody,
            'unblockExplainer' => (s) => s.unblockExplainer,
            'whyReporting' => (s) => s.whyReporting,
            'reportDetails' => (s) => s.reportDetails,
            'reportDetailsHint' => (s) => s.reportDetailsHint,
            'alsoBlockThem' => (s) => s.alsoBlockThem,
            'alsoBlockThemExplainer' => (s) => s.alsoBlockThemExplainer,
            'sendReport' => (s) => s.sendReport,
            'reportSent' => (s) => s.reportSent,
            'myReports' => (s) => s.myReports,
            'noReportsSent' => (s) => s.noReportsSent,
            'reportStatusOpen' => (s) => s.reportStatusOpen,
            'reportStatusReviewing' => (s) => s.reportStatusReviewing,
            'reportStatusActioned' => (s) => s.reportStatusActioned,
            _ => (s) => s.reportStatusDismissed,
          };

      const keys = [
        'block', 'unblock', 'report', 'blocked', 'blockedAccounts',
        'noBlockedAccounts', 'safetyAndPrivacy', 'blockConfirmBody',
        'unblockExplainer', 'whyReporting', 'reportDetails',
        'reportDetailsHint', 'alsoBlockThem', 'alsoBlockThemExplainer',
        'sendReport', 'reportSent', 'myReports', 'noReportsSent',
        'reportStatusOpen', 'reportStatusReviewing', 'reportStatusActioned',
        'reportStatusDismissed',
      ];

      final english = AppLocalizationsEn();
      for (final locale in _locales.where((l) => l != 'en')) {
        final strings = lookupAppLocalizations(Locale(locale));
        for (final key in keys) {
          final translated = pick(key)(strings);
          expect(translated.trim(), isNotEmpty,
              reason: '$key is empty in $locale');
          expect(
            translated,
            isNot(pick(key)(english)),
            reason: '$key is untranslated in $locale — it fell back to '
                'English, which is the one screen that must not',
          );
        }
      }
    });

    test('the name placeholder survives translation', () {
      // A translation that drops {name} leaves "Block " with nothing after
      // it, and one that mangles the braces shows them to the person.
      for (final locale in _locales) {
        final strings = lookupAppLocalizations(Locale(locale));
        for (final produced in [
          strings.blockPerson('Ravi'),
          strings.reportPerson('Ravi'),
          strings.unblockQuestion('Ravi'),
        ]) {
          expect(produced, contains('Ravi'), reason: 'name lost in $locale');
          expect(produced, isNot(contains('{')), reason: 'braces in $locale');
        }
      }
    });
  });
}
