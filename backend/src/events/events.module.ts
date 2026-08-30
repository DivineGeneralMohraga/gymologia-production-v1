import { Module } from '@nestjs/common';
import { EventsFeedController, GymEventsController } from './events.controller';
import { EventsService } from './events.service';

@Module({
  controllers: [GymEventsController, EventsFeedController],
  providers: [EventsService],
  exports: [EventsService],
})
export class EventsModule {}
