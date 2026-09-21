import {
  ConflictException,
  Injectable,
  Logger,
  NotFoundException,
} from '@nestjs/common';
import {
  GymStatus,
  MembershipStatus,
  ReferralAccountStatus,
  StaffStatus,
} from '@prisma/client';

import { PrismaService } from '../prisma/prisma.service';
import { CryptoService } from '../common/crypto/crypto.service';
import { AuditService } from '../common/audit/audit.service';

interface RequestMeta {
  ip?: string | null;
  userAgent?: string | null;
}

/**
 * Deleting your account.
 *
 * Required by Google Play of any app offering account creation: available in
 * the app, and startable from the web without installing it. We sign people
 * up with a phone number, so it applies to all three apps and there is no
 * version of shipping without it.
 *
 * ## Anonymise, do not remove
 *
 * The row survives with its identifying columns emptied. Deleting it outright
 * would take the payment history with it, which the law requires keeping, and
 * would leave the audit log pointing at nothing -- and an audit trail with
 * dangling actors is not a trail, it is a list of anonymous events that
 * settles no dispute.
 *
 * So: everything that identifies a person goes, and money, moderation history
 * and the audit trail stay with the person taken out of them.
 *
 * ## Thirty days, not instantly
 *
 * Deletion is usually decided in the middle of something -- an argument, a bad
 * day, somebody standing over you. A wipe with no way back turns a moment into
 * a permanent loss, so the request sets a date and a job does the work. The
 * account keeps working meanwhile and the app shows the date with a way to
 * stop it.
 *
 * ## One thing it deliberately does NOT do
 *
 * It does not refuse when there are unwithdrawn referral earnings. That was
 * the first design and it was wrong: payouts need Cashfree Verification, which
 * is not configured, so nobody with a balance can withdraw -- and refusing
 * would leave those accounts permanently undeletable, which is the exact
 * requirement this exists to satisfy. Instead the amount is shown, the person
 * acknowledges it, and the figure is recorded so a later claim can be honoured.
 */
@Injectable()
export class AccountDeletionService {
  private readonly logger = new Logger(AccountDeletionService.name);

  /** How long someone has to change their mind. */
  static readonly GRACE_DAYS = 30;

  /**
   * What a deleted person's messages leave behind.
   *
   * Their rows are soft-deleted, so every chat query already skips them, and
   * the body is overwritten so the plaintext is genuinely gone rather than
   * merely hidden behind a flag somebody could stop honouring later.
   */
  private static readonly TOMBSTONE = 'deleted-account';

  constructor(
    private readonly prisma: PrismaService,
    private readonly crypto: CryptoService,
    private readonly audit: AuditService,
  ) {}

  // ── Before deciding ─────────────────────────────────────────────────

  /**
   * Everything the confirmation screen needs to be honest.
   *
   * Shown before the button, not as an error after it. Somebody who taps
   * delete and is then told about a gym they own has been made to feel the
   * decision was refused, when what they needed was to know first.
   */
  async preview(userId: string) {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
      select: { id: true, deletionScheduledFor: true, anonymisedAt: true },
    });
    if (!user || user.anonymisedAt) throw new NotFoundException('No such account');

    const [gyms, memberships, staffRoles, referral] = await Promise.all([
      this.prisma.gym.findMany({
        where: { ownerId: userId, status: { not: GymStatus.DELETED } },
        select: { id: true, name: true, status: true },
      }),
      this.prisma.membership.count({
        where: {
          userId,
          status: { in: [MembershipStatus.ACTIVE, MembershipStatus.ON_LEAVE] },
        },
      }),
      this.prisma.staffMember.count({
        where: { userId, status: StaffStatus.ACTIVE },
      }),
      this.prisma.referralAccount.findUnique({
        where: { userId },
        select: { pendingPaise: true },
      }),
    ]);

    return {
      // A gym owner is stopped, and told which gyms and why. Everything else
      // is a warning rather than a blocker.
      blockers: gyms.map((g) => ({
        type: 'OWNS_GYM' as const,
        gymId: g.id,
        name: g.name,
        message:
          'Delete this gym first. Members and staff would lose access to it, and they will be told it has closed.',
      })),
      willLose: {
        memberships,
        staffRoles,
        // Shown as an amount so the acknowledgement is about a number, not a
        // vague possibility.
        unwithdrawnPaise: referral?.pendingPaise ?? 0,
      },
      graceDays: AccountDeletionService.GRACE_DAYS,
      alreadyScheduledFor: user.deletionScheduledFor,
    };
  }

  // ── Asking ──────────────────────────────────────────────────────────

  async request(
    userId: string,
    via: 'APP' | 'WEB',
    meta: RequestMeta,
  ) {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
      select: {
        id: true,
        phone: true,
        deletionScheduledFor: true,
        anonymisedAt: true,
      },
    });
    if (!user || user.anonymisedAt) throw new NotFoundException('No such account');

    // Asking twice is the same state as asking once. Returning the existing
    // date rather than erroring, and NOT pushing the date out, because a
    // second tap must never quietly extend how long the account survives.
    if (user.deletionScheduledFor) {
      return {
        scheduledFor: user.deletionScheduledFor,
        graceDays: AccountDeletionService.GRACE_DAYS,
        alreadyRequested: true,
      };
    }

    const ownedGyms = await this.prisma.gym.count({
      where: { ownerId: userId, status: { not: GymStatus.DELETED } },
    });
    if (ownedGyms > 0) {
      throw new ConflictException(
        'Delete your gyms first. Deleting your account would cut off every member and staff member in them.',
      );
    }

    const referral = await this.prisma.referralAccount.findUnique({
      where: { userId },
      select: { pendingPaise: true },
    });

    const scheduledFor = new Date(
      Date.now() + AccountDeletionService.GRACE_DAYS * 24 * 60 * 60 * 1000,
    );

    await this.prisma.$transaction([
      this.prisma.user.update({
        where: { id: userId },
        data: { deletionRequestedAt: new Date(), deletionScheduledFor: scheduledFor },
      }),
      this.prisma.accountDeletion.create({
        data: {
          userId,
          // Peppered rather than a bare SHA-256. A phone number is ten
          // digits: plain hashing it is a rainbow table somebody builds in
          // an afternoon, and the pepper is what makes this a one-way trace
          // instead of a reversible one.
          phoneHash: this.crypto.hashToken(user.phone),
          scheduledFor,
          requestedVia: via,
          balancePaise: referral?.pendingPaise ?? 0,
        },
      }),
    ]);

    await this.audit.record({
      actorId: userId,
      action: 'account.delete.request',
      entityType: 'User',
      entityId: userId,
      before: { deletionScheduledFor: null },
      after: { deletionScheduledFor: scheduledFor, via },
      ip: meta.ip,
      userAgent: meta.userAgent,
    });

    this.logger.warn(`Account deletion requested via ${via}`);

    return {
      scheduledFor,
      graceDays: AccountDeletionService.GRACE_DAYS,
      alreadyRequested: false,
    };
  }

  async cancel(userId: string, meta: RequestMeta) {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
      select: { id: true, deletionScheduledFor: true, anonymisedAt: true },
    });
    if (!user || user.anonymisedAt) throw new NotFoundException('No such account');

    if (!user.deletionScheduledFor) {
      // Not an error: they wanted the account kept and it is being kept.
      return { scheduledFor: null, cancelled: false };
    }

    await this.prisma.$transaction([
      this.prisma.user.update({
        where: { id: userId },
        data: { deletionRequestedAt: null, deletionScheduledFor: null },
      }),
      this.prisma.accountDeletion.updateMany({
        where: { userId, completedAt: null, cancelledAt: null },
        data: { cancelledAt: new Date() },
      }),
    ]);

    await this.audit.record({
      actorId: userId,
      action: 'account.delete.cancel',
      entityType: 'User',
      entityId: userId,
      before: { deletionScheduledFor: user.deletionScheduledFor },
      after: { deletionScheduledFor: null },
      ip: meta.ip,
      userAgent: meta.userAgent,
    });

    return { scheduledFor: null, cancelled: true };
  }

  async status(userId: string) {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
      select: { deletionRequestedAt: true, deletionScheduledFor: true },
    });
    if (!user) throw new NotFoundException('No such account');

    return {
      pending: user.deletionScheduledFor !== null,
      requestedAt: user.deletionRequestedAt,
      scheduledFor: user.deletionScheduledFor,
      graceDays: AccountDeletionService.GRACE_DAYS,
    };
  }

  // ── Doing it ────────────────────────────────────────────────────────

  /** Every account whose date has passed. Called by the scheduler. */
  async runDue(now = new Date()): Promise<number> {
    const due = await this.prisma.user.findMany({
      where: {
        deletionScheduledFor: { lte: now },
        anonymisedAt: null,
      },
      select: { id: true },
      take: 200,
    });

    let done = 0;
    for (const { id } of due) {
      try {
        await this.anonymise(id);
        done += 1;
      } catch (error) {
        // One failure must not stop the rest. An account that stays past
        // its date is a promise broken quietly, so it is logged loudly.
        this.logger.error(
          `ACCOUNT ANONYMISATION FAILED for ${id} — ${(error as Error).message}`,
        );
      }
    }

    if (done > 0) this.logger.warn(`Anonymised ${done} account(s)`);
    return done;
  }

  /**
   * The wipe itself.
   *
   * One transaction, because a half-anonymised account is worse than either
   * end state: the name is gone from one screen and present on the next, and
   * nobody can tell which rows were reached.
   */
  async anonymise(userId: string): Promise<void> {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
      select: { id: true, anonymisedAt: true },
    });
    if (!user) throw new NotFoundException('No such account');
    if (user.anonymisedAt) return; // Already done. Doing it twice is a no-op.

    const now = new Date();

    // The phone number is the login identity and it is unique, so it cannot
    // simply be blanked. Overwriting it frees the real number: a person who
    // comes back gets a genuinely new account with no history, which is what
    // having deleted the old one ought to mean.
    //
    // Sixteen characters is the column width, and `del-` plus twelve hex
    // digits is exactly that.
    const sentinel = `del-${userId.replace(/-/g, '').slice(0, 12)}`;

    await this.prisma.$transaction(async (tx) => {
      // Anything that is purely a handle on this person: gone outright.
      await tx.session.deleteMany({ where: { userId } });
      await tx.device.deleteMany({ where: { userId } });
      await tx.notificationRecipient.deleteMany({ where: { userId } });

      // Health data. The most sensitive thing here and the least defensible
      // to keep -- nothing downstream reads a departed member's weight.
      await tx.bodyMetric.deleteMany({ where: { userId } });

      // Blocks in both directions. The account is going and the phone is
      // being freed, so a block pointing at it protects nobody.
      await tx.userBlock.deleteMany({
        where: { OR: [{ blockerId: userId }, { blockedId: userId }] },
      });

      // Messages are soft-deleted AND overwritten. The flag is what every
      // chat query already filters on; the overwrite is what makes the
      // plaintext actually gone rather than one forgotten filter away from
      // being readable again.
      await tx.message.updateMany({
        where: { senderId: userId, deletedAt: null },
        data: {
          deletedAt: now,
          ciphertext: AccountDeletionService.TOMBSTONE,
          nonce: AccountDeletionService.TOMBSTONE,
        },
      });
      await tx.conversationMember.updateMany({
        where: { userId, leftAt: null },
        data: { leftAt: now },
      });

      // Gyms stop showing a ghost member or staff member.
      await tx.membership.updateMany({
        where: {
          userId,
          status: { in: [MembershipStatus.ACTIVE, MembershipStatus.ON_LEAVE] },
        },
        data: { status: MembershipStatus.REMOVED },
      });
      await tx.staffMember.updateMany({
        where: { userId, status: { not: StaffStatus.REMOVED } },
        data: { status: StaffStatus.REMOVED },
      });

      // A support ticket carries the number and address they wrote in.
      await tx.supportTicket.updateMany({
        where: { userId },
        data: { contactPhone: 'deleted', contactEmail: null },
      });

      // The referral account keeps its money columns and loses its identity
      // ones. The totals are an accounting record; the UPI handle and PAN
      // are exactly what somebody deleting their account wants gone.
      await tx.referralAccount.updateMany({
        where: { userId },
        data: {
          upiIdEnc: null,
          upiIdMasked: null,
          upiHolderName: null,
          upiVerified: false,
          panEnc: null,
          panLast4: null,
          status: ReferralAccountStatus.BLOCKED,
        },
      });

      await tx.user.update({
        where: { id: userId },
        data: {
          phone: sentinel,
          name: 'Deleted account',
          email: null,
          age: null,
          avatarUrl: null,
          lastLoginAt: null,
          termsVersion: null,
          termsAcceptedAt: null,
          anonymisedAt: now,
          deletionScheduledFor: null,
        },
      });

      await tx.accountDeletion.updateMany({
        where: { userId, completedAt: null, cancelledAt: null },
        data: { completedAt: now },
      });
    });

    // Written after the transaction, not inside it: an audit failure must
    // not roll back a deletion the person asked for and was promised.
    await this.audit.record({
      actorId: null,
      action: 'account.delete.complete',
      entityType: 'User',
      entityId: userId,
      before: null,
      // No identifying values, deliberately. Recording the name and number
      // that were just erased, in a table admins can read, would undo the
      // work.
      after: { anonymised: true },
    });
  }
}
