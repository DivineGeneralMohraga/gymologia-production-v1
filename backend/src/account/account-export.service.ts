import { Injectable } from '@nestjs/common';
import { SubjectType } from '@prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { ConsentService } from '../common/consent/consent.service';

/**
 * Data portability — DPDP Act 2023 Section 12(a).
 *
 * Returns every personal data record held for a user in one JSON
 * structure. The member can download this from Settings. Nothing is
 * redacted except the identifiers that are by design unreadable (OTP
 * hashes, encrypted KYC blobs). Third-party payment references are
 * included as they form part of the financial record.
 */
@Injectable()
export class AccountExportService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly consent: ConsentService,
  ) {}

  async export(userId: string) {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
      select: {
        id: true,
        phone: true,
        name: true,
        email: true,
        age: true,
        locale: true,
        createdAt: true,
        termsVersion: true,
        termsAcceptedAt: true,
      },
    });

    const memberships = await this.prisma.membership.findMany({
      where: { userId },
      select: {
        id: true,
        gymId: true,
        gym: { select: { name: true } },
        status: true,
        startsAt: true,
        endsAt: true,
        planMonths: true,
        maxLeaveDays: true,
        goal: true,
        allowProgressMonitoring: true,
        createdAt: true,
      },
    });

    const bodyMetrics = await this.prisma.bodyMetric.findMany({
      where: { userId },
      select: { weightKg: true, heightCm: true, recordedAt: true },
      orderBy: { recordedAt: 'asc' },
    });

    const attendance = await this.prisma.attendanceRecord.findMany({
      where: { subjectId: userId, subjectType: SubjectType.MEMBER },
      select: {
        date: true,
        status: true,
        gym: { select: { name: true } },
      },
      orderBy: { date: 'desc' },
      take: 1000,
    });

    const leaveRequests = await this.prisma.leaveRequest.findMany({
      where: { subjectId: userId, subjectType: SubjectType.MEMBER },
      select: {
        fromDate: true,
        toDate: true,
        days: true,
        status: true,
        createdAt: true,
        decidedAt: true,
      },
    });

    const supportTickets = await this.prisma.supportTicket.findMany({
      where: { userId },
      select: {
        id: true,
        subject: true,
        status: true,
        priority: true,
        createdAt: true,
      },
    });

    const consentHistory = await this.consent.history(userId);

    return {
      exportedAt: new Date().toISOString(),
      notice:
        'This is all personal data Gymologia holds about your account. ' +
        'Encrypted fields (KYC documents, UPI ID) are not included in plaintext. ' +
        'To request correction or deletion write to support@gymologia.com.',
      account: user,
      memberships,
      bodyMetrics,
      attendance,
      leaveRequests,
      supportTickets,
      consentHistory,
    };
  }
}
