import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Permission } from '@prisma/client';
import { Type } from 'class-transformer';
import {
  ArrayMaxSize,
  ArrayNotEmpty,
  IsArray,
  IsBoolean,
  IsEnum,
  IsInt,
  IsOptional,
  IsString,
  IsUUID,
  Length,
  Max,
  Min,
} from 'class-validator';

export class CreateRoleDto {
  @ApiProperty({ example: 'Front desk' })
  @IsString()
  @Length(2, 60)
  name!: string;

  @ApiPropertyOptional({
    minimum: 11,
    maximum: 999,
    description:
      'Rank, where a lower number is more senior. Must be below your own and below the default roles. Defaults to ten below the floor, leaving room to insert.',
  })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(999)
  level?: number;

  @ApiPropertyOptional({ enum: Permission, isArray: true })
  @IsOptional()
  @IsArray()
  @ArrayMaxSize(40)
  @IsEnum(Permission, { each: true })
  permissions?: Permission[];

  @ApiPropertyOptional({
    default: false,
    description: 'Whether people in this role are exempt from attendance.',
  })
  @IsOptional()
  @IsBoolean()
  exemptFromAttendance?: boolean;
}

export class UpdateRoleDto {
  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @Length(2, 60)
  name?: string;

  @ApiPropertyOptional({ minimum: 11, maximum: 999 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(999)
  level?: number;

  @ApiPropertyOptional({
    enum: Permission,
    isArray: true,
    description: 'The complete set this role should hold. Anything absent is removed.',
  })
  @IsOptional()
  @IsArray()
  @ArrayMaxSize(40)
  @IsEnum(Permission, { each: true })
  permissions?: Permission[];

  @ApiPropertyOptional()
  @IsOptional()
  @IsBoolean()
  exemptFromAttendance?: boolean;
}

export class ReorderRolesDto {
  @ApiProperty({
    type: [String],
    description: 'The roles being re-ranked, most senior first.',
  })
  @IsArray()
  @ArrayNotEmpty()
  @ArrayMaxSize(30)
  @IsUUID('4', { each: true })
  roleIds!: string[];
}
