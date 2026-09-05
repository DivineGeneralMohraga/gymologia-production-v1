/**
 * What counts as a UPI address, and -- more importantly -- what does not.
 *
 *   npx ts-node --transpile-only test/upi-vpa.spec.ts
 *
 * This check is weighted differently from `india-ids.spec.ts`, and the
 * reason is worth stating. Aadhaar has a Verhoeff check digit, so a strict
 * rule there costs nothing: it never rejects a real number. A VPA has no
 * checksum whatsoever. `sarthaq@okhdfcbank` is as well-formed as
 * `sarthak@okhdfcbank` and belongs to a different person, and a UPI
 * transfer is irreversible.
 *
 * So the format rule cannot be the thing that protects the money -- the
 * verification drop before the first payout is -- and the expensive
 * mistake here is the opposite one: rejecting a real address, which leaves
 * a referrer unable to be paid at all with nothing they can do about it.
 * That is why the accepting cases below outnumber the refusing ones, which
 * is the reverse of every other validator in this project.
 *
 * The two-character identifier case is not hypothetical padding. The first
 * version of this regex used `{1,48}` for the middle run, which meant
 * one-character and three-character identifiers passed and two-character
 * ones did not -- a real address, refused, for no reason anybody could
 * have guessed from the error message.
 */
import { isUpiVpa, normaliseVpa } from '../src/common/validation/upi-vpa';

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

function accepts(vpa: string, why: string) {
  if (isUpiVpa(vpa)) ok(`accepts ${JSON.stringify(vpa)} -- ${why}`);
  else bad(`accepts ${JSON.stringify(vpa)}`, `refused, but ${why}`);
}
function refuses(vpa: unknown, why: string) {
  if (!isUpiVpa(vpa)) ok(`refuses ${JSON.stringify(vpa)} -- ${why}`);
  else bad(`refuses ${JSON.stringify(vpa)}`, `accepted, but ${why}`);
}

hdr('Real addresses must not be refused');
accepts('sarthak@okhdfcbank', 'an ordinary Google Pay HDFC handle');
accepts('a@ybl', 'a one-character identifier is legal');
accepts('ab@axl', 'and so is a two-character one');
accepts('9876543210@paytm', 'a phone number is a common identifier');
accepts('9876543210@upi', 'the generic handle');
accepts('first.last@oksbi', 'dots are allowed inside the identifier');
accepts('first-last@okaxis', 'so are hyphens');
accepts('first_last@okicici', 'and underscores');
accepts('user123@jupiteraxis', 'digits in both halves');
accepts('x'.repeat(50) + '@ybl', 'a 50-character identifier is within bounds');

hdr('Case and whitespace are not significant');
accepts('Sarthak@OKHDFCBANK', 'a VPA is case-insensitive');
accepts('  sarthak@ybl  ', 'surrounding whitespace is trimmed');
if (normaliseVpa('  Sarthak@YBL ') === 'sarthak@ybl') {
  ok('normaliseVpa lowercases and trims');
} else {
  bad('normaliseVpa', `got ${JSON.stringify(normaliseVpa('  Sarthak@YBL '))}`);
}
// Storage uses the normalised form, so two spellings of one address must
// not become two different stored values.
if (normaliseVpa('SARTHAK@YBL') === normaliseVpa('sarthak@ybl')) {
  ok('two spellings of one address normalise to the same string');
} else {
  bad('normalisation', 'the same address normalised two ways');
}

hdr('Shapes that could not be an address');
refuses('sarthak', 'there is no handle at all');
refuses('sarthak@', 'the handle is empty');
refuses('@okhdfcbank', 'the identifier is empty');
refuses('@', 'both halves empty');
refuses('', 'empty string');
refuses('a@b@ybl', 'two @ is not an address, and a looser rule would take it');
refuses('sarthak@ybl@', 'a trailing @');
refuses('sarthak@y', 'a one-character handle -- no PSP is one letter');
refuses('sar thak@ybl', 'a space inside the identifier');
refuses('sarthak@ok bank', 'a space inside the handle');
refuses('.sarthak@ybl', 'a leading dot');
refuses('sarthak.@ybl', 'a trailing dot');
refuses('-sarthak@ybl', 'a leading hyphen');
refuses('sarthak@ok.bank', 'a dot in the handle -- NPCI handles have none');
refuses('sarthak@ok-bank', 'a hyphen in the handle');
refuses('x'.repeat(51) + '@ybl', 'an identifier past the 50-character bound');

hdr('Types and injection shapes');
refuses(undefined, 'undefined is not a string');
refuses(null, 'null is not a string');
refuses(12345, 'a number is not a string');
refuses({}, 'an object is not a string');
refuses([], 'an array is not a string');
refuses("sarthak'--@ybl", 'a quote and a SQL comment');
refuses('sarthak@ybl; DROP TABLE users', 'a statement terminator');
refuses('<script>alert(1)</script>@ybl', 'markup');
refuses('sarthak@ybl\nBcc: someone@else', 'a newline, which is header injection');
// Built at runtime rather than as a literal: a raw NUL byte in the source
// makes git treat this whole file as binary and stop showing diffs.
refuses('sarthak' + String.fromCharCode(0) + '@ybl', 'an embedded NUL');

hdr('The pattern does not blow up on hostile input');
// A bounded pattern with no nested unbounded quantifiers should not
// backtrack catastrophically. Measured rather than argued.
const started = Date.now();
for (let i = 0; i < 200; i += 1) {
  isUpiVpa('a'.repeat(2000) + '!'.repeat(2000));
  isUpiVpa('a.'.repeat(1000) + '@');
}
const elapsed = Date.now() - started;
if (elapsed < 1000) ok(`400 pathological inputs matched in ${elapsed}ms`);
else bad('ReDoS', `400 pathological inputs took ${elapsed}ms`);

process.stdout.write(`\n${checks} checks, ${failures} failed\n`);
if (failures > 0) {
  process.stdout.write('\x1b[31mSOME CHECKS FAILED\x1b[0m\n');
  process.exit(1);
}
process.stdout.write('\x1b[32mALL CHECKS PASSED\x1b[0m\n');
