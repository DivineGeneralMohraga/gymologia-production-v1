import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Transform } from 'class-transformer';
import {
  IsIn,
  IsInt,
  IsOptional,
  Max,
  MaxLength,
  Min,
  MinLength,
  ValidateIf,
} from 'class-validator';

export class KycQueueDto {
  @ApiPropertyOptional({ default: 25 })
  @IsOptional()
  @Transform(({ value }) => Number(value))
  @IsInt()
  @Min(1)
  @Max(100)
  take?: number;

  @ApiPropertyOptional({ default: 0 })
  @IsOptional()
  @Transform(({ value }) => Number(value))
  @IsInt()
  @Min(0)
  skip?: number;
}

export class KycDecisionDto {
  @ApiProperty({ enum: ['APPROVE', 'REJECT'] })
  @IsIn(['APPROVE', 'REJECT'])
  decision!: 'APPROVE' | 'REJECT';

  /**
   * Required on a rejection, and long enough to say something useful. The
   * owner is shown this and has to be able to act on it -- "rejected" on
   * its own leaves them resubmitting the same documents.
   */
  @ApiPropertyOptional()
  @ValidateIf((o: KycDecisionDto) => o.decision === 'REJECT')
  @MinLength(10, {
    message: 'Say why, in enough words that the owner can fix it',
  })
  @MaxLength(500)
  reason?: string;
}
