/**
 * Nothing secret reaches the audit table.
 *
 *   npx ts-node --transpile-only test/audit-redaction.spec.ts
 *
 * The audit log is read by more people than the KYC record is -- every
 * admin with the log viewer, not just a verification reviewer -- so it is
 * the worst place for a raw identity number to sit. This function is what
 * stops that, and it was a private method with no test.
 *
 * It is a backstop rather than the first line: callers pass deliberate
 * snapshots, not whole rows. But `StaffService.update` writes
 * `after: { ...dto }`, and a spread like that leaks the day somebody adds
 * a field to the DTO without thinking about the log. The tests below are
 * written against that day.
 *
 * Every value here is obviously fake.
 */
import { REDACTED_KEYS, redactSnapshot } from '../src/common/audit/redact';

let failures = 0;
let checks = 0;

function ok(what: string) {
  checks += 1;
  process.stdout.write(`  \x1b[32mPASS\x1b[0m  ${what}\n`);
}
function bad(what: string, detail: string) {
  checks += 1;
  failures += 1;
  process.stdout.write(`  \x1b[31mFAIL\x1b[0m  ${what} -- ${detail}\n`);
}
function hdr(what: string) {
  process.stdout.write(`\n\x1b[1m${what}\x1b[0m\n`);
}

const SECRET = 'THE-SECRET-VALUE-987654321';

/** The only question that matters: can the secret be found anywhere? */
function survives(value: unknown): boolean {
  return JSON.stringify(redactSnapshot(value) ?? null).includes(SECRET);
}

hdr('Every redacted key, at the top level');
for (const key of [...REDACTED_KEYS].sort()) {
  const out = redactSnapshot({ [key]: SECRET }) as Record<string, unknown>;
  if (out[key] === '[redacted]') ok(`${key} is redacted`);
  else bad(`${key} is redacted`, `got ${JSON.stringify(out[key])}`);
}

hdr('Case does not matter');
for (const variant of ['aadhaarEnc', 'AADHAARENC', 'AadhaarEnc', 'aadhaarenc']) {
  if (!survives({ [variant]: SECRET })) ok(`${variant} is redacted`);
  else bad(`${variant} is redacted`, 'the value came through');
}

hdr('Nesting does not help it escape');
const nested = {
  gym: { name: 'Fake Gym', kyc: { aadhaarEnc: SECRET, aadhaarLast: '4321' } },
};
if (!survives(nested)) ok('a value three levels down is redacted');
else bad('nested redaction', 'the value came through');

const inArray = { records: [{ ok: 1 }, { panEnc: SECRET }] };
if (!survives(inArray)) ok('a value inside an array of objects is redacted');
else bad('array redaction', 'the value came through');

const deepArray = { a: [[{ tokenHash: SECRET }]] };
if (!survives(deepArray)) ok('a value in a nested array is redacted');
else bad('nested array redaction', 'the value came through');

hdr('What must survive, because the log is useless without it');
// Redacting these would break the questions the audit trail exists to
// answer, which is its own kind of failure.
const keeps = redactSnapshot({
  code: 'REF-4XY9',
  aadhaarLast: '4321',
  panLast: 'ABCDE',
  // The real column is panLast4, and the referral payout trail writes it.
  // Testing `panLast` alone proved nothing about the name actually used.
  panLast4: '234F',
  // `sa*****@okhdfcbank`. Redacting it would leave no way to tell from the
  // log which address a referrer moved their payouts to, which is the one
  // question that trail exists to answer.
  upiIdMasked: 'sa*****@okhdfcbank',
  roleName: 'Manager',
  status: 'APPROVED',
  reason: 'Marked present on the wrong day',
  addressProofUrl: 'https://fake.supabase.co/storage/v1/object/x.pdf',
  idempotencyKey: 'payout-attempt-7',
}) as Record<string, unknown>;
for (const [key, want] of Object.entries({
  code: 'REF-4XY9',
  aadhaarLast: '4321',
  panLast: 'ABCDE',
  panLast4: '234F',
  upiIdMasked: 'sa*****@okhdfcbank',
  roleName: 'Manager',
  status: 'APPROVED',
  idempotencyKey: 'payout-attempt-7',
})) {
  if (keeps[key] === want) ok(`${key} survives, as it must`);
  else bad(`${key} survives`, `got ${JSON.stringify(keeps[key])}`);
}

hdr('A whole row, spread wholesale — the shape that leaks');
// Modelled on what would happen if a KYC record, a session, or a user were
// ever passed straight into a snapshot instead of a chosen subset.
const kycRow = {
  id: 'fake-id',
  gymId: 'fake-gym',
  aadhaarEnc: SECRET,
  aadhaarLast: '4321',
  panEnc: SECRET,
  panLast: 'ABCDE',
  gstinEnc: SECRET,
  altProofUrl: 'https://fake.supabase.co/storage/v1/object/proof.pdf',
  aadhaarStatus: 'VERIFIED',
};
if (!survives(kycRow)) ok('a whole gym_kyc row leaks nothing');
else bad('kyc row', 'a number came through');

const sessionRow = { id: 'fake', userId: 'fake', tokenHash: SECRET, ip: '1.2.3.4' };
if (!survives(sessionRow)) ok('a whole session row leaks nothing');
else bad('session row', 'the token hash came through');

const otpRow = { id: 'fake', phone: '+919999999999', codeHash: SECRET, salt: SECRET };
if (!survives(otpRow)) ok('a whole otp_challenge row leaks nothing');
else bad('otp row', 'the code hash came through');

// A referral_accounts row carries a payment address and a tax number. The
// service deliberately writes a chosen subset into the audit log rather
// than the row, but this is the shape it would take if anyone ever spread
// it, and the masked handle and last four must still come through.
const referralRow = {
  id: 'fake',
  userId: 'fake',
  code: 'REF-4XY9',
  upiIdEnc: SECRET,
  upiIdMasked: 'sa*****@okhdfcbank',
  upiHolderName: 'Sarthak Sharma',
  upiVerified: true,
  panEnc: SECRET,
  panLast4: '234F',
  panStatus: 'PENDING',
};
if (!survives(referralRow)) ok('a whole referral_accounts row leaks nothing');
else bad('referral row', 'an encrypted value came through');
const referralOut = redactSnapshot(referralRow) as Record<string, unknown>;
if (referralOut.upiIdMasked === 'sa*****@okhdfcbank' && referralOut.panLast4 === '234F') {
  ok('and the masked handle and last four still come through');
} else {
  bad('referral row survivors', JSON.stringify(referralOut));
}

const authPayload = { registrationToken: SECRET, phone: '+919999999999' };
if (!survives(authPayload)) ok('a registration token leaks nothing');
else bad('registration token', 'it came through');

hdr('Limits, and they announce themselves');
// Truncating in silence is how somebody later reads "nothing was here"
// off a log entry that actually means "we stopped looking".
const deep: Record<string, unknown> = {};
let cursor = deep;
for (let i = 0; i < 12; i += 1) {
  const next: Record<string, unknown> = {};
  cursor.child = next;
  cursor = next;
}
cursor.aadhaarEnc = SECRET;
const deepOut = JSON.stringify(redactSnapshot(deep));
if (!deepOut.includes(SECRET)) ok('a value below the depth limit cannot leak');
else bad('depth limit', 'a deeply buried value came through');
if (deepOut.includes('[depth-limit]')) ok('and the cut is marked, not silent');
else bad('depth marker', 'the truncation left no trace');

const long = { items: Array.from({ length: 120 }, (_, i) => i) };
const longOut = redactSnapshot(long) as { items: unknown[] };
if (longOut.items.length <= 51) ok('a long array is capped');
else bad('array cap', `kept ${longOut.items.length}`);
if (String(longOut.items[longOut.items.length - 1]).includes('more')) {
  ok('and says how many it dropped');
} else {
  bad('array cap marker', `last element was ${JSON.stringify(longOut.items[longOut.items.length - 1])}`);
}

hdr('Ordinary values pass through unharmed');
const now = new Date('2026-09-05T10:00:00.000Z');
const plain = redactSnapshot({
  n: 42,
  s: 'hello',
  b: true,
  nul: null,
  when: now,
}) as Record<string, unknown>;
if (plain.n === 42 && plain.s === 'hello' && plain.b === true && plain.nul === null) {
  ok('numbers, strings, booleans and null are untouched');
} else {
  bad('scalars', JSON.stringify(plain));
}
if (plain.when === now.toISOString()) ok('a Date becomes an ISO string, not {}');
else bad('date handling', JSON.stringify(plain.when));

if (redactSnapshot(undefined) === undefined) ok('undefined stays undefined');
else bad('undefined', 'it changed');
if (redactSnapshot(null) === undefined) ok('null becomes undefined, so no column is written');
else bad('null', 'it changed');

process.stdout.write('\n');
if (failures > 0) {
  process.stdout.write(`\x1b[31m${failures} of ${checks} checks FAILED\x1b[0m\n`);
  process.exit(1);
}
process.stdout.write(`\x1b[32mALL ${checks} CHECKS PASSED\x1b[0m\n`);
