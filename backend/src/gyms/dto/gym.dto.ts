import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Transform, Type } from 'class-transformer';
import {
  ArrayMaxSize,
  IsArray,
  IsInt,
  IsLatitude,
  IsLongitude,
  IsNumber,
  IsOptional,
  IsString,
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

export class CreateGymDto {
  @ApiProperty({ example: 'Iron Temple Fitness' })
  @IsString()
  @trim()
  @Length(2, 150)
  @IsCleanName()
  name!: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @MaxLength(4000)
  description?: string;

  @ApiProperty({ example: 'Plot 14, Sector 22' })
  @IsString()
  @trim()
  @Length(3, 200)
  addressLine1!: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @MaxLength(200)
  addressLine2?: string;

  @ApiProperty({ example: 'Haryana' })
  @IsString()
  @trim()
  @Length(2, 80)
  state!: string;

  @ApiProperty({ example: 'Gurugram' })
  @IsString()
  @trim()
  @Length(2, 80)
  district!: string;

  @ApiProperty({ example: 'Gurugram' })
  @IsString()
  @trim()
  @Length(2, 80)
  city!: string;

  @ApiProperty({ example: '122001' })
  @IsString()
  @Matches(/^\d{6}$/, { message: 'Enter a valid 6-digit PIN code' })
  pincode!: string;

  @ApiProperty({ example: '+919876543210' })
  @IsString()
  @trim()
  @MaxLength(20)
  contactPhone!: string;

  @ApiPropertyOptional({ description: 'Decimal degrees' })
  @IsOptional()
  @IsLatitude()
  latitude?: number;

  @ApiPropertyOptional()
  @IsOptional()
  @IsLongitude()
  longitude?: number;

  @ApiPropertyOptional({
    example: 4,
    description: 'Leave days a member may take per month before approval is needed',
  })
  @IsOptional()
  @IsInt()
  @Min(0)
  @Max(31)
  maxLeaveDaysPerMonth?: number;

  @ApiPropertyOptional({ example: 30 })
  @IsOptional()
  @IsInt()
  @Min(0)
  @Max(365)
  maxLeaveDaysPerMembership?: number;

  @ApiPropertyOptional({ type: [String], example: ['Steam room', 'Free parking'] })
  @IsOptional()
  @IsArray()
  @ArrayMaxSize(40)
  @IsString({ each: true })
  @MaxLength(120, { each: true })
  perks?: string[];

  @ApiPropertyOptional({ type: [String] })
  @IsOptional()
  @IsArray()
  @ArrayMaxSize(20)
  @IsStorageUrl({ each: true })
  @MaxLength(500, { each: true })
  imageUrls?: string[];
}

export class UpdateGymDto {
  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @trim()
  @Length(2, 150)
  @IsCleanName()
  name?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @MaxLength(4000)
  description?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @Length(3, 200)
  addressLine1?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @MaxLength(200)
  addressLine2?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @Length(2, 80)
  state?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @Length(2, 80)
  district?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @Length(2, 80)
  city?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @Matches(/^\d{6}$/, { message: 'Enter a valid 6-digit PIN code' })
  pincode?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @MaxLength(20)
  contactPhone?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsLatitude()
  latitude?: number;

  @ApiPropertyOptional()
  @IsOptional()
  @IsLongitude()
  longitude?: number;

  @ApiPropertyOptional()
  @IsOptional()
  @IsInt()
  @Min(0)
  @Max(31)
  maxLeaveDaysPerMonth?: number;

  @ApiPropertyOptional()
  @IsOptional()
  @IsInt()
  @Min(0)
  @Max(365)
  maxLeaveDaysPerMembership?: number;

  @ApiPropertyOptional({ type: [String] })
  @IsOptional()
  @IsArray()
  @ArrayMaxSize(40)
  @IsString({ each: true })
  @MaxLength(120, { each: true })
  perks?: string[];

  @ApiPropertyOptional({ type: [String] })
  @IsOptional()
  @IsArray()
  @ArrayMaxSize(20)
  @IsStorageUrl({ each: true })
  @MaxLength(500, { each: true })
  imageUrls?: string[];
}

/**
 * Gym search, as the member app's first page uses it.
 *
 * With coordinates, results are ranked by distance. Without — which is
 * what happens when someone declines location permission — they fall back
 * to a text match on locality, which is why `district` and `query` exist.
 */
export class SearchGymsDto {
  @ApiPropertyOptional({ description: 'Free text over gym name and city' })
  @IsOptional()
  @IsString()
  @trim()
  @MaxLength(120)
  query?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @MaxLength(80)
  state?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @MaxLength(80)
  district?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @Type(() => Number)
  @IsLatitude()
  latitude?: number;

  @ApiPropertyOptional()
  @IsOptional()
  @Type(() => Number)
  @IsLongitude()
  longitude?: number;

  @ApiPropertyOptional({ default: 20 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(50)
  limit?: number;

  @ApiPropertyOptional({ default: 0 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(0)
  offset?: number;
}

export class RateGymDto {
  @ApiProperty({ minimum: 1, maximum: 5 })
  @IsNumber()
  @IsInt()
  @Min(1)
  @Max(5)
  stars!: number;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @trim()
  @MaxLength(500)
  comment?: string;
}
