import { Injectable, Logger } from '@nestjs/common';
import { PayoutStatus, RedemptionStatus } from '@prisma/client';

import { PrismaService } from '../prisma/prisma.service';
import { CryptoService } from '../common/crypto/crypto.service';
import { AuditService } from '../common/audit/audit.service';
import { CashfreePayoutsService } from '../payments/cashfree-payouts.service';

export interface RunResult {
  payoutId: string;
  outcome: 'SENT' | 'PENDING' | 'FAILED' | 'REFUSED';
  detail: string;
}

/**
 * Turning a queued withdrawal into money that has actually moved.
 *
 * ## The refusal that matters most
 *
 * **An address nobody has checked is never paid.** The ₹10 taken from the
 * first withdrawal buys a check against the bank's record of who owns that
 * UPI ID, and that check needs `CASHFREE_VERIFY_CLIENT_ID`, which is empty.
 * Sending anyway would mean charging somebody for a check that never
 * happened and then transferring to an unverified address -- the exact
 * failure the whole referral payout design is arranged around, since
 * `sarthaq@okhdfcbank` is a perfectly valid address belonging to a
 * stranger and the transfer does not come back.
 *
 * So this refuses, loudly, and leaves the payout QUEUED. A referrer's money
 * waits; it is not lost and it is not misdirected.
 *
 * ## Order of operations
 *
 * The status moves to PROCESSING **before** the network call and back only
 * on a definite answer. A crash between the two leaves PROCESSING, which
 * `assertNoPayoutInFlight` already treats as in-flight, so nothing else can
 * raise a second payout for the same rewards. Recovering one of those is a
 * status read against the transfer id, never a re-send.
 *
 * ## When it fails
 *
 * The rewards go back to ELIGIBLE and the fee is returned with them. A
 * failed transfer must not cost somebody ₹10 and their rewards; they end up
 * exactly where they started, free to try again.
 */
@Injectable()
export class PayoutRunnerService {
  private readonly logger = new Logger(PayoutRunnerService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly crypto: CryptoService,
    private readonly audit: AuditService,
    private readonly payouts: CashfreePayoutsService,
  ) {}

  /** Whether anything could be sent at all right now, and why not. */
  blockedReason(verifyConfigured: boolean): string | null {
    if (!this.payouts.isConfigured) {
      return 'Cashfree Payouts credentials are not set';
    }
    if (!verifyConfigured) {
      return 'Cashfree Verification credentials are not set, so no address can be checked';
    }
    return null;
  }

  /**
   * Attempt one queued payout.
   *
   * Returns rather than throws for every ordinary outcome, because the
   * caller is a loop over several and one refusal must not stop the rest.
   */
  async run(payoutId: string, verifyConfigured: boolean): Promise<RunResult> {
    const payout = await this.prisma.payout.findUnique({
      where: { id: payoutId },
      include: { referralAccount: { include: { user: true } } },
    });

    if (!payout) return { payoutId, outcome: 'FAILED', detail: 'No such payout' };
    if (payout.status !== PayoutStatus.QUEUED) {
      return {
        payoutId,
        outcome: 'REFUSED',
        detail: `Not queued (${payout.status})`,
      };
    }

    const blocked = this.blockedReason(verifyConfigured);
    if (blocked) {
      // Deliberately left QUEUED. The money is owed and still owed.
      this.logger.warn(`Payout ${payoutId} held: ${blocked}`);
      return { payoutId, outcome: 'REFUSED', detail: blocked };
    }

    const account = payout.referralAccount;
    if (!account.upiVerified) {
      return {
        payoutId,
        outcome: 'REFUSED',
        detail: 'The UPI address has not been verified',
      };
    }

    const vpa = this.decryptVpa(account.upiIdEnc, account.id);
    if (!vpa || !account.upiHolderName) {
      return {
        payoutId,
        outcome: 'REFUSED',
        detail: 'No usable UPI address on record',
      };
    }

    // In flight from here on, before anything leaves the building.
    await this.prisma.payout.update({
      where: { id: payout.id },
      data: { status: PayoutStatus.PROCESSING },
    });

    try {
      await this.payouts.ensureBeneficiary({
        // Derived from the account, so one person is one beneficiary
        // however many times they withdraw.
        beneficiaryId: `ref_${account.id.replace(/-/g, '')}`.slice(0, 50),
        name: account.upiHolderName,
        vpa,
        phone: account.user.phone,
        email: account.user.email,
      });

      const result = await this.payouts.transfer({
        transferId: payout.idempotencyKey,
        beneficiaryId: `ref_${account.id.replace(/-/g, '')}`.slice(0, 50),
        amountPaise: payout.netPaise,
        remarks: 'Gymologia referral reward',
      });

      if (result.state === 'SUCCESS') {
        await this.settle(payout.id, account.id, payout.netPaise, result.utr);
        return { payoutId, outcome: 'SENT', detail: result.utr ?? 'sent' };
      }

      if (result.state === 'PENDING') {
        // Left PROCESSING on purpose: it is with Cashfree, and the next
        // status read decides. Nothing here re-sends.
        return { payoutId, outcome: 'PENDING', detail: 'With Cashfree' };
      }

      await this.giveBack(payout.id, result.reason);
      return { payoutId, outcome: 'FAILED', detail: result.reason };
    } catch (error) {
      // A network failure is NOT proof the transfer did not happen. Left
      // PROCESSING so a human or a status read resolves it; re-sending on a
      // timeout is how somebody gets paid twice.
      const detail = error instanceof Error ? error.message : String(error);
      this.logger.error(
        `Payout ${payoutId} left PROCESSING after an error: ${detail}`,
      );
      return { payoutId, outcome: 'PENDING', detail };
    }
  }

  /** Money arrived: mark everything, once, in one transaction. */
  private async settle(
    payoutId: string,
    accountId: string,
    netPaise: number,
    utr: string | null,
  ) {
    await this.prisma.$transaction([
      this.prisma.payout.update({
        where: { id: payoutId },
        data: {
          status: PayoutStatus.SUCCESS,
          cashfreeUtr: utr,
          processedAt: new Date(),
        },
      }),
      this.prisma.referralRedemption.updateMany({
        where: { payoutId },
        data: { status: RedemptionStatus.PAID },
      }),
      this.prisma.referralAccount.update({
        where: { id: accountId },
        data: {
          totalPaidPaise: { increment: netPaise },
          pendingPaise: { decrement: netPaise },
        },
      }),
    ]);

    await this.audit.record({
      actorId: null,
      action: 'referral.payout.sent',
      entityType: 'Payout',
      entityId: payoutId,
      before: null,
      after: { netPaise, utr },
      ip: null,
      userAgent: null,
    });
  }

  /**
   * It did not go: put the referrer back exactly where they started.
   *
   * The rewards return to ELIGIBLE and the fee goes with them, because a
   * failed transfer must not cost somebody ten rupees for a check whose
   * result they never got the benefit of.
   */
  private async giveBack(payoutId: string, reason: string) {
    await this.prisma.$transaction([
      this.prisma.referralRedemption.updateMany({
        where: { payoutId },
        data: { status: RedemptionStatus.ELIGIBLE, payoutId: null },
      }),
      this.prisma.payout.update({
        where: { id: payoutId },
        data: {
          status: PayoutStatus.FAILED,
          failureReason: reason.slice(0, 500),
          processedAt: new Date(),
        },
      }),
    ]);

    this.logger.warn(`Payout ${payoutId} failed, rewards returned: ${reason}`);
  }

  private decryptVpa(cipher: string | null, accountId: string): string | null {
    if (!cipher) return null;
    try {
      return this.crypto.decrypt(cipher);
    } catch {
      this.logger.error(
        `Stored UPI address for referral account ${accountId} did not decrypt`,
      );
      return null;
    }
  }
}
