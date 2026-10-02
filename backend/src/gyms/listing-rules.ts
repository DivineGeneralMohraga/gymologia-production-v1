import { Prisma } from '@prisma/client';

/**
 * Whether a gym needs verified KYC before it is listed in the public gym
 * browser.
 *
 * The spec asks for it, and the whole verification flow exists (app form,
 * private document storage, the admin review queue). It is switched OFF
 * from 2026-10-01 by product decision: KYC is not being run yet, and with
 * the gate on no real gym could ever reach search -- a Pro plan would buy
 * nothing. Off, a gym is listed once it is active, public, and on a live
 * Pro plan.
 *
 * REQUIRE_KYC_FOR_LISTING=true turns the gate back on. Search, the ranking
 * screen and the ranking scope all read this one function, so they cannot
 * disagree about who is listed.
 */
export function kycRequiredForListing(): boolean {
  return (process.env.REQUIRE_KYC_FOR_LISTING ?? '').trim().toLowerCase() === 'true';
}

// ── Demo gyms ────────────────────────────────────────────────────────────

/**
 * The Play test accounts (TEST_ACCOUNT_PHONE): the logins given to Google's
 * reviewers, and used for demos and testing.
 */
export function testAccountPhones(): string[] {
  return (process.env.TEST_ACCOUNT_PHONE ?? '')
    .split(',')
    .map((p) => p.trim())
    .filter(Boolean);
}

export function isTestAccount(phone?: string | null): boolean {
  return !!phone && testAccountPhones().includes(phone);
}

/**
 * A gym owned by a test account is a demo gym: it exists so reviewers and
 * testers see a working app, with made-up ratings and photos. Real users
 * must never see one -- not in search, not on its public page, not as the
 * host of an event -- or they would be shown gyms that do not exist.
 *
 * Returns the Prisma filter for a gym that hides demo gyms from anyone who
 * is not themselves a test account. A viewer who is not signed in is not a
 * test account.
 */
export function hideDemoGymsFrom(viewerPhone?: string | null): Prisma.GymWhereInput {
  const phones = testAccountPhones();
  if (phones.length === 0 || isTestAccount(viewerPhone)) return {};
  return { owner: { phone: { notIn: phones } } };
}

/**
 * The same rule for raw SQL over `gyms g`, used by the ranking scope. A
 * real gym is ranked only against real gyms, so a demo gym can never push
 * it down; a demo gym is ranked against everything.
 */
export function hideDemoGymsSql(show: boolean): Prisma.Sql {
  const phones = testAccountPhones();
  if (show || phones.length === 0) return Prisma.empty;
  return Prisma.sql`AND NOT EXISTS (
    SELECT 1 FROM users u WHERE u.id = g."ownerId" AND u.phone IN (${Prisma.join(phones)})
  )`;
}
