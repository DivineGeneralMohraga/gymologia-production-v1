import {
  BadRequestException,
  ConflictException,
  Injectable,
  Logger,
} from '@nestjs/common';
import { PayoutStatus, RedemptionStatus } from '@prisma/client';
import { randomUUID } from 'node:crypto';

import { PrismaService } from '../prisma/prisma.service';
import { AuditService } from '../common/audit/audit.service';
import { istFinancialYear } from '../common/utils/day';

interface RequestMeta {
  ip?: string | null;
  userAgent?: string | null;
}

/**
 * Taking the money out.
 *
 * The referrer asks; nothing pays out on a schedule. That is the owner's
 * design and it is also the safer one -- an automatic transfer to an
 * address nobody has confirmed is the failure this whole feature has been
 * arranged to avoid, and asking is the moment a person looks at the
 * address one more time.
 *
 * ## What is deducted
 *
 * Ten rupees, once, to cover checking that the UPI address is really
 * theirs. Nothing else. **No TDS**: at ₹50 a referral somebody needs four
 * hundred referrals inside one financial year to reach the ₹20,000 where
 * withholding would begin, so the columns exist, default to zero, and are
 * written as zero. The financial year is still recorded on every payout,
 * because the day that stops being true the records have to already be
 * there rather than start there.
 *
 * ## Why the fee follows the verification rather than the calendar
 *
 * "First time" is the obvious reading, and it is wrong in one case that
 * matters: somebody withdraws, later changes their UPI ID, and withdraws
 * again. That new address has never been checked. Tying the fee to
 * `upiVerified` -- which is cleared whenever the address or the claimed
 * name changes -- means the fee is charged exactly when a check actually
 * has to be paid for, and never when one does not. A person who never
 * changes their address pays it once, which is what was asked for.
 */
@Injectable()
export class WithdrawalsService {
  private readonly logger = new Logger(WithdrawalsService.name);

  /** What checking an address costs, passed on once. */
  static readonly VERIFY_FEE_PAISE = 1000;

  constructor(
    private readonly prisma: PrismaService,
    private readonly audit: AuditService,
  ) {}

  /**
   * What could be taken out right now, and what would arrive.
   *
   * Read-only, and deliberately its own endpoint: the app shows these
   * numbers on a screen before there is any button to press, and a person
   * about to move money should be able to see the arithmetic rather than
   * discover the deduction afterwards.
   */
  async quote(accountId: string, upiVerified: boolean, hasAddress: boolean) {
    const rows = await this.prisma.referralRedemption.findMany({
      where: {
        referralAccountId: accountId,
        status: RedemptionStatus.ELIGIBLE,
        payoutId: null,
      },
      select: { id: true, rewardPaise: true },
    });

    const grossPaise = rows.reduce((sum, r) => sum + r.rewardPaise, 0);
    // Charged only when a check has to be run. See the note on the class.
    const verifyFeePaise = upiVerified ? 0 : WithdrawalsService.VERIFY_FEE_PAISE;
    const netPaise = Math.max(0, grossPaise - verifyFeePaise);

    const blockedBy: string[] = [];

    // In flight comes FIRST, and the order is the whole point. Straight
    // after a successful withdrawal both conditions are true -- nothing is
    // withdrawable AND a payout is moving -- and the reason a person needs
    // is the second one. Listing the balance first told somebody who had
    // just withdrawn fifty rupees that they had never earned anything.
    if (await this.inFlight(accountId)) {
      blockedBy.push('A withdrawal is already on its way');
    }

    if (!hasAddress) {
      blockedBy.push('Add the UPI ID your rewards should be sent to');
    }

    if (grossPaise === 0) {
      // "Nothing has cleared" and "you have earned nothing" are different
      // things to be told, and only one of them is discouraging for the
      // wrong reason.
      const held = await this.prisma.referralRedemption.count({
        where: {
          referralAccountId: accountId,
          status: RedemptionStatus.PENDING,
        },
      });
      blockedBy.push(
        held > 0
          ? 'Your rewards are still clearing'
          : 'Nothing to withdraw yet',
      );
    } else if (grossPaise <= verifyFeePaise) {
      // Refused rather than sent as zero. A transfer that costs its whole
      // value to make is not a payout, and taking the fee out of it would
      // leave somebody with a receipt for nothing.
      blockedBy.push(
        'Your cleared rewards do not yet cover the one-time verification',
      );
    }

    return {
      grossPaise,
      verifyFeePaise,
      tdsPaise: 0,
      netPaise,
      rewardCount: rows.length,
      canWithdraw: blockedBy.length === 0,
      blockedBy,
    };
  }

  /**
   * Ask for the cleared rewards to be sent.
   *
   * Two withdraw requests arriving together would each read the same
   * cleared rewards and each raise a payout for them, paying the same fifty
   * rupees twice. What prevents that is the last statement in the
   * transaction: the rewards are attached to this payout by id **and only
   * while `payoutId` is still null**, and the number of rows that actually
   * moved is compared against the number expected. A concurrent request
   * that got there first leaves the count short, and the whole transaction
   * -- payout row included -- rolls back.
   *
   * An earlier version relied on an UPDATE that set a column to the value
   * it already held, purely for the row lock. That does work, and it is far
   * too subtle to leave in the path that moves money.
   */
  async withdraw(
    userId: string,
    account: { id: string; upiIdMasked: string | null; upiVerified: boolean },
    meta: RequestMeta,
  ) {
    const hasAddress = Boolean(account.upiIdMasked);
    const q = await this.quote(account.id, account.upiVerified, hasAddress);

    if (!q.canWithdraw) {
      // The first blocker, in the server's own words. The app shows this
      // verbatim rather than deciding for itself which one matters.
      const [first] = q.blockedBy;
      if (first === 'A withdrawal is already on its way') {
        throw new ConflictException({
          message:
            'A withdrawal is already on its way. You can ask for another once it settles.',
          code: 'PAYOUT_IN_FLIGHT',
        });
      }
      throw new BadRequestException(first ?? 'Nothing to withdraw');
    }

    const payout = await this.prisma.$transaction(async (tx) => {
      // Read inside the transaction, not from the quote above: the quote
      // was a separate round trip and something may have cleared or been
      // reversed since.
      const rewards = await tx.referralRedemption.findMany({
        where: {
          referralAccountId: account.id,
          status: RedemptionStatus.ELIGIBLE,
          payoutId: null,
        },
        select: { id: true, rewardPaise: true },
      });
      if (rewards.length === 0) {
        throw new ConflictException('Those rewards are no longer available');
      }

      const grossPaise = rewards.reduce((sum, r) => sum + r.rewardPaise, 0);
      const verifyFeePaise = account.upiVerified
        ? 0
        : WithdrawalsService.VERIFY_FEE_PAISE;
      if (grossPaise <= verifyFeePaise) {
        throw new ConflictException('Those rewards are no longer available');
      }

      const created = await tx.payout.create({
        data: {
          referralAccountId: account.id,
          grossPaise,
          tdsPaise: 0,
          tdsRateBps: 0,
          verifyFeePaise,
          netPaise: grossPaise - verifyFeePaise,
          status: PayoutStatus.QUEUED,
          // Per payout, not per attempt: this is what Cashfree is given so
          // a retry of the same transfer can never send twice.
          idempotencyKey: `payout-${account.id}-${randomUUID()}`,
          financialYear: istFinancialYear(new Date()),
        },
      });

      // The guard. `payoutId: null` means a reward another request already
      // claimed cannot be claimed again, and the count says whether that
      // happened. Anything short of the full set rolls the payout back with
      // it rather than sending a total that no longer matches its rewards.
      const attached = await tx.referralRedemption.updateMany({
        where: { id: { in: rewards.map((r) => r.id) }, payoutId: null },
        data: { payoutId: created.id },
      });
      if (attached.count !== rewards.length) {
        throw new ConflictException(
          'Those rewards were claimed by another withdrawal. Try again.',
        );
      }

      return created;
    });

    await this.audit.record({
      actorId: userId,
      action: 'referral.withdrawal.request',
      entityType: 'Payout',
      entityId: payout.id,
      before: null,
      // The masked handle only. This row is read by every admin with the
      // log viewer, and a payment address should not need the redactor to
      // be the last line of defence.
      after: {
        grossPaise: payout.grossPaise,
        verifyFeePaise: payout.verifyFeePaise,
        netPaise: payout.netPaise,
        upiIdMasked: account.upiIdMasked,
      },
      ip: meta.ip,
      userAgent: meta.userAgent,
    });

    this.logger.log(
      `Withdrawal queued: ${payout.id} net ${payout.netPaise} paise`,
    );

    return this.view(payout);
  }

  /** What has been asked for and what happened to it. */
  async history(accountId: string, limit = 20) {
    const take = Math.min(Math.max(Math.trunc(limit) || 20, 1), 100);
    const rows = await this.prisma.payout.findMany({
      where: { referralAccountId: accountId },
      orderBy: { createdAt: 'desc' },
      take,
    });
    return { items: rows.map((p) => this.view(p)) };
  }

  private async inFlight(accountId: string): Promise<boolean> {
    const row = await this.prisma.payout.findFirst({
      where: {
        referralAccountId: accountId,
        status: { in: [PayoutStatus.QUEUED, PayoutStatus.PROCESSING] },
      },
      select: { id: true },
    });
    return Boolean(row);
  }

  /**
   * What a referrer is told about one payout.
   *
   * The Cashfree transfer id is deliberately not here. It is ours, it means
   * nothing to the person, and the UTR -- which is the reference their bank
   * will recognise if they have to chase it -- is.
   */
  private view(p: {
    id: string;
    grossPaise: number;
    verifyFeePaise: number;
    tdsPaise: number;
    netPaise: number;
    status: PayoutStatus;
    cashfreeUtr: string | null;
    failureReason: string | null;
    createdAt: Date;
    processedAt: Date | null;
  }) {
    return {
      id: p.id,
      grossPaise: p.grossPaise,
      verifyFeePaise: p.verifyFeePaise,
      tdsPaise: p.tdsPaise,
      netPaise: p.netPaise,
      status: p.status,
      utr: p.cashfreeUtr,
      failureReason: p.failureReason,
      requestedAt: p.createdAt,
      settledAt: p.processedAt,
    };
  }
}
