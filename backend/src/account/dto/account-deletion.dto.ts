import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsIn, IsOptional } from 'class-validator';

export class RequestDeletionDto {
  @ApiPropertyOptional({
    enum: ['APP', 'WEB'],
    default: 'APP',
    description:
      'Which route the request came from. Play requires the web one to exist; knowing which people actually use decides which is worth improving.',
  })
  @IsOptional()
  @IsIn(['APP', 'WEB'])
  via?: 'APP' | 'WEB';
}
