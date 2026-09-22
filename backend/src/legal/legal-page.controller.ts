import { Controller, Get, NotFoundException, Res } from '@nestjs/common';
import { ApiExcludeController } from '@nestjs/swagger';
import type { Response } from 'express';

import { Public } from '../rbac/rbac.decorators';
import { brandFooter, brandPage, escapeHtml } from '../common/web/brand-page';
import { LEGAL_DOCUMENTS, LegalDocument } from './legal.content';

/**
 * Terms of Use and Privacy Policy as actual web pages.
 *
 * `GET /legal/:slug` (LegalController) already serves this content as
 * JSON for the app's own in-app screen. This is the other consumer of the
 * same source of truth: a plain URL that opens in a browser with nothing
 * installed, because both app stores' listing forms ask for one and an app
 * reviewer or a prospective user has to be able to read it before they
 * have the app at all.
 *
 * Deliberately outside the API prefix, same reasoning as delete-account:
 * `gymologia.com/privacy` reads as a policy, not an endpoint.
 */
@ApiExcludeController()
@Public()
@Controller()
export class LegalPageController {
  @Get('terms')
  terms(@Res() res: Response): void {
    this.render(res, 'terms', '/terms');
  }

  @Get('privacy')
  privacy(@Res() res: Response): void {
    this.render(res, 'privacy', '/privacy');
  }

  private render(
    res: Response,
    slug: string,
    path: '/terms' | '/privacy',
  ): void {
    const doc = LEGAL_DOCUMENTS[slug];
    if (!doc) throw new NotFoundException('No such document');

    res.setHeader(
      'Content-Security-Policy',
      [
        "default-src 'none'",
        "script-src 'none'",
        "style-src 'unsafe-inline'",
        "base-uri 'none'",
        "form-action 'none'",
      ].join('; '),
    );
    res.setHeader('Content-Type', 'text/html; charset=utf-8');
    res.setHeader('Referrer-Policy', 'no-referrer');
    res.send(page(doc, path));
  }
}

/**
 * The document body is plain text: paragraphs separated by a blank line,
 * headings a single ALL-CAPS line at the start of a block. That format is
 * what makes it readable as source and safe to re-flow for the in-app
 * screen; here it becomes real headings and paragraphs instead of one
 * long unbroken block a reader has to parse themselves.
 */
function renderBody(body: string): string {
  const blocks = body.trim().split(/\n{2,}/);
  return blocks
    .map((block) => {
      const lines = block.split('\n').map((l) => l.trim());
      const [first, ...rest] = lines;
      const isHeading = /^[A-Z0-9][A-Z0-9 '&,.:-]*$/.test(first) && rest.length > 0;
      if (isHeading) {
        return `<h2>${escapeHtml(first)}</h2><p>${linkify(rest.join(' '))}</p>`;
      }
      return `<p>${linkify(lines.join(' '))}</p>`;
    })
    .join('\n');
}

function linkify(text: string): string {
  // The domain is matched as repeated (dot + label) groups rather than a
  // flat [\w.-]+ class, so a sentence-ending period right after the TLD
  // (".com. We may...") is never pulled into the address.
  return escapeHtml(text).replace(
    /[\w.+-]+@[\w-]+(?:\.[\w-]+)+/g,
    (email) => `<a href="mailto:${email}">${email}</a>`,
  );
}

function page(doc: LegalDocument, path: '/terms' | '/privacy'): string {
  return brandPage({
    title: `${doc.title} — Gymologia`,
    bodyHtml: `
  <h1>${escapeHtml(doc.title)}</h1>
  <p class="updated">Version ${escapeHtml(doc.version)} · updated ${escapeHtml(doc.updatedAt)}</p>
  ${renderBody(doc.body)}
  ${brandFooter(path)}`,
  });
}
