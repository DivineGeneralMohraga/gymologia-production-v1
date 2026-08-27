import { HttpException, Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import axios, { AxiosInstance } from 'axios';
import { Msg91Config } from '../config/configuration';
import { toMsg91Format } from '../common/utils/phone.util';

interface Msg91Response {
  type?: string;
  message?: string;
  request_id?: string;
}

/**
 * MSG91, in two modes.
 *
 * WIDGET (preferred, and what the previous production build used): MSG91
 * generates, sends and verifies the code under its own DLT-approved
 * template. India requires DLT approval for transactional SMS, and MSG91
 * silently accepts-then-drops sends made without one — so until our own
 * template is approved, this is the only path that reaches a real handset.
 * Requires MSG91_WIDGET_ID and MSG91_WIDGET_TOKEN.
 *
 * DIRECT (fallback): we generate and hash the code ourselves and MSG91 only
 * carries it. More control — our own throttling, attempt counters and audit
 * trail — but it needs a DLT template registered to this account.
 *
 * Mode is chosen by configuration, never per request.
 */
@Injectable()
export class Msg91Service {
  private readonly logger = new Logger(Msg91Service.name);
  private readonly http: AxiosInstance;
  private readonly cfg: Msg91Config;

  constructor(private readonly config: ConfigService) {
    this.cfg = this.config.getOrThrow<Msg91Config>('msg91');
    this.http = axios.create({
      baseURL: 'https://control.msg91.com/api',
      timeout: 15_000,
      headers: { 'Content-Type': 'application/json' },
    });

    this.logger.log(
      `OTP delivery mode: ${this.usesWidgetDelivery ? 'WIDGET' : 'DIRECT'}`,
    );
    if (!this.usesWidgetDelivery) {
      this.logger.warn(
        'DIRECT mode needs a DLT-approved template on this MSG91 account. ' +
          'Without one MSG91 returns success and never delivers. Set ' +
          'MSG91_WIDGET_TOKEN to use the widget instead.',
      );
    }
  }

  /** True when both widget credentials are present. */
  get usesWidgetDelivery(): boolean {
    return Boolean(this.cfg.widgetId && this.cfg.widgetToken);
  }

  get widgetId(): string {
    return this.cfg.widgetId;
  }

  // ── WIDGET mode ────────────────────────────────────────────────────

  /**
   * Ask MSG91 to generate and send a code. Returns its request id, which
   * verifyWidgetOtp must quote back.
   */
  async widgetSendOtp(phoneE164: string): Promise<string> {
    const { data } = await this.call('/v5/widget/sendOtp', {
      widgetId: this.cfg.widgetId,
      tokenAuth: this.cfg.widgetToken,
      identifier: toMsg91Format(phoneE164),
    });

    const requestId = typeof data.message === 'string' ? data.message : '';
    if (!requestId) {
      this.logger.error(
        `MSG91 widget returned no request id: ${JSON.stringify(data)}`,
      );
      throw new HttpException('Could not start verification.', 502);
    }
    return requestId;
  }

  /** Ask MSG91 whether this code matches the one it sent for `requestId`. */
  async widgetVerifyOtp(requestId: string, code: string): Promise<boolean> {
    try {
      const { data } = await this.call('/v5/widget/verifyOtp', {
        widgetId: this.cfg.widgetId,
        tokenAuth: this.cfg.widgetToken,
        reqId: requestId,
        otp: code,
      });
      return `${data.type}`.toLowerCase() === 'success';
    } catch {
      // A wrong code comes back as an error body, not an exception worth
      // surfacing — it is an expected outcome, not a failure of ours.
      return false;
    }
  }

  // ── DIRECT mode ────────────────────────────────────────────────────

  /** Carry a code we generated. Requires our own DLT template. */
  async sendOtp(phoneE164: string, code: string): Promise<void> {
    const mobile = toMsg91Format(phoneE164);
    try {
      const { data } = await this.http.post<Msg91Response>(
        '/v5/otp',
        {},
        {
          params: {
            authkey: this.cfg.authKey,
            mobile,
            otp: code,
            otp_length: this.cfg.otpLength,
            otp_expiry: Math.ceil(this.cfg.otpTtlSeconds / 60),
          },
        },
      );
      if (data?.type && data.type !== 'success') {
        throw new Error(data.message ?? 'MSG91 rejected the request');
      }
    } catch (error) {
      this.logger.error(
        `MSG91 send failed for ...${mobile.slice(-4)}: ${this.describe(error)}`,
      );
      throw new HttpException(
        'Could not send the verification code. Please try again.',
        502,
      );
    }
  }

  // ── Client-driven widget ───────────────────────────────────────────

  /**
   * Verify an access token produced by the MSG91 widget running on the
   * client. Returns the phone number MSG91 confirmed.
   */
  async verifyWidgetToken(accessToken: string): Promise<string | null> {
    try {
      const { data } = await this.call('/v5/widget/verifyAccessToken', {
        authkey: this.cfg.authKey,
        'access-token': accessToken,
      });
      return typeof data.message === 'string' ? data.message : null;
    } catch (error) {
      this.logger.warn(`Widget token verification failed: ${this.describe(error)}`);
      return null;
    }
  }

  // ── Shared ─────────────────────────────────────────────────────────

  /**
   * MSG91 answers HTTP 200 even when it refuses, so the body has to be
   * inspected rather than trusting the status code.
   */
  private async call(
    path: string,
    body: Record<string, unknown>,
  ): Promise<{ data: Msg91Response }> {
    try {
      const response = await this.http.post<Msg91Response>(path, body);
      const data = response.data ?? {};

      if (`${data.type}`.toLowerCase() === 'error') {
        this.logger.error(`MSG91 refused ${path}: ${JSON.stringify(data)}`);
        throw new HttpException(
          typeof data.message === 'string' && data.message
            ? 'Could not send the verification code. Please try again.'
            : 'Verification service unavailable. Please try again.',
          502,
        );
      }
      return { data };
    } catch (error) {
      if (error instanceof HttpException) throw error;
      this.logger.error(`MSG91 ${path} failed: ${this.describe(error)}`);
      throw new HttpException(
        'Could not reach the verification service. Please try again.',
        502,
      );
    }
  }

  /** Vendor errors can carry account identifiers — log them, never return them. */
  private describe(error: unknown): string {
    if (axios.isAxiosError(error)) {
      return JSON.stringify(error.response?.data ?? error.message);
    }
    return (error as Error).message;
  }
}
