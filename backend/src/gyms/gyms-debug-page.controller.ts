import { Controller, Get, Res } from '@nestjs/common';
import { ApiExcludeController } from '@nestjs/swagger';
import type { Response } from 'express';

import { Public } from '../rbac/rbac.decorators';
import { brandPage, escapeHtml } from '../common/web/brand-page';
import { GymsService } from './gyms.service';

/**
 * A same-origin page that calls search() directly and prints what it
 * gets back, no app involved.
 *
 * This exists to answer one question during the "the app shows no
 * gyms" investigation: does search() itself return anything, seen from
 * a client that isn't the Flutter app? A browser page hosted anywhere
 * else would hit main.ts's CORS allow-list (`*.gymologia.com` only in
 * production) before it even got this far, so this has to live on the
 * API's own origin to be useful.
 *
 * Temporary. Delete once the app-side bug is found -- this has no
 * reason to stay public afterwards.
 */
@ApiExcludeController()
@Public()
@Controller()
export class GymsDebugPageController {
  constructor(private readonly gyms: GymsService) {}

  @Get('debug/gyms')
  async page(@Res() res: Response): Promise<void> {
    let bodyHtml: string;
    try {
      const results = await this.gyms.search({});
      bodyHtml = `
  <h1>Gym search -- raw result</h1>
  <p class="sub">Calls the same search() the app calls, straight from the server. No CORS, no app, no client parsing.</p>
  <p class="updated">${results.length} gym(s) returned, fetched at ${escapeHtml(new Date().toISOString())}</p>
  ${
    results.length === 0
      ? '<div class="card warn"><strong>Zero gyms returned.</strong> If you expected some, the problem is server-side (data/eligibility), not the app.</div>'
      : results
          .map(
            (g) => `<div class="card">
      <strong>${escapeHtml(g.displayName)}</strong><br>
      ${escapeHtml(g.district)}, ${escapeHtml(g.state)} &middot; rating ${g.rating} (${g.ratingCount}) &middot; id ${escapeHtml(g.id)}
    </div>`,
          )
          .join('\n')
  }`;
    } catch (e) {
      bodyHtml = `
  <h1>Gym search -- raw result</h1>
  <div class="card warn"><strong>search() threw:</strong><br>${escapeHtml(String(e))}</div>`;
    }

    res.setHeader(
      'Content-Security-Policy',
      "default-src 'none'; script-src 'none'; style-src 'unsafe-inline'; base-uri 'none'; form-action 'none'",
    );
    res.setHeader('Content-Type', 'text/html; charset=utf-8');
    res.setHeader('Referrer-Policy', 'no-referrer');
    res.send(brandPage({ title: 'Gym search debug', bodyHtml }));
  }
}
