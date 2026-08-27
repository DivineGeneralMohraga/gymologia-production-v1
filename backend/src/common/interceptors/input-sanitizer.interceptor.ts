import {
  CallHandler,
  ExecutionContext,
  Injectable,
  NestInterceptor,
} from '@nestjs/common';
import type { Request } from 'express';
import { Observable } from 'rxjs';
import { SecurityEventService } from '../security/security-event.service';

/**
 * Patterns that have no business appearing in a gym app's input. This is
 * NOT the SQL-injection defence — Prisma's parameterized queries are, and
 * they hold regardless of what arrives here. This layer exists to notice
 * that somebody is *trying*, so the account and IP surface in the admin
 * app's security log before they find something that does work.
 */
const PROBE_PATTERNS: Array<{ name: string; re: RegExp }> = [
  {
    name: 'sql-tautology',
    re: /(\b(or|and)\b\s+['"]?\d+['"]?\s*=\s*['"]?\d+)/i,
  },
  {
    name: 'sql-keyword-chain',
    re: /\b(union\s+select|drop\s+table|insert\s+into|delete\s+from|truncate\s+table|alter\s+table)\b/i,
  },
  { name: 'sql-comment', re: /(--\s|\/\*|\*\/|;\s*--)/ },
  { name: 'sql-sleep', re: /\b(sleep|pg_sleep|benchmark|waitfor\s+delay)\s*\(/i },
  { name: 'script-injection', re: /<script\b|javascript:|onerror\s*=|onload\s*=/i },
  { name: 'template-injection', re: /\$\{.*\}|\{\{.*\}\}/ },
  { name: 'path-traversal', re: /\.\.[/\\]{1,2}(\.\.[/\\]{1,2})*(etc|windows|proc)\b/i },
  { name: 'nosql-operator', re: /"\$(where|ne|gt|lt|regex|expr)"\s*:/i },
];

/** Fields whose values are never inspected or logged. */
const SKIP_FIELDS = new Set([
  'password',
  'code',
  'accessToken',
  'refreshToken',
  'registrationToken',
  'ciphertext',
  'publicKey',
  'signedPreKey',
]);

const MAX_DEPTH = 8;
const MAX_STRING_SAMPLE = 400;

/**
 * Watches request bodies and query strings for attack signatures and
 * records what it sees. It observes rather than blocks: a false positive
 * that rejects a legitimate gym description ("Perks: 24/7 access -- best
 * rates") would be a worse outcome than a logged event nobody acts on.
 * Genuine blocking happens at the throttler and the WAF.
 */
@Injectable()
export class InputSanitizerInterceptor implements NestInterceptor {
  constructor(private readonly securityEvents: SecurityEventService) {}

  intercept(context: ExecutionContext, next: CallHandler): Observable<unknown> {
    const request = context.switchToHttp().getRequest<Request & { user?: { userId: string } }>();

    const findings = [
      ...this.scan(request.body, 'body'),
      ...this.scan(request.query, 'query'),
    ];

    if (findings.length > 0) {
      void this.securityEvents.record({
        type: 'INJECTION_ATTEMPT',
        severity: findings.length > 2 ? 'HIGH' : 'MEDIUM',
        userId: request.user?.userId ?? null,
        ip: request.ip ?? null,
        userAgent: request.get('user-agent') ?? null,
        route: request.route?.path ?? request.url,
        details: { findings: findings.slice(0, 10) },
        actionTaken: 'logged; request allowed (queries are parameterized)',
      });
    }

    return next.handle();
  }

  private scan(
    value: unknown,
    path: string,
    depth = 0,
  ): Array<{ field: string; pattern: string; sample: string }> {
    if (depth > MAX_DEPTH || value === null || value === undefined) return [];

    if (typeof value === 'string') {
      const hits: Array<{ field: string; pattern: string; sample: string }> = [];
      for (const { name, re } of PROBE_PATTERNS) {
        if (re.test(value)) {
          hits.push({
            field: path,
            pattern: name,
            sample: value.slice(0, MAX_STRING_SAMPLE),
          });
        }
      }
      return hits;
    }

    if (Array.isArray(value)) {
      return value
        .slice(0, 50)
        .flatMap((item, i) => this.scan(item, `${path}[${i}]`, depth + 1));
    }

    if (typeof value === 'object') {
      return Object.entries(value as Record<string, unknown>).flatMap(
        ([key, val]) =>
          SKIP_FIELDS.has(key) ? [] : this.scan(val, `${path}.${key}`, depth + 1),
      );
    }

    return [];
  }
}
