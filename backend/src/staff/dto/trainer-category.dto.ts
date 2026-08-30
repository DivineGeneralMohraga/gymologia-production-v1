import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  ArrayMaxSize,
  ArrayNotEmpty,
  IsArray,
  IsBoolean,
  IsInt,
  IsOptional,
  IsString,
  IsUUID,
  Length,
  Max,
  Min,
} from 'class-validator';

export class CreateTrainerCategoryDto {
  @ApiProperty({ example: 'Rehab' })
  @IsString()
  @Length(2, 60)
  name!: string;

  @ApiPropertyOptional({
    default: true,
    description:
      'False means one trainer in this category holds one member at a time — the usual setting for personal training.',
  })
  @IsOptional()
  @IsBoolean()
  allowsMultipleMembers?: boolean;

  @ApiPropertyOptional({ minimum: 0, maximum: 100 })
  @IsOptional()
  @IsInt()
  @Min(0)
  @Max(100)
  sortOrder?: number;
}

export class UpdateTrainerCategoryDto {
  @ApiPropertyOptional({ example: 'Personal' })
  @IsOptional()
  @IsString()
  @Length(2, 60)
  name?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsBoolean()
  allowsMultipleMembers?: boolean;

  @ApiPropertyOptional({ minimum: 0, maximum: 100 })
  @IsOptional()
  @IsInt()
  @Min(0)
  @Max(100)
  sortOrder?: number;
}

export class ReorderTrainerCategoriesDto {
  @ApiProperty({
    type: [String],
    description: 'Every category id for this gym, in the order they should appear.',
  })
  @IsArray()
  @ArrayNotEmpty()
  @ArrayMaxSize(25)
  @IsUUID('4', { each: true })
  categoryIds!: string[];
}
