/**
 * The website's legal pages must match the text the apps show.
 *
 *   npx ts-node --transpile-only test/website-legal.spec.ts
 *
 * gymologia.com/privacy.html and terms.html are generated from
 * src/legal/legal.content.ts by website-src/build.mjs, and the Play Store
 * listing links to them. Change the legal text without rebuilding the site
 * and the store would point at a policy the app no longer shows, so this
 * fails until `node website-src/build.mjs` has been run.
 */
import * as fs from 'node:fs';
import * as path from 'node:path';
import { LEGAL_DOCUMENTS, LEGAL_VERSION } from '../src/legal/legal.content';

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

const site = path.join(__dirname, '..', '..', 'website');
const rebuild = 'run: node website-src/build.mjs';

for (const [slug, doc] of Object.entries(LEGAL_DOCUMENTS)) {
  const file = path.join(site, `${slug}.html`);
  if (!fs.existsSync(file)) {
    bad(`website/${slug}.html exists`, rebuild);
    continue;
  }
  const html = fs.readFileSync(file, 'utf8');
  if (html.includes(`Version ${LEGAL_VERSION}`)) {
    ok(`website/${slug}.html is version ${LEGAL_VERSION}`);
  } else {
    bad(`website/${slug}.html is version ${LEGAL_VERSION}`, rebuild);
  }
  // Spot-check the body too: the version alone would pass if the text
  // changed without a version bump.
  const lastLine = doc.body.trim().split('\n').filter((l) => l.trim() && !/[A-Z]{4}/.test(l)).at(-1) ?? '';
  const probe = lastLine.trim().slice(0, 40).replace(/&/g, '&amp;').replace(/"/g, '&quot;');
  if (!probe || html.includes(probe)) {
    ok(`website/${slug}.html carries the current wording`);
  } else {
    bad(`website/${slug}.html carries the current wording`, `missing "${probe}" -- ${rebuild}`);
  }
}

if (fs.existsSync(path.join(site, 'delete-account.html'))) {
  ok('website/delete-account.html exists (Play Store deletion link)');
} else {
  bad('website/delete-account.html exists (Play Store deletion link)', rebuild);
}

process.stdout.write(`\n${checks} checks, ${failures} failed\n`);
if (failures > 0) {
  process.stdout.write('\x1b[31mSOME CHECKS FAILED\x1b[0m\n');
  process.exit(1);
}
process.stdout.write('\x1b[32mALL CHECKS PASSED\x1b[0m\n');
