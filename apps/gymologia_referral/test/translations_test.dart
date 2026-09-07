import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The ten .arb files, checked against each other.
///
/// Flutter falls back to the template for a missing key, which is the right
/// behaviour at runtime and a very good way to never notice that a language
/// is half English. Nothing else in the build fails on a gap, so this is
/// where a gap has to be found.
///
/// Placeholders matter more than the prose. A translation that drops
/// `{amount}` still compiles and still renders -- it just silently stops
/// telling somebody how much money they are owed.
void main() {
  final dir = Directory('lib/l10n');
  final template = _read(File('${dir.path}/app_en.arb'));
  final templateKeys = _keys(template);

  final locales = <String, Map<String, dynamic>>{};
  for (final file in dir.listSync().whereType<File>()) {
    final name = file.path.split(RegExp(r'[\\/]')).last;
    final match = RegExp(r'^app_([a-z]{2})\.arb$').firstMatch(name);
    if (match == null || match.group(1) == 'en') continue;
    locales[match.group(1)!] = _read(file);
  }

  test('every language the app claims to support has a file', () {
    // The list the picker offers comes from the generated delegate, which
    // comes from these files -- so a language named in the member app and
    // missing here would simply not be offered, with nothing to notice.
    expect(
      locales.keys.toSet(),
      {'hi', 'bn', 'ta', 'te', 'mr', 'ml', 'kn', 'gu', 'pa'},
    );
  });

  test('the template has something to translate', () {
    // Guards the whole file: if the template failed to parse or the glob
    // found nothing, every check below would pass against an empty set.
    expect(templateKeys.length, greaterThan(100));
  });

  for (final entry in locales.entries) {
    final locale = entry.key;
    final keys = _keys(entry.value);

    group(locale, () {
      test('translates every key', () {
        expect(templateKeys.difference(keys), isEmpty,
            reason: 'missing from app_$locale.arb');
      });

      test('invents none', () {
        // A key here and not in the template is dead weight at best and a
        // typo'd key name at worst -- which reads as a missing translation.
        expect(keys.difference(templateKeys), isEmpty,
            reason: 'not in the template');
      });

      test('keeps every placeholder', () {
        for (final key in templateKeys) {
          final expected = _placeholders(template[key] as String);
          if (expected.isEmpty) continue;
          final actual = _placeholders(entry.value[key] as String);
          expect(actual, expected,
              reason: '$key in app_$locale.arb: '
                  'placeholders must match the template exactly');
        }
      });

      test('is not simply the English copied across', () {
        // Every string identical to English means the file was never
        // translated, and the parity checks above would all pass.
        final same = templateKeys
            .where((k) => entry.value[k] == template[k])
            .toSet();
        // These four are the same in every language on purpose: a product
        // name, a support address, and two format examples typed into
        // fields that accept ASCII only.
        final expectedSame = {
          'appTitle',
          'footerLine',
          'footerSupport',
          'upiIdHint',
          'panHint',
          'upiSectionTitle',
          'upiIdLabel',
          'panSectionTitle',
          'panLabel',
        };
        expect(same.difference(expectedSame), isEmpty,
            reason: 'untranslated strings in app_$locale.arb');
      });
    });
  }
}

Map<String, dynamic> _read(File file) =>
    jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;

/// Message keys only: `@@locale` and the `@key` metadata blocks are not
/// translatable content.
Set<String> _keys(Map<String, dynamic> arb) =>
    arb.keys.where((k) => !k.startsWith('@')).toSet();

Set<String> _placeholders(String message) =>
    RegExp(r'\{(\w+)\}').allMatches(message).map((m) => m.group(1)!).toSet();
