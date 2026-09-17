import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { Prisma, ReportStatus } from '@prisma/client';

import { PrismaService } from '../prisma/prisma.service';
import { AuditService } from '../common/audit/audit.service';
import type { AdminContext } from '../admin/admin.guard';
import { ListReportsDto, ResolveReportDto } from './dto/safety.dto';

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
          reportedUser: { select: { id: true, name: true, phone: true } },
          gym: { select: { id: true, name: true } },
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
        gym: r.gym,
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
        conversation: { select: { id: true, type: true } },
        gym: { select: { id: true, name: true } },
        reviewedBy: { select: { user: { select: { name: true } } } },
        message: {
          select: { id: true, senderId: true, createdAt: true, deletedAt: true },
        },
      },
    });
    if (!report) throw new NotFoundException('No such report');

    const [priorAgainst, priorBy, blocksAgainst] = await Promise.all([
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
    ]);

    return {
      ...report,
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
}
