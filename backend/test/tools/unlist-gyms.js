// Usage (from backend/): node test/tools/unlist-gyms.js <gymId> [gymId...]
//
// The suites run against the live database, and a gym on a free trial is
// PRO and listed -- so a suite that starts a trial puts its test gym in
// real people's search results. Every such suite calls this from an EXIT
// trap, so the gym is taken out of search however the suite ends.
// Empty arguments are ignored: a trap may fire before a gym was created.
const fs = require('fs');
for (const l of fs.readFileSync('.env', 'utf8').split(/\r?\n/)) {
  const m = /^([A-Z0-9_]+)=(.*)$/.exec(l.trim());
  if (m) process.env[m[1]] = m[2].replace(/^"|"$/g, '');
}
const { PrismaClient } = require('@prisma/client');
const p = new PrismaClient();
const ids = process.argv.slice(2).filter((s) => /^[0-9a-f-]{36}$/.test(s));
(async () => {
  if (ids.length === 0) return;
  await p.gym.updateMany({ where: { id: { in: ids } }, data: { publicListing: false } });
})()
  .then(() => p.$disconnect())
  .catch((e) => { console.error(e.message); process.exit(1); });
