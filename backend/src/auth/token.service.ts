import { Injectable, Logger, UnauthorizedException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import { AppClient } from '@prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { CryptoService } from '../common/crypto/crypto.service';
import { JwtConfig } from '../config/configuration';

export interface AccessTokenPayload {
  sub: string; // userId
  phone: string;
  client: AppClient;
  sid: string; // session id, so a token can be revoked with its session
}

export interface TokenPair {
  accessToken: string;
  refreshToken: string;
  expiresIn: number;
}

export interface SessionMeta {
  deviceId?: string | null;
  ip?: string | null;
  userAgent?: string | null;
}

/**
 * Access tokens are short-lived JWTs (15 min) carrying the session id.
 * Refresh tokens are opaque random strings — only their hash is stored,
 * so a database read cannot mint a session.
 *
 * Refresh is rotating: every use issues a new refresh token and revokes
 * the old one. Presenting an already-revoked refresh token is treated as
 * theft and kills every session for that user.
 */
@Injectable()
export class TokenService {
  private readonly logger = new Logger(TokenService.name);

  private readonly cfg: JwtConfig;

  constructor(
    private readonly jwt: JwtService,
    private readonly prisma: PrismaService,
    private readonly crypto: CryptoService,
    config: ConfigService,
  ) {
    this.cfg = config.getOrThrow<JwtConfig>('jwt');
  }

  async issuePair(
    userId: string,
    phone: string,
    appClient: AppClient,
    meta: SessionMeta = {},
  ): Promise<TokenPair> {
    const refreshToken = this.crypto.generateToken(32);
    const tokenHash = this.crypto.hashToken(refreshToken);

    const session = await this.prisma.session.create({
      data: {
        userId,
        tokenHash,
        appClient,
        deviceId: meta.deviceId ?? null,
        ip: meta.ip ?? null,
        userAgent: meta.userAgent?.slice(0, 300) ?? null,
        expiresAt: this.refreshExpiry(),
      },
      select: { id: true },
    });

    const accessToken = await this.signAccess({
      sub: userId,
      phone,
      client: appClient,
      sid: session.id,
    });

    return {
      accessToken,
      refreshToken,
      expiresIn: this.ttlSeconds(this.cfg.accessTtl),
    };
  }

  async verifyAccess(token: string): Promise<AccessTokenPayload> {
    try {
      return await this.jwt.verifyAsync<AccessTokenPayload>(token, {
        secret: this.cfg.accessSecret,
      });
    } catch {
      throw new UnauthorizedException('Session expired. Please sign in again.');
    }
  }

  /** Rotating refresh. Reuse of a revoked token nukes the whole family. */
  async rotate(refreshToken: string, meta: SessionMeta = {}): Promise<TokenPair> {
    const tokenHash = this.crypto.hashToken(refreshToken);

    const session = await this.prisma.session.findUnique({
      where: { tokenHash },
      include: { user: { select: { id: true, phone: true, status: true } } },
    });

    if (!session) {
      throw new UnauthorizedException('Session expired. Please sign in again.');
    }

    if (session.revokedAt) {
      // A revoked refresh token came back. Either the device replayed an
      // old value, or somebody stole it. Assume the worst.
      await this.revokeAllForUser(session.userId);
      throw new UnauthorizedException(
        'Session was revoked for security. Please sign in again.',
      );
    }

    if (session.expiresAt.getTime() < Date.now()) {
      throw new UnauthorizedException('Session expired. Please sign in again.');
    }

    if (session.user.status !== 'ACTIVE') {
      throw new UnauthorizedException('This account is not active.');
    }

    const nextToken = this.crypto.generateToken(32);
    const nextHash = this.crypto.hashToken(nextToken);

    // Old session is closed and a fresh one opened in one transaction, so
    // there is never a moment where both are usable.
    const [, created] = await this.prisma.$transaction([
      this.prisma.session.update({
        where: { id: session.id },
        data: { revokedAt: new Date() },
      }),
      this.prisma.session.create({
        data: {
          userId: session.userId,
          tokenHash: nextHash,
          appClient: session.appClient,
          deviceId: meta.deviceId ?? session.deviceId,
          ip: meta.ip ?? null,
          userAgent: meta.userAgent?.slice(0, 300) ?? session.userAgent,
          expiresAt: this.refreshExpiry(),
        },
        select: { id: true },
      }),
    ]);

    const accessToken = await this.signAccess({
      sub: session.userId,
      phone: session.user.phone,
      client: session.appClient,
      sid: created.id,
    });

    return {
      accessToken,
      refreshToken: nextToken,
      expiresIn: this.ttlSeconds(this.cfg.accessTtl),
    };
  }

  async revokeSession(sessionId: string): Promise<void> {
    await this.prisma.session.updateMany({
      where: { id: sessionId, revokedAt: null },
      data: { revokedAt: new Date() },
    });
  }

  async revokeAllForUser(userId: string): Promise<void> {
    await this.prisma.session.updateMany({
      where: { userId, revokedAt: null },
      data: { revokedAt: new Date() },
    });
  }

  /**
   * Confirms the session behind an access token is still live. Called on
   * every authenticated request, which is what makes logout immediate
   * instead of "immediate in fifteen minutes".
   */
  async assertSessionActive(sessionId: string): Promise<void> {
    // Retried, because this is the single hottest query in the product and
    // the one the hosted pooler drops. A brief connection failure here is
    // not "your session ended" -- it is us being unable to ask. Safe to
    // repeat: it is a read.
    const session = await this.prisma.withRetry(
      'assertSessionActive',
      () =>
        this.prisma.session.findUnique({
          where: { id: sessionId },
          select: { revokedAt: true, expiresAt: true },
        }),
      { safeToRepeat: true },
    );

    if (!session || session.revokedAt || session.expiresAt.getTime() < Date.now()) {
      throw new UnauthorizedException('Session expired. Please sign in again.');
    }

    // Bookkeeping, and deliberately not allowed to fail the request.
    //
    // `lastUsedAt` is written here on every authenticated request and read
    // by nothing in the codebase. Awaiting it meant a timestamp nobody
    // consumes could turn an authorised request into a 500 -- the
    // authorisation decision was already made two lines above. If it
    // fails, the request proceeds and the failure is logged.
    try {
      await this.prisma.session.update({
        where: { id: sessionId },
        data: { lastUsedAt: new Date() },
      });
    } catch (error) {
      this.logger.warn(
        `could not update lastUsedAt for session ${sessionId}: ${
          error instanceof Error ? error.message : String(error)
        }`,
      );
    }
  }

  private signAccess(payload: AccessTokenPayload): Promise<string> {
    return this.jwt.signAsync(payload, {
      secret: this.cfg.accessSecret,
      expiresIn: this.ttlSeconds(this.cfg.accessTtl),
    });
  }

  private refreshExpiry(): Date {
    return new Date(Date.now() + this.ttlSeconds(this.cfg.refreshTtl) * 1000);
  }

  /** Parses "15m" / "30d" / "3600" into seconds. */
  private ttlSeconds(ttl: string): number {
    const match = /^(\d+)([smhd])?$/.exec(ttl.trim());
    if (!match) return 900;
    const value = Number.parseInt(match[1], 10);
    switch (match[2]) {
      case 'd':
        return value * 86_400;
      case 'h':
        return value * 3_600;
      case 'm':
        return value * 60;
      default:
        return value;
    }
  }
}
