import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Transform } from 'class-transformer';
import {
  IsBoolean,
  IsEmail,
  IsInt,
  IsOptional,
  IsString,
  IsUUID,
  Length,
  Matches,
  Max,
  MaxLength,
  Min,
} from 'class-validator';
import { IsStorageUrl } from '../../common/validation/storage-url';
import { IsCleanName } from '../../common/validation/clean-name';

const trim = () =>
  Transform(({ value }) => (typeof value === 'string' ? value.trim() : value));

export class LookupPersonDto {
  @ApiProperty({ example: '+919876543210' })
  @IsString()
  @trim()
  @MaxLength(20)
  phone!: string;
}

export class AddStaffDto {
  @ApiProperty({ description: 'From the lookup step' })
  @IsUUID()
  challengeId!: string;

  @ApiProperty()
  @IsString()
  @trim()
  @MaxLength(20)
  phone!: string;

  @ApiProperty({ example: '482913' })
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

  @ApiProperty({ description: 'Role to assign. Must be junior to your own.' })
  @IsUUID()
  roleId!: string;

  @ApiPropertyOptional({ default: false })
  @IsOptional()
  @IsBoolean()
  isTrainer?: boolean;

  @ApiPropertyOptional({ description: 'Required when isTrainer is true' })
  @IsOptional()
  @IsUUID()
  trainerCategoryId?: string;

  @ApiPropertyOptional({ default: false })
  @IsOptional()
  @IsBoolean()
  addressProofApproved?: boolean;

  @ApiPropertyOptional()
  @IsOptional()
  @IsStorageUrl()
  @MaxLength(500)
  addressProofUrl?: string;
}

export class UpdateStaffDto {
  @ApiPropertyOptional()
  @IsOptional()
  @IsUUID()
  roleId?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsBoolean()
  isTrainer?: boolean;

  @ApiPropertyOptional()
  @IsOptional()
  @IsUUID()
  trainerCategoryId?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsBoolean()
  addressProofApproved?: boolean;

  @ApiPropertyOptional()
  @IsOptional()
  @IsStorageUrl()
  @MaxLength(500)
  addressProofUrl?: string;
}
