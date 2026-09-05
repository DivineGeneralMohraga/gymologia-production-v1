import {
  ConflictException,
  ForbiddenException,
  Injectable,
  Logger,
} from '@nestjs/common';
import {
  Prisma,
  PayoutStatus,
  ReferralAccount,
  ReferralAccountStatus,
  RedemptionStatus,
  VerificationStatus,
} from '@prisma/client';

import { PrismaService } from '../prisma/prisma.service';
import { CryptoService } from '../common/crypto/crypto.service';
import { AuditService } from '../common/audit/audit.service';
import { normaliseVpa } from '../common/validation/upi-vpa';
import { SetPanDto, SetPayoutMethodDto } from './dto/referrals.dto';

interface RequestMeta {
  ip?: string | null;
  userAgent?: string | null;
}

/**
 * A referrer's own account: their code, where the money should go, and what
 * it has earned.
 *
 * This is the half of the referral flow that was missing. Redeeming a code
 * worked and was tested; the 10% discount and the reward both applied
 * correctly. But nothing in the product ever created a code --
 * `CryptoService.generateReferralCode` was called from nowhere, and the only
 * place a ReferralAccount came into existence was the payments test suite,
 * which inserted one straight into the database with Prisma so it would have
 * something to redeem. A discount nobody can obtain a code for is not a
 * working feature, whatever the redemption path does.
 *
 * The payout columns were the same story one layer down: `upiIdEnc`,
 * `upiHolderName`, `panEnc` and `panLast4` were modelled, encrypted-at-rest
 * by design, and written by nothing at all. `CryptoService.maskUpi` existed
 * for them and had no caller anywhere in the codebase. They are collected
 * here now.
 */
@Injectable()
export class ReferralsService {
  private readonly logger = new Logger(ReferralsService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly crypto: CryptoService,
    private readonly audit: AuditService,
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
    const account = await this.accountFor(userId);

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
      // ENGLISH ONLY, and that is a gap rather than a decision. Every other
      // user-facing string in this product is translated into ten
      // languages; this one is built on the server and ships as English to
      // all of them. The exercises endpoint already shows the shape of the
      // fix -- honour Accept-Language and return the caller's language --
      // and it should be applied here when the referral app is built,
      // because the whole point of this string is that it gets forwarded
      // to somebody else.
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
      payout: this.payoutView(account),
    };
  }

  /**
   * Record where this referrer's money should be sent.
   *
   * The subtle part is the verification flag. `upiVerified` means "the
   * verification drop came back with a name that matched the claimed one",
   * and that is a statement about one specific address and one specific
   * name. If either changes, the old result no longer supports the new
   * claim, so it is cleared -- otherwise somebody verifies an address they
   * control, swaps in another, and inherits a VERIFIED flag onto an account
   * nobody ever checked.
   *
   * "Changed" is decided by decrypting what is stored and comparing the
   * plaintext. Comparing the masked handles instead would look correct and
   * be wrong: `sarthak@ybl` and `sarthaq@ybl` both mask to `sa*****@ybl`,
   * so a typo into somebody else's account would read as no change at all
   * and keep the verification.
   */
  async setPayoutMethod(
    userId: string,
    dto: SetPayoutMethodDto,
    meta: RequestMeta,
  ) {
    const account = await this.accountFor(userId);
    await this.assertNoPayoutInFlight(account.id);

    const upiId = normaliseVpa(dto.upiId);
    const holderName = dto.holderName;

    const changed =
      this.storedVpa(account) !== upiId ||
      (account.upiHolderName ?? null) !== holderName;

    const updated = await this.prisma.referralAccount.update({
      where: { id: account.id },
      data: {
        upiIdEnc: this.crypto.encrypt(upiId),
        upiIdMasked: this.crypto.maskUpi(upiId),
        upiHolderName: holderName,
        ...(changed ? { upiVerified: false, upiVerifiedAt: null } : {}),
      },
    });

    await this.audit.record({
      actorId: userId,
      action: account.upiIdEnc
        ? 'referral.payout_method.update'
        : 'referral.payout_method.set',
      entityType: 'ReferralAccount',
      entityId: account.id,
      // The masked handle only, never the address itself. The redactor
      // would catch a raw one, but the audit log is opened by every admin
      // with the log viewer and a payment address should not need the
      // redactor to be the last line.
      before: account.upiIdEnc
        ? { upiIdMasked: account.upiIdMasked, upiVerified: account.upiVerified }
        : null,
      after: {
        upiIdMasked: updated.upiIdMasked,
        upiVerified: updated.upiVerified,
        changed,
      },
      ip: meta.ip,
      userAgent: meta.userAgent,
    });

    return this.payoutView(updated);
  }

  /**
   * Record the PAN that tax will be withheld against.
   *
   * Nothing verifies it yet -- Cashfree's Verification Suite is not wired,
   * so the status goes to PENDING and stays there rather than to VERIFIED,
   * because "we have it" and "we checked it" are different claims and only
   * the first one is true.
   */
  async setPan(userId: string, dto: SetPanDto, meta: RequestMeta) {
    const account = await this.accountFor(userId);
    await this.assertNoPayoutInFlight(account.id);

    const pan = dto.pan;

    const updated = await this.prisma.referralAccount.update({
      where: { id: account.id },
      data: {
        panEnc: this.crypto.encrypt(pan),
        panLast4: this.crypto.last4(pan),
        panStatus: VerificationStatus.PENDING,
      },
    });

    await this.audit.record({
      actorId: userId,
      action: 'referral.pan.set',
      entityType: 'ReferralAccount',
      entityId: account.id,
      before: { panStatus: account.panStatus, panLast4: account.panLast4 },
      after: { panStatus: updated.panStatus, panLast4: updated.panLast4 },
      ip: meta.ip,
      userAgent: meta.userAgent,
    });

    return this.payoutView(updated);
  }

  // -- internals -------------------------------------------------------

  /**
   * What the caller is told about payouts. Never the address itself: only
   * the masked handle and the name they claimed, both of which they typed.
   */
  private payoutView(account: ReferralAccount) {
    const youStillNeedTo: string[] = [];
    if (!account.upiIdMasked) {
      youStillNeedTo.push('Add the UPI ID your rewards should be sent to');
    }
    // REJECTED as well as NOT_SUBMITTED. A rejected PAN is the case where
    // the person most needs telling: they believe they have supplied it,
    // and listing only the never-submitted case would leave them waiting
    // for a payout that is blocked on something nobody mentioned.
    if (
      account.panStatus === VerificationStatus.NOT_SUBMITTED ||
      account.panStatus === VerificationStatus.REJECTED
    ) {
      youStillNeedTo.push(
        account.panStatus === VerificationStatus.REJECTED
          ? 'Your PAN was not accepted. Check the number and send it again'
          : 'Add your PAN before your earnings reach the tax threshold',
      );
    }

    return {
      upiIdMasked: account.upiIdMasked,
      upiHolderName: account.upiHolderName,
      upiVerified: account.upiVerified,
      panLast4: account.panLast4,
      panStatus: account.panStatus,
      // Said plainly rather than left for the reader to infer from an empty
      // list: money is being earned and none of it can be sent yet. This
      // stays false even once the details are complete, because the thing
      // that is missing is on our side, not theirs.
      canBePaidOut: false,
      why: 'Payouts are not connected yet. Rewards accrue and are held.',
      youStillNeedTo,
    };
  }

  /** The stored address in clear, or null if there is none or it will not decrypt. */
  private storedVpa(account: ReferralAccount): string | null {
    if (!account.upiIdEnc) return null;
    try {
      return this.crypto.decrypt(account.upiIdEnc);
    } catch {
      // A value that will not decrypt cannot be compared, so treat it as
      // absent. That errs towards clearing the verification flag, which is
      // the safe direction: the alternative is carrying a VERIFIED onto an
      // address we cannot even read.
      this.logger.warn(
        `Stored UPI ID for referral account ${account.id} did not decrypt`,
      );
      return null;
    }
  }

  /**
   * Refuse to move the goalposts while money is on its way.
   *
   * A payout that is QUEUED or PROCESSING was built against the address and
   * the PAN on record at the time. Letting either change underneath it
   * means a transfer lands somewhere the user no longer expects, or tax is
   * withheld against a number that is no longer the one on file.
   *
   * This check and the update that follows are not in one transaction, so
   * a payout queued in the gap between them would be built on the old
   * address and land after the new one was accepted. That window cannot be
   * hit today -- nothing queues a payout, there is no runner -- but when
   * one is built this has to become a transaction that locks the account
   * row, and the note belongs here rather than in somebody's memory.
   */
  private async assertNoPayoutInFlight(referralAccountId: string) {
    const inFlight = await this.prisma.payout.findFirst({
      where: {
        referralAccountId,
        status: { in: [PayoutStatus.QUEUED, PayoutStatus.PROCESSING] },
      },
      select: { id: true },
    });
    if (inFlight) {
      throw new ConflictException(
        'A payout is already on its way. These details can be changed once it settles.',
      );
    }
  }

  /** Find or lazily create the caller's account, refusing gym owners. */
  private async accountFor(userId: string): Promise<ReferralAccount> {
    await this.assertNotAGymOwner(userId);

    const existing = await this.prisma.referralAccount.findUnique({
      where: { userId },
    });
    return existing ?? (await this.create(userId));
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
  private async create(userId: string): Promise<ReferralAccount> {
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
