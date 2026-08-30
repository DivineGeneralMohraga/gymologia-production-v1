import { ApiPropertyOptional } from '@nestjs/swagger';
import {
  Difficulty,
  Discipline,
  MuscleGroup,
  TrainingGoal,
} from '@prisma/client';
import { Transform } from 'class-transformer';
import { IsEnum, IsOptional, IsString, MaxLength } from 'class-validator';

export class ListExercisesDto {
  @ApiPropertyOptional({ enum: Discipline })
  @IsOptional()
  @IsEnum(Discipline)
  discipline?: Discipline;

  @ApiPropertyOptional({ enum: MuscleGroup })
  @IsOptional()
  @IsEnum(MuscleGroup)
  muscle?: MuscleGroup;

  @ApiPropertyOptional({
    enum: TrainingGoal,
    description: 'Matches the reason a member joined, so the directory can be filtered to it.',
  })
  @IsOptional()
  @IsEnum(TrainingGoal)
  goal?: TrainingGoal;

  @ApiPropertyOptional({ enum: Difficulty })
  @IsOptional()
  @IsEnum(Difficulty)
  difficulty?: Difficulty;

  @ApiPropertyOptional({ description: 'Search by name' })
  @IsOptional()
  @IsString()
  @Transform(({ value }) => (typeof value === 'string' ? value.trim() : value))
  @MaxLength(80)
  query?: string;
}
