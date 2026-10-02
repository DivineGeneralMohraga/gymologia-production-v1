// Usage (from backend/): node test/tools/activate-gym.js <gymId> [gymId...]
//
// The CRM is locked until a gym has a plan, so suites that exercise the CRM
// need an active gym. The free trial would do it, but it also lists the gym
// in the live app's search and uses up the owner's one trial -- this sets
// the gym ACTIVE and unlisted instead, as if paid for and kept private.
const fs = require('fs');
for (const l of fs.readFileSync('.env', 'utf8').split(/\r?\n/)) {
  const m = /^([A-Z0-9_]+)=(.*)$/.exec(l.trim());
  if (m) process.env[m[1]] = m[2].replace(/^"|"$/g, '');
}
const { PrismaClient } = require('@prisma/client');
const p = new PrismaClient();
const ids = process.argv.slice(2).filter(Boolean);
(async () => {
  if (ids.length === 0) throw new Error('no gym id given');
  const r = await p.gym.updateMany({
    where: { id: { in: ids } },
    data: { status: 'ACTIVE', publicListing: false },
  });
  if (r.count !== ids.length) throw new Error(`activated ${r.count} of ${ids.length}`);
})()
  .then(() => p.$disconnect())
  .catch((e) => { console.error(e.message); process.exit(1); });
