/**
 * Format checks for Aadhaar, PAN and GSTIN.
 *
 *   npx ts-node --transpile-only test/india-ids.spec.ts
 *
 * The Aadhaar cases are the point. A length check accepts a transposed
 * pair of digits and the owner finds out days later, from a rejection they
 * cannot interpret. The Verhoeff check digit catches it while they are
 * still looking at the field.
 *
 * The numbers below are constructed to satisfy the format, not taken from
 * anybody's document.
 */
import { isAadhaar, isGstin, isPan, panInGstin } from '../src/common/validation/india-ids';

type Case = [string, unknown, boolean];

function run(label: string, check: (v: unknown) => boolean, cases: Case[]): number {
  process.stdout.write(`\n${label}\n`);
  let bad = 0;
  for (const [what, value, want] of cases) {
    const got = check(value);
    const ok = got === want;
    if (!ok) bad += 1;
    process.stdout.write(
      `  ${ok ? 'PASS' : 'FAIL'}  ${want ? 'accepts' : 'refuses'} ${what}\n`,
    );
  }
  return bad;
}

// The check digit here was computed with the Verhoeff generator, not
// guessed -- the first draft of this file guessed one, and every "accepts"
// case failed until the digit was worked out properly. Constructed from a
// sequential body so it is plainly not anybody's document.
const VALID = '234567890124';

let failures = run('Aadhaar', isAadhaar, [
  ['a number with a correct check digit', VALID, true],
  ['the same number spaced', '2345 6789 0124', true],
  ['the same number hyphenated', '2345-6789-0124', true],
  ['a wrong check digit', '234567890125', false],
  ['an adjacent pair transposed, which is what Verhoeff is for',
   '234576890124', false],
  ['eleven digits', '23456789012', false],
  ['thirteen digits', '2345678901244', false],
  ['a number starting 0, which is reserved', '034567890124', false],
  ['a number starting 1, which is reserved', '134567890124', false],
  ['letters', 'abcdefghijkl', false],
  ['an empty string', '', false],
  ['a non-string', 234567890124, false],
]);

failures += run('PAN', isPan, [
  ['a well-formed PAN', 'ABCDE1234F', true],
  ['lowercase, which is normalised before this', 'abcde1234f', true],
  ['digits where letters belong', '123451234F', false],
  ['a missing trailing letter', 'ABCDE1234', false],
  ['one character too many', 'ABCDE1234FG', false],
  ['an empty string', '', false],
]);

failures += run('GSTIN', isGstin, [
  ['a well-formed GSTIN', '27ABCDE1234F1Z5', true],
  ['no Z in the fourteenth position', '27ABCDE1234F1X5', false],
  ['too short', '27ABCDE1234F1Z', false],
  ['a PAN on its own', 'ABCDE1234F', false],
]);

process.stdout.write('\nThe PAN inside a GSTIN\n');
const embedded = panInGstin('27ABCDE1234F1Z5');
const ok = embedded === 'ABCDE1234F';
if (!ok) failures += 1;
process.stdout.write(
  `  ${ok ? 'PASS' : 'FAIL'}  is extracted for cross-checking (${embedded})\n`,
);

process.stdout.write(failures ? `\n${failures} FAILED\n` : '\nall cases pass\n');
process.exit(failures ? 1 : 0);
