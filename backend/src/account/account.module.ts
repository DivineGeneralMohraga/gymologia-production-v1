import { Module } from '@nestjs/common';
import { AccountDeletionController } from './account-deletion.controller';
import { AccountDeletionPageController } from './account-deletion-page.controller';
import { AccountDeletionService } from './account-deletion.service';
import { AccountExportController } from './account-export.controller';
import { AccountExportService } from './account-export.service';

/**
 * Account deletion and data export.
 *
 * Exported because MaintenanceService owns every cron in the product, and
 * scattering schedules across feature modules is how two of them end up
 * running the same work at different hours.
 */
@Module({
  controllers: [
    AccountDeletionController,
    AccountDeletionPageController,
    AccountExportController,
  ],
  providers: [AccountDeletionService, AccountExportService],
  exports: [AccountDeletionService],
})
export class AccountModule {}
