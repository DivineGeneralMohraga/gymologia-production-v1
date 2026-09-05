/**
 * The boot-time configuration gate.
 *
 *   npx ts-node --transpile-only test/env-validation.spec.ts
 *
 * This function is the only thing standing between a half-configured
 * deployment and a live one. It decides whether a server that cannot
 * verify a payment webhook, or that is pointed at a sandbox payment
 * gateway while calling itself production, is allowed to start at all --
 * and until now nothing checked it. It is a pure function, so there was
 * never a good reason for that.
 *
 * The cases that matter most are the ones where it must REFUSE. A gate
 * that lets everything through looks identical to a correct one on the
 * happy path, and the difference only shows up on the day it was supposed
 * to save you.
 *
 * Every value below is obviously fake.
 */
import { resolveStage, validateEnv } from '../src/config/env.validation';

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

/** A configuration with everything filled in, as a starting point. */
function completeEnv(): Record<string, unknown> {
  return {
    NODE_ENV: 'production',
    APP_STAGE: 'production',
    DATABASE_URL: 'postgresql://user:pw@db.example.com:5432/postgres',
    DIRECT_URL: 'postgresql://user:pw@db.example.com:5432/postgres',
    JWT_ACCESS_SECRET: 'x'.repeat(48),
    JWT_REFRESH_SECRET: 'y'.repeat(48),
    ENCRYPTION_KEY: 'ab'.repeat(32), // 64 hex characters
    OTP_PEPPER: 'z'.repeat(40),
    MSG91_AUTH_KEY: 'fake-msg91-key',
    MSG91_WIDGET_ID: 'fake-widget-id',
    CASHFREE_ENV: 'production',
    CASHFREE_CLIENT_ID: 'fake-client-id',
    CASHFREE_CLIENT_SECRET: 'fake-client-secret',
    CASHFREE_WEBHOOK_SECRET: 'fake-webhook-secret',
    CASHFREE_PAYOUT_CLIENT_ID: 'fake-payout-id',
    CASHFREE_PAYOUT_CLIENT_SECRET: 'fake-payout-secret',
    SUPABASE_URL: 'https://fake.supabase.co',
    SUPABASE_SERVICE_ROLE_KEY: 'fake-service-role-key',
  };
}

/** Assert that validateEnv rejects, and that it says which key. */
function refuses(what: string, env: Record<string, unknown>, mentioning: string) {
  try {
    validateEnv(env);
    bad(what, 'it was ACCEPTED');
  } catch (error) {
    const message = (error as Error).message;
    if (message.includes(mentioning)) ok(what);
    else bad(what, `refused, but never mentioned ${mentioning}: ${message}`);
  }
}

function accepts(what: string, env: Record<string, unknown>) {
  try {
    validateEnv(env);
    ok(what);
  } catch (error) {
    bad(what, `refused: ${(error as Error).message}`);
  }
}

hdr('Which stage are we in');
// Fail closed: production unless something explicitly says otherwise, so a
// forgotten APP_STAGE errs towards the stricter rules rather than the
// looser ones.
const stage = (raw: Record<string, unknown>) => resolveStage(raw);
const stageIs = (what: string, raw: Record<string, unknown>, want: string) => {
  const got = stage(raw);
  if (got === want) ok(what);
  else bad(what, `got ${got}, wanted ${want}`);
};
stageIs('NODE_ENV=production alone means production', { NODE_ENV: 'production' }, 'production');
stageIs('APP_STAGE=staging opts a production build out', { NODE_ENV: 'production', APP_STAGE: 'staging' }, 'staging');
stageIs('APP_STAGE=production forces the strict rules', { NODE_ENV: 'development', APP_STAGE: 'production' }, 'production');
stageIs('a laptop with neither set is staging', {}, 'staging');
stageIs('an unrecognised APP_STAGE falls back to NODE_ENV', { NODE_ENV: 'production', APP_STAGE: 'prod' }, 'production');

hdr('A complete configuration');
accepts('a fully populated production environment starts', completeEnv());

hdr('Keys required everywhere');
for (const key of [
  'DATABASE_URL',
  'DIRECT_URL',
  'JWT_ACCESS_SECRET',
  'JWT_REFRESH_SECRET',
  'ENCRYPTION_KEY',
  'OTP_PEPPER',
  'MSG91_AUTH_KEY',
  'MSG91_WIDGET_ID',
  'CASHFREE_CLIENT_ID',
  'CASHFREE_CLIENT_SECRET',
]) {
  const env = completeEnv();
  delete env[key];
  refuses(`missing ${key} refuses to boot`, env, key);
}

hdr('An empty string is missing, not present');
// This is the case that actually happens. A .env file with `KEY=` and
// nothing after it reads as an empty string, not as absent, and a check
// written against undefined alone would wave it through -- which is
// exactly the shape of the file this project has today.
for (const key of ['JWT_ACCESS_SECRET', 'CASHFREE_CLIENT_SECRET']) {
  const env = completeEnv();
  env[key] = '';
  refuses(`${key}= (empty) is treated as missing`, env, key);
}
const spaces = completeEnv();
spaces.MSG91_AUTH_KEY = '   ';
refuses('whitespace only is treated as missing', spaces, 'MSG91_AUTH_KEY');

hdr('Keys required only in production');
for (const key of [
  'CASHFREE_WEBHOOK_SECRET',
  'CASHFREE_PAYOUT_CLIENT_ID',
  'CASHFREE_PAYOUT_CLIENT_SECRET',
  'SUPABASE_URL',
  'SUPABASE_SERVICE_ROLE_KEY',
]) {
  const prod = completeEnv();
  delete prod[key];
  refuses(`production refuses to start without ${key}`, prod, key);

  const staging = completeEnv();
  staging.APP_STAGE = 'staging';
  staging.CASHFREE_ENV = 'sandbox';
  delete staging[key];
  accepts(`staging starts without ${key}`, staging);
}

hdr('Shapes, not just presence');
const shortAccess = completeEnv();
shortAccess.JWT_ACCESS_SECRET = 'too-short';
refuses('a short JWT secret is refused', shortAccess, 'JWT_ACCESS_SECRET');

const shortPepper = completeEnv();
shortPepper.OTP_PEPPER = 'short';
refuses('a short OTP pepper is refused', shortPepper, 'OTP_PEPPER');

for (const bogus of ['not-hex-at-all', 'ab'.repeat(16), 'zz'.repeat(32)]) {
  const env = completeEnv();
  env.ENCRYPTION_KEY = bogus;
  refuses(
    `an encryption key that is not 32 bytes of hex is refused (${bogus.slice(0, 12)}…)`,
    env,
    'ENCRYPTION_KEY',
  );
}

const mysql = completeEnv();
mysql.DATABASE_URL = 'mysql://user:pw@host/db';
refuses('a non-postgres DATABASE_URL is refused', mysql, 'DATABASE_URL');

accepts('postgres:// is accepted as well as postgresql://', {
  ...completeEnv(),
  DATABASE_URL: 'postgres://user:pw@db.example.com:5432/postgres',
});

hdr('The two mistakes that hurt most in production');
// Taking real money against a sandbox gateway, and a production server
// quietly talking to a database on the box it is running on.
const sandboxInProd = completeEnv();
sandboxInProd.CASHFREE_ENV = 'sandbox';
refuses('sandbox payments at production stage are refused', sandboxInProd, 'CASHFREE_ENV');

for (const host of ['localhost', '127.0.0.1']) {
  const env = completeEnv();
  env.DATABASE_URL = `postgresql://user:pw@${host}:5432/postgres`;
  refuses(`a ${host} database in production is refused`, env, 'localhost');
}

// ...and neither rule fires on a staging box, which is the whole point of
// having a stage separate from NODE_ENV.
const stagingSandbox = completeEnv();
stagingSandbox.APP_STAGE = 'staging';
stagingSandbox.CASHFREE_ENV = 'sandbox';
stagingSandbox.DATABASE_URL = 'postgresql://user:pw@localhost:5432/postgres';
accepts('a staging box may use sandbox payments and a local database', stagingSandbox);

hdr('It names everything wrong at once');
// One boot, one list. Being told about a missing key, fixing it, and then
// being told about the next one is a miserable way to configure a server.
const broken = completeEnv();
delete broken.JWT_ACCESS_SECRET;
delete broken.MSG91_AUTH_KEY;
broken.ENCRYPTION_KEY = 'nope';
try {
  validateEnv(broken);
  bad('three problems are reported together', 'it was accepted');
} catch (error) {
  const m = (error as Error).message;
  const named = ['JWT_ACCESS_SECRET', 'MSG91_AUTH_KEY', 'ENCRYPTION_KEY'].filter((k) =>
    m.includes(k),
  );
  if (named.length === 3) ok('three problems are reported together, not one at a time');
  else bad('three problems are reported together', `only named ${named.join(', ')}`);
}

process.stdout.write('\n');
if (failures > 0) {
  process.stdout.write(`\x1b[31m${failures} of ${checks} checks FAILED\x1b[0m\n`);
  process.exit(1);
}
process.stdout.write(`\x1b[32mALL ${checks} CHECKS PASSED\x1b[0m\n`);
