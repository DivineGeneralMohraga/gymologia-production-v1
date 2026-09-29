import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Transform } from 'class-transformer';
import {
  IsBoolean,
  IsEmail,
  IsInt,
  IsOptional,
  IsString,
  Length,
  Matches,
  Max,
  MaxLength,
  Min,
} from 'class-validator';
import { IsCleanName } from '../../common/validation/clean-name';

const trim = () =>
  Transform(({ value }) => (typeof value === 'string' ? value.trim() : value));

export class CreateTicketDto {
  @ApiProperty({ example: 'My membership days look wrong' })
  @IsString()
  @trim()
  @Length(3, 200)
  subject!: string;

  @ApiProperty()
  @IsString()
  @trim()
  @Length(10, 4000)
  message!: string;

  @ApiProperty({ description: 'Where support should reply.' })
  @IsString()
  @trim()
  @MaxLength(20)
  contactPhone!: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsEmail()
  @MaxLength(255)
  contactEmail?: string;

  @ApiPropertyOptional({
    default: false,
    description: 'Raises the priority. Meant for things blocking a gym from operating.',
  })
  @IsOptional()
  @IsBoolean()
  urgent?: boolean;
}

/**
 * What a person may change about themselves.
 *
 * Phone is deliberately not here — see the note on the controller.
 */
export class UpdateProfileDto {
  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @trim()
  @Length(2, 120)
  @IsCleanName()
  name?: string;

  @ApiPropertyOptional({ description: 'Send an empty string to remove it.' })
  @IsOptional()
  @IsString()
  @trim()
  @MaxLength(255)
  @Matches(/^$|^[^@\s]+@[^@\s]+\.[^@\s]+$/, {
    message: 'Enter a valid email address, or an empty value to remove it',
  })
  email?: string;

  @ApiPropertyOptional({ minimum: 13, maximum: 100 })
  @IsOptional()
  @IsInt()
  @Min(13)
  @Max(100)
  age?: number;

  @ApiPropertyOptional({ example: 'hi' })
  @IsOptional()
  @IsString()
  @MaxLength(10)
  locale?: string;
}
