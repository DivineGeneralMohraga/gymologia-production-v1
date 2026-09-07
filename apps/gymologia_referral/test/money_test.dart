import 'package:flutter_test/flutter_test.dart';
import 'package:gymologia_referral/core/money.dart';
import 'package:intl/date_symbol_data_local.dart';

/// Money is the only arithmetic this app does, so it is the only arithmetic
/// worth testing. Everything else on screen is a string the server sent.
void main() {
  setUpAll(() async => initializeDateFormatting());

  test('a reward is fifty rupees, not fifty paise', () {
    // The whole app deals in paise. Reading rewardPaise as rupees would
    // show ₹5,000 for a ₹50 reward, and it would look plausible.
    expect(Money.format(5000), '₹50');
  });

  test('the verification fee is ten rupees', () {
    expect(Money.format(1000), '₹10');
  });

  test('nothing earned is not an empty string', () {
    // A blank where a zero belongs reads as "still loading".
    expect(Money.format(0), '₹0');
  });

  test('a round amount carries no trailing paise', () {
    expect(Money.format(15000), isNot(contains('.')));
  });

  test('but an amount with paise shows them', () {
    // TDS is a percentage of a reward, so it will not stay round.
    expect(Money.format(4750), '₹47.50');
    expect(Money.format(1), '₹0.01');
  });

  test('grouping is Indian, not Western', () {
    // ₹1,00,000 and not ₹100,000. This is the reason en_IN is pinned in
    // Money rather than following the interface language: a Tamil reader
    // in India still expects lakh grouping.
    expect(Money.format(10000000), '₹1,00,000');
    expect(Money.format(100000000), '₹10,00,000');
  });

  test('a negative amount keeps its sign rather than reading as a credit', () {
    // Nothing produces one today. If a reversal ever nets out below zero,
    // the screen must not show it as money owed to the referrer.
    expect(Money.format(-5000), contains('50'));
    expect(Money.format(-5000), isNot('₹50'));
  });
}
