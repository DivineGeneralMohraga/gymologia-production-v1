import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { ReportCategory, ReportStatus } from '@prisma/client';
import { Transform } from 'class-transformer';
import {
  IsEnum,
  IsInt,
  IsOptional,
  IsString,
  IsUUID,
  Length,
  Max,
  Min,
} from 'class-validator';

const trim = () =>
  Transform(({ value }) => (typeof value === 'string' ? value.trim() : value));

export class BlockUserDto {
  @ApiProperty({ description: 'Who to block.' })
  @IsUUID()
  userId!: string;

  @ApiPropertyOptional({
    description:
      'A private note to yourself about why. Nobody else ever sees it, including the person blocked.',
    example: 'Kept messaging after I asked them to stop',
  })
  @IsOptional()
  @IsString()
  @trim()
  @Length(1, 200)
  reason?: string;
}

export class CreateReportDto {
  @ApiProperty({ description: 'Who is being reported.' })
  @IsUUID()
  reportedUserId!: string;

  @ApiProperty({ enum: ReportCategory })
  @IsEnum(ReportCategory)
  category!: ReportCategory;

  @ApiProperty({
    description:
      'What happened, in the reporter’s own words. Required, and not optional padding: the review desk does not surface message bodies, so this is the only account of the content a reviewer sees.',
    minLength: 10,
    maxLength: 2000,
  })
  @IsString()
  @trim()
  @Length(10, 2000)
  details!: string;

  @ApiPropertyOptional({
    description: 'The specific message, when the report is about one.',
  })
  @IsOptional()
  @IsUUID()
  messageId?: string;

  @ApiPropertyOptional({ description: 'Where it happened.' })
  @IsOptional()
  @IsUUID()
  conversationId?: string;

  @ApiPropertyOptional({ description: 'Which gym this is at.' })
  @IsOptional()
  @IsUUID()
  gymId?: string;
}

// ── Admin side ────────────────────────────────────────────────────────

export class ListReportsDto {
  @ApiPropertyOptional({ enum: ReportStatus })
  @IsOptional()
  @IsEnum(ReportStatus)
  status?: ReportStatus;

  @ApiPropertyOptional({ enum: ReportCategory })
  @IsOptional()
  @IsEnum(ReportCategory)
  category?: ReportCategory;

  @ApiPropertyOptional({ default: 1 })
  @IsOptional()
  @Transform(({ value }) => Number(value))
  @IsInt()
  @Min(1)
  page?: number;

  @ApiPropertyOptional({ default: 25 })
  @IsOptional()
  @Transform(({ value }) => Number(value))
  @IsInt()
  @Min(1)
  @Max(100)
  pageSize?: number;
}

export class ResolveReportDto {
  @ApiProperty({
    enum: [ReportStatus.REVIEWING, ReportStatus.ACTIONED, ReportStatus.DISMISSED],
    description: 'OPEN is not a destination — a report starts there.',
  })
  @IsEnum(ReportStatus)
  status!: ReportStatus;

  @ApiProperty({
    description:
      'What was actually done, for the person who reads this report next. "Warned by phone", "no action, mutual argument", "account suspended".',
    minLength: 3,
    maxLength: 500,
  })
  @IsString()
  @trim()
  @Length(3, 500)
  actionTaken!: string;
}
