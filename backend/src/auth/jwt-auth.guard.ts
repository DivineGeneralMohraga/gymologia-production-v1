import {
  CanActivate,
  ExecutionContext,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { TokenService } from './token.service';
import { SecurityEventService } from '../common/security/security-event.service';
import { IS_PUBLIC_KEY, OPTIONAL_AUTH_KEY, AuthUser } from '../rbac/rbac.decorators';

interface AuthRequest {
  user?: AuthUser;
  headers: Record<string, string | string[] | undefined>;
  ip?: string;
  route?: { path?: string };
}

/**
 * Global authentication gate. Registered as an APP_GUARD, so every route
 * is protected unless it opts out with @Public() — the safe default being
 * "closed", not "open".
 *
 * Beyond signature verification it re-checks that the session behind the
 * token is still live, which is what makes logout and account suspension
 * take effect immediately rather than whenever the access token expires.
 */
@Injectable()
export class JwtAuthGuard implements CanActivate {
  constructor(
    private readonly reflector: Reflector,
    private readonly tokens: TokenService,
    private readonly securityEvents: SecurityEventService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const isPublic = this.reflector.getAllAndOverride<boolean>(IS_PUBLIC_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);
    if (isPublic) {
      const optional = this.reflector.getAllAndOverride<boolean>(OPTIONAL_AUTH_KEY, [
        context.getHandler(),
        context.getClass(),
      ]);
      if (optional) await this.tryIdentify(context.switchToHttp().getRequest<AuthRequest>());
      return true;
    }

    const request = context.switchToHttp().getRequest<AuthRequest>();
    const token = this.extractBearer(request);

    if (!token) {
      throw new UnauthorizedException('Authentication required');
    }

    let payload;
    try {
      payload = await this.tokens.verifyAccess(token);
    } catch (error) {
      await this.securityEvents.record({
        type: 'INVALID_TOKEN',
        severity: 'LOW',
        ip: request.ip,
        route: request.route?.path,
        details: { reason: 'access token failed verification' },
      });
      throw error;
    }

    await this.tokens.assertSessionActive(payload.sid);

    request.user = {
      userId: payload.sub,
      phone: payload.phone,
      appClient: payload.client,
      sessionId: payload.sid,
    };

    return true;
  }

  /**
   * For OptionalAuth routes: set request.user when a valid, live session is
   * presented, and otherwise leave the caller anonymous. Never throws -- a
   * stale token on a public page must not turn it into an error.
   */
  private async tryIdentify(request: AuthRequest): Promise<void> {
    const token = this.extractBearer(request);
    if (!token) return;
    try {
      const payload = await this.tokens.verifyAccess(token);
      await this.tokens.assertSessionActive(payload.sid);
      request.user = {
        userId: payload.sub,
        phone: payload.phone,
        appClient: payload.client,
        sessionId: payload.sid,
      };
    } catch {
      // Anonymous, as if no token had been sent.
    }
  }

  private extractBearer(request: AuthRequest): string | null {
    const header = request.headers.authorization;
    const value = Array.isArray(header) ? header[0] : header;
    if (!value) return null;
    const [scheme, token] = value.split(' ');
    if (scheme?.toLowerCase() !== 'bearer' || !token) return null;
    return token;
  }
}
