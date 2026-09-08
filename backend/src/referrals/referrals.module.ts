import { Module } from '@nestjs/common';

import { AdminModule } from '../admin/admin.module';
import { PaymentsModule } from '../payments/payments.module';

import { ReferralsController } from './referrals.controller';
import { ReferralsService } from './referrals.service';
import { WithdrawalsService } from './withdrawals.service';
import { PayoutRunnerService } from './payout-runner.service';
import { PayoutsAdminController } from './payouts-admin.controller';

@Module({
  // AdminModule for the guard the payout desk sits behind.
  imports: [PaymentsModule, AdminModule],
  controllers: [ReferralsController, PayoutsAdminController],
  providers: [ReferralsService, WithdrawalsService, PayoutRunnerService],
  exports: [ReferralsService, PayoutRunnerService],
})
export class ReferralsModule {}
