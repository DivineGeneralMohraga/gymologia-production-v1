// Builds gymologia.com into ../website, the folder the server publishes.
//
//   node website-src/build.mjs
//
// home.html is the landing page body (it is also what the Claude artifact
// preview publishes). The Privacy Policy and Terms are rendered from
// backend/src/legal/legal.content.ts -- the same text the apps show -- so
// the website can never say something different from the app. Run this
// again whenever that file changes; test/website-legal.spec.ts in the
// backend fails if the published pages fall behind it.
import { readFileSync, writeFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const here = dirname(fileURLToPath(import.meta.url));
const root = join(here, '..');
const out = join(root, 'website');
const SITE = 'https://gymologia.com';

// ── Legal text, read straight from the backend source ──
const legalSrc = readFileSync(join(root, 'backend/src/legal/legal.content.ts'), 'utf8');
const LEGAL_VERSION = /LEGAL_VERSION = '([^']+)'/.exec(legalSrc)[1];
const SUPPORT_EMAIL = /SUPPORT_EMAIL = '([^']+)'/.exec(legalSrc)[1];
function legalDoc(slug) {
  const block = new RegExp(`slug: '${slug}',[\\s\\S]*?title: '([^']+)'[\\s\\S]*?updatedAt: '([^']+)'[\\s\\S]*?body: \`([\\s\\S]*?)\`\\.trim\\(\\)`).exec(legalSrc);
  if (!block) throw new Error(`legal document "${slug}" not found`);
  return {
    title: block[1],
    updatedAt: block[2],
    body: block[3].replaceAll('${SUPPORT_EMAIL}', SUPPORT_EMAIL).trim(),
  };
}

const esc = (s) => s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
const linkEmail = (s) => s.replace(/[\w.+-]+@[\w-]+\.[\w.]+/g, (m) => `<a href="mailto:${m}">${m}</a>`);
const slugify = (s) => s.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '');
const isHeading = (line) => line.length < 90 && /[A-Z]/.test(line) && line === line.toUpperCase();
// "WHO CAN USE GYMOLOGIA" -> "Who can use Gymologia", keeping names and
// acronyms as they are written elsewhere.
const KEEP = { gymologia: 'Gymologia', kyc: 'KYC', otp: 'OTP', upi: 'UPI', india: 'India', dpdp: 'DPDP', sms: 'SMS' };
const sentenceCase = (h) => h.toLowerCase().replace(/^./, (c) => c.toUpperCase())
  .replace(/[A-Za-z]+/g, (w) => KEEP[w.toLowerCase()] ?? w);
const longDate = (iso) => new Date(iso + 'T00:00:00Z').toLocaleDateString('en-IN', { day: 'numeric', month: 'long', year: 'numeric', timeZone: 'UTC' });

// Plain text with blank-line paragraphs; a block that starts with an ALL
// CAPS line opens a section.
function renderLegal(body) {
  const sections = [];
  let current = { heading: null, html: [] };
  for (const block of body.split(/\n\s*\n/)) {
    const lines = block.split('\n').map((l) => l.trim()).filter(Boolean);
    if (!lines.length) continue;
    if (isHeading(lines[0])) {
      if (current.heading || current.html.length) sections.push(current);
      current = { heading: lines.shift(), html: [] };
      if (!lines.length) continue;
    }
    // "Name: ..." / "Email: ..." blocks keep their line breaks.
    const listy = lines.length > 1 && lines.every((l) => /^[A-Z][\w ]{1,20}:/.test(l));
    const text = listy ? lines.map((l) => linkEmail(esc(l))).join('<br>') : linkEmail(esc(lines.join(' ')));
    current.html.push(`<p>${text}</p>`);
  }
  sections.push(current);
  return sections;
}

// ── Page shell ──
function head({ title, description, path, extraHead = '' }) {
  const url = SITE + '/' + path;
  return `<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<title>${esc(title)}</title>
<meta name="description" content="${esc(description)}">
<meta name="theme-color" content="#0B0B0C">
<link rel="canonical" href="${url}">
<link rel="icon" href="favicon.svg" type="image/svg+xml">
<link rel="apple-touch-icon" href="apple-touch-icon.png">
<meta property="og:type" content="website">
<meta property="og:site_name" content="Gymologia">
<meta property="og:title" content="${esc(title)}">
<meta property="og:description" content="${esc(description)}">
<meta property="og:url" content="${url}">
<meta property="og:image" content="${SITE}/og.png">
<meta property="og:image:width" content="1200">
<meta property="og:image:height" content="630">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:image" content="${SITE}/og.png">
${extraHead}`;
}

// ── Home ──
const home = readFileSync(join(here, 'home.html'), 'utf8');
const cut = home.indexOf('<div class="grain"');
if (cut < 0) throw new Error('home.html: body start marker not found');
const homeHead = home.slice(0, cut)
  .replace(/<title>[\s\S]*?<\/title>\s*/, '')
  .replace(/<meta name="description"[^>]*>\s*/, '');
const homeBody = home.slice(cut);
const homeTitle = 'Gymologia: gym app for members and gym owners in India';
const homeDesc = 'Find a gym near you and track your training. Run your gym\'s members, staff, attendance, leave, events and chat from one app. Made by Ganda Group Technologies.';
const jsonLd = {
  '@context': 'https://schema.org',
  '@type': 'SoftwareApplication',
  name: 'Gymologia',
  operatingSystem: 'Android',
  applicationCategory: 'HealthApplication',
  description: homeDesc,
  publisher: { '@type': 'Organization', name: 'Ganda Group Technologies' },
  offers: [
    { '@type': 'Offer', name: 'Basic', price: '599', priceCurrency: 'INR' },
    { '@type': 'Offer', name: 'Pro', price: '1199', priceCurrency: 'INR' },
  ],
};
writeFileSync(join(out, 'index.html'),
  head({ title: homeTitle, description: homeDesc, path: '',
    extraHead: `<script type="application/ld+json">${JSON.stringify(jsonLd)}</script>\n` })
  + homeHead + '</head>\n<body>\n' + homeBody + '\n</body>\n</html>\n');

// ── Legal pages ──
const FONTS = `<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Barlow+Condensed:ital,wght@0,700;0,800;0,900;1,900&family=Barlow:wght@400;500;600&display=swap">`;

const PAGE_CSS = `<style>
:root {
  --ink: #0B0B0C; --iron: #141416; --line: #2A2B2E; --chalk: #F4F4EE; --dust: #A3A59A; --volt: #C6FF00;
  --display: "Barlow Condensed", "Arial Narrow", "Roboto Condensed", sans-serif;
  --body: "Barlow", "Segoe UI", system-ui, -apple-system, sans-serif;
  --gutter: clamp(16px, 4vw, 48px);
  color-scheme: dark;
}
* { box-sizing: border-box; }
body { margin: 0; background: var(--ink); color: var(--chalk); font-family: var(--body); font-size: 17px; line-height: 1.65; -webkit-font-smoothing: antialiased; }
a { color: var(--volt); }
:focus-visible { outline: 3px solid var(--volt); outline-offset: 3px; border-radius: 6px; }
::selection { background: var(--volt); color: var(--ink); }
.wrap { width: 100%; max-width: 1180px; margin-inline: auto; padding-inline: var(--gutter); }
.nav { position: sticky; top: env(safe-area-inset-top, 0px); z-index: 10; background: color-mix(in srgb, var(--ink) 85%, transparent); backdrop-filter: blur(14px); -webkit-backdrop-filter: blur(14px); border-bottom: 1px solid var(--line); }
.nav .wrap { display: flex; align-items: center; justify-content: space-between; gap: 16px; padding-block: 14px; }
.brand { display: flex; align-items: center; gap: 12px; text-decoration: none; color: var(--chalk); }
.tile { width: 40px; height: 40px; border-radius: 12px; background: var(--volt); display: grid; place-items: center; flex: none; }
.tile svg { width: 25px; height: 25px; color: var(--ink); }
.brand b { font-family: var(--display); font-weight: 900; font-style: italic; font-size: 24px; letter-spacing: .02em; }
.back { font-family: var(--display); font-weight: 700; text-transform: uppercase; letter-spacing: .08em; font-size: 15px; color: var(--dust); text-decoration: none; }
.back:hover { color: var(--chalk); }
.doc { display: grid; grid-template-columns: 240px minmax(0, 1fr); gap: clamp(28px, 5vw, 72px); padding-block: clamp(40px, 7vw, 90px); }
.doc-head { grid-column: 1 / -1; display: grid; gap: 14px; border-bottom: 1px solid var(--line); padding-bottom: 28px; }
.eyebrow { font-family: var(--display); font-weight: 700; text-transform: uppercase; letter-spacing: .14em; font-size: 15px; color: var(--volt); }
h1 { font-family: var(--display); font-weight: 900; font-style: italic; text-transform: uppercase; font-size: clamp(48px, 8vw, 104px); line-height: .9; margin: 0; text-wrap: balance; }
.meta { color: var(--dust); font-size: 15px; margin: 0; }
.toc { position: sticky; top: 96px; align-self: start; display: grid; gap: 2px; font-size: 15px; }
.toc b { font-family: var(--display); font-weight: 800; text-transform: uppercase; letter-spacing: .12em; font-size: 13px; color: var(--dust); margin-bottom: 8px; }
.toc a { color: var(--dust); text-decoration: none; padding: 5px 0 5px 12px; border-left: 2px solid var(--line); }
.toc a:hover { color: var(--chalk); border-left-color: var(--volt); }
.body { max-width: 68ch; min-width: 0; }
.body section { scroll-margin-top: 90px; padding-block: 6px 18px; }
.body h2 { font-family: var(--display); font-weight: 800; text-transform: uppercase; letter-spacing: .02em; font-size: clamp(24px, 3vw, 32px); line-height: 1.05; margin: 22px 0 10px; text-wrap: balance; }
.body p { margin: 0 0 14px; color: #D9DBD2; }
.body ol { padding-left: 22px; color: #D9DBD2; }
.body li { margin-bottom: 10px; }
.callout { border: 1px solid var(--line); border-left: 3px solid var(--volt); background: var(--iron); border-radius: 12px; padding: 16px 18px; margin: 0 0 18px; }
.callout p:last-child { margin-bottom: 0; }
footer { border-top: 1px solid var(--line); padding-block: 30px; color: var(--dust); font-size: 14px; }
footer .wrap { display: flex; flex-wrap: wrap; gap: 14px 28px; justify-content: space-between; }
footer nav { display: flex; flex-wrap: wrap; gap: 10px 22px; }
footer nav a { color: var(--chalk); text-decoration: none; border-bottom: 1px solid var(--line); }
footer nav a:hover { color: var(--volt); border-color: var(--volt); }
@media (max-width: 860px) { .doc { grid-template-columns: minmax(0, 1fr); } .toc { position: static; } }
</style>`;

const LOGO = `<span class="tile"><svg viewBox="0 0 64 64" aria-hidden="true"><g fill="currentColor" transform="rotate(-12 32 32)"><rect x="6" y="20" width="7" height="24" rx="3"/><rect x="14" y="14" width="8" height="36" rx="3.5"/><rect x="42" y="14" width="8" height="36" rx="3.5"/><rect x="51" y="20" width="7" height="24" rx="3"/><rect x="21" y="29" width="22" height="6" rx="2"/></g></svg></span>`;

const NAV = `<nav class="nav" aria-label="Main"><div class="wrap">
  <a class="brand" href="./" aria-label="Gymologia home">${LOGO}<b>GYMOLOGIA</b></a>
  <a class="back" href="./">Back to home</a>
</div></nav>`;

const FOOTER = `<footer><div class="wrap">
  <span>© 2026 Ganda Group Technologies. Gymologia is made by Ganda Group Technologies, India.</span>
  <nav aria-label="Legal"><a href="privacy.html">Privacy Policy</a><a href="terms.html">Terms of Use</a><a href="delete-account.html">Delete your account</a><a href="mailto:${SUPPORT_EMAIL}">${SUPPORT_EMAIL}</a></nav>
</div></footer>`;

function page({ file, title, description, eyebrow, heading, meta, sections, intro = '' }) {
  const toc = sections.filter((s) => s.heading)
    .map((s) => `<a href="#${slugify(s.heading)}">${esc(sentenceCase(s.heading))}</a>`).join('\n');
  const body = sections.map((s) => s.heading
    ? `<section id="${slugify(s.heading)}"><h2>${esc(sentenceCase(s.heading))}</h2>${s.html.join('\n')}</section>`
    : `<section>${s.html.join('\n')}</section>`).join('\n');
  writeFileSync(join(out, file),
    head({ title, description, path: file }) + FONTS + '\n' + PAGE_CSS + '\n</head>\n<body>\n' + NAV + `
<main class="wrap doc">
  <header class="doc-head">
    <span class="eyebrow">${esc(eyebrow)}</span>
    <h1>${esc(heading)}</h1>
    <p class="meta">${meta}</p>
  </header>
  <nav class="toc" aria-label="On this page"><b>On this page</b>${toc}</nav>
  <article class="body">${intro}${body}</article>
</main>
` + FOOTER + '\n</body>\n</html>\n');
}

for (const [slug, file, description] of [
  ['privacy', 'privacy.html', 'What Gymologia collects, why, who can see it, how long it is kept, and your rights under the DPDP Act 2023.'],
  ['terms', 'terms.html', 'The terms for using Gymologia, the gym app for members, gym owners and staff, operated by Ganda Group Technologies.'],
]) {
  const doc = legalDoc(slug);
  page({
    file,
    title: `${doc.title} | Gymologia`,
    description,
    eyebrow: 'Gymologia · Ganda Group Technologies',
    heading: doc.title,
    meta: `Last updated ${longDate(doc.updatedAt)} · Version ${esc(LEGAL_VERSION)} · This is the same text shown in the Gymologia apps.`,
    sections: renderLegal(doc.body),
  });
}

// ── Delete your account (the link Google Play asks for) ──
const p = (t) => `<p>${t}</p>`;
page({
  file: 'delete-account.html',
  title: 'Delete your Gymologia account',
  description: 'How to delete your Gymologia or Gymologia Referral account, what is deleted, and what is kept and for how long.',
  eyebrow: 'Gymologia · Ganda Group Technologies',
  heading: 'Delete your account',
  meta: `Applies to the Gymologia app and the Gymologia Referral app, both by Ganda Group Technologies.`,
  intro: `<div class="callout">${p('You can delete your account yourself in the app. It takes under a minute, and you can change your mind for 30 days.')}</div>`,
  sections: [
    { heading: 'IN THE APP', html: [`<ol>
<li>Open Gymologia (or Gymologia Referral) and sign in with your phone number.</li>
<li>Go to <b>Settings</b> and tap <b>Delete account</b>.</li>
<li>Read what will be removed, then tap <b>Delete my account</b>.</li>
</ol>`, p('Your account stays usable for 30 days. During that time you can cancel the deletion from the same screen. After 30 days it is deleted and cannot be brought back.'),
      p('If you own a gym on Gymologia, delete the gym first (Gym profile, then Delete). Its members and staff are told the gym has closed.'),
      p('Want a copy first? Settings has <b>Download my data</b>, which gives you everything we hold about your account.')] },
    { heading: 'IF YOU CANNOT USE THE APP', html: [
      p(`Email <a href="mailto:${SUPPORT_EMAIL}">${SUPPORT_EMAIL}</a> with the subject "Delete my account", from the email address on your account, or tell us the phone number on the account. We will confirm it is you through that number before deleting anything, and reply within 30 days.`)] },
    { heading: 'WHAT IS DELETED', html: [
      p('Your name, email, age and phone number are removed from the account, which is anonymised. Your weight and height history is deleted. You are signed out of every device, and your gym memberships and staff roles end.'),
      p('Referral earnings that have not been paid out yet are lost, so withdraw them first.')] },
    { heading: 'WHAT IS KEPT, AND FOR HOW LONG', html: [
      p('Some records must be kept by law or to protect other people, without your name attached where possible:'),
      `<ol>
<li>Attendance and membership records your gym keeps: 7 years after the membership ends.</li>
<li>Payment and tax records: as long as Indian tax law requires (currently 8 years from the year of assessment).</li>
<li>Security and audit logs: 3 years.</li>
</ol>`,
      p('The <a href="privacy.html#how-long-we-keep-it">Privacy Policy</a> lists every category.')] },
  ],
});

// ── robots and sitemap ──
writeFileSync(join(out, 'robots.txt'), `User-agent: *\nAllow: /\nSitemap: ${SITE}/sitemap.xml\n`);
const today = new Date().toISOString().slice(0, 10);
writeFileSync(join(out, 'sitemap.xml'), `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
${['', 'privacy.html', 'terms.html', 'delete-account.html'].map((u) => `  <url><loc>${SITE}/${u}</loc><lastmod>${today}</lastmod></url>`).join('\n')}
</urlset>
`);

console.log(`Built ${out} (legal version ${LEGAL_VERSION})`);
