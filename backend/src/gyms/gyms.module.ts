import { Module } from '@nestjs/common';
import { GymsController } from './gyms.controller';
import { GymsService } from './gyms.service';
import { RankingService } from './ranking.service';

@Module({
  controllers: [GymsController],
  providers: [GymsService, RankingService],
  exports: [GymsService],
})
export class GymsModule {}
