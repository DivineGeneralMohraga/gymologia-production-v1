import { HttpException, Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import axios, { AxiosInstance } from 'axios';
import { createHmac, timingSafeEqual } from 'node:crypto';
import { CashfreeConfig } from '../config/configuration';

export interface CreateOrderInput {
  orderId: string;
  amountPaise: number;
  customerId: string;
  customerPhone: string;
  customerName?: string;
  customerEmail?: string;
  returnUrl?: string;
  note?: string;
}

export interface CreatedOrder {
  orderId: string;
  /** Handed to the Cashfree SDK on the device to open the payment sheet. */
  paymentSessionId: string;
}

export interface OrderStatus {
  orderId: string;
  status: string;
  amountPaise: number;
  paymentId?: string;
  method?: string;
}

/**
 * Cashfree Payment Gateway.
 *
 * Two things this service is careful about, because both are how payment
 * integrations lose money:
 *
 *   Amounts cross the wire as rupees with two decimals, but everything on
 *   our side is paise as an integer. The conversion happens here and
 *   nowhere else, so a float never touches a balance.
 *
 *   Webhook signatures are verified against the raw request body, not a
 *   re-serialised object. JSON.stringify does not reproduce byte-for-byte
 *   what was signed, so re-serialising silently fails every signature.
 */
@Injectable()
export class CashfreeService {
  private readonly logger = new Logger(CashfreeService.name);
  private readonly http: AxiosInstance;
  private readonly cfg: CashfreeConfig;

  constructor(private readonly config: ConfigService) {
    this.cfg = this.config.getOrThrow<CashfreeConfig>('cashfree');
    this.http = axios.create({
      baseURL: this.cfg.pgBaseUrl,
      timeout: 20_000,
      headers: {
        'Content-Type': 'application/json',
        'x-api-version': '2023-08-01',
        'x-client-id': this.cfg.clientId,
        'x-client-secret': this.cfg.clientSecret,
      },
    });

    this.logger.log(`Cashfree PG in ${this.cfg.env} mode`);
  }

  get isSandbox(): boolean {
    return this.cfg.env === 'sandbox';
  }

  /** Paise to the rupee string Cashfree expects. */
  private toRupees(paise: number): number {
    return Number((paise / 100).toFixed(2));
  }

  /** Rupees back to paise, rounded so 0.1 + 0.2 style drift cannot survive. */
  private toPaise(rupees: number | string): number {
    return Math.round(Number(rupees) * 100);
  }

  async createOrder(input: CreateOrderInput): Promise<CreatedOrder> {
    try {
      const { data } = await this.http.post<{
        order_id: string;
        payment_session_id: string;
      }>('/orders', {
        order_id: input.orderId,
        order_amount: this.toRupees(input.amountPaise),
        order_currency: 'INR',
        order_note: input.note?.slice(0, 200),
        customer_details: {
          customer_id: input.customerId,
          customer_phone: input.customerPhone.replace(/^\+/, ''),
          ...(input.customerName ? { customer_name: input.customerName } : {}),
          ...(input.customerEmail ? { customer_email: input.customerEmail } : {}),
        },
        ...(input.returnUrl
          ? { order_meta: { return_url: input.returnUrl } }
          : {}),
      });

      if (!data?.payment_session_id) {
        throw new Error('Cashfree returned no payment session');
      }

      return {
        orderId: data.order_id,
        paymentSessionId: data.payment_session_id,
      };
    } catch (error) {
      this.logger.error(`Order creation failed: ${this.describe(error)}`);
      throw new HttpException(
        'Could not start the payment. Please try again.',
        502,
      );
    }
  }

  /**
   * Ask Cashfree what actually happened to an order.
   *
   * This is the authority, not the webhook: a webhook can be missed, and a
   * client saying "payment worked" can be forged. Activation reads from
   * here before it trusts anything.
   */
  async fetchOrder(orderId: string): Promise<OrderStatus> {
    try {
      const { data } = await this.http.get<{
        order_id: string;
        order_status: string;
        order_amount: number;
      }>(`/orders/${orderId}`);

      let paymentId: string | undefined;
      let method: string | undefined;

      if (data.order_status === 'PAID') {
        const { data: payments } = await this.http.get<
          Array<{
            cf_payment_id: string | number;
            payment_status: string;
            payment_group?: string;
          }>
        >(`/orders/${orderId}/payments`);

        const success = payments.find((p) => p.payment_status === 'SUCCESS');
        paymentId = success ? String(success.cf_payment_id) : undefined;
        method = success?.payment_group;
      }

      return {
        orderId: data.order_id,
        status: data.order_status,
        amountPaise: this.toPaise(data.order_amount),
        paymentId,
        method,
      };
    } catch (error) {
      this.logger.error(`Order fetch failed for ${orderId}: ${this.describe(error)}`);
      throw new HttpException(
        'Could not confirm the payment. Please try again.',
        502,
      );
    }
  }

  /**
   * Verify a webhook came from Cashfree.
   *
   * The signature covers `timestamp + rawBody`, HMAC-SHA256 with the
   * client secret, base64. The raw body must be exactly the bytes that
   * arrived — see the note on this class.
   *
   * Returns false rather than throwing, so the caller can log the attempt
   * as a security event and still answer 200; a non-200 makes Cashfree
   * retry a request we already know is forged.
   */
  verifyWebhook(rawBody: Buffer | string, timestamp: string, signature: string): boolean {
    const secret = this.cfg.webhookSecret || this.cfg.clientSecret;
    if (!secret || !timestamp || !signature) return false;

    const payload = timestamp + (Buffer.isBuffer(rawBody) ? rawBody.toString('utf8') : rawBody);
    const expected = createHmac('sha256', secret).update(payload).digest('base64');

    const a = Buffer.from(expected);
    const b = Buffer.from(signature);
    if (a.length !== b.length) return false;
    return timingSafeEqual(a, b);
  }

  private describe(error: unknown): string {
    if (axios.isAxiosError(error)) {
      return JSON.stringify(error.response?.data ?? error.message);
    }
    return (error as Error).message;
  }
}
