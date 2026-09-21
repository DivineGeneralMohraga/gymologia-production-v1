// The 30-day deletion job must not anonymise a user who has become a gym
// owner during the grace period (DPDP erasure vs. cutting off a gym's members).
//
//   npm run build && npm run test:dpdp:job
//
// Scoped to the year 2000 so only the two synthetic users it creates can be
// "due" -- it never touches a real account. Leaves two DPDP-TEST users, a
// DPDP-TEST gym and one audit row behind (append-only by design).
const { NestFactory } = require('@nestjs/core');
const { AppModule } = require('../dist/app.module');
const { AccountDeletionService } = require('../dist/account/account-deletion.service');
const { PrismaService } = require('../dist/prisma/prisma.service');

(async () => {
  const app = await NestFactory.createApplicationContext(AppModule, { logger: false });
  const svc = app.get(AccountDeletionService);
  const prisma = app.get(PrismaService);
  const r = () => String(Math.floor(1000 + Math.random() * 8999));
  const due = new Date('2000-01-01T00:00:00Z');

  const A = await prisma.user.create({ data: { phone: '+91999991' + r(), name: 'DPDP-TEST-DUE-NOGYM', phoneVerified: true, deletionRequestedAt: due, deletionScheduledFor: due } });
  const B = await prisma.user.create({ data: { phone: '+91999992' + r(), name: 'DPDP-TEST-DUE-OWNER', phoneVerified: true, deletionRequestedAt: due, deletionScheduledFor: due } });
  await prisma.gym.create({ data: { ownerId: B.id, name: 'DPDP-TEST-DUE-GYM', addressLine1: 't', state: 't', district: 't', city: 't', pincode: '000000', contactPhone: B.phone, status: 'ACTIVE' } });

  const done = await svc.runDue(new Date('2000-01-02T00:00:00Z'));
  const a = await prisma.user.findUnique({ where: { id: A.id } });
  const b = await prisma.user.findUnique({ where: { id: B.id } });
  const audit = await prisma.auditLog.findFirst({ where: { action: 'account.delete.blocked', entityId: B.id } });

  const checks = [
    ['exactly one account was anonymised', done === 1],
    ['the user with no gym was anonymised', !!a.anonymisedAt && a.name === 'Deleted account'],
    ['the gym owner was NOT anonymised', b.anonymisedAt === null && b.name === 'DPDP-TEST-DUE-OWNER'],
    ["the owner's deletion request was cleared", b.deletionScheduledFor === null],
    ['an account.delete.blocked audit row explains why', !!audit],
  ];
  let failed = 0;
  for (const [name, pass] of checks) { console.log(pass ? '  PASS ' : '  FAIL ', name); if (!pass) failed++; }
  console.log(failed ? `\n${failed} FAILED` : '\nALL PASSED');
  await app.close();
  process.exit(failed ? 1 : 0);
})().catch((e) => { console.error(e); process.exit(2); });
