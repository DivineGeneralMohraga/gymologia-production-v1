import { Module } from '@nestjs/common';
import {
  GymNotificationsController,
  MyNotificationsController,
} from './notifications.controller';
import { NotificationsService } from './notifications.service';

@Module({
  controllers: [GymNotificationsController, MyNotificationsController],
  providers: [NotificationsService],
  exports: [NotificationsService],
})
export class NotificationsModule {}
