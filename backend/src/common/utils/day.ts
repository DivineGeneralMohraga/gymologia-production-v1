/**
 * Calendar-day arithmetic for an Indian product.
 *
 * Every "which day was that" decision in this system — attendance, leave,
 * analytics buckets — has to be answered in Indian local time, because that
 * is the day the person at the gym is living in. Answering it in UTC is
 * wrong by five and a half hours, and it is wrong in the direction that
 * matters: a 5am session, which is when a great many Indian gyms are
 * busiest, is 23:30 UTC the *previous* day. Left in UTC, that member's
 * Monday visit is recorded against Sunday, and if they also come at 8am the
 * unique index sees two different dates and stores two records for one day.
 *
 * Answering it in the *server's* local time is worse still: it silently
 * differs between a developer's machine and the deployed host, so the bug
 * only appears in production.
 *
 * India has observed no daylight saving since 1945, so a fixed offset is
 * exact rather than an approximation. That is the reason this is arithmetic
 * and not a timezone library.
 */

/** IST is UTC+05:30, with no daylight saving to complicate it. */
const IST_OFFSET_MS = (5 * 60 + 30) * 60 * 1000;

/**
 * The Indian calendar day containing `input`, as midnight UTC.
 *
 * Midnight UTC is how Prisma reads and writes a `@db.Date` column, so the
 * value round-trips through the database unchanged.
 *
 * A date-only string ("2026-08-31") parses as midnight UTC and comes back
 * as the same day, so query parameters are safe to pass straight in.
 */
export function istDay(input: string | Date): Date {
  const at = new Date(input);
  const shifted = new Date(at.getTime() + IST_OFFSET_MS);
  return new Date(
    Date.UTC(
      shifted.getUTCFullYear(),
      shifted.getUTCMonth(),
      shifted.getUTCDate(),
    ),
  );
}

/** Today, in India. */
export function istToday(): Date {
  return istDay(new Date());
}

/**
 * The Monday of the Indian week containing `input`, as midnight UTC.
 * Used to group attendance into weeks without a per-day comparison.
 */
export function istWeekStart(input: string | Date): Date {
  const day = istDay(input);
  // getUTCDay is 0 for Sunday; shift so Monday is 0.
  const offset = (day.getUTCDay() + 6) % 7;
  return new Date(day.getTime() - offset * 24 * 60 * 60 * 1000);
}
