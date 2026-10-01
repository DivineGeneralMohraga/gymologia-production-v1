import { ForbiddenException, Injectable, NotFoundException } from '@nestjs/common';
import { GymStatus, Permission, Plan, Prisma } from '@prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { PermissionService, ActorContext } from '../rbac/permission.service';
import { kycRequiredForListing } from './listing-rules';

/**
 * Where a gym sits in Gymologia's search results.
 *
 * The position is computed with the same rule the search endpoint sorts by
 * — rating first, then how many ratings back it up — over the same eligible
 * set. If the two ever diverge, this screen becomes a number that means
 * nothing, so they are written to be read together.
 *
 * Only PRO gyms appear in search at all, so only PRO gyms have a position.
 * A Basic gym is told that plainly rather than shown a rank it does not have.
 */
@Injectable()
export class RankingService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly permissions: PermissionService,
  ) {}

  async forGym(actor: ActorContext) {
    this.permissions.assert(actor, Permission.VIEW_RANKING);

    const gym = await this.prisma.gym.findFirst({
      where: { id: actor.gymId, deletedAt: null },
      select: {
        id: true,
        name: true,
        city: true,
        district: true,
        state: true,
        status: true,
        publicListing: true,
        ratingAverage: true,
        ratingCount: true,
        subscriptions: {
          where: { status: 'ACTIVE', endsAt: { gt: new Date() } },
          select: { plan: true },
          take: 1,
        },
        kyc: { select: { verifiedAt: true } },
      },
    });
    if (!gym) throw new NotFoundException('Gym not found');

    const plan = gym.subscriptions[0]?.plan ?? null;
    // Counts as verified while the KYC gate is off (listing-rules.ts).
    const kycVerified = !kycRequiredForListing() || gym.kyc?.verifiedAt != null;
    const listed =
      plan === Plan.PRO &&
      gym.status === GymStatus.ACTIVE &&
      gym.publicListing &&
      kycVerified;

    if (!listed) {
      // Say which of the four reasons it is. "You are not ranked" without
      // a reason leaves an owner unable to act on it.
      return {
        listed: false,
        plan,
        reason:
          plan !== Plan.PRO
            ? 'Only Pro gyms appear in Gymologia search. Upgrade to be ranked.'
            : gym.status !== GymStatus.ACTIVE
              ? 'Your gym is not active, so it is not being shown in search.'
              : !kycVerified
                ? 'Your KYC verification is not complete yet, so you are not being shown in search.'
                : 'Public listing is switched off in your gym profile.',
        rating: Number(gym.ratingAverage),
        ratingCount: gym.ratingCount,
        scopes: [],
      };
    }

    const rating = new Prisma.Decimal(gym.ratingAverage);

    const scopes = await Promise.all([
      this.scope(gym, rating, 'city'),
      this.scope(gym, rating, 'district'),
      this.scope(gym, rating, 'state'),
      this.scope(gym, rating, 'india'),
    ]);

    return {
      listed: true,
      plan,
      rating: Number(gym.ratingAverage),
      ratingCount: gym.ratingCount,
      scopes,
      // Rating drives the order, so this is the lever an owner actually has.
      advice:
        gym.ratingCount === 0
          ? 'No members have rated you yet. Ratings are what decide the order.'
          : null,
    };
  }

  /**
   * Position within one scope: how many eligible gyms rank strictly above
   * this one, plus one.
   *
   * "Above" is the same comparison search sorts by — a higher rating wins,
   * and on a tie the gym with more ratings behind it wins.
   */
  private async scope(
    gym: {
      id: string;
      city: string;
      district: string;
      state: string;
      ratingCount: number;
    },
    rating: Prisma.Decimal,
    kind: 'city' | 'district' | 'state' | 'india',
  ) {
    const area =
      kind === 'city'
        ? Prisma.sql`AND g.city ILIKE ${gym.city}`
        : kind === 'district'
          ? Prisma.sql`AND g.district ILIKE ${gym.district}`
          : kind === 'state'
            ? Prisma.sql`AND g.state ILIKE ${gym.state}`
            : Prisma.empty;

    // The eligibility half is the search endpoint's WHERE clause: active,
    // publicly listed, holding a live PRO subscription -- and KYC-verified
    // when that gate is on.
    const kycClause = kycRequiredForListing()
      ? Prisma.sql`AND EXISTS (
          SELECT 1 FROM gym_kyc k
          WHERE k."gymId" = g.id AND k."verifiedAt" IS NOT NULL
        )`
      : Prisma.empty;
    const eligible = Prisma.sql`
      FROM gyms g
      WHERE g."deletedAt" IS NULL
        AND g.status::text = 'ACTIVE'
        AND g."publicListing" = true
        ${kycClause}
        AND EXISTS (
          SELECT 1 FROM gym_subscriptions s
          WHERE s."gymId" = g.id
            AND s.status::text = 'ACTIVE'
            AND s.plan::text = 'PRO'
            AND s."endsAt" > NOW()
        )
        ${area}
    `;

    const [ahead, total] = await Promise.all([
      this.prisma.$queryRaw<{ count: number }[]>`
        SELECT COUNT(*)::int AS count
        ${eligible}
          AND g.id <> ${gym.id}::uuid
          AND (
            g."ratingAverage" > ${rating}
            OR (g."ratingAverage" = ${rating} AND g."ratingCount" > ${gym.ratingCount})
          )
      `,
      this.prisma.$queryRaw<{ count: number }[]>`
        SELECT COUNT(*)::int AS count
        ${eligible}
      `,
    ]);

    return {
      scope: kind,
      label: LABELS[kind](gym),
      position: (ahead[0]?.count ?? 0) + 1,
      outOf: total[0]?.count ?? 0,
    };
  }
}

const LABELS: Record<
  'city' | 'district' | 'state' | 'india',
  (gym: { city: string; district: string; state: string }) => string
> = {
  city: (gym) => gym.city,
  district: (gym) => gym.district,
  state: (gym) => gym.state,
  india: () => 'All India',
};
