import { Module } from '@nestjs/common';
import { AdminController } from './admin.controller';
import { AdminService } from './admin.service';
import { AdminGuard } from './admin.guard';
import { PeopleModule } from '../people/people.module';
import { NotificationsModule } from '../notifications/notifications.module';

@Module({
  imports: [PeopleModule, NotificationsModule],
  controllers: [AdminController],
  providers: [AdminService, AdminGuard],
})
export class AdminModule {}
