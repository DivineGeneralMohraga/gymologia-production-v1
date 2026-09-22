// Live regression test for a bug fixed 2026-09-23:
//
//   npm run build && (start the API on :3000), then:  npm run test:search-kyc-gate
//
// gyms.service.ts's search() -- and ranking.service.ts's mirror of it --
// only checked status/publicListing/PRO-subscription. CLAUDE.md is explicit
// that the public browser lists a gym once it "has already done kyc and
// using pro plan"; a PRO gym with zero KYC documents on file was showing up
// anyway (confirmed live against +919999900000's Apex Fitness Pune gym,
// which had no gym_kyc row at all before it was backfilled by hand).
//
// Unlike the other live suites in this directory, this one cleans up every
// row it creates -- by exact id, never by a "looks like test data" filter --
// because re-running an uncleaned suite is exactly how 882 junk gyms ended
// up in production earlier this project. The owner User row is the one
// thing left behind, matching the project-wide rule of never deleting a
// User.
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();
const B = 'http://localhost:3000/api/v1';

let pass = 0, fail = 0;
const failures = [];
function ok(name, cond, detail = '') {
  if (cond) { pass++; console.log('  PASS ', name); }
  else { fail++; failures.push(name + (detail ? ' :: ' + detail : '')); console.log('  FAIL ', name, detail); }
}
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

async function api(method, path, body, token, retried = false) {
  const res = await fetch(B + path, {
    method,
    headers: { 'Content-Type': 'application/json', ...(token ? { Authorization: 'Bearer ' + token } : {}) },
    body: body ? JSON.stringify(body) : undefined,
  });
  let j = null;
  try { j = await res.json(); } catch { /* no body */ }
  if (res.status === 429 && !retried) {
    console.log('   (rate limited, waiting 62s)');
    await sleep(62000);
    return api(method, path, body, token, true);
  }
  return { s: res.status, j };
}

async function login(phone) {
  const r1 = await api('POST', '/auth/otp/request', { phone, appClient: 'STAFF' });
  if (r1.s !== 200) throw new Error('otp request failed ' + r1.s + JSON.stringify(r1.j));
  const r2 = await api('POST', '/auth/otp/verify', { phone, code: r1.j.devCode, challengeId: r1.j.challengeId, appClient: 'STAFF' });
  if (r2.j.status === 'NEW_USER') {
    const reg = await api('POST', '/auth/register', { registrationToken: r2.j.registrationToken, name: 'KYCGATE-TEST-USER', age: 30 });
    return { status: 'AUTHENTICATED', tokens: reg.j.tokens, user: reg.j.user };
  }
  return r2.j;
}

(async () => {
  let gymId = null;
  try {
    const cand = [];
    for (let i = 0; i < 8; i++) cand.push('+9199999' + String(70000 + Math.floor(Math.random() * 9999)));
    const taken = new Set((await prisma.user.findMany({ where: { phone: { in: cand } }, select: { phone: true } })).map((u) => u.phone));
    const free = cand.filter((p) => !taken.has(p));
    if (free.length < 1) throw new Error('not enough free test numbers');
    const ownerPhone = free[0];
    const district = 'KycGateTestDistrict-' + Date.now();

    console.log('\n[Setup] Owner + a Pro-plan gym with no KYC yet');
    const lo = await login(ownerPhone);
    ok('owner registers/signs in', lo.status === 'AUTHENTICATED' || lo.user, JSON.stringify(lo).slice(0, 120));
    const ownTok = lo.tokens.accessToken;

    let r = await api('POST', '/gyms', {
      name: 'KYCGATE-TEST-GYM', addressLine1: 'Test road',
      state: 'KycGateTestState', district, city: 'KycGateTestCity',
      pincode: '000000', contactPhone: ownerPhone,
    }, ownTok);
    ok('gym created', r.s === 200 || r.s === 201, r.s + ' ' + JSON.stringify(r.j).slice(0, 150));
    gymId = r.j.id || (r.j.gym && r.j.gym.id);

    // Force PRO + ACTIVE + publicListing deterministically, same as the
    // other live suites do, rather than depending on the trial/payment flow.
    await prisma.gym.update({ where: { id: gymId }, data: { status: 'ACTIVE', publicListing: true } });
    await prisma.gymSubscription.deleteMany({ where: { gymId } });
    await prisma.gymSubscription.create({
      data: {
        gymId, plan: 'PRO', status: 'ACTIVE',
        startsAt: new Date(Date.now() - 86400000), endsAt: new Date(Date.now() + 30 * 86400000),
        amountPayablePaise: 0, basePricePaise: 0, isTrial: false,
      },
    });

    console.log('\n[1] PRO + ACTIVE + publicListing, but no gym_kyc row at all');
    r = await api('GET', `/gyms/search?district=${encodeURIComponent(district)}`, null, null);
    ok('search does NOT list an unverified gym', r.s === 200 && !r.j.some((g) => g.id === gymId), r.s + ' ' + JSON.stringify(r.j));

    let rank = await api('GET', `/gyms/${gymId}/ranking`, null, ownTok);
    ok('ranking says not listed (no KYC row)', rank.s === 200 && rank.j.listed === false, JSON.stringify(rank.j));
    ok('ranking reason mentions KYC', /kyc/i.test(rank.j.reason || ''), rank.j.reason);

    console.log('\n[2] gym_kyc row exists but is not verified yet (documents submitted, pending review)');
    const kyc = await prisma.gymKyc.create({
      data: { gymId, premises: 'OWNED', aadhaarStatus: 'PENDING', panStatus: 'PENDING', gstStatus: 'NOT_SUBMITTED' },
    });
    r = await api('GET', `/gyms/search?district=${encodeURIComponent(district)}`, null, null);
    ok('search still does NOT list it while KYC is pending', r.s === 200 && !r.j.some((g) => g.id === gymId), r.s + ' ' + JSON.stringify(r.j));

    console.log('\n[3] gym_kyc verified -- this is what an admin APPROVE decision sets');
    await prisma.gymKyc.update({ where: { id: kyc.id }, data: { aadhaarStatus: 'VERIFIED', panStatus: 'VERIFIED', verifiedAt: new Date() } });
    r = await api('GET', `/gyms/search?district=${encodeURIComponent(district)}`, null, null);
    ok('search NOW lists it once KYC is verified', r.s === 200 && r.j.some((g) => g.id === gymId), r.s + ' ' + JSON.stringify(r.j));

    rank = await api('GET', `/gyms/${gymId}/ranking`, null, ownTok);
    ok('ranking says listed now', rank.s === 200 && rank.j.listed === true, JSON.stringify(rank.j));
    ok('ranking returns all four scopes', Array.isArray(rank.j.scopes) && rank.j.scopes.length === 4, JSON.stringify(rank.j.scopes));
  } finally {
    // Inclusion-based cleanup: only the exact ids this run created, never a
    // "looks like test data" filter. The owner User row is left in place.
    if (gymId) {
      await prisma.gymKyc.deleteMany({ where: { gymId } });
      await prisma.gymSubscription.deleteMany({ where: { gymId } });
      await prisma.gym.delete({ where: { id: gymId } }).catch(() => {});
      console.log('\n[Cleanup] deleted throwaway gym', gymId, 'and its kyc/subscription rows');
    }
    await prisma.$disconnect();
  }

  console.log(`\n==== RESULT: ${pass} passed, ${fail} failed ====`);
  if (fail > 0) { console.log('Failures:', failures); process.exit(1); }
})().catch(async (e) => {
  console.error('SCRIPT ERROR', e);
  await prisma.$disconnect();
  process.exit(1);
});
