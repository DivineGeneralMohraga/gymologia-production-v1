/**
 * What gets retried when the database blinks, and -- more importantly --
 * what does not.
 *
 *   npx ts-node --transpile-only test/retry.spec.ts
 *
 * The weight here is on the refusals. A retry that fires too rarely costs
 * one failed request; a retry that fires on the wrong error can run a write
 * twice. So the cases below spend most of their length proving that
 * anything which is not provably a connection failure is re-thrown
 * untouched, and that an ambiguous failure -- the connection dropped, the
 * statement may or may not have run -- is only repeated when the caller has
 * said the operation is safe to repeat.
 *
 * No database is touched: PrismaClient does not connect until $connect().
 */
import { Prisma } from '@prisma/client';
import { PrismaService } from '../src/prisma/prisma.service';
import {
  httpForPrisma,
  isTransientDbError,
  prismaErrorCode,
} from '../src/common/filters/prisma-http';

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

const prisma = new PrismaService();

/** Silence the retry warnings; the assertions are the output that matters. */
// eslint-disable-next-line @typescript-eslint/no-explicit-any
(prisma as any).logger = { warn: () => {}, log: () => {}, error: () => {}, debug: () => {} };

function dbError(code: string): Error {
  return new Prisma.PrismaClientKnownRequestError(`simulated ${code}`, {
    code,
    clientVersion: 'test',
  });
}

/** Fails `times` times with `code`, then succeeds. Counts its own calls. */
function flaky(code: string, times: number) {
  let calls = 0;
  const fn = async () => {
    calls += 1;
    if (calls <= times) throw dbError(code);
    return 'ok';
  };
  return { fn, calls: () => calls };
}

async function main() {
  hdr('A connection failure is repeated');

  for (const code of ['P1001', 'P1002', 'P2024']) {
    const f = flaky(code, 1);
    const got = await prisma.withRetry(`t-${code}`, f.fn);
    if (got === 'ok' && f.calls() === 2) {
      ok(`${code} is retried and succeeds on the second attempt`);
    } else {
      bad(`${code} retried`, `result ${got} after ${f.calls()} call(s)`);
    }
  }

  const twice = flaky('P1001', 2);
  const got = await prisma.withRetry('t-twice', twice.fn);
  if (got === 'ok' && twice.calls() === 3) ok('it will try three times in total');
  else bad('three attempts', `after ${twice.calls()} call(s)`);

  hdr('And given up on, rather than retried forever');
  const never = flaky('P1001', 99);
  try {
    await prisma.withRetry('t-never', never.fn);
    bad('gives up', 'it returned instead of throwing');
  } catch (e) {
    const code = e instanceof Prisma.PrismaClientKnownRequestError ? e.code : '?';
    if (never.calls() === 3 && code === 'P1001') {
      ok('after three attempts the original error is re-thrown, not a wrapper');
    } else {
      bad('gives up', `${never.calls()} call(s), code ${code}`);
    }
  }

  hdr('Errors that are NOT connection failures are never repeated');
  // These are the expensive mistakes: P2002 means the row already exists,
  // and retrying it neither helps nor is meaningful. Anything not proven
  // to be a connection failure must reach the caller untouched.
  for (const code of ['P2002', 'P2003', 'P2025', 'P2014']) {
    const f = flaky(code, 1);
    try {
      await prisma.withRetry(`t-${code}`, f.fn);
      bad(`${code} not retried`, 'the call succeeded, so it was repeated');
    } catch {
      if (f.calls() === 1) ok(`${code} is thrown straight through, tried once`);
      else bad(`${code} not retried`, `called ${f.calls()} times`);
    }
  }

  const plain = flaky('', 1);
  const boom = async () => {
    plain.calls();
    throw new Error('something entirely else');
  };
  try {
    await prisma.withRetry('t-plain', boom);
    bad('non-Prisma error', 'it succeeded');
  } catch (e) {
    if (e instanceof Error && e.message === 'something entirely else') {
      ok('an ordinary error is not treated as a connection failure');
    } else {
      bad('non-Prisma error', String(e));
    }
  }

  hdr('An ambiguous drop is only repeated when the caller says it is safe');
  // P1017 means the server closed the connection: the statement may have
  // run. Repeating a write on that could double it, so the default refuses.
  const unsafe = flaky('P1017', 1);
  try {
    await prisma.withRetry('t-p1017-default', unsafe.fn);
    bad('P1017 default', 'it retried a possibly-executed statement');
  } catch {
    if (unsafe.calls() === 1) ok('P1017 is NOT retried by default');
    else bad('P1017 default', `called ${unsafe.calls()} times`);
  }

  const safe = flaky('P1017', 1);
  const r = await prisma.withRetry('t-p1017-safe', safe.fn, { safeToRepeat: true });
  if (r === 'ok' && safe.calls() === 2) ok('P1017 IS retried when marked safe to repeat');
  else bad('P1017 safe', `result ${r} after ${safe.calls()} call(s)`);

  // The default being the conservative one is the point: the careless call
  // site gets the safe behaviour.
  const dflt = flaky('P1017', 1);
  try {
    await prisma.withRetry('t-p1017-omitted', dflt.fn, {});
    bad('conservative default', 'omitting the option retried it');
  } catch {
    ok('omitting the option gives the conservative behaviour, not the loose one');
  }

  hdr('The happy path is not slowed down');
  const started = Date.now();
  let calls = 0;
  const fast = await prisma.withRetry('t-fast', async () => {
    calls += 1;
    return 'straight through';
  });
  const elapsed = Date.now() - started;
  if (fast === 'straight through' && calls === 1 && elapsed < 50) {
    ok(`a call that works is not delayed (${elapsed}ms, one call)`);
  } else {
    bad('happy path', `${elapsed}ms, ${calls} call(s)`);
  }

  hdr('Retries are counted, so an operator can see them');
  const before = prisma.transientRetries;
  const counted = flaky('P1001', 1);
  await prisma.withRetry('t-count', counted.fn);
  if (prisma.transientRetries === before + 1) {
    ok(`the retry counter went from ${before} to ${prisma.transientRetries}`);
  } else {
    bad('counter', `${before} then ${prisma.transientRetries}`);
  }

  hdr('Backoff grows, and stays inside a request budget');
  // Deliberately short: this covers the sub-second transient. It does not
  // try to ride out a multi-minute outage, because holding an HTTP request
  // open that long ties up a connection and makes the outage worse.
  const t0 = Date.now();
  const slow = flaky('P1001', 2);
  await prisma.withRetry('t-budget', slow.fn);
  const total = Date.now() - t0;
  if (total >= 200 && total < 2000) {
    ok(`two retries cost ${total}ms -- backed off, and inside a request budget`);
  } else {
    bad('backoff budget', `${total}ms`);
  }

  hdr('What the caller is told when the database is gone');
  // The class matters and is easy to miss. Prisma reports P2024 as a
  // PrismaClientKnownRequestError and P1001/P1002/P1017 as a
  // PrismaClientInitializationError. A filter inspecting only the first
  // class maps the pool timeout to 503 and sends every genuine "the
  // database is gone" to a 500 -- the exact case the mapping is for.
  const initError = (code: string) =>
    new Prisma.PrismaClientInitializationError('simulated ' + code, 'test', code);

  for (const code of ['P1001', 'P1002', 'P1017']) {
    const answer = httpForPrisma(initError(code));
    if (answer && answer.status === 503) {
      ok(code + ' (an initialization error) maps to 503, not 500');
    } else {
      bad(code + ' maps to 503', 'got ' + JSON.stringify(answer));
    }
  }

  const pool = httpForPrisma(dbError('P2024'));
  if (pool && pool.status === 503) ok('P2024 (a known-request error) also maps to 503');
  else bad('P2024 maps to 503', JSON.stringify(pool));

  if (prismaErrorCode(initError('P1001')) === 'P1001') {
    ok('the code is read off whichever class carried it');
  } else {
    bad('prismaErrorCode', 'it missed the initialization error');
  }

  // The mapping must not swallow real application errors into 503.
  const conflict = httpForPrisma(dbError('P2002'));
  if (conflict && conflict.status === 409) ok('P2002 is still a 409, not swallowed into 503');
  else bad('P2002', JSON.stringify(conflict));

  const missing = httpForPrisma(dbError('P2025'));
  if (missing && missing.status === 404) ok('P2025 is still a 404');
  else bad('P2025', JSON.stringify(missing));

  if (httpForPrisma(new Error('not a prisma error')) === null) {
    ok('a non-Prisma error is left for the caller to handle');
  } else {
    bad('non-Prisma', 'it was mapped');
  }

  if (isTransientDbError(initError('P1001')) && !isTransientDbError(dbError('P2002'))) {
    ok('isTransientDbError separates an outage from a constraint violation');
  } else {
    bad('isTransientDbError', 'it does not separate them');
  }

  process.stdout.write(`\n${checks} checks, ${failures} failed\n`);
  if (failures > 0) {
    process.stdout.write('\x1b[31mSOME CHECKS FAILED\x1b[0m\n');
    process.exit(1);
  }
  process.stdout.write('\x1b[32mALL CHECKS PASSED\x1b[0m\n');
  process.exit(0);
}

void main();
