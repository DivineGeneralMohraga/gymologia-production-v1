import { ForbiddenException, Injectable, NotFoundException } from '@nestjs/common';
import { Permission } from '@prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import {
  NON_GRANTABLE,
  SCREEN_GATES,
  ALL_PERMISSIONS,
} from './rbac.constants';

/**
 * Everything the authorization layer needs to know about one person acting
 * inside one gym. Built fresh per request — never cached across requests,
 * because a permission revoked mid-session must bite immediately.
 */
export interface ActorContext {
  userId: string;
  gymId: string;
  staffMemberId: string;
  roleId: string;
  roleName: string;
  /** Lower = more senior. */
  level: number;
  isSuper: boolean;
  isGymOwner: boolean;
  permissions: ReadonlySet<Permission>;
}

/**
 * The authorization engine.
 *
 * Three rules run through every method here, and they are the whole model:
 *
 *   1. HOLD  — you can only do what your role explicitly holds.
 *   2. OUTRANK — you can only act on someone strictly junior to you.
 *              Peers and superiors are off limits, always.
 *   3. NO ESCALATION — you can never grant a permission you do not hold.
 *
 * Owner and Manager are `isSuper` and pass rule 1 unconditionally, but
 * rules 2 and 3 still apply to them (an owner outranks everyone anyway;
 * a manager cannot act on the owner).
 */
@Injectable()
export class PermissionService {
  constructor(private readonly prisma: PrismaService) {}

  /**
   * Resolve who this user is inside this gym. Throws if they are not
   * active staff there — membership alone grants no CRM access.
   */
  async getActorContext(userId: string, gymId: string): Promise<ActorContext> {
    const staff = await this.prisma.staffMember.findUnique({
      where: { gymId_userId: { gymId, userId } },
      include: {
        role: { include: { permissions: true } },
        gym: { select: { ownerId: true, status: true } },
      },
    });

    if (!staff || staff.status !== 'ACTIVE') {
      throw new ForbiddenException('You are not active staff at this gym');
    }

    const isSuper = staff.role.isSuper;
    const permissions = new Set<Permission>(
      isSuper
        ? ALL_PERMISSIONS
        : staff.role.permissions.map((rp) => rp.permission),
    );

    const isGymOwner = staff.gym.ownerId === userId;

    // DELETE_GYM tracks gym ownership, not role membership. A super-role
    // manager holds everything else but never this.
    if (isGymOwner) {
      permissions.add(Permission.DELETE_GYM);
    } else {
      permissions.delete(Permission.DELETE_GYM);
    }

    return {
      userId,
      gymId,
      staffMemberId: staff.id,
      roleId: staff.roleId,
      roleName: staff.role.name,
      level: staff.role.level,
      isSuper,
      isGymOwner,
      permissions,
    };
  }

  // ── Rule 1: HOLD ───────────────────────────────────────────────────

  has(ctx: ActorContext, permission: Permission): boolean {
    return ctx.permissions.has(permission);
  }

  hasAny(ctx: ActorContext, permissions: Permission[]): boolean {
    return permissions.some((p) => ctx.permissions.has(p));
  }

  hasAll(ctx: ActorContext, permissions: Permission[]): boolean {
    return permissions.every((p) => ctx.permissions.has(p));
  }

  assert(ctx: ActorContext, permission: Permission): void {
    if (!this.has(ctx, permission)) {
      // Deliberately vague: naming the missing permission tells an attacker
      // how the model is shaped. The precise reason goes to the audit log.
      throw new ForbiddenException('You do not have access to this action');
    }
  }

  assertAny(ctx: ActorContext, permissions: Permission[]): void {
    if (!this.hasAny(ctx, permissions)) {
      throw new ForbiddenException('You do not have access to this action');
    }
  }

  // ── Rule 2: OUTRANK ────────────────────────────────────────────────

  /** True when the actor is strictly senior to `targetLevel`. */
  outranks(ctx: ActorContext, targetLevel: number): boolean {
    return ctx.level < targetLevel;
  }

  assertOutranks(ctx: ActorContext, targetLevel: number, what = 'this person'): void {
    if (!this.outranks(ctx, targetLevel)) {
      throw new ForbiddenException(
        `Your role is not senior enough to act on ${what}`,
      );
    }
  }

  /** Look up a staff member and confirm the actor is senior to them. */
  async assertOutranksStaff(
    ctx: ActorContext,
    targetStaffMemberId: string,
  ): Promise<{ userId: string; level: number; roleId: string }> {
    const target = await this.prisma.staffMember.findFirst({
      where: { id: targetStaffMemberId, gymId: ctx.gymId },
      include: { role: { select: { level: true } } },
    });
    if (!target) {
      throw new NotFoundException('Staff member not found at this gym');
    }
    if (target.userId === ctx.userId) {
      throw new ForbiddenException('You cannot perform this action on yourself');
    }
    this.assertOutranks(ctx, target.role.level, 'this staff member');
    return {
      userId: target.userId,
      level: target.role.level,
      roleId: target.roleId,
    };
  }

  /** Confirm the actor may modify a role definition. */
  async assertCanModifyRole(
    ctx: ActorContext,
    roleId: string,
  ): Promise<{ level: number; isSystem: boolean; name: string }> {
    const role = await this.prisma.role.findFirst({
      where: { id: roleId, gymId: ctx.gymId },
      select: { level: true, isSystem: true, isSuper: true, name: true },
    });
    if (!role) throw new NotFoundException('Role not found at this gym');

    // Nobody edits a super role. Owner and Manager are fixed points.
    if (role.isSuper && !ctx.isGymOwner) {
      throw new ForbiddenException('This role cannot be modified');
    }
    this.assertOutranks(ctx, role.level, 'this role');
    return role;
  }

  // ── Rule 3: NO ESCALATION ──────────────────────────────────────────

  /**
   * The check that stops privilege escalation: a person handing out
   * permissions can only hand out what they themselves hold.
   */
  assertCanGrant(ctx: ActorContext, requested: Permission[]): void {
    const forbidden = requested.filter((p) => NON_GRANTABLE.has(p));
    if (forbidden.length > 0) {
      throw new ForbiddenException(
        `These permissions cannot be granted to any role: ${forbidden.join(', ')}`,
      );
    }

    const notHeld = requested.filter((p) => !ctx.permissions.has(p));
    if (notHeld.length > 0) {
      throw new ForbiddenException(
        `You cannot grant permissions you do not hold: ${notHeld.join(', ')}`,
      );
    }
  }

  /**
   * Removing permissions is bounded the same way — you cannot strip a
   * permission you do not hold yourself, otherwise a junior role could
   * quietly disarm a senior one.
   */
  assertCanRevoke(ctx: ActorContext, requested: Permission[]): void {
    const notHeld = requested.filter((p) => !ctx.permissions.has(p));
    if (notHeld.length > 0) {
      throw new ForbiddenException(
        `You cannot revoke permissions you do not hold: ${notHeld.join(', ')}`,
      );
    }
  }

  // ── UI support ─────────────────────────────────────────────────────

  /**
   * Which CRM screens this actor should see. The client hides the rest.
   * This is a convenience for rendering — never a substitute for the
   * server-side check on the action itself.
   */
  visibleScreens(ctx: ActorContext): string[] {
    return Object.entries(SCREEN_GATES)
      .filter(([, gates]) => gates.some((g) => ctx.permissions.has(g)))
      .map(([screen]) => screen);
  }

  /** Payload the staff app fetches on entering a gym. */
  describe(ctx: ActorContext) {
    return {
      gymId: ctx.gymId,
      staffMemberId: ctx.staffMemberId,
      role: { id: ctx.roleId, name: ctx.roleName, level: ctx.level },
      isGymOwner: ctx.isGymOwner,
      isSuper: ctx.isSuper,
      permissions: [...ctx.permissions].sort(),
      visibleScreens: this.visibleScreens(ctx),
    };
  }
}
