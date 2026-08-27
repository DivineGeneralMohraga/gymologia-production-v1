import { BadRequestException, Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { OtpPurpose } from '@prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { CryptoService } from '../common/crypto/crypto.service';
import { SecurityEventService } from '../common/security/security-event.service';
import { Msg91Service } from './msg91.service';
import { Msg91Config } from '../config/configuration';
import { TooManyRequestsException } from '../common/exceptions/too-many-requests.exception';

/**
 * Evaluated once at module load. A per-request check could be influenced by
 * something mutating process.env at runtime; a module constant cannot.
 */
const IS_PRODUCTION = process.env.NODE_ENV === 'production';

export interface IssuedChallenge {
  challengeId: string;
  expiresAt: Date;
  resendAfterSeconds: number;
  /** False when the SMS did not go out and we let it slide (dev only). */
  delivered: boolean;
  /** Present outside production only, so a tester can read the code back. */
  devCode?: string;
}

/** How many codes one number may request inside the window. */
const REQUEST_LIMIT = 5;
const REQUEST_WINDOW_MINUTES = 15;
/** Minimum gap between two sends to the same number. */
const RESEND_COOLDOWN_SECONDS = 30;

/**
 * OTP issuance and verification.
 *
 * The code itself is never stored. Each challenge holds a scrypt hash with
 * a per-row salt and an environment pepper, so a database dump alone
 * cannot be replayed against the login endpoint.
 *
 * Abuse controls, in order:
 *   • per-number cooldown  — stops resend hammering
 *   • per-number quota     — stops SMS bill farming
 *   • per-challenge tries  — stops code brute force (5 attempts)
 *   • security events      — feeds IP-level blocking
 */
@Injectable()
export class OtpService {
  private readonly logger = new Logger(OtpService.name);
  private readonly cfg: Msg91Config;

  constructor(
    private readonly prisma: PrismaService,
    private readonly crypto: CryptoService,
    private readonly msg91: Msg91Service,
    private readonly securityEvents: SecurityEventService,
    config: ConfigService,
  ) {
    this.cfg = config.getOrThrow<Msg91Config>('msg91');
  }

  /**
   * Issue a challenge and text it. Returns the challenge id, which the
   * client echoes back on verify so we never have to trust the phone
   * number alone at that step.
   */
  async issue(
    phone: string,
    purpose: OtpPurpose,
    meta: { ip?: string | null } = {},
  ): Promise<IssuedChallenge> {
    await this.enforceIssueLimits(phone, purpose, meta.ip ?? null);

    const code = this.crypto.generateOtp(this.cfg.otpLength);
    const salt = this.crypto.newSalt();
    const codeHash = await this.crypto.hashSecret(code, salt);
    const expiresAt = new Date(Date.now() + this.cfg.otpTtlSeconds * 1000);

    // Any earlier live challenge for this number and purpose is retired, so
    // only the newest code can ever be used.
    await this.prisma.otpChallenge.updateMany({
      where: { phone, purpose, consumedAt: null, expiresAt: { gt: new Date() } },
      data: { consumedAt: new Date() },
    });

    const challenge = await this.prisma.otpChallenge.create({
      data: {
        phone,
        purpose,
        codeHash,
        salt,
        expiresAt,
        requestIp: meta.ip ?? null,
      },
      select: { id: true, expiresAt: true },
    });

    // In production a delivery failure is fatal: issuing a challenge for a
    // code nobody received just strands the user on the OTP screen.
    // Outside production it is survivable, because the code is logged and
    // returned below — which is what makes local testing possible without
    // burning real SMS credit or waiting on DLT template approval.
    let delivered = true;
    try {
      await this.msg91.sendOtp(phone, code);
    } catch (error) {
      if (IS_PRODUCTION) throw error;
      delivered = false;
      this.logger.warn(
        `MSG91 delivery failed, continuing because NODE_ENV is not production: ${(error as Error).message}`,
      );
    }

    if (!IS_PRODUCTION) {
      this.logger.warn(
        `DEV OTP for ${this.crypto.maskPhone(phone)} is ${code}`,
      );
    }

    return {
      challengeId: challenge.id,
      expiresAt: challenge.expiresAt,
      resendAfterSeconds: RESEND_COOLDOWN_SECONDS,
      delivered,
      // Guarded on the constant, not on a request field, so there is no
      // input that can coax a real deployment into returning this.
      devCode: IS_PRODUCTION ? undefined : code,
    };
  }

  /**
   * Check a code. Consumes the challenge on success; increments the
   * attempt counter and records a security event on failure.
   */
  async verify(
    challengeId: string,
    phone: string,
    code: string,
    purpose: OtpPurpose,
    meta: { ip?: string | null } = {},
  ): Promise<void> {
    const challenge = await this.prisma.otpChallenge.findUnique({
      where: { id: challengeId },
    });

    const fail = async (reason: string): Promise<never> => {
      await this.securityEvents.record({
        type: 'OTP_ABUSE',
        severity: 'MEDIUM',
        ip: meta.ip,
        details: { reason, phone: this.crypto.maskPhone(phone), purpose },
      });
      // One message for every failure mode: a caller must not be able to
      // tell "wrong code" from "expired" from "no such challenge".
      throw new BadRequestException('Invalid or expired verification code');
    };

    if (
      !challenge ||
      challenge.phone !== phone ||
      challenge.purpose !== purpose ||
      challenge.consumedAt !== null ||
      challenge.expiresAt.getTime() < Date.now()
    ) {
      return fail('challenge-invalid');
    }

    if (challenge.attempts >= challenge.maxTries) {
      // Burn it so further guesses cannot continue against this row.
      await this.prisma.otpChallenge.update({
        where: { id: challenge.id },
        data: { consumedAt: new Date() },
      });
      return fail('max-attempts');
    }

    const ok = await this.crypto.verifySecret(code, challenge.salt, challenge.codeHash);

    if (!ok) {
      await this.prisma.otpChallenge.update({
        where: { id: challenge.id },
        data: { attempts: { increment: 1 } },
      });
      return fail('wrong-code');
    }

    await this.prisma.otpChallenge.update({
      where: { id: challenge.id },
      data: { consumedAt: new Date() },
    });
  }

  private async enforceIssueLimits(
    phone: string,
    purpose: OtpPurpose,
    ip: string | null,
  ): Promise<void> {
    const now = Date.now();

    const latest = await this.prisma.otpChallenge.findFirst({
      where: { phone, purpose },
      orderBy: { createdAt: 'desc' },
      select: { createdAt: true },
    });

    if (
      latest &&
      now - latest.createdAt.getTime() < RESEND_COOLDOWN_SECONDS * 1000
    ) {
      const wait = Math.ceil(
        (RESEND_COOLDOWN_SECONDS * 1000 - (now - latest.createdAt.getTime())) / 1000,
      );
      throw new TooManyRequestsException(
        `Please wait ${wait}s before requesting another code`,
      );
    }

    const windowStart = new Date(now - REQUEST_WINDOW_MINUTES * 60_000);
    const recentCount = await this.prisma.otpChallenge.count({
      where: { phone, createdAt: { gte: windowStart } },
    });

    if (recentCount >= REQUEST_LIMIT) {
      await this.securityEvents.record({
        type: 'OTP_ABUSE',
        severity: 'HIGH',
        ip,
        details: {
          reason: 'quota-exceeded',
          phone: this.crypto.maskPhone(phone),
          count: recentCount,
        },
        actionTaken: 'issue blocked for the remainder of the window',
      });
      throw new TooManyRequestsException(
        'Too many verification codes requested. Try again later.',
      );
    }
  }

  /** Housekeeping: drop spent and expired challenges. */
  async purgeExpired(): Promise<number> {
    const cutoff = new Date(Date.now() - 24 * 60 * 60 * 1000);
    const { count } = await this.prisma.otpChallenge.deleteMany({
      where: {
        OR: [{ expiresAt: { lt: cutoff } }, { consumedAt: { lt: cutoff } }],
      },
    });
    return count;
  }
}
