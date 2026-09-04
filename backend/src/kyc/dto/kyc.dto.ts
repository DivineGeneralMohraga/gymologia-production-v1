import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { AltProofType, PremisesOwnership } from '@prisma/client';
import { Transform } from 'class-transformer';
import { IsEnum, IsOptional, MaxLength, ValidateIf } from 'class-validator';
import {
  IsAadhaar,
  IsGstin,
  IsPan,
} from '../../common/validation/india-ids';
import { IsStorageUrl } from '../../common/validation/storage-url';

const upper = () =>
  Transform(({ value }) =>
    typeof value === 'string' ? value.trim().toUpperCase() : value,
  );

const digits = () =>
  Transform(({ value }) =>
    typeof value === 'string' ? value.replace(/[\s-]/g, '') : value,
  );

/**
 * What a gym owner submits for verification.
 *
 * The conditional rules are the interesting part, and they are enforced
 * here rather than left to the reviewer to notice:
 *
 *   - no GST means some other proof the premises trade legitimately;
 *   - rented premises mean a letter from the landlord, because otherwise a
 *     tenant could register an address they have no permission to use.
 *
 * Every URL must already be in our own storage, which is what
 * `POST /gyms/:gymId/uploads/sign` hands out. A URL from anywhere else is
 * refused: these are documents a reviewer opens.
 */
export class SubmitKycDto {
  @ApiProperty({ example: '234567890123' })
  @digits()
  @IsAadhaar()
  aadhaar!: string;

  @ApiProperty({ example: 'ABCDE1234F' })
  @upper()
  @IsPan()
  pan!: string;

  @ApiPropertyOptional({ example: '27ABCDE1234F1Z5' })
  @IsOptional()
  @upper()
  @IsGstin()
  gstin?: string;

  @ApiProperty({ enum: PremisesOwnership })
  @IsEnum(PremisesOwnership)
  premises!: PremisesOwnership;

  /** Required when there is no GST registration to stand on. */
  @ApiPropertyOptional({ enum: AltProofType })
  @ValidateIf((o: SubmitKycDto) => !o.gstin)
  @IsEnum(AltProofType, {
    message: 'altProofType is required when you have no GST registration',
  })
  altProofType?: AltProofType;

  @ApiPropertyOptional()
  @ValidateIf((o: SubmitKycDto) => !o.gstin)
  @IsStorageUrl({
    message: 'altProofUrl is required when you have no GST registration',
  })
  @MaxLength(500)
  altProofUrl?: string;

  /** Required when the premises are rented. */
  @ApiPropertyOptional()
  @ValidateIf((o: SubmitKycDto) => o.premises === PremisesOwnership.RENTED)
  @IsStorageUrl({
    message: 'nocUrl is required when the premises are rented',
  })
  @MaxLength(500)
  nocUrl?: string;
}
