import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// Dates, written in the language the app is being read in.
///
/// This exists because five screens each carried their own
/// `['Jan', 'Feb', ...]` table. That was fine while the app was English-only
/// and became wrong the moment it was not: the interface would be in Tamil
/// and every date still reading "Jan". `intl` already knows the month and
/// day names for every locale the app ships, so none of those tables need to
/// exist.
///
/// Every function takes the locale explicitly rather than reading it from a
/// context, so they can be called from anywhere and are trivial to test.
class Dates {
  const Dates._();

  /// The locale to format in. Read it once per build:
  ///
  ///     final locale = Dates.localeOf(context);
  static String localeOf(BuildContext context) =>
      Localizations.localeOf(context).toLanguageTag();

  /// "12 Aug" — a day and month, no year. For anything within this year.
  static String dayMonth(DateTime date, String locale) =>
      DateFormat('d MMM', locale).format(date);

  /// "Mon 12 Aug" — used where the weekday matters, as it does on an
  /// attendance sheet.
  static String weekdayDayMonth(DateTime date, String locale) =>
      DateFormat('EEE d MMM', locale).format(date);

  /// "12 Aug 2026" — where the year cannot be assumed.
  static String full(DateTime date, String locale) =>
      DateFormat('d MMM y', locale).format(date);

  /// "Aug" — a bare month, for chart labels.
  static String month(DateTime date, String locale) =>
      DateFormat('MMM', locale).format(date);

  /// A time of day, in whatever form the locale writes it: 24-hour in most of
  /// the world, 12-hour with am/pm where that is the convention.
  static String time(DateTime date, String locale) =>
      DateFormat.jm(locale).format(date);

  /// Parses an ISO string and formats it, returning empty for anything
  /// unparseable rather than throwing — these are display paths, and a bad
  /// date from the API should not take a screen down.
  static String isoDayMonth(String? iso, String locale) {
    final date = _parse(iso);
    return date == null ? '' : dayMonth(date, locale);
  }

  static String isoWeekdayDayMonth(String? iso, String locale) {
    final date = _parse(iso);
    return date == null ? '' : weekdayDayMonth(date, locale);
  }

  static String isoFull(String? iso, String locale) {
    final date = _parse(iso);
    return date == null ? '' : full(date, locale);
  }

  static DateTime? _parse(String? iso) =>
      iso == null ? null : DateTime.tryParse(iso);
}
