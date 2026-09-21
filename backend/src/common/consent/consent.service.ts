import { Injectable, Logger } from '@nestjs/common';
import { ConsentPurpose, Prisma } from '@prisma/client';
import { PrismaService } from '../../prisma/prisma.service';

export interface ConsentInput {
  userId: string;
  purpose: ConsentPurpose;
  granted: boolean;
  version?: string | null;
  metadata?: Prisma.InputJsonValue | null;
  ip?: string | null;
  userAgent?: string | null;
}

/**
 * A queryable, per-purpose consent register — DPDP Act 2023 s.6, which
 * requires consent to be specific to a purpose rather than one blanket
 * "terms accepted" flag. Every call inserts a new row rather than updating
 * one: `granted: false` is written just like `granted: true`, so the
 * history of what someone agreed to and when they withdrew it survives.
 * The current state for a (userId, purpose) pair is simply its latest row.
 *
 * This does not replace the fields it grew out of — User.termsVersion,
 * Membership.allowProgressMonitoring — those remain the fast path the rest
 * of the product reads. This is the audit trail behind them.
 */
@Injectable()
export class ConsentService {
  private readonly logger = new Logger(ConsentService.name);

  constructor(private readonly prisma: PrismaService) {}

  async record(input: ConsentInput): Promise<void> {
    try {
      await this.prisma.consentRecord.create({
        data: {
          userId: input.userId,
          purpose: input.purpose,
          granted: input.granted,
          version: input.version ?? null,
          metadata: input.metadata ?? undefined,
          ip: input.ip?.slice(0, 64) ?? null,
          userAgent: input.userAgent?.slice(0, 300) ?? null,
        },
      });
    } catch (error) {
      // A missed consent row must never turn into a failed request — the
      // action it documents (accepting terms, toggling monitoring) has
      // already happened by the time this is called.
      this.logger.error(
        `Failed to record consent ${input.purpose} for ${input.userId}: ${(error as Error).message}`,
      );
    }
  }

  /** Full history for one user, newest first — used by the data export. */
  async history(userId: string) {
    return this.prisma.consentRecord.findMany({
      where: { userId },
      select: {
        purpose: true,
        granted: true,
        version: true,
        metadata: true,
        createdAt: true,
      },
      orderBy: { createdAt: 'desc' },
    });
  }
}
