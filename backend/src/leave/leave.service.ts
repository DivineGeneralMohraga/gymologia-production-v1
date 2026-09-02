import {
  BadRequestException,
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import {
  ExtensionReason,
  LeaveStatus,
  MembershipStatus,
  Permission,
  Prisma,
  SubjectType,
} from '@prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { AuditService } from '../common/audit/audit.service';
import { PermissionService, ActorContext } from '../rbac/permission.service';
import type { RequestMeta } from '../gyms/gyms.service';
import { istDay } from '../common/utils/day';
import { DecideLeaveDto, ListLeaveDto, RequestLeaveDto } from './dto/leave.dto';



/** Inclusive day count: 1st to 3rd is three days, not two. */
function inclusiveDays(from: Date, to: Date): number {
  return Math.round((to.getTime() - from.getTime()) / 86_400_000) + 1;
}

@Injectable()
export class LeaveService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly permissions: PermissionService,
    private readonly audit: AuditService,
  ) {}

  /**
   * Someone asks for leave.
   *
   * Members: leave pauses the membership clock, so the days come back at
   * the end. Within both ceilings — the gym's monthly allowance and the
   * one set on their own membership — it approves on submission, as the
   * spec asks. Above either, it goes PENDING for an elevated approver.
   *
   * Staff: informational. There is no clock to pause, so it always needs
   * a decision from someone senior.
   */
  async request(
    gymId: string,
    userId: string,
    dto: RequestLeaveDto,
    meta: RequestMeta,
  ) {
    const fromDate = istDay(dto.fromDate);
    const toDate = istDay(dto.toDate);

    if (toDate < fromDate) {
      throw new BadRequestException('The end date cannot be before the start date');
    }
    const days = inclusiveDays(fromDate, toDate);
    if (days > 365) {
      throw new BadRequestException('Leave cannot exceed a year');
    }

    const overlapping = await this.prisma.leaveRequest.findFirst({
      where: {
        gymId,
        subjectId: userId,
        status: {
          in: [LeaveStatus.PENDING, LeaveStatus.APPROVED, LeaveStatus.AUTO_APPROVED],
        },
        fromDate: { lte: toDate },
        toDate: { gte: fromDate },
      },
      select: { id: true },
    });
    if (overlapping) {
      throw new BadRequestException(
        'You already have leave covering some of those dates',
      );
    }

    const isMember = dto.subjectType === SubjectType.MEMBER;

    let requiresElevated = true;
    let membershipId: string | null = null;

    if (isMember) {
      const gym = await this.prisma.gym.findUnique({
        where: { id: gymId },
        select: { maxLeaveDaysPerMonth: true },
      });
      if (!gym) throw new NotFoundException('Gym not found');

      const membership = await this.prisma.membership.findFirst({
        where: {
          gymId,
          userId,
          status: { in: [MembershipStatus.ACTIVE, MembershipStatus.ON_LEAVE] },
        },
      });
      if (!membership) {
        throw new NotFoundException('You do not have an active membership here');
      }
      membershipId = membership.id;

      const usedThisMonth = await this.daysTakenInMonth(gymId, userId, fromDate);

      // Both ceilings must hold for this to auto-approve.
      const withinMonthly = usedThisMonth + days <= gym.maxLeaveDaysPerMonth;
      const withinMembership =
        membership.leaveDaysUsed + days <= membership.maxLeaveDays;

      requiresElevated = !(withinMonthly && withinMembership);
    } else {
      // Staff leave always needs a decision.
      const staff = await this.prisma.staffMember.findUnique({
        where: { gymId_userId: { gymId, userId } },
        select: { id: true },
      });
      if (!staff) throw new ForbiddenException('You are not staff at this gym');
    }

    const status = requiresElevated
      ? LeaveStatus.PENDING
      : LeaveStatus.AUTO_APPROVED;

    const leave = await this.prisma.$transaction(async (tx) => {
      const created = await tx.leaveRequest.create({
        data: {
          gymId,
          subjectType: dto.subjectType,
          subjectId: userId,
          fromDate,
          toDate,
          days,
          reason: dto.reason ?? null,
          status,
          requiresElevatedApproval: requiresElevated,
          ...(status === LeaveStatus.AUTO_APPROVED ? { decidedAt: new Date() } : {}),
        },
      });

      if (status === LeaveStatus.AUTO_APPROVED && membershipId) {
        await this.applyMemberLeave(tx, membershipId, days);
      }

      return created;
    });

    await this.audit.record({
      actorId: userId,
      gymId,
      action: 'leave.request',
      entityType: 'LeaveRequest',
      entityId: leave.id,
      after: { days, status, requiresElevated },
      ip: meta.ip,
      userAgent: meta.userAgent,
    });

    return leave;
  }

  /**
   * Approve or decline. Also used to reverse an earlier decision — in
   * which case the actor must be senior to whoever decided first, which
   * is the spec's rule for undoing a mistaken approval.
   */
  async decide(
    actor: ActorContext,
    leaveId: string,
    dto: DecideLeaveDto,
    meta: RequestMeta,
  ) {
    const leave = await this.prisma.leaveRequest.findFirst({
      where: { id: leaveId, gymId: actor.gymId },
    });
    if (!leave) throw new NotFoundException('Leave request not found');

    this.permissions.assert(
      actor,
      leave.subjectType === SubjectType.MEMBER
        ? Permission.APPROVE_LEAVE_MEMBER
        : Permission.APPROVE_LEAVE_STAFF,
    );

    if (leave.subjectId === actor.userId) {
      throw new ForbiddenException('You cannot decide your own leave request');
    }

    const alreadyDecided =
      leave.status !== LeaveStatus.PENDING && leave.decidedById !== null;

    if (alreadyDecided) {
      // Reversing someone else's call needs both the extra permission and
      // seniority over them. Owner and Manager pass on seniority anyway.
      this.permissions.assert(actor, Permission.EDIT_LEAVE_DECISION);
      await this.assertSeniorToDecider(actor, leave.decidedById as string);
    }

    const approving = dto.status === LeaveStatus.APPROVED;
    const wasApproved =
      leave.status === LeaveStatus.APPROVED ||
      leave.status === LeaveStatus.AUTO_APPROVED;

    const updated = await this.prisma.$transaction(async (tx) => {
      if (alreadyDecided) {
        await tx.leaveDecisionOverride.create({
          data: {
            leaveRequestId: leave.id,
            previousStatus: leave.status,
            newStatus: dto.status,
            originalDeciderId: leave.decidedById as string,
            actorId: actor.userId,
            reason: dto.note ?? null,
          },
        });
      }

      const result = await tx.leaveRequest.update({
        where: { id: leave.id },
        data: {
          status: dto.status,
          decidedById: actor.userId,
          decidedAt: new Date(),
          decisionNote: dto.note ?? null,
        },
      });

      if (leave.subjectType === SubjectType.MEMBER) {
        const membership = await tx.membership.findFirst({
          where: { gymId: actor.gymId, userId: leave.subjectId },
        });

        if (membership) {
          if (approving && !wasApproved) {
            await this.applyMemberLeave(tx, membership.id, leave.days);
          } else if (!approving && wasApproved) {
            // Reversing an approval takes the days back off the clock.
            await this.revertMemberLeave(tx, membership.id, leave.days);
          }
        }
      }

      return result;
    });

    await this.audit.record({
      actorId: actor.userId,
      gymId: actor.gymId,
      action: alreadyDecided ? 'leave.override' : 'leave.decide',
      entityType: 'LeaveRequest',
      entityId: leave.id,
      before: { status: leave.status, decidedById: leave.decidedById },
      after: { status: dto.status, note: dto.note },
      ip: meta.ip,
      userAgent: meta.userAgent,
    });

    return updated;
  }

  async list(actor: ActorContext, dto: ListLeaveDto) {
    this.permissions.assert(
      actor,
      dto.subjectType === SubjectType.MEMBER
        ? Permission.VIEW_LEAVE_MEMBER
        : Permission.VIEW_LEAVE_STAFF,
    );

    return this.prisma.leaveRequest.findMany({
      where: {
        gymId: actor.gymId,
        subjectType: dto.subjectType,
        ...(dto.status ? { status: dto.status } : {}),
      },
      include: {
        subject: { select: { id: true, name: true, phone: true } },
        decidedBy: { select: { id: true, name: true } },
        overrides: { orderBy: { createdAt: 'desc' } },
      },
      orderBy: [{ status: 'asc' }, { fromDate: 'desc' }],
      take: 200,
    });
  }

  /** A person's own leave, in either app. */
  async mine(userId: string, gymId?: string) {
    return this.prisma.leaveRequest.findMany({
      where: { subjectId: userId, ...(gymId ? { gymId } : {}) },
      include: { gym: { select: { id: true, name: true, district: true } } },
      orderBy: { fromDate: 'desc' },
      take: 50,
    });
  }

  async cancel(userId: string, leaveId: string) {
    const leave = await this.prisma.leaveRequest.findFirst({
      where: { id: leaveId, subjectId: userId },
    });
    if (!leave) throw new NotFoundException('Leave request not found');

    if (leave.fromDate.getTime() <= Date.now()) {
      throw new BadRequestException('Leave that has already started cannot be cancelled');
    }

    const wasApproved =
      leave.status === LeaveStatus.APPROVED ||
      leave.status === LeaveStatus.AUTO_APPROVED;

    await this.prisma.$transaction(async (tx) => {
      await tx.leaveRequest.update({
        where: { id: leaveId },
        data: { status: LeaveStatus.CANCELLED },
      });

      if (wasApproved && leave.subjectType === SubjectType.MEMBER) {
        const membership = await tx.membership.findFirst({
          where: { gymId: leave.gymId, userId },
        });
        if (membership) {
          await this.revertMemberLeave(tx, membership.id, leave.days);
        }
      }
    });

    return { cancelled: true };
  }

  // ── Membership clock ───────────────────────────────────────────────

  /**
   * Approved member leave pauses the subscription: the end date moves out
   * by the number of days taken, so the member gets back the time they
   * paid for but could not use.
   */
  private async applyMemberLeave(
    tx: Prisma.TransactionClient,
    membershipId: string,
    days: number,
  ): Promise<void> {
    const membership = await tx.membership.findUnique({
      where: { id: membershipId },
      select: { endsAt: true, leaveDaysUsed: true },
    });
    if (!membership) return;

    const newEndsAt = new Date(membership.endsAt);
    newEndsAt.setDate(newEndsAt.getDate() + days);

    await tx.membership.update({
      where: { id: membershipId },
      data: {
        endsAt: newEndsAt,
        leaveDaysUsed: membership.leaveDaysUsed + days,
        status: MembershipStatus.ON_LEAVE,
      },
    });

    await tx.membershipExtension.create({
      data: {
        membershipId,
        previousEndsAt: membership.endsAt,
        newEndsAt,
        reason: ExtensionReason.LEAVE_COMPENSATION,
        note: `${days} day(s) of approved leave`,
      },
    });
  }

  private async revertMemberLeave(
    tx: Prisma.TransactionClient,
    membershipId: string,
    days: number,
  ): Promise<void> {
    const membership = await tx.membership.findUnique({
      where: { id: membershipId },
      select: { endsAt: true, leaveDaysUsed: true },
    });
    if (!membership) return;

    const newEndsAt = new Date(membership.endsAt);
    newEndsAt.setDate(newEndsAt.getDate() - days);

    await tx.membership.update({
      where: { id: membershipId },
      data: {
        endsAt: newEndsAt,
        leaveDaysUsed: Math.max(0, membership.leaveDaysUsed - days),
        status: MembershipStatus.ACTIVE,
      },
    });

    await tx.membershipExtension.create({
      data: {
        membershipId,
        previousEndsAt: membership.endsAt,
        newEndsAt,
        reason: ExtensionReason.CORRECTION,
        note: `Reversed ${days} day(s) of leave`,
      },
    });
  }

  private async daysTakenInMonth(
    gymId: string,
    userId: string,
    within: Date,
  ): Promise<number> {
    const monthStart = new Date(
      Date.UTC(within.getUTCFullYear(), within.getUTCMonth(), 1),
    );
    const monthEnd = new Date(
      Date.UTC(within.getUTCFullYear(), within.getUTCMonth() + 1, 0),
    );

    const rows = await this.prisma.leaveRequest.findMany({
      where: {
        gymId,
        subjectId: userId,
        status: { in: [LeaveStatus.APPROVED, LeaveStatus.AUTO_APPROVED] },
        fromDate: { lte: monthEnd },
        toDate: { gte: monthStart },
      },
      select: { days: true },
    });

    return rows.reduce((sum, r) => sum + r.days, 0);
  }

  private async assertSeniorToDecider(actor: ActorContext, deciderUserId: string) {
    const decider = await this.prisma.staffMember.findUnique({
      where: { gymId_userId: { gymId: actor.gymId, userId: deciderUserId } },
      include: { role: { select: { level: true } } },
    });

    // The original decider has left; only a super role may clean up.
    if (!decider) {
      if (!actor.isSuper) {
        throw new ForbiddenException(
          'Only an owner or manager can change a decision made by someone who has left',
        );
      }
      return;
    }

    if (decider.userId === actor.userId) return;

    this.permissions.assertOutranks(
      actor,
      decider.role.level,
      'the person who made this decision',
    );
  }
}
