/**
 * Who gets blocked, who never does, and for how long.
 *
 *   npx ts-node --transpile-only test/ip-block.spec.ts
 *
 * The exemption cases carry the most weight here. A blocking rule that is
 * slightly too slow lets an attacker send a few more requests; one that
 * blocks the wrong address takes a paying gym offline, or -- during a test
 * run against localhost -- locks the developer out of their own server
 * with no obvious cause. So the tests below spend most of their length on
 * what must *never* be blocked.
 */
import {
  BLOCK_RULES,
  decide,
  isExempt,
  ruleFor,
} from '../src/common/security/ip-block.policy';
import { IpBlockService } from '../src/common/security/ip-block.service';

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
function is(what: string, got: unknown, want: unknown) {
  if (got === want) ok(what);
  else bad(what, `got ${JSON.stringify(got)}, wanted ${JSON.stringify(want)}`);
}
function hdr(what: string) {
  process.stdout.write(`\n\x1b[1m${what}\x1b[0m\n`);
}

hdr('Addresses that must never be blocked');
for (const ip of [
  '127.0.0.1',
  '::1',
  '::ffff:127.0.0.1',
  '10.0.0.7',
  '192.168.1.20',
  '172.16.0.1',
  '172.31.255.254',
  '169.254.10.1',
  'fd00::1',
  'fe80::1',
]) {
  is(`${ip} is exempt`, isExempt(ip), true);
}
is('an empty address is exempt', isExempt(''), true);
is('a null address is exempt', isExempt(null), true);
is('an undefined address is exempt', isExempt(undefined), true);
is('"unknown" is exempt', isExempt('unknown'), true);

hdr('Addresses that are blockable');
// 172.15 and 172.32 sit just outside the private range and must not be
// swept up by a sloppy prefix match on "172.".
for (const ip of ['203.0.113.7', '8.8.8.8', '172.15.0.1', '172.32.0.1', '1.2.3.4']) {
  is(`${ip} is not exempt`, isExempt(ip), false);
}

hdr('Which signals carry a rule at all');
for (const type of ['INJECTION_ATTEMPT', 'BRUTE_FORCE', 'OTP_ABUSE', 'INVALID_TOKEN'] as const) {
  is(`${type} has a rule`, ruleFor(type) !== undefined, true);
}
// Blocking on these would punish the wrong person; see the policy file.
for (const type of [
  'PERMISSION_DENIED',
  'WEBHOOK_SIGNATURE_INVALID',
  'RATE_LIMIT_TRIPPED',
  'ANOMALOUS_LOGIN',
  'PAYOUT_VELOCITY',
] as const) {
  is(`${type} deliberately has no rule`, ruleFor(type) === undefined, true);
}

hdr('The threshold is a floor, not a fence');
const inj = ruleFor('INJECTION_ATTEMPT')!;
is('one short of the threshold does not block', decide('INJECTION_ATTEMPT', inj.threshold - 1), null);
is(
  'exactly the threshold blocks',
  decide('INJECTION_ATTEMPT', inj.threshold)?.blockMinutes,
  inj.blockMinutes,
);
is(
  'well over the threshold still blocks',
  decide('INJECTION_ATTEMPT', inj.threshold * 10)?.blockMinutes,
  inj.blockMinutes,
);
is('a type with no rule never blocks', decide('PERMISSION_DENIED', 10_000), null);

hdr('Thresholds are set high enough for shared addresses');
// Carrier-grade NAT means one public address can carry a whole town. These
// assertions are a tripwire on the numbers themselves: lowering one below
// what ordinary use produces should fail here and make somebody argue for
// it, rather than quietly locking out a city.
const otp = ruleFor('OTP_ABUSE')!;
is('OTP abuse needs at least 20 events', otp.threshold >= 20, true);
is('an OTP block lasts under an hour', otp.blockMinutes <= 60, true);
const tok = ruleFor('INVALID_TOKEN')!;
is('invalid tokens need at least 30 events', tok.threshold >= 30, true);
for (const rule of BLOCK_RULES) {
  is(`${rule.type} blocks for a bounded time`, rule.blockMinutes > 0 && rule.blockMinutes <= 60, true);
  is(`${rule.type} explains itself`, rule.because.length > 20, true);
}

hdr('The registry');
const svc = new IpBlockService();
const VICTIM = '203.0.113.99';

is('an unknown address is not blocked', svc.retryAfterMs(VICTIM), 0);

svc.block(VICTIM, 15, 'test');
const left = svc.retryAfterMs(VICTIM);
is('a blocked address reports time remaining', left > 0 && left <= 15 * 60_000, true);
is('the block appears in the active list', svc.active().some((e) => e.ip === VICTIM), true);

// Extending must never shorten: a second offence during a long block
// should not reset the clock downwards.
svc.block(VICTIM, 1, 'a shorter second offence');
is('a shorter block does not shorten an existing one', svc.retryAfterMs(VICTIM) > 60_000, true);
svc.block(VICTIM, 30, 'a longer second offence');
is('a longer block extends it', svc.retryAfterMs(VICTIM) > 15 * 60_000, true);

is('an operator can lift a block', svc.unblock(VICTIM), true);
is('and it is gone', svc.retryAfterMs(VICTIM), 0);
is('lifting a block that is not there says so', svc.unblock(VICTIM), false);

hdr('One log entry per block, not one per evaluation');
// This is the contract that stops a burst of probes writing several
// IP_BLOCKED rows for a single block. Recording an event is
// fire-and-forget, so concurrent evaluations can all count after every row
// has landed and all reach the same correct verdict; only the first of
// them started the block, and only that one should be logged. Caught by
// running it, not by reading it -- five probes produced three rows.
const dup = new IpBlockService();
const BURST = '203.0.113.55';
is('the first block reports that it is new', dup.block(BURST, 15, 'first'), true);
is('a concurrent second verdict does not', dup.block(BURST, 15, 'same again'), false);
is('nor does one that extends it', dup.block(BURST, 45, 'longer'), false);
is('but the extension did take effect', dup.retryAfterMs(BURST) > 30 * 60_000, true);
dup.unblock(BURST);
is('after the block lifts, a new one is new again', dup.block(BURST, 5, 'later'), true);
is('blocking an exempt address is never new', dup.block('127.0.0.1', 5, 'nope'), false);

// The whole point of the exemption list is that it holds even when the
// blocking path is called directly.
svc.block('127.0.0.1', 60, 'should be refused');
is('blocking loopback does nothing', svc.retryAfterMs('127.0.0.1'), 0);
svc.block('10.1.2.3', 60, 'should be refused');
is('blocking a private address does nothing', svc.retryAfterMs('10.1.2.3'), 0);

hdr('Blocks expire');
const quick = new IpBlockService();
// A negative duration is the cheapest way to land an already-expired entry
// without making the test sleep.
quick.block('198.51.100.4', -1, 'already over');
is('an expired block does not hold', quick.retryAfterMs('198.51.100.4'), 0);

process.stdout.write('\n');
if (failures > 0) {
  process.stdout.write(`\x1b[31m${failures} of ${checks} checks FAILED\x1b[0m\n`);
  process.exit(1);
}
process.stdout.write(`\x1b[32mALL ${checks} CHECKS PASSED\x1b[0m\n`);
