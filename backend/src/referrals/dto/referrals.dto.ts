import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Transform, Type } from 'class-transformer';
import {
  IsInt,
  IsOptional,
  IsString,
  Matches,
  Max,
  MaxLength,
  Min,
  MinLength,
} from 'class-validator';

import { IsPan } from '../../common/validation/india-ids';
import { IsUpiVpa, normaliseVpa } from '../../common/validation/upi-vpa';

/**
 * Where a referrer's money should go.
 *
 * The holder name is not decoration and it is not optional. The ₹10
 * verification drop that runs before the first payout comes back with the
 * name the bank has registered against that address -- and a name from the
 * bank is only useful if there is a claimed name to compare it against.
 * Without one, the drop would confirm that the address exists, which is not
 * the question. The question is whether it is yours.
 */
export class SetPayoutMethodDto {
  @ApiProperty({ example: 'sarthak@okhdfcbank' })
  @Transform(({ value }) =>
    typeof value === 'string' ? normaliseVpa(value) : value,
  )
  @IsUpiVpa()
  upiId!: string;

  @ApiProperty({ example: 'Sarthak Sharma' })
  @Transform(({ value }) =>
    typeof value === 'string' ? value.trim().replace(/\s+/g, ' ') : value,
  )
  @IsString()
  @MinLength(2)
  @MaxLength(120)
  @Matches(/^[\p{L}][\p{L}\s.'-]*$/u, {
    message: 'holderName must be the name on the bank account',
  })
  holderName!: string;
}

/**
 * PAN, for tax withholding.
 *
 * Collected separately from the UPI ID rather than in one form, because
 * they are needed at different moments: an address is wanted the first time
 * somebody wants paying, a PAN only once their earnings for the year
 * approach the threshold where TDS has to be withheld. Asking for a tax
 * number up front, from somebody who has earned ₹50, is how a signup gets
 * abandoned.
 */
export class SetPanDto {
  @ApiProperty({ example: 'ABCDE1234F' })
  @Transform(({ value }) =>
    typeof value === 'string' ? value.trim().toUpperCase() : value,
  )
  @IsPan()
  pan!: string;
}

/**
 * How many reward rows to return.
 *
 * `@Type(() => Number)` is not decoration: the global pipe runs with
 * `enableImplicitConversion: false`, so without it `?limit=20` arrives as
 * the string "20", fails `@IsInt`, and the screen shows a validation error
 * for a parameter the user never typed.
 */
export class EarningsQueryDto {
  @ApiPropertyOptional({ minimum: 1, maximum: 100, default: 50 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(100)
  limit?: number;
}
