import {
  BadRequestException,
  ConflictException,
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { Permission } from '@prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { AuditService } from '../common/audit/audit.service';
import { PermissionService, ActorContext } from '../rbac/permission.service';
import {
  ALL_PERMISSIONS,
  CUSTOM_ROLE_MAX_LEVEL,
  CUSTOM_ROLE_MIN_LEVEL,
  GRANTABLE_PERMISSIONS,
  NON_GRANTABLE,
} from '../rbac/rbac.constants';
import type { RequestMeta } from '../gyms/gyms.service';
import {
  CreateRoleDto,
  ReorderRolesDto,
  UpdateRoleDto,
} from './dto/role.dto';

/**
 * Creating and editing the roles a gym runs on.
 *
 * The three rules live in PermissionService and are not restated here:
 * you can only act on a role junior to your own (OUTRANK), you can only
 * hand out permissions you hold yourself (NO ESCALATION), and a super role
 * is a fixed point nobody edits.
 *
 * What this adds on top is the shape of the thing: names must be unique per
 * gym, levels must stay strictly between the actor and the floor, and a role
 * with people in it cannot be deleted out from under them.
 */
@Injectable()
export class RolesService {
  private static readonly MAX_PER_GYM = 30;

  constructor(
    private readonly prisma: PrismaService,
    private readonly permissions: PermissionService,
    private readonly audit: AuditService,
  ) {}

  /**
   * The permission catalogue, grouped, with a plain-language label for each
   * and whether this actor may grant it.
   *
   * The last part matters: a screen that lists every permission and then
   * refuses half of them on save is worse than one that shows what you can
   * actually do.
   */
  catalogue(actor: ActorContext) {
    return {
      groups: PERMISSION_GROUPS.map((group) => ({
        title: group.title,
        permissions: group.permissions.map((permission) => ({
          permission,
          label: PERMISSION_LABELS[permission] ?? permission,
          grantable:
            !NON_GRANTABLE.has(permission) && actor.permissions.has(permission),
          /** Ungrantable to anyone, ever — not merely absent from this actor. */
          neverGrantable: NON_GRANTABLE.has(permission),
        })),
      })),
    };
  }

  async findOne(actor: ActorContext, roleId: string) {
    const role = await this.prisma.role.findFirst({
      where: { id: roleId, gymId: actor.gymId },
      include: {
        permissions: { select: { permission: true } },
        _count: { select: { staff: true } },
      },
    });
    if (!role) throw new NotFoundException('Role not found at this gym');

    return {
      id: role.id,
      name: role.name,
      level: role.level,
      isSystem: role.isSystem,
      isSuper: role.isSuper,
      exemptFromAttendance: role.exemptFromAttendance,
      staffCount: role._count.staff,
      // A super role holds everything implicitly; it has no permission rows
      // to list, and showing an empty list would read as "holds nothing".
      permissions: role.isSuper
        ? ALL_PERMISSIONS
        : role.permissions.map((p) => p.permission),
      editable: this.canModify(actor, role),
      deletable:
        this.canModify(actor, role) && !role.isSystem && role._count.staff === 0,
    };
  }

  async create(actor: ActorContext, dto: CreateRoleDto, meta: RequestMeta) {
    this.permissions.assert(actor, Permission.ADD_ROLES);

    const name = dto.name.trim();
    if (!name) throw new BadRequestException('Give the role a name');

    const total = await this.prisma.role.count({ where: { gymId: actor.gymId } });
    if (total >= RolesService.MAX_PER_GYM) {
      throw new BadRequestException(
        `A gym can have at most ${RolesService.MAX_PER_GYM} roles`,
      );
    }

    await this.assertNameFree(actor.gymId, name);

    const level = this.assertLevelAllowed(actor, dto.level);
    const permissions = dedupe(dto.permissions ?? []);
    this.permissions.assertCanGrant(actor, permissions);

    const role = await this.prisma.role.create({
      data: {
        gymId: actor.gymId,
        name,
        level,
        // Only the seeded roles are system roles. Anything made here can be
        // deleted again, which is what makes it safe to let people create.
        isSystem: false,
        isSuper: false,
        exemptFromAttendance: dto.exemptFromAttendance ?? false,
        permissions: { create: permissions.map((permission) => ({ permission })) },
      },
      select: { id: true },
    });

    await this.audit.record({
      actorId: actor.userId,
      gymId: actor.gymId,
      action: 'role.create',
      entityType: 'Role',
      entityId: role.id,
      after: { name, level, permissions },
      ip: meta.ip,
      userAgent: meta.userAgent,
    });

    return this.findOne(actor, role.id);
  }

  async update(
    actor: ActorContext,
    roleId: string,
    dto: UpdateRoleDto,
    meta: RequestMeta,
  ) {
    // Renaming and re-permissioning are separate permissions in the spec, so
    // ask for whichever the caller is actually trying to do.
    if (dto.permissions !== undefined) {
      this.permissions.assert(actor, Permission.EDIT_PERMISSIONS);
    }
    if (dto.name !== undefined || dto.exemptFromAttendance !== undefined) {
      this.permissions.assertAny(actor, [
        Permission.EDIT_PERMISSIONS,
        Permission.ADD_ROLES,
      ]);
    }
    if (dto.level !== undefined) {
      this.permissions.assert(actor, Permission.EDIT_ROLE_HIERARCHY);
    }

    const existing = await this.permissions.assertCanModifyRole(actor, roleId);

    const before = await this.prisma.role.findUniqueOrThrow({
      where: { id: roleId },
      include: { permissions: { select: { permission: true } } },
    });

    const name = dto.name?.trim();
    if (name !== undefined) {
      if (!name) throw new BadRequestException('Give the role a name');
      if (name.toLowerCase() !== existing.name.toLowerCase()) {
        await this.assertNameFree(actor.gymId, name);
      }
    }

    let level: number | undefined;
    if (dto.level !== undefined) {
      if (before.isSystem) {
        throw new ForbiddenException(
          'A default role keeps its place in the hierarchy',
        );
      }
      level = this.assertLevelAllowed(actor, dto.level);
    }

    let permissions: Permission[] | undefined;
    if (dto.permissions !== undefined) {
      if (before.isSuper) {
        throw new ForbiddenException(
          'This role holds every permission and cannot be narrowed',
        );
      }
      permissions = dedupe(dto.permissions);
      this.permissions.assertCanGrant(actor, permissions);

      // Removing a permission is also an exercise of authority over it.
      // Without this, someone who cannot grant MANAGE_STAFF could still
      // strip it from a role that has it.
      const removed = before.permissions
        .map((p) => p.permission)
        .filter((p) => !permissions!.includes(p));
      this.permissions.assertCanGrant(actor, removed);
    }

    await this.prisma.$transaction(async (tx) => {
      await tx.role.update({
        where: { id: roleId },
        data: {
          ...(name !== undefined ? { name } : {}),
          ...(level !== undefined ? { level } : {}),
          ...(dto.exemptFromAttendance !== undefined
            ? { exemptFromAttendance: dto.exemptFromAttendance }
            : {}),
        },
      });

      if (permissions !== undefined) {
        // Replace wholesale rather than diffing: the client sends the full
        // set it wants, and a diff would have to be right about ordering to
        // avoid a moment where the role holds neither old nor new.
        await tx.rolePermission.deleteMany({ where: { roleId } });
        if (permissions.length > 0) {
          await tx.rolePermission.createMany({
            data: permissions.map((permission) => ({ roleId, permission })),
          });
        }
      }
    });

    await this.audit.record({
      actorId: actor.userId,
      gymId: actor.gymId,
      action: 'role.update',
      entityType: 'Role',
      entityId: roleId,
      before: {
        name: before.name,
        level: before.level,
        permissions: before.permissions.map((p) => p.permission),
      },
      after: { name, level, permissions },
      ip: meta.ip,
      userAgent: meta.userAgent,
    });

    return this.findOne(actor, roleId);
  }

  async remove(actor: ActorContext, roleId: string, meta: RequestMeta) {
    this.permissions.assert(actor, Permission.DELETE_ROLES);
    await this.permissions.assertCanModifyRole(actor, roleId);

    const role = await this.prisma.role.findUniqueOrThrow({
      where: { id: roleId },
      include: { _count: { select: { staff: true } } },
    });

    if (role.isSystem) {
      throw new ForbiddenException(
        'Default roles cannot be deleted. Every gym needs them.',
      );
    }
    // Staff whose role vanished would hold no permissions and could not be
    // acted on by anyone, because there would be no level to outrank.
    if (role._count.staff > 0) {
      throw new ConflictException(
        `${role._count.staff} ${role._count.staff === 1 ? 'person is' : 'people are'} ` +
          'in this role. Move them to another role first.',
      );
    }

    await this.prisma.role.delete({ where: { id: roleId } });

    await this.audit.record({
      actorId: actor.userId,
      gymId: actor.gymId,
      action: 'role.delete',
      entityType: 'Role',
      entityId: roleId,
      before: { name: role.name, level: role.level },
      ip: meta.ip,
      userAgent: meta.userAgent,
    });

    return { deleted: true };
  }

  /**
   * Re-rank the roles. The client sends the ids it wants reordered, most
   * senior first, and they are spaced out so a later insertion between two
   * of them does not need another reshuffle.
   */
  async reorder(actor: ActorContext, dto: ReorderRolesDto, meta: RequestMeta) {
    this.permissions.assert(actor, Permission.EDIT_ROLE_HIERARCHY);

    const roles = await this.prisma.role.findMany({
      where: { id: { in: dto.roleIds }, gymId: actor.gymId },
      select: { id: true, level: true, isSystem: true, isSuper: true, name: true },
    });
    if (roles.length !== dto.roleIds.length) {
      throw new NotFoundException('Role not found at this gym');
    }

    for (const role of roles) {
      if (role.isSuper || role.isSystem) {
        throw new ForbiddenException(
          `${role.name} is a default role and keeps its place in the hierarchy`,
        );
      }
      this.permissions.assertOutranks(actor, role.level, `the ${role.name} role`);
    }

    // Everything being reordered stays strictly junior to the actor and
    // below the default roles, for the same reason as above.
    const start = Math.max(actor.level + 1, CUSTOM_ROLE_MIN_LEVEL);
    const step = 1;
    const lowest = start + (dto.roleIds.length - 1) * step;
    if (lowest > CUSTOM_ROLE_MAX_LEVEL) {
      throw new BadRequestException('Too many roles to fit below yours');
    }

    await this.prisma.$transaction(
      dto.roleIds.map((id, index) =>
        this.prisma.role.update({
          where: { id },
          data: { level: start + index * step },
        }),
      ),
    );

    await this.audit.record({
      actorId: actor.userId,
      gymId: actor.gymId,
      action: 'role.reorder',
      entityType: 'Role',
      entityId: actor.gymId,
      after: { order: dto.roleIds },
      ip: meta.ip,
      userAgent: meta.userAgent,
    });

    return { roles: await this.list(actor) };
  }

  /** Roles with counts, ordered most senior first. */
  async list(actor: ActorContext) {
    const roles = await this.prisma.role.findMany({
      where: { gymId: actor.gymId },
      include: { _count: { select: { staff: true, permissions: true } } },
      orderBy: { level: 'asc' },
    });

    return roles.map((role) => ({
      id: role.id,
      name: role.name,
      level: role.level,
      isSystem: role.isSystem,
      isSuper: role.isSuper,
      staffCount: role._count.staff,
      permissionCount: role.isSuper
        ? ALL_PERMISSIONS.length
        : role._count.permissions,
      editable: this.canModify(actor, role),
      deletable:
        this.canModify(actor, role) && !role.isSystem && role._count.staff === 0,
    }));
  }

  // ── Helpers ────────────────────────────────────────────────────────

  private canModify(
    actor: ActorContext,
    role: { level: number; isSuper: boolean },
  ): boolean {
    if (role.isSuper && !actor.isGymOwner) return false;
    return this.permissions.outranks(actor, role.level);
  }

  /**
   * A new or moved role has to sit strictly below the person moving it, and
   * below the default roles.
   *
   * The second half matters as much as the first. Owner and Manager are
   * super roles holding every permission, present and future. A custom role
   * slotted above Manager would outrank a role that can do everything,
   * which is not a hierarchy anyone can reason about — so custom roles
   * start below both of them, at CUSTOM_ROLE_MIN_LEVEL.
   */
  private assertLevelAllowed(actor: ActorContext, requested?: number): number {
    const floor = Math.max(actor.level + 1, CUSTOM_ROLE_MIN_LEVEL);
    const level = requested ?? floor + 9;

    if (level <= actor.level) {
      throw new ForbiddenException('A role you create must rank below your own');
    }
    if (level < CUSTOM_ROLE_MIN_LEVEL) {
      throw new ForbiddenException(
        `Custom roles rank below the default ones — ${CUSTOM_ROLE_MIN_LEVEL} or lower in seniority`,
      );
    }
    if (level > CUSTOM_ROLE_MAX_LEVEL) {
      throw new BadRequestException(
        `Rank must be between ${CUSTOM_ROLE_MIN_LEVEL} and ${CUSTOM_ROLE_MAX_LEVEL}`,
      );
    }
    return level;
  }

  /**
   * Names are compared case-insensitively. The unique index is
   * case-sensitive, so without this a gym gets "Trainer" and "trainer" and
   * nobody can tell which is which on the staff screen.
   */
  private async assertNameFree(gymId: string, name: string) {
    const clash = await this.prisma.role.findFirst({
      where: { gymId, name: { equals: name, mode: 'insensitive' } },
      select: { id: true },
    });
    if (clash) throw new ConflictException(`This gym already has a "${name}" role`);
  }
}

function dedupe(permissions: Permission[]): Permission[] {
  return [...new Set(permissions)];
}

/**
 * The catalogue, in the order a person thinks about it rather than the order
 * the enum happens to be declared in. Anything grantable that is missing from
 * a group would be invisible in the app, so the guard below fails the build
 * rather than letting a permission go unmanageable.
 */
const PERMISSION_GROUPS: { title: string; permissions: Permission[] }[] = [
  {
    title: 'Attendance',
    permissions: [
      Permission.MARK_ATTENDANCE_MEMBER,
      Permission.MARK_ATTENDANCE_STAFF,
      Permission.EDIT_ATTENDANCE_MEMBER,
      Permission.EDIT_ATTENDANCE_STAFF,
      Permission.VIEW_ATTENDANCE_MEMBER,
      Permission.VIEW_ATTENDANCE_STAFF,
    ],
  },
  {
    title: 'Leave',
    permissions: [
      Permission.VIEW_LEAVE_MEMBER,
      Permission.VIEW_LEAVE_STAFF,
      Permission.APPROVE_LEAVE_MEMBER,
      Permission.APPROVE_LEAVE_STAFF,
      Permission.EDIT_LEAVE_DECISION,
    ],
  },
  {
    title: 'Members',
    permissions: [
      Permission.ADD_MEMBER,
      Permission.MANAGE_MEMBER,
      Permission.REMOVE_MEMBER,
      Permission.VIEW_PROGRESS,
    ],
  },
  {
    title: 'Staff',
    permissions: [
      Permission.ADD_STAFF,
      Permission.MANAGE_STAFF,
      Permission.REMOVE_STAFF,
      Permission.ADD_TRAINER,
      Permission.MANAGE_TRAINERS,
    ],
  },
  {
    title: 'Roles',
    permissions: [
      Permission.ADD_ROLES,
      Permission.EDIT_PERMISSIONS,
      Permission.DELETE_ROLES,
      Permission.EDIT_ROLE_HIERARCHY,
    ],
  },
  {
    title: 'Events & communication',
    permissions: [
      Permission.HOST_EVENTS,
      Permission.MANAGE_EVENTS,
      Permission.SEND_NOTIFICATIONS,
      Permission.MANAGE_CHAT_GROUPS,
    ],
  },
  {
    title: 'The gym itself',
    permissions: [
      Permission.EDIT_GYM_PROFILE,
      Permission.MANAGE_SUBSCRIPTION,
      Permission.VIEW_ANALYTICS,
      Permission.VIEW_RANKING,
      Permission.DELETE_GYM,
    ],
  },
  {
    title: 'Everything',
    permissions: [Permission.ADMINISTRATIVE],
  },
];

const PERMISSION_LABELS: Partial<Record<Permission, string>> = {
  [Permission.MARK_ATTENDANCE_MEMBER]: 'Mark member attendance',
  [Permission.MARK_ATTENDANCE_STAFF]: 'Mark staff attendance',
  [Permission.EDIT_ATTENDANCE_MEMBER]: 'Correct member attendance',
  [Permission.EDIT_ATTENDANCE_STAFF]: 'Correct staff attendance',
  [Permission.VIEW_ATTENDANCE_MEMBER]: 'See member attendance',
  [Permission.VIEW_ATTENDANCE_STAFF]: 'See staff attendance',
  [Permission.VIEW_LEAVE_MEMBER]: 'See member leave',
  [Permission.VIEW_LEAVE_STAFF]: 'See staff leave',
  [Permission.APPROVE_LEAVE_MEMBER]: 'Decide member leave',
  [Permission.APPROVE_LEAVE_STAFF]: 'Decide staff leave',
  [Permission.EDIT_LEAVE_DECISION]: 'Overturn a leave decision',
  [Permission.ADD_MEMBER]: 'Add members',
  [Permission.MANAGE_MEMBER]: 'Edit members and extend memberships',
  [Permission.REMOVE_MEMBER]: 'Remove members',
  [Permission.VIEW_PROGRESS]: 'See member progress',
  [Permission.ADD_STAFF]: 'Add staff',
  [Permission.MANAGE_STAFF]: 'Edit staff roles',
  [Permission.REMOVE_STAFF]: 'Remove staff',
  [Permission.ADD_TRAINER]: 'Assign trainers',
  [Permission.MANAGE_TRAINERS]: 'Manage trainer categories',
  [Permission.ADD_ROLES]: 'Create roles',
  [Permission.EDIT_PERMISSIONS]: 'Edit what roles can do',
  [Permission.DELETE_ROLES]: 'Delete roles',
  [Permission.EDIT_ROLE_HIERARCHY]: 'Reorder the hierarchy',
  [Permission.HOST_EVENTS]: 'Host events',
  [Permission.MANAGE_EVENTS]: 'Edit and cancel events',
  [Permission.SEND_NOTIFICATIONS]: 'Send announcements',
  [Permission.MANAGE_CHAT_GROUPS]: 'Create and manage chat groups',
  [Permission.EDIT_GYM_PROFILE]: 'Edit the gym profile',
  [Permission.MANAGE_SUBSCRIPTION]: 'Manage the plan and payment',
  [Permission.VIEW_ANALYTICS]: 'See analytics',
  [Permission.VIEW_RANKING]: 'See search ranking',
  [Permission.DELETE_GYM]: 'Delete the gym',
  [Permission.ADMINISTRATIVE]: 'Everything above, including anything added later',
};

// A grantable permission missing from the catalogue could never be given to
// anyone through the app. Fail at import rather than shipping that silently.
{
  const listed = new Set(PERMISSION_GROUPS.flatMap((g) => g.permissions));
  const missing = GRANTABLE_PERMISSIONS.filter((p) => !listed.has(p));
  if (missing.length > 0) {
    throw new Error(
      `Permissions missing from the roles catalogue: ${missing.join(', ')}`,
    );
  }
}
