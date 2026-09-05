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
 * subscription changes, payouts. There is no update or delete path in this
 * service, and nothing else in the codebase writes to the table.
 *
 * APPEND-ONLY IS A PROPERTY OF THIS CODE, NOT OF THE DATABASE. This
 * comment used to claim "the runtime DB role is granted INSERT and SELECT
 * on audit_logs only", and that was simply untrue. Checked against the
 * live database rather than assumed:
 *
 *   current_user                                    -> postgres
 *   tableowner of audit_logs                        -> postgres
 *   has_table_privilege(..., 'UPDATE' / 'DELETE')   -> true, true
 *
 * The application connects as the owner of the table and can rewrite or
 * empty it at will. Nothing does, but "nobody can" and "nothing does" are
 * different promises, and only the second one is being kept. That matters
 * before anyone repeats the stronger version in a compliance
 * conversation, where an append-only trail is taken to mean tamper
 * evidence rather than good manners.
 *
 * Making it true is not a one-line change, and the reason is worth
 * recording. Row level security is enabled on every table with no
 * policies, which the application survives only because `postgres` has
 * rolbypassrls. A restricted role with INSERT and SELECT on audit_logs
 * would need BYPASSRLS as well, or every query in the product stops
 * working the moment the connection string changes. That is a deliberate
 * piece of infrastructure work, not a tidy-up.
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
