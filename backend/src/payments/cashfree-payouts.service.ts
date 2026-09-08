import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import axios, { AxiosInstance } from 'axios';

import { CashfreeConfig } from '../config/configuration';

export interface BeneficiaryInput {
  /** Stable per referral account, so the same person is one beneficiary. */
  beneficiaryId: string;
  name: string;
  vpa: string;
  phone: string;
  email?: string | null;
}

export interface TransferInput {
  /** Our payout's idempotency key. Cashfree rejects a repeat of this. */
  transferId: string;
  beneficiaryId: string;
  amountPaise: number;
  remarks?: string;
}

export type TransferOutcome =
  | { state: 'SUCCESS'; referenceId: string | null; utr: string | null }
  | { state: 'PENDING'; referenceId: string | null }
  | { state: 'FAILED'; reason: string };

/**
 * Sending money out, as opposed to taking it in.
 *
 * A separate client from `CashfreeService` on purpose, and not just for
 * tidiness: Payouts is a different product with **different credentials, a
 * different base URL and a different API version**. Sharing one axios
 * instance would mean one wrong header sends a transfer request signed with
 * the payment-gateway key, which fails in a way that reads like a
 * configuration problem rather than a mix-up.
 *
 * ## Refuses rather than pretends
 *
 * `isConfigured` is false when either payout credential is missing, and
 * every method throws rather than returning a hopeful default. A payouts
 * client that quietly no-ops is worse than none: the payout row would move
 * to SUCCESS having sent nothing, and the first person to notice would be
 * a referrer who never got their money.
 *
 * ## Amounts
 *
 * Cashfree takes rupees with two decimal places; everything in this
 * codebase is an integer number of paise. The conversion happens here and
 * nowhere else, so a float never touches a balance.
 */
@Injectable()
export class CashfreePayoutsService {
  private readonly logger = new Logger(CashfreePayoutsService.name);
  private readonly cfg: CashfreeConfig;
  private readonly http: AxiosInstance;

  constructor(private readonly config: ConfigService) {
    this.cfg = this.config.getOrThrow<CashfreeConfig>('cashfree');
    this.http = axios.create({
      baseURL: this.cfg.payoutBaseUrl,
      timeout: 30_000,
      headers: {
        'Content-Type': 'application/json',
        'x-api-version': '2024-01-01',
        'x-client-id': this.cfg.payoutClientId,
        'x-client-secret': this.cfg.payoutClientSecret,
      },
      // 4xx is data, not an exception: Cashfree explains a refusal in the
      // body and that explanation is what a referrer needs to be told.
      validateStatus: (s) => s < 500,
    });

    if (this.isConfigured) {
      this.logger.log(`Cashfree Payouts in ${this.cfg.env} mode`);
    } else {
      this.logger.warn(
        'Cashfree Payouts is NOT configured: withdrawals will be recorded and held, not sent',
      );
    }
  }

  get isConfigured(): boolean {
    return Boolean(this.cfg.payoutClientId && this.cfg.payoutClientSecret);
  }

  private assertConfigured(): void {
    if (!this.isConfigured) {
      throw new Error(
        'Cashfree Payouts credentials are not set (CASHFREE_PAYOUT_CLIENT_ID / _SECRET)',
      );
    }
  }

  /** Rupees, to two places, from an integer number of paise. */
  private toRupees(paise: number): number {
    return Number((paise / 100).toFixed(2));
  }

  /**
   * Register the destination, or accept that it is already registered.
   *
   * An id that already exists comes back as a 409 with
   * `beneficiary_id_already_exists`, and that is a success for our purpose:
   * the beneficiary id is derived from the referral account, so a repeat
   * means this person has been paid before. Treating it as a failure would
   * make every second withdrawal fail.
   */
  async ensureBeneficiary(input: BeneficiaryInput): Promise<void> {
    this.assertConfigured();

    const res = await this.http.post('/beneficiary', {
      beneficiary_id: input.beneficiaryId,
      beneficiary_name: input.name,
      beneficiary_instrument_details: { vpa: input.vpa },
      beneficiary_contact_details: {
        beneficiary_phone: input.phone.replace(/^\+91/, ''),
        ...(input.email ? { beneficiary_email: input.email } : {}),
      },
    });

    if (res.status >= 200 && res.status < 300) return;

    const code = String(
      (res.data as { code?: string; type?: string })?.code ?? '',
    );
    if (res.status === 409 || code.includes('already_exists')) {
      this.logger.debug(`Beneficiary ${input.beneficiaryId} already registered`);
      return;
    }

    throw new Error(`Beneficiary rejected: ${this.describe(res.data)}`);
  }

  /**
   * Send it.
   *
   * `transfer_id` is our idempotency key, so a retry of the same payout can
   * never send twice -- Cashfree refuses a repeated id, and that refusal is
   * reported as PENDING rather than FAILED so the status check below
   * decides what actually happened. Treating a duplicate as a failure would
   * be the one mistake that costs somebody their money twice.
   */
  async transfer(input: TransferInput): Promise<TransferOutcome> {
    this.assertConfigured();

    const res = await this.http.post('/transfers', {
      transfer_id: input.transferId,
      transfer_amount: this.toRupees(input.amountPaise),
      transfer_currency: 'INR',
      transfer_mode: 'upi',
      beneficiary_details: { beneficiary_id: input.beneficiaryId },
      ...(input.remarks ? { transfer_remarks: input.remarks } : {}),
    });

    const body = res.data as {
      status?: string;
      cf_transfer_id?: string | number;
      transfer_utr?: string;
      code?: string;
      message?: string;
    };

    if (res.status >= 200 && res.status < 300) {
      return this.readState(body);
    }

    // A repeated transfer id means this exact payout was already sent. Ask
    // what happened to it rather than guessing.
    if (String(body?.code ?? '').includes('already_exists')) {
      this.logger.warn(
        `Transfer ${input.transferId} was already submitted; reading its status`,
      );
      return { state: 'PENDING', referenceId: null };
    }

    return { state: 'FAILED', reason: this.describe(res.data) };
  }

  /** What happened to a transfer we already submitted. */
  async getTransfer(transferId: string): Promise<TransferOutcome> {
    this.assertConfigured();

    const res = await this.http.get('/transfers', {
      params: { transfer_id: transferId },
    });

    if (res.status >= 200 && res.status < 300) {
      return this.readState(res.data as Record<string, unknown>);
    }
    return { state: 'FAILED', reason: this.describe(res.data) };
  }

  /**
   * Cashfree's status vocabulary, reduced to the three outcomes that
   * change what we do.
   *
   * Anything unrecognised is PENDING, never SUCCESS. Guessing optimistically
   * about a word we do not know would mark a payout paid on the strength of
   * a status nobody has read.
   */
  private readState(body: Record<string, unknown>): TransferOutcome {
    const status = String(body?.['status'] ?? '').toUpperCase();
    const reference =
      body?.['cf_transfer_id'] != null ? String(body['cf_transfer_id']) : null;
    const utr =
      body?.['transfer_utr'] != null ? String(body['transfer_utr']) : null;

    if (status === 'SUCCESS' || status === 'COMPLETED') {
      return { state: 'SUCCESS', referenceId: reference, utr };
    }
    if (status === 'FAILED' || status === 'REJECTED' || status === 'ERROR') {
      return {
        state: 'FAILED',
        reason: String(body?.['status_description'] ?? body?.['message'] ?? status),
      };
    }
    return { state: 'PENDING', referenceId: reference };
  }

  private describe(data: unknown): string {
    if (data && typeof data === 'object') {
      const d = data as { message?: string; code?: string };
      if (d.message) return `${d.code ? d.code + ': ' : ''}${d.message}`;
      return JSON.stringify(data).slice(0, 400);
    }
    return String(data).slice(0, 400);
  }
}
