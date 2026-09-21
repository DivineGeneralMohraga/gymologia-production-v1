import {
  BadRequestException,
  ForbiddenException,
  Injectable,
  Logger,
  UnauthorizedException,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import { AppClient, OtpPurpose, User } from '@prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { CryptoService } from '../common/crypto/crypto.service';
import { SecurityEventService } from '../common/security/security-event.service';
import { AuditService } from '../common/audit/audit.service';
import { NotificationsService } from '../notifications/notifications.service';
import { OtpService } from './otp.service';
import { Msg91Service } from './msg91.service';
import { TokenService, TokenPair, SessionMeta } from './token.service';
import { normalizePhone } from '../common/utils/phone.util';
import {
  GuardianConsentRequestDto,
  GuardianConsentVerifyDto,
  RegisterDto,
  RequestOtpDto,
  VerifyOtpDto,
  VerifyWidgetTokenDto,
} from './dto/auth.dto';
import { JwtConfig } from '../config/configuration';

/** Short-lived proof that a phone number was just verified, for signup. */
interface RegistrationTokenPayload {
  phone: string;
  purpose: 'register';
  client: AppClient;
}

/**
 * Short-lived proof that a parent/guardian's number was OTP-verified for a
 * specific pending registration. DPDP Act 2023 s.9 — a minor's account
 * cannot be created without this.
 */
interface GuardianConsentTokenPayload {
  phone: string; // the minor's phone, tying this token to one registration
  guardianPhone: string;
  purpose: 'guardian_consent';
}

export type VerifyResult =
  | { status: 'NEW_USER'; registrationToken: string; phone: string }
  | { status: 'AUTHENTICATED'; tokens: TokenPair; user: PublicUser };

export interface PublicUser {
  id: string;
  phone: string;
  name: string;
  email: string | null;
  age: number | null;
  avatarUrl: string | null;
  locale: string;
  createdAt: Date;
}

@Injectable()
export class AuthService {
  private readonly logger = new Logger(AuthService.name);
  private readonly jwtCfg: JwtConfig;

  constructor(
    private readonly prisma: PrismaService,
    private readonly otp: OtpService,
    private readonly msg91: Msg91Service,
    private readonly tokens: TokenService,
    private readonly crypto: CryptoService,
    private readonly jwt: JwtService,
    private readonly securityEvents: SecurityEventService,
    private readonly notifications: NotificationsService,
    private readonly audit: AuditService,
    config: ConfigService,
  ) {
    this.jwtCfg = config.getOrThrow<JwtConfig>('jwt');
  }

  // ── Step 1: send a code ────────────────────────────────────────────

  async requestOtp(dto: RequestOtpDto, meta: SessionMeta) {
    const phone = normalizePhone(dto.phone);

    // A blocked account should not even be able to burn our SMS credit.
    const existing = await this.prisma.user.findUnique({
      where: { phone },
      select: { status: true },
    });
    if (existing && existing.status !== 'ACTIVE') {
      await this.securityEvents.record({
        type: 'ANOMALOUS_LOGIN',
        severity: 'MEDIUM',
        ip: meta.ip,
        details: { reason: 'otp requested for non-active account' },
      });
      throw new ForbiddenException(
        'This account is not active. Contact support@gymologia.com',
      );
    }

    const challenge = await this.otp.issue(phone, OtpPurpose.LOGIN, { ip: meta.ip });

    return {
      challengeId: challenge.challengeId,
      expiresAt: challenge.expiresAt,
      resendAfterSeconds: challenge.resendAfterSeconds,
      // Never echo the full number back — it confirms enumeration.
      phoneMasked: this.crypto.maskPhone(phone),
      // Both undefined in production; see OtpService.issue.
      delivered: challenge.delivered,
      devCode: challenge.devCode,
    };
  }

  // ── Step 2: check the code ─────────────────────────────────────────

  /**
   * On success this branches: a known number gets tokens straight away, a
   * new number gets a registration token to carry into /auth/register.
   * The client decides which screen to show from `status`.
   */
  async verifyOtp(dto: VerifyOtpDto, meta: SessionMeta): Promise<VerifyResult> {
    const phone = normalizePhone(dto.phone);

    await this.otp.verify(dto.challengeId, phone, dto.code, OtpPurpose.LOGIN, {
      ip: meta.ip,
    });

    return this.completeVerification(phone, dto.appClient, {
      ...meta,
      deviceId: dto.deviceId ?? meta.deviceId,
    });
  }

  /** Alternative entry point for clients using the MSG91 drop-in widget. */
  async verifyWidgetToken(
    dto: VerifyWidgetTokenDto,
    meta: SessionMeta,
  ): Promise<VerifyResult> {
    const verified = await this.msg91.verifyWidgetToken(dto.accessToken);
    if (!verified) {
      await this.securityEvents.record({
        type: 'INVALID_TOKEN',
        severity: 'MEDIUM',
        ip: meta.ip,
        details: { reason: 'msg91 widget token rejected' },
      });
      throw new UnauthorizedException('Verification failed. Please try again.');
    }

    const phone = normalizePhone(verified);
    return this.completeVerification(phone, dto.appClient, {
      ...meta,
      deviceId: dto.deviceId ?? meta.deviceId,
    });
  }

  private async completeVerification(
    phone: string,
    appClient: AppClient,
    meta: SessionMeta,
  ): Promise<VerifyResult> {
    const user = await this.prisma.user.findUnique({ where: { phone } });

    if (!user) {
      const registrationToken = await this.jwt.signAsync(
        { phone, purpose: 'register', client: appClient } satisfies RegistrationTokenPayload,
        { secret: this.jwtCfg.accessSecret, expiresIn: '15m' },
      );
      return { status: 'NEW_USER', registrationToken, phone };
    }

    if (user.status !== 'ACTIVE') {
      throw new ForbiddenException(
        'This account is not active. Contact support@gymologia.com',
      );
    }

    await this.assertClientAllowed(user.id, appClient);

    const tokens = await this.tokens.issuePair(user.id, user.phone, appClient, meta);

    await this.prisma.user.update({
      where: { id: user.id },
      data: { lastLoginAt: new Date(), phoneVerified: true },
    });

    return { status: 'AUTHENTICATED', tokens, user: this.toPublicUser(user) };
  }

  // ── Step 3: create the account ─────────────────────────────────────

  private async decodeRegistrationToken(
    token: string,
  ): Promise<RegistrationTokenPayload> {
    let payload: RegistrationTokenPayload;
    try {
      payload = await this.jwt.verifyAsync<RegistrationTokenPayload>(token, {
        secret: this.jwtCfg.accessSecret,
      });
    } catch {
      throw new UnauthorizedException(
        'Verification expired. Please verify your number again.',
      );
    }
    if (payload.purpose !== 'register') {
      throw new UnauthorizedException('Invalid registration token');
    }
    return payload;
  }

  /**
   * Step 1 of guardian consent: send a code to the phone the guardian
   * holds. Kept as its own OTP purpose so this challenge can never be
   * redeemed anywhere except /auth/guardian-consent/verify.
   */
  async requestGuardianConsent(
    dto: GuardianConsentRequestDto,
    meta: SessionMeta,
  ) {
    const registration = await this.decodeRegistrationToken(dto.registrationToken);
    const guardianPhone = normalizePhone(dto.guardianPhone);
    const minorPhone = normalizePhone(registration.phone);

    if (guardianPhone === minorPhone) {
      throw new BadRequestException(
        "The guardian's number must be different from your own.",
      );
    }

    const challenge = await this.otp.issue(
      guardianPhone,
      OtpPurpose.GUARDIAN_CONSENT,
      { ip: meta.ip },
    );

    return {
      challengeId: challenge.challengeId,
      expiresAt: challenge.expiresAt,
      resendAfterSeconds: challenge.resendAfterSeconds,
      guardianPhoneMasked: this.crypto.maskPhone(guardianPhone),
      delivered: challenge.delivered,
      devCode: challenge.devCode,
    };
  }

  /**
   * Step 2: the guardian's code is checked, and a short-lived token is
   * minted binding that verified guardian number to this one pending
   * registration. /auth/register refuses to create an under-18 account
   * without it.
   */
  async verifyGuardianConsent(
    dto: GuardianConsentVerifyDto,
    meta: SessionMeta,
  ) {
    const registration = await this.decodeRegistrationToken(dto.registrationToken);
    const guardianPhone = normalizePhone(dto.guardianPhone);

    await this.otp.verify(
      dto.challengeId,
      guardianPhone,
      dto.code,
      OtpPurpose.GUARDIAN_CONSENT,
      { ip: meta.ip },
    );

    const guardianConsentToken = await this.jwt.signAsync(
      {
        phone: normalizePhone(registration.phone),
        guardianPhone,
        purpose: 'guardian_consent',
      } satisfies GuardianConsentTokenPayload,
      { secret: this.jwtCfg.accessSecret, expiresIn: '15m' },
    );

    return { guardianConsentToken };
  }

  async register(dto: RegisterDto, meta: SessionMeta) {
    const payload = await this.decodeRegistrationToken(dto.registrationToken);
    const phone = normalizePhone(payload.phone);

    // Someone could have registered this number in the window between
    // verification and submit. Treat it as a login rather than an error.
    const existing = await this.prisma.user.findUnique({ where: { phone } });
    if (existing) {
      // The same eligibility check the login path runs, and it belongs on
      // this branch too. The account was created in the fifteen minutes
      // since this token was issued, and creating a gym is one of the
      // things that can have happened in them -- so this is the one path
      // to a REFERRAL session that could otherwise skip the owner check.
      // Nothing much comes of holding one, because every referral endpoint
      // asks again, but a rule with two versions is a rule waiting to be
      // enforced in only one of them.
      await this.assertClientAllowed(existing.id, payload.client);

      const tokens = await this.tokens.issuePair(
        existing.id,
        existing.phone,
        payload.client,
        meta,
      );
      return { tokens, user: this.toPublicUser(existing), alreadyRegistered: true };
    }

    // DPDP Act 2023 s.9 — a minor's account cannot be created on their own
    // say-so. This is the actual gate; the app's guardian notice is only a
    // prompt to go through the flow that produces this token.
    let guardianPhone: string | null = null;
    if (dto.age < 18) {
      if (!dto.guardianConsentToken) {
        throw new BadRequestException(
          "You're under 18 — a parent or guardian needs to verify their number first.",
        );
      }
      let guardianPayload: GuardianConsentTokenPayload;
      try {
        guardianPayload = await this.jwt.verifyAsync<GuardianConsentTokenPayload>(
          dto.guardianConsentToken,
          { secret: this.jwtCfg.accessSecret },
        );
      } catch {
        throw new UnauthorizedException(
          'Guardian verification expired. Please verify again.',
        );
      }
      if (guardianPayload.purpose !== 'guardian_consent' || guardianPayload.phone !== phone) {
        throw new UnauthorizedException('Invalid guardian consent');
      }
      guardianPhone = guardianPayload.guardianPhone;
    }

    const user = await this.prisma.user.create({
      data: {
        phone,
        name: dto.name,
        email: dto.email?.toLowerCase() ?? null,
        age: dto.age,
        locale: dto.locale ?? 'en',
        phoneVerified: true,
        lastLoginAt: new Date(),
      },
    });

    await this.assertClientAllowed(user.id, payload.client);

    if (guardianPhone) {
      await this.audit.record({
        actorId: user.id,
        gymId: null,
        action: 'account.guardian_consent',
        entityType: 'User',
        entityId: user.id,
        after: {
          minor: true,
          age: dto.age,
          guardianPhoneMasked: this.crypto.maskPhone(guardianPhone),
        },
        ip: meta.ip,
        userAgent: meta.userAgent,
      });
    }

    const tokens = await this.tokens.issuePair(
      user.id,
      user.phone,
      payload.client,
      { ...meta, deviceId: dto.deviceId ?? meta.deviceId },
    );

    this.logger.log(`New user registered via ${payload.client}`);

    // The two default messages the spec asks every new user to be sent.
    // Deliberately not awaited: the account exists and the tokens are
    // issued, and a welcome message that cannot be written must not turn a
    // successful registration into a failed one. The service swallows its
    // own errors and logs them.
    void this.notifications.sendOnboarding(user.id);

    return { tokens, user: this.toPublicUser(user), alreadyRegistered: false };
  }

  // ── Session lifecycle ──────────────────────────────────────────────

  async refresh(refreshToken: string, meta: SessionMeta): Promise<TokenPair> {
    return this.tokens.rotate(refreshToken, meta);
  }

  async logout(sessionId: string): Promise<void> {
    await this.tokens.revokeSession(sessionId);
  }

  async logoutEverywhere(userId: string): Promise<void> {
    await this.tokens.revokeAllForUser(userId);
  }

  async me(userId: string): Promise<PublicUser> {
    const user = await this.prisma.user.findUnique({ where: { id: userId } });
    if (!user) throw new UnauthorizedException('Account no longer exists');
    return this.toPublicUser(user);
  }

  /**
   * The referral app has an eligibility rule the other apps do not: a
   * person who owns a gym on Gymologia cannot hold a referral account.
   * Checked at login, not only at signup, because someone can register a
   * gym after creating their referral account.
   */
  private async assertClientAllowed(
    userId: string,
    appClient: AppClient,
  ): Promise<void> {
    if (appClient !== AppClient.REFERRAL) return;

    const ownedGym = await this.prisma.gym.findFirst({
      where: { ownerId: userId, deletedAt: null },
      select: { id: true },
    });

    if (ownedGym) {
      throw new ForbiddenException({
        message:
          'Gym owners cannot use the referral app. Gym staff and everyone else can.',
        // The referral app carries this sentence in ten languages and
        // shows its own when it sees this code. Without it the client
        // would have to match on the English, which breaks the first
        // time the wording is improved.
        code: 'REFERRAL_OWNER_EXCLUDED',
      });
    }
  }

  private toPublicUser(user: User): PublicUser {
    return {
      id: user.id,
      phone: user.phone,
      name: user.name,
      email: user.email,
      age: user.age,
      avatarUrl: user.avatarUrl,
      locale: user.locale,
      createdAt: user.createdAt,
    };
  }
}
