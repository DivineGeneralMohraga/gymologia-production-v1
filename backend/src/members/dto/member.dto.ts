import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Transform, Type } from 'class-transformer';
import { MembershipStatus } from '@prisma/client';
import {
  IsBoolean,
  IsEmail,
  IsEnum,
  IsInt,
  IsISO8601,
  IsOptional,
  IsString,
  IsUUID,
  Length,
  Matches,
  Max,
  MaxLength,
  Min,
} from 'class-validator';
import { IsCleanName } from '../../common/validation/clean-name';

const trim = () =>
  Transform(({ value }) => (typeof value === 'string' ? value.trim() : value));

export class AddMemberDto {
  @ApiProperty({ description: 'From the lookup step' })
  @IsUUID()
  challengeId!: string;

  @ApiProperty()
  @IsString()
  @trim()
  @MaxLength(20)
  phone!: string;

  @ApiProperty()
  @IsString()
  @Matches(/^\d{4,8}$/, { message: 'Verification code must be 4-8 digits' })
  code!: string;

  @ApiPropertyOptional({ description: 'Required only when the number is new to Gymologia' })
  @IsOptional()
  @IsString()
  @trim()
  @Length(2, 120)
  @IsCleanName()
  name?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsEmail()
  @MaxLength(255)
  email?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsInt()
  @Min(13)
  @Max(100)
  age?: number;

  @ApiProperty({ example: 3, description: 'Subscription length in months' })
  @IsInt()
  @Min(1)
  @Max(60)
  planMonths!: number;

  @ApiPropertyOptional({ description: 'Defaults to today' })
  @IsOptional()
  @IsISO8601()
  startsAt?: string;

  @ApiProperty({
    example: 4,
    description: 'Leave days allowed on this membership. Set by staff, not the member.',
  })
  @IsInt()
  @Min(0)
  @Max(365)
  maxLeaveDays!: number;

  @ApiPropertyOptional({ description: 'Staff member id of the assigned trainer' })
  @IsOptional()
  @IsUUID()
  assignedTrainerId?: string;

  @ApiPropertyOptional({
    example: 'Bulk up, target 78kg',
    description: 'What the member wants out of the gym.',
  })
  @IsOptional()
  @IsString()
  @trim()
  @MaxLength(300)
  goal?: string;

  @ApiPropertyOptional({
    default: false,
    description:
      'Whether staff and the assigned trainer may see this member’s weight and height history. ' +
      'Unchecked by default — DPDP Act s.6 requires the member’s own affirmative consent, not staff setting it on their behalf.',
  })
  @IsOptional()
  @IsBoolean()
  allowProgressMonitoring?: boolean;

  @ApiPropertyOptional({ default: false })
  @IsOptional()
  @IsBoolean()
  addressProofApproved?: boolean;

  @ApiPropertyOptional({
    default: false,
    description:
      'Required (must be true) when the member being added is under 18: confirms a parent or ' +
      'guardian has verified consent (DPDP Act 2023 s.9). Ignored for adult members.',
  })
  @IsOptional()
  @IsBoolean()
  guardianConsentConfirmed?: boolean;
}

export class UpdateMemberDto {
  @ApiPropertyOptional()
  @IsOptional()
  @IsUUID()
  assignedTrainerId?: string | null;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @trim()
  @MaxLength(300)
  goal?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsInt()
  @Min(0)
  @Max(365)
  maxLeaveDays?: number;

  @ApiPropertyOptional()
  @IsOptional()
  @IsBoolean()
  addressProofApproved?: boolean;
}

export class ExtendMembershipDto {
  @ApiProperty({ example: 3, description: 'Months to add to the current end date' })
  @IsInt()
  @Min(1)
  @Max(60)
  months!: number;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @trim()
  @MaxLength(300)
  note?: string;
}

/** A member allowing, or refusing, staff access to their progress. */
export class MonitoringConsentDto {
  @ApiProperty()
  @IsBoolean()
  allow!: boolean;
}

export class ListMembersDto {
  @ApiPropertyOptional({ enum: MembershipStatus })
  @IsOptional()
  @IsEnum(MembershipStatus)
  status?: MembershipStatus;

  @ApiPropertyOptional({ description: 'Search by member name or phone' })
  @IsOptional()
  @IsString()
  @trim()
  @MaxLength(120)
  query?: string;

  @ApiPropertyOptional({ default: 50 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(200)
  limit?: number;

  @ApiPropertyOptional({ default: 0 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(0)
  offset?: number;
}

/** The monthly weight and height check-in, submitted by the member. */
export class RecordMetricDto {
  @ApiPropertyOptional({ example: 74.5 })
  @IsOptional()
  @Type(() => Number)
  @Min(20)
  @Max(400)
  weightKg?: number;

  @ApiPropertyOptional({ example: 176 })
  @IsOptional()
  @Type(() => Number)
  @Min(80)
  @Max(260)
  heightCm?: number;
}
