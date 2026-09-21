import { Module } from '@nestjs/common';
import { GymsController } from './gyms.controller';
import { GymsService } from './gyms.service';
import { RankingService } from './ranking.service';
import { NotificationsModule } from '../notifications/notifications.module';

@Module({
  imports: [NotificationsModule],
  controllers: [GymsController],
  providers: [GymsService, RankingService],
  exports: [GymsService],
})
export class GymsModule {}
