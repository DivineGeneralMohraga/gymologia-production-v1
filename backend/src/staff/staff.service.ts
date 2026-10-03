import {
  BadRequestException,
  ConflictException,
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { OtpPurpose, Permission, StaffStatus } from '@prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { AuditService } from '../common/audit/audit.service';
import { PermissionService, ActorContext } from '../rbac/permission.service';
import { PersonLookupService } from '../people/person-lookup.service';
import type { RequestMeta } from '../gyms/gyms.service';
import { AddStaffDto, UpdateStaffDto } from './dto/staff.dto';

@Injectable()
export class StaffService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly permissions: PermissionService,
    private readonly lookup: PersonLookupService,
    private readonly audit: AuditService,
  ) {}

  /** Everyone on staff. Owner and Manager appear but cannot be acted on. */
  async list(actor: ActorContext, includeRemoved = false) {
    const rows = await this.prisma.staffMember.findMany({
      where: {
        gymId: actor.gymId,
        ...(includeRemoved ? {} : { status: StaffStatus.ACTIVE }),
      },
      include: {
        user: { select: { id: true, name: true, phone: true, email: true } },
        role: { select: { id: true, name: true, level: true, isSuper: true, exemptFromAttendance: true } },
        trainerCategory: { select: { id: true, name: true } },
        _count: { select: { assignedMemberships: true } },
      },
      orderBy: [{ role: { level: 'asc' } }, { joinedAt: 'asc' }],
    });

    return rows.map((row) => ({
      id: row.id,
      user: row.user,
      role: row.role,
      isTrainer: row.isTrainer,
      trainerCategory: row.trainerCategory,
      assignedMemberCount: row._count.assignedMemberships,
      addressProofApproved: row.addressProofApproved,
      status: row.status,
      joinedAt: row.joinedAt,
      isSelf: row.userId === actor.userId,
      // The client greys out rows it cannot act on rather than failing a
      // request the user was allowed to attempt.
      canManage:
        row.userId !== actor.userId &&
        this.permissions.outranks(actor, row.role.level),
    }));
  }

  /** Step 1 of adding staff: OTP the number being added. */
  async startLookup(actor: ActorContext, phone: string, ip?: string | null) {
    this.permissions.assert(actor, Permission.ADD_STAFF);
    return this.lookup.startLookup(phone, OtpPurpose.ADD_STAFF, ip);
  }

  /** Step 2: verify the code and attach them to the gym. */
  async add(actor: ActorContext, dto: AddStaffDto, meta: RequestMeta) {
    this.permissions.assert(actor, Permission.ADD_STAFF);

    const role = await this.prisma.role.findFirst({
      where: { id: dto.roleId, gymId: actor.gymId },
      select: { id: true, name: true, level: true, isSuper: true },
    });
    if (!role) throw new NotFoundException('Role not found at this gym');

    // You cannot hire someone into a role at or above your own — that is
    // the escalation route that would otherwise bypass every other check.
    this.permissions.assertOutranks(actor, role.level, 'this role');

    await this.validateTrainerCategory(actor.gymId, dto.isTrainer, dto.trainerCategoryId);

    const person = await this.lookup.verifyAndResolve(
      {
        challengeId: dto.challengeId,
        phone: dto.phone,
        code: dto.code,
        name: dto.name,
        email: dto.email,
        age: dto.age,
      },
      OtpPurpose.ADD_STAFF,
      meta.ip,
    );

    const existing = await this.prisma.staffMember.findUnique({
      where: { gymId_userId: { gymId: actor.gymId, userId: person.userId } },
      select: { id: true, status: true },
    });

    if (existing && existing.status === StaffStatus.ACTIVE) {
      throw new ConflictException('This person is already on staff here');
    }

    const staff = existing
      ? await this.prisma.staffMember.update({
          where: { id: existing.id },
          data: {
            roleId: role.id,
            status: StaffStatus.ACTIVE,
            removedAt: null,
            isTrainer: dto.isTrainer ?? false,
            trainerCategoryId: dto.trainerCategoryId ?? null,
            addressProofApproved: dto.addressProofApproved ?? false,
            addressProofUrl: dto.addressProofUrl ?? null,
            addedById: actor.userId,
          },
        })
      : await this.prisma.staffMember.create({
          data: {
            gymId: actor.gymId,
            userId: person.userId,
            roleId: role.id,
            isTrainer: dto.isTrainer ?? false,
            trainerCategoryId: dto.trainerCategoryId ?? null,
            addressProofApproved: dto.addressProofApproved ?? false,
            addressProofUrl: dto.addressProofUrl ?? null,
            addedById: actor.userId,
          },
        });

    await this.audit.record({
      actorId: actor.userId,
      gymId: actor.gymId,
      action: existing ? 'staff.reinstate' : 'staff.add',
      entityType: 'StaffMember',
      entityId: staff.id,
      after: { role: role.name, isTrainer: dto.isTrainer ?? false },
      ip: meta.ip,
      userAgent: meta.userAgent,
    });

    return this.findOne(actor, staff.id);
  }

  async update(
    actor: ActorContext,
    staffMemberId: string,
    dto: UpdateStaffDto,
    meta: RequestMeta,
  ) {
    this.permissions.assert(actor, Permission.MANAGE_STAFF);
    const target = await this.permissions.assertOutranksStaff(actor, staffMemberId);

    let nextRoleName: string | undefined;
    if (dto.roleId && dto.roleId !== target.roleId) {
      const role = await this.prisma.role.findFirst({
        where: { id: dto.roleId, gymId: actor.gymId },
        select: { id: true, name: true, level: true },
      });
      if (!role) throw new NotFoundException('Role not found at this gym');
      // Promoting into a role you do not outrank would let a manager mint
      // a peer, or an owner-equivalent.
      this.permissions.assertOutranks(actor, role.level, 'this role');
      nextRoleName = role.name;
    }

    await this.validateTrainerCategory(
      actor.gymId,
      dto.isTrainer,
      dto.trainerCategoryId,
    );

    const before = await this.prisma.staffMember.findUnique({
      where: { id: staffMemberId },
      select: { roleId: true, isTrainer: true, trainerCategoryId: true },
    });

    await this.prisma.staffMember.update({
      where: { id: staffMemberId },
      data: {
        ...(dto.roleId ? { roleId: dto.roleId } : {}),
        ...(dto.isTrainer !== undefined ? { isTrainer: dto.isTrainer } : {}),
        ...(dto.trainerCategoryId !== undefined
          ? { trainerCategoryId: dto.trainerCategoryId }
          : {}),
        ...(dto.addressProofApproved !== undefined
          ? { addressProofApproved: dto.addressProofApproved }
          : {}),
        ...(dto.addressProofUrl !== undefined
          ? { addressProofUrl: dto.addressProofUrl }
          : {}),
      },
    });

    await this.audit.record({
      actorId: actor.userId,
      gymId: actor.gymId,
      action: 'staff.update',
      entityType: 'StaffMember',
      entityId: staffMemberId,
      before,
      after: { ...dto, roleName: nextRoleName },
      ip: meta.ip,
      userAgent: meta.userAgent,
    });

    return this.findOne(actor, staffMemberId);
  }

  async remove(actor: ActorContext, staffMemberId: string, meta: RequestMeta) {
    this.permissions.assert(actor, Permission.REMOVE_STAFF);
    const target = await this.permissions.assertOutranksStaff(actor, staffMemberId);

    const gym = await this.prisma.gym.findUnique({
      where: { id: actor.gymId },
      select: { ownerId: true },
    });
    if (gym?.ownerId === target.userId) {
      throw new ForbiddenException(
        'The gym owner cannot be removed from their own gym',
      );
    }

    // Members assigned to this trainer would otherwise point at someone
    // who no longer works here.
    await this.prisma.$transaction([
      this.prisma.membership.updateMany({
        where: { assignedTrainerId: staffMemberId },
        data: { assignedTrainerId: null },
      }),
      this.prisma.staffMember.update({
        where: { id: staffMemberId },
        data: { status: StaffStatus.REMOVED, removedAt: new Date() },
      }),
    ]);

    await this.audit.record({
      actorId: actor.userId,
      gymId: actor.gymId,
      action: 'staff.remove',
      entityType: 'StaffMember',
      entityId: staffMemberId,
      ip: meta.ip,
      userAgent: meta.userAgent,
    });

    return { removed: true };
  }

  async findOne(actor: ActorContext, staffMemberId: string) {
    const row = await this.prisma.staffMember.findFirst({
      where: { id: staffMemberId, gymId: actor.gymId },
      include: {
        user: { select: { id: true, name: true, phone: true, email: true } },
        role: { select: { id: true, name: true, level: true, isSuper: true } },
        trainerCategory: { select: { id: true, name: true } },
      },
    });
    if (!row) throw new NotFoundException('Staff member not found');

    return {
      id: row.id,
      user: row.user,
      role: row.role,
      isTrainer: row.isTrainer,
      trainerCategory: row.trainerCategory,
      addressProofApproved: row.addressProofApproved,
      status: row.status,
      joinedAt: row.joinedAt,
      canManage:
        row.userId !== actor.userId &&
        this.permissions.outranks(actor, row.role.level),
    };
  }

  /** Trainers in a category, for the add-member screen's trainer picker. */
  async listTrainers(actor: ActorContext, categoryId?: string) {
    const rows = await this.prisma.staffMember.findMany({
      where: {
        gymId: actor.gymId,
        status: StaffStatus.ACTIVE,
        isTrainer: true,
        ...(categoryId ? { trainerCategoryId: categoryId } : {}),
      },
      include: {
        user: { select: { id: true, name: true } },
        trainerCategory: { select: { id: true, name: true, allowsMultipleMembers: true } },
        _count: { select: { assignedMemberships: true } },
      },
      orderBy: { joinedAt: 'asc' },
    });

    return rows.map((row) => ({
      staffMemberId: row.id,
      name: row.user.name,
      category: row.trainerCategory,
      assignedMemberCount: row._count.assignedMemberships,
      // A one-to-one category is full once it has a member; the picker
      // shows it disabled rather than letting the assignment fail later.
      available:
        row.trainerCategory?.allowsMultipleMembers !== false ||
        row._count.assignedMemberships === 0,
    }));
  }

  private async validateTrainerCategory(
    gymId: string,
    isTrainer?: boolean,
    trainerCategoryId?: string,
  ): Promise<void> {
    if (!trainerCategoryId) {
      if (isTrainer) {
        throw new BadRequestException(
          'Choose a trainer category (General, Personal, or one you have created)',
        );
      }
      return;
    }

    const category = await this.prisma.trainerCategory.findFirst({
      where: { id: trainerCategoryId, gymId },
      select: { id: true },
    });
    if (!category) {
      throw new NotFoundException('Trainer category not found at this gym');
    }
  }
}
