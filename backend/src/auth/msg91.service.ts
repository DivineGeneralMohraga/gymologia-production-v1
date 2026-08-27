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
 * Delivery only.
 *
 * Gymologia generates, hashes, stores and verifies its own OTP codes —
 * see OtpService. MSG91 is the transport that carries the code to the
 * handset, nothing more. Keeping verification on our side means we own
 * the throttling, the attempt counter and the audit trail, instead of
 * inheriting whatever the vendor decides.
 *
 * The widget token path is also supported for clients that use MSG91's
 * drop-in OTP widget; there the vendor does verify, and we confirm the
 * resulting access token server-side before trusting the phone number.
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
      timeout: 10_000,
      headers: { 'Content-Type': 'application/json' },
    });
  }

  /**
   * Send a specific code to a number. MSG91's v5 OTP endpoint accepts an
   * explicit `otp` parameter, which is what lets us keep generation local.
   */
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
      // Never leak the vendor's error text to the caller — it can contain
      // account identifiers. Log it, return something generic.
      const detail = axios.isAxiosError(error)
        ? JSON.stringify(error.response?.data ?? error.message)
        : (error as Error).message;
      this.logger.error(`MSG91 send failed for ${mobile.slice(-4)}: ${detail}`);
      throw new HttpException(
        'Could not send the verification code. Please try again.',
        502,
      );
    }
  }

  /**
   * Verify an access token produced by the MSG91 OTP widget. Returns the
   * phone number the vendor confirmed, so the caller can match it against
   * what the client claims.
   */
  async verifyWidgetToken(accessToken: string): Promise<string | null> {
    try {
      const { data } = await this.http.post<Msg91Response & { message?: string }>(
        '/v5/widget/verifyAccessToken',
        {
          authkey: this.cfg.authKey,
          'access-token': accessToken,
        },
      );

      if (data?.type !== 'success') return null;
      // MSG91 returns the verified identifier in `message`.
      return typeof data.message === 'string' ? data.message : null;
    } catch (error) {
      const detail = axios.isAxiosError(error)
        ? JSON.stringify(error.response?.data ?? error.message)
        : (error as Error).message;
      this.logger.warn(`MSG91 widget verification failed: ${detail}`);
      return null;
    }
  }

  get widgetId(): string {
    return this.cfg.widgetId;
  }
}
