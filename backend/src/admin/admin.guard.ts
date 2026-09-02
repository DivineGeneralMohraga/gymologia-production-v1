import {
  CanActivate,
  ExecutionContext,
  ForbiddenException,
  Injectable,
  SetMetadata,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { AdminRole, StaffStatus } from '@prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { SecurityEventService } from '../common/security/security-event.service';
import type { AuthUser } from '../rbac/rbac.decorators';

export const ADMIN_ROLES_KEY = 'admin:roles';

/**
 * Gate an admin route behind one or more internal roles. With no roles
 * listed, any active admin may reach it.
 */
export const RequireAdminRole = (...roles: AdminRole[]) =>
  SetMetadata(ADMIN_ROLES_KEY, roles);

export interface AdminContext {
  adminId: string;
  userId: string;
  role: AdminRole;
  name: string;
}

/**
 * Everything under /admin is staff-only.
 *
 * A normal Gymologia account is not enough: there has to be an active
 * AdminStaff row. That row is the whole boundary between "a person with the
 * app" and "a person who can read every gym's data", so an attempt without
 * one is written to the security log rather than quietly refused.
 */
@Injectable()
export class AdminGuard implements CanActivate {
  constructor(
    private readonly prisma: PrismaService,
    private readonly reflector: Reflector,
    private readonly security: SecurityEventService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context
      .switchToHttp()
      .getRequest<{ user?: AuthUser; admin?: AdminContext; ip?: string }>();

    const user = request.user;
    if (!user) throw new ForbiddenException('Sign in first');

    const admin = await this.prisma.adminStaff.findUnique({
      where: { userId: user.userId },
      include: { user: { select: { name: true } } },
    });

    if (!admin || admin.status !== StaffStatus.ACTIVE) {
      // Someone with a valid app session probing the admin API is worth
      // knowing about, whether it is curiosity or a stolen token.
      await this.security.record({
        type: 'PERMISSION_DENIED',
        severity: 'HIGH',
        userId: user.userId,
        ip: request.ip ?? null,
        route: context.switchToHttp().getRequest<{ url?: string }>().url ?? null,
        details: {
          scope: 'admin',
          reason: admin ? `status ${admin.status}` : 'not admin staff',
        },
        actionTaken: 'refused',
      });
      throw new ForbiddenException('You do not have access to this action');
    }

    const required =
      this.reflector.getAllAndOverride<AdminRole[] | undefined>(
        ADMIN_ROLES_KEY,
        [context.getHandler(), context.getClass()],
      ) ?? [];

    // OWNER is deliberately not listed on every handler; it holds everything.
    if (
      required.length > 0 &&
      admin.role !== AdminRole.OWNER &&
      !required.includes(admin.role)
    ) {
      throw new ForbiddenException('Your role does not cover this');
    }

    request.admin = {
      adminId: admin.id,
      userId: admin.userId,
      role: admin.role,
      name: admin.user.name,
    };
    return true;
  }
}
