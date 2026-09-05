import { ForbiddenException, Injectable, Logger } from '@nestjs/common';
import { Prisma, ReferralAccountStatus, RedemptionStatus } from '@prisma/client';

import { PrismaService } from '../prisma/prisma.service';
import { CryptoService } from '../common/crypto/crypto.service';

/**
 * A referrer's own account: their code, and what it has earned.
 *
 * This is the half of the referral flow that was missing. Redeeming a code
 * worked and was tested; the 10% discount and the ₹50 reward both applied
 * correctly. But <b>nothing in the product ever created a code</b> --
 * `CryptoService.generateReferralCode` was called from nowhere, and the only
 * place a ReferralAccount came into existence was the payments test suite,
 * which inserted one straight into the database with Prisma so it would have
 * something to redeem. A discount nobody can obtain a code for is not a
 * working feature, whatever the redemption path does.
 */
@Injectable()
export class ReferralsService {
  private readonly logger = new Logger(ReferralsService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly crypto: CryptoService,
  ) {}

  /**
   * The caller's referral account, created on first ask.
   *
   * Created lazily rather than at registration on purpose: most members
   * never refer anybody, and a row per account for a feature most of them
   * will not use is a cost with no reader. Asking for the code is the
   * moment somebody has decided to use it.
   */
  async mine(userId: string) {
    await this.assertNotAGymOwner(userId);

    const existing = await this.prisma.referralAccount.findUnique({
      where: { userId },
    });
    const account = existing ?? (await this.create(userId));

    // Counted from the redemptions rather than read off the running totals
    // on the account, so the two can be compared if they ever disagree.
    const [redeemed, pending] = await Promise.all([
      this.prisma.referralRedemption.count({
        where: { referralAccountId: account.id },
      }),
      this.prisma.referralRedemption.count({
        where: {
          referralAccountId: account.id,
          status: RedemptionStatus.PENDING,
        },
      }),
    ]);

    return {
      code: account.code,
      status: account.status,
      shareText:
        `Use my Gymologia code ${account.code} when you subscribe your gym ` +
        `and get 10% off.`,
      timesRedeemed: redeemed,
      awaitingClearance: pending,
      earnings: {
        totalEarnedPaise: account.totalEarnedPaise,
        pendingPaise: account.pendingPaise,
        totalPaidPaise: account.totalPaidPaise,
        totalTdsPaise: account.totalTdsPaise,
      },
      payout: {
        // Said plainly rather than left for the reader to infer from an
        // empty list: money is being earned and none of it can be sent yet.
        upiVerified: account.upiVerified,
        upiIdMasked: account.upiIdMasked,
        panStatus: account.panStatus,
        canBePaidOut: false,
        why: 'Payouts are not connected yet. Rewards accrue and are held.',
      },
    };
  }

  /**
   * The same rule the referral app's login enforces, applied again here.
   *
   * A person can register a gym after signing in, so checking only at login
   * would leave an owner holding a referral account they were never
   * supposed to have. The spec is explicit that owners are excluded and
   * their staff are not.
   */
  private async assertNotAGymOwner(userId: string): Promise<void> {
    const ownedGym = await this.prisma.gym.findFirst({
      where: { ownerId: userId, deletedAt: null },
      select: { id: true },
    });
    if (ownedGym) {
      throw new ForbiddenException(
        'Gym owners cannot hold a referral account. Gym staff and everyone else can.',
      );
    }
  }

  /**
   * Mint a code, retrying on the astronomically unlikely collision.
   *
   * The column is unique, so a clash is a P2002 rather than a duplicate
   * row -- but it would surface to the user as a failure to get their own
   * code, which is a poor way to meet a feature. Three attempts, then the
   * error is allowed through rather than looping.
   */
  private async create(userId: string) {
    for (let attempt = 1; attempt <= 3; attempt += 1) {
      const code = this.crypto.generateReferralCode();
      try {
        return await this.prisma.referralAccount.create({
          data: { userId, code, status: ReferralAccountStatus.ACTIVE },
        });
      } catch (error) {
        const clash =
          error instanceof Prisma.PrismaClientKnownRequestError &&
          error.code === 'P2002';

        // Two requests from the same person at once: the other one won and
        // the account now exists, which is the outcome either way.
        if (clash) {
          const raced = await this.prisma.referralAccount.findUnique({
            where: { userId },
          });
          if (raced) return raced;

          this.logger.warn(
            `Referral code collision on attempt ${attempt}; generating another`,
          );
          continue;
        }
        throw error;
      }
    }

    throw new Error('Could not generate an unused referral code');
  }
}
