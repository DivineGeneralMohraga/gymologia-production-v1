// DPDP Act 2023 live regression test.
//
//   npm run build && (start the API on :3000), then:  npm run test:dpdp
//
// Drives the RUNNING API and the real database end to end: guardian-OTP
// sign-up for under-18s, the consent register and data export, staff
// enrolment of minors (server-side gate), the gym-owner deletion blocker,
// the gym-closing notification, right-to-erasure requests, and the
// append-only triggers.
//
// Every run leaves permanent test rows behind -- audit_logs, consent_records
// and security_events are append-only BY DESIGN, and a user with audit rows
// cannot be hard-deleted. Each user it creates is labelled DPDP-TEST and has
// account deletion requested at the end, so the app's own 30-day job
// anonymises them. Do not run it against production.
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

async function login(phone, client = 'MEMBER') {
  const r1 = await api('POST', '/auth/otp/request', { phone, appClient: client });
  if (r1.s !== 200) throw new Error('otp request failed ' + r1.s + JSON.stringify(r1.j));
  const r2 = await api('POST', '/auth/otp/verify', { phone, code: r1.j.devCode, challengeId: r1.j.challengeId, appClient: client });
  return r2.j;
}

(async () => {
  // pick free test-account numbers (fixed OTP, no SMS)
  const cand = [];
  for (let i = 0; i < 12; i++) cand.push('+9199999' + String(20000 + Math.floor(Math.random() * 79999)));
  const taken = new Set((await prisma.user.findMany({ where: { phone: { in: cand } }, select: { phone: true } })).map((u) => u.phone));
  const free = cand.filter((p) => !taken.has(p));
  console.log('free test numbers:', free.length);
  if (free.length < 3) throw new Error('not enough free test numbers');
  const [minorPhone, adultPhone, newMinorPhone] = free;
  const guardianPhone = '+919999900110';
  const users = {};

  console.log('\n[A] Legal content served');
  const legalIdx = (await api('GET', '/legal')).j;
  const privacy = (await api('GET', '/legal/privacy')).j.body;
  ok('legal version is current 2026-09-21.x', /^2026-09-21\./.test(legalIdx.version), legalIdx.version);
  ok('privacy names the Grievance Officer', privacy.includes('GRIEVANCE OFFICER') && privacy.includes('Sarthak Ganda'));
  ok('privacy describes 13-17 guardian consent', privacy.includes('13 to 17') && privacy.includes('guardian'));
  ok('privacy states retention incl. identity documents', privacy.includes('Identity documents') && privacy.includes('HOW LONG WE KEEP IT'));
  ok('privacy says chat is NOT end-to-end encrypted', privacy.includes('CHAT IS NOT END-TO-END ENCRYPTED'));
  ok('privacy: progress monitoring is off by default', privacy.includes('It is off by default'));

  console.log('\n[B] Under-18 SELF-registration (guardian OTP)');
  const lm = await login(minorPhone); ok('minor number is a NEW_USER', lm.status === 'NEW_USER', JSON.stringify(lm).slice(0, 80));
  const la = await login(adultPhone); ok('adult number is a NEW_USER', la.status === 'NEW_USER');
  const regM = lm.registrationToken, regA = la.registrationToken;

  let r = await api('POST', '/auth/guardian-consent/request', { registrationToken: regM, guardianPhone: minorPhone });
  ok('guardian number == own number is refused (400)', r.s === 400, r.s);
  r = await api('POST', '/auth/guardian-consent/request', { registrationToken: 'garbage', guardianPhone });
  ok('guardian request with bad registration token refused (401)', r.s === 401, r.s);
  r = await api('POST', '/auth/guardian-consent/request', { registrationToken: regM, guardianPhone });
  ok('guardian OTP issued', r.s === 200 && !!r.j.challengeId, r.s);
  const gch = r.j;
  r = await api('POST', '/auth/guardian-consent/verify', { registrationToken: regM, challengeId: gch.challengeId, guardianPhone, code: '000001' });
  ok('wrong guardian code rejected (400)', r.s === 400, r.s);
  r = await api('POST', '/auth/guardian-consent/verify', { registrationToken: regM, challengeId: gch.challengeId, guardianPhone, code: gch.devCode });
  ok('right guardian code yields a consent token', r.s === 200 && !!r.j.guardianConsentToken, r.s);
  const gTok = r.j.guardianConsentToken;

  r = await api('POST', '/auth/register', { registrationToken: regM, name: 'DPDP-TEST-MINOR', age: 15 });
  ok('minor register WITHOUT guardian token refused (400)', r.s === 400, r.s);
  r = await api('POST', '/auth/register', { registrationToken: regM, name: 'DPDP-TEST-MINOR', age: 15, guardianConsentToken: 'garbage' });
  ok('minor register with garbage guardian token refused (401)', r.s === 401, r.s);
  r = await api('POST', '/auth/register', { registrationToken: regA, name: 'DPDP-TEST-ADULT', age: 15, guardianConsentToken: gTok });
  ok("guardian token is bound to ONE registration (other phone's token refused, 401)", r.s === 401, r.s);
  const minorExistsBefore = await prisma.user.count({ where: { phone: minorPhone } });
  ok('no minor account was created by any refused attempt', minorExistsBefore === 0, minorExistsBefore);
  r = await api('POST', '/auth/register', { registrationToken: regM, name: 'DPDP-TEST-MINOR', age: 15, guardianConsentToken: gTok });
  ok('minor register WITH valid guardian token succeeds (201)', r.s === 201 && r.j.user.age === 15, r.s + ' ' + JSON.stringify(r.j).slice(0, 120));
  users.minor = { id: r.j.user.id, tok: r.j.tokens.accessToken, phone: minorPhone };
  r = await api('POST', '/auth/register', { registrationToken: regA, name: 'DPDP-TEST-ADULT', age: 30 });
  ok('ADULT register needs no guardian (regression, 201)', r.s === 201, r.s);
  users.adult = { id: r.j.user.id, tok: r.j.tokens.accessToken, phone: adultPhone };

  console.log('\n[C] Consent register + data export (DPDP s.6, s.12)');
  r = await api('GET', '/me/export');
  ok('/me/export requires auth (401)', r.s === 401, r.s);
  await api('POST', '/me/legal/accept', null, users.minor.tok);
  r = await api('GET', '/me/export', null, users.minor.tok);
  ok('export returns the account', r.s === 200 && r.j.account && r.j.account.id === users.minor.id, r.s);
  const hist = (r.j && r.j.consentHistory) || [];
  ok('export lists GUARDIAN_CONSENT (granted)', hist.some((h) => h.purpose === 'GUARDIAN_CONSENT' && h.granted === true));
  ok('export lists TERMS_OF_USE + PRIVACY_POLICY at current version',
    hist.some((h) => h.purpose === 'TERMS_OF_USE' && h.version === legalIdx.version) &&
    hist.some((h) => h.purpose === 'PRIVACY_POLICY' && h.version === legalIdx.version));
  ok('export never contains other users\' data', JSON.stringify(r.j).indexOf(users.adult.id) === -1);
  const aud = await prisma.auditLog.findFirst({ where: { action: 'account.guardian_consent', entityId: users.minor.id } });
  ok('audit log records guardian consent with MASKED guardian phone', !!aud && aud.after && /\*{3,}/.test(aud.after.guardianPhoneMasked || ''), JSON.stringify(aud && aud.after));

  console.log('\n[D] Gym owner deletion blocker + staff enrolment of minors (DPDP s.9)');
  // the freshly registered adult owns the test gym, so no shared account is needed
  const ownerPhone = adultPhone;
  const ownTok = users.adult.tok; const ownId = users.adult.id;
  r = await api('POST', '/gyms', { name: 'DPDP-TEST-GYM', addressLine1: 'Test road', state: 'Test', district: 'Test', city: 'Test', pincode: '000000', contactPhone: ownerPhone }, ownTok);
  ok('test gym created', r.s === 201 || r.s === 200, r.s + ' ' + JSON.stringify(r.j).slice(0, 150));
  const gymId = r.j.id || (r.j.gym && r.j.gym.id);
  await prisma.gym.update({ where: { id: gymId }, data: { status: 'ACTIVE' } });

  r = await api('GET', '/me/deletion/preview', null, ownTok);
  ok('deletion preview lists the gym as a blocker', r.s === 200 && r.j.blockers.length === 1, JSON.stringify(r.j).slice(0, 150));
  ok('blocker text no longer mentions handing over to another owner', r.s === 200 && !/hand it/i.test(r.j.blockers[0].message) && /closed/.test(r.j.blockers[0].message));
  r = await api('POST', '/me/deletion', {}, ownTok);
  ok('owner cannot request account deletion while owning a gym (409)', r.s === 409, r.s);

  async function enrol(phone, extra) {
    const lk = await api('POST', `/gyms/${gymId}/members/lookup`, { phone }, ownTok);
    if (lk.s !== 200 && lk.s !== 201) return { s: lk.s, j: lk.j, stage: 'lookup' };
    return api('POST', `/gyms/${gymId}/members`, { challengeId: lk.j.challengeId, phone: lk.j.phone, code: lk.j.devCode, planMonths: 1, maxLeaveDays: 2, ...extra }, ownTok);
  }
  r = await enrol(newMinorPhone, { name: 'DPDP-TEST-NEWMINOR' });
  ok('NEW member with NO age is refused server-side (400)', r.s === 400 && /age/i.test(JSON.stringify(r.j)), r.s + ' ' + JSON.stringify(r.j).slice(0, 120));
  r = await enrol(newMinorPhone, { name: 'DPDP-TEST-NEWMINOR', age: 15 });
  ok('NEW minor without guardian confirmation refused (400)', r.s === 400 && /parent or guardian/.test(JSON.stringify(r.j)), r.s + ' ' + JSON.stringify(r.j).slice(0, 120));
  const orphan = await prisma.user.count({ where: { phone: newMinorPhone } });
  ok('...and NO account was created for the refused minor (no data stored without consent)', orphan === 0, 'accounts found: ' + orphan);
  r = await enrol(newMinorPhone, { name: 'DPDP-TEST-NEWMINOR', age: 15, guardianConsentConfirmed: true });
  ok('NEW minor WITH guardian confirmation is enrolled (201)', r.s === 201, r.s + ' ' + JSON.stringify(r.j).slice(0, 150));
  const nm = await prisma.user.findUnique({ where: { phone: newMinorPhone } });
  users.newMinor = { id: nm && nm.id, phone: newMinorPhone };
  const nmc = await prisma.consentRecord.findFirst({ where: { userId: nm.id, purpose: 'GUARDIAN_CONSENT' } });
  ok('staff-enrolment guardian consent stored in the consent register', !!nmc && nmc.metadata && nmc.metadata.confirmedByStaffId === ownId);
  const nmm = await prisma.membership.findFirst({ where: { userId: nm.id, gymId } });
  ok('new membership has progress monitoring OFF by default (opt-in)', nmm && nmm.allowProgressMonitoring === false);

  r = await enrol(minorPhone, {});
  ok('EXISTING minor (self-registered, age 15) without confirmation refused (400)', r.s === 400 && /parent or guardian/.test(JSON.stringify(r.j)), r.s);
  r = await enrol(minorPhone, { guardianConsentConfirmed: true });
  ok('EXISTING minor WITH confirmation is enrolled (201)', r.s === 201, r.s + ' ' + JSON.stringify(r.j).slice(0, 120));
  r = await enrol(adultPhone, {});
  ok('EXISTING adult enrolls with no guardian step (regression, 201)', r.s === 201, r.s + ' ' + JSON.stringify(r.j).slice(0, 120));

  console.log('\n[E] Gym closing notifies members (product fix) + owner deletion unblocked');
  r = await api('DELETE', `/gyms/${gymId}`, null, ownTok);
  ok('owner deletes the gym', r.s === 200 && r.j.deleted === true, r.s);
  await sleep(2500);
  const n = await prisma.notification.findFirst({ where: { gymId, source: 'GYMOLOGIA' }, include: { recipients: true } });
  ok('a closing notification was created', !!n, 'none');
  const rec = new Set((n ? n.recipients : []).map((x) => x.userId));
  ok('all three active members were notified', rec.has(users.minor.id) && rec.has(users.adult.id) && rec.has(users.newMinor.id), [...rec].length + ' recipients');
  r = await api('POST', '/me/deletion', {}, ownTok);
  ok('owner can now request account deletion (blocker cleared)', r.s === 200 || r.s === 201, r.s + ' ' + JSON.stringify(r.j).slice(0, 100));

  console.log('\n[F] Right to erasure: deletion request + cancel-able grace period');
  for (const [label, u] of Object.entries({ minor: users.minor, adult: users.adult })) {
    const d = await api('POST', '/me/deletion', {}, u.tok);
    const st = await api('GET', '/me/deletion', null, u.tok);
    const days = st.j && st.j.scheduledFor ? Math.round((new Date(st.j.scheduledFor) - Date.now()) / 86400000) : null;
    ok(`${label}: deletion scheduled ~30 days out`, (d.s === 200 || d.s === 201) && st.j.pending === true && days >= 29 && days <= 30, `${d.s} days=${days}`);
  }
  const nl = await login(newMinorPhone);
  if (nl.status === 'AUTHENTICATED') await api('POST', '/me/deletion', {}, nl.tokens.accessToken);

  console.log('\n[G] Database-level guarantees');
  const trg = await prisma.$queryRaw`SELECT c.relname AS tbl, t.tgname FROM pg_trigger t JOIN pg_class c ON c.oid = t.tgrelid WHERE t.tgname LIKE '%\_no\_%' AND NOT t.tgisinternal ORDER BY 1,2`;
  ok('6 append-only triggers present (3 tables x update/delete + truncate)', trg.length === 6, trg.map((x) => x.tgname).join(','));
  for (const [tbl, col] of [['audit_logs', 'action'], ['consent_records', 'granted'], ['security_events', 'type']]) {
    let blocked = false;
    try { await prisma.$executeRawUnsafe ? await prisma.$queryRaw`SELECT 1` : null; } catch { /* noop */ }
    try {
      if (tbl === 'audit_logs') await prisma.$executeRaw`UPDATE audit_logs SET action = action WHERE id = (SELECT id FROM audit_logs LIMIT 1)`;
      if (tbl === 'consent_records') await prisma.$executeRaw`UPDATE consent_records SET granted = granted WHERE id = (SELECT id FROM consent_records LIMIT 1)`;
      if (tbl === 'security_events') await prisma.$executeRaw`UPDATE security_events SET severity = severity WHERE id = (SELECT id FROM security_events LIMIT 1)`;
    } catch (e) { blocked = /append-only/.test(String(e.message)); }
    ok(`${tbl}: even a no-op UPDATE is rejected by the trigger`, blocked);
  }
  const def = await prisma.$queryRaw`SELECT column_default FROM information_schema.columns WHERE table_name='memberships' AND column_name='allowProgressMonitoring'`;
  ok('memberships.allowProgressMonitoring column default is false', def[0].column_default === 'false');
  const onCount = await prisma.membership.count({ where: { allowProgressMonitoring: true } });
  ok('no membership has progress monitoring switched on without the member doing it', onCount === 0, 'count=' + onCount);
  const staleSessions = await prisma.session.count({ where: { expiresAt: { lt: new Date(Date.now() - 90 * 86400000) } } });
  console.log('   info: sessions expired >90d awaiting the weekly purge:', staleSessions);
  const nullAge = await prisma.user.count({ where: { age: null, anonymisedAt: null } });
  const allU = await prisma.user.count({ where: { anonymisedAt: null } });
  console.log('   info: accounts with NO age on record (gate cannot apply):', nullAge, 'of', allU);

  console.log('\n==== RESULT:', pass, 'passed,', fail, 'failed ====');
  if (fail) { console.log('FAILURES:'); failures.forEach((f) => console.log(' -', f)); }
  await prisma.$disconnect();
  process.exit(fail ? 1 : 0);
})().catch(async (e) => { console.error('SCRIPT ERROR', e); await prisma.$disconnect(); process.exit(2); });
