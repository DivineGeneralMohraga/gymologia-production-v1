import {
  BadRequestException,
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import {
  AttendanceStatus,
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
import { EditAttendanceDto, ListAttendanceDto, MarkAttendanceDto } from './dto/attendance.dto';

/** Midnight UTC for a given day, so one person has one record per date. */
function dayOnly(input: string | Date): Date {
  const d = new Date(input);
  return new Date(Date.UTC(d.getUTCFullYear(), d.getUTCMonth(), d.getUTCDate()));
}

@Injectable()
export class AttendanceService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly permissions: PermissionService,
    private readonly audit: AuditService,
  ) {}

  /**
   * Mark someone present or absent.
   *
   * Two different permissions depending on who the subject is, and for
   * staff subjects the marker must also outrank them — a trainer cannot
   * mark the manager who supervises them.
   *
   * Marking attendance mid-leave closes that leave: the spec's rule is
   * that turning up means the leave is over, and the member should not be
   * credited days they actually trained.
   */
  async mark(actor: ActorContext, dto: MarkAttendanceDto, meta: RequestMeta) {
    const date = dayOnly(dto.date ?? new Date());
    if (date.getTime() > dayOnly(new Date()).getTime()) {
      throw new BadRequestException('Attendance cannot be marked for a future date');
    }

    const subject = await this.resolveSubject(actor, dto.subjectType, dto.subjectId, 'mark');

    const record = await this.prisma.attendanceRecord.upsert({
      where: {
        gymId_subjectId_date: { gymId: actor.gymId, subjectId: subject.userId, date },
      },
      create: {
        gymId: actor.gymId,
        subjectType: dto.subjectType,
        subjectId: subject.userId,
        date,
        status: dto.status ?? AttendanceStatus.PRESENT,
        markedById: actor.userId,
      },
      update: {
        // Re-marking the same day is an edit, and is recorded as one.
        status: dto.status ?? AttendanceStatus.PRESENT,
        editedById: actor.userId,
        editedAt: new Date(),
        editReason: 'Re-marked',
      },
    });

    let closedLeave: string | null = null;
    if (
      dto.subjectType === SubjectType.MEMBER &&
      (dto.status ?? AttendanceStatus.PRESENT) === AttendanceStatus.PRESENT
    ) {
      closedLeave = await this.closeRunningLeave(actor.gymId, subject.userId, date);
    }

    await this.audit.record({
      actorId: actor.userId,
      gymId: actor.gymId,
      action: 'attendance.mark',
      entityType: 'AttendanceRecord',
      entityId: record.id,
      after: { subjectType: dto.subjectType, date, status: record.status, closedLeave },
      ip: meta.ip,
      userAgent: meta.userAgent,
    });

    return { ...record, closedLeaveId: closedLeave };
  }

  /**
   * The member came back early. Close the leave on the day they turned up
   * and put the membership back to ACTIVE, crediting only the days they
   * were genuinely away.
   */
  private async closeRunningLeave(
    gymId: string,
    userId: string,
    date: Date,
  ): Promise<string | null> {
    const running = await this.prisma.leaveRequest.findFirst({
      where: {
        gymId,
        subjectId: userId,
        subjectType: SubjectType.MEMBER,
        status: { in: [LeaveStatus.APPROVED, LeaveStatus.AUTO_APPROVED] },
        fromDate: { lte: date },
        toDate: { gte: date },
      },
    });
    if (!running) return null;

    const daysActuallyTaken = Math.max(
      0,
      Math.round((date.getTime() - running.fromDate.getTime()) / 86_400_000),
    );
    const daysReturned = running.days - daysActuallyTaken;

    await this.prisma.$transaction(async (tx) => {
      await tx.leaveRequest.update({
        where: { id: running.id },
        data: {
          status: LeaveStatus.CLOSED_EARLY,
          closedEarlyAt: new Date(),
          toDate: date,
          days: daysActuallyTaken,
        },
      });

      const membership = await tx.membership.findFirst({
        where: { gymId, userId, status: MembershipStatus.ON_LEAVE },
      });

      if (membership) {
        // The membership clock was pushed out by the full leave length.
        // Pull back the days that were not used.
        const correctedEnd = new Date(membership.endsAt);
        correctedEnd.setDate(correctedEnd.getDate() - daysReturned);

        await tx.membership.update({
          where: { id: membership.id },
          data: {
            status: MembershipStatus.ACTIVE,
            endsAt: correctedEnd,
            leaveDaysUsed: Math.max(
              0,
              membership.leaveDaysUsed - daysReturned,
            ),
          },
        });

        await tx.membershipExtension.create({
          data: {
            membershipId: membership.id,
            previousEndsAt: membership.endsAt,
            newEndsAt: correctedEnd,
            reason: 'CORRECTION',
            note: `Returned ${daysReturned} day(s) early from leave`,
          },
        });
      }
    });

    return running.id;
  }

  /**
   * Correct a record that was marked wrongly, or was never marked.
   * A reason is mandatory — an attendance edit without one is
   * indistinguishable from tampering when someone reads the log later.
   */
  async edit(
    actor: ActorContext,
    recordId: string,
    dto: EditAttendanceDto,
    meta: RequestMeta,
  ) {
    const record = await this.prisma.attendanceRecord.findFirst({
      where: { id: recordId, gymId: actor.gymId },
    });
    if (!record) throw new NotFoundException('Attendance record not found');

    this.permissions.assert(
      actor,
      record.subjectType === SubjectType.MEMBER
        ? Permission.EDIT_ATTENDANCE_MEMBER
        : Permission.EDIT_ATTENDANCE_STAFF,
    );

    if (record.subjectType === SubjectType.STAFF) {
      await this.assertOutranksSubjectUser(actor, record.subjectId);
    }

    const updated = await this.prisma.attendanceRecord.update({
      where: { id: recordId },
      data: {
        status: dto.status,
        editedById: actor.userId,
        editedAt: new Date(),
        editReason: dto.reason,
      },
    });

    await this.audit.record({
      actorId: actor.userId,
      gymId: actor.gymId,
      action: 'attendance.edit',
      entityType: 'AttendanceRecord',
      entityId: recordId,
      before: { status: record.status },
      after: { status: dto.status, reason: dto.reason },
      ip: meta.ip,
      userAgent: meta.userAgent,
    });

    return updated;
  }

  /** Attendance for a gym over a date range, members or staff. */
  async list(actor: ActorContext, dto: ListAttendanceDto) {
    this.permissions.assert(
      actor,
      dto.subjectType === SubjectType.MEMBER
        ? Permission.VIEW_ATTENDANCE_MEMBER
        : Permission.VIEW_ATTENDANCE_STAFF,
    );

    const from = dto.from ? dayOnly(dto.from) : dayOnly(new Date());
    const to = dto.to ? dayOnly(dto.to) : from;

    const records = await this.prisma.attendanceRecord.findMany({
      where: {
        gymId: actor.gymId,
        subjectType: dto.subjectType,
        date: { gte: from, lte: to },
        ...(dto.subjectId ? { subjectId: dto.subjectId } : {}),
      },
      include: {
        subject: { select: { id: true, name: true, phone: true } },
        markedBy: { select: { id: true, name: true } },
        editedBy: { select: { id: true, name: true } },
      },
      orderBy: [{ date: 'desc' }, { markedAt: 'desc' }],
      take: 500,
    });

    return records;
  }

  /**
   * One person's attendance, for the "check attendance" screen. The spec
   * is specific that searching for someone you have no permission over
   * says so rather than pretending they do not exist.
   */
  async forSubject(
    actor: ActorContext,
    subjectType: SubjectType,
    subjectUserId: string,
    days = 60,
  ) {
    this.permissions.assert(
      actor,
      subjectType === SubjectType.MEMBER
        ? Permission.VIEW_ATTENDANCE_MEMBER
        : Permission.VIEW_ATTENDANCE_STAFF,
    );

    if (subjectType === SubjectType.STAFF) {
      await this.assertOutranksSubjectUser(actor, subjectUserId);
    }

    const since = new Date();
    since.setDate(since.getDate() - days);

    const [records, present] = await Promise.all([
      this.prisma.attendanceRecord.findMany({
        where: {
          gymId: actor.gymId,
          subjectId: subjectUserId,
          date: { gte: dayOnly(since) },
        },
        orderBy: { date: 'desc' },
      }),
      this.prisma.attendanceRecord.count({
        where: {
          gymId: actor.gymId,
          subjectId: subjectUserId,
          status: AttendanceStatus.PRESENT,
        },
      }),
    ]);

    return { totalPresent: present, windowDays: days, records };
  }

  /**
   * The analytics the spec asks for: joins over time and how many members
   * are actually turning up.
   */
  async summary(actor: ActorContext, days = 30) {
    this.permissions.assert(actor, Permission.VIEW_ANALYTICS);

    const since = new Date();
    since.setDate(since.getDate() - days);
    const sinceDay = dayOnly(since);

    const [activeMembers, joined, attendanceRows, distinctAttendees] =
      await Promise.all([
        this.prisma.membership.count({
          where: { gymId: actor.gymId, status: MembershipStatus.ACTIVE },
        }),
        this.prisma.membership.count({
          where: { gymId: actor.gymId, createdAt: { gte: since } },
        }),
        this.prisma.attendanceRecord.groupBy({
          by: ['date'],
          where: {
            gymId: actor.gymId,
            subjectType: SubjectType.MEMBER,
            status: AttendanceStatus.PRESENT,
            date: { gte: sinceDay },
          },
          _count: { _all: true },
          orderBy: { date: 'asc' },
        }),
        this.prisma.attendanceRecord.findMany({
          where: {
            gymId: actor.gymId,
            subjectType: SubjectType.MEMBER,
            status: AttendanceStatus.PRESENT,
            date: { gte: sinceDay },
          },
          distinct: ['subjectId'],
          select: { subjectId: true },
        }),
      ]);

    return {
      windowDays: days,
      activeMembers,
      joinedInWindow: joined,
      /** Members who came at least once — the spec's "engagement" figure. */
      engagedMembers: distinctAttendees.length,
      engagementRate:
        activeMembers === 0
          ? 0
          : Math.round((distinctAttendees.length / activeMembers) * 100),
      dailyPresent: attendanceRows.map((row) => ({
        date: row.date,
        count: row._count._all,
      })),
    };
  }

  // ── Guards ─────────────────────────────────────────────────────────

  /**
   * Resolve who is being marked, and confirm the actor may mark them.
   * Members are identified by membership; staff by their staff record.
   */
  private async resolveSubject(
    actor: ActorContext,
    subjectType: SubjectType,
    subjectId: string,
    _action: string,
  ): Promise<{ userId: string }> {
    if (subjectType === SubjectType.MEMBER) {
      this.permissions.assert(actor, Permission.MARK_ATTENDANCE_MEMBER);

      const membership = await this.prisma.membership.findFirst({
        where: {
          gymId: actor.gymId,
          OR: [{ id: subjectId }, { userId: subjectId }],
          status: { not: MembershipStatus.REMOVED },
        },
        select: { userId: true },
      });
      if (!membership) throw new NotFoundException('Member not found at this gym');
      return { userId: membership.userId };
    }

    this.permissions.assert(actor, Permission.MARK_ATTENDANCE_STAFF);

    const staff = await this.prisma.staffMember.findFirst({
      where: {
        gymId: actor.gymId,
        OR: [{ id: subjectId }, { userId: subjectId }],
        status: 'ACTIVE',
      },
      include: { role: { select: { level: true, exemptFromAttendance: true, name: true } } },
    });
    if (!staff) throw new NotFoundException('Staff member not found at this gym');

    if (staff.role.exemptFromAttendance) {
      throw new BadRequestException(
        `${staff.role.name} is not subject to attendance.`,
      );
    }
    if (staff.userId === actor.userId) {
      throw new ForbiddenException('You cannot mark your own attendance');
    }
    this.permissions.assertOutranks(actor, staff.role.level, 'this staff member');

    return { userId: staff.userId };
  }

  private async assertOutranksSubjectUser(actor: ActorContext, userId: string) {
    const staff = await this.prisma.staffMember.findUnique({
      where: { gymId_userId: { gymId: actor.gymId, userId } },
      include: { role: { select: { level: true } } },
    });
    if (!staff) return; // Not staff any more; nothing to outrank.
    if (staff.userId === actor.userId) return;
    this.permissions.assertOutranks(actor, staff.role.level, 'this staff member');
  }
}

export type AttendanceWhere = Prisma.AttendanceRecordWhereInput;
