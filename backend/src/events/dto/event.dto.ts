import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { EventStatus } from '@prisma/client';
import { Transform, Type } from 'class-transformer';
import {
  IsBoolean,
  IsEnum,
  IsISO8601,
  IsInt,
  IsOptional,
  IsString,
  Length,
  Max,
  MaxLength,
  Min,
} from 'class-validator';
import { IsStorageUrl } from '../../common/validation/storage-url';
import { IsCleanName, IsCleanText } from '../../common/validation/clean-name';

const trim = () =>
  Transform(({ value }) => (typeof value === 'string' ? value.trim() : value));

export class CreateEventDto {
  @ApiProperty({ example: 'Summer Deadlift Meet' })
  @IsString()
  @trim()
  @Length(3, 150)
  @IsCleanName()
  title!: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsStorageUrl()
  @MaxLength(500)
  bannerUrl?: string;

  @ApiProperty()
  @IsString()
  @trim()
  @Length(10, 4000)
  @IsCleanText()
  description!: string;

  @ApiProperty({ description: 'What someone has to do to take part.' })
  @IsString()
  @trim()
  @Length(5, 2000)
  @IsCleanText()
  howToParticipate!: string;

  @ApiPropertyOptional({ example: 'Rs 10,000 and a year of free membership' })
  @IsOptional()
  @IsString()
  @trim()
  @MaxLength(200)
  @IsCleanText()
  prize?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @trim()
  @MaxLength(2000)
  @IsCleanText()
  prizeDescription?: string;

  @ApiProperty({ example: '2026-09-20' })
  @IsISO8601()
  registrationLastDate!: string;

  @ApiProperty({ example: '2026-09-25T09:00:00Z' })
  @IsISO8601()
  startsAt!: string;

  @ApiProperty({ example: '2026-09-25T17:00:00Z' })
  @IsISO8601()
  endsAt!: string;

  @ApiPropertyOptional({
    default: true,
    description:
      'When false, members see the requirements as emphasised text instead of a sign-up button.',
  })
  @IsOptional()
  @IsBoolean()
  membersCanParticipate?: boolean;

  @ApiPropertyOptional({
    default: true,
    description:
      'Pro plan only. Kept off for Basic gyms, with a note in the response rather than an error.',
  })
  @IsOptional()
  @IsBoolean()
  publicListing?: boolean;

  @ApiPropertyOptional({ default: false })
  @IsOptional()
  @IsBoolean()
  allowNonMembers?: boolean;
}

/**
 * What an event manager may change after announcing it.
 *
 * startsAt is deliberately absent: people plan around a start time, and
 * moving it quietly is how someone turns up to an empty gym.
 */
export class UpdateEventDto {
  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @trim()
  @Length(3, 150)
  @IsCleanName()
  title?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsStorageUrl()
  @MaxLength(500)
  bannerUrl?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @trim()
  @Length(10, 4000)
  @IsCleanText()
  description?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @trim()
  @Length(5, 2000)
  @IsCleanText()
  howToParticipate?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @trim()
  @MaxLength(200)
  @IsCleanText()
  prize?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @trim()
  @MaxLength(2000)
  @IsCleanText()
  prizeDescription?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsISO8601()
  registrationLastDate?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsISO8601()
  endsAt?: string;

  @ApiPropertyOptional({ enum: EventStatus })
  @IsOptional()
  @IsEnum(EventStatus)
  status?: EventStatus;
}

export class ListEventsDto {
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

  @ApiPropertyOptional({ default: 50 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(100)
  limit?: number;
}
