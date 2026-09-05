import {
  CanActivate,
  ExecutionContext,
  HttpException,
  HttpStatus,
  Injectable,
} from '@nestjs/common';
import { Request } from 'express';

import { IpBlockService } from './ip-block.service';

/**
 * Refuses callers that have earned a temporary block.
 *
 * Registered before every other guard so a blocked address costs a lookup
 * in a Map and nothing else -- no throttler bookkeeping, no token
 * verification, no database. That ordering is the point: the reason to
 * block an attacker is to stop paying for them.
 *
 * 429 rather than 403, and with Retry-After. 403 says "you may not do
 * this", which would be a lie -- the caller may, in a quarter of an hour.
 * A client that reads the header backs off correctly, and a human reading
 * the response is told what actually happened.
 *
 * This depends on `req.ip` being truthful, which depends in turn on
 * `app.set('trust proxy', 1)` in main.ts matching the deployment. Behind
 * exactly one proxy it is right. Deployed with no proxy in front, a
 * client can set X-Forwarded-For and choose its own address -- which lets
 * an attacker both evade a block and get somebody else blocked. So: keep
 * a proxy in front, or drop the trust setting to 0. This guard is one
 * layer, not the only one; the rate limits and the auth checks behind it
 * do not depend on the address at all.
 */
@Injectable()
export class IpBlockGuard implements CanActivate {
  constructor(private readonly blocks: IpBlockService) {}

  canActivate(context: ExecutionContext): boolean {
    if (context.getType() !== 'http') return true;

    const http = context.switchToHttp();
    const request = http.getRequest<Request>();
    const left = this.blocks.retryAfterMs(request.ip);
    if (left <= 0) return true;

    const seconds = Math.ceil(left / 1000);

    // On the header, not in the body. The exception filter normalises
    // every error into one shape, so an extra field added to the payload
    // here is dropped before the client ever sees it -- this said it sent
    // an honest Retry-After while sending nothing of the kind. A header
    // survives the filter, and Retry-After is the field an HTTP client
    // already knows how to obey.
    const response = http.getResponse<{ setHeader?: (k: string, v: string) => void }>();
    response.setHeader?.('Retry-After', String(seconds));

    throw new HttpException(
      'Too many suspicious requests from this address. Try again shortly.',
      HttpStatus.TOO_MANY_REQUESTS,
      { cause: new Error('ip blocked') },
    );
  }
}
