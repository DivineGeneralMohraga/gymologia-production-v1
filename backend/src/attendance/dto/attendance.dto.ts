import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { AttendanceStatus, SubjectType } from '@prisma/client';
import { Transform, Type } from 'class-transformer';
import {
  IsEnum, IsIn, IsISO8601, IsInt, IsOptional, IsString, IsUUID, Max, MaxLength, Min,
} from 'class-validator';
import { GROWTH_UNITS, type GrowthUnit } from '../attendance.service';

const trim = () =>
  Transform(({ value }) => (typeof value === 'string' ? value.trim() : value));

export class MarkAttendanceDto {
  @ApiProperty({ enum: SubjectType })
  @IsEnum(SubjectType)
  subjectType!: SubjectType;

  @ApiProperty({ description: 'Membership id or staff member id, or the user id' })
  @IsUUID()
  subjectId!: string;

  @ApiPropertyOptional({ description: 'Defaults to today. Future dates are refused.' })
  @IsOptional()
  @IsISO8601()
  date?: string;

  @ApiPropertyOptional({ enum: AttendanceStatus, default: AttendanceStatus.PRESENT })
  @IsOptional()
  @IsEnum(AttendanceStatus)
  status?: AttendanceStatus;
}

export class EditAttendanceDto {
  @ApiProperty({ enum: AttendanceStatus })
  @IsEnum(AttendanceStatus)
  status!: AttendanceStatus;

  @ApiProperty({
    description: 'Why it is being changed. Required — an unexplained edit is indistinguishable from tampering.',
  })
  @IsString()
  @trim()
  @MaxLength(300)
  reason!: string;
}

export class ListAttendanceDto {
  @ApiProperty({ enum: SubjectType })
  @IsEnum(SubjectType)
  subjectType!: SubjectType;

  @ApiPropertyOptional()
  @IsOptional()
  @IsUUID()
  subjectId?: string;

  @ApiPropertyOptional({ description: 'Defaults to today' })
  @IsOptional()
  @IsISO8601()
  from?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsISO8601()
  to?: string;
}

export class AttendanceWindowDto {
  @ApiPropertyOptional({ default: 60 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(365)
  days?: number;
}

export class GrowthQueryDto {
  @ApiPropertyOptional({ enum: GROWTH_UNITS, default: 'month' })
  @IsOptional()
  @IsIn(GROWTH_UNITS)
  unit?: GrowthUnit;

  @ApiPropertyOptional({
    default: 12,
    description: 'How many buckets to return, counting back from the current one.',
  })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(60)
  periods?: number;
}
