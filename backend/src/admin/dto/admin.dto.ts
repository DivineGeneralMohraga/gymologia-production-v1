import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  AdminRole,
  AppClient,
  Severity,
  StaffStatus,
  TicketPriority,
  TicketStatus,
} from '@prisma/client';
import { Transform, Type } from 'class-transformer';
import {
  IsEmail,
  IsEnum,
  IsISO8601,
  IsInt,
  IsOptional,
  IsString,
  IsUUID,
  Length,
  Max,
  MaxLength,
  Min,
} from 'class-validator';

const trim = () =>
  Transform(({ value }) => (typeof value === 'string' ? value.trim() : value));

export class AdminLookupDto {
  @ApiProperty({ example: '+919876543210' })
  @IsString()
  @Length(10, 16)
  phone!: string;
}

export class AddAdminStaffDto {
  @ApiProperty()
  @IsUUID()
  challengeId!: string;

  @ApiProperty()
  @IsString()
  @Length(10, 16)
  phone!: string;

  @ApiProperty({ example: '123456' })
  @IsString()
  @Length(4, 8)
  code!: string;

  @ApiProperty({ enum: AdminRole })
  @IsEnum(AdminRole)
  role!: AdminRole;

  @ApiPropertyOptional()
  @IsOptional()
  @trim()
  @IsEmail()
  @MaxLength(255)
  workEmail?: string;

  @ApiPropertyOptional({
    description:
      'Internal HR record. This is the one place a date of birth is stored, and it is an employment record, not a consumer one.',
  })
  @IsOptional()
  @IsISO8601()
  dateOfBirth?: string;
}

/** Ban or unban an app account. The reason goes to the audit log. */
export class AccountStatusDto {
  @ApiProperty({ example: 'Abusive messages to gym staff' })
  @trim()
  @IsString()
  @Length(5, 300)
  reason!: string;
}

export class UpdateAdminStaffDto {
  @ApiPropertyOptional({ enum: AdminRole })
  @IsOptional()
  @IsEnum(AdminRole)
  role?: AdminRole;

  @ApiPropertyOptional({ enum: StaffStatus })
  @IsOptional()
  @IsEnum(StaffStatus)
  status?: StaffStatus;

  @ApiPropertyOptional()
  @IsOptional()
  @trim()
  @IsEmail()
  @MaxLength(255)
  workEmail?: string;
}

export class ListTicketsDto {
  @ApiPropertyOptional({ enum: TicketStatus })
  @IsOptional()
  @IsEnum(TicketStatus)
  status?: TicketStatus;

  @ApiPropertyOptional({ enum: TicketPriority })
  @IsOptional()
  @IsEnum(TicketPriority)
  priority?: TicketPriority;

  @ApiPropertyOptional({ enum: AppClient })
  @IsOptional()
  @IsEnum(AppClient)
  appClient?: AppClient;

  @ApiPropertyOptional({ default: 50, maximum: 200 })
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

export class ResolveTicketDto {
  @ApiProperty({ description: 'What was done. Shown to nobody but the team.' })
  @IsString()
  @Length(3, 2000)
  note!: string;
}

export class ListLogsDto {
  @ApiPropertyOptional({ description: 'Substring match on the action name.' })
  @IsOptional()
  @trim()
  @IsString()
  @MaxLength(80)
  action?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsUUID()
  gymId?: string;

  @ApiPropertyOptional({ enum: Severity })
  @IsOptional()
  @IsEnum(Severity)
  severity?: Severity;

  @ApiPropertyOptional({ default: 50, maximum: 200 })
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
