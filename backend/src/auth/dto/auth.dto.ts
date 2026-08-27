import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { AppClient } from '@prisma/client';
import { Transform } from 'class-transformer';
import {
  IsEmail,
  IsEnum,
  IsInt,
  IsOptional,
  IsString,
  Length,
  Matches,
  Max,
  MaxLength,
  Min,
} from 'class-validator';

/**
 * Every field that reaches a controller passes through one of these.
 * `forbidNonWhitelisted` in the global ValidationPipe means an unexpected
 * property is a 400, not a silently ignored extra — so a client cannot
 * smuggle `role` or `isVerified` into a create call.
 */

const trim = () => Transform(({ value }) => (typeof value === 'string' ? value.trim() : value));

export class RequestOtpDto {
  @ApiProperty({ example: '+918178848820', description: 'E.164, or a 10-digit Indian number' })
  @IsString()
  @trim()
  @MaxLength(20)
  phone!: string;

  @ApiProperty({ enum: AppClient, example: AppClient.MEMBER })
  @IsEnum(AppClient)
  appClient!: AppClient;
}

export class VerifyOtpDto {
  @ApiProperty({ format: 'uuid' })
  @IsString()
  @Length(36, 36)
  challengeId!: string;

  @ApiProperty({ example: '+918178848820' })
  @IsString()
  @trim()
  @MaxLength(20)
  phone!: string;

  @ApiProperty({ example: '482913' })
  @IsString()
  @Matches(/^\d{4,8}$/, { message: 'Verification code must be 4-8 digits' })
  code!: string;

  @ApiProperty({ enum: AppClient })
  @IsEnum(AppClient)
  appClient!: AppClient;

  @ApiPropertyOptional({ description: 'Stable per-install identifier' })
  @IsOptional()
  @IsString()
  @MaxLength(128)
  deviceId?: string;
}

export class RegisterDto {
  @ApiProperty({ description: 'Issued by /auth/otp/verify when the number is new' })
  @IsString()
  @MaxLength(2000)
  registrationToken!: string;

  @ApiProperty({ example: 'Sarthak' })
  @IsString()
  @trim()
  @Length(2, 120)
  name!: string;

  @ApiPropertyOptional({ example: 'sarthak@example.com' })
  @IsOptional()
  @IsEmail({}, { message: 'Enter a valid email address' })
  @MaxLength(255)
  email?: string;

  /**
   * Age, deliberately not date of birth. A DOB is a key into someone's
   * bank and government records; an age band is all a gym app needs.
   */
  @ApiProperty({ example: 24, minimum: 13, maximum: 100 })
  @IsInt()
  @Min(13, { message: 'You must be at least 13 to use Gymologia' })
  @Max(100)
  age!: number;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @MaxLength(128)
  deviceId?: string;

  @ApiPropertyOptional({ example: 'en' })
  @IsOptional()
  @IsString()
  @MaxLength(10)
  locale?: string;
}

export class RefreshDto {
  @ApiProperty()
  @IsString()
  @MaxLength(500)
  refreshToken!: string;
}

export class VerifyWidgetTokenDto {
  @ApiProperty({ description: 'access-token returned by the MSG91 OTP widget' })
  @IsString()
  @MaxLength(4000)
  accessToken!: string;

  @ApiProperty({ enum: AppClient })
  @IsEnum(AppClient)
  appClient!: AppClient;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @MaxLength(128)
  deviceId?: string;
}
