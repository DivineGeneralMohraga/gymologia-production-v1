import { SecurityEventType } from '@prisma/client';

/**
 * When has a caller earned a temporary block?
 *
 * Kept as plain data and pure functions so the decision can be tested
 * without a database, a server, or an attacker. The service beside this
 * file does the counting and the blocking; everything about *whether* to
 * block is here.
 *
 * The governing constraint is that a block is a blunt instrument aimed at
 * an address, and in India an address is very often shared. Carrier-grade
 * NAT puts thousands of mobile subscribers behind one public IP, so a
 * threshold tuned for a single attacker on a single machine can lock a
 * whole town out of the app. Every number below is set high enough that
 * ordinary use -- including a broken client retrying, or a gym full of
 * members on one office connection -- stays well clear of it.
 */
export interface BlockRule {
  type: keyof typeof SecurityEventType;
  /** How far back to count. */
  windowMinutes: number;
  /** Events inside the window that earn a block. */
  threshold: number;
  /** How long the block lasts. */
  blockMinutes: number;
  /** Why this signal is safe to block on, in one line. */
  because: string;
}

/**
 * Only signals where a legitimate client has no reason to produce many.
 *
 * Deliberately absent, and each for a reason:
 *
 *   PERMISSION_DENIED         a confused staff member clicking around a
 *                             screen they do not have rights to generates
 *                             these all day. Blocking them is punishing
 *                             the wrong person for a UI problem.
 *   WEBHOOK_SIGNATURE_INVALID blocking here means blocking whoever sent
 *                             it, and the plausible sender is Cashfree
 *                             with a stale secret. Locking out the payment
 *                             provider is worse than the forged call,
 *                             which is already ignored.
 *   RATE_LIMIT_TRIPPED        the throttler has already handled it; a
 *                             second penalty on the same event is just a
 *                             longer outage for a busy client.
 *   ANOMALOUS_LOGIN           a real member travelling, on a new phone.
 *                             Worth a look by a human, never an automatic
 *                             lockout.
 */
export const BLOCK_RULES: readonly BlockRule[] = [
  {
    type: 'INJECTION_ATTEMPT',
    windowMinutes: 10,
    threshold: 5,
    blockMinutes: 15,
    because:
      'no legitimate client sends SQL or script metacharacters in a phone ' +
      'or name field; five is a margin against an over-eager sanitizer rule',
  },
  {
    type: 'BRUTE_FORCE',
    windowMinutes: 10,
    threshold: 10,
    blockMinutes: 30,
    because: 'repeated credential guessing has no innocent reading',
  },
  {
    type: 'OTP_ABUSE',
    windowMinutes: 15,
    threshold: 20,
    blockMinutes: 15,
    because:
      'set high because one mobile carrier NAT can carry a whole city; ' +
      'twenty in a quarter of an hour is farming, not a gym signing members up',
  },
  {
    type: 'INVALID_TOKEN',
    windowMinutes: 10,
    threshold: 30,
    blockMinutes: 10,
    because:
      'a broken client looping on a stale token can produce these honestly, ' +
      'so the bar is high and the block short',
  },
];

/** Indexed for the hot path. */
const RULES_BY_TYPE = new Map<string, BlockRule>(
  BLOCK_RULES.map((r) => [r.type, r]),
);

export function ruleFor(
  type: keyof typeof SecurityEventType,
): BlockRule | undefined {
  return RULES_BY_TYPE.get(type);
}

/**
 * Addresses that are never blocked, whatever they do.
 *
 * Loopback and the private ranges cover the operator's own machine, the
 * test suite, and anything reaching us from inside the network. Blocking
 * those buys nothing -- an attacker who is already inside does not need
 * the public API -- and costs a great deal: a threshold tripped during a
 * test run would lock the developer out of their own server, and a health
 * check from a load balancer on 10.x would take the whole service out of
 * rotation.
 *
 * An address we cannot read is exempt for the same reason: blocking the
 * empty string blocks everyone whose IP failed to parse.
 */
export function isExempt(ip: string | null | undefined): boolean {
  if (!ip) return true;

  const v = ip.trim().toLowerCase();
  if (v === '' || v === '::1' || v === 'localhost' || v === 'unknown') {
    return true;
  }

  // ::ffff:127.0.0.1 and friends.
  const bare = v.startsWith('::ffff:') ? v.slice(7) : v;

  if (bare === '127.0.0.1' || bare.startsWith('127.')) return true;
  if (bare.startsWith('10.')) return true;
  if (bare.startsWith('192.168.')) return true;
  if (bare.startsWith('169.254.')) return true; // link-local
  if (bare.startsWith('fc') || bare.startsWith('fd')) return true; // unique local v6
  if (bare.startsWith('fe80:')) return true; // link-local v6

  // 172.16.0.0 – 172.31.255.255
  const m = /^172\.(\d{1,2})\./.exec(bare);
  if (m) {
    const second = Number(m[1]);
    if (second >= 16 && second <= 31) return true;
  }

  return false;
}

/**
 * Given a count already observed for one address, should it be blocked,
 * and for how long?
 *
 * Returns null when the type carries no rule or the count is under the
 * threshold — which is the overwhelmingly common answer, and the reason
 * this is separated from anything that touches the database.
 */
export function decide(
  type: keyof typeof SecurityEventType,
  countInWindow: number,
): { blockMinutes: number; rule: BlockRule } | null {
  const rule = ruleFor(type);
  if (!rule) return null;
  if (countInWindow < rule.threshold) return null;
  return { blockMinutes: rule.blockMinutes, rule };
}
