/**
 * The shared look for Gymologia's public web pages -- delete-account,
 * terms, privacy. These are the only parts of the product a person can
 * open without the app installed (an app-store reviewer, someone who
 * uninstalled and wants their data gone), so they are the one place a
 * generic-looking government-form page would actually cost us: it is the
 * first or only impression some readers get.
 *
 * One shared shell, not three copies of the same CSS, so a colour or
 * spacing change made here is made everywhere at once.
 */

/** Same seed as apps/gymologia/lib/theme.dart -- one brand colour, everywhere. */
export const BRAND_COLOR = '#E8452C';

export function escapeHtml(s: string): string {
  return s
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;');
}

const SHARED_STYLE = `
  :root { color-scheme: light dark; }
  * { box-sizing: border-box; }
  body {
    margin: 0; padding: 0 16px 64px;
    font: 16px/1.6 system-ui, -apple-system, "Segoe UI", Roboto, sans-serif;
    background: #fff; color: #16181d;
  }
  main { max-width: 34rem; margin: 0 auto; }
  header.brand {
    display: flex; align-items: center; gap: .6rem;
    padding: 1.6rem 0 .4rem;
  }
  header.brand .mark {
    width: 34px; height: 34px; border-radius: 9px;
    background: ${BRAND_COLOR}; color: #fff;
    display: flex; align-items: center; justify-content: center;
    font-weight: 800; font-size: 1.05rem; flex: none;
  }
  header.brand .name { font-weight: 800; font-size: 1.15rem; letter-spacing: -.01em; }
  h1 { font-size: 1.5rem; margin: .6rem 0 .25rem; }
  h2 { font-size: 1.02rem; margin: 1.9rem 0 .5rem; letter-spacing: .01em; }
  p { margin: .6rem 0; }
  .sub { color: #5c6270; margin-top: 0; }
  .updated { color: #5c6270; font-size: .85rem; margin: -.2rem 0 1.2rem; }
  label { display: block; font-weight: 600; margin: 1rem 0 .3rem; font-size: .9rem; }
  input {
    width: 100%; padding: .7rem .8rem; font-size: 1rem;
    border: 1px solid #c3c8d2; border-radius: 8px;
    background: #fff; color: inherit;
  }
  button {
    width: 100%; margin-top: 1rem; padding: .8rem;
    font-size: 1rem; font-weight: 600; border: 0; border-radius: 8px;
    background: ${BRAND_COLOR}; color: #fff; cursor: pointer;
  }
  button.danger { background: #c4341c; }
  button[disabled] { opacity: .55; cursor: default; }
  ul { padding-left: 1.2rem; }
  li { margin: .3rem 0; }
  .card {
    border: 1px solid #e0e3ea; border-radius: 10px;
    padding: 1rem 1.1rem; margin-top: 1rem; background: #f8f9fb;
  }
  .warn { border-color: #e8bfb6; background: #fdf4f2; }
  .msg { margin-top: 1rem; font-weight: 600; }
  .err { color: #b3301a; }
  .ok { color: #1a7a42; }
  .hidden { display: none; }
  footer { margin-top: 2.5rem; font-size: .85rem; color: #5c6270; }
  footer nav { margin-bottom: .5rem; }
  footer nav a { margin-right: 1rem; }
  a { color: ${BRAND_COLOR}; }
  @media (prefers-color-scheme: dark) {
    body { background: #14161a; color: #e7e9ee; }
    input { background: #1c1f25; border-color: #333944; }
    .card { background: #1a1d23; border-color: #2a2f38; }
    .warn { background: #2a1c19; border-color: #5c3128; }
    .sub, .updated, footer { color: #9aa2b1; }
  }
`;

/** The wordmark used at the top of every one of these pages. */
export function brandHeader(): string {
  return `<header class="brand"><span class="mark">G</span><span class="name">Gymologia</span></header>`;
}

/**
 * The footer every one of these pages shares -- a way back to the other
 * two, and the one support address that answers all of them.
 */
export function brandFooter(currentPath: '/delete-account' | '/terms' | '/privacy'): string {
  const links: Array<{ href: '/terms' | '/privacy' | '/delete-account'; label: string }> = [
    { href: '/terms', label: 'Terms of Use' },
    { href: '/privacy', label: 'Privacy Policy' },
    { href: '/delete-account', label: 'Delete account' },
  ];
  const nav = links
    .filter((l) => l.href !== currentPath)
    .map((l) => `<a href="${l.href}">${l.label}</a>`)
    .join('');
  return `<footer><nav>${nav}</nav>Questions? Email <a href="mailto:support@gymologia.com">support@gymologia.com</a>.</footer>`;
}

export function brandPage(opts: {
  title: string;
  bodyHtml: string;
  extraStyle?: string;
}): string {
  return `<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="robots" content="noindex">
<title>${escapeHtml(opts.title)}</title>
<style>${SHARED_STYLE}${opts.extraStyle ?? ''}</style>
</head>
<body>
<main>
${brandHeader()}
${opts.bodyHtml}
</main>
</body>
</html>`;
}
