import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { NotificationAudience } from '@prisma/client';
import { Transform } from 'class-transformer';
import {
  IsEnum,
  IsIn,
  IsOptional,
  IsString,
  Length,
  MaxLength,
} from 'class-validator';

const trim = () =>
  Transform(({ value }) => (typeof value === 'string' ? value.trim() : value));

/** The audiences a gym may address. The wider ones belong to the admin app. */
const GYM_AUDIENCES = [
  NotificationAudience.GYM_MEMBERS,
  NotificationAudience.GYM_STAFF,
  NotificationAudience.GYM_EVERYONE,
];

export class SendNotificationDto {
  @ApiProperty({ example: 'Closed on Sunday for maintenance' })
  @IsString()
  @trim()
  @Length(3, 150)
  title!: string;

  @ApiProperty({ example: 'The gym will reopen Monday at 6am. Sorry for the short notice.' })
  @IsString()
  @trim()
  @Length(3, 2000)
  body!: string;

  @ApiPropertyOptional({
    enum: GYM_AUDIENCES,
    default: NotificationAudience.GYM_EVERYONE,
    description: 'A gym can address its own members and staff, not the whole platform.',
  })
  @IsOptional()
  @IsEnum(NotificationAudience)
  @IsIn(GYM_AUDIENCES, {
    message: 'A gym can only notify its own members and staff.',
  })
  audience?: NotificationAudience;

  @ApiPropertyOptional({ description: 'Where tapping it should take the reader.' })
  @IsOptional()
  @IsString()
  @MaxLength(300)
  deepLink?: string;
}
