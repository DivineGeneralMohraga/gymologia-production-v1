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
import { SupportedLocale } from '../common/utils/locale';
import { SetPanDto, SetPayoutMethodDto } from './dto/referrals.dto';
import { shareText } from './share-text';

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
  async mine(userId: string, locale: SupportedLocale = 'en') {
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
      // In the caller's language, resolved from Accept-Language the same
      // way the exercise directory does it. This string is unusual in that
      // its real audience is not the person reading the screen -- it gets
      // forwarded to a gym owner -- so shipping English to a Marathi
      // speaker makes them retype it before it is useful.
      shareText: shareText(account.code, locale),
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
   * The individual rewards behind the totals.
   *
   * `mine()` returns four running counters, and a counter is not something
   * a person can check. Somebody who handed their code to three gym owners
   * and sees ₹100 earned has no way, from a number, to find out which of
   * the three did not count -- and that is exactly the question a referrer
   * asks. This is the answer: one row per redemption, with the gym, the
   * reward, and where it has got to.
   *
   * What the gym paid is deliberately NOT here. The referrer's reward is a
   * flat ₹50 and is theirs; the discount is a fraction of what that gym
   * spent, which is the gym's business and none of theirs. Nor is anything
   * else about the gym -- no address, no owner, no contact. The name is
   * included because without it the screen is a list of anonymous amounts,
   * which cannot settle the question it exists to settle.
   *
   * A REVERSED row stays in the list rather than disappearing. A refunded
   * subscription takes the reward back, and a reward that silently vanishes
   * from a list is how a support ticket gets written.
   */
  async earnings(userId: string, limit = 50) {
    const account = await this.accountFor(userId);
    const take = Math.min(Math.max(Math.trunc(limit) || 50, 1), 100);

    // take + 1, so "is there another page" is answered by looking rather
    // than inferred from a full one. `rows.length === take` is true both
    // when more exist and when the count lands exactly on the limit, and
    // the second case would tell a referrer with exactly fifty rewards
    // that some of them are hidden. The extra row is dropped below.
    const rows = await this.prisma.referralRedemption.findMany({
      where: { referralAccountId: account.id },
      orderBy: { createdAt: 'desc' },
      take: take + 1,
      select: {
        id: true,
        gymId: true,
        rewardPaise: true,
        status: true,
        createdAt: true,
        eligibleAt: true,
      },
    });

    const hasMore = rows.length > take;
    const page = hasMore ? rows.slice(0, take) : rows;

    // One query for every gym on the page rather than one per row. The
    // list is capped at a hundred, so this is two queries at any length.
    const gymIds = [...new Set(page.map((r) => r.gymId))];
    const gyms = gymIds.length
      ? await this.prisma.gym.findMany({
          where: { id: { in: gymIds } },
          select: { id: true, name: true, district: true },
        })
      : [];
    const byId = new Map(gyms.map((g) => [g.id, g]));

    return {
      items: page.map((r) => {
        const gym = byId.get(r.gymId);
        return {
          id: r.id,
          // A deleted gym leaves the redemption standing -- the reward was
          // still earned -- so the name has to survive its absence.
          gymName: gym ? `${gym.name} - ${gym.district}` : 'A gym',
          rewardPaise: r.rewardPaise,
          status: r.status,
          createdAt: r.createdAt,
          eligibleAt: r.eligibleAt,
        };
      }),
      // Said here rather than inferred from a short page: the list is
      // capped, and a referrer with more than a hundred redemptions should
      // be told the screen is not showing all of them.
      returned: page.length,
      limit: take,
      hasMore,
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

    // The same rule as the UPI address, for the same reason. Re-sending an
    // unchanged, already-verified PAN must not quietly un-verify it --
    // otherwise opening the form and pressing save costs somebody their
    // verification. Anything else goes back to PENDING: a changed number
    // has plainly not been checked, and a REJECTED one that is sent again
    // is a request for another look, which is how gym KYC resubmission
    // already behaves.
    const changed = this.decryptOrNull(account.panEnc, 'PAN', account.id) !== pan;
    const keepVerified =
      !changed && account.panStatus === VerificationStatus.VERIFIED;

    const updated = await this.prisma.referralAccount.update({
      where: { id: account.id },
      data: {
        panEnc: this.crypto.encrypt(pan),
        panLast4: this.crypto.last4(pan),
        ...(keepVerified ? {} : { panStatus: VerificationStatus.PENDING }),
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
    return this.decryptOrNull(account.upiIdEnc, 'UPI ID', account.id);
  }

  /**
   * Decrypt a stored field for comparison, or null if it is absent or
   * unreadable.
   *
   * A value that will not decrypt cannot be compared, so it is treated as
   * absent. That errs towards clearing the verification, which is the safe
   * direction: the alternative is carrying a VERIFIED onto a value we
   * cannot even read.
   */
  private decryptOrNull(
    cipher: string | null,
    what: string,
    accountId: string,
  ): string | null {
    if (!cipher) return null;
    try {
      return this.crypto.decrypt(cipher);
    } catch {
      this.logger.warn(
        `Stored ${what} for referral account ${accountId} did not decrypt`,
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
      throw new ConflictException({
        message:
          'A payout is already on its way. These details can be changed once it settles.',
        // The second and last code in the product. It earns one because
        // this refusal lands on the form where somebody sets where their
        // money goes: they press save, nothing changes, and the only
        // explanation is a sentence they may not read. Every other message
        // from this service is shown as prose, which is the right default.
        code: 'PAYOUT_IN_FLIGHT',
      });
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
      throw new ForbiddenException({
        message:
          'Gym owners cannot hold a referral account. Gym staff and everyone else can.',
        // The same code the login path uses, because it is the same rule
        // and the app says the same thing about it. A second code would
        // mean a second translation of one sentence.
        code: 'REFERRAL_OWNER_EXCLUDED',
      });
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
