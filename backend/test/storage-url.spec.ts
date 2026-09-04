/**
 * What the storage-URL constraint accepts and refuses.
 *
 *   npx ts-node --transpile-only test/storage-url.spec.ts
 *
 * Not a jest file: there is no unit-test runner wired up here, and the
 * project's convention is a script that prints PASS/FAIL and exits
 * non-zero. Kept next to the shell suites for the same reason.
 *
 * The cases that matter are the refusals. `@IsUrl()` accepted every one of
 * them, and each is a URL that other people's devices would then fetch.
 */
import {
  isStorageUrl,
  resetStorageHostCache,
} from '../src/common/validation/storage-url';

type Case = [string, unknown, boolean];

function run(label: string, cases: Case[]): number {
  process.stdout.write(`\n${label}\n`);
  let bad = 0;
  for (const [what, value, want] of cases) {
    const got = isStorageUrl(value);
    const ok = got === want;
    if (!ok) bad += 1;
    process.stdout.write(
      `  ${ok ? 'PASS' : 'FAIL'}  ${want ? 'accepts' : 'refuses'} ${what}` +
        `${ok ? '' : `  (got ${got})`}\n`,
    );
  }
  return bad;
}

const HOST = 'https://myproject.supabase.co';
const GOOD = `${HOST}/storage/v1/object/public/gym-images/a.png`;

process.env.SUPABASE_URL = HOST;
resetStorageHostCache();

let failures = run('With SUPABASE_URL configured', [
  ['our own storage URL', GOOD, true],
  ['a private object path', `${HOST}/storage/v1/object/sign/kyc/x.pdf`, true],
  ['another project entirely', 'https://other.supabase.co/storage/v1/object/public/a.png', false],
  ['an arbitrary host', 'https://attacker.example/tracker.png', false],
  ['plain http on our own host', GOOD.replace('https:', 'http:'), false],
  ['the cloud metadata address', 'http://169.254.169.254/latest/meta-data/', false],
  ['credentials disguising the host', `https://myproject.supabase.co@evil.test/storage/v1/object/a.png`, false],
  ['our host but not a storage path', `${HOST}/rest/v1/gyms`, false],
  ['a path traversal outside storage', `${HOST}/storage/../rest/v1/gyms`, false],
  ['something that is not a URL', 'not a url', false],
  ['a non-string', 42, false],
  ['null', null, false],
  ['a URL longer than the column', `${HOST}/storage/v1/object/public/${'a'.repeat(600)}`, false],
]);

// The URLs the upload service actually mints have to survive the check
// that guards the field they are submitted into. These two shapes are what
// StorageService.signUpload returns for a public and a private bucket; if
// the two ever drift apart, an owner uploads a file successfully and is
// then told the URL is invalid.
failures += run('URLs the upload service produces', [
  ['a public gym image', `${HOST}/storage/v1/object/public/gym-images/a-gym-id/f47ac10b.jpg`, true],
  ['a public event banner', `${HOST}/storage/v1/object/public/event-banners/a-gym-id/f47ac10b.webp`, true],
  ['a private KYC document', `${HOST}/storage/v1/object/kyc-documents/a-gym-id/f47ac10b.pdf`, true],
  ['a signed read of a KYC document', `${HOST}/storage/v1/object/sign/kyc-documents/a-gym-id/f47ac10b.pdf?token=abc`, true],
]);

// A developer machine with nothing configured must still refuse hostile
// hosts. Failing open here is how a bad URL reaches a fixture.
delete process.env.SUPABASE_URL;
resetStorageHostCache();

failures += run('With SUPABASE_URL unset (developer machine)', [
  ['any Supabase project', GOOD, true],
  ['an arbitrary host', 'https://attacker.example/x.png', false],
  ['a lookalike host', 'https://supabase.co.evil.test/storage/v1/object/a.png', false],
]);

process.stdout.write(
  failures ? `\n${failures} FAILED\n` : '\nall cases pass\n',
);
process.exit(failures ? 1 : 0);
