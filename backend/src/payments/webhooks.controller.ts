import {
  Controller,
  Headers,
  HttpCode,
  HttpStatus,
  Logger,
  Post,
  Req,
} from '@nestjs/common';
import { ApiExcludeController } from '@nestjs/swagger';
import type { Request } from 'express';
import { CashfreeService } from './cashfree.service';
import { SubscriptionsService } from './subscriptions.service';
import { SecurityEventService } from '../common/security/security-event.service';
import { Public } from '../rbac/rbac.decorators';

interface CashfreeWebhook {
  type?: string;
  data?: {
    order?: { order_id?: string; order_amount?: number; order_status?: string };
    payment?: {
      cf_payment_id?: string | number;
      payment_status?: string;
      payment_amount?: number;
      payment_group?: string;
      payment_message?: string;
    };
  };
}

/**
 * Cashfree calls this when a payment settles.
 *
 * Three rules govern everything here:
 *
 *   Verify before trusting. The signature covers the raw bytes plus the
 *   timestamp header; without it, anyone who guesses this URL can activate
 *   a subscription for free.
 *
 *   Answer 200 even when rejecting. A non-200 makes Cashfree retry, and
 *   retrying a request we have already decided is forged just multiplies
 *   the noise. The rejection goes to security_events instead.
 *
 *   Never trust the amount in the payload. Activation re-checks it against
 *   what the order was created for.
 */
@ApiExcludeController()
@Controller('webhooks/cashfree')
export class WebhooksController {
  private readonly logger = new Logger(WebhooksController.name);

  constructor(
    private readonly cashfree: CashfreeService,
    private readonly subscriptions: SubscriptionsService,
    private readonly securityEvents: SecurityEventService,
  ) {}

  @Public()
  @Post()
  @HttpCode(HttpStatus.OK)
  async handle(
    @Req() req: Request & { rawBody?: Buffer },
    @Headers('x-webhook-signature') signature?: string,
    @Headers('x-webhook-timestamp') timestamp?: string,
  ): Promise<{ received: boolean }> {
    const rawBody = req.rawBody;

    if (!rawBody) {
      // Without the original bytes no signature can be checked, so this is
      // a misconfiguration on our side rather than a bad caller.
      this.logger.error(
        'Webhook arrived without a raw body — rawBody must be enabled in main.ts',
      );
      return { received: true };
    }

    const valid =
      signature != null &&
      timestamp != null &&
      this.cashfree.verifyWebhook(rawBody, timestamp, signature);

    if (!valid) {
      await this.securityEvents.record({
        type: 'WEBHOOK_SIGNATURE_INVALID',
        severity: 'HIGH',
        ip: req.ip,
        route: '/webhooks/cashfree',
        details: {
          hasSignature: signature != null,
          hasTimestamp: timestamp != null,
          bytes: rawBody.length,
        },
        actionTaken: 'ignored; answered 200 so it is not retried',
      });
      return { received: true };
    }

    let body: CashfreeWebhook;
    try {
      body = JSON.parse(rawBody.toString('utf8')) as CashfreeWebhook;
    } catch {
      this.logger.warn('Signed webhook body was not valid JSON');
      return { received: true };
    }

    const orderId = body.data?.order?.order_id;
    if (!orderId) return { received: true };

    const paymentStatus = body.data?.payment?.payment_status;

    if (body.type === 'PAYMENT_SUCCESS_WEBHOOK' || paymentStatus === 'SUCCESS') {
      const paid = body.data?.payment?.payment_amount ?? body.data?.order?.order_amount;

      await this.subscriptions.activate(orderId, {
        paymentId:
          body.data?.payment?.cf_payment_id != null
            ? String(body.data.payment.cf_payment_id)
            : undefined,
        method: body.data?.payment?.payment_group,
        amountPaise: Math.round(Number(paid ?? 0) * 100),
        source: 'webhook',
        raw: body as unknown,
      });
      return { received: true };
    }

    if (
      body.type === 'PAYMENT_FAILED_WEBHOOK' ||
      paymentStatus === 'FAILED' ||
      paymentStatus === 'USER_DROPPED'
    ) {
      await this.subscriptions.markFailed(
        orderId,
        body.data?.payment?.payment_message ?? paymentStatus ?? 'Payment failed',
      );
    }

    return { received: true };
  }
}
