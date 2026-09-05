import { Injectable, Logger } from '@nestjs/common';
import { AppClient, Prisma } from '@prisma/client';
import { PrismaService } from '../../prisma/prisma.service';
import { redactSnapshot } from './redact';

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
          before: redactSnapshot(input.before) as Prisma.InputJsonValue | undefined,
          after: redactSnapshot(input.after) as Prisma.InputJsonValue | undefined,
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

}
