import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { Prisma, VerificationStatus } from '@prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { AuditService } from '../common/audit/audit.service';
import { StorageService } from '../uploads/storage.service';
import type { AdminContext } from '../admin/admin.guard';
import { KycDecisionDto } from './dto/kyc-review.dto';

/**
 * Verification from the reviewer's side.
 *
 * A reviewer never sees a full Aadhaar, PAN or GSTIN. That is deliberate,
 * and it is not an obstacle to the job: whether a *number* is genuine is a
 * question for the issuing registry, which is what the verification
 * provider asks. What a human is for is the part a registry cannot answer
 * -- does this landlord's letter name this address, does the electricity
 * bill belong to the same person as the PAN. So the console gets the
 * documents and the last four digits, and nothing more.
 *
 * Document links are signed and expire in minutes. A reviewer who pastes
 * one into a chat has shared something already dead by the time anyone
 * else opens it.
 */
@Injectable()
export class KycReviewService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly audit: AuditService,
    private readonly storage: StorageService,
  ) {}

  /** Everything waiting on a human, oldest first: a queue, not a list. */
  async queue(take = 25, skip = 0) {
    const where: Prisma.GymKycWhereInput = {
      verifiedAt: null,
      OR: [
        { aadhaarStatus: VerificationStatus.PENDING },
        { panStatus: VerificationStatus.PENDING },
        { gstStatus: VerificationStatus.PENDING },
        { nocStatus: VerificationStatus.PENDING },
      ],
    };

    const [rows, total] = await this.prisma.$transaction([
      this.prisma.gymKyc.findMany({
        where,
        orderBy: { updatedAt: 'asc' },
        take: Math.min(take, 100),
        skip,
        select: {
          gymId: true,
          premises: true,
          altProofType: true,
          aadhaarLast4: true,
          panLast4: true,
          gstinLast4: true,
          aadhaarStatus: true,
          panStatus: true,
          gstStatus: true,
          nocStatus: true,
          rejectionReason: true,
          updatedAt: true,
          gym: { select: { name: true, city: true, district: true, state: true } },
        },
      }),
      this.prisma.gymKyc.count({ where }),
    ]);

    return { total, items: rows };
  }

  /**
   * One submission, with links that open the documents.
   *
   * The links are minted per request rather than stored, so a reviewer who
   * bookmarks this response gets nothing useful back later.
   */
  async detail(gymId: string) {
    const kyc = await this.prisma.gymKyc.findUnique({
      where: { gymId },
      include: {
        gym: {
          select: {
            name: true,
            addressLine1: true,
            city: true,
            district: true,
            state: true,
            pincode: true,
          },
        },
      },
    });
    if (!kyc) throw new NotFoundException('No submission for that gym');

    const documents: Array<{ kind: string; url: string }> = [];
    for (const [kind, stored] of [
      ['ALT_PROOF', kyc.altProofUrl],
      ['NOC', kyc.nocUrl],
    ] as const) {
      if (!stored) continue;
      const path = this.pathIn(stored);
      if (!path) continue;
      documents.push({
        kind,
        url: await this.storage.signDownload('kyc-documents', path),
      });
    }

    return {
      gymId: kyc.gymId,
      gym: kyc.gym,
      premises: kyc.premises,
      altProofType: kyc.altProofType,
      // Last four only, for the same reason it is last four everywhere else.
      aadhaarLast4: kyc.aadhaarLast4,
      panLast4: kyc.panLast4,
      gstinLast4: kyc.gstinLast4,
      aadhaarStatus: kyc.aadhaarStatus,
      panStatus: kyc.panStatus,
      gstStatus: kyc.gstStatus,
      nocStatus: kyc.nocStatus,
      rejectionReason: kyc.rejectionReason,
      verifiedAt: kyc.verifiedAt,
      documents,
      submittedAt: kyc.createdAt,
      updatedAt: kyc.updatedAt,
    };
  }

  async decide(admin: AdminContext, gymId: string, dto: KycDecisionDto) {
    const kyc = await this.prisma.gymKyc.findUnique({
      where: { gymId },
      select: {
        id: true,
        verifiedAt: true,
        gstStatus: true,
        nocStatus: true,
        aadhaarStatus: true,
        panStatus: true,
      },
    });
    if (!kyc) throw new NotFoundException('No submission for that gym');
    if (kyc.verifiedAt) {
      throw new BadRequestException('That gym is already verified');
    }

    const approving = dto.decision === 'APPROVE';
    const next = approving
      ? VerificationStatus.VERIFIED
      : VerificationStatus.REJECTED;

    // A document nobody submitted stays NOT_SUBMITTED. Marking an absent
    // GST as verified would read, later, as though one had been seen.
    const carry = (current: VerificationStatus) =>
      current === VerificationStatus.NOT_SUBMITTED ? current : next;

    const updated = await this.prisma.gymKyc.update({
      where: { gymId },
      data: {
        aadhaarStatus: carry(kyc.aadhaarStatus),
        panStatus: carry(kyc.panStatus),
        gstStatus: carry(kyc.gstStatus),
        nocStatus: carry(kyc.nocStatus),
        rejectionReason: approving ? null : dto.reason!,
        verifiedAt: approving ? new Date() : null,
        verifiedByAdminId: approving ? admin.adminId : null,
      },
      select: { id: true, verifiedAt: true, rejectionReason: true },
    });

    await this.audit.record({
      actorId: admin.userId,
      gymId,
      action: approving ? 'gym.kyc.approve' : 'gym.kyc.reject',
      entityType: 'GymKyc',
      entityId: kyc.id,
      after: {
        decision: dto.decision,
        // The reason is shown to the owner, so it is not a secret; keeping
        // it here is what makes a disputed rejection answerable later.
        reason: approving ? null : dto.reason,
        reviewer: admin.name,
      },
    });

    return {
      gymId,
      verifiedAt: updated.verifiedAt,
      rejectionReason: updated.rejectionReason,
    };
  }

  /**
   * The object path inside the bucket, taken from the stored URL.
   *
   * The URL was checked on the way in and can only be one of ours, but the
   * path is still pulled out by parsing rather than by trimming a prefix,
   * so a URL shaped slightly differently yields nothing instead of a
   * malformed path that gets signed anyway.
   */
  private pathIn(url: string): string | null {
    try {
      const { pathname } = new URL(url);
      const marker = '/kyc-documents/';
      const at = pathname.indexOf(marker);
      if (at < 0) return null;
      const path = pathname.slice(at + marker.length);
      return path.includes('..') || path === '' ? null : path;
    } catch {
      return null;
    }
  }
}
