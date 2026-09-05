/**
 * What must never reach the audit table, and the walk that removes it.
 *
 * Pulled out of AuditService so it can be tested directly. It was a
 * private method, which meant the one function whose whole job is to stop
 * raw Aadhaar numbers being written to a table that more people can read
 * than the KYC record itself had no test at all.
 *
 * This is a backstop, not the first line. Callers are expected to pass
 * deliberate before/after snapshots rather than whole rows. But at least
 * one caller spreads a DTO wholesale (`after: { ...dto }` in
 * StaffService.update), and that shape leaks silently the day the DTO
 * gains a field somebody did not think about. The backstop is what makes
 * that a near miss rather than an incident.
 */

/**
 * Compared lower-cased, so `aadhaarEnc` and `AADHAARENC` both match.
 *
 * What is deliberately NOT here matters as much as what is:
 *
 *   code            a referral code is the point of the referral audit
 *                   trail. Redacting it would make the log useless for
 *                   the question it exists to answer.
 *   aadhaarLast     the last four digits are what a reviewer works from
 *                   and what the owner sees; they are not the number.
 *   publicKey       public by definition -- it is half of a key exchange.
 *   idempotencyKey  not a credential; it identifies a payout attempt, and
 *                   seeing which one was retried is the trail's job.
 */
export const REDACTED_KEYS: ReadonlySet<string> = new Set([
  // Identity documents, encrypted or not.
  'aadhaar',
  'aadhaarenc',
  'pan',
  'panenc',
  'gstin',
  'gstinenc',
  'upiid',
  'upiidenc',
  'ciphertext',

  // Anything that is, or unlocks, a session.
  'codehash',
  'tokenhash',
  'salt',
  'password',
  'accesstoken',
  'refreshtoken',
  // A signed token that lets the holder finish creating an account for a
  // phone number. Absent until it was looked for.
  'registrationtoken',
  // A device push token is a capability: whoever holds it can send
  // notifications to that phone.
  'fcmtoken',
  'devicetoken',

  // One-time codes. `code` itself is left alone on purpose -- see above.
  'otp',
  'otpcode',
  'devcode',

  // Service credentials, in case one is ever put in a snapshot.
  'clientsecret',
  'authkey',
  'apikey',
  'secret',
  'webhooksecret',
  'servicerolekey',
  'anonkey',
  'privatekey',
]);

const MAX_DEPTH = 6;
const MAX_ARRAY = 50;

/**
 * Recursively replaces sensitive values with a marker.
 *
 * Depth and array length are capped so a pathological object cannot turn
 * an audit write into a stack overflow or a multi-megabyte row. The caps
 * announce themselves in the output rather than silently truncating, so
 * somebody reading the log can tell the difference between "there was
 * nothing here" and "we stopped looking".
 */
export function redactSnapshot(value: unknown): unknown {
  if (value === undefined || value === null) return undefined;

  const walk = (node: unknown, depth: number): unknown => {
    if (depth > MAX_DEPTH) return '[depth-limit]';
    if (node === null || typeof node !== 'object') return node;
    if (node instanceof Date) return node.toISOString();
    if (Array.isArray(node)) {
      const kept = node.slice(0, MAX_ARRAY).map((v) => walk(v, depth + 1));
      if (node.length > MAX_ARRAY) {
        kept.push(`[${node.length - MAX_ARRAY} more]`);
      }
      return kept;
    }

    const out: Record<string, unknown> = {};
    for (const [key, val] of Object.entries(node as Record<string, unknown>)) {
      out[key] = REDACTED_KEYS.has(key.toLowerCase())
        ? '[redacted]'
        : walk(val, depth + 1);
    }
    return out;
  };

  return walk(value, 0);
}
