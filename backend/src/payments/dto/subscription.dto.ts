import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Plan } from '@prisma/client';
import { Transform } from 'class-transformer';
import { IsEnum, IsOptional, IsString, Length } from 'class-validator';

export class CheckoutDto {
  @ApiProperty({ enum: Plan })
  @IsEnum(Plan)
  plan!: Plan;

  @ApiPropertyOptional({
    description: 'A referral code from the Gymologia Referral app.',
    example: 'K7MPQR29',
  })
  @IsOptional()
  @IsString()
  @Transform(({ value }) =>
    typeof value === 'string' ? value.trim().toUpperCase() : value)
  @Length(4, 20)
  referralCode?: string;
}

export class QuoteDto {
  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @Transform(({ value }) =>
    typeof value === 'string' ? value.trim().toUpperCase() : value)
  @Length(4, 20)
  referralCode?: string;
}
