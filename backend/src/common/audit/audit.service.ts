import { Injectable, Logger } from '@nestjs/common';
import { AppClient, Prisma } from '@prisma/client';
import { PrismaService } from '../../prisma/prisma.service';

export interface AuditInput {
  actorId?: string | null;
  gymId?: string | null;
  /** Dotted verb, e.g. "leave.override", "role.permission.grant". */
  action: string;
  entityType: string;
  entityId?: string | null;
  before?: unknown;
  after?: unknown;
  ip?: string | null;
  userAgent?: string | null;
  appClient?: AppClient | null;
}

/**
 * Keys whose values must never reach the audit table. Snapshots run
 * through a redactor before they are written, because "before/after" on a
 * KYC update would otherwise be the one place raw Aadhaar numbers sit in
 * plain text.
 */
const REDACTED_KEYS = new Set([
  'aadhaar',
  'aadhaarenc',
  'pan',
  'panenc',
  'gstin',
  'gstinenc',
  'upiid',
  'upiidenc',
  'codehash',
  'tokenhash',
  'salt',
  'ciphertext',
  'password',
  'accesstoken',
  'refreshtoken',
  'clientsecret',
  'authkey',
]);

/**
 * Append-only record of who did what.
 *
 * Every state change that a human could later dispute goes through here:
 * attendance edits, leave overrides, permission grants, member removals,
 * subscription changes, payouts. There is no update or delete path, and
 * the runtime DB role is granted INSERT and SELECT on audit_logs only.
 */
@Injectable()
export class AuditService {
  private readonly logger = new Logger(AuditService.name);

  constructor(private readonly prisma: PrismaService) {}

  async record(input: AuditInput): Promise<void> {
    try {
      await this.prisma.auditLog.create({
        data: {
          actorId: input.actorId ?? null,
          gymId: input.gymId ?? null,
          action: input.action.slice(0, 80),
          entityType: input.entityType.slice(0, 60),
          entityId: input.entityId?.slice(0, 64) ?? null,
          before: this.redact(input.before),
          after: this.redact(input.after),
          ip: input.ip?.slice(0, 64) ?? null,
          userAgent: input.userAgent?.slice(0, 300) ?? null,
          appClient: input.appClient ?? null,
        },
      });
    } catch (error) {
      // An audit write failing must not roll back the business action, but
      // it is loud, because a silent gap in the trail is the worst outcome.
      this.logger.error(
        `AUDIT WRITE FAILED action=${input.action} entity=${input.entityType}:${input.entityId} — ${(error as Error).message}`,
      );
    }
  }

  /** Recursively replaces sensitive values with a marker. */
  private redact(value: unknown): Prisma.InputJsonValue | undefined {
    if (value === undefined || value === null) return undefined;

    const walk = (node: unknown, depth: number): unknown => {
      if (depth > 6) return '[depth-limit]';
      if (node === null || typeof node !== 'object') return node;
      if (node instanceof Date) return node.toISOString();
      if (Array.isArray(node)) return node.slice(0, 50).map((v) => walk(v, depth + 1));

      const out: Record<string, unknown> = {};
      for (const [key, val] of Object.entries(node as Record<string, unknown>)) {
        out[key] = REDACTED_KEYS.has(key.toLowerCase())
          ? '[redacted]'
          : walk(val, depth + 1);
      }
      return out;
    };

    return walk(value, 0) as Prisma.InputJsonValue;
  }
}
