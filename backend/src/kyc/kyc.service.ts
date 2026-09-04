import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { PremisesOwnership, VerificationStatus } from '@prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { CryptoService } from '../common/crypto/crypto.service';
import { AuditService } from '../common/audit/audit.service';
import { panInGstin } from '../common/validation/india-ids';
import type { ActorContext } from '../rbac/permission.service';
import { SubmitKycDto } from './dto/kyc.dto';

/**
 * Gym verification: three document checks and, for a tenant, a letter from
 * the landlord.
 *
 * Numbers are encrypted at rest and only the last four characters are kept
 * in clear. Nothing here ever returns a full Aadhaar, PAN or GSTIN -- not
 * to the owner who submitted it, not to an admin. The clear-text exists for
 * exactly as long as it takes to encrypt it and hand it to the verification
 * provider.
 */
@Injectable()
export class KycService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly crypto: CryptoService,
    private readonly audit: AuditService,
  ) {}

  async submit(
    actor: ActorContext,
    dto: SubmitKycDto,
    meta: { ip?: string | null; userAgent?: string | null },
  ) {
    // A GSTIN carries the holder's PAN in characters 3-12. If it disagrees
    // with the PAN submitted alongside it, one of the two belongs to
    // somebody else, and finding that here beats finding it at the registry.
    if (dto.gstin && panInGstin(dto.gstin) !== dto.pan) {
      throw new BadRequestException(
        'The PAN inside that GSTIN does not match the PAN you entered',
      );
    }

    const existing = await this.prisma.gymKyc.findUnique({
      where: { gymId: actor.gymId },
      select: { id: true, verifiedAt: true },
    });

    // Re-submitting after verification would silently unverify a live gym.
    // Changing a verified record is an admin action, not a self-service one.
    if (existing?.verifiedAt) {
      throw new BadRequestException(
        'This gym is already verified. Contact support to change these details.',
      );
    }

    const data = {
      aadhaarEnc: this.crypto.encrypt(dto.aadhaar),
      aadhaarLast4: this.crypto.last4(dto.aadhaar),
      panEnc: this.crypto.encrypt(dto.pan),
      panLast4: this.crypto.last4(dto.pan),
      gstinEnc: dto.gstin ? this.crypto.encrypt(dto.gstin) : null,
      gstinLast4: dto.gstin ? this.crypto.last4(dto.gstin) : null,

      premises: dto.premises,
      nocUrl: dto.premises === PremisesOwnership.RENTED ? dto.nocUrl! : null,
      nocStatus:
        dto.premises === PremisesOwnership.RENTED
          ? VerificationStatus.PENDING
          : VerificationStatus.NOT_SUBMITTED,

      altProofType: dto.gstin ? null : dto.altProofType!,
      altProofUrl: dto.gstin ? null : dto.altProofUrl!,

      aadhaarStatus: VerificationStatus.PENDING,
      panStatus: VerificationStatus.PENDING,
      gstStatus: dto.gstin
        ? VerificationStatus.PENDING
        : VerificationStatus.NOT_SUBMITTED,

      // A resubmission after a rejection starts clean rather than carrying
      // the old reason around next to new documents.
      rejectionReason: null,
    };

    const saved = await this.prisma.gymKyc.upsert({
      where: { gymId: actor.gymId },
      create: { gymId: actor.gymId, ...data },
      update: data,
    });

    await this.audit.record({
      actorId: actor.userId,
      gymId: actor.gymId,
      action: existing ? 'gym.kyc.resubmit' : 'gym.kyc.submit',
      entityType: 'GymKyc',
      entityId: saved.id,
      // Deliberately no numbers, not even encrypted: the audit log is read
      // by more people than the KYC record is, and the redactor should not
      // be the only thing standing between them and an Aadhaar.
      after: {
        premises: dto.premises,
        hasGstin: Boolean(dto.gstin),
        altProofType: data.altProofType,
        nocProvided: Boolean(data.nocUrl),
      },
      ip: meta.ip,
      userAgent: meta.userAgent,
    });

    return this.shape(saved);
  }

  /** What the owner is shown: progress, never the numbers back. */
  async forGym(gymId: string) {
    const kyc = await this.prisma.gymKyc.findUnique({ where: { gymId } });
    if (!kyc) {
      return {
        submitted: false,
        aadhaarStatus: VerificationStatus.NOT_SUBMITTED,
        panStatus: VerificationStatus.NOT_SUBMITTED,
        gstStatus: VerificationStatus.NOT_SUBMITTED,
        nocStatus: VerificationStatus.NOT_SUBMITTED,
        premises: null,
        verifiedAt: null,
        rejectionReason: null,
      };
    }
    return this.shape(kyc);
  }

  private shape(kyc: {
    aadhaarLast4: string | null;
    panLast4: string | null;
    gstinLast4: string | null;
    aadhaarStatus: VerificationStatus;
    panStatus: VerificationStatus;
    gstStatus: VerificationStatus;
    nocStatus: VerificationStatus;
    premises: PremisesOwnership | null;
    altProofType: unknown;
    verifiedAt: Date | null;
    rejectionReason: string | null;
  }) {
    return {
      submitted: true,
      // Last four only. Enough for an owner to recognise which document they
      // sent, useless to anyone who intercepts the response.
      aadhaarLast4: kyc.aadhaarLast4,
      panLast4: kyc.panLast4,
      gstinLast4: kyc.gstinLast4,
      aadhaarStatus: kyc.aadhaarStatus,
      panStatus: kyc.panStatus,
      gstStatus: kyc.gstStatus,
      nocStatus: kyc.nocStatus,
      premises: kyc.premises,
      altProofType: kyc.altProofType,
      verifiedAt: kyc.verifiedAt,
      rejectionReason: kyc.rejectionReason,
    };
  }
}
