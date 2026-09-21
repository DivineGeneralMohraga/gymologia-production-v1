import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Prisma, SecurityEventType, Severity } from '@prisma/client';
import * as nodemailer from 'nodemailer';
import { PrismaService } from '../../prisma/prisma.service';
import { IpBlockService } from './ip-block.service';
import { decide, isExempt, ruleFor } from './ip-block.policy';

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
 * What lands here today: OTP farming and code guessing, tokens that do not
 * verify, permission probing, webhook signatures that fail, logins that
 * look out of character, and injection signatures in input. The enum also
 * carries RATE_LIMIT_TRIPPED, PAYOUT_VELOCITY, REFERRAL_FRAUD and
 * SUSPICIOUS_UPLOAD, and nothing writes any of them — they are room left
 * for later, not features. This comment used to list payout velocity as
 * though it were arriving.
 *
 * Two consumers read it — the admin app's log viewer, and the blocking
 * logic below, which decides whether an address has earned a temporary
 * refusal.
 *
 * That second consumer used to be a claim rather than a fact: this file
 * described it and exposed `countRecent` for it, and nothing in the
 * codebase called that method. Detection recorded; nothing acted.
 *
 * Recording is deliberately fire-and-forget: a failure to write telemetry
 * must never turn into a failure of the request being protected. The same
 * applies to the block evaluation that follows it — if counting throws,
 * the request carries on unblocked.
 */
@Injectable()
export class SecurityEventService {
  private readonly logger = new Logger(SecurityEventService.name);
  private readonly mailer: nodemailer.Transporter | null;
  private readonly alertTo: string;
  // One email per event type per window, so the exact moment an attack
  // produces the most HIGH/CRITICAL events is not also the moment the
  // alert inbox becomes useless.
  private readonly alertedRecently = new Map<string, number>();
  private static readonly ALERT_COOLDOWN_MS = 15 * 60_000;

  constructor(
    private readonly prisma: PrismaService,
    private readonly blocks: IpBlockService,
    config: ConfigService,
  ) {
    const host = config.get<string>('support.smtpHost', '');
    this.alertTo = config.get<string>('support.email', 'support@gymologia.com');
    this.mailer = host
      ? nodemailer.createTransport({
          host,
          port: config.get<number>('support.smtpPort', 587),
          auth: {
            user: config.get<string>('support.smtpUser', ''),
            pass: config.get<string>('support.smtpPass', ''),
          },
        })
      : null;
  }

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
        // DPDP Act s.8(6): potential breach events must reach a human.
        void this.sendAlert(input.type, input.severity, input.ip, input.userId);
      }
    } catch (error) {
      // Never let telemetry break the request it is observing.
      this.logger.error(
        `Failed to record security event ${input.type}: ${(error as Error).message}`,
      );
    }

    await this.considerBlocking(input);
  }

  /**
   * Has this address now done enough of this to be refused for a while?
   *
   * Only runs for the few event types that carry a rule, and only for
   * addresses that are blockable at all, so the common case costs one Map
   * lookup and no query. A failure here is swallowed: the worst outcome
   * of a broken counter must be an attacker who is merely rate limited,
   * never a legitimate request that fails because telemetry did.
   */
  private async considerBlocking(input: SecurityEventInput): Promise<void> {
    const rule = ruleFor(input.type);
    if (!rule) return;
    if (isExempt(input.ip)) return;

    const ip = input.ip as string;
    try {
      const seen = await this.countRecent(input.type, rule.windowMinutes, { ip });
      const verdict = decide(input.type, seen);
      if (!verdict) return;

      const newlyBlocked = this.blocks.block(
        ip,
        verdict.blockMinutes,
        `${seen} ${input.type} in ${rule.windowMinutes}m`,
      );

      // One log entry per block, not one per evaluation that reached the
      // same conclusion. Recording is fire-and-forget, so a burst of
      // probes produces several concurrent evaluations that each count
      // after all the rows have landed; before this check that wrote three
      // IP_BLOCKED rows for a single block, which reads as three separate
      // incidents to whoever opens the log.
      if (!newlyBlocked) return;

      // The block is itself an action taken against a caller, so it goes
      // in the same log as the events that earned it. Without this an
      // operator sees the attack and cannot tell what was done about it.
      await this.prisma.securityEvent
        .create({
          data: {
            type: SecurityEventType.IP_BLOCKED,
            severity: Severity.HIGH,
            userId: input.userId ?? null,
            ip: this.truncate(ip, 64),
            route: this.truncate(input.route, 200),
            details: {
              trigger: input.type,
              seen,
              windowMinutes: rule.windowMinutes,
              threshold: rule.threshold,
              because: rule.because,
            },
            actionTaken: `blocked for ${verdict.blockMinutes} minutes`,
          },
        })
        .catch(() => undefined);
    } catch (error) {
      this.logger.error(
        `Block evaluation failed for ${input.type}: ${(error as Error).message}`,
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

  private async sendAlert(
    type: string,
    severity: string,
    ip: string | null | undefined,
    userId: string | null | undefined,
  ): Promise<void> {
    if (!this.mailer) return;

    const now = Date.now();
    const last = this.alertedRecently.get(type);
    if (last && now - last < SecurityEventService.ALERT_COOLDOWN_MS) return;
    this.alertedRecently.set(type, now);

    try {
      await this.mailer.sendMail({
        from: this.alertTo,
        to: this.alertTo,
        subject: `[Gymologia] ${severity} security event: ${type}`,
        text:
          `A ${severity} security event was recorded.\n\n` +
          `Type: ${type}\nIP: ${ip ?? '—'}\nUser: ${userId ?? '—'}\n` +
          `Time: ${new Date().toISOString()}\n\n` +
          `Review in the admin app. If this is a personal data breach, ` +
          `notify DPBI within 72 hours (DPDP Act 2023 s.8(6)).`,
      });
    } catch {
      // Never let a broken mailer surface as a request failure.
    }
  }

  private truncate(value: string | null | undefined, max: number): string | null {
    if (!value) return null;
    return value.length > max ? value.slice(0, max) : value;
  }
}
