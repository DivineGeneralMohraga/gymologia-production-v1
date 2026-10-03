import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { Prisma, ReportStatus, ReportTarget } from '@prisma/client';

import { PrismaService } from '../prisma/prisma.service';
import { AuditService } from '../common/audit/audit.service';
import type { AdminContext } from '../admin/admin.guard';
import {
  ListReportsDto,
  ResolveReportDto,
  SetListingHiddenDto,
} from './dto/safety.dto';

interface RequestMeta {
  ip?: string | null;
  userAgent?: string | null;
}

/**
 * The desk that reads reports.
 *
 * A report queue nobody works is worse than no report button, because it
 * asks a person being harassed to describe what happened and then does
 * nothing with it. This is the other half of the feature, not an extra.
 *
 * What a reviewer sees is bounded by policy rather than by arithmetic. The
 * server holds the key to message bodies and `ChatService` decrypts them
 * routinely; this desk does not, so working the queue never means reading
 * private conversations. The reporter's own account is therefore the
 * evidence. Everything around it — who sent it, in which conversation,
 * when, and how many other people have reported or blocked the same
 * account — is independently verifiable, and that context is what turns one
 * person's word against another into a decision that can be defended.
 */
@Injectable()
export class SafetyReviewService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly audit: AuditService,
  ) {}

  async list(dto: ListReportsDto) {
    const page = dto.page ?? 1;
    const pageSize = dto.pageSize ?? 25;

    const where: Prisma.ContentReportWhereInput = {
      ...(dto.status ? { status: dto.status } : {}),
      ...(dto.target ? { target: dto.target } : {}),
      ...(dto.category ? { category: dto.category } : {}),
    };

    const [total, rows] = await Promise.all([
      this.prisma.contentReport.count({ where }),
      this.prisma.contentReport.findMany({
        where,
        // Open first, then oldest. A desk that works newest-first leaves
        // the earliest complaint — the one that has been waiting longest
        // for an answer — permanently at the bottom.
        orderBy: [{ status: 'asc' }, { createdAt: 'asc' }],
        skip: (page - 1) * pageSize,
        take: pageSize,
        select: {
          id: true,
          category: true,
          status: true,
          details: true,
          createdAt: true,
          reviewedAt: true,
          actionTaken: true,
          reporter: { select: { id: true, name: true } },
          target: true,
          reportedUser: { select: { id: true, name: true, phone: true } },
          gym: { select: { id: true, name: true, listingHiddenAt: true } },
          event: { select: { id: true, title: true, hiddenAt: true } },
          reviewedBy: { select: { user: { select: { name: true } } } },
        },
      }),
    ]);

    return {
      items: rows.map((r) => ({
        id: r.id,
        category: r.category,
        status: r.status,
        details: r.details,
        reporter: r.reporter,
        reportedUser: {
          id: r.reportedUser.id,
          name: r.reportedUser.name,
        },
        target: r.target,
        gym: r.gym
          ? { id: r.gym.id, name: r.gym.name, hidden: r.gym.listingHiddenAt !== null }
          : null,
        event: r.event
          ? { id: r.event.id, title: r.event.title, hidden: r.event.hiddenAt !== null }
          : null,
        filedAt: r.createdAt,
        reviewedAt: r.reviewedAt,
        reviewedBy: r.reviewedBy?.user.name ?? null,
        actionTaken: r.actionTaken,
      })),
      total,
      page,
      pageSize,
    };
  }

  /**
   * One report with its context.
   *
   * The history against the same account is the point of this screen. A
   * single complaint is one person's account of a conversation; six
   * complaints from six unrelated people is a pattern, and the two need
   * completely different responses.
   */
  async detail(reportId: string) {
    const report = await this.prisma.contentReport.findUnique({
      where: { id: reportId },
      select: {
        id: true,
        category: true,
        status: true,
        details: true,
        createdAt: true,
        reviewedAt: true,
        actionTaken: true,
        messageId: true,
        reporter: { select: { id: true, name: true } },
        reportedUser: {
          select: { id: true, name: true, phone: true, createdAt: true },
        },
        target: true,
        conversation: { select: { id: true, type: true } },
        // For a gym or event report the listing itself is the evidence: it
        // is public, so the desk shows what the reporter saw.
        gym: {
          select: {
            id: true,
            name: true,
            description: true,
            district: true,
            state: true,
            contactPhone: true,
            listingHiddenAt: true,
            listingHiddenReason: true,
            images: { select: { url: true }, orderBy: { sortOrder: 'asc' }, take: 5 },
            perks: { select: { label: true } },
          },
        },
        event: {
          select: {
            id: true,
            title: true,
            bannerUrl: true,
            description: true,
            howToParticipate: true,
            prize: true,
            prizeDescription: true,
            startsAt: true,
            hiddenAt: true,
            hiddenReason: true,
          },
        },
        reviewedBy: { select: { user: { select: { name: true } } } },
        message: {
          select: { id: true, senderId: true, createdAt: true, deletedAt: true },
        },
      },
    });
    if (!report) throw new NotFoundException('No such report');

    const [priorAgainst, priorBy, blocksAgainst, sameListing] = await Promise.all([
      this.prisma.contentReport.count({
        where: { reportedUserId: report.reportedUser.id, id: { not: reportId } },
      }),
      this.prisma.contentReport.count({
        where: { reporterId: report.reporter.id, id: { not: reportId } },
      }),
      // How many people have blocked this account. The strongest signal
      // available, because a block costs the blocker nothing to make and
      // they gain nothing by it -- unlike a report, which can be malicious.
      this.prisma.userBlock.count({
        where: { blockedId: report.reportedUser.id },
      }),
      // How many other people reported this same gym or event. Several
      // unrelated reporters is what makes a takedown easy to stand behind.
      report.target === ReportTarget.EVENT && report.event
        ? this.prisma.contentReport.count({
            where: { eventId: report.event.id, target: ReportTarget.EVENT, id: { not: reportId } },
          })
        : report.target === ReportTarget.GYM && report.gym
          ? this.prisma.contentReport.count({
              where: { gymId: report.gym.id, target: ReportTarget.GYM, id: { not: reportId } },
            })
          : Promise.resolve(0),
    ]);

    return {
      ...report,
      gym: report.gym
        ? {
            id: report.gym.id,
            name: report.gym.name,
            description: report.gym.description,
            district: report.gym.district,
            state: report.gym.state,
            contactPhone: report.gym.contactPhone,
            images: report.gym.images.map((i) => i.url),
            perks: report.gym.perks.map((p) => p.label),
            hidden: report.gym.listingHiddenAt !== null,
            hiddenAt: report.gym.listingHiddenAt,
            hiddenReason: report.gym.listingHiddenReason,
          }
        : null,
      event: report.event
        ? {
            ...report.event,
            hidden: report.event.hiddenAt !== null,
          }
        : null,
      reviewedBy: report.reviewedBy?.user.name ?? null,
      message: report.message
        ? {
            id: report.message.id,
            sentAt: report.message.createdAt,
            deleted: report.message.deletedAt !== null,
            // Said explicitly so nobody spends time looking for a way to
            // open it on this screen. Deliberately does not claim the
            // message is unreadable anywhere -- it is not, and a reviewer
            // told otherwise would repeat it to somebody who relied on it.
            body: null,
            bodyNote:
              'Message contents are not shown on this desk, so that working the queue does not mean reading private conversations. The reporter’s description above is the account of what was said.',
          }
        : null,
      context: {
        priorReportsAgainstThisAccount: priorAgainst,
        reportsFiledByThisReporter: priorBy,
        peopleWhoHaveBlockedThisAccount: blocksAgainst,
        otherReportsOfThisListing: sameListing,
      },
    };
  }

  async resolve(
    admin: AdminContext,
    reportId: string,
    dto: ResolveReportDto,
    meta: RequestMeta,
  ) {
    if (dto.status === ReportStatus.OPEN) {
      throw new BadRequestException(
        'A report cannot be moved back to open — it starts there.',
      );
    }

    const existing = await this.prisma.contentReport.findUnique({
      where: { id: reportId },
      select: { id: true, status: true, actionTaken: true },
    });
    if (!existing) throw new NotFoundException('No such report');

    const updated = await this.prisma.contentReport.update({
      where: { id: reportId },
      data: {
        status: dto.status,
        actionTaken: dto.actionTaken,
        reviewedById: admin.adminId,
        // REVIEWING means somebody has picked it up, not that it is
        // finished, so the decision timestamp is only set when it is.
        reviewedAt:
          dto.status === ReportStatus.REVIEWING ? null : new Date(),
      },
      select: { id: true, status: true, reviewedAt: true, actionTaken: true },
    });

    await this.audit.record({
      actorId: admin.userId,
      action: 'safety.report.resolve',
      entityType: 'ContentReport',
      entityId: reportId,
      before: { status: existing.status, actionTaken: existing.actionTaken },
      after: { status: updated.status, actionTaken: updated.actionTaken },
      ip: meta.ip,
      userAgent: meta.userAgent,
    });

    return updated;
  }

  /**
   * Hiding the gym or event a report is about, or bringing it back.
   *
   * A gym is hidden from search, its public page, the ranking and the
   * national events feed; its own staff and members keep their CRM and
   * their gym. An event is hidden from every feed and cannot be joined.
   * Either way nothing is deleted, so a mistaken takedown is one tap to undo.
   *
   * Works on the report rather than on a gym or event id, so every takedown
   * traces back to the complaint that prompted it.
   */
  async setListingHidden(
    admin: AdminContext,
    reportId: string,
    dto: SetListingHiddenDto,
    meta: RequestMeta,
  ) {
    if (dto.hidden && !dto.reason) {
      throw new BadRequestException(
        'Say why it is being hidden. The gym sees this reason.',
      );
    }

    const report = await this.prisma.contentReport.findUnique({
      where: { id: reportId },
      select: { id: true, target: true, gymId: true, eventId: true },
    });
    if (!report) throw new NotFoundException('No such report');

    const now = new Date();
    let entityType: 'Gym' | 'Event';
    let entityId: string;
    let before: { hidden: boolean; reason: string | null };

    if (report.target === ReportTarget.EVENT && report.eventId) {
      const event = await this.prisma.event.findUnique({
        where: { id: report.eventId },
        select: { id: true, hiddenAt: true, hiddenReason: true },
      });
      if (!event) throw new NotFoundException('That event no longer exists');
      before = { hidden: event.hiddenAt !== null, reason: event.hiddenReason };
      await this.prisma.event.update({
        where: { id: event.id },
        data: dto.hidden
          ? { hiddenAt: event.hiddenAt ?? now, hiddenReason: dto.reason }
          : { hiddenAt: null, hiddenReason: null },
      });
      entityType = 'Event';
      entityId = event.id;
    } else if (report.target === ReportTarget.GYM && report.gymId) {
      const gym = await this.prisma.gym.findUnique({
        where: { id: report.gymId },
        select: { id: true, listingHiddenAt: true, listingHiddenReason: true },
      });
      if (!gym) throw new NotFoundException('That gym no longer exists');
      before = { hidden: gym.listingHiddenAt !== null, reason: gym.listingHiddenReason };
      await this.prisma.gym.update({
        where: { id: gym.id },
        data: dto.hidden
          ? { listingHiddenAt: gym.listingHiddenAt ?? now, listingHiddenReason: dto.reason }
          : { listingHiddenAt: null, listingHiddenReason: null },
      });
      entityType = 'Gym';
      entityId = gym.id;
    } else {
      throw new BadRequestException(
        'This report is about a person, not a gym or event. Use the account ban instead.',
      );
    }

    await this.audit.record({
      actorId: admin.userId,
      action: dto.hidden ? 'safety.listing.hide' : 'safety.listing.unhide',
      entityType,
      entityId,
      before,
      after: { hidden: dto.hidden, reason: dto.hidden ? dto.reason : null, reportId },
      ip: meta.ip,
      userAgent: meta.userAgent,
    });

    return { target: report.target, id: entityId, hidden: dto.hidden };
  }
}
