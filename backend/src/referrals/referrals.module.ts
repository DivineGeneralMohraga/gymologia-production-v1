import { Module } from '@nestjs/common';

import { ReferralsController } from './referrals.controller';
import { ReferralsService } from './referrals.service';
import { WithdrawalsService } from './withdrawals.service';

@Module({
  controllers: [ReferralsController],
  providers: [ReferralsService, WithdrawalsService],
  exports: [ReferralsService],
})
export class ReferralsModule {}
