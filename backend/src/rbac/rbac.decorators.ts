import { SetMetadata, createParamDecorator, ExecutionContext } from '@nestjs/common';
import { Permission } from '@prisma/client';
import type { ActorContext } from './permission.service';

export const PERMISSIONS_KEY = 'rbac:permissions';
export const PERMISSIONS_MODE_KEY = 'rbac:permissions:mode';

/**
 * Gate a handler behind one or more permissions, resolved against the gym
 * in the route (`:gymId`).
 *
 *   @RequirePermissions(Permission.ADD_MEMBER)
 *   @RequirePermissions(Permission.MARK_ATTENDANCE_MEMBER, Permission.MARK_ATTENDANCE_STAFF)
 *
 * Multiple permissions are OR by default — the handler itself narrows
 * further (e.g. an attendance endpoint accepts either, then checks the
 * specific one matching the subject type in the body).
 */
export const RequirePermissions = (...permissions: Permission[]) =>
  SetMetadata(PERMISSIONS_KEY, permissions);

/** Same as above but every listed permission must be held. */
export const RequireAllPermissions = (...permissions: Permission[]) => {
  return (target: object, key?: string | symbol, descriptor?: PropertyDescriptor) => {
    SetMetadata(PERMISSIONS_KEY, permissions)(target, key as string, descriptor as PropertyDescriptor);
    SetMetadata(PERMISSIONS_MODE_KEY, 'all')(target, key as string, descriptor as PropertyDescriptor);
  };
};

/** Marks a route as reachable without a JWT (login, webhooks, health). */
export const IS_PUBLIC_KEY = 'auth:public';
export const Public = () => SetMetadata(IS_PUBLIC_KEY, true);

/** The authenticated user, injected by JwtAuthGuard. */
export interface AuthUser {
  userId: string;
  phone: string;
  appClient: string;
  sessionId: string;
}

export const CurrentUser = createParamDecorator(
  (data: keyof AuthUser | undefined, ctx: ExecutionContext) => {
    const request = ctx.switchToHttp().getRequest<{ user?: AuthUser }>();
    const user = request.user;
    if (!user) return undefined;
    return data ? user[data] : user;
  },
);

/** The resolved gym-scoped permission context, injected by PermissionsGuard. */
export const Actor = createParamDecorator(
  (_data: unknown, ctx: ExecutionContext): ActorContext => {
    const request = ctx.switchToHttp().getRequest<{ actor?: ActorContext }>();
    if (!request.actor) {
      throw new Error(
        'Actor requested on a route without PermissionsGuard — add @RequirePermissions or resolve the context manually.',
      );
    }
    return request.actor;
  },
);
