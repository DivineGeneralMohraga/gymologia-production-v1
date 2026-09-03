import {
  BadRequestException,
  ConflictException,
  ForbiddenException,
  Injectable,
  Logger,
  NotFoundException,
  OnModuleInit,
} from '@nestjs/common';
import {
  AdminRole,
  AppClient,
  GymStatus,
  MembershipStatus,
  OtpPurpose,
  StaffStatus,
  TicketStatus,
} from '@prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { AuditService } from '../common/audit/audit.service';
import { PersonLookupService } from '../people/person-lookup.service';
import { istDay } from '../common/utils/day';
import type { RequestMeta } from '../gyms/gyms.service';
import type { AdminContext } from './admin.guard';
import {
  AddAdminStaffDto,
  ListLogsDto,
  ListTicketsDto,
  ResolveTicketDto,
  UpdateAdminStaffDto,
} from './dto/admin.dto';

/**
 * The internal console: who works here, what the platform looks like today,
 * the support queue, and the logs.
 *
 * Everything an admin does here crosses a tenancy boundary — these are the
 * only endpoints in the system that read across gyms — so every mutation is
 * written to the audit log with the admin's own id, not the gym's.
 */
@Injectable()
export class AdminService implements OnModuleInit {
  private readonly logger = new Logger(AdminService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly audit: AuditService,
    private readonly lookup: PersonLookupService,
  ) {}

  /**
   * The first admin has to come from somewhere, and it cannot be an endpoint
   * or anyone could call it. ADMIN_BOOTSTRAP_PHONE promotes exactly one
   * account, and only while no admin exists at all — so it is a way to start
   * the system, never a way to climb into it later.
   */
  async onModuleInit() {
    const phone = process.env.ADMIN_BOOTSTRAP_PHONE?.trim();
    if (!phone) return;

    const existing = await this.prisma.adminStaff.count();
    if (existing > 0) return;

    const user = await this.prisma.user.findUnique({
      where: { phone },
      select: { id: true, name: true },
    });
    if (!user) {
      this.logger.warn(
        `ADMIN_BOOTSTRAP_PHONE ${maskPhone(phone)} has no account yet. ` +
          'Sign in on the app once, then restart, and it becomes the owner.',
      );
      return;
    }

    await this.prisma.adminStaff.create({
      data: { userId: user.id, role: AdminRole.OWNER },
    });
    this.logger.warn(
      `Bootstrapped ${user.name} (${maskPhone(phone)}) as admin OWNER. ` +
        'This runs only while there are no admins at all.',
    );
  }

  /** Whether this account can open the admin app, and as what. */
  async whoami(admin: AdminContext) {
    return {
      adminId: admin.adminId,
      name: admin.name,
      role: admin.role,
      canManageStaff:
        admin.role === AdminRole.OWNER || admin.role === AdminRole.ADMIN,
      canSeeLogs:
        admin.role === AdminRole.OWNER || admin.role === AdminRole.ADMIN,
      canHandleSupport: admin.role !== AdminRole.KYC_AGENT,
      canBroadcast:
        admin.role === AdminRole.OWNER || admin.role === AdminRole.ADMIN,
    };
  }

  // ── Dashboard ──────────────────────────────────────────────────────

  /**
   * The numbers the spec asks for on the admin dashboard: how many people
   * are on each app, how many gyms are live, and how much of the membership
   * base is actually training.
   */
  async dashboard() {
    const monthAgo = new Date();
    monthAgo.setDate(monthAgo.getDate() - 30);
    const since = istDay(monthAgo);

    const [
      users,
      newUsers,
      gymsByStatus,
      staffCount,
      owners,
      activeMemberships,
      engaged,
      openTickets,
      urgentTickets,
      installs,
    ] = await Promise.all([
      this.prisma.user.count(),
      this.prisma.user.count({ where: { createdAt: { gte: monthAgo } } }),
      this.prisma.gym.groupBy({
        by: ['status'],
        where: { deletedAt: null },
        _count: { _all: true },
      }),
      this.prisma.staffMember.count({ where: { status: StaffStatus.ACTIVE } }),
      // Both of these are COUNT(DISTINCT ...) in SQL rather than a findMany
      // whose rows are then counted in JavaScript. The dashboard is
      // platform-wide, so the naive version drags every distinct owner and
      // every distinct attending member across the wire to produce two
      // integers -- fine on a test database, ruinous on a real one.
      this.prisma.$queryRaw<{ count: number }[]>`
        SELECT COUNT(DISTINCT "ownerId")::int AS count
        FROM gyms
        WHERE "deletedAt" IS NULL
      `,
      this.prisma.membership.count({
        where: { status: MembershipStatus.ACTIVE },
      }),
      this.prisma.$queryRaw<{ count: number }[]>`
        SELECT COUNT(DISTINCT "subjectId")::int AS count
        FROM attendance_records
        WHERE "subjectType"::text = 'MEMBER'
          AND status::text = 'PRESENT'
          AND date >= ${since}
      `,
      this.prisma.supportTicket.count({ where: { status: TicketStatus.OPEN } }),
      this.prisma.supportTicket.count({
        where: { status: TicketStatus.OPEN, priority: 'URGENT' },
      }),
      this.prisma.appInstallStat.findMany().catch(() => []),
    ]);

    const byStatus = Object.fromEntries(
      gymsByStatus.map((row) => [row.status, row._count._all]),
    ) as Record<string, number>;

    return {
      people: {
        total: users,
        newInLast30Days: newUsers,
        /** Staff records, not people: one person can work at several gyms. */
        gymStaffRecords: staffCount,
        gymOwners: owners[0]?.count ?? 0,
      },
      gyms: {
        active: byStatus[GymStatus.ACTIVE] ?? 0,
        draft: byStatus[GymStatus.DRAFT] ?? 0,
        suspended: byStatus[GymStatus.SUSPENDED] ?? 0,
        total: Object.values(byStatus).reduce((a, b) => a + b, 0),
      },
      members: {
        active: activeMemberships,
        /** Trained at least once in the last 30 days. */
        engaged: engaged[0]?.count ?? 0,
        engagementRate:
          activeMemberships === 0
            ? 0
            : Math.round(((engaged[0]?.count ?? 0) / activeMemberships) * 100),
      },
      support: { open: openTickets, urgent: urgentTickets },
      // Install counts are only as good as whatever reports them; the table
      // exists and is empty until something does.
      installs: installs.map((row) => ({
        appClient: row.appClient,
        platform: row.platform,
        installs: row.installs,
      })),
    };
  }

  // ── Admin staff ────────────────────────────────────────────────────

  async listStaff() {
    const rows = await this.prisma.adminStaff.findMany({
      include: { user: { select: { name: true, phone: true, email: true } } },
      orderBy: { createdAt: 'asc' },
    });

    return rows.map((row) => ({
      id: row.id,
      name: row.user.name,
      phone: maskPhone(row.user.phone),
      workEmail: row.workEmail,
      role: row.role,
      status: row.status,
      createdAt: row.createdAt,
    }));
  }

  /**
   * Adding an admin requires the person to verify the number they are being
   * added on, exactly like adding gym staff. An internal account that can
   * read every gym's data is not something to hand out on a typed number.
   */
  async startStaffLookup(admin: AdminContext, phone: string, ip?: string) {
    this.assertManagesStaff(admin);
    return this.lookup.startLookup(phone, OtpPurpose.ADMIN_STAFF_ADD, ip);
  }

  async addStaff(admin: AdminContext, dto: AddAdminStaffDto, meta: RequestMeta) {
    this.assertManagesStaff(admin);

    if (dto.role === AdminRole.OWNER && admin.role !== AdminRole.OWNER) {
      throw new ForbiddenException('Only an owner can appoint another owner');
    }

    // Checked before the code is verified, not after. The gym-staff flow
    // creates a placeholder account for a number nobody has signed in from,
    // which is right there and wrong here: an internal account reads every
    // gym on the platform and should only ever attach to a real person who
    // has been through login themselves. Checking first also avoids burning
    // their one-time code on a request that cannot succeed. It leaks
    // nothing: the lookup step already told this admin whether the number
    // has an account.
    const known = await this.prisma.user.findUnique({
      where: { phone: normalizeIndianPhone(dto.phone) },
      select: { id: true },
    });
    if (!known) {
      throw new BadRequestException(
        'This number has never signed in to Gymologia. Ask them to open the app once first.',
      );
    }

    const verified = await this.lookup.verifyAndResolve(
      { challengeId: dto.challengeId, phone: dto.phone, code: dto.code },
      OtpPurpose.ADMIN_STAFF_ADD,
      meta.ip,
    );

    const user = await this.prisma.user.findUniqueOrThrow({
      where: { id: verified.userId },
      select: { id: true, name: true },
    });

    const existing = await this.prisma.adminStaff.findUnique({
      where: { userId: user.id },
    });
    if (existing && existing.status === StaffStatus.ACTIVE) {
      throw new ConflictException('This person is already on the admin team');
    }

    const staff = existing
      ? await this.prisma.adminStaff.update({
          where: { id: existing.id },
          data: {
            role: dto.role,
            status: StaffStatus.ACTIVE,
            workEmail: dto.workEmail ?? existing.workEmail,
            dateOfBirth: dto.dateOfBirth ? new Date(dto.dateOfBirth) : existing.dateOfBirth,
          },
        })
      : await this.prisma.adminStaff.create({
          data: {
            userId: user.id,
            role: dto.role,
            workEmail: dto.workEmail ?? null,
            dateOfBirth: dto.dateOfBirth ? new Date(dto.dateOfBirth) : null,
            addedById: admin.adminId,
          },
        });

    await this.audit.record({
      actorId: admin.userId,
      action: existing ? 'admin.staff.reinstate' : 'admin.staff.add',
      entityType: 'AdminStaff',
      entityId: staff.id,
      after: { role: dto.role, name: user.name },
      ip: meta.ip,
      userAgent: meta.userAgent,
    });

    return this.listStaff();
  }

  async updateStaff(
    admin: AdminContext,
    staffId: string,
    dto: UpdateAdminStaffDto,
    meta: RequestMeta,
  ) {
    this.assertManagesStaff(admin);

    const target = await this.prisma.adminStaff.findUnique({
      where: { id: staffId },
    });
    if (!target) throw new NotFoundException('Admin staff member not found');

    // Nobody edits themselves out of, or further into, their own authority.
    if (target.userId === admin.userId) {
      throw new ForbiddenException('You cannot change your own admin record');
    }
    if (target.role === AdminRole.OWNER && admin.role !== AdminRole.OWNER) {
      throw new ForbiddenException('Only an owner can act on another owner');
    }
    if (dto.role === AdminRole.OWNER && admin.role !== AdminRole.OWNER) {
      throw new ForbiddenException('Only an owner can appoint another owner');
    }

    // The last active owner cannot be demoted or switched off, or the
    // console locks everyone out with no way back in short of the database.
    if (
      target.role === AdminRole.OWNER &&
      (dto.role !== undefined || dto.status === StaffStatus.REMOVED)
    ) {
      const owners = await this.prisma.adminStaff.count({
        where: { role: AdminRole.OWNER, status: StaffStatus.ACTIVE },
      });
      if (owners <= 1) {
        throw new ConflictException(
          'This is the last active owner. Appoint another before changing this one.',
        );
      }
    }

    await this.prisma.adminStaff.update({
      where: { id: staffId },
      data: {
        ...(dto.role !== undefined ? { role: dto.role } : {}),
        ...(dto.status !== undefined ? { status: dto.status } : {}),
        ...(dto.workEmail !== undefined ? { workEmail: dto.workEmail } : {}),
      },
    });

    await this.audit.record({
      actorId: admin.userId,
      action: 'admin.staff.update',
      entityType: 'AdminStaff',
      entityId: staffId,
      before: { role: target.role, status: target.status },
      after: dto as Record<string, unknown>,
      ip: meta.ip,
      userAgent: meta.userAgent,
    });

    return this.listStaff();
  }

  // ── Support ────────────────────────────────────────────────────────

  async listTickets(dto: ListTicketsDto) {
    const take = Math.min(dto.limit ?? 50, 200);
    const where = {
      ...(dto.status ? { status: dto.status } : {}),
      ...(dto.priority ? { priority: dto.priority } : {}),
      ...(dto.appClient ? { appClient: dto.appClient } : {}),
    };

    const [items, total] = await Promise.all([
      this.prisma.supportTicket.findMany({
        where,
        take,
        skip: dto.offset ?? 0,
        // Urgent first, then oldest: a queue sorted purely by age buries the
        // gym that cannot operate under a week of routine questions.
        orderBy: [{ priority: 'desc' }, { createdAt: 'asc' }],
        include: {
          user: { select: { name: true } },
          assignedAdmin: { include: { user: { select: { name: true } } } },
        },
      }),
      this.prisma.supportTicket.count({ where }),
    ]);

    return {
      total,
      items: items.map((t) => ({
        id: t.id,
        subject: t.subject,
        message: t.message,
        appClient: t.appClient,
        contactPhone: maskPhone(t.contactPhone),
        contactEmail: t.contactEmail,
        status: t.status,
        priority: t.priority,
        reportedBy: t.user?.name ?? null,
        assignedTo: t.assignedAdmin?.user.name ?? null,
        assignedAdminId: t.assignedAdminId,
        resolutionNote: t.resolutionNote,
        createdAt: t.createdAt,
        resolvedAt: t.resolvedAt,
      })),
    };
  }

  async claimTicket(admin: AdminContext, ticketId: string, meta: RequestMeta) {
    this.assertHandlesSupport(admin);

    const ticket = await this.prisma.supportTicket.findUnique({
      where: { id: ticketId },
    });
    if (!ticket) throw new NotFoundException('Ticket not found');
    if (ticket.assignedAdminId && ticket.assignedAdminId !== admin.adminId) {
      throw new ConflictException('Someone else is already on this ticket');
    }

    await this.prisma.supportTicket.update({
      where: { id: ticketId },
      data: {
        assignedAdminId: admin.adminId,
        status: ticket.status === TicketStatus.OPEN
          ? TicketStatus.IN_PROGRESS
          : ticket.status,
      },
    });

    await this.audit.record({
      actorId: admin.userId,
      action: 'admin.ticket.claim',
      entityType: 'SupportTicket',
      entityId: ticketId,
      ip: meta.ip,
      userAgent: meta.userAgent,
    });

    return { claimed: true };
  }

  async resolveTicket(
    admin: AdminContext,
    ticketId: string,
    dto: ResolveTicketDto,
    meta: RequestMeta,
  ) {
    this.assertHandlesSupport(admin);

    const ticket = await this.prisma.supportTicket.findUnique({
      where: { id: ticketId },
    });
    if (!ticket) throw new NotFoundException('Ticket not found');
    if (ticket.status === TicketStatus.RESOLVED) {
      throw new ConflictException('This ticket is already resolved');
    }

    await this.prisma.supportTicket.update({
      where: { id: ticketId },
      data: {
        status: TicketStatus.RESOLVED,
        resolutionNote: dto.note,
        resolvedAt: new Date(),
        assignedAdminId: ticket.assignedAdminId ?? admin.adminId,
      },
    });

    await this.audit.record({
      actorId: admin.userId,
      action: 'admin.ticket.resolve',
      entityType: 'SupportTicket',
      entityId: ticketId,
      after: { note: dto.note },
      ip: meta.ip,
      userAgent: meta.userAgent,
    });

    return { resolved: true };
  }

  // ── Logs ───────────────────────────────────────────────────────────

  async auditLog(dto: ListLogsDto) {
    const take = Math.min(dto.limit ?? 50, 200);
    const where = {
      ...(dto.action ? { action: { contains: dto.action, mode: 'insensitive' as const } } : {}),
      ...(dto.gymId ? { gymId: dto.gymId } : {}),
    };

    const [items, total] = await Promise.all([
      this.prisma.auditLog.findMany({
        where,
        take,
        skip: dto.offset ?? 0,
        orderBy: { createdAt: 'desc' },
        include: { actor: { select: { name: true } } },
      }),
      this.prisma.auditLog.count({ where }),
    ]);

    // AuditLog keeps gymId as a plain column rather than a relation, so that
    // a log line survives the gym it describes being deleted. Names are
    // resolved for the rows on this page only.
    const gymNames = await this.namesForGyms(
      items.map((row) => row.gymId).filter((id): id is string => id !== null),
    );

    return {
      total,
      items: items.map((row) => ({
        id: row.id,
        action: row.action,
        entityType: row.entityType,
        entityId: row.entityId,
        actor: row.actor?.name ?? null,
        gym: row.gymId ? (gymNames.get(row.gymId) ?? 'deleted gym') : null,
        before: row.before,
        after: row.after,
        ip: row.ip,
        createdAt: row.createdAt,
      })),
    };
  }

  async securityLog(dto: ListLogsDto) {
    const take = Math.min(dto.limit ?? 50, 200);
    const where = dto.severity ? { severity: dto.severity } : {};

    const [items, total] = await Promise.all([
      this.prisma.securityEvent.findMany({
        where,
        take,
        skip: dto.offset ?? 0,
        orderBy: { createdAt: 'desc' },
      }),
      this.prisma.securityEvent.count({ where }),
    ]);

    // Same reasoning as the audit log: userId is a column, not a relation,
    // so an event about an account still reads after that account is gone.
    const userNames = await this.namesForUsers(
      items.map((row) => row.userId).filter((id): id is string => id !== null),
    );

    return {
      total,
      items: items.map((row) => ({
        id: row.id,
        type: row.type,
        severity: row.severity,
        user: row.userId ? (userNames.get(row.userId) ?? 'deleted account') : null,
        ip: row.ip,
        route: row.route,
        details: row.details,
        actionTaken: row.actionTaken,
        createdAt: row.createdAt,
      })),
    };
  }

  // ── Helpers ────────────────────────────────────────────────────────

  private async namesForGyms(ids: string[]): Promise<Map<string, string>> {
    if (ids.length === 0) return new Map();
    const rows = await this.prisma.gym.findMany({
      where: { id: { in: [...new Set(ids)] } },
      select: { id: true, name: true },
    });
    return new Map(rows.map((row) => [row.id, row.name]));
  }

  private async namesForUsers(ids: string[]): Promise<Map<string, string>> {
    if (ids.length === 0) return new Map();
    const rows = await this.prisma.user.findMany({
      where: { id: { in: [...new Set(ids)] } },
      select: { id: true, name: true },
    });
    return new Map(rows.map((row) => [row.id, row.name]));
  }

  // ── Guards ─────────────────────────────────────────────────────────

  private assertManagesStaff(admin: AdminContext) {
    if (admin.role !== AdminRole.OWNER && admin.role !== AdminRole.ADMIN) {
      throw new ForbiddenException('Your role does not cover managing staff');
    }
  }

  private assertHandlesSupport(admin: AdminContext) {
    if (admin.role === AdminRole.KYC_AGENT) {
      throw new ForbiddenException('Your role does not cover support');
    }
  }
}

/**
 * Phone numbers are masked everywhere in the console. An admin needs to know
 * which ticket belongs to whom, not to be able to copy a list of every
 * number on the platform out of a support screen.
 */
function maskPhone(phone: string): string {
  if (phone.length < 7) return '***';
  return `${phone.slice(0, 3)}******${phone.slice(-4)}`;
}

export type AdminAppClient = AppClient;

/**
 * The same normalisation the lookup applies, so the pre-check above compares
 * like with like. A number typed as 9876543210 and one as +919876543210 are
 * the same person.
 */
function normalizeIndianPhone(raw: string): string {
  const digits = raw.replace(/\D/g, '');
  const last10 = digits.slice(-10);
  return `+91${last10}`;
}
