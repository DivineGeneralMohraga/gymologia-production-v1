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
 * APPEND-ONLY IS NOW ALSO A PROPERTY OF THE DATABASE, WITH ONE HONEST
 * CAVEAT. Migration `20260921_append_only_triggers` added BEFORE
 * UPDATE/DELETE/TRUNCATE triggers on audit_logs that raise an exception
 * for any role, including the table owner. Verified live, not assumed:
 * a direct UPDATE and DELETE against a real row both failed with
 * Postgres error 42501, and TRUNCATE failed the same way, while ordinary
 * `.create()` inserts through this service kept working.
 *
 * The app's runtime role (`postgres`) is not a Postgres superuser --
 * rolsuper is false, it only carries rolbypassrls -- so it cannot use
 * `SET session_replication_role = replica` to silently disable triggers;
 * that command itself needs superuser here. What it CAN still do, because
 * it owns the table, is run `ALTER TABLE audit_logs DISABLE TRIGGER ...`
 * or `DROP TRIGGER`. That remains true and is the honest limit of this
 * approach: it stops every ordinary write path -- a bug, a careless
 * migration, a credential riding the existing connection -- but not a
 * deliberate, privileged actor willing to issue that specific ALTER
 * statement first. Removing that last gap needs a second, genuinely
 * restricted role (INSERT + SELECT only, no ownership, no ALTER) that the
 * app would have to connect through for this table specifically -- a
 * separate piece of infrastructure work, not a trigger.
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
