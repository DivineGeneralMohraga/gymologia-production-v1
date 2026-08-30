import { Injectable, Logger } from '@nestjs/common';
import { Cron, CronExpression } from '@nestjs/schedule';
import {
  GymStatus,
  MembershipStatus,
  RedemptionStatus,
  SubscriptionStatus,
} from '@prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { OtpService } from '../auth/otp.service';

/**
 * The jobs that make time pass.
 *
 * Without these, every "ends at" date in the system is decorative: a
 * subscription past its end date still reads ACTIVE, a lapsed member still
 * reads ACTIVE with a negative day count, and OTP challenges accumulate
 * forever. Reads mostly compensate — search checks `endsAt > now` rather
 * than trusting status — but a row that lies about its own state is a bug
 * waiting for the next person who trusts it.
 *
 * Every method here is public and idempotent so it can be run by hand, or
 * by a test, rather than only on the schedule.
 */
@Injectable()
export class MaintenanceService {
  private readonly logger = new Logger(MaintenanceService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly otp: OtpService,
  ) {}

  @Cron(CronExpression.EVERY_HOUR)
  async hourly(): Promise<void> {
    const subs = await this.expireSubscriptions();
    const members = await this.expireMemberships();
    if (subs || members) {
      this.logger.log(
        `Expired ${subs} subscription(s) and ${members} membership(s)`,
      );
    }
  }

  @Cron(CronExpression.EVERY_DAY_AT_3AM)
  async daily(): Promise<void> {
    const purged = await this.otp.purgeExpired();
    const eligible = await this.releaseReferralRewards();
    this.logger.log(
      `Purged ${purged} OTP challenge(s), released ${eligible} referral reward(s)`,
    );
  }

  /**
   * Close out subscriptions whose term has ended, and drop the gym out of
   * ACTIVE when nothing is left covering it.
   *
   * The CRM deliberately keeps working for a suspended gym. Locking an
   * owner out of their own member list the moment a card expires would
   * hold their data hostage over a billing lapse; not being listed in
   * search is the consequence, and that is enough.
   */
  async expireSubscriptions(): Promise<number> {
    const now = new Date();

    const lapsed = await this.prisma.gymSubscription.findMany({
      where: { status: SubscriptionStatus.ACTIVE, endsAt: { lte: now } },
      select: { id: true, gymId: true },
    });
    if (lapsed.length === 0) return 0;

    await this.prisma.gymSubscription.updateMany({
      where: { id: { in: lapsed.map((s) => s.id) } },
      data: { status: SubscriptionStatus.EXPIRED },
    });

    // A gym only drops to SUSPENDED when nothing else still covers it —
    // an owner who renewed early has a second subscription waiting.
    const gymIds = [...new Set(lapsed.map((s) => s.gymId))];
    for (const gymId of gymIds) {
      const stillCovered = await this.prisma.gymSubscription.findFirst({
        where: {
          gymId,
          status: SubscriptionStatus.ACTIVE,
          endsAt: { gt: now },
        },
        select: { id: true },
      });

      if (!stillCovered) {
        await this.prisma.gym.updateMany({
          where: { id: gymId, status: GymStatus.ACTIVE },
          data: { status: GymStatus.SUSPENDED },
        });
      }
    }

    return lapsed.length;
  }

  /**
   * Members whose term has run out.
   *
   * Marked EXPIRED rather than REMOVED: the spec asks for them to drop off
   * automatically, but their attendance history and the gym's own record
   * of them should survive, and a renewal should be able to bring them
   * back without re-enrolling.
   *
   * Members on leave are skipped — their clock is paused on purpose, and
   * expiring them would punish someone for taking leave they were granted.
   */
  async expireMemberships(): Promise<number> {
    const { count } = await this.prisma.membership.updateMany({
      where: {
        status: MembershipStatus.ACTIVE,
        endsAt: { lte: new Date() },
      },
      data: { status: MembershipStatus.EXPIRED },
    });
    return count;
  }

  /**
   * Referral rewards past their hold become payable.
   *
   * The hold exists so a refund or chargeback cannot leave a paid-out
   * reward behind. A reward whose subscription did not survive is reversed
   * instead of released.
   */
  async releaseReferralRewards(): Promise<number> {
    const now = new Date();

    const due = await this.prisma.referralRedemption.findMany({
      where: {
        status: RedemptionStatus.PENDING,
        eligibleAt: { lte: now },
      },
      include: {
        subscription: { select: { status: true } },
      },
    });
    if (due.length === 0) return 0;

    const good = due.filter(
      (r) =>
        r.subscription.status === SubscriptionStatus.ACTIVE ||
        r.subscription.status === SubscriptionStatus.EXPIRED,
    );
    const bad = due.filter((r) => !good.includes(r));

    if (good.length > 0) {
      await this.prisma.referralRedemption.updateMany({
        where: { id: { in: good.map((r) => r.id) } },
        data: { status: RedemptionStatus.ELIGIBLE },
      });
    }

    // A cancelled or failed subscription takes its reward back with it.
    for (const reversed of bad) {
      await this.prisma.$transaction([
        this.prisma.referralRedemption.update({
          where: { id: reversed.id },
          data: { status: RedemptionStatus.REVERSED },
        }),
        this.prisma.referralAccount.update({
          where: { id: reversed.referralAccountId },
          data: {
            pendingPaise: { decrement: reversed.rewardPaise },
            totalEarnedPaise: { decrement: reversed.rewardPaise },
          },
        }),
      ]);
    }

    if (bad.length > 0) {
      this.logger.warn(
        `Reversed ${bad.length} referral reward(s) whose subscription did not stand`,
      );
    }

    return good.length;
  }

  /** Everything at once. Used by the maintenance script and by tests. */
  async runAll(): Promise<{
    subscriptions: number;
    memberships: number;
    otpPurged: number;
    rewardsReleased: number;
  }> {
    return {
      subscriptions: await this.expireSubscriptions(),
      memberships: await this.expireMemberships(),
      otpPurged: await this.otp.purgeExpired(),
      rewardsReleased: await this.releaseReferralRewards(),
    };
  }
}
