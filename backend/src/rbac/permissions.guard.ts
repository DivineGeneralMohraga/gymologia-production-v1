import {
  BadRequestException,
  CanActivate,
  ExecutionContext,
  ForbiddenException,
  Injectable,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { Permission } from '@prisma/client';
import { PermissionService, ActorContext } from './permission.service';
import { SecurityEventService } from '../common/security/security-event.service';
import {
  PERMISSIONS_KEY,
  PERMISSIONS_MODE_KEY,
  WORKS_WITHOUT_PLAN_KEY,
  AuthUser,
} from './rbac.decorators';

interface GuardedRequest {
  method?: string;
  user?: AuthUser;
  actor?: ActorContext;
  params: Record<string, string>;
  body?: Record<string, unknown>;
  ip?: string;
  route?: { path?: string };
  headers: Record<string, string | string[] | undefined>;
}

/**
 * Resolves the caller's role inside the gym named by the route, checks the
 * declared permissions, and hands the resulting ActorContext to the
 * handler via `@Actor()`.
 *
 * Runs after JwtAuthGuard, so `request.user` is already populated.
 * Every denial is written to security_events — a burst of them from one
 * account is the clearest signal of someone probing the permission model.
 */
@Injectable()
export class PermissionsGuard implements CanActivate {
  constructor(
    private readonly reflector: Reflector,
    private readonly permissions: PermissionService,
    private readonly securityEvents: SecurityEventService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const required = this.reflector.getAllAndOverride<Permission[]>(
      PERMISSIONS_KEY,
      [context.getHandler(), context.getClass()],
    );

    // No permission metadata: this guard has nothing to say. Authentication
    // is JwtAuthGuard's job, and it has already run.
    if (!required || required.length === 0) return true;

    const request = context.switchToHttp().getRequest<GuardedRequest>();
    const user = request.user;
    if (!user) throw new ForbiddenException('Not authenticated');

    const gymId = this.extractGymId(request);
    if (!gymId) {
      throw new BadRequestException(
        'This action must be scoped to a gym (missing gymId)',
      );
    }

    const actor = await this.permissions.getActorContext(user.userId, gymId);
    request.actor = actor;

    // No plan, no CRM. A new gym is a draft until the free trial or a paid
    // plan starts: only the routes needed to pay and set up stay open. A gym
    // whose plan ran out is read-only until renewed -- the owner can still
    // see their members and history (holding that hostage over a late
    // payment would be wrong), but cannot add or change anything.
    // Checked before permissions so the owner gets this reason rather than
    // a misleading "no access".
    const worksWithoutPlan = this.reflector.getAllAndOverride<boolean>(
      WORKS_WITHOUT_PLAN_KEY,
      [context.getHandler(), context.getClass()],
    );
    const readOnly = request.method === 'GET' || request.method === 'HEAD';
    if (!actor.gymActive && !worksWithoutPlan && !(actor.gymLapsed && readOnly)) {
      throw new ForbiddenException(
        actor.gymLapsed
          ? "This gym's plan has ended. Renew it to make changes."
          : 'This gym has no active plan. Start the free trial or choose a plan to use this.',
      );
    }

    const mode = this.reflector.getAllAndOverride<'all' | 'any'>(
      PERMISSIONS_MODE_KEY,
      [context.getHandler(), context.getClass()],
    );

    const granted =
      mode === 'all'
        ? this.permissions.hasAll(actor, required)
        : this.permissions.hasAny(actor, required);

    if (!granted) {
      await this.securityEvents.record({
        type: 'PERMISSION_DENIED',
        severity: 'LOW',
        userId: user.userId,
        ip: request.ip,
        route: request.route?.path,
        details: {
          gymId,
          role: actor.roleName,
          required,
          mode: mode ?? 'any',
        },
      });
      throw new ForbiddenException('You do not have access to this action');
    }

    return true;
  }

  /**
   * gymId may arrive as a route param, a body field, or a header (the
   * staff app sends X-Gym-Id on gym-scoped calls). Route params win.
   */
  private extractGymId(request: GuardedRequest): string | null {
    const fromParams = request.params?.gymId;
    if (fromParams) return fromParams;

    const fromBody = request.body?.gymId;
    if (typeof fromBody === 'string' && fromBody.length > 0) return fromBody;

    const fromHeader = request.headers['x-gym-id'];
    if (typeof fromHeader === 'string' && fromHeader.length > 0) {
      return fromHeader;
    }

    return null;
  }
}
