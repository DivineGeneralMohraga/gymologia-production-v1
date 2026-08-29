import { Module } from '@nestjs/common';
import { CashfreeService } from './cashfree.service';
import { SubscriptionsService } from './subscriptions.service';
import { SubscriptionsController } from './subscriptions.controller';
import { WebhooksController } from './webhooks.controller';

@Module({
  controllers: [SubscriptionsController, WebhooksController],
  providers: [CashfreeService, SubscriptionsService],
  exports: [SubscriptionsService, CashfreeService],
})
export class PaymentsModule {}
