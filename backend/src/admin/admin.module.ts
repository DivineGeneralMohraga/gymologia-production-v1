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
  // The verification desk lives in KycModule but sits behind the same
  // guard, so the guard has to be resolvable from there too.
  exports: [AdminGuard],
})
export class AdminModule {}
