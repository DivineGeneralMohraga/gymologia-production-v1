import { Module } from '@nestjs/common';
import { MaintenanceService } from './maintenance.service';
import { AccountModule } from '../account/account.module';

// AccountModule supplies the deletion service the daily job calls.
@Module({
  imports: [AccountModule],
  providers: [MaintenanceService],
  exports: [MaintenanceService],
})
export class MaintenanceModule {}
