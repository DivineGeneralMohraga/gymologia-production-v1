import { Injectable, Logger } from '@nestjs/common';
import { Prisma, SecurityEventType, Severity } from '@prisma/client';
import { PrismaService } from '../../prisma/prisma.service';

export interface SecurityEventInput {
  type: keyof typeof SecurityEventType;
  severity?: keyof typeof Severity;
  userId?: string | null;
  ip?: string | null;
  userAgent?: string | null;
  route?: string | null;
  details?: Prisma.InputJsonValue;
  actionTaken?: string | null;
}

/**
 * The defensive telemetry sink.
 *
 * Everything suspicious lands here: OTP farming, brute force, permission
 * probing, webhook signatures that do not verify, payout velocity spikes,
 * injection signatures in input. Two consumers read it — the admin app's
 * log viewer, and the throttling logic that decides whether an IP or an
 * account has earned a temporary block.
 *
 * Recording is deliberately fire-and-forget: a failure to write telemetry
 * must never turn into a failure of the request being protected.
 */
@Injectable()
export class SecurityEventService {
  private readonly logger = new Logger(SecurityEventService.name);

  constructor(private readonly prisma: PrismaService) {}

  async record(input: SecurityEventInput): Promise<void> {
    try {
      await this.prisma.securityEvent.create({
        data: {
          type: SecurityEventType[input.type],
          severity: Severity[input.severity ?? 'LOW'],
          userId: input.userId ?? null,
          ip: this.truncate(input.ip, 64),
          userAgent: this.truncate(input.userAgent, 300),
          route: this.truncate(input.route, 200),
          details: input.details,
          actionTaken: this.truncate(input.actionTaken, 200),
        },
      });

      if (input.severity === 'HIGH' || input.severity === 'CRITICAL') {
        this.logger.warn(
          `security:${input.type} severity=${input.severity} ip=${input.ip ?? '-'} user=${input.userId ?? '-'}`,
        );
      }
    } catch (error) {
      // Never let telemetry break the request it is observing.
      this.logger.error(
        `Failed to record security event ${input.type}: ${(error as Error).message}`,
      );
    }
  }

  /**
   * How many events of a type came from one IP inside a window. Used to
   * escalate from "log it" to "block it" — for example, five failed OTP
   * verifications from one address inside ten minutes.
   */
  async countRecent(
    type: keyof typeof SecurityEventType,
    windowMinutes: number,
    where: { ip?: string; userId?: string },
  ): Promise<number> {
    const since = new Date(Date.now() - windowMinutes * 60_000);
    return this.prisma.securityEvent.count({
      where: {
        type: SecurityEventType[type],
        createdAt: { gte: since },
        ...(where.ip ? { ip: where.ip } : {}),
        ...(where.userId ? { userId: where.userId } : {}),
      },
    });
  }

  private truncate(value: string | null | undefined, max: number): string | null {
    if (!value) return null;
    return value.length > max ? value.slice(0, max) : value;
  }
}
