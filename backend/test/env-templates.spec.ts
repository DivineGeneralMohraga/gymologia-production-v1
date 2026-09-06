/**
 * The two env templates must not drift apart.
 *
 *   npx ts-node --transpile-only test/env-templates.spec.ts
 *
 * `.env.example` is what a developer copies; `.env.production.example` is
 * what a deployment copies. They describe the same application, so a
 * variable in one and not the other is either a setting production will be
 * missing or one a developer will never know exists.
 *
 * This exists because that drift already happened twice, silently, and
 * both would have been found at the worst possible moment:
 *
 *   - connection_limit was corrected from 1 to 10 in .env and
 *     .env.example after measuring three HTTP 500s in twenty concurrent
 *     requests -- and NOT in the production template, the only one a
 *     deploy actually reads. The fix was applied where the bug was found
 *     rather than where it belonged, so the first deployment would have
 *     reinstated it.
 *   - TEST_ACCOUNT_PHONE/OTP were added for Play Store review and existed
 *     only in the developer template, so the deployed server would have
 *     had no test account and the review would have been rejected for an
 *     app the reviewer could not sign in to.
 *
 * Neither was a hard thing to notice. Both were invisible because nothing
 * looked.
 */
import * as fs from 'node:fs';
import * as path from 'node:path';

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

const root = path.join(__dirname, '..');

function keysOf(file: string): Set<string> {
  const full = path.join(root, file);
  const text = fs.readFileSync(full, 'utf8');
  const keys = new Set<string>();
  for (const line of text.split(/\r?\n/)) {
    const m = /^\s*([A-Z][A-Z0-9_]*)\s*=/.exec(line);
    if (m) keys.add(m[1]);
  }
  return keys;
}

function valueOf(file: string, key: string): string | null {
  const text = fs.readFileSync(path.join(root, file), 'utf8');
  for (const line of text.split(/\r?\n/)) {
    const m = new RegExp(`^\\s*${key}\\s*=\\s*(.*)$`).exec(line);
    if (m) return m[1].trim().replace(/^"|"$/g, '');
  }
  return null;
}

const DEV = '.env.example';
const PROD = '.env.production.example';

hdr('Both templates exist and were read');
// Guarded: every comparison below is trivially true of two empty sets.
let dev: Set<string>;
let prod: Set<string>;
try {
  dev = keysOf(DEV);
  prod = keysOf(PROD);
} catch (e) {
  bad('templates readable', String(e));
  process.exit(1);
}

if (dev.size > 10) ok(`${DEV} has ${dev.size} variables`);
else bad(`${DEV} read`, `only ${dev.size} variables found -- did the parse work?`);

if (prod.size > 10) ok(`${PROD} has ${prod.size} variables`);
else bad(`${PROD} read`, `only ${prod.size} variables found -- did the parse work?`);

hdr('Neither template is missing what the other has');
// A handful of keys are genuinely one-sided, and they are listed rather
// than the check being loosened: an exemption somebody has to type is an
// exemption somebody has to justify.
const DEV_ONLY = new Set<string>([
  'NODE_ENV', // the dev template pins development; production sets its own
]);
const PROD_ONLY = new Set<string>([
  'APP_STAGE', // only meaningful on a deployed box
]);

const missingFromProd = [...dev].filter((k) => !prod.has(k) && !DEV_ONLY.has(k)).sort();
const missingFromDev = [...prod].filter((k) => !dev.has(k) && !PROD_ONLY.has(k)).sort();

if (missingFromProd.length === 0) {
  ok(`every variable in ${DEV} is also in ${PROD}`);
} else {
  bad(
    `${PROD} is missing variables`,
    `${missingFromProd.join(', ')} -- a deployment would not know to set ${
      missingFromProd.length === 1 ? 'it' : 'them'
    }`,
  );
}

if (missingFromDev.length === 0) {
  ok(`every variable in ${PROD} is also in ${DEV}`);
} else {
  bad(`${DEV} is missing variables`, missingFromDev.join(', '));
}

hdr('The pooling settings a long-running server needs');
// Named specifically because getting this wrong is invisible until the
// application is under real load, and the wrong value looks deliberate.
for (const file of [DEV, PROD]) {
  const url = valueOf(file, 'DATABASE_URL') ?? '';
  const limit = /connection_limit=(\d+)/.exec(url);
  if (!limit) {
    bad(`${file} sets connection_limit`, 'the parameter is absent from DATABASE_URL');
  } else if (Number(limit[1]) < 5) {
    bad(
      `${file} connection_limit`,
      `it is ${limit[1]}. That is the serverless value; on a long-running ` +
        `server the whole app shares that many connections.`,
    );
  } else {
    ok(`${file} sets connection_limit=${limit[1]}`);
  }

  if (/pool_timeout=\d+/.test(url)) ok(`${file} sets pool_timeout`);
  else bad(`${file} pool_timeout`, 'absent, so a starved pool waits the default');
}

hdr('No template carries a real secret');
// The decisive test is not "does this look like a placeholder" -- the first
// version of this check asked that, with a pattern matching YOUR_ but not
// `your-`, and reported four live credentials in a committed file that were
// nothing of the sort. A word list guesses. Comparing against the actual
// .env does not.
const SENSITIVE = [
  'SUPABASE_SERVICE_ROLE_KEY',
  'CASHFREE_CLIENT_SECRET',
  'CASHFREE_CLIENT_ID',
  'MSG91_AUTH_KEY',
  'MSG91_WIDGET_ID',
  'ENCRYPTION_KEY',
  'OTP_PEPPER',
  'JWT_ACCESS_SECRET',
  'JWT_REFRESH_SECRET',
  'TEST_ACCOUNT_OTP',
];

const NEWLINE = new RegExp(String.fromCharCode(92) + 'r?' + String.fromCharCode(92) + 'n');
let liveEnv: Record<string, string> | null = null;
try {
  liveEnv = {};
  for (const line of fs.readFileSync(path.join(root, '.env'), 'utf8').split(NEWLINE)) {
    const m = /^\s*([A-Z][A-Z0-9_]*)\s*=\s*(.*)$/.exec(line);
    if (m) liveEnv[m[1]] = m[2].trim().replace(/^"|"$/g, '');
  }
} catch {
  liveEnv = null; // No .env on this machine; the comparison below is skipped.
}

if (liveEnv && Object.keys(liveEnv).length > 0) {
  ok(`read ${Object.keys(liveEnv).length} live values to compare against`);
  for (const file of [DEV, PROD]) {
    const leaked = SENSITIVE.filter((k) => {
      const t = valueOf(file, k);
      const real = liveEnv?.[k];
      return t !== null && t !== '' && real !== undefined && real !== '' && t === real;
    });
    if (leaked.length === 0) ok(`${file} contains no value that matches a live secret`);
    else bad(`${file} LEAKS A CREDENTIAL`, `${leaked.join(', ')} matches .env exactly`);
  }
} else {
  // Said out loud rather than passing quietly: without .env there is
  // nothing to compare against and this section proved nothing.
  bad('live comparison', 'no .env on this machine, so nothing was compared');
}

// A weaker second opinion, for a machine with no .env to compare against.
//
// Phrased as "does this look like a real secret" rather than "is this a
// known placeholder word". The word-list version failed twice running --
// first not recognising `your-`, then not recognising `generate-` -- which
// is the nature of word lists. Every miss is a false alarm about a leaked
// credential, and false alarms about leaked credentials are how people
// learn to ignore them.
//
// A generated secret is a contiguous run of base64 or hex with no hyphens
// or spaces. A placeholder is words a human wrote, and humans separate
// words. That distinction needs no vocabulary.
for (const file of [DEV, PROD]) {
  const suspicious = SENSITIVE.filter((k) => {
    const v = valueOf(file, k);
    if (v === null || v === '') return false;
    return v.length >= 20 && /^[A-Za-z0-9_+/=.]+$/.test(v);
  });
  if (suspicious.length === 0) {
    ok(`${file} holds nothing shaped like a generated secret`);
  } else {
    bad(`${file} has a value shaped like a real secret`, suspicious.join(', '));
  }
}


process.stdout.write(`\n${checks} checks, ${failures} failed\n`);
if (failures > 0) {
  process.stdout.write('\x1b[31mSOME CHECKS FAILED\x1b[0m\n');
  process.exit(1);
}
process.stdout.write('\x1b[32mALL CHECKS PASSED\x1b[0m\n');
