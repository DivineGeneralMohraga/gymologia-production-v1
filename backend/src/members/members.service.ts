import {
  BadRequestException,
  ConflictException,
  ForbiddenException,
  Injectable,
  NotFoundException,
} from "@nestjs/common";
import {
  AttendanceStatus,
  ExtensionReason,
  MembershipStatus,
  OtpPurpose,
  Permission,
  Prisma,
  SubjectType,
} from "@prisma/client";
import { PrismaService } from "../prisma/prisma.service";
import { AuditService } from "../common/audit/audit.service";
import { PermissionService, ActorContext } from "../rbac/permission.service";
import { PersonLookupService } from "../people/person-lookup.service";
import type { RequestMeta } from "../gyms/gyms.service";
import { istDay, istWeekStart } from "../common/utils/day";
import {
  AddMemberDto,
  ExtendMembershipDto,
  ListMembersDto,
  RecordMetricDto,
  UpdateMemberDto,
} from "./dto/member.dto";

@Injectable()
export class MembersService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly permissions: PermissionService,
    private readonly lookup: PersonLookupService,
    private readonly audit: AuditService,
  ) {}

  // ── Staff-facing ───────────────────────────────────────────────────

  async list(actor: ActorContext, dto: ListMembersDto) {
    const limit = dto.limit ?? 50;

    const where: Prisma.MembershipWhereInput = {
      gymId: actor.gymId,
      ...(dto.status
        ? { status: dto.status }
        : { status: { not: MembershipStatus.REMOVED } }),
      ...(dto.query
        ? {
            user: {
              OR: [
                { name: { contains: dto.query, mode: "insensitive" } },
                { phone: { contains: dto.query } },
              ],
            },
          }
        : {}),
    };

    const [rows, total] = await Promise.all([
      this.prisma.membership.findMany({
        where,
        include: {
          user: { select: { id: true, name: true, phone: true, email: true } },
          assignedTrainer: {
            select: { id: true, user: { select: { name: true } } },
          },
        },
        orderBy: { createdAt: "desc" },
        take: limit,
        skip: dto.offset ?? 0,
      }),
      this.prisma.membership.count({ where }),
    ]);

    return {
      total,
      items: rows.map((row) => this.toMemberSummary(row)),
    };
  }

  async startLookup(actor: ActorContext, phone: string, ip?: string | null) {
    this.permissions.assert(actor, Permission.ADD_MEMBER);
    return this.lookup.startLookup(phone, OtpPurpose.ADD_MEMBER, ip);
  }

  async add(actor: ActorContext, dto: AddMemberDto, meta: RequestMeta) {
    this.permissions.assert(actor, Permission.ADD_MEMBER);

    const gym = await this.prisma.gym.findUnique({
      where: { id: actor.gymId },
      select: { maxLeaveDaysPerMembership: true },
    });
    if (!gym) throw new NotFoundException("Gym not found");

    // Staff set this per membership, but the gym's own ceiling is the
    // upper bound — otherwise the gym-wide policy means nothing.
    if (dto.maxLeaveDays > gym.maxLeaveDaysPerMembership) {
      throw new BadRequestException(
        `This gym allows at most ${gym.maxLeaveDaysPerMembership} leave days per membership.`,
      );
    }

    if (dto.assignedTrainerId) {
      await this.assertTrainerAssignable(actor.gymId, dto.assignedTrainerId);
    }

    const person = await this.lookup.verifyAndResolve(
      {
        challengeId: dto.challengeId,
        phone: dto.phone,
        code: dto.code,
        name: dto.name,
        email: dto.email,
        age: dto.age,
      },
      OtpPurpose.ADD_MEMBER,
      meta.ip,
    );

    // DPDP Act 2023 s.9 — processing a minor's data needs verified guardian
    // consent. This gate is not optional and cannot be satisfied by the
    // gym staff's own say-so; `guardianConsentConfirmed` must be set by the
    // client only after it has actually collected that consent.
    if (person.age != null && person.age < 18 && !dto.guardianConsentConfirmed) {
      throw new BadRequestException(
        "This person is under 18. A parent or guardian's verified consent is required " +
          "before they can be added as a member (DPDP Act 2023 s.9).",
      );
    }

    const active = await this.prisma.membership.findFirst({
      where: {
        gymId: actor.gymId,
        userId: person.userId,
        status: { in: [MembershipStatus.ACTIVE, MembershipStatus.ON_LEAVE] },
      },
      select: { id: true },
    });
    if (active) {
      throw new ConflictException(
        "This person already has an active membership here. Extend it instead.",
      );
    }

    const startsAt = dto.startsAt ? new Date(dto.startsAt) : new Date();
    const endsAt = addMonths(startsAt, dto.planMonths);

    const membership = await this.prisma.membership.create({
      data: {
        gymId: actor.gymId,
        userId: person.userId,
        startsAt,
        endsAt,
        planMonths: dto.planMonths,
        maxLeaveDays: dto.maxLeaveDays,
        assignedTrainerId: dto.assignedTrainerId ?? null,
        goal: dto.goal ?? null,
        // Default OFF (DPDP Act s.6 — member must opt in, not opt out).
        // Staff may only flip this to true with the member's affirmative
        // consent recorded at the time of enrolment.
        allowProgressMonitoring: dto.allowProgressMonitoring ?? false,
        addressProofApproved: dto.addressProofApproved ?? false,
        addedById: actor.userId,
      },
    });

    await this.audit.record({
      actorId: actor.userId,
      gymId: actor.gymId,
      action: "member.add",
      entityType: "Membership",
      entityId: membership.id,
      after: {
        planMonths: dto.planMonths,
        endsAt,
        maxLeaveDays: dto.maxLeaveDays,
        newAccount: person.created,
        ...(person.age != null && person.age < 18
          ? { minor: true, guardianConsentConfirmed: true }
          : {}),
      },
      ip: meta.ip,
      userAgent: meta.userAgent,
    });

    return this.findOne(actor, membership.id);
  }

  async findOne(actor: ActorContext, membershipId: string) {
    const row = await this.prisma.membership.findFirst({
      where: { id: membershipId, gymId: actor.gymId },
      include: {
        user: {
          select: { id: true, name: true, phone: true, email: true, age: true },
        },
        assignedTrainer: {
          select: { id: true, user: { select: { name: true } } },
        },
        extensions: { orderBy: { createdAt: "desc" }, take: 10 },
      },
    });
    if (!row) throw new NotFoundException("Member not found at this gym");

    return {
      ...this.toMemberSummary(row),
      email: row.user.email,
      age: row.user.age,
      startsAt: row.startsAt,
      planMonths: row.planMonths,
      addressProofApproved: row.addressProofApproved,
      allowProgressMonitoring: row.allowProgressMonitoring,
      extensions: row.extensions,
    };
  }

  async update(
    actor: ActorContext,
    membershipId: string,
    dto: UpdateMemberDto,
    meta: RequestMeta,
  ) {
    this.permissions.assert(actor, Permission.MANAGE_MEMBER);

    const membership = await this.prisma.membership.findFirst({
      where: { id: membershipId, gymId: actor.gymId },
      select: {
        id: true,
        maxLeaveDays: true,
        goal: true,
        assignedTrainerId: true,
      },
    });
    if (!membership)
      throw new NotFoundException("Member not found at this gym");

    if (dto.assignedTrainerId) {
      await this.assertTrainerAssignable(actor.gymId, dto.assignedTrainerId);
    }

    await this.prisma.membership.update({
      where: { id: membershipId },
      data: {
        ...(dto.assignedTrainerId !== undefined
          ? { assignedTrainerId: dto.assignedTrainerId }
          : {}),
        ...(dto.goal !== undefined ? { goal: dto.goal } : {}),
        ...(dto.maxLeaveDays !== undefined
          ? { maxLeaveDays: dto.maxLeaveDays }
          : {}),
        ...(dto.addressProofApproved !== undefined
          ? { addressProofApproved: dto.addressProofApproved }
          : {}),
      },
    });

    await this.audit.record({
      actorId: actor.userId,
      gymId: actor.gymId,
      action: "member.update",
      entityType: "Membership",
      entityId: membershipId,
      before: membership,
      after: dto,
      ip: meta.ip,
      userAgent: meta.userAgent,
    });

    return this.findOne(actor, membershipId);
  }

  /** Extend a membership. Every extension is recorded with its reason. */
  async extend(
    actor: ActorContext,
    membershipId: string,
    dto: ExtendMembershipDto,
    meta: RequestMeta,
  ) {
    this.permissions.assert(actor, Permission.MANAGE_MEMBER);

    const membership = await this.prisma.membership.findFirst({
      where: { id: membershipId, gymId: actor.gymId },
      select: { id: true, endsAt: true, status: true },
    });
    if (!membership)
      throw new NotFoundException("Member not found at this gym");

    // An expired membership extends from today, not from the date it
    // lapsed — otherwise renewing a month late silently costs the member
    // that month.
    const base =
      membership.endsAt.getTime() < Date.now() ? new Date() : membership.endsAt;
    const newEndsAt = addMonths(base, dto.months);

    await this.prisma.$transaction([
      this.prisma.membership.update({
        where: { id: membershipId },
        data: {
          endsAt: newEndsAt,
          status:
            membership.status === MembershipStatus.EXPIRED
              ? MembershipStatus.ACTIVE
              : membership.status,
        },
      }),
      this.prisma.membershipExtension.create({
        data: {
          membershipId,
          previousEndsAt: membership.endsAt,
          newEndsAt,
          reason: ExtensionReason.PAID_RENEWAL,
          note: dto.note ?? null,
          actorId: actor.userId,
        },
      }),
    ]);

    await this.audit.record({
      actorId: actor.userId,
      gymId: actor.gymId,
      action: "member.extend",
      entityType: "Membership",
      entityId: membershipId,
      before: { endsAt: membership.endsAt },
      after: { endsAt: newEndsAt, months: dto.months },
      ip: meta.ip,
      userAgent: meta.userAgent,
    });

    return this.findOne(actor, membershipId);
  }

  async remove(actor: ActorContext, membershipId: string, meta: RequestMeta) {
    this.permissions.assert(actor, Permission.REMOVE_MEMBER);

    const membership = await this.prisma.membership.findFirst({
      where: { id: membershipId, gymId: actor.gymId },
      select: { id: true },
    });
    if (!membership)
      throw new NotFoundException("Member not found at this gym");

    await this.prisma.membership.update({
      where: { id: membershipId },
      data: { status: MembershipStatus.REMOVED },
    });

    await this.audit.record({
      actorId: actor.userId,
      gymId: actor.gymId,
      action: "member.remove",
      entityType: "Membership",
      entityId: membershipId,
      ip: meta.ip,
      userAgent: meta.userAgent,
    });

    return { removed: true };
  }

  /**
   * A member's progress, as staff see it.
   *
   * Gated twice: the viewer needs VIEW_PROGRESS, and the member must not
   * have revoked monitoring consent. The consent check is not a
   * permission — no role can override it, because the member owns that
   * decision.
   */
  async progress(actor: ActorContext, membershipId: string) {
    this.permissions.assert(actor, Permission.VIEW_PROGRESS);

    const membership = await this.prisma.membership.findFirst({
      where: { id: membershipId, gymId: actor.gymId },
      include: { user: { select: { id: true, name: true } } },
    });
    if (!membership)
      throw new NotFoundException("Member not found at this gym");

    if (!membership.allowProgressMonitoring) {
      throw new ForbiddenException(
        "This member has turned off progress monitoring.",
      );
    }

    const [metrics, attendanceCount, recentAttendance] = await Promise.all([
      this.prisma.bodyMetric.findMany({
        where: { userId: membership.userId },
        orderBy: { recordedAt: "desc" },
        take: 24,
      }),
      this.prisma.attendanceRecord.count({
        where: {
          gymId: actor.gymId,
          subjectId: membership.userId,
          status: "PRESENT",
        },
      }),
      this.prisma.attendanceRecord.findMany({
        where: { gymId: actor.gymId, subjectId: membership.userId },
        orderBy: { date: "desc" },
        take: 30,
        select: { date: true, status: true },
      }),
    ]);

    return {
      member: membership.user,
      goal: membership.goal,
      startsAt: membership.startsAt,
      endsAt: membership.endsAt,
      daysRemaining: daysBetween(new Date(), membership.endsAt),
      totalSessionsAttended: attendanceCount,
      metrics: metrics.map((m) => ({
        recordedAt: m.recordedAt,
        weightKg: m.weightKg == null ? null : Number(m.weightKg),
        heightCm: m.heightCm == null ? null : Number(m.heightCm),
      })),
      recentAttendance,
    };
  }

  // ── Member-facing ──────────────────────────────────────────────────

  /**
   * The member app's home. Returns their memberships across all gyms —
   * which is how the app decides whether to show the gym browser or the
   * membership dashboard.
   */
  async myMemberships(userId: string) {
    const rows = await this.prisma.membership.findMany({
      where: {
        userId,
        status: { in: [MembershipStatus.ACTIVE, MembershipStatus.ON_LEAVE] },
      },
      include: {
        gym: {
          select: {
            id: true,
            name: true,
            district: true,
            contactPhone: true,
            images: { orderBy: { sortOrder: "asc" }, take: 1 },
          },
        },
        assignedTrainer: { select: { user: { select: { name: true } } } },
      },
      orderBy: { endsAt: "desc" },
    });

    return rows.map((row) => ({
      membershipId: row.id,
      gym: {
        id: row.gym.id,
        displayName: `${row.gym.name} - ${row.gym.district}`,
        imageUrl: row.gym.images[0]?.url ?? null,
        contactPhone: row.gym.contactPhone,
      },
      status: row.status,
      startsAt: row.startsAt,
      endsAt: row.endsAt,
      daysRemaining: daysBetween(new Date(), row.endsAt),
      goal: row.goal,
      trainerName: row.assignedTrainer?.user.name ?? null,
      maxLeaveDays: row.maxLeaveDays,
      leaveDaysUsed: row.leaveDaysUsed,
      allowProgressMonitoring: row.allowProgressMonitoring,
    }));
  }

  /** The member's own weight/height history. */
  async myMetrics(userId: string) {
    const metrics = await this.prisma.bodyMetric.findMany({
      where: { userId },
      orderBy: { recordedAt: "desc" },
      take: 36,
    });

    const latest = metrics[0];
    return {
      latest: latest
        ? {
            recordedAt: latest.recordedAt,
            weightKg: latest.weightKg == null ? null : Number(latest.weightKg),
            heightCm: latest.heightCm == null ? null : Number(latest.heightCm),
          }
        : null,
      // The app prompts when the last entry is over a month old, or when
      // there has never been one.
      checkInDue:
        !latest ||
        Date.now() - latest.recordedAt.getTime() > 30 * 24 * 60 * 60 * 1000,
      history: metrics.map((m) => ({
        recordedAt: m.recordedAt,
        weightKg: m.weightKg == null ? null : Number(m.weightKg),
        heightCm: m.heightCm == null ? null : Number(m.heightCm),
      })),
    };
  }

  /**
   * The member's own attendance, at the gyms they belong to.
   *
   * Every other attendance route is gym-scoped and permission-gated, which
   * left the one person whose record it is unable to see it. This needs no
   * permission for the same reason /me/metrics does not: it is their data.
   */
  async myAttendance(userId: string, days = 90) {
    const window = Math.min(Math.max(days, 7), 365);

    const memberships = await this.prisma.membership.findMany({
      where: {
        userId,
        status: { in: [MembershipStatus.ACTIVE, MembershipStatus.ON_LEAVE] },
      },
      select: {
        id: true,
        startsAt: true,
        gym: { select: { id: true, name: true, district: true } },
      },
    });
    if (memberships.length === 0) return [];

    const since = istDay(new Date());
    since.setDate(since.getDate() - window);

    const records = await this.prisma.attendanceRecord.findMany({
      where: {
        subjectId: userId,
        subjectType: SubjectType.MEMBER,
        gymId: { in: memberships.map((m) => m.gym.id) },
        date: { gte: since },
      },
      select: { gymId: true, date: true, status: true },
      orderBy: { date: "asc" },
    });

    return memberships.map((membership) => {
      const mine = records.filter((r) => r.gymId === membership.gym.id);
      const present = mine.filter((r) => r.status === AttendanceStatus.PRESENT);

      // The 1st of the current Indian month. Taking `new Date()` and setting
      // the day to 1 rolls into the next month whenever the server clock is
      // past 18:30 UTC, because that is already tomorrow in India.
      const todayIst = istDay(new Date());
      const monthStart = new Date(
        Date.UTC(todayIst.getUTCFullYear(), todayIst.getUTCMonth(), 1),
      );
      const thisMonth = present.filter((r) => r.date >= monthStart).length;

      // Counted from the later of the window and the day they joined, so a
      // member who signed up last week is not marked down for the weeks
      // before that.
      const countingFrom =
        membership.startsAt > since ? istDay(membership.startsAt) : since;
      const daysCounted = Math.max(
        1,
        Math.round((Date.now() - countingFrom.getTime()) / 86_400_000),
      );

      return {
        membershipId: membership.id,
        gymId: membership.gym.id,
        gymDisplayName: `${membership.gym.name} - ${membership.gym.district}`,
        windowDays: window,
        daysCounted,
        present: present.length,
        absent: mine.length - present.length,
        thisMonth,
        /**
         * Visits per week over the counted period, or null until there is a
         * week to average over. One session on day one is not "7 a week",
         * and showing that would be the app lying to encourage someone.
         */
        visitsPerWeek:
          daysCounted < 7
            ? null
            : Math.round((present.length / daysCounted) * 7 * 10) / 10,
        /**
         * Consecutive weeks ending this one with at least one visit. A daily
         * streak would punish rest days, which every training plan has.
         */
        weekStreak: weekStreak(present.map((r) => r.date)),
        days: mine.map((r) => ({
          date: r.date,
          status: r.status,
        })),
      };
    });
  }

  async recordMetric(userId: string, dto: RecordMetricDto) {
    if (dto.weightKg == null && dto.heightCm == null) {
      throw new BadRequestException("Enter a weight or a height");
    }

    await this.prisma.bodyMetric.create({
      data: {
        userId,
        weightKg:
          dto.weightKg == null ? null : new Prisma.Decimal(dto.weightKg),
        heightCm:
          dto.heightCm == null ? null : new Prisma.Decimal(dto.heightCm),
        source: "SELF",
      },
    });

    return this.myMetrics(userId);
  }

  /** The member turning staff monitoring of their metrics on or off. */
  async setMonitoringConsent(
    userId: string,
    membershipId: string,
    allow: boolean,
  ) {
    const membership = await this.prisma.membership.findFirst({
      where: { id: membershipId, userId },
      select: { id: true },
    });
    if (!membership) {
      throw new NotFoundException("Membership not found");
    }

    await this.prisma.membership.update({
      where: { id: membershipId },
      data: { allowProgressMonitoring: allow },
    });

    return { allowProgressMonitoring: allow };
  }

  // ── Helpers ────────────────────────────────────────────────────────

  private async assertTrainerAssignable(gymId: string, staffMemberId: string) {
    const trainer = await this.prisma.staffMember.findFirst({
      where: { id: staffMemberId, gymId, status: "ACTIVE", isTrainer: true },
      include: {
        trainerCategory: {
          select: { allowsMultipleMembers: true, name: true },
        },
        _count: { select: { assignedMemberships: true } },
      },
    });
    if (!trainer) {
      throw new NotFoundException("Trainer not found at this gym");
    }

    if (
      trainer.trainerCategory?.allowsMultipleMembers === false &&
      trainer._count.assignedMemberships > 0
    ) {
      throw new ConflictException(
        `This ${trainer.trainerCategory.name} trainer already has a member assigned.`,
      );
    }
  }

  private toMemberSummary(row: MembershipRow) {
    return {
      membershipId: row.id,
      user: row.user,
      status: row.status,
      endsAt: row.endsAt,
      daysRemaining: daysBetween(new Date(), row.endsAt),
      goal: row.goal,
      maxLeaveDays: row.maxLeaveDays,
      leaveDaysUsed: row.leaveDaysUsed,
      trainer: row.assignedTrainer
        ? { id: row.assignedTrainer.id, name: row.assignedTrainer.user.name }
        : null,
    };
  }
}

type MembershipRow = Prisma.MembershipGetPayload<{
  include: {
    user: { select: { id: true; name: true; phone: true; email: true } };
    assignedTrainer: { select: { id: true; user: { select: { name: true } } } };
  };
}>;

/** Calendar-month arithmetic that does not overflow (31 Jan + 1 → 28 Feb). */
function addMonths(from: Date, months: number): Date {
  const d = new Date(from);
  const targetDay = d.getDate();
  d.setMonth(d.getMonth() + months);
  if (d.getDate() < targetDay) {
    // Rolled into the next month; step back to the last day of the intended one.
    d.setDate(0);
  }
  return d;
}

function daysBetween(from: Date, to: Date): number {
  return Math.ceil((to.getTime() - from.getTime()) / (24 * 60 * 60 * 1000));
}

/**
 * Consecutive weeks with at least one visit, counting back from this week.
 * The current week does not break the streak while it is still running —
 * otherwise every member's streak reads zero every Monday morning.
 *
 * Weeks are Indian weeks. This used to cut days on the server's own clock,
 * which meant the answer differed between a developer's machine and the
 * deployed host.
 */
function weekStreak(dates: Date[]): number {
  if (dates.length === 0) return 0;

  const weeks = new Set(dates.map((d) => istWeekStart(d).getTime()));
  let cursor = istWeekStart(new Date());

  const back = (from: Date) => new Date(from.getTime() - 7 * 86_400_000);

  let streak = 0;
  if (!weeks.has(cursor.getTime())) {
    cursor = back(cursor);
    if (!weeks.has(cursor.getTime())) return 0;
  }
  while (weeks.has(cursor.getTime())) {
    streak += 1;
    cursor = back(cursor);
  }
  return streak;
}
