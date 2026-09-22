// Live regression test for three staff/CRM bugs reported and fixed 2026-09-22:
//
//   npm run build && (start the API on :3000), then:  npm run test:bugfix-staff-events
//
//   1. Adding a trainer never asked which category (general/personal/other
//      made by gym management) -- add_person_sheet.dart's staff branch only
//      showed a role picker; isTrainer/trainerCategoryId were never sent
//      even though the backend has always required and validated them.
//   2. Staff had no way to mark a staff member's attendance in the app --
//      staff_page.dart only had onTap (edit) and onLongPress (view
//      history); there was no equivalent of MembersPage's tap-to-mark.
//   3. Staff at a Basic-plan gym could not see events their own gym's
//      management hosted, if they were not also a paying member there --
//      EventsService.feed() built "my gyms" from Membership rows only,
//      never from StaffMember rows, and Basic gyms are excluded from the
//      public feed by design.
//
// Drives the RUNNING API and the real database end to end. Every row is
// labelled BUGFIX-TEST and uses randomised, previously-unused phone
// numbers, so reruns never collide with earlier ones. Nothing it creates
// needs cleanup: a throwaway gym, its staff and its event are all
// harmless, clearly-labelled test data.
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

async function login(phone, client = 'STAFF') {
  const r1 = await api('POST', '/auth/otp/request', { phone, appClient: client });
  if (r1.s !== 200) throw new Error('otp request failed ' + r1.s + JSON.stringify(r1.j));
  const r2 = await api('POST', '/auth/otp/verify', { phone, code: r1.j.devCode, challengeId: r1.j.challengeId, appClient: client });
  if (r2.j.status === 'NEW_USER') {
    const reg = await api('POST', '/auth/register', { registrationToken: r2.j.registrationToken, name: 'BUGFIX-TEST-USER', age: 30 });
    return { status: 'AUTHENTICATED', tokens: reg.j.tokens, user: reg.j.user };
  }
  return r2.j;
}

async function lookupAndVerify(gymId, phone, actorTok, extra = {}) {
  const lk = await api('POST', `/gyms/${gymId}/staff/lookup`, { phone }, actorTok);
  if (lk.s !== 200 && lk.s !== 201) return { s: lk.s, j: lk.j };
  return api('POST', `/gyms/${gymId}/staff`, { challengeId: lk.j.challengeId, phone: lk.j.phone, code: lk.j.devCode, ...extra }, actorTok);
}

(async () => {
  const cand = [];
  for (let i = 0; i < 12; i++) cand.push('+9199999' + String(60000 + Math.floor(Math.random() * 9999)));
  const taken = new Set((await prisma.user.findMany({ where: { phone: { in: cand } }, select: { phone: true } })).map((u) => u.phone));
  const free = cand.filter((p) => !taken.has(p));
  if (free.length < 4) throw new Error('not enough free test numbers');
  const [ownerPhone, trainerPhone, plainStaffPhone, otherStaffPhone] = free;

  console.log('\n[Setup] Owner + a Basic-plan gym');
  const lo = await login(ownerPhone, 'STAFF');
  ok('owner registers/signs in', lo.status === 'AUTHENTICATED' || lo.user, JSON.stringify(lo).slice(0, 120));
  const ownTok = lo.tokens.accessToken;
  let r = await api('POST', '/gyms', { name: 'BUGFIX-TEST-GYM', addressLine1: 'Test road', state: 'Test', district: 'Test', city: 'Test', pincode: '000000', contactPhone: ownerPhone }, ownTok);
  ok('gym created', r.s === 200 || r.s === 201, r.s + ' ' + JSON.stringify(r.j).slice(0, 150));
  const gymId = r.j.id || (r.j.gym && r.j.gym.id);
  // Explicitly Basic (not Pro) -- default status is ACTIVE with whatever plan
  // the fixture leaves it at; force it so bug #3's exact scenario is real.
  await prisma.gym.update({ where: { id: gymId }, data: { status: 'ACTIVE' } });
  await prisma.gymSubscription.deleteMany({ where: { gymId } });
  await prisma.gymSubscription.create({
    data: {
      gymId, plan: 'BASIC', status: 'ACTIVE',
      startsAt: new Date(Date.now() - 86400000), endsAt: new Date(Date.now() + 30 * 86400000),
      basePricePaise: 59900, amountPayablePaise: 59900,
    },
  });
  const gymCheck = await prisma.gym.findUnique({ where: { id: gymId }, include: { subscriptions: true } });
  console.log('   gym subscription plan:', gymCheck.subscriptions.map((s) => s.plan + '/' + s.status).join(','));

  console.log('\n[1] Trainer category is asked for and enforced');
  r = await api('GET', `/gyms/${gymId}/trainer-categories`, null, ownTok);
  ok('trainer categories listable', r.s === 200, r.s);
  let generalCatId = (r.j || []).find((c) => /general/i.test(c.name))?.id;
  if (!generalCatId) {
    const created = await api('POST', `/gyms/${gymId}/trainer-categories`, { name: 'BUGFIX-TEST-CATEGORY', allowsMultipleMembers: true }, ownTok);
    ok('fallback: created a trainer category', created.s === 200 || created.s === 201, created.s);
    generalCatId = created.j.id || (created.j[0] && created.j[0].id);
  }
  ok('have a usable trainer category id', !!generalCatId, generalCatId);

  r = await lookupAndVerify(gymId, trainerPhone, ownTok, { name: 'BUGFIX-TEST-TRAINER', roleId: undefined });
  // roleId is required regardless; fetch an assignable role first.
  const roles = await api('GET', `/gyms/${gymId}/roles`, null, ownTok);
  // Owner/Manager are deliberately exempt from attendance -- pick a role
  // that IS subject to it, so test #2 below exercises the real path.
  const assignableRole = (roles.j || []).find(
    (x) => x.assignable && !/manager|owner|admin/i.test(x.name),
  );
  ok('an assignable non-exempt role exists to test with', !!assignableRole, JSON.stringify(roles.j).slice(0, 250));

  r = await lookupAndVerify(gymId, trainerPhone, ownTok, { name: 'BUGFIX-TEST-TRAINER', roleId: assignableRole.id, isTrainer: true });
  ok('isTrainer:true with NO category is rejected server-side (400)', r.s === 400, r.s + ' ' + JSON.stringify(r.j).slice(0, 150));

  r = await lookupAndVerify(gymId, trainerPhone, ownTok, { name: 'BUGFIX-TEST-TRAINER', roleId: assignableRole.id, isTrainer: true, trainerCategoryId: generalCatId });
  ok('isTrainer:true WITH a category succeeds (201)', r.s === 201, r.s + ' ' + JSON.stringify(r.j).slice(0, 150));
  const trainerUserId = (await prisma.user.findUnique({ where: { phone: trainerPhone } }))?.id;
  const trainerStaffRow = await prisma.staffMember.findFirst({ where: { gymId, userId: trainerUserId } });
  ok('StaffMember row actually has isTrainer=true and the right category', trainerStaffRow?.isTrainer === true && trainerStaffRow?.trainerCategoryId === generalCatId, JSON.stringify(trainerStaffRow));

  console.log('\n[2] Marking a staff member\'s attendance');
  r = await lookupAndVerify(gymId, plainStaffPhone, ownTok, { name: 'BUGFIX-TEST-STAFF', roleId: assignableRole.id });
  ok('a second, non-trainer staff member is added', r.s === 201, r.s);
  const staffUserId = (await prisma.user.findUnique({ where: { phone: plainStaffPhone } }))?.id;

  r = await api('POST', `/gyms/${gymId}/attendance`, { subjectType: 'STAFF', subjectId: staffUserId }, ownTok);
  ok('owner marks the staff member PRESENT (this is the exact call staff_page.dart now makes)', r.s === 200 || r.s === 201, r.s + ' ' + JSON.stringify(r.j).slice(0, 150));
  const attRow = await prisma.attendanceRecord.findFirst({ where: { gymId, subjectId: staffUserId, subjectType: 'STAFF' } });
  ok('an AttendanceRecord row exists for that staff member today', !!attRow && attRow.status === 'PRESENT', JSON.stringify(attRow));

  r = await api('POST', `/gyms/${gymId}/attendance`, { subjectType: 'STAFF', subjectId: staffUserId }, ownTok);
  ok('marking the same person again same day is idempotent, not an error', r.s === 200 || r.s === 201, r.s);
  const attCount = await prisma.attendanceRecord.count({ where: { gymId, subjectId: staffUserId, subjectType: 'STAFF' } });
  ok('...and there is still exactly one row for today, not a duplicate', attCount === 1, attCount);

  console.log('\n[3] Basic-plan staff sees their own gym\'s hosted events');
  const now = new Date();
  r = await api('POST', `/gyms/${gymId}/events`, {
    title: 'BUGFIX-TEST-EVENT',
    description: 'Testing that Basic-plan staff see their own gym events.',
    howToParticipate: 'Show up on the day.',
    registrationLastDate: new Date(now.getTime() + 86400000).toISOString().slice(0, 10),
    startsAt: new Date(now.getTime() + 2 * 86400000).toISOString(),
    endsAt: new Date(now.getTime() + 2 * 86400000 + 3600000).toISOString(),
  }, ownTok);
  ok('management hosts an event at the Basic gym', r.s === 200 || r.s === 201, r.s + ' ' + JSON.stringify(r.j).slice(0, 200));
  ok('...and the response itself says it is Basic-only (not publicly listed)', !!(r.j && r.j.listingNote), JSON.stringify(r.j && r.j.listingNote));
  const eventRow = await prisma.event.findFirst({ where: { gymId, title: 'BUGFIX-TEST-EVENT' } });
  ok('event row confirms publicListing=false (Basic plan)', eventRow && eventRow.publicListing === false, eventRow && eventRow.publicListing);

  // A THIRD staff member who is a staff member ONLY -- never added as a paying
  // member of this gym. This is exactly the bug report: "basic plan staff not
  // able to see events hosted by management of gym".
  r = await lookupAndVerify(gymId, otherStaffPhone, ownTok, { name: 'BUGFIX-TEST-STAFFONLY', roleId: assignableRole.id });
  ok('a staff-only (non-member) account is added', r.s === 201, r.s);
  const staffOnlyLogin = await login(otherStaffPhone, 'STAFF');
  const staffOnlyTok = staffOnlyLogin.tokens.accessToken;
  const staffOnlyUserId = staffOnlyLogin.user.id;
  const hasMembership = await prisma.membership.count({ where: { userId: staffOnlyUserId } });
  ok('...confirmed: this account has NO membership anywhere (the exact bug scenario)', hasMembership === 0, hasMembership);

  r = await api('GET', '/events', null, staffOnlyTok);
  ok('/events feed call succeeds for the staff-only account', r.s === 200, r.s + ' ' + JSON.stringify(r.j).slice(0, 150));
  const mine = (r.j && r.j.myGyms) || [];
  ok('BEFORE THE FIX this would be empty -- the hosted event now appears under "my gyms"', mine.some((e) => e.title === 'BUGFIX-TEST-EVENT'), 'myGyms titles: ' + mine.map((e) => e.title).join(','));
  const global = (r.j && r.j.global) || [];
  ok('...and it correctly does NOT leak into the public/global feed (Basic plan)', !global.some((e) => e.title === 'BUGFIX-TEST-EVENT'));

  console.log('\n==== RESULT:', pass, 'passed,', fail, 'failed ====');
  if (fail) { console.log('FAILURES:'); failures.forEach((f) => console.log(' -', f)); }
  await prisma.$disconnect();
  process.exit(fail ? 1 : 0);
})().catch(async (e) => { console.error('SCRIPT ERROR', e); await prisma.$disconnect(); process.exit(2); });
