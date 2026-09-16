import {
  BadRequestException,
  ForbiddenException,
  Injectable,
  Logger,
  NotFoundException,
} from '@nestjs/common';
import { Prisma, ReportCategory, ReportStatus } from '@prisma/client';

import { PrismaService } from '../prisma/prisma.service';
import { AuditService } from '../common/audit/audit.service';

interface RequestMeta {
  ip?: string | null;
  userAgent?: string | null;
}

/**
 * Getting away from somebody, and telling us about them.
 *
 * The chat carries user-generated content -- members message members, and
 * the unofficial group is one staff cannot see into. An app that offers
 * that and no way out is missing the thing every such app needs, and Play
 * requires both halves explicitly for exactly this reason.
 *
 * ## Blocking is silent, and cuts both ways
 *
 * A one-directional record, enforced in both directions. If A blocks B then
 * neither sees the other's messages and neither can open a direct
 * conversation with the other. Hiding only one side would leave A still
 * receiving what they blocked to escape; telling B would invite retaliation
 * somewhere this app cannot see.
 *
 * ## A report carries text because the server cannot read the message
 *
 * Messages are AES-GCM ciphertext and no key is held here. A report naming
 * only a message id would hand a reviewer a row they cannot open. So the
 * reporter's own account of what they saw is the evidence, and the message
 * id travels with it for everything that IS verifiable: who sent it, in
 * which conversation, at what time.
 */
@Injectable()
export class SafetyService {
  private readonly logger = new Logger(SafetyService.name);

  /** How many reports one person may file in a day. */
  private static readonly REPORTS_PER_DAY = 20;

  constructor(
    private readonly prisma: PrismaService,
    private readonly audit: AuditService,
  ) {}

  // ── Blocking ────────────────────────────────────────────────────────

  async block(
    blockerId: string,
    blockedId: string,
    reason: string | undefined,
    meta: RequestMeta,
  ) {
    if (blockerId === blockedId) {
      throw new BadRequestException('You cannot block yourself');
    }

    const target = await this.prisma.user.findUnique({
      where: { id: blockedId },
      select: { id: true, name: true },
    });
    if (!target) throw new NotFoundException('No such person');

    // Blocking twice is the same state as blocking once, so the second
    // attempt succeeds quietly instead of erroring on the unique index.
    await this.prisma.userBlock.upsert({
      where: { blockerId_blockedId: { blockerId, blockedId } },
      create: { blockerId, blockedId, reason: reason ?? null },
      update: { reason: reason ?? null },
    });

    await this.audit.record({
      actorId: blockerId,
      action: 'safety.block',
      entityType: 'User',
      entityId: blockedId,
      before: null,
      after: { blocked: true },
      ip: meta.ip,
      userAgent: meta.userAgent,
    });

    return { blocked: true, userId: blockedId, name: target.name };
  }

  async unblock(blockerId: string, blockedId: string, meta: RequestMeta) {
    const existing = await this.prisma.userBlock.findUnique({
      where: { blockerId_blockedId: { blockerId, blockedId } },
      select: { id: true },
    });
    if (!existing) {
      // Not an error: the caller wanted this person unblocked and they are.
      return { blocked: false, userId: blockedId };
    }

    await this.prisma.userBlock.delete({ where: { id: existing.id } });
    await this.audit.record({
      actorId: blockerId,
      action: 'safety.unblock',
      entityType: 'User',
      entityId: blockedId,
      before: { blocked: true },
      after: { blocked: false },
      ip: meta.ip,
      userAgent: meta.userAgent,
    });

    return { blocked: false, userId: blockedId };
  }

  /** Who this person has blocked. Never who has blocked them. */
  async listBlocks(blockerId: string) {
    const rows = await this.prisma.userBlock.findMany({
      where: { blockerId },
      orderBy: { createdAt: 'desc' },
      include: { blocked: { select: { id: true, name: true, avatarUrl: true } } },
    });

    return {
      items: rows.map((r) => ({
        userId: r.blocked.id,
        name: r.blocked.name,
        avatarUrl: r.blocked.avatarUrl,
        reason: r.reason,
        blockedAt: r.createdAt,
      })),
    };
  }

  /**
   * Every user id that should be invisible to this person, in either
   * direction.
   *
   * One query rather than two, and the caller gets a Set because the chat
   * checks it per message. Callers that have no blocks pay for one indexed
   * lookup returning nothing.
   */
  async invisibleTo(userId: string): Promise<Set<string>> {
    const rows = await this.prisma.userBlock.findMany({
      where: { OR: [{ blockerId: userId }, { blockedId: userId }] },
      select: { blockerId: true, blockedId: true },
    });

    const ids = new Set<string>();
    for (const r of rows) {
      ids.add(r.blockerId === userId ? r.blockedId : r.blockerId);
    }
    return ids;
  }

  /**
   * Only the people this person has blocked themselves.
   *
   * Separate from `invisibleTo` because the two answer different
   * questions. This one is safe to show -- "you blocked them" is the
   * blocker's own information. `invisibleTo` merges both directions and
   * must never be rendered as a list, or it tells somebody who blocked
   * them.
   */
  async blockedByMe(blockerId: string): Promise<Set<string>> {
    const rows = await this.prisma.userBlock.findMany({
      where: { blockerId },
      select: { blockedId: true },
    });
    return new Set(rows.map((r) => r.blockedId));
  }

  /** Whether either of these two has blocked the other. */
  async isBlockedBetween(a: string, b: string): Promise<boolean> {
    const row = await this.prisma.userBlock.findFirst({
      where: {
        OR: [
          { blockerId: a, blockedId: b },
          { blockerId: b, blockedId: a },
        ],
      },
      select: { id: true },
    });
    return Boolean(row);
  }

  // ── Reporting ───────────────────────────────────────────────────────

  async report(
    reporterId: string,
    input: {
      reportedUserId: string;
      category: ReportCategory;
      details: string;
      messageId?: string;
      conversationId?: string;
      gymId?: string;
    },
    meta: RequestMeta,
  ) {
    if (reporterId === input.reportedUserId) {
      throw new BadRequestException('You cannot report yourself');
    }

    const target = await this.prisma.user.findUnique({
      where: { id: input.reportedUserId },
      select: { id: true },
    });
    if (!target) throw new NotFoundException('No such person');

    // A cap, because a report queue is read by a person. Someone filing
    // hundreds is either automating abuse of the queue or is in a
    // situation that blocking solves better.
    const since = new Date(Date.now() - 24 * 60 * 60 * 1000);
    const todaysCount = await this.prisma.contentReport.count({
      where: { reporterId, createdAt: { gte: since } },
    });
    if (todaysCount >= SafetyService.REPORTS_PER_DAY) {
      throw new ForbiddenException(
        'You have filed a lot of reports today. If somebody is bothering you, block them — that takes effect immediately.',
      );
    }

    // If a message is named, it has to exist and it has to be theirs.
    // Otherwise a report could pin somebody else's words on an innocent
    // account, and the reviewer has no way to tell.
    if (input.messageId) {
      const msg = await this.prisma.message.findUnique({
        where: { id: input.messageId },
        select: { id: true, senderId: true, conversationId: true },
      });
      if (!msg) throw new NotFoundException('No such message');
      if (msg.senderId !== input.reportedUserId) {
        throw new BadRequestException(
          'That message was not sent by the person being reported',
        );
      }
    }

    try {
      const created = await this.prisma.contentReport.create({
        data: {
          reporterId,
          reportedUserId: input.reportedUserId,
          messageId: input.messageId ?? null,
          conversationId: input.conversationId ?? null,
          gymId: input.gymId ?? null,
          category: input.category,
          details: input.details,
          status: ReportStatus.OPEN,
        },
      });

      await this.audit.record({
        actorId: reporterId,
        action: 'safety.report',
        entityType: 'ContentReport',
        entityId: created.id,
        before: null,
        // Deliberately NOT the details. Those are the reporter's account of
        // something said to them, often the very abuse being reported, and
        // the audit log is read by every admin holding the log viewer.
        after: {
          category: created.category,
          reportedUserId: created.reportedUserId,
          hasMessage: Boolean(created.messageId),
        },
        ip: meta.ip,
        userAgent: meta.userAgent,
      });

      this.logger.warn(
        `Report filed: ${created.category} against user ${created.reportedUserId}`,
      );

      return {
        id: created.id,
        status: created.status,
        // Said plainly, because the commonest disappointment with a report
        // is expecting something to happen instantly and seeing nothing.
        message:
          'Thank you. A person will review this. If you want it to stop now, block them as well — that takes effect immediately.',
      };
    } catch (error) {
      if (
        error instanceof Prisma.PrismaClientKnownRequestError &&
        error.code === 'P2002'
      ) {
        // The same message reported twice by the same person. Not an error
        // worth showing: their report is already in the queue.
        return {
          id: null,
          status: ReportStatus.OPEN,
          message: 'You have already reported this. It is in the queue.',
        };
      }
      throw error;
    }
  }

  /** What this person has reported, so they can see it was recorded. */
  async myReports(reporterId: string) {
    const rows = await this.prisma.contentReport.findMany({
      where: { reporterId },
      orderBy: { createdAt: 'desc' },
      take: 50,
      select: {
        id: true,
        category: true,
        status: true,
        createdAt: true,
        reportedUser: { select: { name: true } },
      },
    });

    return {
      items: rows.map((r) => ({
        id: r.id,
        category: r.category,
        // The outcome, not the reviewer's notes: what was decided about
        // another person's account is not the reporter's to read.
        status: r.status,
        about: r.reportedUser.name,
        filedAt: r.createdAt,
      })),
    };
  }
}
