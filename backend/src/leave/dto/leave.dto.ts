import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { LeaveStatus, SubjectType } from '@prisma/client';
import { Transform } from 'class-transformer';
import { IsEnum, IsISO8601, IsIn, IsOptional, IsString, MaxLength } from 'class-validator';

const trim = () =>
  Transform(({ value }) => (typeof value === 'string' ? value.trim() : value));

export class RequestLeaveDto {
  @ApiProperty({ enum: SubjectType })
  @IsEnum(SubjectType)
  subjectType!: SubjectType;

  @ApiProperty({ example: '2026-09-01' })
  @IsISO8601()
  fromDate!: string;

  @ApiProperty({ example: '2026-09-05' })
  @IsISO8601()
  toDate!: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @trim()
  @MaxLength(500)
  reason?: string;
}

export class DecideLeaveDto {
  @ApiProperty({
    enum: [LeaveStatus.APPROVED, LeaveStatus.DECLINED],
    description: 'Reversing an earlier decision requires EDIT_LEAVE_DECISION and seniority over whoever decided.',
  })
  @IsIn([LeaveStatus.APPROVED, LeaveStatus.DECLINED])
  status!: typeof LeaveStatus.APPROVED | typeof LeaveStatus.DECLINED;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @trim()
  @MaxLength(300)
  note?: string;
}

export class ListLeaveDto {
  @ApiProperty({ enum: SubjectType })
  @IsEnum(SubjectType)
  subjectType!: SubjectType;

  @ApiPropertyOptional({ enum: LeaveStatus })
  @IsOptional()
  @IsEnum(LeaveStatus)
  status?: LeaveStatus;
}
