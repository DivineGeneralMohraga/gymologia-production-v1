import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { ContentType } from '@prisma/client';
import { Transform } from 'class-transformer';
import {
  ArrayMaxSize,
  ArrayMinSize,
  IsArray,
  IsEnum,
  IsISO8601,
  IsOptional,
  IsString,
  IsUUID,
  Length,
} from 'class-validator';

const trim = () =>
  Transform(({ value }) => (typeof value === 'string' ? value.trim() : value));

export class SendMessageDto {
  @ApiProperty({ example: 'Are we open on Sunday?' })
  @IsString()
  @trim()
  @Length(1, 4000)
  body!: string;

  @ApiPropertyOptional({ enum: ContentType, default: ContentType.TEXT })
  @IsOptional()
  @IsEnum(ContentType)
  contentType?: ContentType;
}

export class OpenDirectDto {
  @ApiProperty({ description: 'Who to talk to. Must be at the same gym.' })
  @IsUUID()
  userId!: string;
}

export class CreateGroupDto {
  @ApiProperty({ example: 'Saturday morning crew' })
  @IsString()
  @trim()
  @Length(2, 120)
  name!: string;

  @ApiProperty({
    type: [String],
    description: 'Everyone to add. You are included automatically.',
  })
  @IsArray()
  @ArrayMinSize(1)
  @ArrayMaxSize(200)
  @IsUUID(undefined, { each: true })
  userIds!: string[];
}

export class MessageHistoryDto {
  @ApiPropertyOptional({
    description: 'Fetch messages older than this timestamp, for paging back.',
  })
  @IsOptional()
  @IsISO8601()
  before?: string;
}
