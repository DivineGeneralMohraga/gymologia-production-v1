import { Module } from '@nestjs/common';
import { CashfreeService } from './cashfree.service';
import { CashfreePayoutsService } from './cashfree-payouts.service';
import { SubscriptionsService } from './subscriptions.service';
import { SubscriptionsController } from './subscriptions.controller';
import { WebhooksController } from './webhooks.controller';

@Module({
  controllers: [SubscriptionsController, WebhooksController],
  providers: [CashfreeService, CashfreePayoutsService, SubscriptionsService],
  exports: [SubscriptionsService, CashfreeService, CashfreePayoutsService],
})
export class PaymentsModule {}
