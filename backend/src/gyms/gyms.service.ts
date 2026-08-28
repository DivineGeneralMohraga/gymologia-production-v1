import {
  BadRequestException,
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { GymStatus, Permission, Plan, Prisma } from '@prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { AuditService } from '../common/audit/audit.service';
import { PermissionService, ActorContext } from '../rbac/permission.service';
import {
  ALL_PERMISSIONS,
  DEFAULT_ROLES,
  DEFAULT_TRAINER_CATEGORIES,
  ROLE_LEVEL,
} from '../rbac/rbac.constants';
import { normalizePhone } from '../common/utils/phone.util';
import {
  CreateGymDto,
  RateGymDto,
  SearchGymsDto,
  UpdateGymDto,
} from './dto/gym.dto';

/** How many gyms one person may own. A guard against runaway automation. */
const MAX_GYMS_PER_OWNER = 25;

@Injectable()
export class GymsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly permissions: PermissionService,
    private readonly audit: AuditService,
  ) {}

  // ── Creation ───────────────────────────────────────────────────────

  /**
   * Create a gym and everything it cannot function without.
   *
   * One transaction: the gym, its five default roles with their
   * permissions, the two trainer categories, and the owner's own staff
   * record. A gym that exists without an Owner role attached to its
   * creator is unusable and unrecoverable through the API — so either all
   * of it lands or none of it does.
   */
  async create(userId: string, dto: CreateGymDto, meta: RequestMeta) {
    const owned = await this.prisma.gym.count({
      where: { ownerId: userId, deletedAt: null },
    });
    if (owned >= MAX_GYMS_PER_OWNER) {
      throw new BadRequestException(
        `You have reached the limit of ${MAX_GYMS_PER_OWNER} gyms.`,
      );
    }

    const contactPhone = normalizePhone(dto.contactPhone);

    const gym = await this.prisma.$transaction(async (tx) => {
      const created = await tx.gym.create({
        data: {
          ownerId: userId,
          name: dto.name,
          description: dto.description ?? null,
          addressLine1: dto.addressLine1,
          addressLine2: dto.addressLine2 ?? null,
          state: dto.state,
          district: dto.district,
          city: dto.city,
          pincode: dto.pincode,
          contactPhone,
          latitude: dto.latitude ?? null,
          longitude: dto.longitude ?? null,
          maxLeaveDaysPerMonth: dto.maxLeaveDaysPerMonth ?? 4,
          maxLeaveDaysPerMembership: dto.maxLeaveDaysPerMembership ?? 30,
          // A new gym is a draft until a plan is paid for. Nothing is
          // listed publicly and the CRM is usable but empty.
          status: GymStatus.DRAFT,
          perks: dto.perks?.length
            ? { create: dto.perks.map((label) => ({ label })) }
            : undefined,
          images: dto.imageUrls?.length
            ? {
                create: dto.imageUrls.map((url, sortOrder) => ({
                  url,
                  sortOrder,
                })),
              }
            : undefined,
          trainerCategories: { create: DEFAULT_TRAINER_CATEGORIES },
        },
      });

      // Roles, each with its permission rows.
      const roleIdByName = new Map<string, string>();
      for (const spec of DEFAULT_ROLES) {
        const role = await tx.role.create({
          data: {
            gymId: created.id,
            name: spec.name,
            level: spec.level,
            isSystem: spec.isSystem,
            isSuper: spec.isSuper,
            exemptFromAttendance: spec.exemptFromAttendance,
            permissions: {
              create: spec.permissions.map((permission) => ({ permission })),
            },
          },
          select: { id: true },
        });
        roleIdByName.set(spec.name, role.id);
      }

      const ownerRoleId = roleIdByName.get('Owner');
      if (!ownerRoleId) {
        // Cannot happen unless DEFAULT_ROLES is edited badly; failing here
        // rolls the whole thing back rather than leaving an orphan gym.
        throw new Error('Owner role missing from DEFAULT_ROLES');
      }

      await tx.staffMember.create({
        data: { gymId: created.id, userId, roleId: ownerRoleId },
      });

      return created;
    });

    await this.audit.record({
      actorId: userId,
      gymId: gym.id,
      action: 'gym.create',
      entityType: 'Gym',
      entityId: gym.id,
      after: { name: gym.name, district: gym.district },
      ip: meta.ip,
      userAgent: meta.userAgent,
    });

    return this.findOneForStaff(gym.id, userId);
  }

  // ── Reading ────────────────────────────────────────────────────────

  /**
   * Every gym this person can open the CRM for — owned or worked at.
   * This is the staff app's first screen.
   */
  async listMine(userId: string) {
    const staffRows = await this.prisma.staffMember.findMany({
      where: { userId, status: 'ACTIVE', gym: { deletedAt: null } },
      include: {
        role: { select: { id: true, name: true, level: true, isSuper: true } },
        gym: {
          include: {
            images: { orderBy: { sortOrder: 'asc' }, take: 1 },
            _count: { select: { memberships: true, staff: true, perks: true } },
            subscriptions: {
              where: { status: 'ACTIVE' },
              orderBy: { endsAt: 'desc' },
              take: 1,
            },
          },
        },
      },
      orderBy: { joinedAt: 'asc' },
    });

    return staffRows.map((row) => ({
      ...this.toGymSummary(row.gym),
      isOwner: row.gym.ownerId === userId,
      myRole: row.role,
      staffMemberId: row.id,
    }));
  }

  /** Full profile for someone who works there. */
  async findOneForStaff(gymId: string, userId: string) {
    const gym = await this.prisma.gym.findFirst({
      where: { id: gymId, deletedAt: null },
      include: {
        images: { orderBy: { sortOrder: 'asc' } },
        perks: true,
        kyc: { select: { aadhaarStatus: true, panStatus: true, gstStatus: true, videoKycStatus: true } },
        subscriptions: { where: { status: 'ACTIVE' }, orderBy: { endsAt: 'desc' }, take: 1 },
        _count: { select: { memberships: true, staff: true } },
      },
    });
    if (!gym) throw new NotFoundException('Gym not found');

    const actor = await this.permissions.getActorContext(userId, gymId);

    return {
      ...this.toGymDetail(gym),
      access: this.permissions.describe(actor),
    };
  }

  /**
   * Public gym profile, as a prospective member sees it. Only what the
   * spec lists: images, name, description, perks, contact.
   */
  async findOnePublic(gymId: string) {
    const gym = await this.prisma.gym.findFirst({
      where: { id: gymId, deletedAt: null, status: GymStatus.ACTIVE },
      include: {
        images: { orderBy: { sortOrder: 'asc' } },
        perks: true,
        subscriptions: { where: { status: 'ACTIVE' }, orderBy: { endsAt: 'desc' }, take: 1 },
      },
    });
    if (!gym) throw new NotFoundException('Gym not found');

    return {
      id: gym.id,
      displayName: `${gym.name} - ${gym.district}`,
      name: gym.name,
      description: gym.description,
      district: gym.district,
      state: gym.state,
      city: gym.city,
      images: gym.images.map((i) => i.url),
      perks: gym.perks.map((p) => p.label),
      perkCount: gym.perks.length,
      rating: Number(gym.ratingAverage),
      ratingCount: gym.ratingCount,
      contactPhone: gym.contactPhone,
    };
  }

  /**
   * The member app's gym browser.
   *
   * Only PRO gyms that have opted into public listing appear — that is
   * what the pro plan buys. Ranking follows the spec: nearby first when
   * the phone shared coordinates, otherwise by rating weighted by how
   * many people rated.
   *
   * Distance is computed in memory after filtering by locality. At launch
   * scale that is the right trade; past a few thousand listed gyms this
   * wants PostGIS and an index.
   */
  async search(dto: SearchGymsDto) {
    const limit = dto.limit ?? 20;
    const offset = dto.offset ?? 0;

    const where: Prisma.GymWhereInput = {
      deletedAt: null,
      status: GymStatus.ACTIVE,
      publicListing: true,
      subscriptions: {
        some: {
          status: 'ACTIVE',
          plan: Plan.PRO,
          endsAt: { gt: new Date() },
        },
      },
      ...(dto.state ? { state: { equals: dto.state, mode: 'insensitive' } } : {}),
      ...(dto.district
        ? { district: { equals: dto.district, mode: 'insensitive' } }
        : {}),
      ...(dto.query
        ? {
            OR: [
              { name: { contains: dto.query, mode: 'insensitive' } },
              { city: { contains: dto.query, mode: 'insensitive' } },
              { district: { contains: dto.query, mode: 'insensitive' } },
            ],
          }
        : {}),
    };

    const gyms = await this.prisma.gym.findMany({
      where,
      include: {
        images: { orderBy: { sortOrder: 'asc' }, take: 1 },
        _count: { select: { perks: true } },
      },
      // Over-fetch so in-memory distance ranking has something to sort.
      take: dto.latitude != null ? 200 : limit + offset,
      skip: dto.latitude != null ? 0 : offset,
      orderBy: [{ ratingAverage: 'desc' }, { ratingCount: 'desc' }],
    });

    const scored = gyms.map((gym) => {
      const distanceKm =
        dto.latitude != null &&
        dto.longitude != null &&
        gym.latitude != null &&
        gym.longitude != null
          ? haversineKm(
              dto.latitude,
              dto.longitude,
              Number(gym.latitude),
              Number(gym.longitude),
            )
          : null;

      return {
        id: gym.id,
        displayName: `${gym.name} - ${gym.district}`,
        district: gym.district,
        state: gym.state,
        city: gym.city,
        imageUrl: gym.images[0]?.url ?? null,
        rating: Number(gym.ratingAverage),
        ratingCount: gym.ratingCount,
        perkCount: gym._count.perks,
        distanceKm: distanceKm == null ? null : Math.round(distanceKm * 10) / 10,
      };
    });

    if (dto.latitude != null) {
      scored.sort((a, b) => {
        // Gyms without coordinates sink below those with them.
        if (a.distanceKm == null && b.distanceKm == null) {
          return b.rating - a.rating;
        }
        if (a.distanceKm == null) return 1;
        if (b.distanceKm == null) return -1;
        return a.distanceKm - b.distanceKm;
      });
      return scored.slice(offset, offset + limit);
    }

    return scored.slice(0, limit);
  }

  /**
   * Roles at this gym, annotated with whether the caller may assign each
   * one. Assignable means strictly junior to the caller's own role — the
   * same rule the server enforces on the write, surfaced early so a
   * picker never offers something that would be refused.
   */
  async roles(actor: ActorContext) {
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
      assignable: this.permissions.outranks(actor, role.level),
    }));
  }

  // ── Mutation ───────────────────────────────────────────────────────

  async update(
    actor: ActorContext,
    dto: UpdateGymDto,
    meta: RequestMeta,
  ) {
    this.permissions.assert(actor, Permission.EDIT_GYM_PROFILE);

    const before = await this.prisma.gym.findUnique({
      where: { id: actor.gymId },
      select: { name: true, district: true, maxLeaveDaysPerMonth: true },
    });

    const { perks, imageUrls, contactPhone, ...rest } = dto;

    await this.prisma.$transaction(async (tx) => {
      await tx.gym.update({
        where: { id: actor.gymId },
        data: {
          ...rest,
          ...(contactPhone ? { contactPhone: normalizePhone(contactPhone) } : {}),
        },
      });

      // Perks and images are replace-in-full: the client sends the list it
      // wants, which is simpler to reason about than a patch protocol.
      if (perks) {
        await tx.gymPerk.deleteMany({ where: { gymId: actor.gymId } });
        if (perks.length) {
          await tx.gymPerk.createMany({
            data: perks.map((label) => ({ gymId: actor.gymId, label })),
          });
        }
      }
      if (imageUrls) {
        await tx.gymImage.deleteMany({ where: { gymId: actor.gymId } });
        if (imageUrls.length) {
          await tx.gymImage.createMany({
            data: imageUrls.map((url, sortOrder) => ({
              gymId: actor.gymId,
              url,
              sortOrder,
            })),
          });
        }
      }
    });

    await this.audit.record({
      actorId: actor.userId,
      gymId: actor.gymId,
      action: 'gym.update',
      entityType: 'Gym',
      entityId: actor.gymId,
      before,
      after: rest,
      ip: meta.ip,
      userAgent: meta.userAgent,
    });

    return this.findOneForStaff(actor.gymId, actor.userId);
  }

  /**
   * Soft delete. Only the person the gym is registered to — checked
   * against ownership, not a role, because DELETE_GYM is ungrantable.
   */
  async remove(actor: ActorContext, meta: RequestMeta) {
    if (!actor.isGymOwner) {
      throw new ForbiddenException('Only the gym owner can delete this gym');
    }

    await this.prisma.gym.update({
      where: { id: actor.gymId },
      data: { deletedAt: new Date(), status: GymStatus.DELETED },
    });

    await this.audit.record({
      actorId: actor.userId,
      gymId: actor.gymId,
      action: 'gym.delete',
      entityType: 'Gym',
      entityId: actor.gymId,
      ip: meta.ip,
      userAgent: meta.userAgent,
    });

    return { deleted: true };
  }

  /**
   * A rating may only come from someone who holds or held a membership
   * there, and each person gets exactly one. Staff cannot alter or remove
   * it — there is no endpoint that lets them.
   */
  async rate(gymId: string, userId: string, dto: RateGymDto) {
    const membership = await this.prisma.membership.findFirst({
      where: { gymId, userId },
      select: { id: true },
    });
    if (!membership) {
      throw new ForbiddenException(
        'Only members of this gym can rate it',
      );
    }

    await this.prisma.$transaction(async (tx) => {
      await tx.gymRating.upsert({
        where: { gymId_userId: { gymId, userId } },
        create: { gymId, userId, stars: dto.stars, comment: dto.comment ?? null },
        update: { stars: dto.stars, comment: dto.comment ?? null },
      });

      // Recompute from the rows rather than incrementing a counter, so a
      // changed rating cannot drift the average.
      const agg = await tx.gymRating.aggregate({
        where: { gymId },
        _avg: { stars: true },
        _count: true,
      });

      await tx.gym.update({
        where: { id: gymId },
        data: {
          ratingAverage: new Prisma.Decimal(agg._avg.stars ?? 0),
          ratingCount: agg._count,
        },
      });
    });

    return this.findOnePublic(gymId);
  }

  // ── Shaping ────────────────────────────────────────────────────────

  private toGymSummary(gym: GymWithSummary) {
    const plan = gym.subscriptions?.[0];
    return {
      id: gym.id,
      name: gym.name,
      displayName: `${gym.name} - ${gym.district}`,
      district: gym.district,
      state: gym.state,
      city: gym.city,
      status: gym.status,
      imageUrl: gym.images?.[0]?.url ?? null,
      memberCount: gym._count?.memberships ?? 0,
      staffCount: gym._count?.staff ?? 0,
      perkCount: gym._count?.perks ?? 0,
      rating: Number(gym.ratingAverage),
      ratingCount: gym.ratingCount,
      plan: plan?.plan ?? null,
      planEndsAt: plan?.endsAt ?? null,
      isTrial: plan?.isTrial ?? false,
    };
  }

  private toGymDetail(gym: GymWithDetail) {
    const plan = gym.subscriptions?.[0];
    return {
      id: gym.id,
      name: gym.name,
      displayName: `${gym.name} - ${gym.district}`,
      description: gym.description,
      addressLine1: gym.addressLine1,
      addressLine2: gym.addressLine2,
      state: gym.state,
      district: gym.district,
      city: gym.city,
      pincode: gym.pincode,
      latitude: gym.latitude == null ? null : Number(gym.latitude),
      longitude: gym.longitude == null ? null : Number(gym.longitude),
      contactPhone: gym.contactPhone,
      maxLeaveDaysPerMonth: gym.maxLeaveDaysPerMonth,
      maxLeaveDaysPerMembership: gym.maxLeaveDaysPerMembership,
      status: gym.status,
      publicListing: gym.publicListing,
      images: gym.images?.map((i) => i.url) ?? [],
      perks: gym.perks?.map((p) => p.label) ?? [],
      rating: Number(gym.ratingAverage),
      ratingCount: gym.ratingCount,
      memberCount: gym._count?.memberships ?? 0,
      staffCount: gym._count?.staff ?? 0,
      kyc: gym.kyc ?? null,
      plan: plan
        ? {
            plan: plan.plan,
            status: plan.status,
            endsAt: plan.endsAt,
            isTrial: plan.isTrial,
          }
        : null,
      ownerRoleLevel: ROLE_LEVEL.OWNER,
    };
  }
}

export interface RequestMeta {
  ip?: string | null;
  userAgent?: string | null;
}

type GymWithSummary = Prisma.GymGetPayload<{
  include: {
    images: true;
    _count: { select: { memberships: true; staff: true; perks: true } };
    subscriptions: true;
  };
}>;

type GymWithDetail = Prisma.GymGetPayload<{
  include: {
    images: true;
    perks: true;
    kyc: {
      select: {
        aadhaarStatus: true;
        panStatus: true;
        gstStatus: true;
        videoKycStatus: true;
      };
    };
    subscriptions: true;
    _count: { select: { memberships: true; staff: true } };
  };
}>;

/** Great-circle distance in kilometres. */
function haversineKm(
  lat1: number,
  lon1: number,
  lat2: number,
  lon2: number,
): number {
  const R = 6371;
  const toRad = (d: number) => (d * Math.PI) / 180;
  const dLat = toRad(lat2 - lat1);
  const dLon = toRad(lon2 - lon1);
  const a =
    Math.sin(dLat / 2) ** 2 +
    Math.cos(toRad(lat1)) * Math.cos(toRad(lat2)) * Math.sin(dLon / 2) ** 2;
  return 2 * R * Math.asin(Math.sqrt(a));
}
