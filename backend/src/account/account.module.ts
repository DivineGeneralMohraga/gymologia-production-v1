import { Module } from '@nestjs/common';
import { AccountDeletionController } from './account-deletion.controller';
import { AccountDeletionPageController } from './account-deletion-page.controller';
import { AccountDeletionService } from './account-deletion.service';

/**
 * Account deletion: the in-app route, the web page Play requires, and the
 * scheduled job that does the work once the grace period is up.
 *
 * Exported because MaintenanceService owns every cron in the product, and
 * scattering schedules across feature modules is how two of them end up
 * running the same work at different hours.
 */
@Module({
  controllers: [AccountDeletionController, AccountDeletionPageController],
  providers: [AccountDeletionService],
  exports: [AccountDeletionService],
})
export class AccountModule {}
