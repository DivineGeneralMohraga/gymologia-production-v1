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
