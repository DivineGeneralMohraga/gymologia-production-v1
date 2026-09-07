import 'package:intl/intl.dart';

/// Rupees, out of paise.
///
/// Every amount in this app arrives from the server as an integer number of
/// paise and is formatted here. Nothing multiplies, divides or adds money
/// anywhere else: a balance the client computed would eventually disagree
/// with the one the server will actually pay, and the person holding the
/// phone would be right to believe the phone.
///
/// The Indian grouping is not the same as the Western one -- ₹1,00,000, not
/// ₹100,000 -- so the locale matters and `en_IN` is used regardless of the
/// interface language. A Tamil reader in India still expects lakh grouping.
class Money {
  const Money._();

  static final NumberFormat _whole = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  static final NumberFormat _withPaise = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  /// ₹50 for a round amount, ₹50.25 when there are paise to show.
  ///
  /// Rewards are whole rupees today and trailing `.00` on every row is
  /// noise; TDS is a percentage and will not be, so both cases are handled
  /// rather than assuming the amounts that exist right now.
  static String format(int paise) {
    final rupees = paise / 100;
    return paise % 100 == 0 ? _whole.format(rupees) : _withPaise.format(rupees);
  }
}
